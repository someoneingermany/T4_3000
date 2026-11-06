#import "@preview/clean-dhbw:0.6.0": *


= Technische Grundlagen moderner Fahrzeuge <ch:grundlagen>

Um bewerten zu können, welche Fahrzeugfunktionen über ein manipuliertes Update beeinflussbar sind, ist ein Verständnis des technischen Aufbaus moderner Fahrzeuge erforderlich. Dieses Kapitelbeschreibt zunächst den Wandel vom mechanisch geprägten zum softwaredefinierten Fahrzeug. Anschließend werden die Elektrik/Elektronik-Architektur und die fahrzeuginternen Bussystem erläutert, über die Steuergeräte miteinander kommunizieren. Darauf aufbauend werden Sensoren und Aktoren vorgestellt, das heißt die Komponenten, über die ein Fahrzeug seine Umgebung wahrnimmt und auf sie einwirkt.
Den Abschluss bilden Fahrerassistenzsysteme und automatisiertes Fahren, in denen diese Komponenten zusammenwirken. 

Das Kapitel legt den Schwerpunkt auf die Eigenschaften, die für die spätere Sicherheitsanalyse relevant sind. Die externen Schnittstellen des Fahrzeugs werden in @ch:angriffsflächen[Kapitel] behandelt, der Ablauf von Software-Updates in @ch:ota-updates[Kapitel] und technische Schutzmaßnahmen in @ch:standards[Kapitel].


== Vom mechanischen zum softwaredefinierten Fahrzeug <sec:sdv>
=== Entwicklung der Fahrzeugelektronik

Über Jahrzehnte war das Automobil ein überwiegend mechanischen System. Lenkung, Bremse und Gaspedal waren über Gestänge, Seilzüge oder Hydraulikleitungen mit den Rädern, der Bremsanlage und dem Motor verbunden @reif2014automobilelektronik.

Das erste in Serie gefertigte Steuergerät mit Mikrocomputer war ein Einzelfunktionsgerät. Es regelte 1977 im Oldsmobile Toronado von Gereral Motors den Zündzeitpunkt. Im Jahr 1981 setzte General Motors in seiner gesamten Pkw-Produktion für den heimischen Markt mikroprozessorgesteuerte Motorsteuerungen mit rund 50.000 Zeilen Programmcode ein. Anfangs dienten diese Steuergeräte vor allem dazu, Verbrauch und Emissionen zu senken @charette2009code. Mit dem Antiblockiersystem und später der Fahrdynamikregelung enthielt die Elektronik zunehmend auch sicherheitsrelevante Aufgaben @reif2010fahrstabilisierung.

Die Menge an Software stieg in der Folge stark an. Nach Einschätzung von Manfred Broy enthielt ein Fahrzeug der Oberklasse im Jahr 2009 annähernd 100 Millionen Zeilen Programmcode, die auf 70 bis 100 vernetzten Steuergeräten Steuergeräten ausgeführt wurden. Die Software steuerte zu diesem Zeitpunkt Funktionen von der Bremse bis zur Lautstärke des Radios @charette2009code. #cite(form: "prose", <koscher2010experimental>) beschrieben moderne Fahrzeuge im Jahr 2010 nicht mehr als rein mechanische Geräte, sondern als Systeme, die von Dutzenden vernetzter Computer überwacht und gesteuert werden @koscher2010experimental.

Diese Entwicklung folgte lange einem einfachen Muster. Dabei wurde für jede neue Funktion ein eigenes Steuergerät entwickelt, das ein Zulieferer mit Hardware und Software als geschlossene Einheit an den Fahrzeughersteller lieferte @jiang2024sdv @khamis2025rethinking. Hardware und Software waren eng aneinander gebunden @khamis2025rethinking. Eine Änderung der Funktion nach Auslieferung war dabei überwiegend auf die Werkstatt beschränkt, beispielsweise bei einem Rückruf @jiang2024sdv.

=== Merkmale des softwaredefinierten Fahrzeugs

Das softwaredefinierte Fahrzeug, kurz #gls("SDV"), löst diese Kopplung auf @khamis2025rethinking. Der Begriff beschreibt ein Konzept, bei dem Software im Mittelpunkt der Fahrzeugfunktionen steht: Sie realisiert und erweitert Funktionen, verbessert die Leistung, passt das Fahrzeug an Umgebungsbedingungen an und ermöglicht, dass sich das Fahrzeug über seinen gesamten Lebenszyklus weiterentwickelt @jiang2024sdv. Technische Voraussetzungen dafür sind eine neue Elektrik/Elektronik-Architektur mit zentralen Hochleistungsrechnern, standardisierte Softwarearchitekturen, eine leistungsfähige Bordkommunikation und die Möglichkeit zur Aktualisierung über #gls("OTA") @jiang2024sdv.

#cite(form: "prose", <khamis2025rethinking>) beschreiben den Kern dieses Wandels als den Übergang von einer verteilten zu einer zentralisierten Rechnerarchitektur. Die Trennung von Software und Hardware ermöglicht es, Funktionen während der gesamten Nutzungsdauer fortlaufend und flexibel bereitzustellen. Daraus entstehen neue Geschäftsmodelle, bei denen Funktionen als Dienst angeboten und nach dem Kauf gegen Entgelt freigeschaltet werden. Die Hardware für eine Funktion ist häufig ab Werk verbaut.
Ob und in welchem Umfang sie genutzt werden kann, entscheidet die Software @khamis2025rethinking. Denkbar ist beispielsweise eine Komfortfunktion wie eine Sitzheizung oder ein erweiterter Assistent, deren Bauteile in jedem Fahrzeug eines Modells vorhanden sind, die erst nach Zahlung eines Entgelts per Softwarefreischaltung aktiviert wird.

Zugleich benennen #cite(form: "prose", <khamis2025rethinking>) eine Reihe von Herausforderungen. Dazu gehören zersplitterte Zertifizierungsrahmen, fehlende standartisierte Werkzeugketten, eine begrenzte Unterstützung kontinuierlicher Validierung und eine wachsende Komplexität bei Wartung und Reparatur der Software. Hinzu kommen das Management von Schwachstellen, die langfristige Softwarepflege, eine zunehmend dezentralisierte Lieferkette und die Einhaltung regulatorischer Vorgaben @khamis2025rethinking. // KEEP?: Mehrere dieser Punkte berühren unmittelbar die Fragestellung dieser Arbeit.

