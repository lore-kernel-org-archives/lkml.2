Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab2IJPjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:39:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51044 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab2IJPjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <1347266386-16229-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-2-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 10 Sep 2012 08:39:23 -0700
Message-ID: <CACRpkdah7h7YqenftcPgRtoS7RE3t47MnAkn9+ZAuF7P-vM4dg@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] pinctrl: mvebu: pinctrl driver core
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 1:39 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> This patch adds a pinctrl driver core for Marvell SoCs plus DT
> binding documentation. This core driver will be used by SoC family
> specific drivers, i.e. Armada XP, Armada 370, Dove, Kirkwood, aso.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
> v2:
> - restructured Kconfig to have a common PINCTRL_MVEBU that are selected by
>   SoC specific drivers.
> - cleaned pinctrl-mvebu and replaced 'magic numbers' by defines
> - make use of of_iomap instead of get_resource/ioremap
> - extended include documentation and checked with scripts/kernel-doc
> - cleaned devicetree binding documentation
>
> v3:
> - list of functions is now built out of pin groups passed to core driver
>   instead of parsing DT node.

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
