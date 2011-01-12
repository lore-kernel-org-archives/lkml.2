Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab1ALXQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:16:09 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49446 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab1ALXQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:16:07 -0500
Date: Wed, 12 Jan 2011 15:16:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: bharata@linux.vnet.ibm.com, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/2] [PATCH -tip 1/2] sched: Reinstate group names
 in /proc/sched_debug.
Message-ID: <20110112231602.GH17328@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110111101040.GD4772@in.ibm.com>
 <20110111101153.GE4772@in.ibm.com>
 <20110111124658.GA4507@zhy>
 <20110111134244.GJ4772@in.ibm.com>
 <20110111140005.GA6069@zhy>
 <20110112074930.GF2723@in.ibm.com>
 <1294831112.19601.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294831112.19601.8.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 12:18:32PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-01-12 at 13:19 +0530, Bharata B Rao wrote:
> > 
> > We could, but I guess its not a recommended practice anymore to depend on
> > spinlocks to protect rcu readside.
> 
> Not only is it not recommended, its a flat out bug for PREEMPT_RCU.

And lockdep-RCU will yell at you under PREEMPT_RCU, which will result
in Miles Lane yelling at me.  ;-)

							Thanx, Paul
