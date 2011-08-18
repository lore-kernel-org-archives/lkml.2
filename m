Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab1HRXQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 19:16:55 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33497 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab1HRXQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 19:16:53 -0400
Date: Thu, 18 Aug 2011 16:16:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110818231646.GH2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110815152052.GA2389@linux.vnet.ibm.com>
 <20110817223735.GI2227@zod.bos.redhat.com>
 <20110817224916.GO2419@linux.vnet.ibm.com>
 <20110817230219.GJ2227@zod.bos.redhat.com>
 <20110817230641.GA7837@somewhere.redhat.com>
 <20110817231750.GK2227@zod.bos.redhat.com>
 <20110818183523.GD2325@linux.vnet.ibm.com>
 <20110818140034.668e8dea.akpm@linux-foundation.org>
 <20110818212334.GE2325@linux.vnet.ibm.com>
 <20110818221920.GR2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818221920.GR2227@zod.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 06:19:20PM -0400, Josh Boyer wrote:
> On Thu, Aug 18, 2011 at 02:23:34PM -0700, Paul E. McKenney wrote:
> > > > I am sorry, but I didn't make the rules!  And I must carry the fix
> > > > longer as well, if that makes you feel any better.
> > > 
> > > bah, we're not that anal.  The patch fixes a bug and prevents a nasty
> > > warning spew.  Please, send it to Linus.
> > 
> > Given your Acked-by and Josh's Tested-by I might consider it.  ;-)
> > 
> > Speaking of which, Josh, does this patch help Nicolas and Michal?
> 
> Yes, it did.  The bug is closed because I included the patch.  (I could
> recreate it myself as well.)

OK, good to know!

> > > We appear to be referring to the patch "rcu: Avoid having just-onlined
> > > CPU resched itself when RCU is idle"?  If so, the changelog doesn't
> > > even mention that the patch fixes a scheduling-while-atomic warning and
> > > the changelog fails to refer to the redhat bug report.  These omissions
> > > should be repaired, please.
> > 
> > OK...  But I cannot bring myself to believe that my fix does more than
> > hide some other bug.  Which is OK, I will just say that in the changelog.
> 
> I looked for this other bug myself for a while.  I couldn't find it.

Well, if there really is some other bug, it will make its continued
presence know soon enough.

Andrew, are you willing to ack this?

							Thanx, Paul
