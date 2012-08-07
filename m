Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2HGSd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:33:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35771 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2HGSdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:33:25 -0400
Date: Tue, 7 Aug 2012 14:23:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 12/23] xen/arm: introduce CONFIG_XEN on ARM
Message-ID: <20120807182337.GP15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-12-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-12-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:15PM +0100, Stefano Stabellini wrote:
> Changes in v2:
> 
> - mark Xen guest support on ARM as EXPERIMENTAL.

OK. Looks good.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/Kconfig |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a91009c..f14664b 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1855,6 +1855,16 @@ config DEPRECATED_PARAM_STRUCT
>  	  This was deprecated in 2001 and announced to live on for 5 years.
>  	  Some old boot loaders still use this way.
>  
> +config XEN_DOM0
> +	def_bool y
> +
> +config XEN
> +	bool "Xen guest support on ARM (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL && ARM && OF
> +	select XEN_DOM0
> +	help
> +	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
> +
>  endmenu
>  
>  menu "Boot options"
> -- 
> 1.7.2.5
