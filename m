Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab1ESUC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:02:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59327 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934063Ab1ESUC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:02:56 -0400
MIME-Version: 1.0
In-Reply-To: <20110518221951.GD20909@sirena.org.uk>
References: <BANLkTikAzjmVoNK20RHRkhHkn3YgSra6dA@mail.gmail.com>
	<20110518162558.GA16414@opensource.wolfsonmicro.com>
	<BANLkTinc-KXfe3aLgX0DPuSj0_+7gBO0vg@mail.gmail.com>
	<20110518221951.GD20909@sirena.org.uk>
Date: Thu, 19 May 2011 22:02:54 +0200
Message-ID: <BANLkTikwH0pDLadZ6w5FGd5Q0e6Nskvp5w@mail.gmail.com>
Subject: Re: Smartcard/SIM card subsystem, LDO regulator and signal modelling
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Bibek BASU <bibek.basu@stericsson.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Juergen Beisert <jbe@pengutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 12:19 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, May 18, 2011 at 07:03:38PM +0200, Linus Walleij wrote:
>
>> I am now starting to contemplate if I should rename the pinmux
>> subsystem to "pinctrl" and not only handle muxing but also
>> biasing in that system.
>
> I've not yet had time to look at pinmux but I'd certainly expect that
> sort of feature - many systems rely on the mode configuration to get the
> functions working (eg, I2C might be a function but you also need to put
> the pin into open drain mode for it to function correctly).

I've renamed the subsystem folder "pinctrl" in next iteration, with
pinmux implemented. We will then expand it to handle other
control such as biasing, driver strength etc, as we go along.

Linus Walleij
