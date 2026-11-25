#import "@preview/clean-dhbw:0.6.0": *


= OTA-Updates <ch:ota-updates>

@ch:angriffsflächen[Kapitel] hat gezeigt, dass der Update-Mechanismus eines Fahrzeugs zugleich Angriffsziel und Schutzmaßnahme ist. In mehreren der beschriebenen Fälle führte der Weg ins Bordnetz über eine Software-Aktualisierung ohne wirksame Prüfung. Behoben wurden die Schwachstellen ebenfalls über Software-Updates. Dieses Kapitel beschreibt, wie solche Updates aufgebaut sind, auf welchen Wegen sie in das Fahrzeug gelangen und durch welche Verfahren sie abgesichert werden.

Zunächst werden die Begriffe geklärt und die Arten von Updates unterschieden. Anschließend folgen die Kommunikationswege, die Architektur der beteiligten Systeme und der Ablauf eines Updates von der Freigabe bis zu Aktivierung im Fahrzeug. Die darauf folgenden Abschnitte behandeln die Absicherung. Dazu gehören die Authentifizierung der Verbindung, die Prüfung der Update-Pakete, das Framework Uptane und die Schutzmechanismen im Fahrzeug. Den Abschluss bilden die regulatorischen Vorgaben

Die Beschreibung in diesem Kapitel stützt sich auf Regelwerke, Normen und offene Spezifikationen, vor allem auf die UN-Regelung Nr.~156, die Spezifikationen von #gls("AUTOSAR") und den Uptane-Standard. Sie beschreibt typische Abläufe und nicht die Umsetzung eines bestimmten Herstellers. Ziel des Kapitels ist es festzuhalten, welche Prüfungen ein Update durchläuft und was diese Prüfungen jeweils belegen. Auf dieser Grundlage untersucht @ch:supply-chain[Kapitel], an welchen Stellen Schadcode trotz dieser Prüfungen eingebracht werden kann.


== Begriffe und Arten <sec:ota-begriffe>

=== Softwareaktualisierung nach der UN-Regelung Nr.~156

Für die Begriffe dieser Arbeit ist die UN-Regelung Nr.~156 maßgeblich, da sie über die europäische Typgenehmigung verbindlich ist. Die Regelung definiert Software als den Teil eines Steuergeräts, der aus digitalen Daten und Befehlen besteht. Eine Softwareaktualisierung ist ein Paket, mit dem Software auf eine neue Version gebracht wird. Ausdrücklich eingeschlossen sind Änderungen von Konfigurationsparametern @unece2021r156[Abs. ~2.3, 2.8]. Das Installieren und Aktivieren eine heruntergeladenen Updates bezeichnet die Regelung als Durchführung @unece2021r156[Abs.~2.4].

Als Over-the-Air-Aktualisierung gilt jedes Verfahren, bei dem Daten drahtlos statt über ein Kabel oder eine andere lokale Verbindung übertragen werden @unece2021r156[Abs.~2.9]. Die allgemeinen Anforderungen der Regelung gelten als unabhängig vom Übertragungsweg. Für drahtlose Updates kommen in eigenen Absätzen weitere Anforderungen hinzu @unece2021r156[Abs.~7.1.4, 7.2.2]. Ein Update, das in der Werkstatt per Diagnosegerät eingespielt wird, ist damit ebenfalls eine Softwareaktualisierung im Sinne der Regelung.

Aus der Definition folgt, dass bereits das Ändern eines einzelnen Parameters eine Softwareaktualisierung ist. Das betrifft insbesondere Funktionen, deren Hardware ab Werk verbaut ist und die erst per Software freigeschaltet werden. Ein Beispiel ist das Angebot "Acceleration Increase" von Mercedes-Benz in den USA. Gegen ein Entgelt von 1.200~US-Dollar pro Jahr steigt bei vier Elektromodellen die Antriebsleistung. Beim EQE~350 etwa von 215 auf 260~kW @electrive2022mercedes. Ein Eingriff in die Hardware ist dafür nicht nötig, da die Fahrzeuge ab Werk über diese Leistung verfügen und sie lediglich in der Software freigeschaltet wird @t3n2022mercedes. In Deutschland bietet der Hersteller die Leistungssteigerung nach Angaben eines Sprechers aus regulatorischen Gründen nicht an. Eine Leistungssteigerung gilt hier als verbrauchsrelevante Änderung, die abnahmepflichtig und steuerlich relevant sein kann @electrive2022mercedes. Die UN-Regelung Nr.~156 verlangt entsprechend, dass der Hersteller für jedes Update bewertet und dokumentiert, ob es typgenehmigte Systeme oder gesetzlich festgelegte Funktionen und Parameter verändert @unece2021r156[Abs.~7.1.1.8, 7.1.1.9].

