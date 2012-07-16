Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2GPLhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:37:21 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49610 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab2GPLhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120716101706.GB17435@pengutronix.de>
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
	<20120712131231.GH2194@pengutronix.de>
	<CACRpkdboeF_G=sTPeSyuZ6KGLCmGSKx_NS=6Rim6HkR2f9=AAQ@mail.gmail.com>
	<20120716101706.GB17435@pengutronix.de>
Date: Mon, 16 Jul 2012 13:37:13 +0200
Message-ID: <CACRpkdY626iYATorphAvg7cQxD2ufysBvXdt3Z644zEuW0wS=w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 12:17 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:

>> And about the perpetual nature of device tree bindings it
>> appears to me that the modus operandi right now is to not
>> regard any of these as written in stone until they are removed
>> from the kernel tree. We have plenty of drivers patching
>> trees and drivers in one for the moment.
>
> I don't get this one. Yes, they are of perpetual nature, so how could we
> remove them from the kernel tree?

What I meant was that at the point when arch/arm/boot/dts/*
is (if ever) removed from the kernel tree and into its own git, so that
the standardization of bindings is decoupled from the Linux kernel
tree, from that point it is no longer possible to alter the bindings
and the code in sync, so at that point the bindings need to be
frozen and all subsequent work will need to gear down and
work on bindings before deployment.

That said, this does not at all solve the problem of already-deployed
device trees using old bindings...

> What I am afraid of is: tentative solutions tend to stay, because the
> need for a proper solution is reduced. Yet, finding proper generic
> bindings might take some time which doesn't meet the high pressure
> around DT at the moment.

I'm +1 on this. But I have learned that I have had to strike a
compromise with people who want to forge ahead. They see things
in the other way: perpetual committee discussions and no code
nor device trees being deployed... :-)

Yours,
Linus Walleij
