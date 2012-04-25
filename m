Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab2DYKqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:46:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53069 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2DYKqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:46:06 -0400
Date: Wed, 25 Apr 2012 11:46:00 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng <B29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Tag on pinctrl
Message-ID: <20120425104559.GA16752@sirena.org.uk>
References: <CACRpkdYqZrNFxj4kyMqYZk5PAcjF6-TroJ+Xq+3EVBLvo5Zg-Q@mail.gmail.com>
 <4F96D84E.7080204@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F96D84E.7080204@wwwdotorg.org>
X-Cookie: No running on pool deck.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 10:43:58AM -0600, Stephen Warren wrote:

> Yes, I have pulled that tag into the Tegra tree as
> for-3.5/gpio-pinmux-dependency, and have a Tegra-specific
> for-3.5/gpio-pinmux branch that depends on it. Two other Tegra branches
> in turn (for-3.5/tegra30-audio, for-3.5/usb-ulpi) depend on
> for-3.5/gpio-pinmux.

> Linus, I think this will get into the ARM SoC tree simply by my saying
> in my for-3.5/gpio-pinmux pull request that the branch depends on your
> tag; I don't /think/ you need to explicitly send a pull request there,
> right?

If the gpio-pinmux branch is based on Linus' branch (which it really
should be if it's a dependency...) then git will do the right thing
here.  If it's not then you need to explicitly get things pulled in but
there will also be bisection issues.
