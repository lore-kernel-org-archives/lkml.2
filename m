Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2ISIjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:39:41 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:40389 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab2ISIjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:39:37 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 0/2] Pinctrl-fy OMAP I2C driver (V2)
Date: Thu, 20 Sep 2012 09:34:47 +0300
Message-Id: <1348122889-28271-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <50596F8F.60506@ti.com>
References: <50596F8F.60506@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pinctrl-fy the OMAP I2C driver.

Due to the requirement of early usage of I2C for
regulators and such, earlier initialization of pinctrl
is required.

This patch series is against

git://gitorious.org/linus-tree/linus-tree.git for_3.7/i2c/big_cleanups

Note that the I2C DT bindings are against the linux-omap-dt tree
and that without https://patchwork.kernel.org/patch/1468531
queued for 3.7 scary messages will be printed on !DT platforms

Pantelis Antoniou (2):
  pinctrl: pinctrl-single must be initialized early.
  OMAP i2c: pinctrl-ify i2c-omap.c

 drivers/i2c/busses/i2c-omap.c    |  6 ++++++
 drivers/pinctrl/pinctrl-single.c | 12 +++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

-- 
1.7.12

