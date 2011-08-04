Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1HDWMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:12:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab1HDWMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:12:34 -0400
Date: Thu, 4 Aug 2011 15:11:31 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] zcache: Fix build error when sysfs is not defined
Message-ID: <20110804221131.GA1401@suse.de>
References: <1297484079-12562-1-git-send-email-ngupta@vflare.org>
 <20110804150524.2dcfcecf.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804150524.2dcfcecf.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 03:05:24PM -0700, Randy Dunlap wrote:
> On Fri, 11 Feb 2011 23:14:39 -0500 Nitin Gupta wrote:
> 
> > Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> > ---
> >  drivers/staging/zcache/zcache.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/staging/zcache/zcache.c b/drivers/staging/zcache/zcache.c
> > index 61be849..8cd3fd8 100644
> > --- a/drivers/staging/zcache/zcache.c
> > +++ b/drivers/staging/zcache/zcache.c
> > @@ -1590,9 +1590,9 @@ __setup("nofrontswap", no_frontswap);
> >  
> >  static int __init zcache_init(void)
> >  {
> > -#ifdef CONFIG_SYSFS
> >  	int ret = 0;
> >  
> > +#ifdef CONFIG_SYSFS
> >  	ret = sysfs_create_group(mm_kobj, &zcache_attr_group);
> >  	if (ret) {
> >  		pr_err("zcache: can't create sysfs\n");
> > -- 
> 
> OMG.  This patch still needs to be applied to linux-next 20110804..........
> sad.

Heh, thanks, I'll queue it up soon.

greg k-h
