//
//  ViewController.m
//  TesteAppFinal
//
//  Created by VINICIUS RESENDE FIALHO on 09/05/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define n64th 0.0625
#define n32th 0.125
#define n16th 0.25
#define eighth 0.5
#define quarter 1.0
#define half 2.0
#define whole 4.0


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   auxIndiceNotas = 0;
   
   descricaoGeralPartitura = [[NSMutableArray alloc] init];
   notasPartitura = [[NSMutableArray alloc] init];
   pentagramaPartitura = [[NSMutableArray alloc] init];
   // NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
   
    NSString *thePath=[[NSBundle mainBundle] pathForResource:@"parabens" ofType:@"xml"];
    NSURL *url=[NSURL fileURLWithPath:thePath];
   
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
   
   
   nomeNotas = [[NSMutableString alloc]init];
   [nomeNotas appendString:@"0A"];
   [nomeNotas appendString:@"0AS"];
   [nomeNotas appendString:@"0B"];
   [nomeNotas appendString:@"0C"];
   [nomeNotas appendString:@"0Cs"];
   [nomeNotas appendString:@"0D"];
   [nomeNotas appendString:@"0E"];
   

}




- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
   
    element = elementName;
    
    if ([element isEqualToString:@"score-partwise"]) {
       item    = [[NSMutableDictionary alloc] init];
       titulo   = [[NSMutableString alloc] init];
       data   = [[NSMutableString alloc] init];
       nomeInstrumento   = [[NSMutableString alloc] init];
    }
   
   if ([element isEqualToString:@"part"]) {
      partitura = [[NSMutableDictionary alloc] init];
      n1 = [[NSMutableString alloc] init];
      armaduraClave = [[NSMutableString alloc] init];
      numeroDeTempo = [[NSMutableString alloc] init];
      unidadeDeTempo = [[NSMutableString alloc] init];
      tipoClave = [[NSMutableString alloc] init];
      linhaClave = [[NSMutableString alloc] init];
   }
   
   if ([element isEqualToString:@"note"]) {
      notas = [[NSMutableDictionary alloc] init];
      n2 = [[NSMutableString alloc] init];
      n3 = [[NSMutableString alloc] init];
      n4 = [[NSMutableString alloc] init];
      n5 = [[NSMutableString alloc] init];
      tom = [[NSMutableString alloc] init];
      
   }
   
   
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  
   //Descricao geral
   if ([element isEqualToString:@"movement-title"]) {
       [titulo appendString:string];
   }
   if ([element isEqualToString:@"encoding-date"]) {
       [data appendString:string];
   }
   if ([element isEqualToString:@"instrument-name"]) {
       [nomeInstrumento appendString:string];
   }
   
   //DescricaoPartitura
   if ([element isEqualToString:@"divisions"]) {
      [n1 appendString:string];
   }
   if ([element isEqualToString:@"fifths"]) {
      [armaduraClave appendString:string];
   }
   if ([element isEqualToString:@"beats"]) {
      [numeroDeTempo appendString:string];
   }
   if ([element isEqualToString:@"beat-type"]) {
      [unidadeDeTempo appendString:string];
   }
   if ([element isEqualToString:@"sign"]) {
      [tipoClave appendString:string];
   }
   if ([element isEqualToString:@"line"]) {
      [linhaClave appendString:string];
   }
   
   //Notas
   if ([element isEqualToString:@"step"]) {
      [n2 appendString:string];
   }
   if ([element isEqualToString:@"octave"]) {
      [n3 appendString:string];
   }
   if ([element isEqualToString:@"duration"]) {
      [n4 appendString:string];
   }
   if ([element isEqualToString:@"type"]) {
      [n5 appendString:string];
   }
   if ([element isEqualToString:@"alter"]) {
      [tom appendString:string];
   }
   
  
  
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
   
   
    if ([elementName isEqualToString:@"score-partwise"]) {
       [item setObject:titulo forKey:@"movement-title"];
       [item setObject:data forKey:@"encoding-date"];
       [item setObject:nomeInstrumento forKey:@"instrument-name"];

       [descricaoGeralPartitura addObject:[item copy]];
    }
   
   if ([elementName isEqualToString:@"part"]) {
      [partitura setObject:n1 forKey:@"divisions"];
      [partitura setObject:armaduraClave forKey:@"fifths"];
      [partitura setObject:numeroDeTempo forKey:@"beats"];
      [partitura setObject:unidadeDeTempo forKey:@"beat-type"];
      [partitura setObject:tipoClave forKey:@"sign"];
      [partitura setObject:linhaClave forKey:@"line"];
      
      [pentagramaPartitura addObject:[partitura copy]];
   }
   
   if ([elementName isEqualToString:@"note"]) {
      [notas setObject:n2 forKey:@"step"];
      [notas setObject:n3 forKey:@"octave"];
      [notas setObject:n4 forKey:@"duration"];
      [notas setObject:n5 forKey:@"type"];
      [notas setObject:tom forKey:@"alter"];
      
      [notasPartitura addObject:[notas copy]];

   }
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
 
   NSLog(@"=================DESCRICAO=====================");
    for(int i=0;i<descricaoGeralPartitura.count;i++){
       NSLog(@"titulo = %@",[[descricaoGeralPartitura objectAtIndex:i] objectForKey: @"movement-title"]);
       NSLog(@"data = %@",[[descricaoGeralPartitura objectAtIndex:i] objectForKey: @"encoding-date"]);
       NSLog(@"nome instrumento = %@",[[descricaoGeralPartitura objectAtIndex:i] objectForKey: @"instrument-name"])
    }
   
   NSLog(@"=================PARTITURA=====================");
   for(int i=0;i<pentagramaPartitura.count;i++){
      NSLog(@"Divisao = %@",[[pentagramaPartitura objectAtIndex:i] objectForKey: @"divisions"]);
      NSLog(@"Armadura Clave = %@",[[pentagramaPartitura objectAtIndex:i] objectForKey: @"fifths"]);
      NSLog(@"Numero de tempo = %@",[[pentagramaPartitura objectAtIndex:i] objectForKey: @"beats"]);
      NSLog(@"Unidade de tempo = %@",[[pentagramaPartitura objectAtIndex:i] objectForKey: @"beat-type"]);
      NSLog(@"Tipo clave = %@",[[pentagramaPartitura objectAtIndex:i] objectForKey: @"sign"]);
      NSLog(@"Linha clave = %@",[[pentagramaPartitura objectAtIndex:i] objectForKey: @"line"]);
   }
   
   NSLog(@"=================NOTAS=====================");
   for(int i=0;i<notasPartitura.count;i++){
      NSLog(@"nota %d \n",i+1);
      NSLog(@"n2 = %@",[[notasPartitura objectAtIndex:i] objectForKey: @"step"]);
      NSLog(@"n3 = %@",[[notasPartitura objectAtIndex:i] objectForKey: @"octave"]);
      NSLog(@"n4 = %@",[[notasPartitura objectAtIndex:i] objectForKey: @"duration"]);
      NSLog(@"n5 = %@",[[notasPartitura objectAtIndex:i] objectForKey: @"type"]);
      NSLog(@"Tom = %@",[[notasPartitura objectAtIndex:i] objectForKey: @"alter"]);
      NSLog(@"----------------");
   }
   
   
}

