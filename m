Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0GNJar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:30:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:56255 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0GNJaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:30:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,201,1278313200"; 
   d="scan'208";a="817978116"
Date: Wed, 14 Jul 2010 11:30:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Add additional WM8994 GPIO functions
Message-ID: <20100714093041.GB2771@sortiz-mobl>
References: <1278590991-9406-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278590991-9406-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Jul 08, 2010 at 09:09:51PM +0900, Mark Brown wrote:
> Later revisions of the WM8994 add some more GPIO functions, define them
> in the header file.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
applied to my for-next branch, thanks.

Cheers,
Samuel.


> ---
>  include/linux/mfd/wm8994/gpio.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mfd/wm8994/gpio.h b/include/linux/mfd/wm8994/gpio.h
> index b4d4c22..0c79b5f 100644
> --- a/include/linux/mfd/wm8994/gpio.h
> +++ b/include/linux/mfd/wm8994/gpio.h
> @@ -36,6 +36,10 @@
>  #define WM8994_GP_FN_WSEQ_STATUS    16
>  #define WM8994_GP_FN_FIFO_ERROR     17
>  #define WM8994_GP_FN_OPCLK          18
> +#define WM8994_GP_FN_THW	    19
> +#define WM8994_GP_FN_DCS_DONE	    20
> +#define WM8994_GP_FN_FLL1_OUT       21
> +#define WM8994_GP_FN_FLL2_OUT       22
>  
>  #define WM8994_GPN_DIR                          0x8000  /* GPN_DIR */
>  #define WM8994_GPN_DIR_MASK                     0x8000  /* GPN_DIR */
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
