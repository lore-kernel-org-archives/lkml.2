Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2FNSrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:47:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57699 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab2FNSrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:47:04 -0400
Date: Thu, 14 Jun 2012 19:46:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linus.walleij@stericsson.com, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C
 driver
Message-ID: <20120614184656.GD30185@sirena.org.uk>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-10-git-send-email-lee.jones@linaro.org>
 <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
 <4FD6F0E8.5040606@linaro.org>
 <CACRpkdYxiT-0x4aetMxB2x8SkB+Mmy8rk8uSzgU_anemSayhMw@mail.gmail.com>
 <4FD83AAD.2010701@linaro.org>
 <CACRpkdZC8E6izDpdnWy6DMjOdA6KsqTaPoaq9pErWoNW0Ewytw@mail.gmail.com>
 <4FD88761.9050703@linaro.org>
 <20120614183636.GB30185@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614183636.GB30185@sirena.org.uk>
X-Cookie: Do not try this at home.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 07:36:36PM +0100, Mark Brown wrote:

> You're not understanding Linus' point.  The compatible string isn't
> useful here because properties like the maximum clock rate of the bus
> depend on the board design, not the silicon.  The controller may be
> perfectly happy to run at a given rate but other devices on the bus or
> the electrical engineering of the PCB itself may restrict this further.

Sorry, I read the next revision and see this was actually resolved OK.
