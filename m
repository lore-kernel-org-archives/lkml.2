Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0LIRIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:08:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:52328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab0LIRIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:08:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="685551831"
Date: Thu, 9 Dec 2010 18:08:52 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500-core chip version cut 2.0 support
Message-ID: <20101209170851.GZ8884@sortiz-mobl>
References: <1291717247-10280-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291717247-10280-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Tue, Dec 07, 2010 at 11:20:47AM +0100, Mattias Wallin wrote:
> This patch adds support for chip version 2.0 or cut 2.0.
> One new interrupt latch register - latch 12 - is introduced.
One question for you:

> diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
> index 1848781..157f000 100644
> --- a/include/linux/mfd/ab8500.h
> +++ b/include/linux/mfd/ab8500.h
> @@ -74,30 +74,37 @@
>  #define AB8500_INT_ACC_DETECT_21DB_F	37
>  #define AB8500_INT_ACC_DETECT_21DB_R	38
>  #define AB8500_INT_GP_SW_ADC_CONV_END	39
> -#define AB8500_INT_BTEMP_LOW		72
> -#define AB8500_INT_BTEMP_LOW_MEDIUM	73
> -#define AB8500_INT_BTEMP_MEDIUM_HIGH	74
> -#define AB8500_INT_BTEMP_HIGH		75
> -#define AB8500_INT_USB_CHARGER_NOT_OK	81
> -#define AB8500_INT_ID_WAKEUP_R		82
> -#define AB8500_INT_ID_DET_R1R		84
> -#define AB8500_INT_ID_DET_R2R		85
> -#define AB8500_INT_ID_DET_R3R		86
> -#define AB8500_INT_ID_DET_R4R		87
> -#define AB8500_INT_ID_WAKEUP_F		88
> -#define AB8500_INT_ID_DET_R1F		90
> -#define AB8500_INT_ID_DET_R2F		91
> -#define AB8500_INT_ID_DET_R3F		92
> -#define AB8500_INT_ID_DET_R4F		93
> -#define AB8500_INT_USB_CHG_DET_DONE	94
> -#define AB8500_INT_USB_CH_TH_PROT_F	96
> -#define AB8500_INT_USB_CH_TH_PROT_R	97
> -#define AB8500_INT_MAIN_CH_TH_PROT_F	98
> -#define AB8500_INT_MAIN_CH_TH_PROT_R	99
> -#define AB8500_INT_USB_CHARGER_NOT_OKF	103
> +#define AB8500_INT_ADP_SOURCE_ERROR	72
> +#define AB8500_INT_ADP_SINK_ERROR	73
> +#define AB8500_INT_ADP_PROBE_PLUG	74
> +#define AB8500_INT_ADP_PROBE_UNPLUG	75
> +#define AB8500_INT_ADP_SENSE_OFF	76
> +#define AB8500_INT_USB_PHY_POWER_ERR	78
> +#define AB8500_INT_USB_LINK_STATUS	79
> +#define AB8500_INT_BTEMP_LOW		80
> +#define AB8500_INT_BTEMP_LOW_MEDIUM	81
> +#define AB8500_INT_BTEMP_MEDIUM_HIGH	82
> +#define AB8500_INT_BTEMP_HIGH		83
> +#define AB8500_INT_USB_CHARGER_NOT_OK	89
> +#define AB8500_INT_ID_WAKEUP_R		90
> +#define AB8500_INT_ID_DET_R1R		92
> +#define AB8500_INT_ID_DET_R2R		93
> +#define AB8500_INT_ID_DET_R3R		94
> +#define AB8500_INT_ID_DET_R4R		95
> +#define AB8500_INT_ID_WAKEUP_F		96
> +#define AB8500_INT_ID_DET_R1F		98
> +#define AB8500_INT_ID_DET_R2F		99
> +#define AB8500_INT_ID_DET_R3F		100
> +#define AB8500_INT_ID_DET_R4F		101
> +#define AB8500_INT_USB_CHG_DET_DONE	102
> +#define AB8500_INT_USB_CH_TH_PROT_F	104
> +#define AB8500_INT_USB_CH_TH_PROT_R    105
> +#define AB8500_INT_MAIN_CH_TH_PROT_F   106
> +#define AB8500_INT_MAIN_CH_TH_PROT_R	107
> +#define AB8500_INT_USB_CHARGER_NOT_OKF	111
This new interrupt sources layout doesn't seem to be compatible with the
current one. What's the story here ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
