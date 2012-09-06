Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115Ab2IFAve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:51:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56842 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2IFAvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:51:32 -0400
Message-ID: <5047F390.8020206@gmail.com>
Date: Wed, 05 Sep 2012 18:51:28 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf: clean should remove libtraceevent.a too
References: <1346890240-61205-1-git-send-email-dsahern@gmail.com> <1346892154.27919.83.camel@gandalf.local.home>
In-Reply-To: <1346892154.27919.83.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/12 6:42 PM, Steven Rostedt wrote:
> On Wed, 2012-09-05 at 18:10 -0600, David Ahern wrote:
>> It's built as part of perf, so it should be cleaned too.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> ---
>>   tools/perf/Makefile |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>> index 90d8e09..5f0259e 100644
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -1068,6 +1068,7 @@ clean:
>>   	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
>>   	$(RM) $(OUTPUT)util/*-bison*
>>   	$(RM) $(OUTPUT)util/*-flex*
>> +	$(RM) $(LIBTRACEEVENT)
>>   	$(python-clean)
>
> Actually, this should do the clean in the tools/lib/traceevent
> directory, as this change wont clean the objects created.
>
> -- Steve
>
>

Indeed. update coming.
