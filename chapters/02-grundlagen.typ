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




== E/E-Architektur <sec:ee-architektur>
== Bussysteme <sec:bussysteme>
== Sensoren <sec:sensoren>
== Aktoren <sec:aktoren>
== Fahrerassistenz und automatisiertes Fahren <sec:adas>