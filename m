Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1EYIxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:53:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:36354 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1EYIxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:53:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="4449797"
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@iki.fi>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hsweeten@visionengravers.com, ryan@bluewatersys.com,
        Dan Williams <dan.j.williams@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <BANLkTi=3z3kO5VEe2up8Mfm+bNXkY3baUw@mail.gmail.com>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
	 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
	 <BANLkTi=3z3kO5VEe2up8Mfm+bNXkY3baUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 13:49:53 +0530
Message-ID: <1306311593.30236.103.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 10:39 +0200, Linus Walleij wrote:
> 2011/5/22 Mika Westerberg <mika.westerberg@iki.fi>:
> 
> > The ep93xx DMA controller has 10 independent memory to peripheral (M2P)
> > channels, and 2 dedicated memory to memory (M2M) channels. M2M channels can
> > also be used by SPI and IDE to perform DMA transfers to/from their memory
> > mapped FIFOs.
> 
> No so much a review comment as an observation: I opposed the merge of the
> EP93xx SPI driver in drivers/spi/ep93xx_spi.c on the grounds that it was close
> enough to amba-pl022.c that it could use that driver instead.
> 
> One of the arguments against was that you were going to do custom DMA
> and stuff. Now you're using the DMAengine, so can you please reconsider
> refactoring amba-pl022.c to suit your needs and you'll get DMA support for
> free mor or less.
Linus is the dma IP same as existing ones? 
In that case we shouldn't have a new driver for same IP.

-- 
~Vinod

