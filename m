Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0IIJiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:38:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45312 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750895Ab0IIJiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:38:15 -0400
Date: Thu, 9 Sep 2010 10:38:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Tony Lindgren <tony@atomide.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        "Lavinen Jarkko (Nokia-MS/Helsinki)" <jarkko.lavinen@nokia.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] MMC: move regulator handling closer to core v3
Message-ID: <20100909093810.GA1988@rakim.wolfsonmicro.main>
References: <1283677538-31121-1-git-send-email-linus.walleij@stericsson.com>
 <20100908155114.880463fc.akpm@linux-foundation.org>
 <4C887837.6060508@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C887837.6060508@nokia.com>
X-Cookie: Many suitcases look alike.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 09:01:27AM +0300, Adrian Hunter wrote:

> As an aside, I would like to enhance the regulator framework to
> enable boards to hook their code directly into the regulator.

What do you mean when you say that you would like boards to "hook
directly into the regulator" - what do you want to be able to do?
Is this the notifiers?  Do you need more of them?

> Arguably this is essential to allow pbias configuration (without
> which the board may be damaged) so that regulator_enable/disable
> can be used independently of the board, or for example to allow

I can't parse this at all I'm afraid.  Could you be more specific about
what you mean by using enable and disable independantly of the board -
clearly the consumer drivers are already able to be board independant?

> the regulator core to turn the regulator on/off at initialisation.

The regulator core already supports enabling or disabling regulators
from the machine constraints which I *think* is what you're looking for
but since I can't follow what you're saying above I'm not sure.
