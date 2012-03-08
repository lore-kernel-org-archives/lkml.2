Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2CHKu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:50:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:31007 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab2CHKuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:50:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116314189"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
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
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Mar 2012 16:25:28 +0530
Message-ID: <1331204128.4657.54.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 11:16 +0100, Guennadi Liakhovetski wrote:
> I still have the impression, that my specific use-case (sh-mobile), where 
> channels can be freely configured for use by _ANY_ client on one of 
> _SEVERAL_ DMAC instances, is not fully understood or taken into account. 
> For this driver any kind of fixed mapping means, that we'd have to use 
> both virtual channels and controllers, adding _a lot_ of complexity to the 
> DMAC driver and making the dmaengine core just an "obfuscation layer." 
> Yes, I remember Russell proposing core helpers for this. They would help, 
> but (1) when would they be available, (2) how well would they be suitable 
> for us, (3) they'd take the coding / maintainance burden away, but 
> wouldn't reduce complexity and run-time overhead. 
Lets try to address you case as well.
On a typical platform
1) how many dma controllers you have?
2) how many clients you have
3) which client can use what controller channel? How is mapping decided,
do you have a mux, is it hard wired by soc designers,....?

Can you pls give a description so that we ensure all models fit in the
final solution?

-- 
~Vinod

