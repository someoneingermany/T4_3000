#import "@preview/clean-dhbw:0.6.0": *


= Schnittstellen und Angriffsflächen <ch:angriffsflächen>

@ch:grundlagen[Kapitel] hat gezeigt, dass die fahrzeuginternen Netze ihren Teilnehmern vertrauen. Eine Nachricht auf dem CAN-Bus wird verarbeitet, sobald sie den richtigen Identifier trägt. Offen geblieben ist, wie ein Angreifer überhaupt in die Lage kommt, solche Nachrichten zu senden. Dieses Kapitel beschreibt deshalb die Schnittstellen, über die ein Fahrzeug mit seiner Umgebung verbunden ist.

Zunächst wird der Begriff der Angriffsfläche erläutert und eine Einteilung der Schnittstellen vorgestellt. Anschließend werden vier Bereiche näher betrachtet: der Diagnosezugang über die OBD-Buchse, Telematik und Infotainment, sowie die Ladeschnittstelle von Elektrofahrzeugen. Fallbeispiele zeigen, wie veröffentlichte Angriffe diese Schnittstellen genutzt haben. Ein Vergleich der Schnittstellen schließt das Kapitel ab und bereitet die Bewertung in @ch:analyse[Kapitel] vor.

Das Kapitel behandelt Angriffe, bei denen ein Angreifer eine Schwachstelle in einer Schnittstelle des ausgelieferten Fahrzeugs direkt ausnutzt. Angriffe über die Software-Lieferkette, bei denen der Schadcode bereits vor der Auslieferung eines Updates eingebracht wird, untersucht @ch:supply-chain[Kapitel]. Die direkte Angriffsfläche ist für diese Arbeit dennoch von Bedeutung, weil #gls("OTA")-Updates über die drahtlosen Schnittstellen des Fahrzeugs übertragen werden @jiang2024sdv. Die Schnittstellen, über die ein Angreifer eindringen kann, sind damit zum Teil dieselben, über die der Hersteller seine Software verteilt.



== Überblick <sec:angriffsflaechen-ueberblick>

=== Begriff der Angriffsfläche

Das National Institute of Standards and Technology (NIST) definiert die Angriffsfläche als die Menge der Punkte an der Grenze eines Systems, einer Systemkomponente oder einer Umgebung, an denen ein Angreifer versuchen kann, einzudringen, eine Wirkung hervorzurufen oder Daten abzuziehen @nist2020sp80053. Im Fahrzeug sind dies vor allem die Schnittstellen, über die Daten von außen in ein Steuergerät gelangen. Jede dieser Schnittstellen wird von Software verarbeitet. Enthält diese Software einen Fehler, kann eine gezielt gestaltete Eingabe dazu führen, dass das Steuergerät Code des Angreifers ausführt. Ein Infotainmentsystem liest etwa beim Abspielen einer Musikdatei deren Inhalt ein. Prüft die Software nicht, ob die Datei dem erwarteten Format entspricht, kann eine präparierte Datei den Speicher des Steuergeräts überschreiben. Diesen Fall haben #cite(form: "prose", <checkoway2011comprehensive>) an einem Serienfahrzeug nachgewiesen.

=== Einteilung der Schnittstellen

Die Untersuchung von #cite(form: "prose", <koscher2010experimental>), die bereits in @ch:grundlagen[Kapitel] aufgegriffen wurde, ging davon aus, dass der Angreifer bereits Nachrichten im fahrzeuginternen Netz senden kann @koscher2010experimental. Ein Bedrohungsmodell, das physischen Zugang voraussetzt, galt jedoch als wenig realistisch, da ein Angreifer mit physischem Zugang auch ohne Computer Schaden anrichten kann @checkoway2011comprehensive. #cite(form: "prose", <checkoway2011comprehensive>) untersuchten deshalb in einer Folgearbeit die externe Angriffsfläche eines Serienfahrzeugs. Sie teilten die Schnittstellen danach ein, auf welchem Weg ein Angreifer schädliche Eingaben an das Fahrzeug übermitteln kann. Daraus ergeben sich drei Kategorien: indirekter physischer Zugang, drahtloser Zugang im Nahbereich und drahtloser Zugang über große Entfernungen @checkoway2011comprehensive. @tab:angriffsflaechen fasst die Einteilung zusammen. Die Ladeschnittstelle von Elektrofahrzeugen war 2011 nicht Gegenstand der Untersuchung und wurde für diese Arbeit ergänzt.

#figure(
  caption: [Einteilung der externen Angriffsfläche eines Fahrzeugs (eigene Darstellung nach @checkoway2011comprehensive, Ladeschnittstelle ergänzt nach @baker2019losing @koehler2023brokenwire)],
  dhbw-table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    table.header([*Kategorie*], [*Voraussetzung für den Angreifer*], [*Beispiele*]),
    [Indirekter physischer Zugang], [ein präpariertes Gerät oder Medium wird mit dem Fahrzeug verbunden], [OBD-Buchse und Werkstatttester, CD, USB, Anschluss für Mobilgeräte],
    [Drahtlos, Nahbereich], [Aufenthalt in Funkreichweite des Fahrzeugs], [Bluetooth, Funkschlüssel, Reifendruckkontrolle, Wegfahrsperre, WLAN],
    [Drahtlos, große Entfernung], [Erreichbarkeit über Rundfunk oder Mobilfunk], [Satellitennavigation, Digitalradio, Verkehrsfunk, Mobilfunk-Telematik],
    [Ladeschnittstelle (ergänzt)], [Anschluss an eine Ladesäule oder Nähe zum Ladevorgang], [Kommunikation zwischen Fahrzeug und Ladesäule über die Ladeleitung],
  ),
) <tab:angriffsflaechen>

Beim *indirekten physischen Zugang* muss sich der Angreifer nicht selbst am Fahrzeug befinden. Er präpariert ein Gerät oder ein Medium, das später von einer anderen Person mit dem Fahrzeug verbunden wird. Dazu gehören beispielsweise ein Diagnosegerät in einer Werkstatt oder eine CD. Beim *drahtlosen Zugang im Nahbereich* muss sich der Angreifer in Funkreichweite des Fahrzeugs aufhalten. Beim *drahtlosen Zugang über große Entfernungen* unterscheiden die Autoren zwei Formen. Rundfunkkanäle wie Digitalradio erreichen alle Fahrzeuge im Empfangsgebiet gleichzeitig. Adressierbare Kanäle wie die Mobilfunkverbindung der Telematik erlauben es dagegen, ein bestimmtes Fahrzeug gezielt anzusprechen @checkoway2011comprehensive.

=== Vom Einstieg zur Wirkung

Das von #cite(form: "prose", <checkoway2011comprehensive>) untersuchte Fahrzeug war eine Limousine im mittleren Preissegment mit weniger als 30 Steuergeräten und mehreren CAN-Bussen. Sein Telematiksteuergerät verfügte über Mobilfunk, Bluetooth, Satellitennavigation und ein Mikrofon im Innenraum. Für jede der nachgewiesenen Schwachstellen erlangten die Autoren die vollständige Kontrolle über die Fahrzeugsysteme. Der Grund liegt in der Architektur, die @sec:bussysteme beschreibt. Das kompromittierte Steuergerät mit externer Schnittstelle ist selbst an den CAN-Bus angeschlossen. Seine Nachrichten werden von den übrigen Steuergeräten ebenso verarbeitet wie die eines berechtigten Senders @koscher2010experimental.

