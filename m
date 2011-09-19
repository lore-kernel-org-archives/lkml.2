Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab1ISDR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 23:17:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:2136 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1ISDR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 23:17:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,403,1312182000"; 
   d="scan'208";a="53034130"
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
From: Vinod Koul <vinod.koul@intel.com>
To: Alan Cox <alan@linux.intel.com>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        evolution@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>
In-Reply-To: <20110914195237.606d11f6@bob.linux.org.uk>
References: <Pine.LNX.4.64.1109051002400.1112@axis700.grange>
	 <1315228408.26251.75.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1109051532220.1112@axis700.grange>
	 <1315233788.26251.163.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1109051700030.1112@axis700.grange>
	 <1315235335.26251.194.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1109051716530.1112@axis700.grange>
	 <438BB0150E931F4B9CE701519A4463010871804A4B@bgsmsx502.gar.corp.intel.com>
	 <alpine.DEB.2.00.1109072048310.30407@axis700.grange>
	 <438BB0150E931F4B9CE701519A4463010871804A4F@bgsmsx502.gar.corp.intel.com>
	 <20110908012119.GJ22142@linux-sh.org>
	 <1315510263.26251.296.camel@vkoul-udesk3>
	 <1315977410.26251.476.camel@vkoul-udesk3>
	 <20110914195237.606d11f6@bob.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 08:43:59 +0530
Message-ID: <1316402039.21359.6.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 19:52 +0100, Alan Cox wrote:
> On Wed, 14 Sep 2011 10:46:50 +0530
> Vinod Koul <vinod.koul@intel.com> wrote:
> 
> > On Fri, 2011-09-09 at 01:01 +0530, Vinod Koul wrote:
> > > On Thu, 2011-09-08 at 10:21 +0900, Paul Mundt wrote:
> > > > On Thu, Sep 08, 2011 at 03:07:53AM +0530, Koul, Vinod wrote:
> > > > > On Wed, 2011-09-07 at 22:01 +0200, Guennadi Liakhovetski wrote:
> > > 
> > > I relooked at the patch, since the filtering is already done in
> > > your .alloc_chan_resources, (which should be fixed when we fix
> > > filtering), I am going to apply this patch
> > Since this is for serial driver, I can carry this patch with ACK from
> > Alan or Alan can take this patch with Ack from me
> 
> Greg normally carries them but I'm happy with this going via your tree.
Okay thanks I have applied it after fixing a trivial conflict

-- 
~Vinod

