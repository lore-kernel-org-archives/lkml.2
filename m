Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab1LGPse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:48:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57697 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516Ab1LGPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:48:33 -0500
Date: Wed, 7 Dec 2011 23:47:47 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-ID: <20111207154746.GA22355@opensource.wolfsonmicro.com>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
 <20111203214924.GA21511@sirena.org.uk>
 <CACRpkdZBX6ct7GNz_5AEfqgnhS75OW9n+CFTzOXMYF8hV1fwOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZBX6ct7GNz_5AEfqgnhS75OW9n+CFTzOXMYF8hV1fwOw@mail.gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 03:16:06PM +0100, Linus Walleij wrote:

> Then in the sysfs interface:

> +       if (led_curr > led->max_current)
> +               led_curr = led->max_current;

> You are only allowed to set a lower value than the max value.

Oh, that's surprising - my expectation had been that the standard
brightness setting would be managing the current limit and the user
wouldn't need to control it separately.
