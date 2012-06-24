Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2FXVCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 17:02:01 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11197 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2FXVB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 17:01:59 -0400
Date: Sun, 24 Jun 2012 23:01:58 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Style cleanup of iwctl
In-Reply-To: <20120624204711.GK5390@mwanda>
Message-ID: <alpine.LNX.2.00.1206242258230.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206242131040.30361@swampdragon.chaosbits.net> <20120624204711.GK5390@mwanda>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2012, Dan Carpenter wrote:

> On Sun, Jun 24, 2012 at 09:45:58PM +0200, Jesper Juhl wrote:
> > Clean up the files iwctl.c and iwctl.h to match the official
> > CodingStyle a bit more closely.
> > 
> > This is *not* a complete cleanup, but it brings the files quite close
> > to the accepted style compared to the state they were originally in
> > (which was a complete mess IMHO).
> > 
> > It's mostly just whitespace changes, but there are also a few
> > pointless casts that were removed, a few tiny reshuffelings of code to
> > reduce indentation etc, but nothing major. There are no functional
> > changes.
> > 
> > I could have split this in multiple patches, I guess, but then I'd
> > probably have ended up with a bunch of patches all touching the same
> > lines multiple times in order to make multiple different changes and
> > that didn't seem worth it.  I opted to just do the whole thing in one
> > big patch, then we at least have a sane base upon which to apply
> > future smaller cleanups.
> 
> Nope.  It is worth it.  Broken out patches are a million times
> easier to review.
> 
Ok. I'll redo it as a series. It'll take a little while, so I may not 
finish it tonight, but I'll do it.

> It frustrates me that you would do things like this when you know
> the rules.  Which part is difficult to understand?
> 
Nothing is difficult to understand, but breaking this into (for example) a 
series that does:
	1) fix the indentation to use tabs and not spaces and proper depth
	2) remove space between cast and variable
	3) add spaces around operators (like "foo && bar" rather than "foo&&bar")
	4) add {} to all branches of if statement if one needs it (or remove if none need them)
would, for many lines, result in all 4 patches changing the same lines.
That just seemed like a little too much churn for a trivial style cleanup 
patch.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