=== Abgrenzung zur Aktualisierung in der Werkstatt

Vor der Einführung von OTA-Updates wurde die Software von Steuergeräten überwiegend in der Werkstatt aktualisiert. Ein Mechaniker verbindet das Fahrzeug dazu mit einem Werkzeug, das über das Bordnetz das Zielsteuergerät erreicht und dessen Software neu programmiert @halder2020ota. Technisch geschieht dies über den Bootloader und die Diagnoseprotokolle, die @sec:ee-architektur und @sec:diagnose beschreiben @autosar2023fota @iso14229-1. #cite(form: "prose", <halder2020ota>) bezeichnen dieses Verfahren als zeit- und ressourcenaufwendig. Es verursacht Arbeitskosten und führt zu Unzufriedenheit bei den Kunden @halder2020ota. Hinzu kommt, dass das Steuergerät während der gesamten Programmierung nicht betriebsbereit ist. Müssen mehrere Steuergeräte aktualisiert werden, verlängert sich die Standzeit, des Fahrzeugs entsprechend @autosar2023fota. Nach einer von #cite(form: "prose", <halder2020ota>) zitierten Schätzung von IHS Automotive sollten die Einsparungen der Hersteller durch OTA-Updates von 2,7~Milliarden US-Dollar im Jahr 2015 auf über 35~Milliarden US-Dollar im Jahr 2022 steigen.

Wie groß der Unterschied in der Praxis ausfallen kann, zeigen zwei Rückrufe. Nach dem Angriff von #cite(form: "prose", <miller2015remote>) rief der Hersteller rund 1,4~Millionen Fahrzeuge zurück @nhtsa2015recall.  #cite(form: "prose", <kuppusamy2018uptane>) führen den Umfang dieses Rückrufs darauf zurück, dass die Fahrzeuge keine OTA-Updates empfangen konnten. Im Dezember 2023 meldete Tesla der US-Verkehrssicherheitsbehörde #gls("NHTSA") einen Rückruf für 2.031.220 Fahrzeuge. Betroffen war die Funktion Autosteer, die zum Assistenzpaket Autopilot der Stufe~2 nach SAE~J3016 gehört. Ihre Kontrollen reichten nicht aus, um einen Fehlgebrauch durch die Fahrenden zu verhindern. Die Abhilfe bestand in einem kostenlosen OTA-Update auf die Softwareversion 2023.40.30, dessen Verteilung ab dem 12.~Dezember~2023 beginnen sollte @nhtsa2023recall23v838. Der Rückruf betraf damit ein Assistenzsystem, das selbstständig lenkt und wurde vollständig über Software behoben.

=== Arten von Updates

Updates lassen sich nach mehreren Merkmalen unterscheiden @tab:ota-arten fasst die Unterscheidungen zusammen, die für diese Arbeit von Bedeutung sind.

#figure(
  caption: [Arten von Updates (eigene Darstellung nach @autosar2025ucm @autosar2023fota @halder2020ota @belu2022delta @unece2021r156)],
  dhbw-table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    table.header([*Merkmal*], [*Ausprägungen*], [*Bedeutung für die Sicherheitsbetrachtung*]),
    [Inhalt], [Anwendungssoftware, Betriebssystem oder Firmware, Konfigurations- und Kalibrierdaten], [auch eine reine Datenänderung kann das Verhalten eines Steuergeräts verändern],
    [Zielsystem], [Infotainment und Karten, Steuergeräte mit Fahrzeugfunktionen], [Updates sicherheitsrelevanter Steuergeräte wirken unmittelbar auf Antrieb, Bremse oder Lenkung],
    [Umfang], [vollständiges Software-Abbild, Teil- oder Delta-Update], [ein Delta-Update setzt eine bestimmte installierte Vorversion voraus],
    [Zweck], [Fehlerbehebung, Schließen von Sicherheitslücken, Rückruf, neue oder freigeschaltete Funktion], [der Nutzer muss vor einem drahtlosen Update über den Zweck informiert werden können],
    [Übertragungsweg], [drahtlos oder lokal in der Werkstatt], [für drahtlose Updates gelten zusätzliche Anforderungen der UN-Regelung Nr.~156],
  ),
) <tab:ota-arten>

