Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab0JFV10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:27:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40951 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933097Ab0JFV1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:27:25 -0400
Date: Wed, 6 Oct 2010 14:27:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] core kernel fixes
Message-ID: <20101006212722.GP2433@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101005191223.GA31795@elte.hu>
 <AANLkTik9E0dr=Qah0d_+9YaAsA7WfeawA1c4oDbiJK-j@mail.gmail.com>
 <20101005210904.GQ2369@linux.vnet.ibm.com>
 <AANLkTi==ZE7+PTPdB1JjdSdqus0Ox+rjTAxMMMJk0fBi@mail.gmail.com>
 <20101005220546.GS2369@linux.vnet.ibm.com>
 <1286333814.4861.9.camel@edumazet-laptop>
 <20101006045905.GE2553@linux.vnet.ibm.com>
 <20101006182049.GA16329@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006182049.GA16329@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 08:20:49PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Ingo, I have this queued up at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> > 
> > It passes targeted testing.  If Eric is OK with it, it is ready to be 
> > pulled.  At least as soon as kernel.org gets it out to the mirrors. 
> > Commmit 773e3f9357.
> 
> Now that the original fix is in Linus's tree, can the followup commits 
> wait until v2.6.37?
> 
> Linus, Paul, what's your preference?

I am fine either way.

							Thanx, Paul

> Thanks,
> 
> 	Ingo
