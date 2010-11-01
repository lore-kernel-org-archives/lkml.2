Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab0KATSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:18:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33098 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0KATSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JE59U4JsFDYOFhXZXDbJqL/unhoHN8ccOkBHzTT7+AS8KkRzHC7CnGUc30r6ABxp6t
         wKKYk2UFwwSFoF4Vb0g7DLzHQc1FD7+1jbrAuhc56XBYqZs1xsMk+v+l9xsEyWNJGXFS
         L4SG4rqQk9zpBSdy5y6yVieI401xuUub9vSu0=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-29-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-29-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 21:18:34 +0200
X-Google-Sender-Auth: e260LR1fXW5y7RzZzrmK2RHeuJ0
Message-ID: <AANLkTikUDEiMPeMucqOu-+jvJ4FyXLnsN8-FNF8z0-hH@mail.gmail.com>
Subject: Re: [PATCH 28/29] Staging: yaffs2: yportenv.h: Add file
From: Pekka Enberg <penberg@kernel.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 8:41 PM, Tracey Dent <tdent48227@gmail.com> wrote:
> Adding files to yaffs2 directory.
>
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/yportenv.h |  333 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 333 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yportenv.h
>
> diff --git a/drivers/staging/yaffs2/yportenv.h b/drivers/staging/yaffs2/yportenv.h
> new file mode 100644
> index 0000000..2f9063b
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yportenv.h
> +#define YCHAR char
> +#define YUCHAR unsigned char
> +#define _Y(x)     x
> +#define yaffs_strcat(a, b)     strcat(a, b)
> +#define yaffs_strcpy(a, b)     strcpy(a, b)
> +#define yaffs_strncpy(a, b, c) strncpy(a, b, c)
> +#define yaffs_strncmp(a, b, c) strncmp(a, b, c)
> +#define yaffs_strnlen(s,m)     strnlen(s,m)
> +#define yaffs_sprintf         sprintf
> +#define yaffs_toupper(a)       toupper(a)
> +
> +#define Y_INLINE __inline__
> +
> +#define YAFFS_LOSTNFOUND_NAME          "lost+found"
> +#define YAFFS_LOSTNFOUND_PREFIX                "obj"
> +
> +/* #define YPRINTF(x) printk x */
> +#define YMALLOC(x) kmalloc(x, GFP_NOFS)
> +#define YFREE(x)   kfree(x)
> +#define YMALLOC_ALT(x) vmalloc(x)
> +#define YFREE_ALT(x)   vfree(x)
> +#define YMALLOC_DMA(x) YMALLOC(x)
> +
> +#define YYIELD() schedule()
> +#define Y_DUMP_STACK() dump_stack()

[snip]

Pretty much all wrappers in this header file want to be killed.