*Inhalt.* Ein Software-Pakte kann nach der AUTOSAR-Spezifikation ausführbare Anwendungen, Aktualisierungen des Betriebssystemkerns oder der Firmware, sowie Konfigurations- und Kalibrierdaten enthalten @autosar2025ucm. Für die Sicherheitsbetrachtung ist diese Unterscheidung von Bedeutung, weil auch eine reine Datenänderung das Verhalten eines Steuergeräts verändern kann. @sec:sensoren hat dies am Beispiel der Kalibrierwerte von Sensoren gezeigt. Ein um ein Grad verdrehter Sensor verschiebt ein Objekt in 100~m Entfernung rechnerisch um 1,75~m.

*Zielsystem.* In der Literatur werden teilweise Software-over-the-Air, kurz #gls("SOTA") und Firmware-over-the-Air, kurz #gls("FOTA"), unterschieden. AUTOSAR verwendet den Begriff FOTA für Steuergeräte, deren neue Software im Hintergrund programmiert wird, während bisherige Software weiterläuft @autosar2023fota. #cite(form: "prose", <kuppusamy2018uptane>) sprechen dagegen allgemein von SOTA-Updates. Diese Arbeit verwendet OTA-Update als Oberbegriff für beide Formen. Zum Zeitpunkt der Untersuchung von #cite(form: "prose", <halder2020ota>) boten nach deren Angaben nur Tesla, BMW, Mercedes-Benz, Audi und General Motors OTA-Updates an. Abgesehen von Tesla beschränkten sich diese auf Karten, Navigation und Infotainment. Der Rückruf von 2023 zeigt, dass inzwischen auch Assistenzsysteme mit Eingriff in die Lenkung per OTA verändert werden @nhtsa2023recall23v838.

*Umfang.* Ein Update kann das vollständige Software-Abbild eines Steuergeräts enthalten oder nur die Unterschiede zur installierten Version. Beim zweiten Verfahren, der Delta-Kodierung, werden ausschließlich die Daten übertragen, die sich zwischen zwei Versionen geändert haben @belu2022delta. In den Versuchen von #cite(form: "prose", <belu2022delta>) waren die so erzeigten Delta-Dateien in allen untersuchten Fällen kleiner, als eine mit ZIP komprimierte Datei derselben Daten. AUTOSAR sieht Teil- und inkrementelle Aktualisierungen ebenfalls vor, sofern das Installationsverfahren des Steuergeräts sie unterstützt @autosar2023fota. Ein Delta-Update lässt sich nur auf genau die Vorversion anwenden, aus der es berechnet wurde. Die UN-Regelung Nr.~156 verlangt deshalb vom Hersteller, vor der Veröffentlichung eines Updates dessen Verträglichkeit mit der zuletzt bekannten Software- und Hardwarekonfiguration der Zielfahrzeuge zu bestätigen @unece2021r156[Abs.~7.1.1.7].

*Zweck.* Updates beheben Fehler, schließen Sicherheitslücken, setzen Rückrufe um oder fügen Funktionen hinzu. Vor einem drahtlosen Update muss der Nutzer über dessen Zweck informiert werden können. Dazu gehören die Angabe, wie dringlich das Update ist und ob es einen Rückruf, der Verkehrssicherheit oder der Cybersicherheit dient @unece2021r156[Abs.~7.2.2.2]


== Kommunikationswege <sec:ota-kommunikation>

