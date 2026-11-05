#import "@preview/clean-dhbw:0.6.0": *
 
#import "glossary.typ": fachbegriffe
#import "abkürzungen.typ": abkürzungen

#show: clean-dhbw.with(
  title: "Car-Hacking: Wo endet Optimierung, wo beginnt rechtlich relevante Täuschung, und wer haftet?",
  authors: (
    (name: "Michelle Schneider", student-id: "7654321", course: "TINF24CS2", course-of-studies: "Cyber Security", company: (
      (name: "Evonik Industries AG", post-code: "12345", city: "Hanau")
    )),
    (name: "Devi Müller", student-id: "1234567", course: "TINF24CS2", course-of-studies: "Cyber Security", company: (
    (name: "HIMA Paul Hildebrandt GmbH", post-code: "12345", city: "Brühl")
    )),
  ),
  type-of-thesis: "Studienarbeit",
  at-university: false, // if true the company name on the title page and the confidentiality statement are hidden
  bibliography: bibliography("sources.bib"),
  date: datetime(year: 2027, day: 12, month: 04),
  glossary: abkürzungen + fachbegriffe, // displays the glossary terms defined in "glossary.typ und abkürzungen von abkürzungen.typ"
  language: "de", // en, de
  supervisor: (university: "Peter Zimmer"),
  university: "Duale Hochschule Baden-Württemberg",
  university-location: "Mannheim",
  university-short: "DHBW",

  
  // ---------- KI-Abschnitt ----------
  show-ai-usage-section: true,
  ai-usage-section-content: [
    Folgende Übersicht listet alle für die Erstellung der Studienarbeit verwendeten KI-basierten Werkzeuge auf und erläutert, wie und wofür sie verwendet wurden:

    - ChatGPT: ...
    - Claude Opus 5: ...
  ],

  // ---------- Anhang ----------
    appendix: include "chapters/12-anhang.typ"
  
)

#set page(margin: 2.5cm)
#set text(size: 11.5pt)
#set par(leading: 8pt, spacing: 19pt)
#set figure.caption(separator: [ -- ])
#show figure.caption: set text(size: 10pt)


  //  ---------------  Start der Arbeit  ---------------  //


#include "chapters/01-einleitung.typ"
#include "chapters/02-grundlagen.typ"
#include "chapters/03-angriffsflächen.typ"
#include "chapters/04-ota-updates.typ"
#include "chapters/05-standards.typ"
#include "chapters/06-supply-chain.typ"
#include "chapters/07-analyse.typ"
#include "chapters/08-rechtliche.typ"
#include "chapters/09-haftung.typ"
#include "chapters/10-handlungsempfehlungen.typ"
#include "chapters/11-fazit-ausblick.typ"



