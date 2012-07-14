Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2GNVfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 17:35:06 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38050 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2GNVez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 17:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120712131231.GH2194@pengutronix.de>
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
	<20120712131231.GH2194@pengutronix.de>
Date: Sat, 14 Jul 2012 23:34:54 +0200
Message-ID: <CACRpkdboeF_G=sTPeSyuZ6KGLCmGSKx_NS=6Rim6HkR2f9=AAQ@mail.gmail.com>
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

On Thu, Jul 12, 2012 at 3:12 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:

> Arnd, since you committed the patches, can you please comment? I'd
> prefer to drop this DT conversion for now, otherwise we might have to
> support this possibly rushed bindings forever? LinusW, what do you
> think?

Well I think I ACKed that from the point of view that it will work as
expected with ux500 with these bindings. What is best from the I2C
subsystem point of view is another question ...

Overall I think we have this general problem with a lot of DT
conversion happening right now: the tempo is set very high and
all chip vendors want DT support RealQuickNowPreferrablyYesterday
and that makes it hard for subsystem maintainers to hold back,
and I also fear vendor-specific properties are overused for this
reason.

And about the perpetual nature of device tree bindings it
appears to me that the modus operandi right now is to not
regard any of these as written in stone until they are removed
from the kernel tree. We have plenty of drivers patching
trees and drivers in one for the moment.

Yours,
Linus Walleij
