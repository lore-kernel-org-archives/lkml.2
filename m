Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2DGHLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 03:11:33 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52964 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2DGHKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 03:10:42 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: gpiolib: per-gpio edges count
To: Jean Pihet <jean.pihet@newoldbits.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>
In-Reply-To: <CAORVsuUQbtC=SF9RP2g04mN-ksE8BU40ACfZvoyGUju=LRbwqg@mail.gmail.com>
References: <CAORVsuWw1rwcsMUrSqZJCeSY_vjJDwakF27kfb6=utN8nBqvag@mail.gmail.com> <CAORVsuUQbtC=SF9RP2g04mN-ksE8BU40ACfZvoyGUju=LRbwqg@mail.gmail.com>
Date: Fri, 06 Apr 2012 20:13:06 -0700
Message-Id: <20120407031306.B24D03E1F86@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012 16:49:03 +0200, Jean Pihet <jean.pihet@newoldbits.com> wrote:
> Hi,
> 
> On Wed, Apr 4, 2012 at 10:53 AM, Jean Pihet <jean.pihet@newoldbits.com> wrote:
> > Hi Grant, Linus,
> >
> > I would like to know if it is possible to get the edges count on a GPIO pin.
> > I was hoping to get it by configuring the pin as input with an edge
> > trigger but on OMAP there is only one irq line per controller (which
> > controls 32 pins).
> > Btw I am using a Beaglebone with OMAP AM3358.
> 
> I figured it out, with the help from Kevin on IRC (thx!).
> 
> Indeed there is a per-pin IRQ count available in /proc/interrupts.
> Sorry for the unconvenience.
> 
> Thanks & regards,
> Jean

Great, I'm glad you got it sorted out.  For the benefit of anyone
coming across this thread, would you mind replying with a summary of
how you solved the problem?

Thanks,
g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
