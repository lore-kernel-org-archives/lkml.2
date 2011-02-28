Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1B1G0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:26:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48257 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1B1G0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:26:06 -0500
Date: Mon, 28 Feb 2011 15:26:00 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 06/09] ARM: s3c2440: gta02: Remove state_mem constraints
 for the pcf50633 regulators
In-reply-to: <1297043521-21903-6-git-send-email-lars@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <000401cbd710$6035fab0$20a1f010$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvGaWw9Z926sH+ITPWQfmVuGe4xOgQpmwkw
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
 <1297043521-21903-6-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> The pcf50633 regulator driver does not use the state_mem constraints, so
> there
> is no use in setting them.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/arm/mach-s3c2440/mach-gta02.c |   15 ---------------
>  1 files changed, 0 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2440/mach-gta02.c
b/arch/arm/mach-s3c2440/mach-
> gta02.c
> index e57c4d8..01e0930 100644
> --- a/arch/arm/mach-s3c2440/mach-gta02.c
> +++ b/arch/arm/mach-s3c2440/mach-gta02.c
> @@ -283,9 +283,6 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  				.valid_modes_mask = REGULATOR_MODE_NORMAL,
>  				.always_on = 1,
>  				.apply_uV = 1,
> -				.state_mem = {
> -					.enabled = 1,
> -				},
>  			},
>  		},
>  		[PCF50633_REGULATOR_DOWN1] = {
> @@ -304,9 +301,6 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  				.valid_modes_mask = REGULATOR_MODE_NORMAL,
>  				.apply_uV = 1,
>  				.always_on = 1,
> -				.state_mem = {
> -					.enabled = 1,
> -				},
>  			},
>  		},
>  		[PCF50633_REGULATOR_HCLDO] = {
> @@ -325,9 +319,6 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  				.valid_modes_mask = REGULATOR_MODE_NORMAL,
>  				.valid_ops_mask = REGULATOR_CHANGE_STATUS,
>  				.apply_uV = 1,
> -				.state_mem = {
> -					.enabled = 0,
> -				},
>  			},
>  		},
>  		[PCF50633_REGULATOR_LDO2] = {
> @@ -362,9 +353,6 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  				.valid_modes_mask = REGULATOR_MODE_NORMAL,
>  				.valid_ops_mask = REGULATOR_CHANGE_STATUS,
>  				.apply_uV = 1,
> -				.state_mem = {
> -					.enabled = 1,
> -				},
>  			},
>  		},
>  		[PCF50633_REGULATOR_LDO6] = {
> @@ -379,9 +367,6 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  				.min_uV = 1800000,
>  				.max_uV = 1800000,
>  				.valid_modes_mask = REGULATOR_MODE_NORMAL,
> -				.state_mem = {
> -					.enabled = 1,
> -				},
>  			},
>  		},
> 
> --

Don't we need regulator_suspend_mem_state_show() on PCF50633?


Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

