Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab1JNN6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:58:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32642 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab1JNN56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:57:58 -0400
Date: Fri, 14 Oct 2011 09:57:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/21] pci: drop unused Kconfig symbol
Message-ID: <20111014135743.GD4577@phenom.oracle.com>
References: <1318595439.6132.77.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318595439.6132.77.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E983FE2.0258:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 02:30:39PM +0200, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Can you provide a commit message describing why?

And can you also use scripts/get_maintainer.pl in the future
to copy the maintainer of this driver as well?

Thanks.
> ---
>  drivers/pci/Kconfig |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 0fa466a..b42798f 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -51,17 +51,6 @@ config XEN_PCIDEV_FRONTEND
>            The PCI device frontend driver allows the kernel to import arbitrary
>            PCI devices from a PCI backend to support PCI driver domains.
>  
> -config XEN_PCIDEV_FE_DEBUG
> -        bool "Xen PCI Frontend debugging"
> -        depends on XEN_PCIDEV_FRONTEND && PCI_DEBUG
> -	help
> -	  Say Y here if you want the Xen PCI frontend to produce a bunch of debug
> -	  messages to the system log.  Select this if you are having a
> -	  problem with Xen PCI frontend support and want to see more of what is
> -	  going on.
> -
> -	  When in doubt, say N.
> -
>  config HT_IRQ
>  	bool "Interrupts on hypertransport devices"
>  	default y
> -- 
> 1.7.4.4
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
