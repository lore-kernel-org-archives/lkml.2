Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2KEN2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:28:48 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49546 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab2KEN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:28:46 -0500
MIME-Version: 1.0
In-Reply-To: <4684026.MA6h34pt1X@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
	<6279158.LZAthHxtvS@vostro.rjw.lan>
	<CACRpkdb6-YsyiSYoJb+Jea_9NPGe+8Nqy1hkCk=Mjki26S3-Zw@mail.gmail.com>
	<4684026.MA6h34pt1X@vostro.rjw.lan>
Date: Mon, 5 Nov 2012 14:28:45 +0100
Message-ID: <CACRpkdbRWPYHBwLVTm-TDRVyp9Kmoaxw0uZg0schn7i0koDKJw@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 2:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, November 05, 2012 02:11:03 PM Linus Walleij wrote:
>> Do you think they will change their mind and give me green light if
>> I tell them I just need to do it right now? ;-)
>
> Well, it's just a matter of fairness to me, actually.
>
> If you allowed somebody to do something in the past, it's simply unfair
> to forbid someone else to do a similar thing later, isn't it?

So if some subsystem has previously merged clk_get() for
the silicon clock pertaining to a driver the maintainer should
be fair to the pinctrl people and merge pinctrl_get() as well.
Well, they don't. But it wasn't any of your subsystems so
I don't blame you.

I have been stand-in-maintaining the GPIO subsystem
for the last two merge windows and I am worrying about the
long term viability of the subsystem if we keep doing this
without facing the real problem of the global GPIO
numberspace.

But since Grant merged the gpiolib-of.c thing and is still the
main maintainer I can atleast chicken out by referring to him
this time ... hit me back if he doesn't respond and I will
have to refactor the world or something.

Yours,
Linus Walleij
