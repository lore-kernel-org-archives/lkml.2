Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1GHUWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 16:22:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab1GHUWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 16:22:49 -0400
Date: Fri, 8 Jul 2011 22:22:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cleanup PATCH] rcu: Do not use rcu_read_lock_held when calling
 rcu_dereference_check
In-Reply-To: <20110708185148.GV6014@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1107082222150.11049@pobox.suse.cz>
References: <20110708135739.GB12834@tiehlicka.suse.cz> <20110708154829.GS6014@linux.vnet.ibm.com> <20110708155752.GE12834@tiehlicka.suse.cz> <20110708163033.GG12834@tiehlicka.suse.cz> <20110708185148.GV6014@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jul 2011, Paul E. McKenney wrote:

> > Hmm, thinking about it some more. Wouldn't it make more sense to push
> > this through trivial tree (CCing Jikos)? Having 5 or so patches with the
> > exactly same changelog sounds overkill to me.
> > 
> > What do you think? Could you give me your Acked-by if you are OK with
> > it, please?
> 
> Whatever works.  ;-)
> 
> However, I did queue the Documentation/RCU/lockdep.txt patch already.

That's no problem for git. But anyway, I have dropped that part.

> For the others,
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks. Applied.

-- 
Jiri Kosina
SUSE Labs
