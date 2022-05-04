@isTest
public class FormatterTest {    
    @isTest 
    public static void format () {
        String output = Formatter.format('Hello, World!', new Map<String, String>());
        
        System.assertEquals('Hello, World!', output);
    }
    
    @isTest 
    public static void formatWithArguments () {
        String output = Formatter.format('Hello, {name}! Welcome to {city}!', new Map<String, String> {
            'name' => 'John',
            'city' => 'New York'
        });
        
        System.assertEquals('Hello, John! Welcome to New York!', output);
    }
    
    @isTest 
    public static void formatWithIntegerArguments () {
        String output = Formatter.format('{x} + {y} = {z}', new Map<String, Integer> {
            'x' => 2,
            'y' => 3,
            'z' => 5
        });
        
        System.assertEquals('2 + 3 = 5', output);
    }
    
    @isTest 
    public static void formatWithArgumentsContainingWhiteSpaces () {
        String output = Formatter.format('My favorite country is {country name}. What is yours, {friend name}?', new Map<String, String> {
            'friend name' => 'Paul',
            'country name' => 'England'
        });
        
        System.assertEquals('My favorite country is England. What is yours, Paul?', output);
    }
    
    class Person {
        public String firstName;
        public String lastName;
        
        public Person (String firstName, String lastName) {
            this.firstName = firstName;
            this.lastName = lastName;
        }
        
        public override String toString () {
            return firstName + ' ' + lastName;
        }
    }
    
    @isTest 
    public static void formatWithObjectArgument () {        
        String output = Formatter.format('Hi, {person}!', new Map<String, Object> {
            'person' => new Person('John', 'Doe')
        });
        
        System.assertEquals('Hi, John Doe!', output);
    }
    
    @isTest 
    public static void formatWithEmptyArgument () {
        Boolean exceptionWasThrown = false;
        
        try {
            Formatter.format('I work at {}.', new Map<String, String> {});
        } catch (Formatter.FormatterException ex) {
            exceptionWasThrown = true;
        }
        
        System.assert(exceptionWasThrown);
    }
    
    @isTest 
    public static void formatWithUndefinedArgument () {
        Boolean exceptionWasThrown = false;
        
        try {
            Formatter.format('I work at {company}.', new Map<String, String> {});
        } catch (Formatter.FormatterException ex) {
            exceptionWasThrown = true;
        }
        
        System.assert(exceptionWasThrown);
    }
    
    @isTest 
    public static void formatWithNullArgument () {
        Boolean exceptionWasThrown = false;
        
        try {
            Formatter.format('I work at {company}.', new Map<String, String> {
                'company' => null
            });
        } catch (Formatter.FormatterException ex) {
            exceptionWasThrown = true;
        }
        
        System.assert(exceptionWasThrown);
    }
    
    @isTest 
    public static void formatWithUnclosedArgument () {
        Boolean exceptionWasThrown = false;
        
        try {
            Formatter.format('I have a dog called {name', new Map<String, String> {
                'name' => 'Bob'
            });
        } catch (Formatter.FormatterException ex) {
            exceptionWasThrown = true;
        }
        
        System.assert(exceptionWasThrown);
    }
    
    @isTest 
    public static void formatWithUnopenedArgument () {
        Boolean exceptionWasThrown = false;
        
        try {
            Formatter.format('I have a dog called name}', new Map<String, String> {
                'name' => 'Bob'
            });
        } catch (Formatter.FormatterException ex) {
            exceptionWasThrown = true;
        }
        
        System.assert(exceptionWasThrown);
    }
    
    @isTest 
    public static void formatWithArgumentOpenedTwice () {
        Boolean exceptionWasThrown = false;
        
        try {
            Formatter.format('I have a dog called {{name}', new Map<String, String> {
                'name' => 'Bob'
            });
        } catch (Formatter.FormatterException ex) {
            exceptionWasThrown = true;
        }
        
        System.assert(exceptionWasThrown);
    }
    
    @isTest 
    public static void formatWithArgumentClosedTwice () {
        Boolean exceptionWasThrown = false;
        
        try {
            Formatter.format('I have a dog called {name}}', new Map<String, String> {
                'name' => 'Bob'
            });
        } catch (Formatter.FormatterException ex) {
            exceptionWasThrown = true;
        }
        
        System.assert(exceptionWasThrown);
    }
    
    @isTest 
    public static void formatWithArgumentOpenedAndClosedTwice () {
        Boolean exceptionWasThrown = false;
        
        try {
            Formatter.format('I have a dog called {{name}}', new Map<String, String> {
                'name' => 'Bob'
            });
        } catch (Formatter.FormatterException ex) {
            exceptionWasThrown = true;
        }
        
        System.assert(exceptionWasThrown);
    }
}