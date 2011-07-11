Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab1GKOR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:17:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:26765 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab1GKORZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:17:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,515,1304319600"; 
   d="scan'208";a="25750214"
Subject: Re: [PATCH 3/3] iwlagn: Add missing comma between constant string
 array
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <2c8a6e15b0f320e4b4b761ae6434862fc3c15924.1310187270.git.joe@perches.com>
References: <cover.1310187270.git.joe@perches.com>
	 <2c8a6e15b0f320e4b4b761ae6434862fc3c15924.1310187270.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 06:42:54 -0700
Message-ID: <1310391774.24940.25.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 23:20 -0700, Joe Perches wrote:
> Multiple quoted strings are concatenated without comma separators.
> 
> Make the array const while there.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 7e6c463..de1a0c1 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -1563,7 +1563,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
>  	release_firmware(ucode_raw);
>  }
>  
> -static const char *desc_lookup_text[] = {
> +static const char * const desc_lookup_text[] = {
>  	"OK",
>  	"FAIL",
>  	"BAD_PARAM",
> @@ -1587,7 +1587,7 @@ static const char *desc_lookup_text[] = {
>  	"NMI_INTERRUPT_DATA_ACTION_PT",
>  	"NMI_TRM_HW_ER",
>  	"NMI_INTERRUPT_TRM",
> -	"NMI_INTERRUPT_BREAK_POINT"
> +	"NMI_INTERRUPT_BREAK_POINT",
>  	"DEBUG_0",
>  	"DEBUG_1",
>  	"DEBUG_2",

Thanks
Wey