=== Lebenszyklus und Wertschöpfungskette

Zwei Eigenschaften unterscheiden das Fahrzeug grundlegend von anderen vernetzen Geräten: seine lange Nutzungsdauer und seine arbeitsteilige Herstellung.

Zum 1.~Januar~2026 waren in Deutschland 9.486.487 Personenkraftwagen zugelassen. Ihr Durchschnittsalter lag bei 10,9~Jahren @kba2026bestand. Aus diesem Durchschnittsalter folgt, dass ein heute verkauftes Fahrzeug voraussichtlich über ein Jahrzehnt im Straßenverkehr bleibt. Dabei verlangt die UN-Regelung Nr.~155, dass das Cybersicherheitsmanagement des Hersteller auch die Phase nach der Produktion abdeckt und auf neue Bedrohungen und Schwachstellen reagiert @unece2021r155.

Die zweite Eigenschaft betrifft die Herkunft der Software. Ein Fahrzeughersteller, im Folgenden als #gls("OEM") bezeichnet, entwickelt einen Teil der Software selbst. Viele Steuergeräte werden von Zulieferern entwickelt, die als Tier-1-Zulieferer unmittelbar an den OEM liefern und ihrerseits Komponenten und Software von Tier-2-Zulieferern beziehen. Die Software eines Steuergeräts wird häufig vom Zulieferer gepflegt und an den OEM übergeben, der sie anschließend an die Fahrzeuge verteilt @kuppusamy2017login . Mit dem Wandel zum #gls("SDV") verschiebt sich diese Struktur, da Hersteller mehr Software selbst entwickeln und zugleich Softwareanbieter außerhalb der klassischen Zulieferkette hinzukommen @khamis2025rethinking.  #cite(form: "prose", <khamis2025rethinking>) bezeichnen diese Entwicklung als die Dezentralisierung der Lieferkette.

Für die vorliegende Arbeit ergeben sich daraus zwei Folgerungen. Erstens stehen Funktionsumfang und Verhalten eines Fahrzeugs bei Auslieferung nicht mehr endgültig fest. Der technische Zustand eines Fahrzeugs zum Zeitpunkt eines Unfalls kann sich daher erheblich von dem Zustand unterscheiden, in  dem es typgenehmigt und verkauft wurde @unece2021r156. Zweitens ist an der Software eines Fahrzeugs eine Vielzahl von Organisationen beteiligt. Jede dieser Organisationen bildet einen möglichen Ansatz für Angriffe auf die Lieferkette, die in @ch:supply-chain[Kapitel] untersucht werden.

== E/E-Architektur <sec:ee-architektur>

Als Elektrik/Elektronik-Architektur kurz E/E-Architektur, wird die Gesamtheit der elektronischen Komponenten eines Fahrzeugs und ihrer Vernetzung bezeichnet. Dazu gehören Steuergeräte, Sensoren, Aktoren, Kabelbäume und Kommunikationsnetze sowie die Zuordnung der Fahrzeugfunktionen zu diesen Komponenten @jiang2024sdv. Die E/E- Architektur legt damit fest, wo eine Funktion berechnet wird, welche Daten sie benötigt und über welche Wege diese Daten fließen.

=== Steuergeräte

Zentraler Baustein der E/E-Architektur ist das Steuergerät, englisch #gls("ECU"). Ein Steuergerät besteht aus einem Miktrocontroller mit Programm- und Datenspeicher, Schaltungen zur Aufbereitung von Sensorsignalen, Treiberstufen zu Ansteuerung von Aktoren, sowie Schnittstellen zu den Fahrzeugnetzen. Die Software liest zyklisch Sensorwerte ein, berechnet daraus Stellgrößen und gibt diese an die Aktoren weiter. Viele Regelungen laufen in festen Zeitrastern von wenigen Millisekunden ab @reif2014automobilelektronik.

Die Software liegt im nichtflüchtigen Speicher des Mikrocontrollers, heute überwiegend im Flash-Speicher. Für diese eng an die Hardware gebundene Software wird häufig der Begriff Firmware verwendet. Neben der eigentlichen Anwendungnssoftware enthält eine Steuergerät einen Bootloader. Dieser wird beim Start zuerst ausgeführt und ermöglicht es, die Anwendugnssoftware neu zu programmieren, ohne das Steuergerät auszubauen @reif2014automobilelektronik. Die Programmierung erfolgt über Diagnoseprotokolle, die in im späteren Verlauf kurz vorgestellt werden. In der Werkstatt läuft dies vereinfacht wie folgt ab: Ein Diagnosegerät wird an das Fahrzeug angeschlossen und versetzt das Steuergerät in einen Programmiermodus. Der Bootloader übernimmt die Kontrolle, löscht den Speicherbereich der alten ANwendugnssoftware, empfängt die neue Software blockweise und schreibt sie in den Flash-Speicher. Anschließend prüft er die neue Software und startet sie @zimmermann2014bussysteme @iso14229-1. Für die vorliegende Arbeit ist der Bootloader von besonderer Bedeutung, weil er die Stelle ist, an der ein Steuergerät über die Annahme neuer Software entscheidet.

Steuergeräte unterscheiden sich stark an ihrer Leistungsfähigkeit. Einfache Steuergeräte für Komfortfunktionen arbeiten mit kleinen Mikrocontrollern und wenige Kilobyte Speicher @reif2014automobilelektronik. Steuergeräte für Motor, Fahrwerk oder Fahrerassistenz verfügen über deutlich leistungsfähiger Prozessoren. Zentrale Hochleistungsrechner, englisch #gls("HPC"), bündeln Funktionen, die bisher auf viele einzelne Steuergeräte verteilt waren @jiang2024sdv.

