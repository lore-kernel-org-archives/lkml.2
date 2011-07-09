Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1GIOIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 10:08:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47778 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753471Ab1GIOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:08:50 -0400
Date: Sat, 9 Jul 2011 23:08:36 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regmap: Add I2C bus support
Message-ID: <20110709140833.GA17655@opensource.wolfsonmicro.com>
References: <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110709115307.GA19804@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110709115307.GA19804@pengutronix.de>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 01:53:07PM +0200, Wolfram Sang wrote:
> On Sat, Jul 09, 2011 at 01:50:42PM +0900, Mark Brown wrote:

> > +#include <linux/regmap.h>
> > +#include <linux/i2c.h>
> > +#include <linux/module.h>

> I second Lars-Peter with init.h here (from his first review).

Remind me of what you're talking about here?

> > +	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_PROTOCOL_MANGLING))
> > +		return -ENOTSUPP;

> Even more here. MANGLING is not needed for reading (and it will fail for a
> number of i2c-masters).

Huh, though I'd removed this.
