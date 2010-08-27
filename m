Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0H0PiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:38:01 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45095 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab0H0PiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:38:00 -0400
X-AuditID: b753bd60-a60ccba000005dcc-3d-4c77dbd3b783
Message-ID: <4C77DBD0.8090808@hitachi.com>
Date: Sat, 28 Aug 2010 00:37:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv11 2.6.36-rc2-tip 10/15] 10: tracing: config option to
 enable both kprobe-tracer and uprobe-tracer.
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6> <20100825134315.5447.96501.sendpatchset@localhost6.localdomain6> <4C76038A.40400@hitachi.com> <20100827093135.GI14431@linux.vnet.ibm.com> <4C779BDB.70003@hitachi.com> <20100827121758.GA5444@linux.vnet.ibm.com>
In-Reply-To: <20100827121758.GA5444@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/08/27 21:17), Srikar Dronamraju wrote:
>>>
>>> I think we should go with the first one, i.e have a common knob thats
>>> by default unselected.
>>
>> Yeah, I'm OK to have a common knob, but I just don't like to set
>> KPROBE_EVENT unselected by default. I think there is no reason
>> to change default selecting (currently, KPROBE_EVENT=y by default.)
> 
> I understand your concern.
> 
>>
>> So, I think we should have below selecting list;
>> --- Tracers
>> ...
>> [*] Enable dynamic events
>>    [ ] Enable user-space dynamic events (EXPERIMENTAL)
>> ...
>>
>> What would you think about this ? :)
>>
>> Thank you,
> 
> 
> Wouldnt it negate the purpose of common knob?
> Because people would still have go and select UPROBE_EVENTS,

Hmm, I think this just seems an enhancement of dynamic events,
and also you can enable it by default on some point.
I mean, eventually, there will be only "Enable dynamic events"
on the screen.

> I think when Frederic asked for a common knob, he was looking at
> enabling both or disabling both and an option to selectively
> select one of the tracers. 

Yeah, but I'd like to ask Frederic that he expected disabling
KPROBE_EVENT by default too, even though it changes current
default config.

Thank you,
