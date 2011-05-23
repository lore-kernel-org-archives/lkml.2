Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1EWJkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:40:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55082 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1EWJkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:40:00 -0400
Subject: Re: [PATCH 3/5] ASoC: ep93xx: convert to use the DMA engine API
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>,
        linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        ryan@bluewatersys.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110523051102.GA10683@opensource.wolfsonmicro.com>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
	 <9f8dd1eb40a6cb44d8207c84f244345a98bb9c0f.1306082097.git.mika.westerberg@iki.fi>
	 <20110523051102.GA10683@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 10:38:51 +0100
Message-ID: <1306143537.3290.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 13:11 +0800, Mark Brown wrote:
> On Sun, May 22, 2011 at 08:03:06PM +0300, Mika Westerberg wrote:
> > Now that we have the EP93xx DMA engine driver in place, we convert the ASoC
> > drivers (I2S, AC97 and PCM) to take advantage of this new API. There are no
> > functional changes.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Given that dmaengine is a standard API I'm wondering if we'll be able to
> make some sort of generic dmaengine DMA driver for ASoC that could be
> shared more widely.

Agreed and 

Acked-by: Liam Girdwood <lrg@ti.com>

