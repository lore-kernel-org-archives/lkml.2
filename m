Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2HFPty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:49:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54961 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756409Ab2HFPtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:49:53 -0400
Date: Mon, 6 Aug 2012 16:49:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 4/9] ASoC: imx: Don't use {en,dis}able_fiq() calls
Message-ID: <20120806154951.GQ16861@opensource.wolfsonmicro.com>
References: <20120805230238.GA1663@lizard>
 <1344207819-3415-4-git-send-email-anton.vorontsov@linaro.org>
 <CAKGA1bkiHj=zMJXSzoGp3fpLS3POnFXSV5y7sYYFAikqoUT9tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bkiHj=zMJXSzoGp3fpLS3POnFXSV5y7sYYFAikqoUT9tQ@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 10:19:50AM -0500, Matt Sealey wrote:

> it's not compiled in unless absolutely necessary. However, there was a
> rumble that this code may disappear or be reworked in the future
> making this also quite redundant. Since it's not in the

There's no point in the FIQ driver if the DMA drivers are supported.
