Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1DLTjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:39:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41512 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1DLTjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=dELELYnBozhJiq845q5UICgP/LSFb6EGDR3ReopN8sQTjn2U0kQfzKUNldlsv2IXnM
         x0YRqlOhBtWmzzae4eXWnA4TaiBsFEDPSrGHKTv+7V3x+DzoK/VjPteZe+rru8JGPQ2b
         y6ZS4mQibzpmjV7NWUX/OjSUJhmRbxf1q9iDo=
Message-ID: <4DA4AA72.4070904@gmail.com>
Date: Tue, 12 Apr 2011 13:39:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: adding trace-cmd's plugins to perf
References: <4DA12905.2020806@gmail.com> <20110412162245.GB2240@nowhere> <20110412183536.GA20452@ghostprotocols.net> <20110412185104.GA9891@liondog.tnic> <20110412185652.GB20452@ghostprotocols.net> <20110412190150.GC9891@liondog.tnic>
In-Reply-To: <20110412190150.GC9891@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/12/11 13:01, Borislav Petkov wrote:
>>> Also, just FYI, I have this RAS daemon patchset which splits perf functionality
>>> into different sub-libs, which are more or less topic based:
>>>
>>> tools/lib/trace/ - all the trace-event* stuff from Steven
>>> tools/lib/lk/	- generic enough stuff (git headers, etc) which several tools could use

Is this going to contain the option parsing as well? e.g., something
tools/kvm is picking up from perf.


>>> tools/lib/perf/ - functionality related to perf events
>>>
>>> Here's the last submission http://marc.info/?l=linux-edac&m=129562244211501&w=2
>>> and I'm currently finishing a new rebase against tip/perf/core.
>>>
>>> If you're fine with that split I'd suggest I load off my stuff first so
>>> that David can continue from there and I can finally stop rebasing like
>>> crazy each time perf moves forward.
>>>
>>> Opinions? Suggestions?
>>
>> Yeah, David, can you try Borislav's patchset and tell us what you think
>> wrt servicing your needs?
> 
> Yeah, but first let me post the latest version - I'll try to do so in
> the next couple of days.
> 
> Thanks.
> 

Sure. This is a background task, and I still need to spend time on
trace-cmd to understand it. ie. it's not something I expect to do within
the next week -- more like within the next month if I get the time.

David
