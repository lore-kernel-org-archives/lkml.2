Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2ISVCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:02:00 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:57521 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2ISVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:01:58 -0400
Date: Wed, 19 Sep 2012 21:01:57 +0000 (UTC)
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
Subject: Re: [PATCH v2 1/9] ARM: OMAP: iommu: fix including iommu.h without
 IOMMU_API selected
In-Reply-To: <1347479152-588-2-git-send-email-omar.luna@linaro.org>
Message-ID: <alpine.DEB.2.00.1209192101450.5264@utopia.booyaka.com>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org> <1347479152-588-2-git-send-email-omar.luna@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Omar Ramirez Luna wrote:

> If included without IOMMU_API being selected it will break
> compilation:
> 
> arch/arm/plat-omap/include/plat/iommu.h:
> 	In function 'dev_to_omap_iommu':
> arch/arm/plat-omap/include/plat/iommu.h:148:
> 	error: 'struct dev_archdata' has no member named 'iommu'
> 
> This will be seen when hwmod includes iommu.h to get the
> structure for attributes. Also needed for tidspbridge
> incremental migration to use iommu code.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>

Thanks, queued for 3.7.

- Paul
