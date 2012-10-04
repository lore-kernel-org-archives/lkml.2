Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab2JDU0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:26:04 -0400
Received: from antcom.de ([188.40.178.216]:56598 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab2JDU0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:26:02 -0400
Message-ID: <506DF0CC.9000202@antcom.de>
Date: Thu, 04 Oct 2012 22:25:48 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stijn Devriendt <highguy@gmail.com>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        bgat@billgatliff.com, Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com> <50682402.8020402@antcom.de> <CACRpkdYGePft_XvhhoNyRfBm484FD46WGagivQzjh5-OE3VJUA@mail.gmail.com>
In-Reply-To: <CACRpkdYGePft_XvhhoNyRfBm484FD46WGagivQzjh5-OE3VJUA@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/10/12 01:07, Linus Walleij wrote:
>> What do others think? JC? Linus? I'm considering this (unsigned int
>> data) a valid option.
> 
> I think we mostly use an unsigned long for such stuff as IRQ flags
> and ioctl() parameters in the kernel.
> 
> In this case it has the upside that it will be 32bit on 32bit systems
> and 64bit on 64bit systems if I'm not mistaken.

Fine. Will try to prepare a patch tomorrow, including fallback to single
GPIO handling (if the driver doesn't implement block operations) and
omitting the sysfs interface in the first patch.

Roland
