Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3ADR2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:28:06 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54400 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3ADR2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:28:04 -0500
Date: Fri, 4 Jan 2013 09:27:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@freedesktop.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcutorture: don't compare ptr with 0
Message-ID: <20130104172700.GA19783@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-20-git-send-email-sasha.levin@oracle.com>
 <20121220223912.GA12614@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220223912.GA12614@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010417-7606-0000-0000-0000071DB690
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 02:39:12PM -0800, Josh Triplett wrote:
> On Thu, Dec 20, 2012 at 02:11:28PM -0500, Sasha Levin wrote:
> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> 
> Fair enough.  You might as well change the first half of the conditional
> too, though.  In any case:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Queued, thank you both!

							Thanx, Paul

> >  kernel/rcutorture.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 31dea01..0249800 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -1749,7 +1749,7 @@ static int rcu_torture_barrier_init(void)
> >  	barrier_cbs_wq =
> >  		kzalloc(n_barrier_cbs * sizeof(barrier_cbs_wq[0]),
> >  			GFP_KERNEL);
> > -	if (barrier_cbs_tasks == NULL || barrier_cbs_wq == 0)
> > +	if (barrier_cbs_tasks == NULL || !barrier_cbs_wq)
> >  		return -ENOMEM;
> >  	for (i = 0; i < n_barrier_cbs; i++) {
> >  		init_waitqueue_head(&barrier_cbs_wq[i]);
> > -- 
> > 1.8.0
> > 
> 

