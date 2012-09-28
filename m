Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab2I1KwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:52:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59962 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757271Ab2I1KwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:52:14 -0400
Date: Fri, 28 Sep 2012 11:52:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Fabio Estevam <festevam@gmail.com>, sameo@linux.intel.com, marex@denx.de,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2] mfd: da9052-core:  Use regmap_irq_get_virq() and fix
 the probe
Message-ID: <20120928105212.GC30869@opensource.wolfsonmicro.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
 <201209280642.05747.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209280642.05747.arnd@arndb.de>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 06:42:05AM +0000, Arnd Bergmann wrote:
> On Friday 28 September 2012, Fabio Estevam wrote:

> > I also plan to convert the other da9052 drivers to use regmap_irq_get_virq().

> Ok, I think they have to be submitted together though, because otherwise
> the other drivers are more broken now.

Given that the drivers don't currently load I'm not sure it's worth the
effort of arranging to get them all merged through one tree, probably
easier to get as many fixes as possible merged as fast as possible.