Zur Absicherung kryptografischer Schlüssel werden in Steuergeräten zunehmend spezielle Sicherheitsbausteine eingesetzt sogenannte #gls("HSM"). Ein HSM ist ein abgeschotteter Bereich auf dem Chip mit eigenem Speicher, der Schlüssel aufbewahrt und kryptografische Operationen selbst ausführt. Die Anwendungssoftware kann das HSM beauftragen, eine Nachricht zu signieren oder zu prüfen, ohne selbst Zugriff auf den Schlüssel zu erhalten. Daraus folgt, eine kompromittierte Anwendugnssoftware kann den Schlüssel nicht auslesen, das HSM selbst jedoch weiterhin für ihre Zwecke benutzen. Grundlegend hierfür war das europäische Forschungsprojekt EVITA, das drei Klassen solcher Module definierte: Full, Medium und Light . Sie unterschieden sich im Funktionsumfang und erlauben es, unterschiedliche Kosten- und Sicherheitsanforderungen zu erfüllen @evita2011summary. Auf die Funktionsweise von HSM und Secure Boot geht @ch:standards[Kapitel] ein.

=== Softwarearchitektur

Die Software moderner Steuergeräte folgt in weiten Teilen dem Standard #gls("AUTOSAR"). Dieser trennt die Anwendungssoftware von einer standardisierten Basissoftware, die Betriebssystem, Kommunikationsdienste, Diagnosefunktionen und Hardwareabstraktion bereitstellt. Eine Laufzeitumgebung verbindet die Softwarekomponenten miteinander und mit der Basissoftware. In einem vereinfachten Beispiel erhält eine Softwarekomponente zu Ansteuerung des Bremslichts über diese Laufzeitumgeung das Signal "Bremspedal betätigt", ohne wissen zu müssen ob es von einem anderen Teil desselben Steuergeräts oder über einen Bus von einem anderen Steuergerät stammt. Die Standardisierung erleichtert es, Softwarekomponenten verschiedener Zulieferer auf einem Steuergerät zu kombinieren und auf andere Hardware zu übertragen @zimmermann2014bussysteme.

AUTOSAR umfasst heute zwei Plattformen @autosar2024adaptive. Die Classic Platform ist für tief eingebettete Steuergeräte mit harten Echtzeitanforderungen ausgelegt. Ihre gesamte Konfiguration wird zur Entwicklungszeit festgelegt, das Betriebssystem basiert auf dem Standard OSEK/VDX @zimmermann2014bussysteme. Die Adaptive Plattform wurde für Hochleistungsrechner entwickelt. Sie basiert auf einem POSIX-konformen Betriebssystem, nutzt eine dienstorientierte Kommunikation und unterstützt Anwendungen, die zur Laufzeit geladen und aktualisiert werden können. In heutigen Fahrzeugen existieren beide Plattformen nebeneinander @autosar2024adaptive.

Die Standartisierung hat eine Kehrseite, die für die Sicherheitsbetrachtung relevant ist. Ziel von AUTOSAR ist es, Softwarekomponenten herstellerübergreifend wiederverwenden zu können @zimmermann2014bussysteme. Wird dieselbe Komponente in Fahrzeugen mehrere Hersteller eingesetzt, betrifft eine Schwachstelle oder ein eingeschleuster Schadcode darin potenziell eine große Zahl von Fahrzeugen unterschiedlicher Marken statt eines einzelnen Fahrzeugmodells

=== Entwicklung der Architekturformen

Die Anordnung der Steuergeräte hat sich in mehreren Stufen entwickelt @jiang2024sdv @khamis2025rethinking. @tab:architekturen fasst die Stufen zusammen.

#figure(
  caption: [Entwicklungsstufen der E/E-Architektur (eigene Darstellung nach @jiang2024sdv @khamis2025rethinking)],
  dhbw-table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    table.header([*Architektur*], [*Gliederungsprinzip*], [*Merkmale*]),
    [Verteilt], [ein Steuergerät je Funktion], [viele Steuergeräte, hoher Verkabelungsaufwand, enge Kopplung von Hardware und Software],
    [Domänenorientiert], [Gruppierung nach Funktionsbereichen], [Domänensteuergeräte je Bereich, zentrales Gateway zwischen den Domänen],
    [Zonal], [Gruppierung nach Einbauort], [Zonensteuergeräte als Ein- und Ausgabeknoten, Funktionslogik auf zentralen Rechnern],
  ),
) <tab:architekturen>

In der *verteilten Architektur* übernimmt jedes Steuergerät eine oder wenige Funktionen. Neue Funktionen werden durch zusätzliche Steuergeräte ergänzt. Die Zahl der Steuergeräte, der Verkabelungsaufwand und die Zahl der Schnittstellen zwischen den Geräten steigen dadurch stark an @jiang2024sdv @khamis2025rethinking.

In der *domänenorientierten Architektur* werden Steuergeräte nach Funktionsbereichen gruppiert. Dazu gehören beispielsweise Antrieb, Fahrwerk, Karosserie, Infotainment und Fahrerassistenz. Jede Domäne erhält ein leistungsfähigeres Domänensteuergerät, das die Funktionen seines Bereichs koordiniert. Ein zentrales Gateaway verbindet die Domänen und leitet Nachrichten regelbasiert zwischen ihnen weiter @jiang2024sdv.

In der *zonalen Architektur* richtet sich die Gliederung nach dem Einbauort. Zonensteuergeräte sammeln Sensor- und Aktorsignale aus einem Bereich des Fahrzeugs, beispielsweise im Heck und leiten sie über ein schnelles Netzwerk an einen oder wenige zentrale Hochleistungsrechner weiter. In einem vereinfachten Beispiel bedient ein Zonensteuergerät vorne links den Scheinwerfer, den Raddrehzahlsensor und den Türkontakt dieser Fahrzeugseite, obwohl diese Komponenten zu unterschiedlichen Funktionsbereichen gehören @jiang2024sdv.

=== Gateaways und Domänentrennung

Gateaways haben in der E/E-Architektur eine doppelte Funktion. Sie übersetzen zwischen unterschiedlichen Bussystemen und Protokollen. Zugleich wirken sie als Filter, in dem sie ausschließlich ausgewählte Nachrichten von einer Domäne in eine andere weiterleiten @jiang2024sdv @aliwa2021cyberattacks. Damit sollen beispielsweise Nachrichten aus dem Infotainment nicht ungefiltert in die Fahrwerkdomäne gelangen @miller2015remote. Eine denkbare Filterregel erlaubt beispielsweise, dass die aktuelle Geschwindigkeit aus der Fahrwerkdomäne an das Infotaiment weitergegeben wird, um sie im Display anzuzeigen und sperrt die Gegenrichtung für Nachrichten, die eine Bremsung anfordern. 

