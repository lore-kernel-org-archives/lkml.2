Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1FMRZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:25:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab1FMRZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:25:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [Bug #37222] 3.0.0-rc1-git3 -- kernel/sched.c:619 invoked rcu_dereference_check() without protection!
Date: Mon, 13 Jun 2011 19:26:58 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Miles Lane <miles.lane@gmail.com>
References: <vv0uv79EvLN.A.jiC.pNS9NB@chimera> <BANLkTikjZ7O6SFmD2e-YnMztGHoGZL69qg@mail.gmail.com> <1307930406.4011.3.camel@minggr.sh.intel.com>
In-Reply-To: <1307930406.4011.3.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106131926.58954.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 13, 2011, Lin Ming wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Date: Mon, Jun 13, 2011 at 4:30 AM
> > Subject: [Bug #37222] 3.0.0-rc1-git3 -- kernel/sched.c:619 invoked
> > rcu_dereference_check() without protection!
> > To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Maciej
> > Rutecki <maciej.rutecki@gmail.com>, Florian Mickler
> > <florian@mickler.org>, Miles Lane <miles.lane@gmail.com>
> > 
> > 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.39.  Please verify if it still should be listed and let the
> > tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=37222
> > Subject         : 3.0.0-rc1-git3 -- kernel/sched.c:619 invoked
> > rcu_dereference_check() without protection!
> > Submitter       : Miles Lane <miles.lane@gmail.com>
> > Date            : 2011-06-04 3:22 (9 days old)
> > Message-ID      : <BANLkTikHS7TuFhm3cfJ+Y=erWDaAwuE_TA@mail.gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=130715775803343&w=2
> > 
> 
> This was fixed already.
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=6c6c54e180
> 
> commit 6c6c54e1807faf116724451ef2bd14993780470a
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Jun 3 17:37:07 2011 +0200
> 
>     sched: Fix/clarify set_task_cpu() locking rules

Thanks, closing.

Rafael
