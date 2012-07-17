Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2GQNHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:07:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52005 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2GQNHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:07:02 -0400
Date: Tue, 17 Jul 2012 14:06:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120717130650.GB27595@sirena.org.uk>
References: <5003FB7C.4030509@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5003FB7C.4030509@linaro.org>
X-Cookie: 1 + 1 = 3, for large values of 1.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 12:31:08PM +0100, Lee Jones wrote:

> I agree with what you say to some extent, but I believe that it is
> more important to have a working solution now than to ensure that
> each bindings are as unique as possible. After any suggestion of
> consolidation, a move from vendor specific to generically defined
> Device Tree bindings is trivial. Especially in the current stage
> where adaptions and definitions are still fluid.

> Obviously some care is taken to ensure the bindings are as generic
> as possible, but not to the extent that will put the project back
> some months. Over past few months I have enabled many sub-systems;

It's not just about having generic bindings, it's also about having
bindings which have some abstraction and hope of reusability. An awful
lot of bindings are just straight dumps of Linux data structures into
the device tree which don't make a terribly great deal of sense as
bindings.

> however, I think it would have been a fraction of that if we'd gone
> through the laborious process of immediate forced consolidation. I
> think it's fine to have platform/vendor specific bindings that work,
> then come back to unify them once the dust settles.

In many of these cases we'd be better off just not putting things into
the device tree in the first place, leaving things at the basic "is the
device there" stuff.