Wie wichtig diese Trennung ist, zeigte die Untersuchung von #cite(form: "prose", <koscher2010experimental>). Die Autoren wiesen experimentell nach, dass ein Angreifer, der nahezu jedes Steuergerät kompromittiert, ein breites Spektrum sicherheitskritischer Systeme vollständig umgehen kann. Der Angriff von #cite(form: "prose", <miller2015remote>) beruhte ebenso darauf, dass vom Infotainmentsystem aus ein Weg in das fahrzeuginterne Bussystem bestand.

Aus diesen Architekturmerkmalen ergibt sich für die Cybersicherheit eine Verschiebung des Risikos. In einer verteilten Architektur bleibt eine manipulierte Software zunächst auf das jeweilige Steuergerät beschränkt. Auf einem Zentralrechner, der Funktionen mehrerer Domänen ausführt, kann ein einziges manipuliertes Softwarepaket dagegen mehrere sicherheitsrelevante Funktionen zugleich beeinflussen @jiang2024sdv. 
Die Trennung der Domänen wurde bisher teilweise durch getrennte Netze und Gateways erreicht. Dies wird jetzt zur Aufgabe der Software selbst, dazu gehören beispielsweise die Basissoftware des Zentralrechners oder des Betriebssystems. Ist diese Software selbst manipuliert, entfällt die Schutzwirkung.


== Bussysteme <sec:bussysteme>

Steuergeräte tauschen Daten über fahrzeuginterne Netze aus. Aus Kosten- und Gewichtsgründen werden überwiegend Bussystem eingesetzt, bei denen sich mehrere Teilnehmer ein gemeinsames Übertragungsmedium teilen. Je nach Anforderung an Datenrate, Echtzeitverhalten und Kosten kommen unterschiedliche Systeme zum Einsatz @aliwa2021cyberattacks.

#figure(
  caption: [Verbreitete Bussysteme im Fahrzeug (eigene Darstellung nach @iso11898-1 @iso17987-1 @iso17458-1 @reif2014automobilelektronik @ieee2015bw @ieee2019cg)],
  dhbw-table(
    columns: (auto, auto, 1fr),
    align: (left, left, left),
    table.header([*Bussystem*], [*Datenrate (typisch)*], [*Typischer Einsatz*]),
    [LIN], [bis 20 kbit/s], [Komfortfunktionen wie Fensterheber, Sitz- und Spiegelverstellung],
    [CAN], [bis 1 Mbit/s], [Antrieb, Fahrwerk, Karosserie; Standard für die meisten Steuergeräte],
    [CAN FD], [mehrere Mbit/s], [Weiterentwicklung von CAN mit größeren Nutzdaten],
    [FlexRay], [bis 10 Mbit/s], [zeitkritische Regelungen im Fahrwerk],
    [MOST], [bis 150 Mbit/s], [Audio- und Videoübertragung im Infotainment],
    [10BASE-T1S], [10 Mbit/s], [Anbindung von Sensoren und Aktoren an Zonensteuergeräte],
    [100BASE-T1 und schneller], [100 Mbit/s bis 1 Gbit/s und mehr], [Fahrerassistenz, Kameras, Verbindung zentraler Rechner],
  ),
) <tab:bussysteme>

=== Controller Area Network

Das am weitesten verbreitete Bussystem ist das #gls("CAN"). Es wurde ab 1983 bei Bosch entwickelt und 1986 öffentlich vorgestellt @cia2026can und ist heute in der Normenreihe ISO~11898 standardisiert. Darin wird unter anderem neben dem klassischen Rahmenformat die Weiterentwicklungen CAN~FD und CAN~XL beschrieben. Mit CAN~XL sind Datenfelder von bis zu 2048~Byte möglich @iso11898-1. 

==== Aufbau einer Nachricht

Eine klassische CAN-Nachricht besteht aus mehreren Feldern. Auf das Startbit folgt der Identitfier, der den Inhalt der NAchricht kennzeichnet @cho2016busoff. Welcher Identitfier für welchen Inhalt steht, legt jeder Hersteller in einer eigenen Kommunikationsmatrix fest. In einem fiktiven Fahrzeug enthält beispielsweise die Nachricht mit dem Identifier '0x1A0' die vier Raddrehzahlen und die Nachricht mit '0x220 den Lenkwinkel. Angreifer müssen diese Zuordnung daher zunächst durch Mitlesen und Ausprobieren ermitteln @miller2015remote. Daran schließen sich Steuerbits an, darunter die Längenangabe (Data Length Code) @cho2016busoff. Es folgen das Datenfeld mit bis zu acht Byte Nutzdaten, die Prüfsumme (CRC), ein Bestätigungsfeld (Acknowledge) und das Rahmenende @cho2016busoff. Die Prüfsumme dient der Erkennung von Übertragungsfehlern @iso11898-1. Da sie ohne geheimen Schlüssel berechnet wird, bietet sie keinen kryptografischen Schutz und kann von jedem Sender korrekt erzeugt werden @koscher2010experimental.

@fig:can-nachricht zeigt die Felder einer solchen Nachricht und ihre Länge in Bit.