Die in @sec:angriffsflaechen-fallbeispiele beschriebenen Angriffe folgen trotz unterschiedlicher Schnittstellen einem gemeinsamen Muster, das sich in vier Schritte gliedern lässt:

+ *Einstieg:* Der Angreifer nutzt eine Schwachstelle in der Software, die Eingaben einer externen Schnittstelle verarbeitet.
+ *Codeausführung:* Er bringt das Steuergerät mit dieser Schnittstelle dazu, eigenen Code auszuführen, und erweitert gegebenenfalls seine Rechte auf diesem Gerät.
+ *Übergang ins Bordnetz:* Er verschafft sich Zugriff auf ein Steuergerät oder Gateway, das Nachrichten auf den fahrzeuginternen Bus senden darf.
+ *Wirkung:* Er sendet Nachrichten an sicherheitsrelevante Steuergeräte und beeinflusst so Funktionen wie Bremse, Lenkung oder Antrieb.


Schutzmaßnahmen können an jedem dieser Schritte ansetzen. Ein Gateway mit Filterregeln, wie es @sec:ee-architektur beschreibt, erschwert den dritten Schritt. SecOC beruht auf einem gemeinsamen Schlüssel von Sender und Empfängern @autosar2024secoc. Es erschwert den vierten Schritt deshalb nur, solange das kompromittierte Steuergerät nicht selbst über den Schlüssel verfügt. Die Schutzmaßnahmen werden in @ch:standards[Kapitel] behandelt.

=== Einordnung in die UN-Regelung Nr.~155

Auch die UN-Regelung Nr.~155 ordnet externe Schnittstellen als Bedrohung ein. Ihr Anhang~5 enthält eine Liste von Bedrohungen, die in sieben Gruppen gegliedert ist. Sie betreffen die Backend-Server des Herstellers, die Kommunikationskanäle des Fahrzeugs, die Update-Verfahren, unbeabsichtigte Handlungen von Menschen, die externe Konnektivität, die Daten und den Code des Fahrzeugs, sowie unzureichend gehärtete Schwachstellen @unece2025r155[Anhang~5]. In der Gruppe der externen Konnektivität nennt die Regelung unter anderem:

- die Manipulation von Funktionen zur Fernbedienung von Systemen, etwa Funkschlüssel, Wegfahrsperre und Ladesäule,
- Störungen von drahtlosen Nahbereichssystemen und Sensoren,
- auf dem Fahrzeug installierte Software Dritter, beispielsweise Unterhaltungsanwendungen,
- Geräte, die an externe Schnittstellen angeschlossen werden, wie USB.

Die Liste deckt damit alle in diesem Kapitel behandelten Schnittstellen ab. Bedrohungen der Update-Verfahren bilden in der Regelung eine eigene Gruppe @unece2025r155. Sie werden in @ch:ota-updates[Kapitel] und @ch:supply-chain[Kapitel] betrachtet.


== OBD2 und Diagnose <sec:obd2>

=== Zweck und gesetzliche Pflicht

Die On-Board-Diagnose, kurz #gls("OBD"), wurde ursprünglich zur Überwachung der Abgasemissionen eingeführt. Das europäische Recht definiert sie als ein Diagnosesystem für die Emissionsminderung, das den wahrscheinlichen Bereich einer Fehlfunktion anhand von gespeicherten Fehlercodes erkennen kann @eu1998obd. Pkw mit Ottomotor und einer Höchstmasse bis 2500~kg müssen in der EU für neue Typen seit dem 1.~Januar~2000 und für alle Fahrzeuge seit dem 1.~Januar~2001 mit dem OBD-System ausgestattet sein. Für vergleichbare Pkw mit Dieselmotor gilt dies seit dem 1.~Januar~2003 für neue Typen und seit dem 1.~Januar~2004 für alle Fahrzeuge @eu1999obd. In den USA ist OBD-II bei Fahrzeugen mit Ottomotor bereits seit 1996 vorgeschrieben @wen2020plugnpwned.

Über die Diagnosebuchse sind heute nicht mehr nur Abgaswerte zugänglich. Wie @sec:diagnose beschreibt, werden über die Diagnoseprotokolle Messwerte ausgelesen, Speicherbereiche beschrieben und neue Software in Steuergeräte geschrieben @iso14229-1. #cite(form: "prose", <koscher2010experimental>) konnten über diesen Zugang Steuergeräte umprogrammieren. Geräte, die in die OBD-Buchse gesteckt werden, sind mit dem fahrzeuginternen Netz verbunden @wen2020plugnpwned. Die Diagnosebuchse ist damit eine Schnittstelle, die per Gesetz vorhanden sein muss und zugleich direkten Zugang zum Bordnetz bietet.

=== Werkstatttester als indirekter Zugang

Ein Angreifer muss die Diagnosebuchse nicht selbst nutzen. #cite(form: "prose", <checkoway2011comprehensive>) untersuchten sogenannte PassThru-Geräte. Werkstätten verbinden damit einen Diagnoserechner mit der OBD-Buchse des Fahrzeugs. Das Protokoll, über das das untersuchte Gerät konfiguriert wurde, war nicht authentifiziert und prüfte Eingaben unzureichend. Ein Angreifer, der sich im WLAN der Werkstatt befand, konnte so Befehle einschleusen und das Gerät dauerhaft manipulieren. Jedes Fahrzeug, das anschließend mit diesem Gerät gewartet wurde, konnte darüber kompromittiert werden. Die Autoren entwickelten zudem eine Variante, die sich selbstständig auf weitere PassThru-Geräte ausbreitete @checkoway2011comprehensive.

Der Angreifer muss das Fahrzeug dabei kein einziges Mal berühren. Er manipuliert ein Werkzeug, dem Werkstatt und Fahrzeug vertrauen, und nutzt es als Verteilweg. Dasselbe Prinzip liegt den Supply-Chain-Angriffen zugrunde, die @ch:supply-chain[Kapitel] untersucht.

=== Nachrüstgeräte in der OBD-Buchse

Neben Werkstattgeräten werden auch Geräte dauerhaft in die OBD-Buchse gesteckt. Sie werden beispielsweise von Versicherungen oder Flottenbetreibern ausgegeben oder direkt von Haltern gekauft @foster2015fast. Mit ihnen lassen sich Fahrzeugdaten auslesen, der Fahrzeugzustand überwachen oder Funktionen aus der Ferne steuern. Ihre Daten senden sie über Mobilfunk, WLAN oder Bluetooth weiter. Sie bilden eine eigene Funkschnittstelle, die direkt am Bordnetz hängt @foster2015fast @wen2020plugnpwned.

