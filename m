Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1KXRWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:22:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50490 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846Ab1KXRWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:22:20 -0500
Date: Thu, 24 Nov 2011 17:22:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: samsung: drop unknown Kconfig symbol
Message-ID: <20111124172216.GR8470@opensource.wolfsonmicro.com>
References: <1322155037.25125.61.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322155037.25125.61.camel@x61.thuisdomein>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 06:17:17PM +0100, Paul Bolle wrote:
> There's no Kconfig symbol 'MACH_NEO1973_GTA01'. So drop all Kconfig
> references to that symbol and all code that depends on
> CONFIG_MACH_NEO1973_GTA01. This also allows for some related cleanups
> (eg, drop some checks for CONFIG_MACH_NEO1973_GTA02, as they have become
> useless). Update a few strings too, to make clear that the Openmoko Neo
> Freerunner (GTA02) is supported while the Openmoko Neo 1973 (GTA01)
> isn't.

There's people somewhat actively working on the OpenMoko devices out of
tree (and I personally have a GTA01) and I'd rather not do anything that
causes any more hassle for them.  I'd suggest discussing this with the
OpenMoko guys if you want to do it.