-(void)tocar2{
   
   NSString *nomeNota = [[notasPartitura objectAtIndex:auxIndiceNotas] objectForKey: @"step"];
   NSString *nivelNota = [[notasPartitura objectAtIndex:auxIndiceNotas] objectForKey: @"octave"];
   
   NSString *tomNota = [[notasPartitura objectAtIndex:auxIndiceNotas] objectForKey: @"alter"];
   NSString *auxTomNota = [tomNota stringByReplacingOccurrencesOfString:@"\n" withString:@""];
   NSString *tomEncurtado = [auxTomNota stringByReplacingOccurrencesOfString:@" " withString:@""];
   
   NSString *notaFinal;
   NSString *auxNotaFinal = [NSString stringWithFormat:@"%@%@",nivelNota,nomeNota];
   NSString *aux2NotaFinal = [auxNotaFinal stringByReplacingOccurrencesOfString:@"\n" withString:@""];
   notaFinal = [aux2NotaFinal stringByReplacingOccurrencesOfString:@" " withString:@""];
   
   
   NSString *tempoNota = [[notasPartitura objectAtIndex:auxIndiceNotas] objectForKey: @"type"];
   NSString *aux2Not = [tempoNota stringByReplacingOccurrencesOfString:@"\n" withString:@""];
   tempoNota = [aux2Not stringByReplacingOccurrencesOfString:@" " withString:@""];
   float tempo;
   
   
   if([tempoNota isEqualToString:@"64th"]){
      tempo = n64th;
   }else if([tempoNota isEqualToString:@"32th"]){
      tempo = n32th;
   }else if([tempoNota isEqualToString:@"16th"]){
      tempo = n16th;
   }else if([tempoNota isEqualToString:@"eighth"]){
      tempo = eighth;
   }else if([tempoNota isEqualToString:@"quarter"]){
      tempo = quarter;
   }else if([tempoNota isEqualToString:@"half"]){
      tempo = half;
   }else {
      tempo = whole;
   }
   
   
   AVPlayerItem *item1;
   
   if ([tomEncurtado rangeOfString:@"-1"].location != NSNotFound){
      
      notaFinal = @"5A";
      NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:notaFinal ofType:@"m4a"]];
      item1 = [[AVPlayerItem alloc] initWithURL:url1];
      
      
   }else if([notaFinal isEqualToString:@""]){
      
      notaFinal = @"1tempos";
      NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:notaFinal ofType:@"m4a"]];
      item1 = [[AVPlayerItem alloc] initWithURL:url1];
   
      
   }else{
      NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:notaFinal ofType:@"m4a"]];
      item1 = [[AVPlayerItem alloc] initWithURL:url1];
   }
   
   
   queuePlayer2 = [[AVQueuePlayer alloc] initWithPlayerItem:item1];
   queuePlayer2.volume = 5.0;
   [queuePlayer2 play];
   
   
   auxIndiceNotas++;
   
   if(auxIndiceNotas < notasPartitura.count){
      [NSTimer scheduledTimerWithTimeInterval:tempo target:self selector:@selector(tocar) userInfo:nil repeats:NO];
   }
   

   
}

