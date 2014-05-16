//
//  ViewController.h
//  TesteAppFinal
//
//  Created by VINICIUS RESENDE FIALHO on 09/05/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <NSXMLParserDelegate> {
    NSXMLParser *parser;
    
    NSMutableArray *descricaoGeralPartitura;
    NSMutableArray *pentagramaPartitura;
    NSMutableArray *notasPartitura;
    
    NSString *element;
    
    NSMutableDictionary *item;
    NSMutableDictionary *partitura;
    NSMutableDictionary *notas;
    
    //descricao da partitura
    NSMutableString *titulo;
    NSMutableString *data;
    NSMutableString *nomeInstrumento;
    
    //partitura
    NSMutableString *n1;
    NSMutableString *armaduraClave;
    NSMutableString *numeroDeTempo;
    NSMutableString *unidadeDeTempo;
    NSMutableString *tipoClave;
    NSMutableString *linhaClave;
    
    //Notas
    NSMutableString *n2;
    NSMutableString *n3;
    NSMutableString *n4;
    NSMutableString *n5;
    NSMutableString *tom;
    
    
    AVQueuePlayer *queuePlayer;
    AVQueuePlayer *queuePlayer2;
    
    NSMutableString *nomeNotas;
    
    int auxIndiceNotas;
}

- (IBAction)buttonPlay:(id)sender;



@end
