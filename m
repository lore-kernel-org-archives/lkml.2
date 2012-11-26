Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2KZFdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 00:33:41 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:18600
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726Ab2KZFdk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 00:33:40 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631hbe9i15d0l1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: Sethi Varun-B16395 <B16395@freescale.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Tabi Timur-B04825 <B04825@freescale.com>
Subject: RE: [PATCH 1/4 v2] iommu/fsl: Store iommu domain information
 pointer in archdata.
Thread-Topic: [PATCH 1/4 v2] iommu/fsl: Store iommu domain information
 pointer in archdata.
Thread-Index: AQHNxydXSwJHpYqzXkW8nt8NqRnsOZf7oFxw
Date: Mon, 26 Nov 2012 05:33:34 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D29AE62@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com>
 <1353419697-31269-2-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1353419697-31269-2-git-send-email-Varun.Sethi@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.77]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,
Can you please apply this patch.

Regards
Varun

> -----Original Message-----
> From: Sethi Varun-B16395
> Sent: Tuesday, November 20, 2012 7:25 PM
> To: joerg.roedel@amd.com; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Wood Scott-B07421;
> Tabi Timur-B04825
> Cc: Sethi Varun-B16395
> Subject: [PATCH 1/4 v2] iommu/fsl: Store iommu domain information pointer
> in archdata.
> 
> Add a new field in the device (powerpc) archdata structure for storing
> iommu domain information pointer. This pointer is stored when the device
> is attached to a particular domain.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
>  arch/powerpc/include/asm/device.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/device.h
> b/arch/powerpc/include/asm/device.h
> index 77e97dd..6dc79fe 100644
> --- a/arch/powerpc/include/asm/device.h
> +++ b/arch/powerpc/include/asm/device.h
> @@ -28,6 +28,10 @@ struct dev_archdata {
>  		void		*iommu_table_base;
>  	} dma_data;
> 
> +	/* IOMMU domain information pointer. This would be set
> +	 * when this device is attached to an iommu_domain.
> +	 */
> +	void			*iommu_domain;
>  #ifdef CONFIG_SWIOTLB
>  	dma_addr_t		max_direct_dma_addr;
>  #endif
> --
> 1.7.4.1


