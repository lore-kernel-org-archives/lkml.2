Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1LFHdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:33:45 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:60125 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1LFHdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:33:44 -0500
Message-ID: <20189.50504.375779.311903@ipc1.ka-ro>
Date: Tue, 6 Dec 2011 08:33:28 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linus.walleij@stericsson.com,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Dong Aisheng <b29396@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
In-Reply-To: <20111206062500.GA3649@S2100-06.ap.freescale.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
	<1322999384-7886-2-git-send-email-b29396@freescale.com>
	<CACRpkdaYz+-nZA6atxA+5kvWOO84YeSHQPNiojq_R4zkHUGz3Q@mail.gmail.com>
	<20111205211838.GG27267@pengutronix.de>
	<20111206062500.GA3649@S2100-06.ap.freescale.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Shawn Guo writes:
> On Mon, Dec 05, 2011 at 10:18:38PM +0100, Sascha Hauer wrote:
> > Freescale has named the pins after their primary function which is quite
> > confusing.
> > 
> > The above means:
> > 
> > MX53_PATA_DATA8 -> mux mode 4
> > MX53_PATA_DATA9 -> mux mode 4
> > ...
> > 
> > This brings me to the point that currently we have the pins described as
> > 
> > #define MX53_PAD_<name>__<function>
> > 
> But that's also the reason why we have so many lengthy iomux-mx*.h on
> imx.  Taking iomux-mx53.h for example, it's a 109K header with 1219
> LOC, but probably only 10% of the definitions will actually be used.
> 
Which has the benefit of having correct pin definitions for everyone
to use. If developers who need to use currently unused pindefs have to
create them on their own, there will always be a good chance in
getting them wrong.

> > which means that you don't have to look into the datasheet to get the
> > different options for a pin
> 
> Looking at the datasheet when we write code is a pretty natural thing
> to me.
> 
The pindefs are like interrupt numbers or IO addresses for which there
also is a complete list of definitions in the kernel no matter whether
they are actually all in use.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
