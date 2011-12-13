Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1LMUyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:54:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:50090 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1LMUyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:54:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86195654"
Date: Tue, 13 Dec 2011 21:59:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH RESEND 1/2] MFD: MAX8997: add platform data and devices
 for LED control
Message-ID: <20111213205905.GH2796@sortiz-mobl>
References: <1323764033-3979-1-git-send-email-dg77.kim@samsung.com>
 <1323764033-3979-2-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323764033-3979-2-git-send-email-dg77.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Donggeun,

On Tue, Dec 13, 2011 at 05:13:52PM +0900, Donggeun Kim wrote:
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index 5be53ae..cb83a7a 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -43,7 +43,8 @@ static struct mfd_cell max8997_devs[] = {
>  	{ .name = "max8997-battery", },
>  	{ .name = "max8997-haptic", },
>  	{ .name = "max8997-muic", },
> -	{ .name = "max8997-flash", },
That doesn't seem to be related to this patch.


> +	{ .name = "max8997-led", .id = 1 },
> +	{ .name = "max8997-led", .id = 2 },
>  };
> @@ -172,7 +194,8 @@ struct max8997_platform_data {
>  
>  	/* HAPTIC: Not implemented */
>  	/* RTC: Not implemented */
> -	/* Flash: Not implemented */
> +	/* ---- Flash ---- */
> +	struct max8997_led_platform_data *led_pdata;
This is a bit confusing: Flash and LED ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
