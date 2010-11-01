Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab0KAS52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:57:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51902 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab0KAS5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:57:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ugLVxc/BIBkXHCRg2LC1JVQiBZwxlkacEz2clY40nL9UmY62Gr/JdJprng1PK9zezR
         XNarNsLY4BfWgw+O/m8K9sZV9Asy+YEHNmz9fRhkev3NR4RUkDvuiTFX7VRP6LpqhGRm
         BJ4LhrXQyvucBAo2CLR5SGzUX0A+c33g7MlKA=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-5-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-5-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 20:57:24 +0200
X-Google-Sender-Auth: pxDuKJyJHvol_I4CmB0kDQCKeJU
Message-ID: <AANLkTimx9KhUZhHKx_FJ=orUoRaVHaye3G9Uazg4iZmm@mail.gmail.com>
Subject: Re: [PATCH 04/29] Staging: yaffs2: moduleconfig.h: Add file
From: Pekka Enberg <penberg@kernel.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 8:40 PM, Tracey Dent <tdent48227@gmail.com> wrote:
> Adding files to yaffs2 directory.
>
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/moduleconfig.h |   86 +++++++++++++++++++++++++++++++++
>  1 files changed, 86 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/moduleconfig.h
>
> diff --git a/drivers/staging/yaffs2/moduleconfig.h b/drivers/staging/yaffs2/moduleconfig.h
> new file mode 100644
> index 0000000..4b4d642
> --- /dev/null
> +++ b/drivers/staging/yaffs2/moduleconfig.h
> @@ -0,0 +1,86 @@
> +/*
> + * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2010 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Martin Fouts <Martin.Fouts@palmsource.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU Lesser General Public License version 2.1 as
> + * published by the Free Software Foundation.
> + *
> + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
> + */
> +
> +#ifndef __YAFFS_CONFIG_H__
> +#define __YAFFS_CONFIG_H__
> +
> +#ifdef YAFFS_OUT_OF_TREE

You probably want to drop this header as well...
