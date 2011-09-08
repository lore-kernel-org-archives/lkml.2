Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1IHX0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:26:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44989 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1IHX0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:26:37 -0400
Date: Thu, 8 Sep 2011 10:41:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/55] Preview of RCU changes for 3.2
Message-ID: <20110908174139.GL2671@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <CAF1ivSZ_THTHMPhXcPSJovxoi1WBvpr07ktMuYL39oode8kz0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1ivSZ_THTHMPhXcPSJovxoi1WBvpr07ktMuYL39oode8kz0w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 10:39:57PM +0800, Lin Ming wrote:
> On Wed, Sep 7, 2011 at 2:00 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > For a testing-only version of this patchset from git, please see the
> > following subject-to-rebase (and subject-to-Hera-availability) branch:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing
> 
> kernel.org is still down.
> Would you put the tree somewhere else(maybe github.com)?

Hello, Lin,

I am unlikely to figure out why github doesn't like me by the end of
the week, so please feel free to post the patches somewhere.  If you
have a -tip tree handy, you could apply them on top of tip/master.
If you don't have a -tip tree handy, they should also apply cleanly
onto v3.0.

							Thanx, Paul
