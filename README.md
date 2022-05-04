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
Formatter.format('{boolean} {string} {integer} {long} {decimal} {double} {date} {datetime}', new Map<String, Object> {
    'boolean' => true,
    'string' => 'abc',
    'integer' => (Integer) 123,
    'long' => (Long) 456,
    'decimal' => (Decimal) 123.456,
    'double' => (Double) 123.456789,
    'date' => Date.today(),
    'datetime' => Datetime.now()
}));
```

## Author

Isaac Luiz Vieira Ferreira <isaacluizvieiraferreira@id.uff.br>

## License

MIT