Auf de Weg von Hersteller zum Steuergerät durchläuft ei Update zwei Abschnitte: die Übertragung bis in das Fahrzeug und die Verteilung innerhalb des Fahrzeugs. Für den ersten Abschnitt stehen drahtlose Verbindugnen und der Zugang in der Werkstatt zur Verfügung. Jeder dieser Wege gehört zu den Schnittstellen, die @ch:angriffsflächen[Kapitel] als Angriffsfläche beschrieben hat.

=== Mobilfunk

Der übliche Weg für OTA-Updates ist die Mobilfunkverbindung des Telematiksteuergeräts. Das von #cite(form: "prose", <halder2020ota>) beschriebene Grundmuster sieht vor, dass die #gls("TCU") das Update-Paket vom Server herunterlädt, prüft und an die zuständigen Steuergerät verteilt. Wie @sec:telematik gezeigt hat, verfügt jeder Pkw eines seit dem 31.~März~2018 neu genehmigten Typs über eine Mobilfunkeinheit für den eCall @eu2015ecall. Die Hersteller in der Untersuchung von #cite(form: "prose", <halder2020ota>) nutzten zum damaligen Zeitpunkt überwiegend 3G-Mobilfunk.

Die Betriebsanleitung eines aktuellen Kia-Elektrofahrzeugs zeigt, wie dieser Weg in der Praxis genutzt wird. Die neue Software wird danach automatisch während der Fahrt heruntergeladen. Installiert wird sie erst nach Zustimmung des Fahrers und unter weiteren Voraussetzungen, die @sec:ota-ablauf beschreibt. Für eine sicherer Installation muss das Fahrzeug ein Mobilfunksignal mit einer Signalstärke über -82~dBm empfangen @kia2027ota.

Der Mobilfunk erlaubt es, jedes Fahrzeug einer Serie ohne Werkstattbesuch zu erreichen. Diese Reichweite macht ihn zugleich zum Angriffsweg. @sec:telematik hat dargestellt, dass sich das Telematiksystem eines Tesla mit einer gefälschte Basisstation verbinden ließ und SMS unbemerkt eingeschleust werden konnten @bitsikas2026lte. Bei vier BMW-Modellen ließ sich der Datenverkehr zwischen Fahrzeug und Telematikdienst über eine gefälschte Basisstation abfangen @keenlab2018bmw. Die Mobilfunkverbindung kann deshalb nicht als vertrauenswürdig vorausgesetzt werden. Der Schutz eines Updates muss an der Verbindung selbst und an den übertragenen Daten ansetzen. @sec:ota-authentifizierung und @sec:ota-verifikation beschreiben beide Ebenen

=== WLAN

Als Alternative zum Mobilfunk können Updates über ein WLAN übertragen werden, etwa im heimischen Netz des Halters. Tesla bot in der Untersuchung von #cite(form: "prose", <halder2020ota>) für das Model~S neben Mobilfunk auch WLAN an. Aach diese Verbindung ist eine Angriffsfläche. Beim Angriff des Keen Security Lab auf ein Tesla Model~S verbanden sich die Fahrzeuge automatisch mit einem bekannten WLAN–Namen. Ein Angreifer konnte so einen eigenen Zugangspunkt bereitstellen und den Browser des Infotainmentsystems auf ein präparierte Webseite leiten @nie2017freefall.

=== Werkstatt und lokale Schnittstellen

Neben den drahtlosen Wegen bleibt die Werkstatt ein Verteilweg für Updates. Dort wird die Software über ein Diangosegerät an der OBD-Buchse mit den Diangoseprotokollen UDS und DoIP eingespielt. Einzelne Hersteller nutzten nach #cite(form: "prose", <halder2020ota>) auch USB-Sticks, die in der Werkstatt angeschlossen werden. Im Fall der vier BMW-Modelle wurden weitere Software-Updates über die Vertragswerkstätten angeboten @keenlab2018bmw. Die UN-Regelung Nr.~155 nennt die Kompromittierung lokaler oder physischer Update-Verfahren ausdrücklich als Bedrohung @unece2025r155[Anhang~5, Nr.~12.2]. Wie @sec:obd2 gezeigt hat, ließen sich Werkstatttester manipulieren und als Verteilweg für Schadcode nutzen @checkoway2011comprehensive.

