Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2LLT4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:56:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33844 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLT4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:56:43 -0500
MIME-Version: 1.0
In-Reply-To: <20121211181336.GD25714@kroah.com>
References: <1355233246-16694-1-git-send-email-linus.walleij@stericsson.com>
	<20121211181336.GD25714@kroah.com>
Date: Wed, 12 Dec 2012 20:56:41 +0100
Message-ID: <CACRpkdbCuTAwqFVWkb7bx7_OAX_0PU8TjjbS879Ui30bdxXkQg@mail.gmail.com>
Subject: Re: [PATCH] drivers/pinctrl: grab default handles from device core
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 7:13 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Dec 11, 2012 at 02:40:46PM +0100, Linus Walleij wrote:
>> diff --git a/include/linux/device.h b/include/linux/device.h

>> +#ifdef CONFIG_PINCTRL
>> +     struct dev_pin_info     pins;
>> +#endif
>
> Can't you just make this a * to the structure, saving a bit of space for
> those that don't use this structure?  Ok, it's only saving one pointer,
> so it's really not a big deal to me if you don't want to do this, just
> asking...

OK I'll look into it.

> Also, this will have to wait until after 3.8-rc1 before I can consider
> merging it, I'm a bit busy for the next two weeks at the least...

Sure. I'm mainly seeking an ACK so I can take it through the pinctrl
subsystem in any case, as I will probably stick a few dependencies
in there. And it'll certainly be for v3.9.

Yours,
Linus Walleij
