public inherited sharing class StohnsDebugging
{
	private static StohnsDebugging myInstance = null;
	private String title;
	private List<StohnsDebuggingItem> items = new List<StohnsDebuggingItem>();

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
		myInstance = StohnsDebugging.getInstance();
		myInstance.title = title;
		return myInstance;
	}

	public StohnsDebugging clearItems()
	{
		items.clear();
		return this;
	}

	public StohnsDebugging push(String name, Object item, Boolean serialize)
	{
		items.add(new StohnsDebuggingItem(name, item, serialize));
		return this;
	}

	public StohnsDebugging debug()
	{
		debug(items);
		clearItems();
		return this;
	}

	public StohnsDebugging debug(String name, Object item, Boolean serialize)
	{
		debug(new List<StohnsDebuggingItem> { new StohnsDebuggingItem(name, item, serialize) });
		return this;
	}

	public StohnsDebugging debug(List<StohnsDebuggingItem> itemList)
	{
		try
		{
			System.debug('<js> ========== ' + ((String.isNotBlank(title)) ? title : 'Debugging') + ' ==========\n' + String.join(buildOutputForList(itemList), '\n'));
		}
		catch (Exception exc)
		{
			System.debug('<js> DEBUGGING ERROR -- Could NOT debug because:\n' + exc.getMessage() + '\n' + exc.getStackTraceString());
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

	private static List<String> buildOutputForList(List<StohnsDebuggingItem> itemList)
	{
		List<String> output = new List<String>();
		for (StohnsDebuggingItem i : itemList)
		{
			output.add(buildOutputForItem(i.name, i.item, i.serialize));
		}
		return output;
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

	public class StohnsDebuggingItem
	{
		public String name = 'not set';
		public Object item = null;
		public Boolean serialize = false;

		public StohnsDebuggingItem(String name, Object item, Boolean serialize)
		{
			this.name = name;
			this.item = item;
			this.serialize = serialize;
		}
	}
}