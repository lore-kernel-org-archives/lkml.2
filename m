Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2DFIeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:34:14 -0400
Received: from mail0.unitn.it ([193.205.206.51]:34543 "EHLO mail0.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab2DFIeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:34:12 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2012 04:34:12 EDT
Subject: Re: [RFC][PATCH 00/16] sched: SCHED_DEADLINE v4
From: Luca Abeni <luca.abeni@unitn.it>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com,
        Tadeus Prastowo <tadeus.prastowo@rwth-aachen.de>
In-Reply-To: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2012 10:25:51 +0200
Message-Id: <1333700751.6646.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> Hello everyone,
> 
> This is the take 4 for the SCHED_DEADLINE patchset.
[...]
> Still missing/incomplete:
>   - (c)group based bandwidth management, and maybe scheduling. It seems
>     some more discussion on what precisely we want is *really* needed
>     for this point;
>   - bandwidth inheritance (to replace deadline/priority inheritance).
>     What's in the patchset is just very few more than a simple
>     placeholder. More discussion on the right way to go is needed here.
>     Some work has already been done, but it is still not ready for
>     submission.
About BWI... A student of mine (added in cc) implemented a prototypal
bandwidth inheritance (based on an old version of SCHED_DEADLINE). It is
here:
https://github.com/eus/cbs_inheritance
(Tadeus, please correct me if I pointed to the wrong repository).

It is not for inclusion yet (it is based on an old version, it is UP
only, and it probably needs some cleanups), but it worked fine in our
tests. Note that in this patch the BWI mechanism is not bound to
rtmutexes, but inheritance is controlled through 2 syscalls (because we
used BWI for client/server interactions).
Anyway, I hope that the BWI code developed by Tadeus can be useful (or
can be directly re-used) for implementing BWI in SCHED_DEADLINE.

BTW, happy Easter to everyone!

				Luca

