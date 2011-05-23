Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1EWFLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:11:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53634 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751120Ab1EWFLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:11:16 -0400
Date: Mon, 23 May 2011 13:11:09 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        ryan@bluewatersys.com, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 3/5] ASoC: ep93xx: convert to use the DMA engine API
Message-ID: <20110523051102.GA10683@opensource.wolfsonmicro.com>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <9f8dd1eb40a6cb44d8207c84f244345a98bb9c0f.1306082097.git.mika.westerberg@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f8dd1eb40a6cb44d8207c84f244345a98bb9c0f.1306082097.git.mika.westerberg@iki.fi>
X-Cookie: There is a 20% chance of tomorrow.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 08:03:06PM +0300, Mika Westerberg wrote:
> Now that we have the EP93xx DMA engine driver in place, we convert the ASoC
> drivers (I2S, AC97 and PCM) to take advantage of this new API. There are no
> functional changes.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Given that dmaengine is a standard API I'm wondering if we'll be able to
make some sort of generic dmaengine DMA driver for ASoC that could be
shared more widely.
