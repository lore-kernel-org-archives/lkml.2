Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0KAUBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:01:47 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21712 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab0KAUBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:01:46 -0400
Date: Mon, 1 Nov 2010 20:51:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tracey Dent <tdent48227@gmail.com>
cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/29] Staging: yaffs2: yaffs_guts: Add files
In-Reply-To: <1288636877-7964-11-git-send-email-tdent48227@gmail.com>
Message-ID: <alpine.LNX.2.00.1011012050060.12889@swampdragon.chaosbits.net>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <1288636877-7964-11-git-send-email-tdent48227@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Tracey Dent wrote:

> Adding files to yaffs2 directory.
>    
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/yaffs_guts.c | 5544 
+++++++++++++++++++++++++++++++++++
>  drivers/staging/yaffs2/yaffs_guts.h |  969 ++++++
>  2 files changed, 6513 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_guts.c
>  create mode 100644 drivers/staging/yaffs2/yaffs_guts.h
>  
> diff --git a/drivers/staging/yaffs2/yaffs_guts.c 
b/drivers/staging/yaffs2/yaffs_guts.c
> new file mode 100644
> index 0000000..eea828a
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yaffs_guts.c
> @@ -0,0 +1,5544 @@
> +/*
> + * YAFFS: Yet Another Flash File System. A NAND-flash specific file 
system.
> + *
> + * Copyright (C) 2002-2010 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning <charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "yportenv.h"
> +#include "yaffs_trace.h"
> +
> +#include "yaffs_guts.h"
> +#include "yaffs_tagsvalidity.h" 
> +#include "yaffs_getblockinfo.h"
> +
> +#include "yaffs_tagscompat.h"
> +
> +#include "yaffs_nand.h"

   ^--- here

> +
> +#include "yaffs_yaffs1.h"
> +#include "yaffs_yaffs2.h"
> +#include "yaffs_bitmap.h"
> +#include "yaffs_verify.h"
> +
> +#include "yaffs_nand.h"

   ^--- and here

duplicate inclusion of "yaffs_nand.h" header.


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

