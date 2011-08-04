Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab1HDFL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 01:11:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:45315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1HDFLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 01:11:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,315,1309762800"; 
   d="scan'208";a="34214653"
Subject: Re: [PATCH] dmaengine: add helper function for slave_single
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110725154739.GD14955@n2100.arm.linux.org.uk>
References: <1311608235.8206.24.camel@vkoul-mobl4>
	 <20110725154739.GD14955@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 09:57:58 +0530
Message-ID: <1312432078.1536.561.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 16:47 +0100, Russell King - ARM Linux wrote:
> On Mon, Jul 25, 2011 at 09:07:15PM +0530, Vinod Koul wrote:
> > >From af9afd16e9954edb45f0cf71834653133d75e79c Mon Sep 17 00:00:00 2001
> > From: Vinod Koul <vinod.koul@intel.com>
> > Date: Mon, 25 Jul 2011 19:57:52 +0530
> > Subject: [PATCH] dmaengine: add helper function for slave_single
> > 
> > For clients which require a single slave transfer and dont want to be bothered
> > about the scatterlist api, this helper gives simple API for this transfer and
> > creates single scatterlist for DMA API
> > 
> > Idea from Russel King
> 
> Please correct this, thanks.
Your wish, I recall you posting similar code in some other thread

I will apply this so that ppl can start using it

-- 
~Vinod

