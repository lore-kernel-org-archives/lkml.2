Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab2INQMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:12:44 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:19008 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab2INQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:12:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,423,1344211200"; 
   d="scan'208";a="14551616"
Date: Fri, 14 Sep 2012 17:11:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 09/10] xen/swiotlb: Fix compile warnings when using plain
 integer instead of NULL pointer.
In-Reply-To: <1347306367-28669-10-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1209141711310.29232@kaball.uk.xensource.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com> <1347306367-28669-10-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Konrad Rzeszutek Wilk wrote:
> arch/x86/xen/pci-swiotlb-xen.c:96:1: warning: Using plain integer as NULL pointer
> arch/x86/xen/pci-swiotlb-xen.c:96:1: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/pci-swiotlb-xen.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> index 406f9c4..fc0c78f 100644
> --- a/arch/x86/xen/pci-swiotlb-xen.c
> +++ b/arch/x86/xen/pci-swiotlb-xen.c
> @@ -97,6 +97,6 @@ int pci_xen_swiotlb_init_late(void)
>  EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
>  
>  IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
> -		  0,
> +		  NULL,
>  		  pci_xen_swiotlb_init,
> -		  0);
> +		  NULL);
> -- 
> 1.7.7.6
> 
