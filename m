Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab0JGRnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:43:00 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55565 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab0JGRm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:42:59 -0400
Date: Thu, 7 Oct 2010 10:42:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] core kernel fixes
Message-ID: <20101007174256.GG2434@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101005191223.GA31795@elte.hu>
 <AANLkTik9E0dr=Qah0d_+9YaAsA7WfeawA1c4oDbiJK-j@mail.gmail.com>
 <20101005210904.GQ2369@linux.vnet.ibm.com>
 <AANLkTi==ZE7+PTPdB1JjdSdqus0Ox+rjTAxMMMJk0fBi@mail.gmail.com>
 <20101005220546.GS2369@linux.vnet.ibm.com>
 <1286333814.4861.9.camel@edumazet-laptop>
 <20101006045905.GE2553@linux.vnet.ibm.com>
 <20101006182049.GA16329@elte.hu>
 <20101006212722.GP2433@linux.vnet.ibm.com>
 <20101007081100.GA16539@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007081100.GA16539@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 10:11:00AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Wed, Oct 06, 2010 at 08:20:49PM +0200, Ingo Molnar wrote:
> > > 
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > Ingo, I have this queued up at:
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> > > > 
> > > > It passes targeted testing.  If Eric is OK with it, it is ready to be 
> > > > pulled.  At least as soon as kernel.org gets it out to the mirrors. 
> > > > Commmit 773e3f9357.
> > > 
> > > Now that the original fix is in Linus's tree, can the followup commits 
> > > wait until v2.6.37?
> > > 
> > > Linus, Paul, what's your preference?
> > 
> > I am fine either way.
> 
> Ok, Linus released -rc7 which is probably the last -rc so to reduce 
> final-rc code flux i have pulled your fix into tip:core/rcu, for 
> v2.6.37.

Ah, good, thank you!  I am rebasing on top of that.  Here is hoping that
this approach quiets down the conflict in -next as well.  ;-)

							Thanx, Paul
