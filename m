Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0CVUrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:47:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48829 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab0CVUrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:47:46 -0400
Date: Mon, 22 Mar 2010 21:47:06 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Nate Case <ncase@xes-inc.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Daniel Silverstone <dsilvers@simtec.co.uk>,
       Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>,
       Kevin Wells <kevin.wells@nxp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] gpiolib: make names array and its values const
Message-ID: <20100322204706.GA10157@pengutronix.de>
References: <20100203155558.GH11354@pengutronix.de> <1265620180-14150-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1265620180-14150-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Feb 08, 2010 at 10:09:38AM +0100, Uwe Kleine-König wrote:
> gpiolib doesn't need to modify the names and I assume most initializers
> use sting constants that shouldn't be modified anyhow.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Kevin Wells <kevin.wells@nxp.com>
> ---
>  drivers/gpio/gpiolib.c      |    2 +-
>  drivers/gpio/pca953x.c      |    2 +-
>  include/asm-generic/gpio.h  |    2 +-
>  include/linux/i2c/pca953x.h |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

I haven't received feed back for these patches.  Would you care to take
them?  If yes, should I resend?  Alternatively you can get them from 

	git://git.pengutronix.de/git/ukl/linux-2.6.git gpiolib/names

whatever is easiest for you ...

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
