Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1CBRNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:13:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:11731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab1CBRNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:13:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,254,1297065600"; 
   d="scan'208";a="608284021"
Subject: Re: [PATCH 1/8 resend] dw_dmac: Remove compilation dependency from
 AVR32
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linus.walleij@stericsson.com, amit.goel@st.com,
        linux-kernel@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1298889267.git.viresh.kumar@st.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
	 <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1298889267.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 22:16:12 +0530
Message-ID: <1299084372.6974.91.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 16:11 +0530, Viresh Kumar wrote:
> This will be used in SPEAr, ARM family.
Does this mean it can be used on AVR32 now? Did you implay it will
*also* be....
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 1c28816..95c7db7 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -82,7 +82,6 @@ config INTEL_IOP_ADMA
>  
>  config DW_DMAC
>  	tristate "Synopsys DesignWare AHB DMA support"
> -	depends on AVR32
Shouldn't you be adding a corresponding depends on new arch? And since
this supports old arch as well, it should say depends on both...
>  	select DMA_ENGINE
>  	default y if CPU_AT32AP7000
>  	help


-- 
~Vinod