#figure(
  caption: [Aufbau einer klassischen CAN-Datennachricht im Standardformat mit 11-Bit-Identifier (eigene Darstellung nach @iso11898-1 @cho2016busoff)],
  {
    set text(size: 7.5pt)
    let gruppe(name, n, farbe) = grid.cell(colspan: n, fill: farbe, inset: 4pt, align: center + horizon)[*#name*]
    let feld(name, farbe) = grid.cell(fill: farbe, inset: (x: 2pt, y: 6pt), align: center + horizon)[#name]
    let bits(t) = grid.cell(inset: 3pt, align: center, stroke: none)[#text(size: 6.5pt, fill: luma(80))[#t]]
    let c1 = luma(235)
    let c2 = rgb("#dbe8f5")
    let c3 = rgb("#c4d9ee")
    let c4 = rgb("#e8f0e0")
    grid(
      columns: (0.6fr, 2fr, 0.55fr, 0.55fr, 0.55fr, 1fr, 3fr, 1.5fr, 0.55fr, 0.75fr, 0.75fr, 0.9fr),
      stroke: 0.5pt + luma(120),
      // Zeile 1: Feldgruppen
      gruppe("Start", 1, c1),
      gruppe("Arbitrierungsfeld", 2, c3),
      gruppe("Steuerfeld", 3, c2),
      gruppe("Datenfeld", 1, c4),
      gruppe("CRC-Feld", 2, c2),
      gruppe("ACK-Feld", 2, c2),
      gruppe("Ende", 1, c1),
      // Zeile 2: Einzelfelder
      feld("SOF", c1),
      feld("Identifier", c3),
      feld("RTR", c3),
      feld("IDE", c2),
      feld("r0", c2),
      feld("DLC", c2),
      feld("Nutzdaten", c4),
      feld("CRC", c2),
      feld("Del.", c2),
      feld("ACK", c2),
      feld("Del.", c2),
      feld("EOF", c1),
      // Zeile 3: Länge in Bit
      bits("1"), bits("11"), bits("1"), bits("1"), bits("1"), bits("4"), bits("0–64"), bits("15"), bits("1"), bits("1"), bits("1"), bits("7"),
    )
    v(2pt)
    align(left, text(size: 6.5pt, fill: luma(80))[Länge in Bit. SOF: Start of Frame, RTR: Remote Transmission Request, IDE: Identifier Extension, r0: reserviertes Bit, DLC: Data Length Code, Del.: Begrenzungsbit (Delimiter), ACK: Acknowledge, EOF: End of Frame.])
  },
) <fig:can-nachricht>

==== Buszugriff und Priorisierung

Alle Teilnehmer sind gleichberechtigt an den Bus angeschlossen @cia2026can. Senden zwei Steuergeräte gleichzeitig, wird der Konflikt bitweise über den Identifier aufgelöst @cho2016busoff @iso11898-1. Elektrisch ist der Bus derart ausgelegt, dass eine logische 0 ("dominant") eine logische 1 ("rezessiv") überschreibt. Jeder Sender liest während des Sendens mit, welcher Pegel auf dem Bus anliegt. Sendet ein Steuergerät eine 1 und liest auf dem Bus eine 0, erkennt es, dass ein anderes Gerät mit höherer Priorität sendet und zieht sich zurück. Am Ende setzt sich der Sender mit dem niedrigsten Identifier durch, ohne dass ein Nachricht verloren geht @cho2016busoff. Der Identifier bestimmt damit zugleich den Inhalt und die Priorität einer Nachricht @cia2026can. Daraus folgt, dass zeitkritischen Nachrichten, wie Bremsfunktionen, niedrige Identifier zugewiesen werden können.

==== Fehlerbehandlung

CAN verfügt über eine ausgeprägte Fehlerbehandlung, die das system robust gegen Störungen machen soll. Jedes Steuergerät führt Fehlerzähler für Sende- und Empfangsfehler. Überschreitet einer der Zähler den Wert 127, wechselt das Gerät vom Zustand "error active" in den Zustand "error passive". Übersteigt der Sendefehlerzähler den Wert 255, trennt sich das Gerät vollständig vom Bus im Zustand "bus off". Dieser Mechanismus soll verhindern, dass ein defektes Steuergerät den gesamten Bus blockiert @cho2016busoff.

#cite(form: "prose", <cho2016busoff>) zeigten, dass sich dieser Schutzmechanismus selbst angreifen lässt. Bei dem von ihnen beschriebenen Bus-off-Angriff provoziert ein kompromittiertes Steuergerät wiederholt den Übertragungsfehler bei einem anderen Gerät, bis dieses sich vom Bus trennt. 
Dazu sendet der Angreifer zeitgleich mit einer bestimmten Nachricht des Opfers eine Nachricht mit demselben Identifier. Diese enthält an einer Stelle ein dominantes statt ein rezessives Bit. Das Opfer erkennt einen Fehler, erhöht seinen Fehlerzähler und wiederholt die Nachricht. Nach wenigen Wiederholungen hat es sich selbst vom Bus abgemeldet. Ist das Opfer in einem angenommen Fall das Steuergerät, welches die Raddrehzahlen sendet, fehlen allen anderen Systemen diese Daten. Die Autoren demonstrieren den Angriff an zwei realen Fahrzeugen. Der Angriff nutzt keine Schwachstelle eines bestimmten Steuergeräts, sondern die im Protokoll festgelegte Fehelrbehandlung, die jeder CAN-Controller umsetzt. Zusätzliche Schutzmaßnamen wie Authentifizierungscodes verhindern ihn nach Analyse der Autoren nicht. Solche Codes prüfen den Inhalt einer vollständig empfangenen Nachricht. Die Nachricht des Opfers wird jedoch bereits während der Übertragung durch das überschriebene Bit ungültig, bevor eine Prüfung stattfinden kann.  Voraussetzung ist, dass der Angreifer selbst Nachrichte auf den Bus senden kann, beispielsweise über ein kompromittiertes Steuergerät @cho2016busoff.

==== Sicherheitseigenschaften

Für die Sicherheitsbetrachtung lassen sich die Eigenschaften von CAN in vier Punkten zusammenfassen.

- *Broadcast:* Jede Nachricht wird an alle Teilnehmer die am gleichen CAN-Bussystem hängen gesendet. Jeder Empfänger entscheidet anhand des Identifiers, ob er sie verarbeitet. Jeder Teilnehmer kann damit den gesamten Verkehr mitlesen @aliwa2021cyberattacks.
- *Keine Absenderadresse:*  Eine CAN-Nachricht enthält keine Information darüber, welches Steuergerät sie gesendet hat.
- *Keine Authentifizierung:* Das Protokoll sieht keine Authentifizierung und keine Verschlüsselung vor. Ein Empfänger kann nicht erkennen, ob eine Bremsanforderung vom zuständigen Steuergerät stammt.
- *Angreifbare Fehlerbehandlung:* Die Mechanismen zur Fehlerbehebung.

CAN wurde in den 1980-Jahren für die Vernetzung von Steuergeräten innerhalb das Fahrzeugs entwickelt @cia2026can. Seit Fahrzeuge über Mobilfunk und andere Funkschnittstellen von außen erreichbar sind, kann ein Angreifer jedoch über eine solche Schnittstelle Zugang zum Bus erlangen @aliwa2021cyberattacks @miller2015remote.

==== CAN FD und CAN XL

CAN mit flexibler Datenrate, kurz CAN~FD, erweitert das Datenfeld auf bis zu 64~Byte und erlaubt es, die Nutzdaten mit einer höheren Bitrate zu übertragen als den priorisierten Teil der Nachricht. CAN~XL vergrößert das Datenfeld und ergänzt Felder zur Kennzeichnung höherer Protokolle @iso11898-1. Die größeren Datenfelder bieten rechnerisch mehr Platz für Authentifizierungsinformationen, die bei klassischem CAN schwer unterzubringen sind, aufgrund der Begrenzung auf acht Byte.

=== Weitere Bussysteme

Das #gls("LIN") ist ein kostengünstiges Bussystem mit einem steuernden und mehreren untergeordneten Knoten. Die 2025 überarbeitete Normenreihe ISO~17987 bezeichnet sie als Commander und Responder. Der Commander gibt einen festen Zeitplan vor, nach dem die Responder abgefragt werden. LIN wird für einfache Komfortfunktionen eingesetzt, bei denen geringe Datenraten genügen, wie beispielsweise für Sitzverstellung @iso17987-1.

FlexRay wurde fpr Anwendungen entwickelt, die ein deterministisches Zeitverhalten und hohe Ausfallsicherheit erfordern. Das Protokoll arbeitet zeitgesteuert. Jeder Teilnehmer erhält feste Zeitslots, in denen er senden darf. Zusätzlich gibt es einen dynamischen Bereich für ereignisgesteuerte Nachrichten. FlexRay kann zwei Kanäle redundant nutzen @iso17458-1.

Für Multimediaanwendungen wurde in der Vergangenheit #gls("MOST") eingesetzt, ein Bussystem mit Ringstruktur, das häufig über Lichtwellenleiter beschrieben wurde @reif2014automobilelektronik.

=== Automotive Ethernet

Mit dem Bedarf an hohen Datenraten für Kameras, Fahrerassistenz und zentrale Rechner gewinnt Ethernet an Bedeutung @jiang2024sdv. Klassisches Ethernet aus der Bürowelt ist für das Fahrzeug wegen Gewicht, Kosten und elektromagnetischer Verträglichkeit eingeschränkt geeignet @ieee2015bw. Daher wurden eigene Varianten für den Einsatz im Fahrzeug standardisiert @ieee2015bw @ieee2019cg.

Der Standard IEEE~802.3bw (100BASE-T1) ermöglicht eine Übertragung mit 100~Mbit/s über ein einzelnes verdrilltes Adernpaar. Ein Adernpaar bezeichnet zwei elektrische Kabel-Leiter, die häufig spiralförmig umeinander verdrillt sind, um elektromagnetische Störungen zu reduzieren.
Der Standard wurde in erster Linie durch die Anforderungen der Automobilindustrie vorangetrieben. Er basiert auf der von der Industrievereinigung OPEN Alliance entwickelten Spezifikation BroadR-Reach und war von Beginn an als erster Schritt einer Familie von Standards mit höherer Datenraten angelegt @ieee2015bw. Für die Anbindung von Sensoren und Aktoren an Zonensteuergeräte definiert IEEE~802.3cg die Variante 10BASE-T1S. Sie überträgt 10~Mbit/s und erlaubt, wie bei CAN, mehrere Teilnehmer an einer gemeinsamen Leitung. Damit lassen sich auch Sensoren und Aktoren mit geringem Datenbedarf über Ethernet anbinden @ieee2019cg.

Mit Ethernet halten Protokolle der Internetprotokollfamilie Einzug in das Fahrzeug. Für die dienstorientierte Kommunikation zwischen Steuergeräten spezifiziert AUTOSAR das Protokoll #gls("SOMEIP") @autosar2022someip. Ein zugehöriges Protokoll zur Dienstsuche ermöglicht es, verfügbare Dienste im Netz zur Laufzeit zu finden und zu abonnieren, statt alle Kommunikationsbeziehungen statisch festzulegen @autosar2024someipsd. Der Unterschied zu CAN lässt sich an einem vereinfachten Beispiel zeigen. Bei CAN sendet das Klimasteuergerät seine Messwerte in festen Abständen an alle Teilnehmer. Bei der dienstorientierten Kommunikation bietet es einen Dienst "Klimatisierung" an. Diesen können andere Steuergeräte im Netz finden und dessen Funktionen, wie Solltemperatur setzen, aufrufen. Diese Flexibilität ist eine Voraussetzung für das SDV @jiang2024sdv. Daraus folgt zugleich, dass Angriffsmuster aus klassischen IP-Netzen auf das Fahrzeug übertragbar werden.

==== Diagnosezugang <sec:diagnose>

Steuergeräte brauchen neben der normalen Kommunikation einen Zugang für Diagnose und Programmierung. Dafür gibt es das Protokoll #gls("UDS"). Es ist in der Normenreihe ISO~14229 festgelegt.
UDS arbeitet nach dem Prinzip von Anfrage und Antwort. Ein Diagnosegerät, der sogenannte Tester, stellt als Client eine Anfrage. Das Steuergerät antworte als Server. Auf diese Weise lassen sich beispielsweise die Motorsteuerung, das Getrieben oder das Antiblockiersystem ansprechen. Typische Dienste sind Messwerte auslesen, Speicherbereiche beschreiben, neue Software aufspielen. Das Aufspielen neuer Software besteht aus mehreren Schritten. Der Tester wechselt zuerst in eine Programmiersitzung. Danach weist er sich gegenüber dem Steuergerät aus. Anschließend kündigt er den Download an, überträgt die Daten und lässt sie am Ende prüfen.

Die Norm sieht vor, dass sich der Tester ausweisen muss, beispielsweise über ein Challenge-Response-Verfahren. Dabei stell das Steuergerät eine Aufgabe die nur ein berechtigter Tester richtig lösen kann. Wie sicher dieses Verfahren ist, legt jeder Hersteller selbst. UDS funktioniert über CAN ebenso wie über Ethernet @iso14229-1.

Für die Diagnose über Ethernet gibt es zusätzlich das Protokoll #gls("DoIP") nach ISO~13400. Es regelt drei Dinge: wie der Tester das Fahrzeug im Netzwerk findet, wie er eine Verbindung zum Gateaway aufbaut und wie das Gateaway die Anfragen an die Steuergeräte weiterleitet. Eine Verschlüsselung der Verbindung mit Transport Layer Security ist in der Norm möglich, aber nicht vorgeschrieben @iso13400-2.

Für diese Arbeit sind die Diagnosedienste aus zwei Gründen wichtig. Erstens wird über sie neue Software in Steuergeräte geschrieben @iso14229-1. Zweitens bieten sie einen weitreichenden Zugang zum Fahrzeug. In Untersuchungen ließen sich über diesen Weg Steuergeräte umprogrammieren @koscher2010experimental. Die Diagnosebuchse als Angriffsweg behandelt @ch:angriffsflächen[Kapitel], den Ablauf eines Updates @ch:ota-updates[Kapitel].

=== Absicherung der Kommunikation

CAN und andere klassische Bussysteme haben keinen eigenen Schutz gegen gefälschte Nachrichten. Deshalb wurden nachträglich Erweiterungen entwickelt. Verbreitet ist das AUTOSAR-Modul #gls ("SecOC") @autosar2024secoc.

SecOC hängt an jede Nachricht zwei Zusatzangaben an:

- einen Prüfcode, meist einen #gls("MAC"), der zeigt, dass die Nachricht echt und unverändert ist,
- einen Zählerstand, der verhindert, dass ein Angreifer alte Nachrichten aufzeichnet und später erneut einspielt

Sender und Empfänger besitzen dafür denselben geheimen Schlüssel. Ein Beispiel zeigt den Ablauf: Das Bremssteuregerät will die Nachricht "Bremsdruck 30~bar" senden. Es berechnet diesen Inhalt, dem aktuellen Zählerstand un dem Schlüssel einen kurzen Prüfcode und hängt ihn an. Der Empfänger rechnet mit demselben Schlüssel nach. Stimmen beide Werte nicht überein, wurde die Nachricht verändert oder stammt nicht von einem Gerät mit dem richtigen Schlüssel. Eine alte erneut eingespielte Nachricht fällt auf, weil ihr Zäherstand nicht mehr aktuell ist. Weitere Schutzmaßnahmen wie Firewalls in Gateaways und Systeme zur Angriffserkennung beschreibt @ch:standards[Kapitel].

Für diese Arbeit ist eine Grenze von SecOC entscheidend. Das Verfahren schützt vor Angreifern, die von außen falsche Nachrichten einschleußen. Allerdings prüft es nur, dass der Absender den richtigen Schlüssel besitzt @autosar2024secoc. Schlussfolgernd daraus bedeutet es, das ein Steuergerät, dessen Software über ein manipuliertes Update verändert wurde, den Schlüssel weiterhin hat. Dementsprechend kann es also Nachrichten senden, die als echt gelten, inhaltlich aber falsch sind. Dieser Unterschied zwischen einem Angriff von außen und einem Angriff aus einem berechtigten Steuergerät wird sich voraussichtlich durch die gesamte Analyse ziehen.

== Sensoren <sec:sensoren>

Sensoren messen physikalische Größen und wandeln sie in elektrische Signale um. Diese Signale verarbeiten die Steuergeräte weiter. Ohne Sensoren gibt es keine Regelung und keine automatisierte Entscheidung im Fahrzeug. Es lassen sich zwischen zwei Gruppen unterscheiden: Sensoren, die den Zustand des eigenen Fahrzeugs erfassen und Sensoren die die Umgebung wahrnehmen @reif2016sensoren.

=== Sensoren für den Fahrzeugzustand

Die erste Gruppe misst beispielsweise, wie schnell und in welche Richtung sich das Fahrzeug. Zu den wichtigen Sensoren gehören:

- *Raddrehzahlsensoren* messen, wie schnell sich jedes Rad dreht. Daraus werden die Geschwindigkeit und Schlupf berechnet, also wie stark ein Rad durchdreht oder blockiert
- *Lenkwinkelsensoren* erfassen, wie weit das Lenkrad eingeschlagen ist. Daraus ergibt, wohin der Fahrer lenken will.
- *Drehratensensoren* messen wir schnell sich das Fahrzeug um seine senkrechte Achse dreht. Diese Größe heißt Gierrate.
- *Beschleunigungssensoren* erfassen die Beschleunigung nach vorn und zur Seite. Sie werden unter anderem für das Auslösen der Airbags genutzt.
- *Drucksensoren* messen beispielsweise, wie stark der Fahrer auf das Bremspedal tritt
- *Pedalwertgeber* erfassen die Stellung von Fahr- und Bremspedal elektrisch @reif2016sensoren.

Diese Sensoren liefern die Daten für Fahrdynamikregelungen wie #gls("ABS") und #gls("ESP"). Das ESP berechnet aus Lenkwinkel und Geschwindigkeit, wohin der Fahrer fahren will. Diesen Wert vergleicht es mit der tatsächlich gemessenen Bewegung. Bricht das Fahrzeug beispielsweise in einer Kurve aus, bremst das ESP einzelne Räder ab und verringert das Motormoment. So stabilisiert es das Fahrzeug @winner2024handbuch. Daraus folgt, wenn die Sensorwerte verfälscht sind, greift das ESP möglicherweise ohne Grund ein oder es bleibt in einer kritischen Situation untätig.

=== Sensoren für die Umfelderfassung

Die zweite Gruppe erfasst die Umgebung des Fahrzeugs. Dazu gehören vorallem Kameras, Radar- und LiDAR-Sensoren sowie Ultraschallsensoren für den Nahbereich @winner2024handbuch @yeong2021sensor. Für die eigenen Position kommen Satellitennavigation, digitale Karten und die Raddrehzahlen hinzu @petit2015remote.@tab:umfeldsensoren vergleicht die wichtigsten Sensortypen.

#figure(
  caption: [Vergleich von Sensoren zur Umfelderfassung (eigene Darstellung nach @yeong2021sensor @winner2024handbuch)],
  dhbw-table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    table.header([*Sensor*], [*Stärken*], [*Schwächen*]),
    [Kamera], [hohe Auflösung, Farbinformation, Erkennung von Markierungen und Verkehrszeichen], [abhängig von Licht und Witterung, keine direkte Entfernungsmessung bei Monokameras],
    [Radar], [Messung von Abstand und Relativgeschwindigkeit, robust bei Dunkelheit, Regen und Nebel], [geringere Auflösung, eingeschränkte Klassifikation von Objekten],
    [LiDAR], [präzise dreidimensionale Abbildung der Umgebung], [hohe Kosten, witterungsempfindlich],
    [Ultraschall], [kostengünstig, zuverlässig im Nahbereich], [geringe Reichweite, auf niedrige Geschwindigkeiten beschränkt],
  ),
) <tab:umfeldsensoren>

