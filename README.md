# Formatter: String formatter for Salesforce

This is a string formatter that allows you to format using named arguments instead of indexed arguments. You can format using all primitive types and objects.

## Usage

Format:

```apex
String output = Formatter.format('Hello, {name}! Welcome to {city}!', new Map<String, String> {
    'name' => 'John',
    'city' => 'New York'
});
```

Format with different types:

```apex
String output = Formatter.format('{boolean} {string} {integer} {date}', new Map<String, Object> {
    'boolean' => true,
    'string' => 'abc',
    'integer' => 123,
    'date' => Date.today(),
});
```

## Author

Isaac Luiz Vieira Ferreira <isaacluizvieiraferreira@id.uff.br>

## License

MIT