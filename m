Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2DGJzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 05:55:50 -0400
Received: from mta-1.ms.rz.rwth-aachen.de ([134.130.7.72]:44295 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237Ab2DGJzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 05:55:48 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2012 05:55:48 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
X-IronPort-AV: E=Sophos;i="4.75,385,1330902000";   d="scan'208";a="172457069"
Subject: Re: [RFC][PATCH 00/16] sched: SCHED_DEADLINE v4
From: Tadeus Prastowo <tadeus.prastowo@rwth-aachen.de>
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
In-reply-to: <1333700751.6646.9.camel@localhost>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
 <1333700751.6646.9.camel@localhost>
Date: Sat, 07 Apr 2012 16:25:31 +0700
Message-id: <1333790731.2292.474.camel@0x657573>
X-Mailer: Evolution 2.30.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone!

On Fri, 2012-04-06 at 10:25 +0200, Luca Abeni wrote:

[...]

> About BWI... A student of mine (added in cc) implemented a prototypal
> bandwidth inheritance (based on an old version of SCHED_DEADLINE). It is
> here:
> https://github.com/eus/cbs_inheritance
> (Tadeus, please correct me if I pointed to the wrong repository).

The repository is correct.

> It is not for inclusion yet (it is based on an old version, it is UP
> only, and it probably needs some cleanups), but it worked fine in our
> tests. Note that in this patch the BWI mechanism is not bound to
> rtmutexes, but inheritance is controlled through 2 syscalls (because we
> used BWI for client/server interactions).
> Anyway, I hope that the BWI code developed by Tadeus can be useful (or
> can be directly re-used) for implementing BWI in SCHED_DEADLINE.

For inclusion, I think the interaction between the two system calls and
RT-mutex subsystem needs some thoughts especially when multi-cores are
involved. I haven't given further thought on this matter upon the
completion of my thesis work, especially in taking into account Dario's
M-BWI approach.

For UP, the BWI syscalls implementation in the aforementioned branch
does not have Dario's BWI implementation for mutexes. And interaction
between the BWI syscalls and RT-Mutex has not been taken into account.

Happy Easter to all of you who celebrate it!

> 				Luca

-- 
Sincerely yours,
Tadeus Prastowo

