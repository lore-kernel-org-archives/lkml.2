Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2CFTM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:12:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55317 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2CFTM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:12:28 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] pinctrl: Declare struct device
Date: Tue,  6 Mar 2012 12:12:12 -0700
Message-Id: <1331061132-25853-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@wwwdotorg.org>

Add a dummy declaration of struct device to avoid the following warning:

In file included from include/linux/pinctrl/machine.h:15:0,
                 from arch/arm/mach-tegra/board-pinmux.h:18,
                 from arch/arm/mach-tegra/board-trimslice-pinmux.c:20:
include/linux/pinctrl/pinctrl.h:115:12: warning: 'struct device' declared inside parameter list [enabled by default]
include/linux/pinctrl/pinctrl.h:115:12: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 include/linux/pinctrl/pinctrl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index bbdd7e1..de63e16 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -20,6 +20,7 @@
 
 #define PINCTRL_STATE_DEFAULT "default"
 
+struct device;
 struct pinctrl_dev;
 struct pinmux_ops;
 struct pinconf_ops;
-- 
1.7.0.4