#cite(form: "prose", <foster2015fast>) untersuchten ein solches Telematikgerät des Herstellers Mobile Devices. Dieses wurde unter anderem von einem US-Versicherer eingesetzt. Auf allen getesteten Geräten war eine Verwaltungsschnittstelle aktiv, die sich per SMS ansprechen ließ. Über sie konnte ein Software-Update aus der Ferne gestartet werden. Die Updates waren nicht kryptografisch signiert, und der Update-Server ließ sich beliebig festlegen. Über eine Suche nach einem gemeinsamen SSH-Schlüssel fanden die Autoren zudem rund 1.500 möglicherweise betroffene Geräte, die aus dem Internet erreichbar waren. In einem Versuch mit einem freiwilligen Fahrer bei niedriger Geschwindigkeit steuerten sie aus der Ferne die Scheibenwischer und betätigten oder deaktivierten die Bremsen @foster2015fast.

#cite(form: "prose", <wen2020plugnpwned>) erweiterten diese Betrachtung auf den gesamten Markt. Sie untersuchten alle 77 drahtlosen OBD-Adapter, die im Februar 2019 bei Amazon in den USA angeboten wurden. Bei rund 84~% der Adapter fehlte eine Authentifizierung sowohl auf der Verbindungs- als auch auf der Anwendungsebene. 67,53~% filterten undefinierte CAN-Nachrichten nicht heraus, sondern leiteten sie an das Fahrzeug weiter. Jeder der 77 Adapter wies mindestens zwei der fünf identifizierten Schwachstellenarten auf. Die Autoren weisen darauf hin, dass einzelne sicherheitskritische CAN-Nachrichten, etwa zum Abschalten des Motors, bei hoher Geschwindigkeit gesperrt sind. Ein Angreifer kann seinen Angriff deshalb nach Einschätzung der Autoren auf Situationen mit geringer Geschwindigkeit abstimmen @wen2020plugnpwned.

Nachrüstgeräte werfen damit ein eigenes Problem auf: Sie werden weder vom Fahrzeughersteller entwickelt, noch von ihm geprüft. #cite(form: "prose", <foster2015fast>) beschreiben sie als lose mit dem Fahrzeug gekoppelt. Fahrzeughersteller können Schwachstellen in diesen Geräten deshalb nur schwer beheben @foster2015fast. Für die Frage nach der Verantwortung in @ch:rechtliche[Kapitel] ist dies relevant, weil an einem Schaden dann ein weiterer Akteur außerhalb der klassischen Lieferkette beteiligt sein kann.

=== Zugang über die Fahrzeugverkabelung

Die Diagnosebuchse ist nicht der einzige physische Zugang zum Bordnetz. #cite(form: "prose", <tindell2023caninjection>) beschreibt den Diebstahl eines Toyota RAV4, bei dem die Täter über den Steckverbinder eines Scheinwerfers an die Leitungen des CAN-Busses gelangten. Ein eingeschleustes Gerät sendete dort gefälschte Nachrichten des Steuergeräts für den schlüssellosen Zugang und verdrängte zugleich die übrigen Steuergeräte vom Bus. Solche Geräte werden nach Angaben des Autors für viele Modelle verschiedener Hersteller angeboten @tindell2023caninjection. Der Fall nutzt die in @sec:bussysteme beschriebenen Eigenschaften von CAN, betrifft aber jeweils nur ein einzelnes Fahrzeug und setzt physischen Zugang voraus. Er dient in dieser Arbeit nur der Abgrenzung.

=== Spannungsfeld zwischen offenem Zugang und Absicherung

Die Diagnosebuchse kann nicht verschlossen werden, ohne berechtigte Nutzer auszuschließen. Nach Art.~61 in Verbindung mit Anhang~X der Verordnung (EU) 2018/858 müssen Hersteller unabhängigen Marktteilnehmern, wie freien Werkstätten, Zugang zu OBD-Informationen sowie Reparatur- und Wartungsinformationen gewähren. Dieser Zugang muss leicht und zügig möglich sein und darf unabhängige Marktteilnehmer gegenüber Vertragswerkstätten nicht benachteiligen @eu2018typgenehmigung. Die Delegierte Verordnung (EU) 2021/1244 ergänzt diesen Anhang um ein Verfahren für sicherheitsrelevante Informationen. Gemeint sind Informationen, Software und Funktionen, die für die Reparatur der Diebstahlschutzfunktionen eines Fahrzeugs erforderlich sind. Unabhängige Marktteilnehmer erhalten darauf nur nach einer Zulassung und Autorisierung Zugriff @eu2021sermi.

Das europäische Recht verfolgt damit zwei Ziele: Der Diagnosezugang soll für berechtigte Dritte offen bleiben und zugleich vor Missbrauch geschützt sein. Abgesichert wird er deshalb nicht durch das Verschließen der Schnittstelle, sondern durch eine Prüfung, wer auf sie zugreift. Auf Protokollebene sieht UDS dafür die in @sec:diagnose beschriebene Zugriffsprüfung vor, deren Stärke jeder Hersteller selbst festlegt @iso14229-1.

== Telematik und Infotainment <sec:telematik>

=== Telematiksteuergerät

Ein Telematiksteuergerät, kurz #gls("TCU"), verbindet die Steuergeräte eines Fahrzeugs mit Systemen außerhalb des Fahrzeugs und ermöglicht so neue Dienste. Solche Geräte werden entweder vom Fahrzeughersteller verbaut oder nachgerüstet, wie in @sec:obd2 beschrieben.

Über den automatischen Notruf ist eine Mobilfunkanbindung für neue Pkw-Typen in der EU inzwischen vorgeschrieben. Seit dem 31.~März~2018 müssen neue Typen der Klassen M1 und N1 mit einem fest eingebauten eCall-System ausgestattet sein. Dieses System löst bei einem schweren Unfall automatisch oder manuell einen Notruf aus. Es überträgt dabei über öffentliche Mobilfunknetze einen Mindestdatensatz und baut eine Sprachverbindung zur Notrufzentrale auf. Von Ausnahmen wie Kleinserien abgesehen, verfügt damit jeder Pkw eines seither neu genehmigten Typs, über eine Mobilfunkeinheit @eu2015ecall.

Wie eine solche Verbindung angegriffen werden kann, zeigten #cite(form: "prose", <checkoway2011comprehensive>). Das Telematiksteuergerät ihres Versuchsfahrzeugs übertrug Daten über den Sprachkanal eines Telefonanrufs. Die Autoren fanden in der Authentifizierung dieses Verfahrens mehrere Schwächen und in der nachgelagerten Verarbeitung einen Pufferüberlauf. Durch einen Anruf beim Fahrzeug konnten sie eigenen Code auf dem Telematiksteuergerät ausführen. Der Angriff gelang auch, indem eine vorbereitete Audiodatei in ein Telefon abgespielt wurde @checkoway2011comprehensive.

