Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0KVRDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:03:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:51300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab0KVRDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:03:06 -0500
Date: Mon, 22 Nov 2010 18:03:03 +0100
From: Jan Kara <jack@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Theodore Tso <tytso@MIT.EDU>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3: Coding style fix in namei.c
Message-ID: <20101122170303.GA5012@quack.suse.cz>
References: <1290161589-5370-1-git-send-email-namhyung@gmail.com>
 <60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
 <1290177928.1678.51.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290177928.1678.51.camel@leonhard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 19-11-10 23:45:28, Namhyung Kim wrote:
> 2010-11-19 (금), 07:57 -0500, Theodore Tso:
> > On Nov 19, 2010, at 5:13 AM, Namhyung Kim wrote:
> > 
> > > * break long lines (using temp variables if needed)
> > > * merge short lines
> > > * put open brace on the same line
> > > * use C89-style comments
> > > * remove a space between function name and parenthesis
> > > * remove a space between '*' and pointer name
> > > * add a space after ','
> > > * other random whitespace fixes
> > > 
> > > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > 
> > What's the benefit of such massive cleanup patches, really?   Does it
> >  really enhance readability _that_ much?
> > 
> > I believe in cleaning up code as I make substantive, useful change, but
> >  code churn for code churn's sake has a number of downsides:
> > 
> > *) It breaks other people's patches that might be pending (probably not
> >  as much of an issue for ext3)
> > *) It makes it really easy to introduce
> >  security holes in code (although it looks like --- I haven't checked
> >  to make sure --- this shouldn't change the compiled code any so we can
> >  at least audit this by applying the patch, and then checking to make
> >  sure the .o hasn't changed.   What really makes my skin crawl is a
> >  massive change like that which doesn't have zero impact on the
> >  compiled object code.  If I get a patch like that, I reject it out of
> >  hand for ext4.)
> > 
> > Bottom line is I really don't think cleanup code helps a lot.  It
> >  wastes your time --- why not find some way of improving the kernel
> >  that has more impact --- and it wastes the time of the responsible
> >  maintainer (who has to go through the code with a fined-toothed comb
> >  to make sure there's nothing bad hidden in a massive patch like this).
> > 
> > Best regards,
> > 
> > -- Ted
> > 
> 
> I wrote this patch because checkpatch complains about the code when I
> tried to write another. Since I saw many codes in namei.c doesn't
> conform the kernel coding style so I decided to write this coding style
> patch first and others on top of it. But if you think it is totally
> useless, I'm fine with dropping it.
  I'm not a big fan of such big coding-style cleanups either. When you are
changing some code for some other reason, it's fine (even desirable) to fix
the coding style (and as a result checkpatch does not complain on your
patch). But doing just coding style fixes makes sense only if the code is
really hard to read which does not seem to be this case...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