Lokaler und drahtloser Zugang können sich in der Praxis gegenseitig beeinflussen. In der Betriebsanleitung des Kia-Fahrzeugs heißt es etwa, dass ein an der OBD-Buchse angeschlossenes Diagnosegerät oder ein Nachrüstegerät ein OTA-Update verhindert. Es muss entfernt und das Fahrzeug neu gestartet werden @kia2027ota

=== Verteilung im Fahrzeug

Innerhalb des Fahrzeugs gelangt das Update über die Bussysteme zu den Steuergeräten. Die AUTOSAR-Spezifikation für die fahrzeugweite Update-Koordination sieht für Steuergeräte der Classic Platform einen sogenannten Flashing Adapter vor. Dieser spricht die Steuergeräte über die Diagnoseprotokolle an, entweder als UDS über CAN oder als UDS über IP @autosar2025vucm. Im Fahrzeug werden damit dieselben Diagnosedienste genutzt wie in der Werkstatt. Der Unterschied besteht darin, dass der Tester kein externe Gerät mehr ist, sondern eine Softwarekomponente im Fahrzeug selbst. Die Datenrate des Bussystems begrenzt, wie schnell ein Steuergerät programmiert werden kann. Ein klassicher CAN-Bus überträgt bis zu 1~Mbit/s. Für ein angenommenes Software-Abbild von 4~MB, das entspricht 32~Mbit, ergibt sich daraus eine Übertragungsdauer  von mindestens 32~s, ohne den Protokoll-Overhead zu berücksichtigen. Über Automotive Ethernet mit 100~Mbit/s sinkt dieser rechnerische Wert auf 0,32~s. Diese Abschätzung erklärt, weshalb Delta-Updates un schnellere Bordnetze die Dauer eines Updates verkürzen.

Für die Sicherheitsbetrachtung ist entscheidend dass die Komponente, die Updates im Fahrzeug verteilt, andere Steuergeräte neu programmieren darf. #cite(form: "prose", <halder2020ota>) bezeichnen das zentrale Gateway deshalb als anfälliger für Angriffe. Die Fallbeispiele in  @sec:angriffsflaechen-fallbeispiele bestätigen dies. Bei Tesla führte der Weg ins Bordnetz über den Update-Prozess des Gateways @nie2017freefall, beim Jeep über die Neuprogrammierung des CAN–Controllers @miller2015remote.



== Architektur <sec:ota-architektur>

=== Komponenten

An einem OTA-Update sind Systeme außerhalb und innerhalb des Fahrzeugs beteiligt. @fig:ota-architektur zeigt den Weg der Software vom Zulieferer bis zum Ziel-Steuergerät in vereinfachter Form.

#figure(
  caption: [Vereinfachter Weg eines OTA-Updates vom Zulieferer bis zum Ziel-Steuergerät (eigene Darstellung nach @kuppusamy2017login @halder2020ota @autosar2025vucm @uptane2025standard)],
  {
    set text(size: 8pt, hyphenate: false)
    set par(justify: false, leading: 0.45em, spacing: 0.6em)
    let kasten(titel, inhalt, farbe) = block(
      fill: farbe,
      stroke: 0.5pt + luma(120),
      inset: (x: 5pt, y: 9pt),
      radius: 2pt,
      width: 100%,
      height: 2.2cm,
    )[
      #set align(top)
      #align(center)[*#titel*]
      #v(6pt)
      #align(center)[#inhalt]
    ]
    let pfeil(beschriftung) = align(center + horizon, stack(
      spacing: 4pt,
      text(size: 13pt)[→],
      text(size: 6.5pt, fill: luma(80))[#beschriftung],
    ))
    grid(
      columns: (1fr, 1.5cm, 1fr, 1.5cm, 1fr, 1.5cm, 1fr),
      align: horizon,
      kasten("Zulieferer", [Entwicklung und Build der Software], luma(235)),
      pfeil([Übergabe]),
      kasten("OEM-Backend", [Integration, Test, Signatur, Kampagnen], rgb("#dbe8f5")),
      pfeil([Mobilfunk, WLAN]),
      kasten("Update-Master", [OTA-Client, Prüfung, Verteilung], rgb("#c4d9ee")),
      pfeil([CAN, Ethernet \ (UDS)]),
      kasten("Ziel-Steuergerät", [Installation, Aktivierung, Versionsbericht], rgb("#e8f0e0")),
    )
  },
) <fig:ota-architektur>