Bei Mobilfunkverbindungen kommt hinzu, dass das Netz selbst die Erreichbarkeit bestimmt. #cite(form: "prose", <miller2015remote>) stellen fest, dass im Mobilfunknetz ihres Versuchsfahrzeugs jedes Gerät dieses Netzbetreibers, jedes andere Gerät im ganzen Land erreichen konnte. Bei einer Suche nach dem verwundbaren Dienst fanden sie 2.695 Fahrzeuge. Ihre Hochrechnung ergab zwischen 292.000 und 471.000 betroffene Fahrzeuge @miller2015remote. Später rief der Hersteller rund 1,4~Millionen Fahrzeuge zurück @nhtsa2015recall.

Die Mobilfunkanbindung aktueller Fahrzeuge bleibt heute immernoch ein Schwachstelle. Dies zeigte die Untersuchung von #cite(form: "prose", <bitsikas2026lte>). Die Autoren analysierten die LTE-Anbindung eines Tesla Model 3 und eines Cybertruck. Das Telematiksystem war anfällig dafür, dass die Teilnehmererkennung ausgelesen wird, dass sich dass sich das Fahrzeug mit einer gefälschten Basisstation verbindet und dass unsichere Rückfallmechanismen die Verfügbarkeit unbemerkt verschlechtern. Veraltete Konfigurationen der Steuerungsebene erlaubten zudem, unbemerkt SMS einzuschleusen und Rundsendungen zu fälschen. Nach Einschätzungen der Autoren gehen Normen und Regelungen wie ISO/SAE~21434 und die UN-Regelungen Nr.~155 und Nr.~156 davon aus, dass die Telematik sicher nachvollziehbar und widerstandsfähig ist. Die Untersuchung zeigt, dass diese Annahme nicht ohne Weiteres zutrifft @bitsikas2026lte. Für die Verteilung von Updates ist das relevant, weil OTA-Updates über diese Verbindung ins Fahrzeug gelangen.

=== Infotainmentsystem

Das Infotainmentsystem, häufig auch Head Unit genannt, bündelt Navigation, Medianwiedergabe, Telefonie und Anwendungen. Es verfügt über eine Vielzahl von Schnittstellen: USB, Bluetooth, WLAN und teilweise eine eigene Mobilfunkverbinung @checkoway2011comprehensive @miller2015remote. Anders als auf Steuergeräten mit nur einer Funktion läuft darauf häufig ein vollwertiges Betriebssystem. Das von #cite(form: "prose", <nie2017freefall>) untersuchte Infotainmentsystem nutzte beispielsweise einen Linux-Kernel und einen Webbrowser auf Basis einer veralteten WebKit-Version. Mit dem Funktionsumfang wächst die Menge an Software, die Eingaben von außen verarbeitet.

Für die Sicherheit entscheidend ist, wie das Infotainmentsystem mit dem übrigen Fahrzeug verbunden ist. Im Fall von #cite(form: "prose", <miller2015remote>) war das Infotainmentsystem an beide CAN-Busse des Fahrzeugs angeschlossen. Wer die Kontrolle über das Infotainmentsystem erlangt, kann unter Umständen auch Nachrichten an sicherheitsrelevante Steurgeräte senden. Bei #cite(form: "prose", <checkoway2011comprehensive>) genügte eine präparierte Musikdatei im WMA-Format auf einer CD. Auf einem PC ließ sich die Datei normal abspielen. Im Fahrzeug nutzte sie einen Programmierfehler beim Einlesen der Datei aus, sodass das Mediensystem den Code der Autoren ausführte und beliebige CAN-Nachrichten sendete @checkoway2011comprehensive.

Ähnlich gelang der Einstieg über Bluetooth das im Versuchsfahrzeug zum Telematiksteuergerät gehörte. Die Autoren nutzten zwei Wege. Zum einen über eine schädliche App auf einem bereits gekoppelten Smartphone oder durch Erraten der Kopplungs-PIN. Das Erraten dauerte im Durchschnitt etwa zehn Stunden pro Fahrzeug @checkoway2011comprehensive.

Mit installierbaren Anwendungen  kommt eine weitere Quelle hinzu. Die UN-Regelung Nr.~155 nennt Software Dritter, beispielsweise Unterhaltungsanwendungen, ausdrücklich als möglichen Weg, um Fahrzeugsystem anzugreifen @unece2025r155.

=== Zugekaufte Software in Schnittstellen

Die Software, die eine Shnittstelle bedient, stammt häufig nicht vom Fahrzeughersteller selbst. Bluetooth wird beispielsweise oft mit einem zugekauften Protokollstapel umgesetzt. Ein solcher Stack, ist die Software, die alle Schichten des Bluetooth-Protokolls verarbeitet. Vom Verbindungsaufbau  bis hin zur Übertragung von Musik oder Telefonbuchdaten. Welche Folgen eine Schwachstelle in einem solchen Baustein haben kann, zeigt der Fall PerfektBlue.

Das Sicherheitsunternehmen PCA Cyber Security fand im Bluetooth-Stack BlueSDK des Herstellers OpenSynergy vier Schwachstellen. Miteinander verkettet erlaubten sie es, Code im Betriebssystem des Infotainmentsystems auszuführen. Nach Angaben der Forscher waren Fahrzeuge von mindestens drei Herstellern betroffen, darunter Mercedes-Benz, Volkswagen und Škoda, sowie eines vierten Herstellers, der nicht genannt wurde @thehackernews2025perfektblue. Wie leicht sich die Schwachstellen ausnutzen lassen, hängt davon ab, wie der jeweilige Fahrzeughersteller das Koppeln von Geräten umgesetzt hat. BlueSDK wird als Framework ausgeliefert, das jeder Kunde anpassen kann. Volkswagen erklärte, Eingriffe in Lenkung, Bremse, Antrieb oder Fahrerassistenz seien nicht mögliche. Denn diese Funktionen liegen auf anderen eigens geschützten Steuergeräten. Zudem müsse ein Angreifer in höchstens fünf bis sieben Metern Entfernung befinden und die Zündung müsse eingeschaltet sein @thehackernews2025perfektblue. OpenSynergy wurde im Mai 2024 über die Schwachstellen informiert und stellte seinen Kunden im September 2024 korrigierte Versionen bereit. Die öffentliche Stellungsnahme folgte im Juli 2025 @opensynergy2025perfektblue.

Der Fall zeigt drei Punkte, die in @ch:supply-chain wieder aufgegriffen werden. Erstens betrifft eine Schwachstelle in einem einzelnen zugekauften Baustein Fahrzeuge mehrerer Hersteller zugleich. @sec:ee-architektur hat diesen Effekt bereits für standardisierte Basissoftware beschrieben. Zweitens liegt zwischen der Korrektur beim Zulieferer und der Installation im Fahrzeug mindestens ein weiterer Schritt. Die Software eines Zulieferers wird an den Hersteller übergeben, der sie anschließend an die Fahrzeuge verteilt @kuppusamy2017login. Eine Korrektur erreicht das Fahrzeug erst, wenn auch der Hersteller sie übernommen und ausgerollt hat. Drittens hängt die Wirkung einer Schwachstelle sowohl vom Code des Zulieferers als auch von dessen Einbindung durch den Hersteller ab @thehackernews2025perfektblue. Für die spätere Frage, wer einen Fehler zu verantworten hat, ist diese Verkettung von Bedeutung.

