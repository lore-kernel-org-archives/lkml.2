Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab2CTHH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 03:07:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:33499 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab2CTHH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 03:07:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="122789022"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1203191722390.11516@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	 <20120307093026.GM17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
	 <20120307103112.GP17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
	 <20120307124620.GT17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
	 <20120307142634.GA18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
	 <20120307162755.GB18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
	 <1331188201.4657.51.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
	 <1331204128.4657.54.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203081200170.29847@axis700.grange>
	 <1331206459.4657.59.camel@vkoul-udesk3>
	 <1331211513.4657.67.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203081412550.29847@axis700.grange>
	 <1331284918.4657.69.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203091022200.7852@axis700.grange>
	 <1331285959.4657.76.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203091049060.7852@axis700.grange>
	 <1331520476.4657.79.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203161029490.13465@axis700.grange>
	 <1332157021.7180.5.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203191244240.11516@axis700.grange>
	 <1332164062.7180.19.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203191436030.11516@axis700.grange>
	 <1332165604.7180.24.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203191502170.11516@axis700.grange>
	 <1332166938.7180.38.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203191524200.11516@axis700.grange>
	 <1332174036.12110.15.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203191722390.11516@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 12:41:33 +0530
Message-ID: <1332227493.12110.21.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 17:32 +0100, Guennadi Liakhovetski wrote:
> Sure. In the datasheet we have: to configure a channel for client 1 write 
> value X to register A and value Y to register B. That's it. One of them is 
> really just a magic slave ID. Another one has several fields with values 
> like bus width and transfer size. They could be passed "properly," but 
> since those fields also vary between DMAC versions, it is easier to just 
> fix the whole register value per client and pass it from the platform 
> data. In any case, at least the slave ID is really just a constant, that 
> cannot be calculated and has to be passed from platform data.
I think I like the idea of having the these slave IDs coming from
platform map. That way drivers can be agnostic...

-- 
~Vinod

