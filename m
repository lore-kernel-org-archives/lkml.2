Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1L2B4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 20:56:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40793 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab1L2B4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 20:56:47 -0500
Date: Thu, 29 Dec 2011 01:56:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Denis Kuzmenko <linux@solonet.org.ua>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Joe Perches'" <joe@perches.com>
Subject: Re: [PATCH v4] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver
 use gpiolib. Fix error disabling pull during probe.
Message-ID: <20111229015640.GB4839@sirena.org.uk>
References: <4EE7E0E7.1020802@solonet.org.ua>
 <063a01ccbfac$498513c0$dc8f3b40$%kim@samsung.com>
 <4EFB851F.9080805@solonet.org.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFB851F.9080805@solonet.org.ua>
X-Cookie: Used with permission.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 11:07:43PM +0200, Denis Kuzmenko wrote:
> On 12/21/2011 08:46 AM, Kukjin Kim wrote:
> > Denis Kuzmenko wrote:

> >> Make s3c24xx LEDS driver use gpiolib. Fix error disabling pull during
> >> probe.

> >> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>

> > Acked-by: Kukjin Kim <kgene.kim@samsung.com>

> > Richard, I think, this should be handled in your tree.

> ping Richard

Take a look at the git logs - Richard hasn't been actively maintaining a
tree for the LEDs for some time now.
