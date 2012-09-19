Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2ISVfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:35:13 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:57701 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2ISVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:35:08 -0400
Date: Wed, 19 Sep 2012 21:35:06 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 2/9] ARM: OMAP3: hwmod data: add mmu data for iva and
 isp
In-Reply-To: <1347479152-588-3-git-send-email-omar.luna@linaro.org>
Message-ID: <alpine.DEB.2.00.1209192134490.5264@utopia.booyaka.com>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org> <1347479152-588-3-git-send-email-omar.luna@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Omar Ramirez Luna wrote:

> Add mmu hwmod data for iva and isp.
> 
> Due to compatibility an ifdef CONFIG_OMAP_IOMMU_IVA2 needs to be
> propagated (previously on iommu resource info) to hwmod data in OMAP3,
> so users of iommu and tidspbridge can avoid issues of two modules
> managing mmu data/irqs/resets; this until tidspbridge can be migrated
> to iommu framework.
> 
> Cc: Benoit Cousson <b-cousson@ti.com>
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>

Thanks, queued for 3.7.

- Paul
