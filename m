Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0FVUm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 16:42:27 -0400
Received: from kroah.org ([198.145.64.141]:34686 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0FVUmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 16:42:25 -0400
Date: Tue, 22 Jun 2010 13:42:10 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 22 (staging/spectra)
Message-ID: <20100622204210.GC31047@kroah.com>
References: <20100622160518.2ef7afcc.sfr@canb.auug.org.au>
 <20100622083032.8abe1605.randy.dunlap@oracle.com>
 <20100622085903.4232617d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622085903.4232617d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 08:59:03AM -0700, Randy Dunlap wrote:
> On Tue, 22 Jun 2010 08:30:32 -0700 Randy Dunlap wrote:
> 
> > On Tue, 22 Jun 2010 16:05:18 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20100621:
> > > 
> > > My fixes tree contains:
> > >       v4l-dvb: update gfp/slab.h includes
> > >       arm: update gfp/slab.h includes
> > >       davinci: update gfp/slab.h includes
> > >       ocfs2: update gfp/slab.h includes
> > >       acpi: update gfp/slab.h includes
> > 
> > 
> > drivers/staging/spectra/ffsport.c:307: error: implicit declaration of function 'blk_fs_request'
> > 
> > Where is this function??
> 
> The macro was deleted from include/linux/blkdev.h.  Just change that line to
> 
> -	if (!blk_fs_request(req))
> +	if (req->cmd_type != REQ_TYPE_FS)

Care to send a patch?

thanks,

greg k-h
