Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab2FMIMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:12:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34163 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2FMIMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:12:05 -0400
MIME-Version: 1.0
In-Reply-To: <4FD83AAD.2010701@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-10-git-send-email-lee.jones@linaro.org>
	<CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
	<4FD6F0E8.5040606@linaro.org>
	<CACRpkdYxiT-0x4aetMxB2x8SkB+Mmy8rk8uSzgU_anemSayhMw@mail.gmail.com>
	<4FD83AAD.2010701@linaro.org>
Date: Wed, 13 Jun 2012 10:12:03 +0200
Message-ID: <CACRpkdZC8E6izDpdnWy6DMjOdA6KsqTaPoaq9pErWoNW0Ewytw@mail.gmail.com>
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 9:01 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Board specific is fine, as the data is protected by a board specific
> property. Do you mean that the properties are *bus specific*? In which case
> I see your point and will apply the correct bindings.

I cannot parse this, the board for me is a SoC, busses and a
number of components connected via e.g. I2C.

Can you define what you mean with a "board specific property"?
It seems you are talking about what I would call an
"SoC-specific property", i.e. something out of a .dtsi file for
a certain SoC, whereas the .dts for an entire board is,
well, for a board, a set of components on a PCB.

The arrangement of accelerometers and battery monitors on a
certain board is board-specific, and it is also by definition
bus-specific.

Yours,
Linus Walleij