*Kameras* liefern detaillierte Bilder mit Farbinformationen. Sie eignen sich dementsprechend um Fahrbahnmarkierungen, Verkehrszeichen, Ampeln und Fußgänger zu erkennen. Bei schlechtem Licht oder schlechtem Wetter lässt ihre Leistung nach. Eine einzelne Kamera kann Entfernungen nur schätzen. Eine Stereokamera nutzt zwei versetzte Bildsensoren und kann daraus Entfernungen berechnen.

*Radarsensoren* senden Funkwellen aus und werten die Reflexionen aus. Aus der Laufzeit des Signals ergibt sich der Abstand eines Objekts. Aus der Frequenzänderung der zurückkommenden Welle ergibt sich seine Geschwindigkeit relativ zum eigenen Fahrzeug. Das Prinzip kennt man von der Sirene eines Krankenwagens. Sie klingt höher, wenn er näher kommt und tiefer, wenn er sich entfernt. Radar funktioniert auch bei Dunkelheit, Regeln und Nebel. Seine Auflösung ist jedoch geringer als die von Kamera oder LiDAR @yeong2021sensor. Abstandsregeltempomaten und viele Notbremsassistenten abreiten mit Radar @winner2024handbuch.

*LiDAR*-Sensoren tasten die Umgebung mit Laserlicht ab. Basierend aus der Laufzeit der Lichtimpulse entsteht ein dreidimensionales Bild der Umgebung. LiDAR ist bislang teurer als Kamera und Radar und reagiert wie die Kamera empfindlihc auf Witterung. Eingesetzt wird es vor allem in höher automatisierten Fahrzeugen @yeong2021sensor.

