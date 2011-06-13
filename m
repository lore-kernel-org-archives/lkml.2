Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1FMB5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 21:57:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:24267 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab1FMB5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 21:57:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,356,1304319600"; 
   d="scan'208";a="13596577"
Subject: Re: [Bug #37222] 3.0.0-rc1-git3 -- kernel/sched.c:619 invoked
 rcu_dereference_check() without protection!
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Miles Lane <miles.lane@gmail.com>
In-Reply-To: <BANLkTikjZ7O6SFmD2e-YnMztGHoGZL69qg@mail.gmail.com>
References: <vv0uv79EvLN.A.jiC.pNS9NB@chimera>
	 <JL7O0m0yLjL.A.u0C.0NS9NB@chimera>
	 <BANLkTikjZ7O6SFmD2e-YnMztGHoGZL69qg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 10:00:06 +0800
Message-ID: <1307930406.4011.3.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Rafael J. Wysocki <rjw@sisk.pl>
> Date: Mon, Jun 13, 2011 at 4:30 AM
> Subject: [Bug #37222] 3.0.0-rc1-git3 -- kernel/sched.c:619 invoked
> rcu_dereference_check() without protection!
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Maciej
> Rutecki <maciej.rutecki@gmail.com>, Florian Mickler
> <florian@mickler.org>, Miles Lane <miles.lane@gmail.com>
> 
> 
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the
> tracking team
> know (either way).
> 
> 
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=37222
> Subject         : 3.0.0-rc1-git3 -- kernel/sched.c:619 invoked
> rcu_dereference_check() without protection!
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2011-06-04 3:22 (9 days old)
> Message-ID      : <BANLkTikHS7TuFhm3cfJ+Y=erWDaAwuE_TA@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=130715775803343&w=2
> 

This was fixed already.
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=6c6c54e180

commit 6c6c54e1807faf116724451ef2bd14993780470a
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Jun 3 17:37:07 2011 +0200

    sched: Fix/clarify set_task_cpu() locking rules


Thanks,
Lin Ming

