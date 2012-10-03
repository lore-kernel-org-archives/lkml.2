Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2JCXIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:08:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45667 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab2JCXIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:08:00 -0400
MIME-Version: 1.0
In-Reply-To: <50682402.8020402@antcom.de>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
	<CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com>
	<50682402.8020402@antcom.de>
Date: Thu, 4 Oct 2012 01:07:59 +0200
Message-ID: <CACRpkdYGePft_XvhhoNyRfBm484FD46WGagivQzjh5-OE3VJUA@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: Stijn Devriendt <highguy@gmail.com>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        bgat@billgatliff.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 12:50 PM, Roland Stigge <stigge@antcom.de> wrote:

> Besides what I discussed with JC and Linus, I find the unsigned int
> (i.e. u32 or u64, depending on the arch) quite appealing. It is a nice
> compromise between my general bit mapped data model (variable size *u8
> array) and the bool *values list. Even maps easily onto a single sysfs
> entry for values, by abstracting a gpio list to an actual data word.
>
> What do others think? JC? Linus? I'm considering this (unsigned int
> data) a valid option.

I think we mostly use an unsigned long for such stuff as IRQ flags
and ioctl() parameters in the kernel.

In this case it has the upside that it will be 32bit on 32bit systems
and 64bit on 64bit systems if I'm not mistaken.

Yours,
Linus Walleij