*Ultraschallsensoren* messen über Schallwellen Abstände von wenigen Metern. Sie werden für Einparkhilfen und automatisches Einparken genutzt @winner2024handbuch.

=== Sensordatenfusion und Kalibrierung

Jeder Sensortyp hat Stärken und Schwächen. Außerdem können Sensoren durch Defekte, Störsignale oder Wetter ausfallen. Ein einzelner Sensore reicht deshalb für eine Fahraufgabe nicht aus. Moderne Systeme führen die Daten mehrerer Sensoren Sensoren zu einem gemeinsamen Bild der Umgebung zusammen. dieser Vorgang heißt Sensordatenfusion @yeong2021sensor. 

Nach #cite(form: "prose", <yeong2021sensor>) ist sie die Grundlage jedes automatisierten Systems. Schon kleine Fehler haben große Folgen. An einem Beispiel gezeigt: Zeigt ein Sensor um ein Grad zur Seite, liegt ein Objekt in 100~m Entfernung rechnerisch um 1,75~m daneben (100~m · tan(1°) ≈ 1,75~m). Je weiter das Objekt entfernt ist, desto größer wird der Fehler. Ein vorausfahrendes Fahrzeug kann so auf der Nachbarspur erscheinen. Umgekehrt kann ein Fahrzeug auf der Nachbarspur plötzlich auf der eigenen Spur liegen.

