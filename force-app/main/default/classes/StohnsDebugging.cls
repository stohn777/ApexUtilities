public inherited sharing class StohnsDebugging
{
	private static StohnsDebugging myInstance = null;
	private String title;
	private List<String> output = new List<String>();

	public static StohnsDebugging getInstance()
	{
		if (myInstance == null) myInstance = new StohnsDebugging();
		return myInstance;
	}

	public static StohnsDebugging start()
	{
		return start(null);
	}

	public static StohnsDebugging start(String title)
	{
		myInstance = new StohnsDebugging();
		myInstance.title = title;
		return myInstance;
	}

	public static void dbg(String title, Object item)
	{
		System.debug('<js> ' + title + ':\n' + serializeOutput(item));
	}

	public StohnsDebugging clearItems()
	{
		output.clear();
		return this;
	}

	public StohnsDebugging push(String name, Object item, Boolean serialize)
	{
		output.add(buildOutputForItem(name, item, serialize));
		return this;
	}

	public StohnsDebugging debug()
	{
		debug(output);
		return this;
	}

	public StohnsDebugging debug(String name, Object item, Boolean serialize)
	{
		push(name, item, serialize);
		debug();
		return this;
	}

	public StohnsDebugging debug(List<String> output)
	{
		try
		{
			System.debug('<js> ========== ' + ((String.isNotBlank(title)) ? title : 'Debugging') + ' ==========\n' + String.join(output, '\n'));
		}
		catch (Exception exc)
		{
			System.debug('<js> DEBUGGING ERROR -- Could NOT debug because:\n' + exc.getMessage() + '\n' + exc.getStackTraceString());
		}
		finally
		{
			output.clear();
			title = null;
		}

		return this;
	}

	public StohnsDebugging whereAmI()
	{
		String whereami;

		try
		{
			Integer i = 1/0;
		}
		catch (Exception exc)
		{
			whereami = exc.getStackTraceString();
		}

		push('where am i', whereami, false);
		return this;
	}

	private static String buildOutputForItem(String name, Object item, Boolean serialize)
	{
		String itemString = '**null**';
		if (item != null) itemString = ((serialize) ? serializeOutput(item) : item.toString());

		return 
			'>>>>>>>  ' + 
			name + ':\n' + 
			itemString;
	}

	private static String serializeOutput(Object item)
	{
		try
		{
			return JSON.serializePretty(item);
		}
		catch (Exception exc)
		{
			return '** Could NOT serialize the item **\n' + item.toString();
		}
	}
}