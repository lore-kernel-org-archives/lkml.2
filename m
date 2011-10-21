Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1JUM5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:57:21 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37016 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1JUM5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:57:20 -0400
MIME-Version: 1.0
In-Reply-To: <20111021125544.GF4080@opensource.wolfsonmicro.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
	<20111020023140.GC32007@S2100-06.ap.freescale.net>
	<CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
	<CACRpkdYCgY9w8UgMKLgxSsu=Veo01-YSKBWndqU_uCTE-GjZuQ@mail.gmail.com>
	<20111020141827.GB6100@sirena.org.uk>
	<CACRpkdaaUmze+W1n4NkApTX0Se1VJAmD+AJSm36QbsKVDzdnRA@mail.gmail.com>
	<20111020154244.GA26083@opensource.wolfsonmicro.com>
	<CACRpkdbJbUefH+Q0GMp+_4FhV5RqQ+KHrGnJLR6jZSNR16NbSw@mail.gmail.com>
	<20111021123041.GE4080@opensource.wolfsonmicro.com>
	<CACRpkdaZQ12W2M9m=vvQ=w6vRppgsZdphm4ftmx6uFAX2HDkog@mail.gmail.com>
	<20111021125544.GF4080@opensource.wolfsonmicro.com>
Date: Fri, 21 Oct 2011 14:57:19 +0200
Message-ID: <CACRpkdbQYcMaK50EJ6n0UXGFfWWw_9YD_abTNDmqBxWxycC6NQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 2:55 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Oct 21, 2011 at 02:51:46PM +0200, Linus Walleij wrote:
>> On Fri, Oct 21, 2011 at 2:30 PM, Mark Brown
>
>> > To repeat once more: this is *not* an on/off control, this is a control
>> > selecting the voltage domain a pin is referenced to.
>
>> Sorry, slow learner. So I'll add:
>> PIN_CONFIG_ENABLE_POWER
>> PIN_CONFIG_DISABLE_POWER
>
>> With the semantics of enabling/disabling the power
>> supply for the pin logic. Correct now?
>
> No, like I keep saying it's nothing to do with enabling or disabling
> power.  It's about selecting between multiple reference domains.  For
> example, choosing between the DBVDD1 and DBVDD2 domains.

OK I think I get it now.

So PIN_CONFIG_POWER_SOURCE and then the argument to
that is definately custom...

Yours,
Linus Walleij
