#import "@preview/clean-dhbw:0.6.0": *


= Technische Grundlagen moderner Fahrzeuge <ch:grundlagen>

Um zu bewerten zu können, welche Fahrzeugfunktionen über ein manipuliertes Update beeinflussbar sind, ist ein Verständnis des technischen Aufbaus moderner Fahrzeuge erforderlich. Dieses Kapitelbeschreibt zunächst den Wandel vom mechanisch geprägten zum softwaredefinierten Fahrzeug. Anschließend werden die Elektrik/Elektronik-Architektur und die fahrzeuginternen Bussystem erläutert, über die Steuergeräte miteinander kommunizieren. Darauf aufbauend werden Sensoren und Aktoren vorgestellt, das heißt die Komponenten, über die ein Fahrzeug seine Umgebung wahrnimmt und auf sie einwirkt.
Den Abschluss bilden Fahrerassistenzsysteme und automatisiertes Fahren, in denen diese Komponenten zusammenwirken. 

Das Kapitel legt den Schwerpunkt auf die Eigenschaften, die für die spätere Sicherheitsanalyse relevant sind. Die externen Schnittstellen des Fahrzeugs werden in @ch:angriffsflächen[Kapitel] behandelt, der Ablauf von Software-Updates in @ch:ota-updates[Kapitel] und technische Schutzmaßnahmen in @ch:standards[Kapitel].


== Vom mechanischen zum softwaredefinierten Fahrzeug <sec:sdv>

=== Entwicklung der Fahrzeugelektronik

Über Jahrzehnte war das Automobil ein überwiegend mechanischen System. Lenkung, Bremse und Gaspedal waren über Gestänge, Seilzüge oder Hydraulikleitungen mit den rädern, der Bremsanlage und dem Motor verbunden @reif2014automobilelektronik.

Das erste in Serie gefertigte Steuergerät mit Mikrocomputer war ein Einzelfunktionsgerät. Es regelte 1977 im Oldsmobile Toronado von Gereral Motors den Zündzeitpunkt. Im Jahr 1981 setzte General Motors und in seiner gesamten Pkw-Produktion für den heimischen Markt mikroprozessorgesteuerte Motorsteuerungen mit rund 50.000 Zeilen Programmcode ein. Anfangs dienten diese Steuergeräte vor allem dazu, Verbrauch und Emissionen zu senken @charette2009code. Mit dem Antiblockiersystem und später der Fahrdynamikregelung enthielt die Elektronik zunehmend sicherheitsrelevante Aufgaben @reif2010fahrstabilisierung.

Die Menge an Software wuchs in der Folge stark an. Nach Einschätzung von Manfred Broy enthielt ein Fahrzeug der Oberklasse im Jahr 2009 annähernd 100 Millionen Zeilen Programmcode, die auf 70 bis 100 vernetzten Steuergeräten Steuergeräten ausgeführt wurden. Die Software steuerte zu diesem Zeitpunkt Funktionen von der Bremse bis zur Lautstärke des Radios @charette2009code. #cite(form: "prose", <koscher2010experimental>) beschrieben moderne Fahrzeuge im Jahr 2010 nicht mehr als rein mechanische Geräte, sondern als Systeme, die von Dutzenden vernetzter Computer überwacht und gesteuert werden @koscher2010experimental.

Diese Entwicklung folgte lange einem einfachen Muster. Für jede neue Funktion wurde ein eigenes Steuergerät entwickelt, das ein Zulieferer mit Hardware und Software als geschlossene Einheit an den Fahrzeughersteller lieferte @jiang2024sdv @khamis2025rethinking. Hardware und Software waren eng aneinander gebunden @khamis2025rethinking. eine Änderung der Funktion nach Auslieferung war überwiegend auf die Werkstatt beschränkt, beispielsweise bei einem Rückruf @jiang2024sdv.

=== Merkmale des softwaredefinierten Fahrzeugs

