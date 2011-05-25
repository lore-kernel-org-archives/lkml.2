Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab1EYIdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:33:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:9217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab1EYIda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="8328473"
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        ryan@bluewatersys.com, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
	 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 13:30:03 +0530
Message-ID: <1306310403.30236.94.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-22 at 20:03 +0300, Mika Westerberg wrote:
> The ep93xx DMA controller has 10 independent memory to peripheral (M2P)
> channels, and 2 dedicated memory to memory (M2M) channels. M2M channels can
> also be used by SPI and IDE to perform DMA transfers to/from their memory
> mapped FIFOs.
> 
> This driver supports both M2P and M2M channels with DMA_SLAVE, DMA_CYCLIC and
> DMA_MEMCPY (M2M only) capabilities.
> 
Acked-by: Vinod Koul <vinod.koul@intel.com>

Which tree are these patches going thru?

-- 
~Vinod

