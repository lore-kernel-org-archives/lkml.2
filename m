Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0CYPHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:07:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49269 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751761Ab0CYPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:07:49 -0400
Date: Thu, 25 Mar 2010 15:07:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Joe Perches <joe@perches.com>, Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/2] DMAENGINE: generic channel status
Message-ID: <20100325150746.GA11425@rakim.wolfsonmicro.main>
References: <1269529381-16914-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269529381-16914-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 04:03:01PM +0100, Linus Walleij wrote:
> Convert the device_is_tx_complete() operation on the
> DMA engine to a generic device_tx_status()operation which
> can return three states, DMA_TX_RUNNING, DMA_TX_COMPLETE,
> DMA_TX_PAUSED.

FWIW (I've never actually used DMAENGINE...)

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
