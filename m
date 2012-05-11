Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161028Ab2EKRIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:08:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37513 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab2EKRIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:08:42 -0400
Message-ID: <4FAD4775.2080101@kernel.dk>
Date: Fri, 11 May 2012 19:08:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: zwu.kernel@gmail.com
CC: linux-kernel@vger.kernel.org, wuzhy@linux.vnet.ibm.com,
        stefanha@linux.vnet.ibm.com, trbecker@trbecker.org
Subject: Re: [PATCH v2] block: Remove some unnecessary codes
References: <1336619193-4808-1-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1336619193-4808-1-git-send-email-zwu.kernel@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-10 05:06, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  block/partition-generic.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/block/partition-generic.c b/block/partition-generic.c
> index 6df5d69..b6a9d5b 100644
> --- a/block/partition-generic.c
> +++ b/block/partition-generic.c
> @@ -473,7 +473,6 @@ rescan:
>  	/* add partitions */
>  	for (p = 1; p < state->limit; p++) {
>  		sector_t size, from;
> -		struct partition_meta_info *info = NULL;
>  
>  		size = state->parts[p].size;
>  		if (!size)
> @@ -508,8 +507,6 @@ rescan:
>  			}
>  		}
>  
> -		if (state->parts[p].has_info)
> -			info = &state->parts[p].info;
>  		part = add_partition(disk, p, from, size,
>  				     state->parts[p].flags,
>  				     &state->parts[p].info);

Thanks, applied.

-- 
Jens Axboe

