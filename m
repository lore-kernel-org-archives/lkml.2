Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0H3WGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 18:06:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab0H3WGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 18:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <20100830214355.GB28865@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
	<20100829184904.GC26209@core.coreip.homeip.net>
	<36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
	<20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
	<20100830204412.GA28711@core.coreip.homeip.net>
	<AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
	<20100830214355.GB28865@core.coreip.homeip.net>
Date: Mon, 30 Aug 2010 15:05:32 -0700
Message-ID: <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Felipe Balbi <me@felipebalbi.com>,
        Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 30, 2010, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>
> That is why I started taking accelerometers in. But I am concerned that
> taking accelerometers (which indeed are most often input devices) will
> lead people to try and use the same for temperature, ALS and other
> sensors that are more often used in industrial process controls.

You're just being silly.

Nobody writes a driver for a "temperature sensor" or "ambient light
sensor". They write a driver for a specific *chip* that is used in
cellphones etc, and that happens to have an ambient light and
temperature sensor on it.

And in that context, it really does make sense to see it as an input
driver. And the fact that there are industrial uses for ALS sensors
that aren't necessarily at all interested on the input layer should
not matter at all.

So don't bring up "ALS isn't always input" because within the context
of a driver for some highly integrated cellphone model, it really IS
input, and there is no ambiguity at all.

So your "sometimes it is, and sometimes it isn't" argument is bogus.
The ambiguity simply doesn't exist when seen in context.

>> (or GPS device, for that matter) really be?
>
> But why GPS should be input device? It has nothing to do with user
> input.

What? OF COURSE it is an input driver. It's the user moving the device
around. It's EXACTLY the same thing as an accelerometer in that
respect. Sure, it's a bit less precise and measures movement wrt some
external frame, but technically they are almost exactly the same.

If you se doing a navigation app, the accelerometer, the compass and
the GPS are all equally (but differently) important.

Again - it's not a user touching buttons. But it IS a user moving around.

      Linus
