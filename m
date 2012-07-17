Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2GQNKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:10:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57303 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2GQNKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:10:41 -0400
Date: Tue, 17 Jul 2012 14:10:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120717131037.GC27595@sirena.org.uk>
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
 <20120712131231.GH2194@pengutronix.de>
 <CACRpkdboeF_G=sTPeSyuZ6KGLCmGSKx_NS=6Rim6HkR2f9=AAQ@mail.gmail.com>
 <20120716101706.GB17435@pengutronix.de>
 <CACRpkdY626iYATorphAvg7cQxD2ufysBvXdt3Z644zEuW0wS=w@mail.gmail.com>
 <20120716123550.GE17435@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716123550.GE17435@pengutronix.de>
X-Cookie: 1 + 1 = 3, for large values of 1.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 02:35:50PM +0200, Wolfram Sang wrote:

> I do know both sides. I easily agree that we have to find a balance
> somewhere to meet both interests. Though, currently my impressions from
> maintaining I2C are:

> a) it is not balanced, but too far on the "let's deploy stuff" side
> b) developers have a tendency to simply map platform_data to bindings
>    and are surprised when told this is often not possible

> which adds burden to the maintainers (who sometimes might not even be
> familiar with devicetree because they are not focused on embedded). And
> I worry about bindings of unmaintained subsystems.

A issue I'm seeing with some of the subsystems mantained by people who
don't work on ARM is that they've got the DT message so strongly that
they're pushing back on people trying to add platform data at all even
on off SoC things that need to work with non-ARM processors.
