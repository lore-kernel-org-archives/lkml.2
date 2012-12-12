Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2LLT64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:58:56 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55994 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:58:55 -0500
MIME-Version: 1.0
In-Reply-To: <20121212115828.GJ4398@game.jcrosoft.org>
References: <1355233246-16694-1-git-send-email-linus.walleij@stericsson.com>
	<20121211181336.GD25714@kroah.com>
	<20121212115828.GJ4398@game.jcrosoft.org>
Date: Wed, 12 Dec 2012 20:58:54 +0100
Message-ID: <CACRpkdbWx+EOvwuO4j19gAbVwUKY+xHQSeoAwB4b-NOMiH4twQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/pinctrl: grab default handles from device core
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 12:58 PM, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:

>> > +#ifdef CONFIG_PINCTRL
>> > +   struct dev_pin_info     pins;
>> > +#endif

> can do do not put ifdef in the struct as if will force us to put ifdef in the
> c code too instead of just use a inline function

Oh, I'm just planning to use this from the pinctrl core code itself
and the code in drivers/base/pinctrl.c (which is only compiled when
CONFIG_PINCTRL is set) so there is no risk for that right now.

I would agree if we exposed to drivers, like the dev_pm_ops...
but that's not the plan right now.

Yours,
Linus Walleij
