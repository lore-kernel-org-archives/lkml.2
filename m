Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab1ENOtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 10:49:36 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51969 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010Ab1ENOtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 10:49:33 -0400
Date: Fri, 13 May 2011 09:38:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110513163801.GX2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DCB8BCD.1080607@kernel.org>
 <4DCB8F7A.90603@kernel.org>
 <20110512092013.GJ2258@linux.vnet.ibm.com>
 <4DCC52FB.6030500@kernel.org>
 <4DCC894D.3070204@kernel.org>
 <20110513084253.GE13647@elte.hu>
 <20110513121906.GA3676@elte.hu>
 <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
 <20110513144059.GA32554@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513144059.GA32554@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 04:40:59PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > very clearly indicate that this is an RCU regression.
> > 
> > This might be the same one Yinghai found:
> > 
> >  e59fb3120bec: rcu: Decrease memory-barrier usage based on semi-formal proof
> > 
> > So with the config i sent it's definitely reproducible.
> 
> yes. And note that the system does not lock up, but boots up after a really 
> long time - perhaps as a side-effect of very rare timer irqs driving forward 
> the RCU state machine?

In the interest of focusing on the code paths that are actually being
executed...

Are you guys seeing NMIs at about the time the slowdown occurs?

							Thanx, Paul
