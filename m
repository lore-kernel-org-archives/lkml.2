Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2CGJzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:55:05 -0500
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:51953 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751092Ab2CGJzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:55:02 -0500
Date: Wed, 7 Mar 2012 08:46:24 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Jamie Iles <jamie@jamieiles.com>, Kevin Hilman <khilman@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Barry Song <baohua.song@csr.com>, Eric Miao <eric.y.miao@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jiandong Zheng <jdzheng@broadcom.com>,
        Colin Cross <ccross@android.com>, Shawn Guo <shawn.guo@linaro.org>,
        Roland Stigge <stigge@antcom.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: Pre-merge-window status of the arm-soc tree
Message-ID: <20120307074624.GH21255@game.jcrosoft.org>
References: <201203062054.55434.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203062054.55434.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1497446878061701892
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.510687/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Notably absent here are still mach-msm and mach-shmobile and some
> platforms have more patches pending. If you have anything that you
> want to get included in 3.4, then now would be a good time to send
> that. Anything that is not in arm-soc by the time the merge window
> opens is not going to make it into the release, and you should allow
> a little bit of time to sort out any conflicts between sending pull
> requests and having them in the branch.
I've much more to send to pull for AT91 DT but all depends on 2 patches
acked by not pulled so far for of

Grant can I apply it via AT91 (of boolean support and nand generic binding)
as I need them for
NAND
USB device
I2C
Shutdown Controller support
RAM Controller
Reset Controller
USB Host

Best Regards,
J.
