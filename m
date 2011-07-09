Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1GIK7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 06:59:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1GIK67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 06:58:59 -0400
Date: Sat, 9 Jul 2011 12:58:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cleanup PATCH] rcu: Do not use rcu_read_lock_held when calling
 rcu_dereference_check
Message-ID: <20110709105857.GA29263@tiehlicka.suse.cz>
References: <20110708135739.GB12834@tiehlicka.suse.cz>
 <20110708154829.GS6014@linux.vnet.ibm.com>
 <20110708155752.GE12834@tiehlicka.suse.cz>
 <20110708163033.GG12834@tiehlicka.suse.cz>
 <20110708185148.GV6014@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1107082222150.11049@pobox.suse.cz>
 <20110708204632.GZ6014@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708204632.GZ6014@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-07-11 13:46:32, Paul E. McKenney wrote:
> On Fri, Jul 08, 2011 at 10:22:45PM +0200, Jiri Kosina wrote:
> > On Fri, 8 Jul 2011, Paul E. McKenney wrote:
> > 
> > > > Hmm, thinking about it some more. Wouldn't it make more sense to push
> > > > this through trivial tree (CCing Jikos)? Having 5 or so patches with the
> > > > exactly same changelog sounds overkill to me.
> > > > 
> > > > What do you think? Could you give me your Acked-by if you are OK with
> > > > it, please?
> > > 
> > > Whatever works.  ;-)
> > > 
> > > However, I did queue the Documentation/RCU/lockdep.txt patch already.
> > 
> > That's no problem for git. But anyway, I have dropped that part.
> > 
> > > For the others,
> > > 
> > > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Thanks. Applied.
> 
> Thank you, Jiri!

Thanks to both of you guys.

> 
> 							Thanx, Paul

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
