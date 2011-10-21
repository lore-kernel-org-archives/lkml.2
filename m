Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1JUMap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:30:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56715 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab1JUMao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:30:44 -0400
Date: Fri, 21 Oct 2011 13:30:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
Message-ID: <20111021123041.GE4080@opensource.wolfsonmicro.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
 <20111020023140.GC32007@S2100-06.ap.freescale.net>
 <CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
 <CACRpkdYCgY9w8UgMKLgxSsu=Veo01-YSKBWndqU_uCTE-GjZuQ@mail.gmail.com>
 <20111020141827.GB6100@sirena.org.uk>
 <CACRpkdaaUmze+W1n4NkApTX0Se1VJAmD+AJSm36QbsKVDzdnRA@mail.gmail.com>
 <20111020154244.GA26083@opensource.wolfsonmicro.com>
 <CACRpkdbJbUefH+Q0GMp+_4FhV5RqQ+KHrGnJLR6jZSNR16NbSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbJbUefH+Q0GMp+_4FhV5RqQ+KHrGnJLR6jZSNR16NbSw@mail.gmail.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:28:25PM +0200, Linus Walleij wrote:
> On Thu, Oct 20, 2011 at 5:42 PM, Mark Brown
> > On Thu, Oct 20, 2011 at 04:43:30PM +0200, Linus Walleij wrote:

> >> In Ux500 we model our power domain switches as regulators,
> >> does such a property even belong in pin control? Is there
> >> one power domain switch per pin you mean, or a power switch
> >> for a whole group of pins?

> > This isn't an on/off control and in this cae it's per pin.

> If this is a binary output pin, I suspect that
> I suspect that what you call "off" is actually implemeted as
> in this figure:

To repeat once more: this is *not* an on/off control, this is a control
selecting the voltage domain a pin is referenced to.

> http://upload.wikimedia.org/wikipedia/commons/c/c0/Tristate_buffer.svg

No, this is completely orthogonal to voltage domain selection.
