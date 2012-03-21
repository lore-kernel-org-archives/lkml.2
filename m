Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab2CUPgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:36:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:53280 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab2CUPgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:36:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="142598093"
Subject: Re: [PATCH v3 00/13] dmaengine: imx-dma: merge dma arch code into
 dmaengine.
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
In-Reply-To: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Mar 2012 21:09:23 +0530
Message-ID: <1332344363.19804.12.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 16:20 +0100, Javier Martin wrote:
> The following series have to be applied on top of the following patches:
> [PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
> [PATCH v3 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
> 
> As discussed with Vinod and Sascha, the file 'arch/arm/mach-imx/dma-v1.c'
> is deprecated and no new patches are accepted for it.
> 
> This series merges this code into the imx-dma.c dmaengine driver.
> 
> Notes for v3:
>  - I send the whole series again despite some patches being the same. I think
>  this is more comfortable for Vinod than just sending those patches that have
>  been modified.
>  - I've generated my series with the following command this time:
>  'git format-patch -s -13 -M -B --subject-prefix="PATCH v3"' as suggested by
>  Sascha but still removing two files in 01/13 generates a lot of noisy diffs.
>  Sorry about that.
>  - I don't include Sascha's Tested-by since maybe he wants to test this last
>  version.
This doesn't apply for me (starting with 6th) on current slave-dma.next
due to obvious changes which have gone into imx.

Can you quickly rebase the series and resend.

Also while at it please fix the checkpatch error

ERROR: space required after that ',' (ctx:VxV)
#4143: FILE: drivers/dma/imx-dma.c:275:
+       dev_dbg(imxdma->dev,"%s channel %d\n", __func__, channel);


-- 
~Vinod

