Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0KFL5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 07:57:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43202 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0KFL5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 07:57:35 -0400
Date: Sat, 6 Nov 2010 11:57:28 +0000
From: James Hogan <james@albanarts.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 12/16] pramfs: extended attributes
Message-ID: <20101106115728.GA13522@gandalf.local>
References: <4CB1EB15.9040109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB1EB15.9040109@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marco,

On Sun, Oct 10, 2010 at 06:34:29PM +0200, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> diff -Nurp linux-2.6.36-orig/fs/pramfs/xattr.h linux-2.6.36/fs/pramfs/xattr.h
> --- linux-2.6.36-orig/fs/pramfs/xattr.h	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/xattr.h	2010-09-18 08:40:35.000000000 +0200
> @@ -0,0 +1,134 @@
> +/*
> + * FILE NAME fs/pramfs/xattr.h
> + *
> + * BRIEF DESCRIPTION
> + *
> + * Extended attributes for the pram filesystem.
> + *
> + * Copyright 2010 Marco Stornelli <marco.stornelli@gmail.com>
> + *
> + * based on fs/ext2/xattr.h with the following copyright:
> + *
> + *(C) 2001 Andreas Gruenbacher, <a.gruenbacher@computer.org>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/xattr.h>
> +
> +/* Magic value in attribute blocks */
> +#define PRAM_XATTR_MAGIC		0x6d617270
> +
> +/* Maximum number of references to one attribute block */
> +#define PRAM_XATTR_REFCOUNT_MAX		1024
> +
> +/* Name indexes */
> +#define PRAM_XATTR_INDEX_USER			1
> +#define PRAM_XATTR_INDEX_POSIX_ACL_ACCESS	2
> +#define PRAM_XATTR_INDEX_POSIX_ACL_DEFAULT	3
> +#define PRAM_XATTR_INDEX_TRUSTED		4
> +#define	PRAM_XATTR_INDEX_LUSTRE			5
> +#define PRAM_XATTR_INDEX_SECURITY	        6

Maybe nobody minds, but there's some inconsistent whitespace here.

Cheers
James
