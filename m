Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3AIIQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:16:18 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:45729 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3AIIQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:16:17 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdaLFjDh_k7BdrzvxNJ5E3ho-BV9n9tHey2AMzQzyuL+Qg@mail.gmail.com>
References: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com>
	<20121212215404.GA18555@kroah.com>
	<CACRpkdaLFjDh_k7BdrzvxNJ5E3ho-BV9n9tHey2AMzQzyuL+Qg@mail.gmail.com>
Date: Wed, 9 Jan 2013 09:16:16 +0100
Message-ID: <CACRpkdYQdn107VAdO69r=o7UPSDy037xJOotOrfi4DuyXiDGcw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/pinctrl: grab default handles from device core
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

On Wed, Jan 2, 2013 at 2:42 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Dec 12, 2012 at 10:54 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Wed, Dec 12, 2012 at 09:25:07PM +0100, Linus Walleij wrote:
>>> From: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> This makes the device core auto-grab the pinctrl handle and set
>>> the "default" (PINCTRL_STATE_DEFAULT) state for every device
>>> that is present in the device model right before probe. This will
>>> account for the lion's share of embedded silicon devcies.
> (...)
>>
>> It looks ok, but this can't go in for 3.8, sorry, please wait for 3.9.
>
> Greg, now that v3.8-rc1 is out, can you give me an ACK on
> this patch so I can put it into linux-next for some rotation
> through the pinctrl tree?

Ping on Greg.

Yours,
Linus Walleij
