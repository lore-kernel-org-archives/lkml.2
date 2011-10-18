Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1JRHOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:14:53 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53932 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1JRHOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <1318872925.4172.81.camel@twins>
References: <1318872925.4172.81.camel@twins>
Date: Tue, 18 Oct 2011 09:14:51 +0200
Message-ID: <CAKfTPtCKjfPJS_Q65GJG+8xG_O8DnPff6O2MUBRsVVzfv-=_5g@mail.gmail.com>
Subject: Re: Scheduler BOF @ LinuxCon.EU/ELCE
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        rostedt <rostedt@goodmis.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2011 19:35, Peter Zijlstra <peterz@infradead.org> wrote:
> Hi,
>
> several people have expressed interest of talking to me about the
> scheduler during the RTLWS/KS/LinuxCon.EU time-frame. Since I've just
> about lost track of who all wanted to talk about what and who can and
> can not make it out to Prague I need help ;-)
>

I will attend the ELCE and I'm interested by scheduler discussion

> Also, since I'm too dis-organized (and mostly busy) to really arrange
> something, can someone volunteer to arrange a BOF or cafe with beer to
> discuss things?
>
> The topics I'm most interested in are:
>
>  - power optimized load-balancing;
>    do packing based on cpu utilization
>    fix the current interface of sched_{mc,ht}_power_savings

I'm also interested

>
>  - integration of the cpufreq/idle governors and the scheduler
>    use the idle guestimate for NO_HZ
>    use $foo for $prev-topic to reduce double accounting etc.

I'm also interested

>
>  - what can we do about the cgroup crap and how can we win some
>   of the performance back;
>    start with fixing the cgroup enabled but unused case
>    continue from there..
>
>    pjt was rewriting load tracking, do tell us about it
>        also tell us what the status of ncrao's hackery is,
>        or does your hackery replace that?
>
> Things I specifically do not want to talk about:
>
>  - systemd, its shit, go away.
>
