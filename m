Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab2EODVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:21:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:54570 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326Ab2EODVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 23:21:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="144037642"
Subject: Re: [PATCH] dmaengine: fix cyclic dma usage
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rmk <rmk@arm.linux.org.uk>
In-Reply-To: <20120512193240.GA446@mwesterb-mobl.lan>
References: <1336717449.15424.1585.camel@vkoul-udesk3>
	 <20120512193240.GA446@mwesterb-mobl.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 08:44:21 +0530
Message-ID: <1337051661.16185.5288.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-12 at 22:32 +0300, Mika Westerberg wrote:
> On Fri, May 11, 2012 at 11:54:09AM +0530, Vinod Koul wrote:
> > 
> > >From 24db9e25a31ac46327253f11908463c48518dec8 Mon Sep 17 00:00:00 2001
> > From: Vinod Koul <vinod.koul@linux.intel.com>
> > Date: Fri, 11 May 2012 11:48:21 +0530
> > Subject: [PATCH] dmaengine: fix cyclic dma usage
> > 
> > for cyclic dma, dont mark the descriptor as complete.
> > Fix the remaining users of cyclic dma which do so
> > 
> > Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> 
> On ep93xx works perfectly.
> 
> Tested-by: Mika Westerberg <mika.westerberg@iki.fi>
Thanks, applied now.

-- 
~Vinod

