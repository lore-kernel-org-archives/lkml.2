Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab2CGMqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:46:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63102 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab2CGMqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:46:33 -0500
Date: Wed, 7 Mar 2012 13:45:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
Message-ID: <Pine.LNX.4.64.1203071342010.19595@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
 <Pine.LNX.4.64.1203021341590.913@axis700.grange> <1331022623.24656.191.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203060935460.9300@axis700.grange> <1331035739.24656.201.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203061339330.9300@axis700.grange> <1331101687.24656.319.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
 <20120307093026.GM17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
 <20120307103112.GP17370@n2100.arm.linux.org.uk> <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:QUqe9R1SUoQ/qQIe9bog5NiyX6IGCTV2MZzmDys4D6r
 VTw3bq4KDdPWZhCg8yv3sfDlX9xt/vfPV+4vKdsCr57PkIg+dZ
 tv6OsMMetpwB/7uHbYw9fIHhaYIv78zEVL/TVMrZUowmierxkK
 6sc1/j842mAnZQlL6p0pcvUqhvGWQezYha1+pGiTiCk96WLvwh
 6GKq/EzI3o9xlRL54lFRxufR2D62cMY6V8wR5jQe166rRn7kRP
 /zKRqEiK0PNWeupbWMj6qS1nmEDo7V3ojp4FshGYQHJkmr845p
 Z0/1PesTLjhJBWlwx77hqi/7vd2aUnW/rSOdIOzC+THa654IRm
 V1dgoSATLOuT+YYTTzuXOxbNN1yvTwZ/YcbUqb8I2cpBjl/9LK
 8fDuOc3fsWwLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Guennadi Liakhovetski wrote:

> 2. (goal: eliminate filter function look-ups) proposed by Linus W
> 
> (a) client issues
> 	dma_request_slave_channel(dev, "MMC-RX")
> (b) the dmaengine core scans a platform-provided list of channel mappings 
>     and picks up _the_ correct channel (****)

I think, this could work well with Russell's idea to implement virtual DMA 
channels centrally in dmaengine core.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