=== Funkschnittstellen im Nahbereich

Neben Telematik und Infotainment besitzen Fahrzeuge weitere Funkschnittstellen mit kurzer Reichweite. *Schlüssellose Zugangs- und Startsysteme*, englisch #gls("PKES"), lassen sich mit einem Relay-Angriff überlisten. Dabei leiten zwei Angreifer die Funksignale zwischen Fahrzeug und Schlüssel weiter, sodass das Fahrzeug den Schlüssel in der Nähe vermutet. #cite(form: "prose", <francillon2011relay>) konnten auf diese Weise zehn Fahrzeugmodelle von acht Herstellern öffnen und starten, unabhängig von der eingesetzten Verschlüsselung. Bei *Reifendruckkontrollsystemen*, englisch #gls("TPMS"), war die Funkübertragung der Messwerte weder verschlüsselt noch authentifiziert. #cite(form: "prose", <rouf2010tpms>) lösten aus einem nebenherfahrenden Fahrzeug gefälschte Warnmeldungen im Zielfahrzeug aus.

Beide Angriffe setzen Nähe zum Fahrzeug voraus, treffen jeweils ein einzelnes Fahrzeug und verschafften keinen Zugriff Zugriff auf das Bordnetz @francillon2011relay @rouf2010tpms. Sie zeigten aber, dass auch Komponenten, die nur Messwerte oder Zugangsdaten übertragen, ohne kryptografische Absicherung, Eingaben von außen annehmen.


== Ladeschnittstelle <sec:ladeschnittstelle>

=== Kommunikation zwischen Fahrzeug und Ladesäule

Elektrofahrzeuge besitzen eine Schnistelle, die bei Fahrzeugen mit Verbrennungsmotor fehlt. Beim Laden werden über die Ladeleitung nicht nur Energie, sondern auch Daten übertragen. Beim Schnellladen mit Gleichstrom nach dem in Europa verbreiteten Standard #gls("CCS") geschieht dies in zwei Stufen @koehler2023brokenwire:

+ Zunächst tauschen Fahrzeug und Ladesäule über ein pulsweitenmoduliertes Signal nach IEC~61851 grundlegende Informationen aus.
+ Anschließend bauen sie eine IP-basierte Verbindung auf, über die sie den Ladevorgang steuern. Diese Verbindung nutzt eine Datenübertragung über die Leitungen der Ladeschnittstelle, sogenannte #gls("PLC"), nach dem Standard HomePlug Green PHY. Die Anwendungsprotkolle sind in DIN~70121 und ISO~15118 festgelegt @koehler2023brokenwire.

ISO~15118-20 beschreibt die Kommunikation zwischen dem Kommunikationssteuergerät des Fahrzeugs, englisch #gls("EVCC"), und dem Kommunikationssteuergerät der Ladesäule, englisch #gls("SECC"). Die Norm legt fest, wie ein Fahrzeug im Kommunikationsnetz erkannt wird und wie eine IP-basierte Verbindung zwischen beiden aufgebaut wird @iso15118-20. Über diese Verbindung werden neben der Steuerung des Ladevorgangs auch Abrechnung, bidirektionales Laden und Internetzugang abgewickelt @baker2019losing.

Für die Sicherheitsbetrachtung folgt daraus, das Fahrzeug baut beim Laden eine Netzwerkverbindung zu einem Gerät auf, das nicht zum Fahrzeug gehört und dessen Software der Fahrzeughersteller nicht kontrolliert. Die UN-Regelung Nr.~155 nennt die Ladesäule entsprechend in ihrer Liste der Funktionen deren Manipulation einen Angriff ermöglichen kann @unece2025r155.

=== Authentifizierung und Plug & Charge

Die Protokolle für die Kommunikation beim Laden wurden in mehreren Stufen weiterentwickelt. DIN~SPEC~70121 aus dem Jahr 2012 enthält das Nötigste für die Energieübertragung und sieht weder TLS noch andere Schutzmaßnahmen vor ISO~16118-2 aus dem Jahr 2014 führte eine optionale TLS-Verschlüsselung ein, bei der sich nur die Ladesäule gegenüber dem Fahrzeug ausweist. Wird TLS genutzt, ist zusätzlich Plug & Charge möglich. Dabei weist sich das Fahrzeug über eine #gls("PKI") automatisch aus und bezahlt den Ladevorgang, ohne dass eine Ladekarte oder App nötig ist. Eine PKI ist ein Verbund aus Zertifizierungsstellen, der öffentliche Schlüssel an die Identität von Teilnehmern bindet. ISO~15118-20 schreibt schließlich gegenseitiges TLS vor, bei dem sich Ladesäule und fahrzeug mit Zertifikaten gegenseitig ausweisen @szakaly2025current.

Mit Plug & Charge wird das Fahrzeug damit Träger kryptografischer Identitäten, die für die Abrechnung genutzt werden. Wie die zugehörige PKI verwaltet und wie mit dem kryptografischen Material umgegangen werden soll, wird in der Branche nach #cite(form: "prose", <johnson2022evse>) kontrovers diskutiert. #cite(form: "prose", <szakaly2025current>) wiesen zudem auf einen Konstruktionsfehler hin. Jedes Zertifikat, das eine vertrauenswürdige Stelle für irgendeine Ladesäule ausgestellt hat, wird an jedem Standort akzeptiert. Das Fahrzeug kann folglich nicht prüfen, ob es mit der Ladesäule verbunden ist, für die das vorgelegte Zertifikat ausgestellt wurde @szakaly2025current.

=== Bekannte Schwachstelle

#cite(form: "prose", <baker2019losing>) zeigten, dass die Datenübertragung über die Ladeleitung elektromagnetische Signale abstrahlt, die sich drahtlos empfangen lassen. Sie entwickelten das erste Werkzeug, mit dem sich solche Netze drahtlos abhören lassen und werteten 54 reale Ladevorgänge aus. Von einem benachbarten Parkplatz aus ließen sich 91,8~% der Nachrichten fehlerfrei mitschneiden. Die Verbindungen waren an öffentlichen Ladepunkten häufig nicht mit TLS verschlüsselt. Die mitgeschnittenen Daten enthielten dauerhafte eindeutige Kennungen, von denen ein Teil zur Freigabe der Abrechnung genutzt wird @baker2019losing.

#cite(form: "prose", <koehler2023brokenwire>) beschrieben mit Brokenwire einen Angriff auf die Verfügbarkeit. Er nutzt das Zugriffsverfahren von HomePlug Green PHY aus, das von den Standards HomePlug Green PHY, DIN~70121 und ISO~15118 vorgeschrieben wird und das alle bekannten Implementierungen umsetzen. Ein schwaches Funksignal genügt, um die Kommunikation zwischen Fahrzeug und Ladesäule zu unterbrechen und den Ladevorgang abzubrechen. In realen Umgebungen gelang der Angriff gegen acht Fahrzeuge und 20 Ladesäulen auf Entfernungen von bis zu 47~m. Er lässt sich mit handelsüblicher Funktechnik durchführen und kann mehrere Fahrzeuge gleichzeitig treffen @koehler2023brokenwire.

