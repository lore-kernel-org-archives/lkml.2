Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab1GJX07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:26:59 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20383 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab1GJX04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:26:56 -0400
Date: Mon, 11 Jul 2011 01:26:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Should SUBLEVEL be removed for 3.x ?
In-Reply-To: <20110710160906.952bb38a.rdunlap@xenotime.net>
Message-ID: <alpine.LNX.2.00.1107110124420.2818@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107110000280.2818@swampdragon.chaosbits.net> <20110710160906.952bb38a.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011, Randy Dunlap wrote:

> On Mon, 11 Jul 2011 00:07:13 +0200 (CEST) Jesper Juhl wrote:
> 
> > Hi
> > 
> > If the plan is that the new kernel is going to be 3.0 (3.x) and the 
> > -stable kernels then get to tack on a third digit with EXTRAVERSION, then 
> > it seems to me that the main Makefile should get rid of SUBLEVEL - or?
> > 
> > Or is the plan to ditch EXTRAVERSION for -stable kernels and have them use 
> > SUBLEVEL instead?
> > 
> > There are a few scripts that need fixing if SUBLEVEL goes the way of the 
> > Dodo, but I didn't want to start fixing those without a clear indication 
> > of whether or not SUBLEVEL is going to/should die.
> > 
> > So what's going to happen to SUBLEVEL/EXTRAVERSION?
> 
> I cannot answer this, but I'd certainly like to see a clear answer
> since I also have several scripts that need such attention.
> 
And besides our own personal scriots there's also stuff like
	scripts/patch-kernel and Documentation/kbuild/makefiles.txt
that need updating.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

