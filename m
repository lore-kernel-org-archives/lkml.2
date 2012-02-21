Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2BUNv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:51:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44287 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2BUNv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:51:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.179.8 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-12-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-12-git-send-email-swarren@nvidia.com>
Date: Tue, 21 Feb 2012 14:51:55 +0100
Message-ID: <CACRpkdbpBZqUUwxwF8o8P1P9yknY7SRSzGmYsa3kQ1JH=QNJ7A@mail.gmail.com>
Subject: Re: [PATCH 11/20] pinctrl: Downgrade pinctrl_get warning when no maps
 are found
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> This may be perfectly legitimate. An IP block may get re-used
> across SoCs. Not all of those SoCs may need pinmux settings for the
> IP block, e.g. if one SoC dedicates pins to that function but
> another doesn't. The driver won't know this, and will always
> attempt to set up the pinmux. The mapping table defines whether any
> HW programming is actually needed.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

This is equivalent to providing dummy pincontrollers as was on my
TODO for a while admittedly.

For consistency with regulators it would maybe be better to have
optional dummy pin controllers but after thinking a bit about it
I think this is more helpful, so I applied it anyway.

However I would invite more opinions...

Yours,
Linus Walleij
