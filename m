Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab0KATMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:12:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51363 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab0KATMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QbIl//IwjTIny2FvnyImXJOR1mYbHtX1TC79crzlBrhP3L2rG7wo0uEgmCQ6d+WRG7
         leofYyNBTtao9zyPEoxQjAWZ199A9G3q02epTUJVuLxdxqF/XT0O4uS1WMJ49wzLKPkj
         yVEUc1OPX1mDAphOATr+vXbh0XvjMrqKZAbzQ=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-21-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-21-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 21:12:12 +0200
X-Google-Sender-Auth: yCh8ZgMUNjQT2c66Mb3ek1WlY4o
Message-ID: <AANLkTimrVAc+XQT3Zasd1U4t5=bsLoCzfCiCuEV3Pwv0@mail.gmail.com>
Subject: Re: [PATCH 20/29] Staging: yaffs2: yaffs_qsort.h: Add file
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
>  drivers/staging/yaffs2/yaffs_qsort.h |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_qsort.h
>
> diff --git a/drivers/staging/yaffs2/yaffs_qsort.h b/drivers/staging/yaffs2/yaffs_qsort.h
> new file mode 100644
> index 0000000..4a4981b
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yaffs_qsort.h
> +#ifndef __YAFFS_QSORT_H__
> +#define __YAFFS_QSORT_H__
> +
> +#ifdef __KERNEL__
> +#include <linux/sort.h>
> +
> +extern void yaffs_qsort(void *const base, size_t total_elems, size_t size,
> +                       int (*cmp)(const void *, const void *)){
> +       sort(base, total_elems, size, cmp, NULL);
> +}
> +
> +#else
> +
> +extern void yaffs_qsort(void *const base, size_t total_elems, size_t size,
> +                       int (*cmp)(const void *, const void *));
> +
> +#endif
> +#endif

Kill this wrapper.
