Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2CNLJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:09:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:41913 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2CNLJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:09:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="77364931"
Subject: Re: [PATCH v3 00/13] dmaengine: imx-dma: merge dma arch code into
 dmaengine.
From: Vinod Koul <vinod.koul@intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
In-Reply-To: <CACKLOr0XzE0PZk=k5xQQvOA_5dfBk1mYDVyKCep36=3w7ugwWg@mail.gmail.com>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
	 <20120309174411.GI3852@pengutronix.de>
	 <CACKLOr0XzE0PZk=k5xQQvOA_5dfBk1mYDVyKCep36=3w7ugwWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Mar 2012 16:44:54 +0530
Message-ID: <1331723694.1727.28.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 08:43 +0100, javier Martin wrote:
> On 9 March 2012 18:44, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Fri, Mar 09, 2012 at 04:20:36PM +0100, Javier Martin wrote:
> >> The following series have to be applied on top of the following patches:
> >> [PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
> >> [PATCH v3 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
> >>
> >> As discussed with Vinod and Sascha, the file 'arch/arm/mach-imx/dma-v1.c'
> >> is deprecated and no new patches are accepted for it.
> >>
> >> This series merges this code into the imx-dma.c dmaengine driver.
> >
> > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> >
> 
> Vinod,
> I think with Sascha's ack, this series is ready to be merged. It's
> quite important for us that it makes it for 3.4.
> 
> Please, don't forget the following patch too, which is meant to be
> applied on top of this series:
> 
> [PATCH] dmaengine: i.MX: Add support for interleaved transfers.
> 
This is my merge queue which means I will merged it after the cookie
fixes (hate rebasing that series again)

-- 
~Vinod

