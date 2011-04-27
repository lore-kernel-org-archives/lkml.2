Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab1D0RnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:43:09 -0400
Received: from mail.tpi.com ([70.99.223.143]:3784 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab1D0RnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:43:07 -0400
Message-ID: <4DB85596.4070105@canonical.com>
Date: Wed, 27 Apr 2011 11:42:46 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: wey-yi.w.guy@intel.com
CC: Andi Kleen <andi@firstfloor.org>, donald.h.fry@intel.com,
        sgruszka@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [96/106] iwlagn: Support new 5000 microcode.
References: <20110426212.641772347@firstfloor.org> <20110426211418.AF9B93E1886@tassilo.jf.intel.com>
In-Reply-To: <20110426211418.AF9B93E1886@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 03:14 PM, Andi Kleen wrote:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
>
> ------------------
> From: Fry, Donald H<donald.h.fry@intel.com>
>
> commit 41504cce240f791f1e16561db95728c5537fbad9 upstream.
>
> New iwlwifi-5000 microcode requires driver support for API version 5.
>
> Signed-off-by: Don Fry<donald.h.fry@intel.com>
> Signed-off-by: Wey-Yi Guy<wey-yi.w.guy@intel.com>
> Signed-off-by: Stanislaw Gruszka<sgruszka@redhat.com>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
>
> ---
>   drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-5000.c
> ===================================================================
> --- linux-2.6.35.y.orig/drivers/net/wireless/iwlwifi/iwl-5000.c
> +++ linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-5000.c
> @@ -51,7 +51,7 @@
>   #include "iwl-agn-debugfs.h"
>
>   /* Highest firmware API version supported */
> -#define IWL5000_UCODE_API_MAX 2
> +#define IWL5000_UCODE_API_MAX 5
>   #define IWL5150_UCODE_API_MAX 2
>
>   /* Lowest firmware API version supported */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Wey-yi,

Will this cause any issues with the existing 2.6.35.12 iwl-5000 driver? 
Is the version 5 API backwards compatible? Ubuntu installs 
iwlwifi-5000-5.ucode by default in order to support compat-wireless 
backports from 2.6.3[678], so I'd hate to break those folks that are 
using the stock 2.6.35.y driver.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
