Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab0JXVhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:37:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab0JXVhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:37:17 -0400
Date: Sun, 24 Oct 2010 23:37:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] trivial
In-Reply-To: <AANLkTinhODbKSMiwau0zRZw+5O+DPBo5UwpxM4q+Ytjb@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1010242334330.6879@pobox.suse.cz>
References: <alpine.LNX.2.00.1010232317360.6879@pobox.suse.cz> <AANLkTinhODbKSMiwau0zRZw+5O+DPBo5UwpxM4q+Ytjb@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010, Linus Torvalds wrote:

> > please pull from 'for-next' branch at
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-next
> 
> Pulled. With one modification: I didn't take the top merge commit.
> 
> I _really_ prefer to see the clashes myself, and the extra merges just
> make history less readable. So if the conflicts are trivial, please
> don't pre-merge stuff - it just hides things from me.
> 
> Now, admittedly the things it hides shouldn't matter for something
> like the trivial tree, but at the same time, exactly because it's the
> trivial tree I would also expect the conflicts to be really trivial,
> so I'd rather just have people follow the general rule of "please
> don't pre-merge" regardless.
> 
> It's a good idea to perhaps do a private merge just to see how nasty
> things are, and to perhaps give me a heads-up (and maybe even export
> the pre-merged thing as a "btw, if you're lazy and don't care about
> the conflicts, you can pull this other pre-merged branch" branch). But
> on the whole, I tend to find the conflicts to be the most telling
> parts of any merge, and be a good hint about what development trees
> clashed with each other.

OK, I always do private merge with your latest tree to see what actually 
happens, and only merge with latest state of your tree whenever there is 
conflict. But deferring this to you (with warning in the pull request) is 
obviously fine with me as well.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
