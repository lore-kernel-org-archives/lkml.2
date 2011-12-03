Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1LCVtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 16:49:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45410 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1LCVtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 16:49:33 -0500
Date: Sat, 3 Dec 2011 21:49:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-ID: <20111203214924.GA21511@sirena.org.uk>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Available while quantities last.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 02:56:22PM +0100, Linus Walleij wrote:

> +What:		/sys/class/leds/<led>/led_current
> +Date:		December 2011
> +KernelVersion:	3.3
> +Contact:	Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
> +Description:
> +		Read and set the current limit for the LED. Value in
> +		milliampere.

This sounds like a platform data thing - normally if you get a current
limit wrong you're heading for magic smoke so it's not something you
want to be playing with at runtime from userspace.