=== Physische Angriffe und Manupulation der Verarbeitung

Sensoren lassen sich auf zwei Wegen angreifen.

Beim *physischen Angriff* stört oder fälscht der Angreifer das Messsignal selbst. #cite(form: "prose", <petit2015remote>) zeigten dies mit handelsüblicher Technik. Sie konnten Kameras blenden und LiDAR-Sensoren mit Laserimpulsen stören oder ihnen Objekte vortäuschen. Die Autoren betonen, dass sich ein automatisiertes Fahrzeug bei schnellen, sicherheitsrelevanten Entscheidungen vollständig auf seine Sensoren verlässt. Für solche Angriffe muss der Angreifer in der Nähe des Fahrzeugs sein und trift nur ein einzelnes Fahrzeug@petit2015remote.

Bei der *Manipulation der Verarbeitung* bleibt der Sensor unverändert. Zwischen Messung und Entscheidung liegen jedoch mehrere Verarbeitungsschritte in Software. Die Signale werden gefiltert, Objekte erkannt und eingeordnet, die Daten mehrerer Sensoren zusammengeführt. Auch die Kalibrierwerte liegen als Daten in der Software @yeong2021sensor. Daraus folgt, wird die Software, die Fusionslogik oder die Kalibrierung manipuliert, entsteht ein falsches Bild der Umgebung. Das gilt auch dann, wenn alle Sensoren richtig messen. Der Angreifer muss dafür nicht in der Nähe des Fahrezeugs sein. Gelangt die Manipulation über ein Update ins Fahrzeug, betrifft sie alle Fahrzeuge, die dieses Update erhalten @yeong2021sensor.

Diese Arbeit konzentriert sich auf die zweite Form. Physische Angriffe auf Sensoren dienen nur zur Abgrenzung.

== Aktoren <sec:aktoren>
== Fahrerassistenz und automatisiertes Fahren <sec:adas>