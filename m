Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2GPTpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:45:31 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60590 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2GPTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120716123550.GE17435@pengutronix.de>
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
	<20120712131231.GH2194@pengutronix.de>
	<CACRpkdboeF_G=sTPeSyuZ6KGLCmGSKx_NS=6Rim6HkR2f9=AAQ@mail.gmail.com>
	<20120716101706.GB17435@pengutronix.de>
	<CACRpkdY626iYATorphAvg7cQxD2ufysBvXdt3Z644zEuW0wS=w@mail.gmail.com>
	<20120716123550.GE17435@pengutronix.de>
Date: Mon, 16 Jul 2012 21:45:29 +0200
Message-ID: <CACRpkdaMB-n7XYcxE8QtAm-WrGc2DR0krfTjQZCbvOL1HYep1Q@mail.gmail.com>
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

On Mon, Jul 16, 2012 at 2:35 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:

> Uhm, I seem to have missed that bindings are deemed more "flexible" as
> long as they are coupled to in-kernel dts files? Is that discussed
> somewhere? I do wonder about it...

Well patches like this are sent out but not commented on from
the perspective of binding stability. So of course, they get merged.

Have a look at this commit:

commit 7f217794ffa72f208a250b79ab0b7ea3de19677f
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sun May 13 00:14:24 2012 -0400

    mmc: dt: Consolidate DT bindings

This is deleting custom properties from DTS files without
adding any code to fallback-support them on old device trees.

(Actually I like this commit a lot, since it is removing custom MMC
props and replacing these with standard bindings common for all
MMC/SD controllers, but ...)

I think there are more examples if you git log on arch/arm/boot/dts...

Yours,
Linus Walleij
