Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2GPF6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:58:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:46947 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2GPF6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:58:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193239835"
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
Date: Mon, 16 Jul 2012 11:28:34 +0530
Message-ID: <1342418314.1726.35.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 22:28 +0200, Guennadi Liakhovetski wrote:
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
> 
> An update to this patch series: unfortunately, I forgot to include the 
> very first patch in this series. I'll send it as a reply to this mail.
Applied the series along with 0.5! patch ...

-- 
~Vinod

