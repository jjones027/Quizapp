
#import "WordPuzzle.h"

@interface NSMutableArray (Shuffle)

- (void)shuffle;

@end

@interface AnswerButton : UIButton

@property (weak, nonatomic) UIButton *questionButton;
@property (weak, nonatomic) UIImageView *bgImage;
@property int index;

@end

@implementation AnswerButton

@end

@implementation NSMutableArray (Shuffle)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform((int)nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end

@interface WordPuzzle()

@property (nonatomic, strong) NSString *originalWord;
@property (nonatomic, strong) NSString *workingWord;
@property (nonatomic, strong) NSMutableArray *songLetters;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *wordLabels;

@property (nonatomic, assign) int randomCount;
@property (nonatomic, assign) int currentLetterIndex;


@end

@implementation WordPuzzle

@synthesize originalWord,workingWord,songLetters,buttons,wordLabels,randomCount,currentLetterIndex;
@synthesize questionGridCellSize,answerGridCellSize;

- (id)initWithWord:(NSString *)str andRandomCharacterToInjectCount:(int)count
{
    self = [super init];
    if(self)
    {
        originalWord = str.lowercaseString;
        randomCount = count;
        currentLetterIndex = 0;
        questionGridCellSize = CGSizeMake(40, 40);
        answerGridCellSize = CGSizeMake(40, 40);
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    songLetters = [NSMutableArray new];
    buttons = [NSMutableArray new];
    wordLabels = [NSMutableArray new];

    workingWord = [originalWord stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *mu = [NSMutableString stringWithString:workingWord];
    
    NSString *alphabet  = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (NSUInteger i = 0; i < randomCount; i++)
    {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet.lowercaseString characterAtIndex:r];
        [mu appendFormat:@"%C", c];
    }
    for (int i = 0; i < [mu length]; i++)
    {
        NSString *ch = [mu substringWithRange:NSMakeRange(i, 1)];
        if (![ch isEqualToString:@" "])
        {
            [songLetters addObject:ch];
        }
    }
    [songLetters shuffle];
}

- (void)addQuestionButtonsGridWithFrame:(CGPoint)origin showOn:(UIView *)viewToAdd
{
    CGFloat xValue = origin.x;
    CGFloat yValue = origin.y;

    for(int i=0;i<songLetters.count;i++)
    {
        UIButton *WordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [WordButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:questionGridCellSize.width/2]];
        [WordButton setFrame:CGRectMake(xValue, yValue, questionGridCellSize.width, questionGridCellSize.height)];
        [WordButton setBackgroundColor:[UIColor blackColor]];
        [WordButton setTitle:[NSString stringWithFormat:@"%@",songLetters[i]] forState:UIControlStateNormal];
        [WordButton addTarget:self action:@selector(wordClick:) forControlEvents:UIControlEventTouchUpInside];
        
        xValue +=questionGridCellSize.width+5;
        if (xValue > viewToAdd.frame.size.width-questionGridCellSize.width)
        {
            yValue+= questionGridCellSize.height+5;
            xValue = origin.x;
        }
        [viewToAdd addSubview:WordButton];
        [buttons addObject:WordButton];
    }
}

- (void)addAnswerGridWithFrame:(CGPoint)origin showOn:(UIView *)viewToAdd
{
    CGFloat xValue = origin.x;
    CGFloat yValue = origin.y;;
    
    for(int i=0;i<originalWord.length;i++)
    {
        if ([[NSString stringWithFormat:@"%C", [originalWord characterAtIndex:i]] isEqualToString:@" "])
        {
            yValue+= questionGridCellSize.height+5;
            xValue = origin.x;
        }
        else
        {
            AnswerButton *answerLabel = [[AnswerButton alloc]initWithFrame:CGRectMake(xValue, yValue,
                                                                            questionGridCellSize.width, questionGridCellSize.height)];
            
            answerLabel.index = i;
            [answerLabel setTitle:[NSString stringWithFormat:@"%C", [originalWord characterAtIndex:i]] forState:UIControlStateNormal];
            [answerLabel.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:questionGridCellSize.width/2]];
            [answerLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            answerLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
            answerLabel.hidden = YES;
            [answerLabel addTarget:self action:@selector(returnLetter:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(xValue, yValue,
                                                                                 questionGridCellSize.width, questionGridCellSize.height)];
            [bgImage setImage:[UIImage imageNamed:@"roundedSquareCell"]];
            answerLabel.bgImage = bgImage;
            if (i == 0) {
                [bgImage setBackgroundColor:[UIColor redColor]];
            }
                
            xValue +=questionGridCellSize.width+5;
            if (xValue > viewToAdd.frame.size.width-questionGridCellSize.width)
            {
                yValue+= questionGridCellSize.height+5;
                xValue = origin.x;
            }
            [wordLabels addObject:answerLabel];
            [viewToAdd addSubview:bgImage];
            [viewToAdd addSubview:answerLabel];
        }
    }
}

- (IBAction)returnLetter:(id)sender
{
    AnswerButton *letterToReturnButton = (AnswerButton*)sender;
    
    if (letterToReturnButton.hidden == NO)
    {
        letterToReturnButton.hidden = YES;
    }
    UIButton *questionButton = letterToReturnButton.questionButton;
    questionButton.hidden = NO;
    [((AnswerButton*)wordLabels[currentLetterIndex]).bgImage setBackgroundColor:[UIColor clearColor]];
    currentLetterIndex = letterToReturnButton.index;
    [((AnswerButton*)wordLabels[currentLetterIndex]).bgImage setBackgroundColor:[UIColor redColor]];
    
}

- (IBAction)wordClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSString *clickedLetter = btn.currentTitle;

        
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCorrectTile:)])
    {
        [self.delegate didSelectCorrectTile:clickedLetter];
    }
    if (btn.hidden == NO)
    {
        btn.hidden = YES;
    }
    ((AnswerButton*)wordLabels[currentLetterIndex]).questionButton = btn;

    [((UIButton*)wordLabels[currentLetterIndex]) setTitle:[NSString stringWithFormat:@"%@", clickedLetter] forState:UIControlStateNormal];
    
    [((AnswerButton*)wordLabels[currentLetterIndex]).bgImage setBackgroundColor:[UIColor clearColor]];
    if (currentLetterIndex < workingWord.length-1) {
        [((AnswerButton*)wordLabels[currentLetterIndex+1]).bgImage setBackgroundColor:[UIColor redColor]];
    }
    
    [wordLabels[currentLetterIndex] setHidden:false];
    [((UIButton*)wordLabels[currentLetterIndex]).titleLabel setHidden:false];
    currentLetterIndex++;
    
    if (originalWord.length == currentLetterIndex)
    {
        // check if the words are the same
        int i = 0;
        for (UIButton* wordLabel in wordLabels)
        {
            if ([wordLabel.titleLabel.text characterAtIndex:0] != [originalWord characterAtIndex:i])
            {
                if (![wordLabel.titleLabel.text isEqualToString:@" "]) {
                    [self.delegate didFailSolvingPuzzle];
                    return;
                }
            }
            i++;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishSolvingPuzzle)])
        {
            [self.delegate didFinishSolvingPuzzle];
        }
    }
}

@end