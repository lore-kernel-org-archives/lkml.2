Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1J0MUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:20:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59508 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1J0MUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:20:32 -0400
Date: Thu, 27 Oct 2011 13:20:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Zeng Zhaoming <b32542@freescale.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH v3 3/4] regulator: pass additional of_node to
 regulator_register()
Message-ID: <20111027122024.GB10089@sirena.org.uk>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
 <1319702185-16108-4-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319702185-16108-4-git-send-email-rnayak@ti.com>
X-Cookie: When does later become never?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:26:24PM +0530, Rajendra Nayak wrote:

> With device tree support for regulators, its needed that the
> regulator_dev->dev device has the right of_node attached.
> To be able to do this add an additional parameter to the
> regulator_register() api, wherein the dt-adapted driver can
> then pass this additional info onto the regulator core.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
