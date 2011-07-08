Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1GHP5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:57:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1GHP5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:57:53 -0400
Date: Fri, 8 Jul 2011 17:57:52 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cleanup PATCH] rcu: Do not use rcu_read_lock_held when calling
 rcu_dereference_check
Message-ID: <20110708155752.GE12834@tiehlicka.suse.cz>
References: <20110708135739.GB12834@tiehlicka.suse.cz>
 <20110708154829.GS6014@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708154829.GS6014@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-07-11 08:48:29, Paul E. McKenney wrote:
> On Fri, Jul 08, 2011 at 03:57:39PM +0200, Michal Hocko wrote:
> > Hi Paul,
> > I guess that this falls down to your area because the code, even though
> > it touches multiple areas, is RCU specific. Let me know if I should
> > break it into smaller pieces or that I should push it through other
> > trees.
> > 
> > git grep -n -A3 "\<rcu_dereference_.*check" doesn't show any other
> > variants to be "affected".
> 
> Hello, Michal,
> 
> Good catch, thank you!!!
> 
> Could you please break this up by maintainer?

OK, will do.

> 
> I have already queued your changes to Documentation/RCU/lockdep.txt with
> your Signed-off-by (probably for 3.1), so please don't worry about those.

OK


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
