Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2GPJhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:37:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:31440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab2GPJhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:37:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="166817283"
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1207161040070.12302@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
	 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de>
	 <1342418828.1726.37.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
	 <1342421587.1726.49.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
	 <1342427305.1726.50.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207161040070.12302@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jul 2012 15:07:32 +0530
Message-ID: <1342431452.1726.54.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 10:47 +0200, Guennadi Liakhovetski wrote:
> > I want to know what does ccr and mid_rid mean to dmac here?
> 
> CHCR contains a few fields, some enable various interrupt sources, some 
> specify repeat- and renew-modes, others yet specify transfer size, source 
> and destination address-modes (incrementing, constant, decrementing), 
> others yet select a DMA client category (slave / memcpy / ...), and a 
> transfer flag. Some of these fields could be calculated, others are 
> pre-defined for various slaves, the exact layout of those fields can also 
> vary between SoCs.
I do not understand how clients would provide these values. 
For pre-defined values, they should be dmac property why should client
like spi or mmc have clue about it?

For others like you mentioned, i guess they could be easily calculated,
right?

> MID_RID is actually a slave-selector, it contains a magic value, that 
> cannot be calculated. 
and again, how does client know this?

-- 
~Vinod

