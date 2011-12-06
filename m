Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab1LFIFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 03:05:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40141 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964Ab1LFIFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 03:05:50 -0500
Date: Tue, 6 Dec 2011 09:05:44 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linus.walleij@stericsson.com,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Dong Aisheng <b29396@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
Message-ID: <20111206080544.GF4585@pengutronix.de>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <1322999384-7886-2-git-send-email-b29396@freescale.com>
 <CACRpkdaYz+-nZA6atxA+5kvWOO84YeSHQPNiojq_R4zkHUGz3Q@mail.gmail.com>
 <20111205211838.GG27267@pengutronix.de>
 <20111206062500.GA3649@S2100-06.ap.freescale.net>
 <20189.50504.375779.311903@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20189.50504.375779.311903@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 06, 2011 at 08:33:28AM +0100, Lothar Waßmann wrote:
> Shawn Guo writes:
> > On Mon, Dec 05, 2011 at 10:18:38PM +0100, Sascha Hauer wrote:
> > > Freescale has named the pins after their primary function which is quite
> > > confusing.
> > > 
> > > The above means:
> > > 
> > > MX53_PATA_DATA8 -> mux mode 4
> > > MX53_PATA_DATA9 -> mux mode 4
> > > ...
> > > 
> > > This brings me to the point that currently we have the pins described as
> > > 
> > > #define MX53_PAD_<name>__<function>
> > > 
> > But that's also the reason why we have so many lengthy iomux-mx*.h on
> > imx.  Taking iomux-mx53.h for example, it's a 109K header with 1219
> > LOC, but probably only 10% of the definitions will actually be used.
> > 
> Which has the benefit of having correct pin definitions for everyone
> to use. If developers who need to use currently unused pindefs have to
> create them on their own, there will always be a good chance in
> getting them wrong.
Another upside is, that adding the complete list once doesn't result in
conflicts if two people add new definitions in the same timeframe. As
the header are only cpp symbols that don't hurt at runtime I think
having them complete is better than the incremental approach.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
