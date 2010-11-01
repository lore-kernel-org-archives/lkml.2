Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0KAUGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:06:55 -0400
Received: from kroah.org ([198.145.64.141]:42385 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab0KAUGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:06:53 -0400
Date: Mon, 1 Nov 2010 13:07:41 -0700
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Tracey Dent <tdent48227@gmail.com>, manningc2@actrix.gen.nz,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/29] Staging: yaffs2: devextras.h: Add file
Message-ID: <20101101200741.GA2049@kroah.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <1288636877-7964-4-git-send-email-tdent48227@gmail.com> <AANLkTi=D8D+AeppbEZJwQii+46OLraw7XC8x1O7A2nre@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=D8D+AeppbEZJwQii+46OLraw7XC8x1O7A2nre@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 08:56:27PM +0200, Pekka Enberg wrote:
> On Mon, Nov 1, 2010 at 8:40 PM, Tracey Dent <tdent48227@gmail.com> wrote:
> > Adding files to yaffs2 directory.
> >
> > Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> > ---
> > ?drivers/staging/yaffs2/devextras.h | ?101 ++++++++++++++++++++++++++++++++++++
> > ?1 files changed, 101 insertions(+), 0 deletions(-)
> > ?create mode 100644 drivers/staging/yaffs2/devextras.h
> >
> > diff --git a/drivers/staging/yaffs2/devextras.h b/drivers/staging/yaffs2/devextras.h
> > new file mode 100644
> > index 0000000..ce30c82
> > --- /dev/null
> > +++ b/drivers/staging/yaffs2/devextras.h
> > @@ -0,0 +1,101 @@
> > +/*
> > + * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
> > + *
> > + * Copyright (C) 2002-2010 Aleph One Ltd.
> > + * ? for Toby Churchill Ltd and Brightstar Engineering
> > + *
> > + * Created by Charles Manning <charles@aleph1.co.uk>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU Lesser General Public License version 2.1 as
> > + * published by the Free Software Foundation.
> > + *
> > + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
> > + */
> > +
> > +/*
> > + * This file is just holds extra declarations of macros that would normally
> > + * be providesd in the Linux kernel. These macros have been written from
> > + * scratch but are functionally equivalent to the Linux ones.
> > + *
> > + */
> 
> Seriously, you're adding WIN32 #ifdefs. Why do we want to merge this
> header to mainline?

It would be in staging, and removed before going to the main portion of
the tree.  This happens all the time...

thanks,

greg k-h
