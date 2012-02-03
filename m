Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2BCVi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:38:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab2BCVi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:38:58 -0500
Date: Fri, 3 Feb 2012 22:38:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jesper Juhl <jj@chaosbits.net>, dm-devel@redhat.com,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] There's no need to include linux/version.h in
 drivers/md/dm-bufio.c
In-Reply-To: <Pine.LNX.4.64.1201151728510.26479@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.LNX.2.00.1202032238380.25026@pobox.suse.cz>
References: <alpine.LNX.2.00.1201152110290.13389@swampdragon.chaosbits.net> <Pine.LNX.4.64.1201151728510.26479@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jan 2012, Mikulas Patocka wrote:

> Acked-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> On Sun, 15 Jan 2012, Jesper Juhl wrote:
> 
> > As 'make versioncheck' points out, drivers/md/dm-bufio.c has no need
> > to include linux/version.h, so this patch removes the unneeded
> > include.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/md/dm-bufio.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > index 0a6806f..b6e58c7 100644
> > --- a/drivers/md/dm-bufio.c
> > +++ b/drivers/md/dm-bufio.c
> > @@ -12,7 +12,6 @@
> >  #include <linux/dm-io.h>
> >  #include <linux/slab.h>
> >  #include <linux/vmalloc.h>
> > -#include <linux/version.h>
> >  #include <linux/shrinker.h>
> >  #include <linux/module.h>

As this doesn't seem to be present in -next, I am taking it. Thanks,

-- 
Jiri Kosina
SUSE Labs
