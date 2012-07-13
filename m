Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab2GMDjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 23:39:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:31833 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab2GMDjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 23:39:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="165246653"
Subject: Re: [PATCH 1/9 v3] dmaengine: add an shdma-base library
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <Pine.LNX.4.64.1207021936490.15365@axis700.grange>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
	 <1336576161-27082-2-git-send-email-g.liakhovetski@gmx.de>
	 <1337055734.16185.5360.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1205171912140.10086@axis700.grange>
	 <1337933737.1580.8.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1205251028530.13353@axis700.grange>
	 <Pine.LNX.4.64.1206281046320.31813@axis700.grange>
	 <Pine.LNX.4.64.1207021936490.15365@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jul 2012 08:56:17 +0530
Message-ID: <1342149977.1726.8.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 22:28 +0200, Guennadi Liakhovetski wrote:
> Hi Vinod
> 
> On Thu, 28 Jun 2012, Guennadi Liakhovetski wrote:
> 
> > Hi Vinod
> > 
> > On Fri, 25 May 2012, Guennadi Liakhovetski wrote:
> > 
> > > Hi Vinod
> > > 
> > > On Fri, 25 May 2012, Vinod Koul wrote:
> > 
> > [snip]
> > 
> > > > Let me know if you plan to fixing them or I will queue these up for 3.6
> > > 
> > > Please, queue these patches for the next merge window, we will work on 
> > > improving the driver after this split.
> > 
> > It's been a month since this mail - do I see it right, that these patches 
> > are still not in your slave-dma tree? Having them there would (1) get them 
> > some exposure and testing and (2) eventually speed up building on top of 
> > them and fixing existing driver's shortcomings. Any approximate idea when 
> > you'd be able to pull them in?
Sorry my bad, I missed them afterwards.

I will try them now. I assumed the two series I have in my inbox in on
top of these 9 patches.

> An update to this patch series: unfortunately, I forgot to include the 
> very first patch in this series. I'll send it as a reply to this mail.

-- 
~Vinod