Wie verbreitet die abgesicherten Protokollversionen in der Praxis sind, untersuchten #cite(form: "prose", <szakaly2025current>). Sie testeten 325 Schnellladesäulen von 26  Herstellern in vier europäischen Ländern, die zwischen 2013 und 2023 gefertigt wurden. 12~% der Ladesäulen unterstützten TLS und 6~% setzten TLS~1.2 normgerecht um. Keine Ladesäule beherrschte gegenseitiges TLS und unterstützte ISO~15118-20. Etwa 47~% implementierten ISO~15118-2. Alle untersuchten Ladesäulen nutzten Kommunikationschips desselben Herstellers, und 62~% von ihnen liefen mit einer Firmware, die älter als zehn Jahre war. Da keine Ladesäule eine Firmware verwendete, die nach der Veröffentlichung  von Brokenwire erschienen war, halten die Autoren diesen Angriff weiterhin wirksam @szakaly2025current.

Die genannten Untersuchungen betreffen das Abhören und Stören der Kommunikation, sowie die Verbreitung von Schutzmaßnahmen. Ein Eindringen in das Bordnetz des Fahrzeugs über die Ladeschnittstelle war nicht Gegenstand dieser Arbeiten @baker2019losing @koehler2023brokenwire @szakaly2025current. #cite(form: "prose", <szakaly2025current>) weisen jedoch darauf hin, dass ein Angreifer mit Zugang zum Kommunikationsnetz zwischen Fahrzeug und Ladesäule eine große Angriffsfläche vorfindet, zu der auch die Ethernet-Schnittstelle des Fahrzeugs gehört. Das Kommunikationssteuergerät des Fahrzeugs verarbeitet Eingaben eines fremden Geräts und ist damit Teil der Angriffsfläche im Sinne von @sec:angriffsflaechen-ueberblick.

=== Ladesäule und Ladenetz als vorgelagerte Systeme

Die Ladesäule ist selbst ein vernetztes Gerät mit eigener Software und eigener Anbindung an Backend-Systeme.  #cite(form: "prose", <johnson2022evse>) werteten öffentlich bekannte Schwachstellen in Ladeinfrastruktur aus und ordneten sie vier Gruppen von Schnittstellen zu: dem Anschluss zum Fahrzeug, den Bedienelementen für Nutzer, der Internetanbindung und den Wartungszugängen. Für jede dieser Gruppen fanden sie dokumentierte Schwachstellen @johnson2022evse. Einige Beispiele verdeutlichen die Brandbreite:

- *Wartungszugänge* sind nach den Autoren in Seriengeräte häufig offen. In einer Untersuchung ließen sich über einen USB-Anschluss die Zugangsdaten für die Kommunikation mit dem Backend kopieren @johnson2022evse.
- *Kommunikation mit dem Backend:* Die Verbindung zwischen Ladesäule und dem Verwaltungssystem des Betreibers läuft häufig über das #gls("OCPP"). Frühere Versionen dieses Protokolls nutzten unverschlüsseltes HTTP, sodass die Kommunikation abgefangen und verändert werden konnte @johnson2022evse.
- *Firmware-Verteilung:* Forschende des Idaho National Laboratory kompromittierten den Server eines Herstellers, der daraufhin eine veränderte Firmware an alle Ladesäulen dieses Herstellers verteilte. In einer weiteren Untersuchung war die Firmware nicht signiert @johnson2022evse.
- *Standardzugangsdaten:* Die US-Behörde CISA warnte 2024 vor einer Schnellladesäule, deren Weboberfläche bei falscher Konfiguration mit unveränderten Standardzugangsdaten erreichbar war. Eine erfolgreiche Ausnutzung ermöglicht es nach Angaben der Behörde, das Gerät abzuschalten, die Bezahlung zu umgehen oder auf Zahlungsdaten zuzugreifen @cisa2024alpitronic.

Das dritte Beispiel entspricht in kleinerem Maßstab dem Angriffsmuster, das diese Arbeit für Fahrzeuge untersucht. Über einen kompromittierten Verteilweg enthält eine ganze Gerätegruppe eine manipulierte Firmware. Für das Fahrzeug bedeutet dies, dass es beim Laden unter Umständen mit einer Gegenstelle kommuniziert. Dessen Software manipuliert wurde über die Lieferkette der Ladesäule, ohne dass der Fahrzeughersteller darauf Einfluss hat.

=== Regulatorische Entwicklung

Die EU schreibt die Unterstützung von ISO~15118 für neue Ladepunkte inzwischen schrittweise vor. Grundlage ist die Delegierte Verordnung (EU) 2025/6565 zur Verordnung über die Infrastruktur für alternative Kraftstoffe. Öffentlich zugängliche Ladepunkte, die neu errichtet oder modernisiert werden, müssen danach seit dem 8.~Januar~2026 die Teile 1 bis 5 von ISO~15118 erfüllen und ab dem 1.~Januar~2027 zusätzlich ISO~15118-20. Ab diesem Zeitpunkt gilt ISO~15118 auch für neue private Ladepunkte. Als automatisches Authentifizierungsverfahren ist ab 2027 nur noch Plug & Charge nach ISO~15118-20 zulässig @nll2026afir @eu2025afir.

Da ISO~15118-20 gegenseitiges TLS vorschreibt @szakaly2025current, wird sich die abgesicherte Kommunikation an neuen Ladepunkten verbreiten. Die Vorgaben gelten für neu errichtete oder modernisierte Ladepunkte @nll2026afir. Bedeutet bestehende Ladesäulen, von denen in der Untersuchung von #cite(form: "prose", <szakaly2025current>) 12~% TLS unterstützten, bleiben davon zunächst unberührt.


== Fallbeispiele <sec:angriffsflaechen-fallbeispiele>

Die folgenden Fallbeispiele zeigen, wie Forschende die beschriebenen Schnittstellen an Serienfahrzeugen genutzt haben. Ausgewählt wurden Angriffe, die aus der Ferne gelangen und deren Ablauf öffentlich dokumentiert ist. @tab:fallbeispiele gibt einen Überblick.

#figure(
  caption: [Ausgewählte Angriffe auf Serienfahrzeuge (eigene Darstellung nach @miller2015remote @nhtsa2015recall @ioactive2015advisory @nie2017freefall @keenlab2018bmw)],
  dhbw-table(
    columns: (auto, auto, 1fr, 1fr, 1fr),
    align: (center, left, left, left, left),
    table.header([*Jahr*], [*Fahrzeug*], [*Einstieg*], [*Weg ins Bordnetz*], [*Behebung*]),
    [2015], [Jeep Cherokee], [Mobilfunk, ungeschützter Dienst des Infotainmentsystems], [Neuprogrammierung des CAN-Controllers ohne Signaturprüfung], [Rückruf, Sperrung des Dienstes im Mobilfunknetz],
    [2016], [Tesla Model S], [WLAN, Webbrowser des Infotainmentsystems], [Rechteausweitung, manipulierte Gateway-Firmware], [OTA-Update nach zehn Tagen, Einführung der Codesignatur],
    [2018], [BMW (vier Modelle)], [USB und OBD lokal, Mobilfunk über gefälschte Basisstation], [Diagnosenachrichten über das zentrale Gateway], [Konfigurationsänderung aus der Ferne, Firmware-Update in der Werkstatt],
  ),
) <tab:fallbeispiele>

