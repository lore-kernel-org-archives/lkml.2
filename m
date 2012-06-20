Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2FTVvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 17:51:20 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18415 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab2FTVvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 17:51:19 -0400
Date: Wed, 20 Jun 2012 23:51:17 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joe Perches <joe@perches.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/get_maintainer.pl: Add tested-by signature
In-Reply-To: <20120620143959.394b9930.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1206202349190.7671@swampdragon.chaosbits.net>
References: <1340193105-10734-1-git-send-email-aletes.xgr@gmail.com> <1340209526.29885.14.camel@joe2Laptop> <20120620143959.394b9930.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Andrew Morton wrote:

> On Wed, 20 Jun 2012 09:25:26 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Wed, 2012-06-20 at 08:51 -0300, Alexandre Pereira da Silva wrote:
> > > The tester of the patch should also be listed to receive patch
> > > notifications.
> > []
> > > diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> > []
> > > @@ -81,6 +81,7 @@ my $penguin_chiefs = "\(" . join("|", @penguin_chief_names) . "\)";
> > >  my @signature_tags = ();
> > >  push(@signature_tags, "Signed-off-by:");
> > >  push(@signature_tags, "Reviewed-by:");
> > > +push(@signature_tags, "Tested-by:");
> > >  push(@signature_tags, "Acked-by:");
> > 
> > I have no objections to this, but maybe Florian Mickler
> > (cc'd) who did analysis on signatures awhile ago might.
> > 
> 
> Yes.  In my experience, a lot of tested-by's come from random internet
> victims who happened to report a bug and who we'll never hear from
> again and who don't want to be told other things about
> whatever-part-of-the-kernel-that-was.
> 
> Perhaps the set "has a tested-by, doesn't have reported-by" would
> filter out a lot of these, dunno.  It all sounds a bit marginal.
> 
> 
> 
> Also, lots of people have used a "Reported-and-tested-by" and there are
> even a few lysdexic "Tested-and-[rR]eported-by" tags in there.
> 
> Any time I see one of these things I stomp on it and turn it into
> separate reported-by and tested-by lines, as Reported-and-tested-by
> just adds pointless duplication, work and noise.  But I appear to have
> lost that fight.
> 
> 
> This fashion of adding new and innovative changelog tags just creates
> inaccuracy and work for people who wish to mine that data for something
> useful, as Alexandre is finding out.
> 
> <does some data mining>
> 
> Geeze, guys.  Who knew there were so many Kernel Komedians?
> 
Andrew - stomp harder!

I'm well aware that it's not your job to fix this mess - just couldn't 
help myself commenting on your "Any time I see one of these things I stomp 
on it" comment...  You should stomp, and stomp HARD!

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

