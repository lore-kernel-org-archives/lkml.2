Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab0ETW7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:59:44 -0400
Received: from mga05.intel.com ([192.55.52.89]:54338 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754546Ab0ETW7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,273,1272870000"; 
   d="scan'208";a="569175241"
Date: Fri, 21 May 2010 00:59:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: twl5031: Rename sih modules
Message-ID: <20100520225935.GE3130@sortiz.org>
References: <1274349860-1736-1-git-send-email-ilkka.koskinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274349860-1736-1-git-send-email-ilkka.koskinen@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilkka,

On Thu, May 20, 2010 at 01:04:20PM +0300, Ilkka Koskinen wrote:
> Fix the names of twl5031 specific sih modules to match
> the documentation.
Patch applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> ---
>  drivers/mfd/twl4030-irq.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
> index 202bdd5..097f24d 100644
> --- a/drivers/mfd/twl4030-irq.c
> +++ b/drivers/mfd/twl4030-irq.c
> @@ -232,10 +232,11 @@ static const struct sih sih_modules_twl5031[8] = {
>  	},
>  	[6] = {
>  		/*
> -		 * ACI doesn't use the same SIH organization.
> -		 * For example, it supports only one interrupt line
> +		 * ECI/DBI doesn't use the same SIH organization.
> +		 * For example, it supports only one interrupt output line.
> +		 * That is, the interrupts are seen on both INT1 and INT2 lines.
>  		 */
> -		.name		= "aci",
> +		.name		= "eci_dbi",
>  		.module		= TWL5031_MODULE_ACCESSORY,
>  		.bits		= 9,
>  		.bytes_ixr	= 2,
> @@ -247,8 +248,8 @@ static const struct sih sih_modules_twl5031[8] = {
>  
>  	},
>  	[7] = {
> -		/* Accessory */
> -		.name		= "acc",
> +		/* Audio accessory */
> +		.name		= "audio",
>  		.module		= TWL5031_MODULE_ACCESSORY,
>  		.control_offset	= TWL5031_ACCSIHCTRL,
>  		.bits		= 2,
> -- 
> 1.6.0.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