Auf der Seite des Herstellers steht ein Backend, das die Software-Abbilder vorhält und festlegt, welches Fahrzeug welches Update erhält. Dafür benötigt es Informationen über den Softwarestand jedes Fahrzeugs. Die UN-Regelung Nr.~156 verlangt vom Hersteller, jede Software- und relevante Hardwareverion eindeutig zu identifiezieren und die Zielfahrzeuge eines Updates zu bestimmen @unece2021r156[Abs.~7.1.1.2, 7.1.1.6]. Im Uptane-Standard greift das sogenannte Director-Repository dafür auf eine Inventardatenbank zu. Es erhält von den Fahrzeugen Berichte über die installierten Versionen @uptane2025standard. Nach AUTOSAR stellt das Backend für jede Kampagne ein Fahrzeugpaket zusammen. Dieses beschreibt die enthaltenen Software-Pakete, die Hinweise an den Fahrer, die Sicherheitsbedingungen für die Durchführung und die Gruppierung der Übertragungen und Aktivierungen.

Im Fahrzeug übernimmt ein OTA-Client die Verbindung zum Backend und wickelt dessen Protokoll ab. Updates können nach festem Zeitplan vom Fahrzeug abgerufen oder vom Backend angestoßen werden. Die Koordination im Fahrzeug übernimmt eine zentrale Instanz, die in dieser Arbeit als Update-Master bezeichnet wird. Sie verteilt die Pakete an die Ziel-Steuergeräte, stimmt sich mit einer Komponente ab, die den Fahrzeugzustand meldet und holt über die Bedienoberfläche die Zustimmung des Fahrers ein  @autosar2025vucm. In den Normen und Spezifikationen tragen diese Komponenten unterschiedliche Namen. @tab:ota-begriffe stellt sie gegenüber. 

