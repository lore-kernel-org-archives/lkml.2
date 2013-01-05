Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab3AERTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:19:30 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49792 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab3AERT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:19:28 -0500
Date: Sat, 5 Jan 2013 09:19:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: comment: correct 'optimized' to 'optimize'.
Message-ID: <20130105171911.GA14324@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1357322381-9573-1-git-send-email-cody@linux.vnet.ibm.com>
 <20130104183353.GB19783@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130104183353.GB19783@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-7606-0000-0000-00000726AFD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 10:33:53AM -0800, Paul E. McKenney wrote:
> On Fri, Jan 04, 2013 at 12:59:40PM -0500, Cody P Schafer wrote:
> > Small gramar fix in rcutree comment regarding 'rcu_scheduler_active'
> > var.
> 
> Queued, thank you!  I could not resist fixing a small nit in the commit
> log as well.  ;-)

And are you OK with my adding your Signed-off-by?  Either way, on future
patches, please add your Signed-off-by in your original posting.

> 							Thanx, Paul
> 
> > ---
> >  kernel/rcutree.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index e441b77..bfb8972 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -105,7 +105,7 @@ int rcu_num_nodes __read_mostly = NUM_RCU_NODES; /* Total # rcu_nodes in use. */
> >   * The rcu_scheduler_active variable transitions from zero to one just
> >   * before the first task is spawned.  So when this variable is zero, RCU
> >   * can assume that there is but one task, allowing RCU to (for example)
> > - * optimized synchronize_sched() to a simple barrier().  When this variable
> > + * optimize synchronize_sched() to a simple barrier().  When this variable
> >   * is one, RCU must actually do all the hard work required to detect real
> >   * grace periods.  This variable is also used to suppress boot-time false
> >   * positives from lockdep-RCU error checking.
> > -- 
> > 1.8.0.3
> > 

