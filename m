Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2CLOGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:06:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38410 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2CLOGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:06:33 -0400
Date: Mon, 12 Mar 2012 14:06:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Marc Reilly <marc@cpdesign.com.au>, sameo@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        spi-devel-general@lists.sourceforge.net, oskar@scara.com
Subject: Re: mfd: mc13xxx: add I2C support, V2
Message-ID: <20120312140620.GB14020@sirena.org.uk>
References: <1331429402-9639-1-git-send-email-marc@cpdesign.com.au>
 <20120311115018.GA16825@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120311115018.GA16825@pengutronix.de>
X-Cookie: Yow!  Are we laid back yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 12:50:18PM +0100, Wolfram Sang wrote:

> free, if this is desired. I think the regmap approach should have been tried
> before we go custom. sound/soc/codecs/ad193x.c might give an impression how
> regmap spi/i2c in one driver could look like.

There's a bunch of other examples in sound/soc and also the wm831x PMIC
driver in drivers/mfd.  For an initial conversion I'd not worry about
the cache, especially with some of the older PMICs hardware designers
were known to come up with some "innovative usability solutions" which
can cause hassle.
