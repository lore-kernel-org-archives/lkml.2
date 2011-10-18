Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1JRJ4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:56:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51766 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1JRJ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:56:47 -0400
MIME-Version: 1.0
In-Reply-To: <4E9D4887.4030003@parallels.com>
References: <1318872925.4172.81.camel@twins>
	<4E9D4887.4030003@parallels.com>
Date: Tue, 18 Oct 2011 15:26:46 +0530
Message-ID: <CA+dVeiaXmrwJkfAcc9dq0fnOrToict_gBPx2Te4r4KkuwRoWOA@mail.gmail.com>
Subject: Re: Scheduler BOF @ LinuxCon.EU/ELCE
From: selva vinayakam <selvavinayak88@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        rostedt <rostedt@goodmis.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
 i am new to this mailing list and i am a beginner in this kernel
development circle
if any body guide me that is useful for me also to give my effort to
that building a kernel

On 18/10/2011, Glauber Costa <glommer@parallels.com> wrote:
> On 10/17/2011 09:35 PM, Peter Zijlstra wrote:
>> Hi,
>>
>> several people have expressed interest of talking to me about the
>> scheduler during the RTLWS/KS/LinuxCon.EU time-frame. Since I've just
>> about lost track of who all wanted to talk about what and who can and
>> can not make it out to Prague I need help ;-)
>>
>> Also, since I'm too dis-organized (and mostly busy) to really arrange
>> something, can someone volunteer to arrange a BOF or cafe with beer to
>> discuss things?
>>
>> The topics I'm most interested in are:
>>
>>   - power optimized load-balancing;
>>      do packing based on cpu utilization
>>      fix the current interface of sched_{mc,ht}_power_savings
>>
>>   - integration of the cpufreq/idle governors and the scheduler
>>      use the idle guestimate for NO_HZ
>>      use $foo for $prev-topic to reduce double accounting etc.
>>
>>   - what can we do about the cgroup crap and how can we win some
>>     of the performance back;
>>      start with fixing the cgroup enabled but unused case
>>      continue from there..
>
> definitely count me in for that.
>
> I won't be in for KS, just linuxcon, and I am busy on Wed 26th.
> I believe Steve Roasted's (*) suggestion is a sane one: Many of us
> will be in other meetings during this time frame, so maybe is saner to
> find a free slot in the conference agenda.
>
> (*) not a typo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
