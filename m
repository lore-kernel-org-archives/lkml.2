Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2CIOHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:07:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47816 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2CIOHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:07:22 -0500
Date: Fri, 9 Mar 2012 14:07:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
	__dma_request_channel()
Message-ID: <20120309140705.GV17370@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1203080902170.29847@axis700.grange> <1331204128.4657.54.camel@vkoul-udesk3> <Pine.LNX.4.64.1203081200170.29847@axis700.grange> <1331206459.4657.59.camel@vkoul-udesk3> <1331211513.4657.67.camel@vkoul-udesk3> <Pine.LNX.4.64.1203081412550.29847@axis700.grange> <1331284918.4657.69.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091022200.7852@axis700.grange> <1331285959.4657.76.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091049060.7852@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203091049060.7852@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 01:20:08PM +0100, Guennadi Liakhovetski wrote:
> As Russell mentioned, struct dma_slave_config isn't suitable for channel 
> configuration.

Actually, I said the exact reverse of what you've just stated.

I also stated (on more than one occasion) that dma_slave_config contains
nothing relevant to channel selection.
