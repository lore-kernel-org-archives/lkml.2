Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2ADJYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:24:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34791 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2ADJYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:24:16 -0500
References: <20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au> <1323880322.23971.33.camel@gandalf.stny.rr.com> <4EE8D305.8020407@zytor.com> <20111222163304.26be6d0f5e514fefb078c0a6@canb.auug.org.au> <20120104190613.2e76daaa000ccf61121fdcc1@canb.auug.org.au>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120104190613.2e76daaa000ccf61121fdcc1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: build warnings after merge of the final tree
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Wed, 04 Jan 2012 01:23:11 -0800
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Message-ID: <f5643ab8-9ba0-4ee6-b61e-403f03525a46@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought it had been...?  Need to investigate (as baby permits...)

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>Hi again,
>
>On Thu, 22 Dec 2011 16:33:04 +1100 Stephen Rothwell
><sfr@canb.auug.org.au> wrote:
>>
>> On Wed, 14 Dec 2011 08:47:01 -0800 "H. Peter Anvin" <hpa@zytor.com>
>wrote:
>> >
>> > On 12/14/2011 08:32 AM, Steven Rostedt wrote:
>> > > On Wed, 2011-12-14 at 18:15 +1100, Stephen Rothwell wrote:
>> > > 
>> > >> Maybe caused by commit d5e553d6e0a4 ("trace: Include
><asm/asm-offsets.h>
>> > >> in trace_syscalls.c") from the tip tree.  These warnings may
>have been
>> > >> here for a while as it is hard to catch the new ones among the
>flood.
>> > >>
>> > > 
>> > > hpa,
>> > > 
>> > > Was this change only needed for x86? If so, could you put that
>into
>> > > asm/ftrace.h instead?
>> > 
>> > Yes (on both accounts).  It was part of the syscall changes; I'll
>move
>> > the include.
>> 
>> Ping?
>
>Can we please have this fixed ...
>-- 
>Cheers,
>Stephen Rothwell                    sfr@canb.auug.org.au
>http://www.canb.auug.org.au/~sfr/

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
