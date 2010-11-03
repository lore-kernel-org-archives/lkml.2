Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0KCRQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:16:47 -0400
Received: from smtp.scorch.co.nz ([27.110.127.199]:34238 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755487Ab0KCRQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:16:44 -0400
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 6/9] Add some yaffs include files
Date: Thu, 4 Nov 2010 06:16:40 +1300
User-Agent: KMail/1.9.10
Cc: cdhmanning@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-7-git-send-email-cdhmanning@gmail.com> <4CD197A1.4060600@caviumnetworks.com>
In-Reply-To: <4CD197A1.4060600@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011040616.40884.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 November 2010 06:10:57 David Daney wrote:
> On 11/03/2010 09:53 AM, cdhmanning@gmail.com wrote:
> > From: Charles Manning<cdhmanning@gmail.com>
> >
> > Adding yaffs2 file system.
> >
> > Signed-off-by: Charles Manning<cdhmanning@gmail.com>
> > ---
> >   fs/yaffs2/yaffs_guts.h  |  914
> > +++++++++++++++++++++++++++++++++++++++++++++++ fs/yaffs2/yaffs_trace.h |
> >   58 +++
> >   fs/yaffs2/yportenv.h    |   90 +++++
> >   3 files changed, 1062 insertions(+), 0 deletions(-)
> >   create mode 100644 fs/yaffs2/yaffs_guts.h
> >   create mode 100644 fs/yaffs2/yaffs_trace.h
> >   create mode 100644 fs/yaffs2/yportenv.h
> >
> > diff --git a/fs/yaffs2/yaffs_guts.h b/fs/yaffs2/yaffs_guts.h
> > new file mode 100644
> > index 0000000..60770ca
> > --- /dev/null
> > +++ b/fs/yaffs2/yaffs_guts.h
> > @@ -0,0 +1,914 @@
> > +/*
> > + * YAFFS: Yet another Flash File System . A NAND-flash specific file
> > system. + *
> > + * Copyright (C) 2002-2010 Aleph One Ltd.
> > + *   for Toby Churchill Ltd and Brightstar Engineering
> > + *
> > + * Created by Charles Manning<charles@aleph1.co.uk>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU Lesser General Public License version
> > 2.1 as + * published by the Free Software Foundation.
> > + *
> > + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
> > + */
>
> What are the implications of putting LGPL things in the kernel?
>
> I don't know, but someone probably should think about it.

Well there's BSD stuff in the kernel too....

This reduction in restrictions for the yaffs headers is to allow people to use 
the headers for custom bootloader integration etc. This should not generate 
problems for any other code.

-- Charles

