Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab0FPGYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:24:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab0FPGYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:24:00 -0400
Subject: Re: [GIT PULL rcu/urgent] yet more lockdep-RCU splat fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, daniel.blueman@gmail.com, lizf@cn.fujitsu.com,
       miles.lane@gmail.com, manfred@colorfullife.com
In-Reply-To: <20100616055358.GB17936@elte.hu>
References: <20100616042224.GA3892@linux.vnet.ibm.com>
	 <20100616055358.GB17936@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 08:23:51 +0200
Message-ID: <1276669431.1745.595.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 07:53 +0200, Ingo Molnar wrote:
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello, Ingo,
> > 
> > Here are a few more fixes for RCU-lockdep splats.
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> > 
> > This is based off of v2.6.35-rc3.
> > 
> > 							Thanx, Paul
> > 
> > ------------------>
> > Daniel J Blueman (1):
> >       rcu: fix lockdep splat in wake_affine()
> > 
> > Paul E. McKenney (2):
> >       rcu: fix scope of wake_affine()'s new RCU read-side critical section
> >       idr: fix RCU lockdep splat in idr_get_next()
> > 
> >  kernel/sched_fair.c |    2 ++
> >  lib/idr.c           |    4 ++--
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> Pulled, thanks a lot Paul!

I'm not at all sure of those two wake_affine() ones..
