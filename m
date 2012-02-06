Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2BFSFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:05:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:21122 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab2BFSFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:05:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121536026"
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
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55202872AB1@CORPEXCH1.na.ads.idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
	 <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com>
	 <20120202214350.GB4432@flint.arm.linux.org.uk>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com>
	 <1328529182.26182.92.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com>
	 <1328542134.26182.111.camel@vkoul-udesk3>
	 <20120206155318.GA20852@flint.arm.linux.org.uk>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202872AB1@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 23:37:05 +0530
Message-ID: <1328551625.26182.139.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 09:02 -0800, Bounine, Alexandre wrote:
> 
> What if we introduce another dma_transaction_type like DMA_SLAVE_EXT
> (extended?).
> In this case all devices that adhere to the generic SLAVE interface
> still be
> registered as DMA_SLAVE and those that do not follow generic route use
> DMA_SLAVE_EXT. 
that way it would be channel specific not transaction specific as you
had asked for...?

Again, how does this solve problem of passing parameters while
preventing abuse...

-- 
~Vinod

