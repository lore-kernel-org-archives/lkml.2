Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2F1Iwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:52:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2F1Iwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:52:33 -0400
Date: Thu, 28 Jun 2012 10:52:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/9 v3] dmaengine: add an shdma-base library
In-Reply-To: <Pine.LNX.4.64.1205251028530.13353@axis700.grange>
Message-ID: <Pine.LNX.4.64.1206281046320.31813@axis700.grange>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de> 
 <1336576161-27082-2-git-send-email-g.liakhovetski@gmx.de> 
 <1337055734.16185.5360.camel@vkoul-udesk3>  <Pine.LNX.4.64.1205171912140.10086@axis700.grange>
 <1337933737.1580.8.camel@vkoul-udesk3> <Pine.LNX.4.64.1205251028530.13353@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:FoS+HkjmhJ5HwY6mIh8oAWMHUnnTKRftzrobXj9vU8O
 AO5DWBoM+mO/0Xbf55WPLz/6bYLmiM07aiLZfMhwmI4pVFoMWG
 13RoovofxAEv4GpT9MPAK6wgnC7ksQbY3nlbq6GNk5f9v4wn6l
 gXY/XNSnIzmPfCJUKyliKes+QT66uQg6wg4gThcz4KCTmL+sPv
 V+/3UDtonxh9z6DqtC+3MGHClb3DpzkNdyLIbOaShJrb8RDSqi
 6/tgne9ocyrcRtp1lLiKdbev2I5EfCrpUv7RpqGZqPirnC7e3u
 TpoXjs2jvel7S9opFyOL8X2oVafcE+2EWlw1bvBb0Eb3v68BJL
 b3TdU5KwF5VNCjFSnhA5WwufRu3HQVV/q4lb3Mim+cCjsYZGOk
 ecv5da3uOcBbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Fri, 25 May 2012, Guennadi Liakhovetski wrote:

> Hi Vinod
> 
> On Fri, 25 May 2012, Vinod Koul wrote:

[snip]

> > Let me know if you plan to fixing them or I will queue these up for 3.6
> 
> Please, queue these patches for the next merge window, we will work on 
> improving the driver after this split.

It's been a month since this mail - do I see it right, that these patches 
are still not in your slave-dma tree? Having them there would (1) get them 
some exposure and testing and (2) eventually speed up building on top of 
them and fixing existing driver's shortcomings. Any approximate idea when 
you'd be able to pull them in?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
