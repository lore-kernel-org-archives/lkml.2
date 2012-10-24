Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344Ab2JXD1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:27:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:54355 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934331Ab2JXD1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:27:48 -0400
Subject: Re: [PATCH 041/193] drivers/dma: remove CONFIG_EXPERIMENTAL
From: Vinod Koul <vkoul@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>
In-Reply-To: <1351022666-6960-42-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-42-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 08:45:37 +0530
Message-ID: <1351048537.5263.11.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 13:01 -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Vinod Koul <vinod.koul@intel.com>
> CC: Dan Williams <djbw@fb.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/dma/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 677cd6e..dc8f4d1 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -51,7 +51,7 @@ config ASYNC_TX_ENABLE_CHANNEL_SWITCH
>  
>  config AMBA_PL08X
>  	bool "ARM PrimeCell PL080 or PL081 support"
> -	depends on ARM_AMBA && EXPERIMENTAL
> +	depends on ARM_AMBA
>  	select DMA_ENGINE
>  	select DMA_VIRTUAL_CHANNELS
>  	help

Applied thanks

-- 
Vinod Koul
Intel Corp.

