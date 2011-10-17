Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1JQRfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:35:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35654 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab1JQRfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:35:53 -0400
Subject: Scheduler BOF @ LinuxCon.EU/ELCE
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        rostedt <rostedt@goodmis.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 17 Oct 2011 19:35:25 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318872925.4172.81.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

several people have expressed interest of talking to me about the
scheduler during the RTLWS/KS/LinuxCon.EU time-frame. Since I've just
about lost track of who all wanted to talk about what and who can and
can not make it out to Prague I need help ;-)

Also, since I'm too dis-organized (and mostly busy) to really arrange
something, can someone volunteer to arrange a BOF or cafe with beer to
discuss things?

The topics I'm most interested in are:

 - power optimized load-balancing;
    do packing based on cpu utilization 
    fix the current interface of sched_{mc,ht}_power_savings

 - integration of the cpufreq/idle governors and the scheduler
    use the idle guestimate for NO_HZ
    use $foo for $prev-topic to reduce double accounting etc.

 - what can we do about the cgroup crap and how can we win some
   of the performance back;
    start with fixing the cgroup enabled but unused case
    continue from there..

    pjt was rewriting load tracking, do tell us about it
        also tell us what the status of ncrao's hackery is,
        or does your hackery replace that?

Things I specifically do not want to talk about:

 - systemd, its shit, go away.
