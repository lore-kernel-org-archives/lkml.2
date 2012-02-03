Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2BCUzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:55:08 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59698 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2BCUzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:55:06 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19otigFjrE0KOn1xoHldSMw
Subject: [PATCH 0/2] Initial DT only generic pinctrl-simple driver
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Dong Aisheng <dongas86@gmail.com>
Date: Fri, 03 Feb 2012 12:54:58 -0800
Message-ID: <20120203205049.4089.74610.stgit@kaulin.local>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's finally something that mostly works for omap2/3/4, this
is now using a minimal subset of the mux bindings posted earlier
by Stephen Warren.

No support for alternative modes at this point, bunch of features
missing.. And the map allocation is copying things unnecessarily
right now. But basically this is what I promised to post few
weeks ago as pinmux-simple.

Hmm, how should we mark the pinmux hogs in .dts?

Regards,

Tony

---

Tony Lindgren (2):
      pinmux: Export pinmux_register_mappings for pinmux modules
      pinctrl: Add simple pinmux driver using device tree data


 .../devicetree/bindings/pinmux/pinctrl-simple.txt  |   62 +
 drivers/pinctrl/Kconfig                            |    6 
 drivers/pinctrl/Makefile                           |    1 
 drivers/pinctrl/pinctrl-simple.c                   | 1286 ++++++++++++++++++++
 drivers/pinctrl/pinmux.c                           |    3 
 5 files changed, 1357 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinmux/pinctrl-simple.txt
 create mode 100644 drivers/pinctrl/pinctrl-simple.c

-- 
Signature
