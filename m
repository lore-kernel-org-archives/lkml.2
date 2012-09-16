Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2IPHr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 03:47:29 -0400
Received: from londo.lunn.ch ([80.238.139.98]:36497 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab2IPHr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 03:47:27 -0400
Date: Sun, 16 Sep 2012 09:46:52 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
Message-ID: <20120916074652.GM28177@lunn.ch>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-4-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347550912-18021-4-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ b/Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt
> @@ -0,0 +1,279 @@
> +* Marvell Kirkwood SoC pinctrl driver for mpp
> +
> +Please refer to marvell,mvebu-pinctrl.txt in this directory for common binding
> +part and usage.
> +
> +Required properties:
> +- compatible: "marvell,88f6180-pinctrl",
> +              "marvell,88f6190-pinctrl", "marvell,88f6192-pinctrl",
> +              "marvell,88f6281-pinctrl", "marvell,88f6282-pinctrl"
> +
> +This driver supports all kirkwood variants, i.e. 88f6180, 88f619x, and 88f628

Hi Sebastian 

The current MPP code determines for itself what chip it is running on.
It can then check if a pin configuration is valid for the current
run time environment.

Here you are suggesting we have to put into the DT what chip we expect
to be on.

What is the advantage of this, over getting the information from the
device itself?

If i wanted to mass convert all existing kirkwood DT boards over to
use pinctrl, im stuck at the very first step. I've no idea what chip
they use, it was not relevant before.

Thanks
	Andrew