=== Jeep Cherokee (2015)

#cite(form: "prose", <miller2015remote>) griffen einen Jeep Cherokee des Modelljahres 2014 an. Sein Infotainmentsysten Uconnect war über das Mobilfunknetz erreichbar. Auf Port 6667 bot es einen Dienst zur Kommunikation zwischen Prozessen an, der keine Authentifizierung verlangte. Über eine Funktion dieses Dienstes konnten die Autoren Befehle mit Administratorrechten ausführen. Das Infotainmentsystem enthielt einen zweiten Mikrocontroller, der für die Kommunikation mit dem CAN-Bus zuständig war. Dessen Software ließ sich vom Infotainmentsystem aus neu aufspielen, ohne dass eine kryptografische Signatur geprüft wurde. Mit einer veränderten Software konnten die Autoren beliebige CAN-Nachrichten senden @miller2015remote.

Der Hersteller rief daraufhin rund 1,4~Millionen Fahrzeuge zurück, um die Software zu aktualisieren @nhtsa2015recall. Zusätzlich sperrte der Mobilfunkbetreiber den Datenverkehr zum betroffenen Port in seinem Netz @ioactive2015advisory.

=== Tesla Model S (2016)

Das Keen Security Lab des Unternehmens Tencent griff im September 2016 ein Tesla Model S aus der Ferne an, sowohl im geparkten Zustand als auch während der Fahrt.
Einstiegspunkt war der Webbrowser des Infotainmentsystems. Fahrzeuge verbanden sich automatisch mit einem bekannten WLAN-Namen, sodass ein Angreifer den Browser über einen eigenen Zugangspunkt auf eine präparierte Webseite leiten konnte. Der Browser nutzte eine veraltete WebKit-Version, deren Schwachstellen die Autoren zur Codeausführung nutzten. Über eine Schwachstelle im ebenfalls veralteten Linux-Kernel erweiterten sie ihre Rechte. Anschließend umgingen sie die Prüfungen im Update-Prozess des Gateways und spielten eine veränderte Gateway-Firmware auf. Danach konnten sie nach eigenen Angaben jederzeit beliebige CAN-Nachrichten einschleusen @nie2017freefall.

Tesla verteilte zehn Tage nach Erhalt des Berichts ein OTA-Update, das die gemeldeten Schwachstellen behob. Zugleich führte der Hersteller eine Codesignatur ein, mit der die Software des Updaters und der Steuergeräte geprüft wird @nie2017freefall. Im Folgejahr gelang es demselben Team, diese Codesignatur zu umgehen. Tesla behob auch diese Schwachstellen per OTA-Update @keenlab2017tesla.

=== BMW (2018)

Das Keen Security Lab untersuchte zwischen Januar 2017 und Februar 2018 vier BMW-Modelle der Baujahre 2012 bis 2017. Es fand 14 Schwachstellen in Infotainmentsystem, Telematiksteuergerät und zentralem Gateway, von denen sieben eine CVE-Nummer erhielten. Lokal ließ sich über USB und die OBD-Buchse eine Hintertür im Infotainmentsystem  einrichten. Aus der Ferne konnte ein Angreifer mit einer gefälschten Mobilfunk-Basisstation den Datenverkehr zwischen Fahrzeug und Telematikdienst abfangen. Dies gelang nach Angaben der Autoren aus mehreren hundert Metern Entfernung, auch während der Fahrt. Über das zentrale Gateway konnten die Autoren beliebige Diagnosenachrichten an Steuergeräte senden. Die meisten Steuergeräte reagierten darauf ebenfalls bei normaler Fahrgeschwindigkeit.

BMW verteilte ab Mitte April 2018 Konfigurationsänderungen aus der Ferne, um Angriffe über den Mobilfunk zu unterbinden. Weitere Software-Updates wurden über die Vertragswerkstätten angeboten. Der Bericht betont, dass es sich dabei nicht um ein OTA-Update der Steuergerätsoftware handelte @keenlab2018bmw.

=== Gemeinsamkeiten

Aus den Fallbeispielen und den Untersuchungen in diesem Kapitel lassen sich vier Gemeinsamkeiten ableiten.

Erstens erfolgte der *Einstieg über Systeme ohne unmittelbare Sicherheitsfunktion*. Infotainment und Telematik steuern weder Bremse noch Lenkung. Sie waren jedoch mit dem Bordnetz verbunden und boten damit einen Weg zu den sicherheitsrelevanten Steuergeräten @miller2015remote @nie2017freefall @keenlab2018bmw.

Zweitens führte der *Weg ins Bordnetz mehrfach über eine Software-Aktualisierung ohne wirksame Prüfung*. Im Jeep wurde die Software des CAN-Controllers ohne Signaturprüfung angenommen @miller2015remote. Bei Tesla ließen sich die Prüfungen im Update-Prozess des Gateway umgehen @nie2017freefall. Das OBD-Telematikgerät akzeptierte unsignierte Updates von einem beliebigen Server @foster2015fast. Der Update-Mechanismus eines Steuergeräts ist damit selbst ein Angriffsziel. Wie er abgesichert werden kann, beschreibt @sec:ota-verifikation.

Drittens wurden die Schwachstellen *über Software behoben, zunehemnd aus der Ferne*. Tesla verteilte seine Korrekturen per OTA-Update @nie2017freefall @keenlab2017tesla. BMW änderte Konfiguration aus der Ferne @keenlab2018bmw. Im Fall des Jeeps war dagegen ein Rückruf nötig @nhtsa2015recall. Die Möglichkeit, Software aus der Ferne zu aktualisieren, ist damit zugleich eine Schutzmaßnahme und ein möglicher Angriffsweg.

Viertens entstanden die Schwachstellen *an den Grenze zwischen Organisation*.  #cite(form: "prose", <checkoway2011comprehensive>) stellten fest, dass nahezu alle von ihnen gefundenen Schwachstellen an den Schnittstellen zwischen Code entstanden, den unterschiedliche Organisationen geschrieben hatten. Sie führen dies darauf zurück, dass Hersteller fertige Komponenten von Zulieferern beziehen und keinen Zugang zum Quellcode der Steuergerät haben, die sie in Auftrag geben @checkoway2011comprehensive. Diese Beobachtung verbidnet die direkte Angriffsfläche mit der Lieferkette, die @ch:supply-chain[Kapitel] untersucht.

== Vergleich der Schnittstellen <sec:angriffsflaechen-vergleich> 

