Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab2GBU2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:28:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2GBU2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:28:36 -0400
Date: Mon, 2 Jul 2012 22:28:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/9 v3] dmaengine: add an shdma-base library
In-Reply-To: <Pine.LNX.4.64.1206281046320.31813@axis700.grange>
Message-ID: <Pine.LNX.4.64.1207021936490.15365@axis700.grange>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de> 
 <1336576161-27082-2-git-send-email-g.liakhovetski@gmx.de> 
 <1337055734.16185.5360.camel@vkoul-udesk3>  <Pine.LNX.4.64.1205171912140.10086@axis700.grange>
 <1337933737.1580.8.camel@vkoul-udesk3> <Pine.LNX.4.64.1205251028530.13353@axis700.grange>
 <Pine.LNX.4.64.1206281046320.31813@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:v0zS9Dpc2mMyni2bU/U2/UhhpYFFeQBxVEcrTLbnmfZ
 RGPTwbDFggHVqAYerVLlQInZ5VEjP69qfT2QTUn34qz0pGiQnD
 8DvMQHDZDnVckAoWkcDPv/KLb+7i198guKlB0YyXDcPzrkxMx8
 U1e761w01zrCU0lPcuev/f9VjqBTi49hS3namNIFucOTcqYV0m
 mTG8tS/zbcgHTVIlWVz+UVGcWtxcXC4jQGthc1vMJfNTaopbqo
 2CDG4PL2vSzXR+z3Te6PcWIHyiw6Ucx4VWtvJWtVD+zKnIse/W
 QQxi0qKlXjYohzF3/cKGJDVAQcK9LkaOr8DOevpEs5XuE9I9Rh
 lZuiu5dQpuu8QBdqTJRacJ3PQrG12tncVsQcgFo0H7taOBhTl1
 5av7jiik0SBNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Thu, 28 Jun 2012, Guennadi Liakhovetski wrote:

> Hi Vinod
> 
> On Fri, 25 May 2012, Guennadi Liakhovetski wrote:
> 
> > Hi Vinod
> > 
> > On Fri, 25 May 2012, Vinod Koul wrote:
> 
> [snip]
> 
> > > Let me know if you plan to fixing them or I will queue these up for 3.6
> > 
> > Please, queue these patches for the next merge window, we will work on 
> > improving the driver after this split.
> 
> It's been a month since this mail - do I see it right, that these patches 
> are still not in your slave-dma tree? Having them there would (1) get them 
> some exposure and testing and (2) eventually speed up building on top of 
> them and fixing existing driver's shortcomings. Any approximate idea when 
> you'd be able to pull them in?

An update to this patch series: unfortunately, I forgot to include the 
very first patch in this series. I'll send it as a reply to this mail.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
