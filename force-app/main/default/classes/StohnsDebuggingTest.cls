@IsTest
private class StohnsDebuggingTest
{
    @IsTest
    private static void test()
    {
        Contact c = new Contact(
            FirstName='Waldo',
            LastName='Schultz',
            Description='Some random contact for testing',
            Email='waldo.schultz@email.com'
        );

        StohnsDebugging.start('This is a test')
            .whereAmI()
            .push('hello world', 'nice day, aye')
            .push('simple text', 'hello world', false)
            .push('contact', c, true);

        StohnsDebugging.getInstance()
            .debug();

        StohnsDebugging.start().debug('contact again', c, true);

        StohnsDebugging.whereAmI_static();
    }
}
