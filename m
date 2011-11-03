Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab1KCRvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933509Ab1KCRvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:51:53 -0400
Message-ID: <4EB2D4B6.3080903@redhat.com>
Date: Thu, 03 Nov 2011 15:51:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sb_edac 32-bit compile fail due to 64-bit divide
References: <20111103140716.GF19809@zod.bos.redhat.com> <4EB2A5FF.1040808@redhat.com> <20111103144347.GG19809@zod.bos.redhat.com> <987664A83D2D224EAE907B061CE93D5301F566BB32@orsmsx505.amr.corp.intel.com> <4EB2D260.7070807@redhat.com> <20111103174841.GH19809@zod.bos.redhat.com>
In-Reply-To: <20111103174841.GH19809@zod.bos.redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-11-2011 15:48, Josh Boyer escreveu:

> How's the below?

Ack.

I'll add it on my tree and submit it to Linus for its addition.
> 
> josh
> 
> ---
> 
> From: Josh Boyer <jwboyer@redhat.com>
> Subject: [PATCH] edac: Only build sb_edac on 64-bit
> 
> The sb_edac driver is marginally useful on a 32-bit kernel, and
> currently has 64-bit divide compile errors when building that config.
> For now, make this build on only for 64-bit kernels.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> 
> ---
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 203361e..5948a21 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -214,7 +214,7 @@ config EDAC_I7300
>  
>  config EDAC_SBRIDGE
>  	tristate "Intel Sandy-Bridge Integrated MC"
> -	depends on EDAC_MM_EDAC && PCI && X86 && X86_MCE_INTEL
> +	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL
>  	depends on EXPERIMENTAL
>  	help
>  	  Support for error detection and correction the Intel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

