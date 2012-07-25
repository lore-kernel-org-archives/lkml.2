Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab2GYLGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:06:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11616 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab2GYLGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:06:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6782"; a="211924934"
Message-ID: <d0252772a2e4d5e824014a68a1ce9681.squirrel@www.codeaurora.org>
In-Reply-To: <1343208766-8046-3-git-send-email-ygardi@codeaurora.org>
References: <1343208766-8046-1-git-send-email-ygardi@codeaurora.org>
    <1343208766-8046-3-git-send-email-ygardi@codeaurora.org>
Date: Wed, 25 Jul 2012 04:06:31 -0700 (PDT)
Subject: Re: [PATCH v8 2/2] mmc: card: Adding support for sanitize in eMMC 
     4.5
From: merez@codeaurora.org
To: "Yaniv Gardi" <ygardi@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Yaniv Gardi" <ygardi@codeaurora.org>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, July 25, 2012 2:32 am, Yaniv Gardi wrote:
> @@ -238,6 +238,7 @@ struct mmc_host {
>  #define MMC_CAP2_BROKEN_VOLTAGE	(1 << 7)	/* Use the broken voltage */
>  #define MMC_CAP2_DETECT_ON_ERR	(1 << 8)	/* On I/O err check card removal
> */
>  #define MMC_CAP2_HC_ERASE_SZ	(1 << 9)	/* High-capacity erase size */
> +#define MMC_CAP2_SANITIZE	(1 << 10)		/* Support Sanitize */
Need to rebase and change CAP2 according to the latest number.
>
>  	mmc_pm_flag_t		pm_caps;	/* supported pm features */
>  	unsigned int        power_notify_type;
> --
> 1.7.6
> --
> Sent by a consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks,
Maya

-- 
Sent by consultant of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

