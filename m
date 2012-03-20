Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964922Ab2CTGNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 02:13:44 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:59215 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2CTGNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 02:13:43 -0400
Date: Tue, 20 Mar 2012 07:13:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.4
Message-ID: <20120320061339.GA27423@gmail.com>
References: <20120319152317.GA3932@gmail.com>
 <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
 <20120320033300.GH2393@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120320033300.GH2393@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Mon, Mar 19, 2012 at 05:18:21PM -0700, Linus Torvalds wrote:
> > On Mon, Mar 19, 2012 at 8:23 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > > Please pull the latest core-rcu-for-linus git tree from:
> > >
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus
> > 
> > So Ingo, Paul - I'd really have liked to have some high-level
> > user-readable explanation of the changes that I could have put in the
> > merge message.

Yeah, good point - I distilled that list in the merge commit 
itself (see commit bdd4431c8d071491a68a65d9457996f222b5ecd3) - 
should have exported that to the pull request itself:

>From bdd4431c8d071491a68a65d9457996f222b5ecd3 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 28 Feb 2012 10:16:01 +0100
Subject: [PATCH] Merge branch 'rcu/next' of
 git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

The major features of this series are:

 - making RCU more aggressive about entering dyntick-idle mode in order to
   improve energy efficiency

 - converting a few more call_rcu()s to kfree_rcu()s

 - applying a number of rcutree fixes and cleanups to rcutiny

 - removing CONFIG_SMP #ifdefs from treercu

 - allowing RCU CPU stall times to be set via sysfs

 - adding CPU-stall capability to rcutorture

 - adding more RCU-abuse diagnostics

 - updating documentation

 - fixing yet more issues located by the still-ongoing top-to-bottom
   inspection of RCU, this time with a special focus on the
   CPU-hotplug code path.

Thanks,

	Ingo
