Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab0JSJsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:48:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:19096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161Ab0JSJsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:48:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="848597969"
Date: Tue, 19 Oct 2010 11:48:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, axel.lin@gmail.com,
        hartleys@visionengravers.com, ian@mnementh.co.uk
Subject: Re: [PATCH] Remove __devinitdata from tc6393xb_mmc_resources
Message-ID: <20101019094818.GH2736@sortiz-mobl>
References: <1286675743-7261-1-git-send-email-marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286675743-7261-1-git-send-email-marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Sun, Oct 10, 2010 at 03:55:43AM +0200, Marek Vasut wrote:
> This static struct resource tc6393xb_mmc_resources[] is used in resume function,
> therefore the data can not be wiped after init.
> 
> Also, this causes a section mismatch.
Patch applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
>  drivers/mfd/tc6393xb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> index ef6c42c..1ea80d8 100644
> --- a/drivers/mfd/tc6393xb.c
> +++ b/drivers/mfd/tc6393xb.c
> @@ -155,7 +155,7 @@ static struct resource __devinitdata tc6393xb_nand_resources[] = {
>  	},
>  };
>  
> -static struct resource __devinitdata tc6393xb_mmc_resources[] = {
> +static struct resource tc6393xb_mmc_resources[] = {
>  	{
>  		.start	= 0x800,
>  		.end	= 0x9ff,
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
