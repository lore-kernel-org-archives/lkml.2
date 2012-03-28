Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2C1Mlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:41:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44338 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2C1Mln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:41:43 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20120328122135.GD17189@somewhere.redhat.com>
References: <alpine.DEB.2.00.1203210953220.20482@router.home>
	<20120327121341.GE13196@somewhere>
	<alpine.DEB.2.00.1203271111110.1170@router.home>
	<1332865469.23924.129.camel@gandalf.stny.rr.com>
	<alpine.DEB.2.00.1203271939170.11825@router.home>
	<1332896805.23924.148.camel@gandalf.stny.rr.com>
	<alpine.DEB.2.00.1203272013260.13193@router.home>
	<1332898535.23924.157.camel@gandalf.stny.rr.com>
	<1332904677.23924.174.camel@gandalf.stny.rr.com>
	<CAOtvUMen0N1rTa3b4KtK+Aw6nV_=3DMq2RB5CE5smSJDFtGrfA@mail.gmail.com>
	<20120328122135.GD17189@somewhere.redhat.com>
Date: Wed, 28 Mar 2012 14:41:42 +0200
Message-ID: <CAOtvUMeF4aB+1dHOGYvsp+VP+VK_TFEnagVpVvkbBTi50m_=nA@mail.gmail.com>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs it
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 2:21 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Mar 28, 2012 at 09:55:37AM +0200, Gilad Ben-Yossef wrote:
|
>> At the risk of butting in on this little flame war, I think it is
>> worth mentioning
>> that this discussion arouse in the context of of a feature
>> (cpuset/nohz) that deals
>> with a single task running alone on a CPU and making zero use of
>> kernel services,
>> from scheduling, through interrupts, to system calls. It's just a pure
>> 100% cpu  bound task.
>
> Note that cpu isolation is a specific usecase of nohz cpusets. But it's
> intended to be more generally useful (probably for most workloads). That
> means we really want to support syscalls, interrupts and everything. That's
> why it is called adaptive tickless and not just userspace isolated tickless.

Point taken.  I guess I suffer from myopic vision just like the next guy  :-)

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
