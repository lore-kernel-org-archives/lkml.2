Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1HPOpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:45:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48571 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab1HPOpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:45:23 -0400
Message-ID: <4E4A7BE3.5090902@us.ibm.com>
Date: Tue, 16 Aug 2011 07:17:07 -0700
From: Nivedita Singhvi <niv@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
References: <1313232790.25267.7.camel@twins> <1313236135.4486.10.camel@marge.simson.net> <1313236713.25267.10.camel@twins> <1313243965.4486.36.camel@marge.simson.net> <20110813162735.GA2650@linux.vnet.ibm.com> <1313295821.6334.5.camel@marge.simson.net>
In-Reply-To: <1313295821.6334.5.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sat, 2011-08-13 at 09:27 -0700, Paul E. McKenney wrote:
> 
>> Strange.  By the time it got around to printing the stall, no one was
>> stalling:
>>
>> [  100.409012] INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by 21, t=60002 jiffies)
>>
>> Now it -is- possible for the stall to end just as we get ready to detect
>> it, but that window is really really small.  The most recent occurrence
>> of this sort of thing was due misconfigured timekeeping, but I don't see
>> any sign of that in the trace.
>>
>> This happens repeatedly?
> 
> Yeah.  When I put -rt9 on the UV box, it was doing the just idling, and
> boom thing I saw with earlier releases on both my Q6600 and x3550 M3
> boxes.  -rt10 seems to have just changed the timing.
> 
> I'll update the x3550 M3, and see if it still gripes.  UV isn't virgin
> source, has to be twiddled a little. (symptom was identical though)

Mike,

Which test were you running? Because I'm not seeing it
on our x3550 M3..

thanks,
Nivedita
