Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1GHA3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 20:29:16 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55475 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1GHA3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 20:29:14 -0400
Date: Thu, 7 Jul 2011 17:29:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: julie Sullivan <kernelmail.jms@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, torvalds@linux-foundation.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110708002903.GI6014@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com>
 <201107072047.14429.kernelmail.jms@gmail.com>
 <20110707195845.GD6014@linux.vnet.ibm.com>
 <201107072147.12751.kernelmail.jms@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107072147.12751.kernelmail.jms@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 09:47:03PM +0100, julie Sullivan wrote:
> > What happens if you revert only these two?
> > 
> > f8b7fc6b514f34a51875dd48dff70d4d17a54f38 rcu: Move RCU_BOOST #ifdefs to
> > header f a46e0899eec7a3069bcadd45dfba7bf67c6ed016 rcu: use softirq instead
> > of kthreads ex
> > 
> > If that works, perhaps we should try to break down a46e0899ee into
> > smaller pieces to see what is causing the trouble.
> 
> OK, if I revert those two only on v3.0-rc4, it boots.

Very good.  I have created a new jms.2011.07.07a branch in the -rcu
git tree at:

	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git

Could you please try out the six commits on that branch and let me
know which of them work for you?

							Thanx, Paul
