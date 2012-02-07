Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2BGONI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:13:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:15907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513Ab2BGONG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:13:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104126457"
Subject: RE: [PATCH 01/11] dmaengine: add context parameter
 toprep_slave_sgand prep_dma_cyclic
From: Vinod Koul <vinod.koul@intel.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Russell King <rmk@arm.linux.org.uk>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552028C2A5D@CORPEXCH1.na.ads.idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
	 <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com>
	 <20120202214350.GB4432@flint.arm.linux.org.uk>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com>
	 <1328529182.26182.92.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com>
	 <1328542134.26182.111.camel@vkoul-udesk3>
	 <20120206155318.GA20852@flint.arm.linux.org.uk>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202872AB1@CORPEXCH1.na.ads.idt.com>
	 <1328551625.26182.139.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202872B3D@CORPEXCH1.na.ads.idt.com>
	 <1328585993.26182.143.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552028C2A5D@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 19:44:17 +0530
Message-ID: <1328624057.26182.144.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 06:01 -0800, Bounine, Alexandre wrote:
> Currently function private_candidate() allows filtering function
> not to be specified and therefore skip the filter check.
> It may be a good safety measure to ensure that channels specified
> as DMA_SLAVE_EXT provide a corresponding filter routine so they
> positively identify dma channel that will accept intended extra
> parameter.
> I assume that a system may have more than one dmac registered as
> DMA_SLAVE_EXT. 
> 
> This is what I have for RapidIO - the filter call ensures that DMA
> channel is associated with a RapidIO controller that provides access
> to the specified SRIO device. 
For slave-dma it's better to have a filter :)
-- 
~Vinod

