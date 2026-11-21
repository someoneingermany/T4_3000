#import "@preview/clean-dhbw:0.6.0": *


= Schnittstellen und Angriffsflächen <ch:angriffsflächen>

@ch:grundlagen[Kapitel] hat gezeigt, dass die fahrzeuginternen Netze ihren Teilnehmern vertrauen. Eine Nachricht auf dem CAN-Bus wird verarbeitet, sobald sie den richtigen Identifier trägt. Offen geblieben ist, wie ein Angreifer überhaupt in die Lage kommt, solche Nachrichten zu senden. Dieses Kapitel beschreibt deshalb die Schnittstellen, über die ein Fahrzeug mit seiner Umgebung verbunden ist.

Zunächst wird der Begriff der Angriffsfläche erläutert und eine Einteilung der Schnittstellen vorgestellt. Anschließend werden vier Bereiche näher betrachtet: der Diagnosezugang über die OBD-Buchse, Telematik und Infotainment, die Backend-Systeme und Apps des Herstellers sowie die Ladeschnittstelle von Elektrofahrzeugen. Fallbeispiele zeigen, wie veröffentlichte Angriffe diese Schnittstellen genutzt haben. Ein Vergleich der Schnittstellen schließt das Kapitel ab und bereitet die Bewertung in @ch:analyse[Kapitel] vor.

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

Über den automatischen Notruf ist eine Mobilfunkanbindung für neue Pkw-Typen in der EU inzwischen vorgeschrieben. Seit dem 31.~März~2018 müssen neue Typen der Klassen M1 und N1 mit einem fest eingebauten eCall-System ausgestattet sein. Dieses System löst bei einem schweren Unfall automatisch oder manuell einen Notruf aus. Es überträgt dabei über öffentliche Mobilfunknetze einen Mindestdatensatz und baut eine Sprachverbindung zur Notrufzentrale auf. Von Ausnahmen wie Kleinserien abgesehen verfügt damit jeder Pkw eines seither neu genehmigten Typs über eine Mobilfunkeinheit @eu2015ecall.

Wie eine solche Verbindung angegriffen werden kann, zeigten 

== Fallbeispiele <sec:angriffsflaechen-fallbeispiele>