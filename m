Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3AHIXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:23:03 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9034 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab3AHIXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:23:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="18528802"
Message-ID: <50EBD75F.7050805@codeaurora.org>
Date: Tue, 08 Jan 2013 10:22:55 +0200
From: Konstantin Dorfman <kdorfman@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Zhang, YiX X" <yix.x.zhang@intel.com>
CC: "cjb@laptop.org" <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule comment
References: <1A230AD7863570458C6CF2BE7CD6618B102BE5CB@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <1A230AD7863570458C6CF2BE7CD6618B102BE5CB@SHSMSX102.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


May be it is worth to change all this struct comments to be:

u8	raw_exception_status;	/* EXT_CSD_EXP_EVENTS_STATUS */

This will reference actual offset value from "include/linux/mmc/mmc.h"

Thanks,

On 01/08/2013 08:07 AM, Zhang, YiX X wrote:
>  From aaea3405944d844f53679b295d4082584f33d9a3 Mon Sep 17 00:00:00 2001
> From: ZhangYi <yix.x.zhang@intel.com>
> Date: Tue, 8 Jan 2013 13:50:09 +0800
> Subject: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule comment
>
> The right value is 54 according to eMMC 4.5 specification.
>
> Signed-off-by: ZhangYi <yix.x.zhang@intel.com>
> ---
>   include/linux/mmc/card.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 5c69315..ffde1d3 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -83,7 +83,7 @@ struct mmc_ext_csd {
>   	unsigned int            data_tag_unit_size;     /* DATA TAG UNIT size */
>   	unsigned int		boot_ro_lock;		/* ro lock support */
>   	bool			boot_ro_lockable;
> -	u8			raw_exception_status;	/* 53 */
> +	u8			raw_exception_status;	/* 54 */
>   	u8			raw_partition_support;	/* 160 */
>   	u8			raw_rpmb_size_mult;	/* 168 */
>   	u8			raw_erased_mem_count;	/* 181 */
>


-- 
Konstantin Dorfman,
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center,
Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
