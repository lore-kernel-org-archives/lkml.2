Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1ERWT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:19:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33147 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab1ERWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:19:57 -0400
Date: Wed, 18 May 2011 23:19:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Bibek BASU <bibek.basu@stericsson.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Juergen Beisert <jbe@pengutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Smartcard/SIM card subsystem, LDO regulator and signal
	modelling
Message-ID: <20110518221951.GD20909@sirena.org.uk>
References: <BANLkTikAzjmVoNK20RHRkhHkn3YgSra6dA@mail.gmail.com> <20110518162558.GA16414@opensource.wolfsonmicro.com> <BANLkTinc-KXfe3aLgX0DPuSj0_+7gBO0vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinc-KXfe3aLgX0DPuSj0_+7gBO0vg@mail.gmail.com>
X-Cookie: Forgive and forget.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 07:03:38PM +0200, Linus Walleij wrote:

> I am now starting to contemplate if I should rename the pinmux
> subsystem to "pinctrl" and not only handle muxing but also
> biasing in that system.

I've not yet had time to look at pinmux but I'd certainly expect that
sort of feature - many systems rely on the mode configuration to get the
functions working (eg, I2C might be a function but you also need to put
the pin into open drain mode for it to function correctly).
