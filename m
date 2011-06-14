Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab1FNBZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:25:21 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55565 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1FNBZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:25:19 -0400
X-AuditID: b753bd60-a50caba000003bac-3a-4df6b87cad13
X-AuditID: b753bd60-a50caba000003bac-3a-4df6b87cad13
Message-ID: <4DF6B878.3060903@hitachi.com>
Date: Tue, 14 Jun 2011 10:25:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 15/15] tracing/kprobes: Fix kprobe-tracer to support stack
 trace
References: <20110609172744.333794089@goodmis.org>	 <20110609172914.290174627@goodmis.org> <20110613102118.GF30962@elte.hu>	 <1307965484.9218.59.camel@gandalf.stny.rr.com>	 <20110613115051.GE10960@elte.hu> <1307967287.9218.64.camel@gandalf.stny.rr.com>
In-Reply-To: <1307967287.9218.64.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/13 21:14), Steven Rostedt wrote:
> On Mon, 2011-06-13 at 13:50 +0200, Ingo Molnar wrote:
>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>>>> +	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count(),
>>>>> +			     NULL);
>>>>
>>>> pointless linebreak.
>>>
>>> Again, probably to do with the 80 char limit.
>>
>> Well, the point of the 80 char limit warning these days is to force a 
>> cleanup of the code. Breaking the line mindlessly *uglifies* the code 
>> so it's pointless to do it.
>>
>> In terms of terminal readability line length up to 90-100 cols is 
>> acceptable for code that is otherwise not ugly.
> 
> I totally agree. I've just had arguments with others that are more 80
> character nazi than I am. ;)

I see, nowadays most of laptops has a wide screen (16:9) :P


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
