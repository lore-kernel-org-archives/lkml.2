Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1L2OA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 09:00:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36420 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1L2OA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 09:00:56 -0500
Date: Thu, 29 Dec 2011 14:00:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 0/4] Random GPIO updates
Message-ID: <20111229140053.GA25479@sirena.org.uk>
References: <20111207162256.GI22355@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207162256.GI22355@opensource.wolfsonmicro.com>
X-Cookie: For internal use only.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 12:22:57AM +0800, Mark Brown wrote:

> This is a fairly random selection of updates I've been sitting on for
> the gpios, partly built up over your sabbatical but a couple predating
> that.  No real theme here except for time.

Adding Linus to the CCs for this since he became GPIO comaintainer
(sorry, should've done this when reposting the patches).

> The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

>   Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git gpio/misc

> Mark Brown (4):
>       gpio: Explicitly index samsung_gpio_cfgs
>       gpio: Fix typo in comment in Samsung driver
>       gpio: Convert GPIO drivers to module_platform_driver
>       gpio: Add decode of WM8994 GPIO configuration

>  drivers/gpio/gpio-adp5520.c    |   12 +------
>  drivers/gpio/gpio-cs5535.c     |   13 +------
>  drivers/gpio/gpio-da9052.c     |   12 +------
>  drivers/gpio/gpio-generic.c    |   12 +------
>  drivers/gpio/gpio-janz-ttl.c   |   13 +------
>  drivers/gpio/gpio-rdc321x.c    |   13 +------
>  drivers/gpio/gpio-samsung.c    |   31 ++++++++++------
>  drivers/gpio/gpio-sch.c        |   13 +------
>  drivers/gpio/gpio-timberdale.c |   13 +------
>  drivers/gpio/gpio-ucb1400.c    |   13 +------
>  drivers/gpio/gpio-vr41xx.c     |   13 +------
>  drivers/gpio/gpio-vx855.c      |   12 +------
>  drivers/gpio/gpio-wm8994.c     |   79 +++++++++++++++++++++++++++++++++++++++-
>  13 files changed, 108 insertions(+), 141 deletions(-)