#figure(
  caption: [Bezeichnungen der Komponenten in AUTOSAR und Uptane (eigene Darstellung nach @autosar2025vucm @autosar2025ucm @autosar2023fota @uptane2025standard)],
  dhbw-table(
    columns: (1fr, auto, 1fr, 1fr),
    align: (left, left, left, left),
    table.header([*Aufgabe*], [*Diese Arbeit*], [*AUTOSAR*], [*Uptane*]),
    [Bereitstellung der Software-Abbilder], [Backend], [OEM-Backend], [Image-Repository],
    [Fahrzeugspezifische Auswahl der Updates], [Backend], [OEM-Backend (Fahrzeugpaket)], [Director-Repository],
    [Verbindung zum Backend], [OTA-Client], [OTA Client], [Teil des Primary],
    [Koordination im Fahrzeug], [Update-Master], [#gls("VUCM"), bei Classic-Steuergeräten FOTA Master], [Primary],
    [Zu aktualisierendes Steuergerät], [Ziel-Steuergerät], [#gls("UCM") (Adaptive Platform), FOTA Target (Classic Platform)], [Secondary],
  ),
) <tab:ota-begriffe>

=== Update-Master als zentrale Instanz

Der Update-Master ist die Stelle im Fahrzeug, an der ein Update erstmals geprüft wird. NAch dem Uptane-Standard lädt der Primary Zeitinformationen, Metadaten und Software-Abbilder herunter, prüft sie und verteilt sie an die übrigen Steuergeräte. Er muss dabei die vollständige Prüfung durchführen, die @sec:uptane beschreibt @uptane2025standard. Auch nach dem FOTA-Konzept von AUTOSAR übernimmt der Master die erste Prüfung von Authentizität und Integrität. Eine erneute Prüfung auf dem Ziel-Steuergerät ist dort optional @autosar2023fota. verzichtet ein Ziel-Steuergerät auf eine eigene Prüfung, vertraut es der Prüfung durch den Update-Master. Ein kompromittierter Update-Master kann ihm dann beliebige Software übergeben. Uptane verlangt deshalb, dass jedes Secondary mindestens eine Teilprüfung selbst durchführt @uptane2025standard.

In welchem Steuergerät der Update-Master liegt, legt der Hersteller fest. #cite(form: "prose", <halder2020ota>) beschreiben den TCU als ladende und verteilende Instanz und stellen zugleich Ansätze vor, bei denen ein Gateway-Steuergerät diese Aufgabe übernimmt. In zonalen Architekturen mit zentralen Hochleistungsrechnern läuft auf jedem Rechner der Adaptive Plattform eine UCM-Instanz, die dort Software installiert, aktualisiert und entfernt @autosar2025ucm. Pro Netzwerkdomäne darf zu einem Zeitpunkt nur eine V-UCM ihre Dienste anbieten @autosar2025vucm. @sec:ee-architektur hat bereits beschrieben, dass ein manipuliertes Softwarepaket auf einem Zentralrechner mehrere sicherheitsrelevante Funktionen zugleich beeinflussen kann @jiang2024sdv. Für den Update-Prozess bedeutet dies, dass ein einzelnes Paket für einen Zentralrechner einen größeren Teil der Fahrzeugfunktionen verändern kann, als ein Paket für ein Einzelfunktionsgerät.



== Ablauf eines Updates <sec:ota-ablauf>

Ein OTA-Update durchläuft mehrere Phasen, an denen unterschiedliche Organisationen und Systeme beteiligt sind. @tab:ota-ablauf ordnet jeder Phase den Ort und die Prüfungen oder Vorgaben zu, die für sie bestehen. Die Einteilung ist eine eigene Zusammenfassung der zitierten Spezifikationen und Regelwerke.

#figure(
  caption: [Phasen eines OTA-Updates (eigene Darstellung nach @unece2021r156 @autosar2025vucm @autosar2023fota @uptane2025standard @kuppusamy2017login)],
  dhbw-table(
    columns: (auto, auto, 1fr),
    align: (left, left, left),
    table.header([*Phase*], [*Ort*], [*Prüfungen und Vorgaben*]),
    [1. Entwicklung und Übergabe], [Zulieferer], [Vorgaben richten sich an den Hersteller, der Risiken aus der Lieferkette beherrschen muss],
    [2. Integration und Freigabe], [Hersteller], [Abhängigkeiten, Verträglichkeit mit den Zielfahrzeugen, Bewertung der Auswirkung auf die Typgenehmigung, Verifikation und Validierung],
    [3. Signatur und Bereitstellung], [Backend], [Signatur der Software-Abbilder und Metadaten],
    [4. Kampagne und Zielfahrzeuge], [Backend], [Auswahl der Zielfahrzeuge anhand ihres gemeldeten Softwarestands],
    [5. Download], [Backend, Update-Master], [gesicherte Verbindung, Prüfung der Metadaten],
    [6. Prüfung im Fahrzeug], [Update-Master, Ziel-Steuergerät], [Prüfung von Signatur und Hashwert, Löschen des Pakets bei Fehlschlag],
    [7. Information und Zustimmung], [Fahrzeug, Nutzer], [Zweck, Änderungen, Dauer und eingeschränkte Funktionen werden angezeigt],
    [8. Prüfung der Voraussetzungen], [Fahrzeug], [ausreichende Energie, sicherer Fahrzeugzustand],
    [9. Installation und Aktivierung], [Ziel-Steuergerät], [Fahren verhindern, wenn die Durchführung während der Fahrt unsicher wäre],
    [10. Kontrolle und Rückmeldung], [Fahrzeug, Backend], [Versionsbericht an das Backend, Information des Nutzers über Erfolg oder Misserfolg],
    [11. Fehlerfall], [Ziel-Steuergerät], [Wiederherstellung der Vorversion oder Übergang in einen sicheren Zustand],
  ),
) <tab:ota-ablauf>

=== Vorbereitung beim Hersteller



== Authentifizierung und sichere Verbindung <sec:ota-authentifizierung>
== Verifikation der Pakete <sec:ota-verifikation>
== Uptane <sec:uptane>
== Schutz im Fahrzeug <sec:ota-schutz>
== Regulatorische Vorgaben <sec:ota-regulatorik>
== Zwischenfazit <sec:ota-zwischenfazit>