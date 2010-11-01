Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0KAS4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:56:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63858 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab0KAS42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qEtTbqAGpalpndHQzg1pzqSyZiziuFLIZRCcT2PLCaXDCzL4Fc4COvrMmfFo88XunP
         s2EKC9b/vu5UqoBlkQ0yEpR/3dOpu+xG0gHwTEHyDoFL/4CeZ4yRtNb97VXDIgkImcBv
         RPQQRzxRgNDrexFBOMSM4sGH0UfdOstFLh4lc=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-4-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-4-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 20:56:27 +0200
X-Google-Sender-Auth: gv8cEdEmvYE70ncon1w0FCYdWss
Message-ID: <AANLkTi=D8D+AeppbEZJwQii+46OLraw7XC8x1O7A2nre@mail.gmail.com>
Subject: Re: [PATCH 03/29] Staging: yaffs2: devextras.h: Add file
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
>  drivers/staging/yaffs2/devextras.h |  101 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 101 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/devextras.h
>
> diff --git a/drivers/staging/yaffs2/devextras.h b/drivers/staging/yaffs2/devextras.h
> new file mode 100644
> index 0000000..ce30c82
> --- /dev/null
> +++ b/drivers/staging/yaffs2/devextras.h
> @@ -0,0 +1,101 @@
> +/*
> + * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2010 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning <charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU Lesser General Public License version 2.1 as
> + * published by the Free Software Foundation.
> + *
> + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
> + */
> +
> +/*
> + * This file is just holds extra declarations of macros that would normally
> + * be providesd in the Linux kernel. These macros have been written from
> + * scratch but are functionally equivalent to the Linux ones.
> + *
> + */

Seriously, you're adding WIN32 #ifdefs. Why do we want to merge this
header to mainline?
