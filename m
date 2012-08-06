Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab2HFThh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:37:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51586 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755586Ab2HFThf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:37:35 -0400
Date: Mon, 6 Aug 2012 20:37:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 4/9] ASoC: imx: Don't use {en,dis}able_fiq() calls
Message-ID: <20120806193734.GA16199@opensource.wolfsonmicro.com>
References: <20120805230238.GA1663@lizard> <1344207819-3415-4-git-send-email-anton.vorontsov@linaro.org> <CAKGA1bkiHj=zMJXSzoGp3fpLS3POnFXSV5y7sYYFAikqoUT9tQ@mail.gmail.com> <20120806154951.GQ16861@opensource.wolfsonmicro.com> <CAKGA1b=_AOub_pEJJGBTb6Y7wLZaSYKQjFTyMVFSr_=9VX4wpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1b=_AOub_pEJJGBTb6Y7wLZaSYKQjFTyMVFSr_=9VX4wpg@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 01:09:26PM -0500, Matt Sealey wrote:

> So that needs to stay, the issue here is why did nobody catch
> ssi-fiq.S breaking in testing MX51
> Babbage and building a Thumb2 kernel, for example? Why did nobody
> notice it was building when
> configuring for MX3/5/6 boards (which do actually have working SSI and
> DMA, as you assume, and
> do not need this code, nor build the imx-pcm-dma-fiq part of the
> driver anyway)? I'm willing to fix all
> of the above, but if there's an obvious deficiency in testing at some
> point we need to fix that too..

As far as I can tell nobody's really running much up to date mainline on
older i.MX processors, all the work is going on the new stuff and most
of the board are on either vendor BSPs or older kernels.
