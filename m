Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0ELTvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:51:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56420 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab0ELTvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:51:47 -0400
Date: Wed, 12 May 2010 12:51:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: [GIT PULL] RCU lockdep splat fix for new perf code
Message-ID: <20100512195142.GA13648@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Recent code added an RCU lockdep splat.  This pull request contains
a single commit that fixes this splat.

Please note that pull is based off of the point in the -tip tree where
the splat was detected, as the offending code is not present at the
usual tip/core/urgent or tip/core/rcu locations.

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

							Thanx, Paul

------------------>
 Paul E. McKenney (1)
	 perf: fix find_swevent_head() RCU lockdep splat

 kernel/perf_event.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)