Die in diesem Kapitel beschriebenen Schnittstellen unterscheiden sich darin, wie nah ein Angreifer dem Fahrzeug kommen muss, wie viele Fahrzeuge ein einzelner Angriff erreichen kann und welche Organisationen außerhalb des Fahrzeugherstellers beteiligt sind. @tab:vergleich-schnittstellen stellt diese Merkmale gegenüber. Die Einordnung ist eine eigene Zusammenfassung der in diesem Kapitel zitierten Untersuchungen. Sie beschreibt typische Fälle und ersetzt keine Bewertung im Einzelfall.

#figure(
  caption: [Vergleich der Schnittstellen nach Nähe, Reichweite und Beteiligten (eigene Darstellung auf Grundlage der in diesem Kapitel zitierten Quellen)],
  dhbw-table(
    columns: (auto, auto, 1fr, 1fr),
    align: (left, left, left, left),
    table.header([*Schnittstelle*], [*Nähe nötig*], [*Fahrzeuge je Angriff*], [*Beteiligte außerhalb des OEM*]),
    [OBD-Buchse und Verkabelung], [ja], [einzelne Fahrzeuge; über ein manipuliertes Werkstattgerät alle damit gewarteten Fahrzeuge], [Werkstätten, Hersteller von Diagnosegeräten],
    [Nachrüstgerät in der OBD-Buchse], [nein], [alle erreichbaren Geräte eines Typs], [Gerätehersteller, Versicherer, Flottenbetreiber],
    [Nahbereichsfunk], [ja], [einzelne Fahrzeuge in Funkreichweite], [Zulieferer von Funk- und Protokollsoftware],
    [Infotainment (Medien, WLAN, Browser, Apps)], [teilweise], [ein Fahrzeug je präpariertem Medium; über WLAN alle Fahrzeuge in Funkreichweite], [Zulieferer, Anbieter von Anwendungen],
    [Mobilfunk-Telematik], [nein], [alle über das Netz erreichbaren Fahrzeuge (Jeep: geschätzt 292.000 bis 471.000)], [Zulieferer, Mobilfunkbetreiber],
    [Backend und Apps], [nein], [potenziell alle verbundenen Fahrzeuge], [Dienstleister, Cloud-Anbieter],
    [Ladeschnittstelle], [ja], [Fahrzeuge an betroffenen Ladesäulen], [Ladesäulenhersteller, Betreiber, PKI-Betreiber],
  ),
) <tab:vergleich-schnittstellen>

Aus diesem Vergleich lassen sich zwei Beobachtungen ableiten. 
Erstens wächst die *Zahl der erreichbaren Fahrzeuge*, je weniger Nähe ein Angriff voraussetzt. Angriffe über die Fahrzeugverkabelung oder Nahbereichsfunk treffen ein einzelnes Fahrzeug @tindell2023caninjection @francillon2011relay. Über die Mobilfunkanbindung waren im Fall des Jeeps Hunderttausende Fahrzeuge erreichbar @miller2015remote. Über ein Backend lassen sich potenziell alle verbundenen Fahrzeuge erreichen @heise2024kia @heise2024vw. Ausnahmen entstehen dort, wo ein zentraler Verteilweg genutzt wird. Ein manipuliertes Werkstattgerät oder eine zentral verteilte Firmware wirk auf alle Geräte, die diesen Weg nutzen @checkoway2011comprehensive @johnson2022evse. Ein OTA-Update ist ein solcher zentraler Verteilweg für die Fahrzeugsoftware selbst. Darin liegt der Grund, warum diese Arbeit den Angriff über die Update-Lieferkette in den Mittelpunkt stellt.

Zweitens sind an *nahezu jeder Schnittstelle Organisationen außerhalb des Fahrzeugherstellers beteiligt*. Dazu gehören Zulieferer von Software-Bausteinen, Hersteller von Nachrüst- und Diagnosegeräten, Mobilfunkbetreiber, Cloud-Anbieter, sowie Hersteller und Betreiber von Ladesäulen. In @sec:methodik wurde die Erreichbarkeit als eines der Kriterien festgelegt, nach denen @ch:analyse[Kapitel] die Sensoren und Aktoren bewertet. Der Vergleich liefert dafür eine erste Abstufung. Je weniger Nähe ein Angriffsweg voraussetzt, desto mehr Fahrzeuge erreicht er und zentrale Verteilwege wie OTA-Updates reichen am weitesten. Für die rechtliche Prüfung in @ch:rechtliche[Kapitel] und @ch:haftung[Kapitel] zeigt er, dass bei einem Schaden regelmäßig mehrere Akteure als Verantwortliche in Betracht kommen.

== Zwischenfazit <sec:angriffsflaechen-zwischenfazit>

Dieses Kapitel hat die Schnittstellen beschrieben, über die eine Angreifer Zugang zu den fahrzeuginternen Netzen erlangen kann. Für die weitere Arbeit lassen sich daraus fünf Erkenntnisse festhalten.

+ *Jede externe Schnittstelle kann zum Einstieg werden.* Diagnosezugang, Infotainment, Telematik, Nahbereichsfunk und Ladeschnittstelle verarbeiten Eingaben von außen. Eine Schwachstelle in dieser Verarbeitung genügte in den untersuchten Fällen, um eigenen Code auszuführen und anschließend Nachrichten in das Bordnetz zu senden.

+ *Einige Schnittstellen sind vorgeschrieben.* Die OBD-Buchse muss nach europäischen Recht vorhanden und für freie Werkstätten zugänglich sein. Seit 2018 verfügt jeder Pkw eines neu genehmigten Typs über eine Mobilfunkeinheit für den eCall. Neue Ladepunkte müssen ISO~15118 unterstützen. Diese Schnittstellen lasse sich nicht entfernen, sondern nur absichern.

+ *Die Angriffsfläche endet nicht am Fahrzeug.* Backend-Server, Apps, Ladesäulen und deren Verwaltungssystem gehören zur Angriffsfläche. Ein Angriff auf diese Systeme kann ohne Schwachstelle im Fahrzeug selbst wirken und potenziell alle verbundenen Fahrzeuge betreffen.

+ *An fast jeder Schnittstelle sind Dritte beteiligt.* Zugekaufte Software-Bausteine wie Bluetooth-Stacks, Nachrüstgeräte, Werkstatttester und Ladesäulen stammen nicht vom Fahrzeughersteller. Eine Schwachstelle in einem zugekauften Baustein kann Fahrzeuge mehrerer Hersteller zugleich betreffen.

+ *Der Update-Mechanismus ist Angriffsziel und Schutzmaßnahme zugleich.* In mehreren Fällen führte der Weg ins Bordnetz über eine ungeprüfte Software-Aktualisierung. Behoben wurden Schwachstellen ebenfalls über Software-Updates, zunehmend per OTA. Zentrale Verteilwege erreichen dabei die größte Zahl von Fahrzeugen.

Die direkten Angriffe in diesem Kapitel setzen eine Schwachstelle im ausgelieferten Fahrzeug voraus. Wie Software-Updates aufgebaut sind, übertragen und abgesichert werden, beschreibt das folgende Kapitel.