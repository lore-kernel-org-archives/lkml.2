Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908Ab1LLFAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:00:37 -0500
Received: from the.earth.li ([46.43.34.31]:52984 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab1LLFAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:00:36 -0500
Date: Sun, 11 Dec 2011 21:00:22 -0800
From: Jonathan McDowell <noodles@earth.li>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/10] ARM: OMAP1: ams-delta: replace custom I/O with
 GPIO
Message-ID: <20111212050022.GI16333@earth.li>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 09:11:58PM +0100, Janusz Krzysztofik wrote:
> The Amstrad Delta board has two extra output ports used for driving
> input lines of different on-board devices. Those ports are now
> controlled with custom functions, provided by the board arch code and
> used by several device drivers.
> 
> The idea behind the series is to replace those custom I/O functions
> with gpiolib API. This way, existing drivers can be made less platform
> dependent, and some of them perhaps even superseded with generic GPIO
> based drivers after the board platform device descriptions are
> converted. Moreover, should a new driver for the on-board Smart Card
> controller ever be created, it could be designed as a generic GPIO
> based driver, not a custom one.

Nice work; moving ams-delta over to gpiolib has been on my todo list for
a while (albeit quite low down).

J.

-- 
I just Fedexed my soul to hell. I'm *real* clever.
