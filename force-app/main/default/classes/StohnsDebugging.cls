public inherited sharing class StohnsDebugging
{
	private static Map<String, StohnsDebugging> instanceMap = new Map<String, StohnsDebugging>();
	private String instanceName;
	private List<String> output = new List<String>();

	public static StohnsDebugging getInstance()
	{
		return getInstance(null);
	}

	public static StohnsDebugging getInstance(String name)
	{
		return start(name);
	}

	public static StohnsDebugging start()
	{
		return start(null);
	}

	public static StohnsDebugging start(String instanceName)
	{
		String instanceNameLowerCase = instanceName?.toLowerCase();

		if (!instanceMap.containsKey(instanceNameLowerCase))
		{
			StohnsDebugging sdb = new StohnsDebugging();
			sdb.instanceName = instanceName;
			instanceMap.put(instanceNameLowerCase, sdb);
		}
		return instanceMap.get(instanceNameLowerCase);
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

	public StohnsDebugging push(String name, Object item)
	{
		return push(name, item, true);
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

	public StohnsDebugging debug(String name, Object item)
	{
		return debug(name, item, true);
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
			System.debug('<js> ========== ' + ((String.isNotBlank(instanceName)) ? instanceName : 'Debugging') + ' ==========\n' + String.join(output, '\n'));
		}
		catch (Exception exc)
		{
			System.debug('<js> DEBUGGING ERROR -- Could NOT debug because:\n' + exc.getMessage() + '\n' + exc.getStackTraceString());
		}
		finally
		{
			output.clear();
			instanceName = null;
		}

		return this;
	}

	public StohnsDebugging whereAmI()
	{
		push('where am i', doWhereAmI(), false);
		return this;
	}

	public static void whereAmI_static()
	{
		System.debug('<js> where am i:\n' + doWhereAmI());
	}

	private static String doWhereAmI()
	{
		try
		{
			throw new StohnsDebuggingException();
		}
		catch (StohnsDebuggingException sde)
		{
			return sde.getStackTraceString();
		}
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

	public class StohnsDebuggingException
		extends Exception
	{
		// intentionally blank
	}
}