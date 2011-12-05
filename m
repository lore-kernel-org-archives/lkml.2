Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1LECuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 21:50:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:37706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab1LECuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 21:50:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,296,1320652800"; 
   d="scan'208";a="98556010"
Subject: Re: [PATCH v2 1/2] dma/ep93xx_dma: fix initialization of M2M
 control register
From: Vinod Koul <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        hsweeten@visionengravers.com, rmallon@gmail.com,
        Rafal Prylowski <prylowski@metasoft.pl>
In-Reply-To: <1bb25192ca6c0dc6f3631a3f937120d560e4e643.1322304185.git.mika.westerberg@iki.fi>
References: <1bb25192ca6c0dc6f3631a3f937120d560e4e643.1322304185.git.mika.westerberg@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 08:18:29 +0530
Message-ID: <1323053309.30390.44.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-26 at 12:54 +0200, Mika Westerberg wrote:
> From: Rafal Prylowski <prylowski@metasoft.pl>
> 
> Setting the flags in case of IDE didn't have any effect since the control
> register is overwritten few lines below. So move these to be after the control
> register is initialized.
> 
> Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Applied both, Thanks

I got a trivial merge conflict on both patches as I think these patches
were of made on top of dma_slave_direction changes we did sometime back.

So please do check if merges were right...


-- 
~Vinod

