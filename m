Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab3AHKPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:15:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:57924 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab3AHKPA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:15:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="271227081"
From: "Zhang, YiX X" <yix.x.zhang@intel.com>
To: Konstantin Dorfman <kdorfman@codeaurora.org>
CC: "cjb@laptop.org" <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule comment
Thread-Topic: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule comment
Thread-Index: Ac3tZl7MWYZmSAgkROiKKbFrSa0WVv//n92A//9bT2A=
Date: Tue, 8 Jan 2013 10:14:51 +0000
Message-ID: <1A230AD7863570458C6CF2BE7CD6618B102BE9D0@SHSMSX102.ccr.corp.intel.com>
References: <1A230AD7863570458C6CF2BE7CD6618B102BE5CB@SHSMSX102.ccr.corp.intel.com>
 <50EBD75F.7050805@codeaurora.org>
In-Reply-To: <50EBD75F.7050805@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes, you are right, I will change them later, thanks.

Regards
Zhang,Yi.


-----Original Message-----
From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Konstantin Dorfman
Sent: Tuesday, January 08, 2013 4:23 PM
To: Zhang, YiX X
Cc: cjb@laptop.org; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule comment


May be it is worth to change all this struct comments to be:

u8	raw_exception_status;	/* EXT_CSD_EXP_EVENTS_STATUS */

This will reference actual offset value from "include/linux/mmc/mmc.h"

Thanks,

On 01/08/2013 08:07 AM, Zhang, YiX X wrote:
>  From aaea3405944d844f53679b295d4082584f33d9a3 Mon Sep 17 00:00:00 
> 2001
> From: ZhangYi <yix.x.zhang@intel.com>
> Date: Tue, 8 Jan 2013 13:50:09 +0800
> Subject: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule 
> comment
>
> The right value is 54 according to eMMC 4.5 specification.
>
> Signed-off-by: ZhangYi <yix.x.zhang@intel.com>
> ---
>   include/linux/mmc/card.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h index 
> 5c69315..ffde1d3 100644
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
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
--
To unsubscribe from this list: send the line "unsubscribe linux-mmc" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