-(void)tocar{
   
  // NSMutableArray *listaNotas = [[NSMutableArray alloc]init];
   
      NSString *nomeNota = [[notasPartitura objectAtIndex:auxIndiceNotas] objectForKey: @"step"];
      NSString *nivelNota = [[notasPartitura objectAtIndex:auxIndiceNotas] objectForKey: @"octave"];
      
      NSString *tomNota = [[notasPartitura objectAtIndex:auxIndiceNotas] objectForKey: @"alter"];
      NSString *auxTomNota = [tomNota stringByReplacingOccurrencesOfString:@"\n" withString:@""];
      NSString *tomEncurtado = [auxTomNota stringByReplacingOccurrencesOfString:@" " withString:@""];
      
      NSString *notaFinal;
      NSString *auxNotaFinal = [NSString stringWithFormat:@"%@%@",nivelNota,nomeNota];
      NSString *aux2NotaFinal = [auxNotaFinal stringByReplacingOccurrencesOfString:@"\n" withString:@""];
      notaFinal = [aux2NotaFinal stringByReplacingOccurrencesOfString:@" " withString:@""];
   
   
      NSString *tempoNota = [[notasPartitura objectAtIndex:auxIndiceNotas] objectForKey: @"type"];
      NSString *aux2Not = [tempoNota stringByReplacingOccurrencesOfString:@"\n" withString:@""];
      tempoNota = [aux2Not stringByReplacingOccurrencesOfString:@" " withString:@""];
     float tempo;
   

   
   if([tempoNota isEqualToString:@"64th"]){
      tempo = n64th;
   }else if([tempoNota isEqualToString:@"32th"]){
      tempo = n32th;
   }else if([tempoNota isEqualToString:@"16th"]){
      tempo = n16th;
   }else if([tempoNota isEqualToString:@"eighth"]){
       tempo = eighth;
   }else if([tempoNota isEqualToString:@"quarter"]){
      tempo = quarter;
   }else if([tempoNota isEqualToString:@"half"]){
      tempo = half;
   }else {
      tempo = whole;
   }
      
   
   
      AVPlayerItem *item1;
   
      if ([tomEncurtado rangeOfString:@"-1"].location != NSNotFound){
         
         NSLog(@"SDS5 %@",notaFinal);
         notaFinal = @"5B";
         NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:notaFinal ofType:@"m4a"]];
         item1 = [[AVPlayerItem alloc] initWithURL:url1];
         //[listaNotas addObject:item1];
         
      }else if([notaFinal isEqualToString:@""]){
         
         notaFinal = @"1tempos";
         NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:notaFinal ofType:@"m4a"]];
         item1 = [[AVPlayerItem alloc] initWithURL:url1];
         //[listaNotas addObject:item1];
         
      }else{
         
         NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:notaFinal ofType:@"m4a"]];
         item1 = [[AVPlayerItem alloc] initWithURL:url1];
         //[listaNotas addObject:item1];
      }
   
   
      queuePlayer = [[AVQueuePlayer alloc] initWithPlayerItem:item1];
      queuePlayer.volume = 5.0;
      [queuePlayer play];
   
   
      auxIndiceNotas++;
   
   NSLog(@"nota %@",notaFinal);
   
   
    if(auxIndiceNotas < notasPartitura.count){
       [NSTimer scheduledTimerWithTimeInterval:tempo target:self selector:@selector(tocar2) userInfo:nil repeats:NO];
    }
 

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPlay:(id)sender {
    [self tocar];
}
@end
