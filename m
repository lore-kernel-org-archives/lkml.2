Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab1IHTX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 15:23:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:35990 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1IHTXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 15:23:23 -0400
Date: Thu, 8 Sep 2011 21:23:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Lin Ming <mlin@ss.pku.edu.cn>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/55] Preview of RCU changes for 3.2
In-Reply-To: <20110908174139.GL2671@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1109082122230.2723@ionos>
References: <20110906180015.GA2560@linux.vnet.ibm.com> <CAF1ivSZ_THTHMPhXcPSJovxoi1WBvpr07ktMuYL39oode8kz0w@mail.gmail.com> <20110908174139.GL2671@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011, Paul E. McKenney wrote:

> On Wed, Sep 07, 2011 at 10:39:57PM +0800, Lin Ming wrote:
> > On Wed, Sep 7, 2011 at 2:00 AM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > >
> > > For a testing-only version of this patchset from git, please see the
> > > following subject-to-rebase (and subject-to-Hera-availability) branch:
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing
> > 
> > kernel.org is still down.
> > Would you put the tree somewhere else(maybe github.com)?
> 
> Hello, Lin,
> 
> I am unlikely to figure out why github doesn't like me by the end of
> the week, so please feel free to post the patches somewhere.  If you
> have a -tip tree handy, you could apply them on top of tip/master.
> If you don't have a -tip tree handy, they should also apply cleanly
> onto v3.0.

  git://tesla.tglx.de/git/linux-2.6-tip

Just in case.

     tglx
