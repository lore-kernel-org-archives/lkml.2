Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1EQNYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:24:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41961 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab1EQNYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L1nnuQmfF3kw1eOckIufw6ndGHm3i4Es1u7U1rL2AkNarqXj/shp7pCx25wMTA0ssR
         5BYOm4CVpmTWhxHmkFLK173jXY9ArsoU443bsnqzZJpHJ8YM484XuBgijxDUII2sGl3f
         ChwoRTrGJ15bRLr+BwmKVpocnZGpxzOaJ4Ca8=
Message-ID: <4DD2771E.70106@gmail.com>
Date: Tue, 17 May 2011 07:24:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110421 Fedora/3.1.9-2.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Michael Rubin <mrubin@google.com>, Ingo Molnar <mingo@elte.hu>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
References: <1304713252.25414.2532.camel@gandalf.stny.rr.com>	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>	 <20110507065803.GA23414@elte.hu>	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>	 <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo>	 <20110507190033.GA11465@elte.hu> <1304996847.2969.151.camel@frodo>	 <20110510084158.GC27426@elte.hu> <1305032797.2943.34.camel@frodo>	 <20110511215111.GA16355@elte.hu>	 <BANLkTikRX2gNwyUSWLNBcpc727Ww7Ya6Ow@mail.gmail.com> <1305631152.5456.665.camel@gandalf.stny.rr.com>
In-Reply-To: <1305631152.5456.665.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/17/11 05:19, Steven Rostedt wrote:
> On Tue, 2011-05-17 at 00:15 -0700, Michael Rubin wrote:
> 
>> What is the plan for customers going forward? Is it going to involve
>> removing ftrace in favor for perf? Removing perf in favor for ftrace?
>> We love perf and don't want to see it go away either.  We tend to use
>> the two systems differently. Do customers basically have to wait a few
>> years to see not only which system wins but which ones stays on top?
> 
> My plan is:
> 
> 1) get libperf.so out for user tools to use.

libparsevent or libperf? If you really meant libperf will it be a
superset of the event parsing -- like the inclusion of the plugins infra?

David

> 
> 2) Start hacking on code again :)
> 
> But I'll make sure that this will not be a burden on Google. There's no
> reason that Google should be punished for using something that is
> mainline, and using the proper ABIs. The code in ftrace is very flexible
> and tools that use ftrace should still work even if we make internal
> changes.
> 
> I'll work closely with you to make sure that Google's tools will always
> work with future kernels.
> 
>>
>> I apologize if this is obvious to others but I am confused.
> 
> No need to apologize, it's a very confusing situation.
> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
