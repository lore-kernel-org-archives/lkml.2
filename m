Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1KPGza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 01:55:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34152 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab1KPGz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 01:55:29 -0500
Date: Wed, 16 Nov 2011 08:55:12 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Rafal Prylowski <prylowski@metasoft.pl>
Cc: linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        vinod.koul@intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        hsweeten@visionengravers.com, dan.j.williams@intel.com, lrg@ti.com
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20111116065512.GB2703@mwesterb-mobl.ger.corp.intel.com>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
 <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi>
 <4EC27EED.4030108@metasoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC27EED.4030108@metasoft.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 04:02:05PM +0100, Rafal Prylowski wrote:
> 
> 1) Control register is incorrectly programmed for IDE (m2m_hw_setup),
> probably copy-paste bug ;)

Yes, this is certainly a copy-paste bug or something. Thanks for fixing :)

Can you send a separate patch for this? Make sure you Cc Vinod Koul as he is
the maintainer of slave dma subsystem.

> 2) Kernel oops when trying to stop running transfers by calling
> dmaengine_terminate_all(...) - caused by dereferencing empty list
> in ep93xx_dma_get_active

Can you post that OOPS log? I would like to understand this problem a bit
better before we do any fixes for the driver.
