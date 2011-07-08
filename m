Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1GHUrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 16:47:04 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46788 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab1GHUrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 16:47:01 -0400
Date: Fri, 8 Jul 2011 13:46:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cleanup PATCH] rcu: Do not use rcu_read_lock_held when
 calling rcu_dereference_check
Message-ID: <20110708204632.GZ6014@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110708135739.GB12834@tiehlicka.suse.cz>
 <20110708154829.GS6014@linux.vnet.ibm.com>
 <20110708155752.GE12834@tiehlicka.suse.cz>
 <20110708163033.GG12834@tiehlicka.suse.cz>
 <20110708185148.GV6014@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1107082222150.11049@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107082222150.11049@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 10:22:45PM +0200, Jiri Kosina wrote:
> On Fri, 8 Jul 2011, Paul E. McKenney wrote:
> 
> > > Hmm, thinking about it some more. Wouldn't it make more sense to push
> > > this through trivial tree (CCing Jikos)? Having 5 or so patches with the
> > > exactly same changelog sounds overkill to me.
> > > 
> > > What do you think? Could you give me your Acked-by if you are OK with
> > > it, please?
> > 
> > Whatever works.  ;-)
> > 
> > However, I did queue the Documentation/RCU/lockdep.txt patch already.
> 
> That's no problem for git. But anyway, I have dropped that part.
> 
> > For the others,
> > 
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Thanks. Applied.

Thank you, Jiri!

							Thanx, Paul
