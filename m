Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2EKPIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:08:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51689 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2EKPIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <1336619193-4808-1-git-send-email-zwu.kernel@gmail.com>
References: <1336619193-4808-1-git-send-email-zwu.kernel@gmail.com>
Date: Fri, 11 May 2012 23:08:50 +0800
Message-ID: <CAEH94LiZ0+BD1UZUcTxkZun8RciWspwj=RqmdTjcH2sobk+4mA@mail.gmail.com>
Subject: Re: [PATCH v2] block: Remove some unnecessary codes
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: jaxboe@fusionio.com
Cc: axboe@kernel.dk, wuzhy@linux.vnet.ibm.com, stefanha@linux.vnet.ibm.com,
        trbecker@trbecker.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI, Jens,

Can you help queue this patch up?

On Thu, May 10, 2012 at 11:06 AM,  <zwu.kernel@gmail.com> wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  block/partition-generic.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/block/partition-generic.c b/block/partition-generic.c
> index 6df5d69..b6a9d5b 100644
> --- a/block/partition-generic.c
> +++ b/block/partition-generic.c
> @@ -473,7 +473,6 @@ rescan:
>        /* add partitions */
>        for (p = 1; p < state->limit; p++) {
>                sector_t size, from;
> -               struct partition_meta_info *info = NULL;
>
>                size = state->parts[p].size;
>                if (!size)
> @@ -508,8 +507,6 @@ rescan:
>                        }
>                }
>
> -               if (state->parts[p].has_info)
> -                       info = &state->parts[p].info;
>                part = add_partition(disk, p, from, size,
>                                     state->parts[p].flags,
>                                     &state->parts[p].info);
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards,

Zhi Yong Wu
