Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0KRH5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:57:43 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:45943 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab0KRH5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:57:42 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2010 02:57:41 EST
X-Spam-Flag: NO
X-Spam-Score: -3.489
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org, "Brian Walsh" <brian@walsh.ws>
Cc: "Russell King" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: ixp4xx export symbol dma_set_coherent_mask
References: <201011172325.10894.brian@walsh.ws>
Date: Thu, 18 Nov 2010 08:51:48 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Imre Kaloz" <kaloz@openwrt.org>
Organization: OpenWrt - Wireless Freedom
Message-ID: <op.vmcv4jpf2s3iss@ecaz>
In-Reply-To: <201011172325.10894.brian@walsh.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 05:25:10 +0100, Brian Walsh <brian@walsh.ws> wrote:

> ARM ixp4xx module building has been broken since commit 710224fa2750.
> arm: fix "arm: fix pci_set_consistent_dma_mask for dmabounce devices"
>
> Signed-off-by: Brian Walsh <brian@walsh.ws>
>
> diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
> index 24498a9..d54b219 100644
> --- a/arch/arm/mach-ixp4xx/common-pci.c
> +++ b/arch/arm/mach-ixp4xx/common-pci.c
> @@ -513,4 +513,5 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
> EXPORT_SYMBOL(ixp4xx_pci_read);
>  EXPORT_SYMBOL(ixp4xx_pci_write);
> +EXPORT_SYMBOL(dma_set_coherent_mask);
>

Same reply as for http://lists.arm.linux.org.uk/lurker/message/20101108.104326.f5a6c7dd.en.html :

http://lists.arm.linux.org.uk/lurker/message/20101102.114433.8822afb6.en.html


Russell, could you apply that patch?


Thanks,

Imre