Das softwaredefinierte Fahrzeug, kurz #gls("SDV"), löst diese Kopplung auf @khamis2025rethinking. Der Begriff beschreibt ein Konzept, bei dem Software im Mittelpunkt der Fahrzeugfunktionen steht: Sie realisiert und erweitert Funktionen, verbessert die Leistung, passt das Fahrzeug an Umgebungsbedingungen an und ermöglicht, dass sich das Fahrzeug über seinen gesamten Lebenszyklus weiterentwickelt @jiang2024sdv. Technische Voraussetzungen dafür sind eine neue Elektrik/Elektronik-Architektur mit zentralen Hochleistungsrechnern, standardisierte Softwarearchitekturen, eine leistungsfähige Bordkommunikation und die Möglichkeit zur Aktualisierung über #gls("OTA") @jiang2024sdv.

#cite(form: "prose", <khamis2025rethinking>) beschreiben den Übergang von einer verteilten zu einer zentralisierten Rechnerarchitektur als Kern dieses Wandels. Die Trennung von Software und Hardware ermöglicht es, Funktionen während der gesamten Nutzungsdauer fortlaufend und flexibel bereitzustellen. Daraus entstehen neue Geschäftsmodelle, bei denen Funktionen als Dienst angeboten und nach dem Kauf gegen Entgelt freigeschaltet werden. Die Hardware für eine Funktion ist häufig ab Werk verbaut.
Ob und in welchem Umfang sie genutzt werden kann, entscheidet die Software @khamis2025rethinking. Denkbar ist beispielsweise eine Komfortfunktion wie eine Sitzheizung oder ein erweiterter Assistent, deren Bauteile in jedem Fahrzeug eines Modells vorhanden sind, die erst nach Zahlung eines Entgelts per Softwarefreischaltung aktiviert wird.

Zugleich benennen #cite(form: "prose", <khamis2025rethinking>) eine Reihe von Herausforderungen. Dazu gehören zersplitterte Zertifizierungsrahmen, fehlende standartisierte Werkzeugketten, eine begrenzte Unterstützung kontinuierlicher Validierung und eine wachsende Komplexität bei Wartung und Reparatur der Software. Hinzu kommen das Management von Schwachstellen, die langfristige Softwarepflege, eine zunehmend dezentralisierte Lieferkette und die Einhaltung regulatorischer Vorgaben @khamis2025rethinking. Mehrere dieser Punkte berühren unmittelbar die Fragestellung dieser Arbeit.

=== Lebenszyklus und Wertschöpfungskette

Zwei Eigenschaften unterscheiden das Fahrzeug grundlegend von anderen vernetzen Geräten: seine lange Nutzungsdauer und seine arbeitsteilige Herstellung.

Zum 1.~Januar~2026 waren in Deutschland 9.486.487 Personenkraftwagen zugelassen. Ihr Durchschnittsalter lag bei 10,9~Jahren @kba2026bestand. Aus diesem Durchschnittsalter folgt, dass ein heute verkauftes Fahrzeug voraussichtlich über ein Jahrzehnt im Strapenverkehr bleibt. Die UN-Regelung Nr.~155 verlangt, dass das Cybersicherheitsmanagement des Hersteller auch die Phase nach der Produktion abdeckt und auf neue Bedrohungen und Schwachstellen reagiert @unece2021r155.

Die zweiter Eigenschaft betrifft die Herkunft der Software. Ein Fahrzeughersteller, im Folgenden als #gls("OEM") bezeichnet, entwickelt einen Teil der Software selbst. Viele Steuergeräte werden von Zulieferern entwickelt, die als Tier-1-Zulieferer unmittelbar an den OEM liefern und ihrerseits Komponenten und Software von Tier-2-Zulieferern beziehen. Die Software eines Steuergeräts wird häufig vom Zulieferer gepflegt und an den OEM übergeben, der sie anschließend an die Fahrzeuge verteilt @kuppusamy2017login . Mit dem Wandel zum SDV verschiebt sich diese Struktur, da Hersteller mehr Software selbst entwickeln und zugleich Softwareanbieter außerhalb der klassischen Zulieferkette hinzukommen @khamis2025rethinking.  #cite(form: "prose", <khamis2025rethinking>) bezeichnen diese Entwicklung als Dezentralisierung der Lieferkette.

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


== Bussysteme <sec:bussysteme>
== Sensoren <sec:sensoren>
== Aktoren <sec:aktoren>
== Fahrerassistenz und automatisiertes Fahren <sec:adas>