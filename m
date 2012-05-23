Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2EWXrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:47:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55781 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2EWXrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:47:35 -0400
Date: Thu, 24 May 2012 00:47:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for May 23 (uml)
Message-ID: <20120523234730.GP11775@ZenIV.linux.org.uk>
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
 <4FBD090E.5020901@xenotime.net>
 <20120523181917.GN11775@ZenIV.linux.org.uk>
 <20120523193707.GO11775@ZenIV.linux.org.uk>
 <20120524091306.e6f6b17d7240b29a124b44c3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524091306.e6f6b17d7240b29a124b44c3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:13:06AM +1000, Stephen Rothwell wrote:
> > 2)
> > 	Cherry-picked these guys into signal.git, along with the rest
> > of signal prereqs for them.  Merge with next/akpm-base yields a couple
> > of trivial conflicts in kernel/fork.c (with
> > 	sched, mm: Rework sched_{fork,exec} node assignment
> > removing INIT_LIST_HEAD right next to the place where we add one; conflict
> > resolution being just keep the one Oleg adds and remove the one Peter removes)
> > and in kernel/irq/manage.c (with
> > 	genirq: Be more informative on irq type mismatch
> > changing a couple of printks in there; conflict resolution: just remove
> > exit_irq_thread() in merged variant).  That's for-next-variant2.  With that
> > variant we get 5 more duplicates with next/akpm, obviously.
> > 
> > Stephen, which way would you prefer it handled?
> 
> So variant2 sits on top of variant1 and you are intending to push the
> work in variant2 in this merge window anyway?   In that case variant2
> makes sense.  The number of small conflicts don't matter to much (up to a
> point anyway :-)).  Also, these cherry-picks are out of Andrew's tree,
> right (so they are already in linuc-next)?  In which case I would
> probably go with variant2.

Fine by me...  Pushed into for-next, should be on git.kernel.org shortly...
