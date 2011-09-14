Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab1INSpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:45:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:16511 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab1INSpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:45:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="48439741"
Date: Wed, 14 Sep 2011 19:52:37 +0100
From: Alan Cox <alan@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
Message-ID: <20110914195237.606d11f6@bob.linux.org.uk>
In-Reply-To: <1315977410.26251.476.camel@vkoul-udesk3>
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
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011 10:46:50 +0530
Vinod Koul <vinod.koul@intel.com> wrote:

> On Fri, 2011-09-09 at 01:01 +0530, Vinod Koul wrote:
> > On Thu, 2011-09-08 at 10:21 +0900, Paul Mundt wrote:
> > > On Thu, Sep 08, 2011 at 03:07:53AM +0530, Koul, Vinod wrote:
> > > > On Wed, 2011-09-07 at 22:01 +0200, Guennadi Liakhovetski wrote:
> > 
> > I relooked at the patch, since the filtering is already done in
> > your .alloc_chan_resources, (which should be fixed when we fix
> > filtering), I am going to apply this patch
> Since this is for serial driver, I can carry this patch with ACK from
> Alan or Alan can take this patch with Ack from me

Greg normally carries them but I'm happy with this going via your tree.
