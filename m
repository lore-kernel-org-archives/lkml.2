Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2KUChT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:37:19 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab2KUC0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:54 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 08/42] sh-pfc: Sort headers alphabetically
Date: Wed, 21 Nov 2012 03:27:09 +0100
Message-Id: <1353464863-10281-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/sh/pfc/core.c    |   10 +++++-----
 drivers/sh/pfc/gpio.c    |    6 +++---
 drivers/sh/pfc/pinctrl.c |    6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/sh/pfc/core.c b/drivers/sh/pfc/core.c
index 3593de5..f1a0c85 100644
--- a/drivers/sh/pfc/core.c
+++ b/drivers/sh/pfc/core.c
@@ -12,15 +12,15 @@
 #define DRV_NAME "sh-pfc"
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/bitops.h>
+#include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
 #include <linux/kernel.h>
-#include <linux/sh_pfc.h>
 #include <linux/module.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/bitops.h>
+#include <linux/sh_pfc.h>
 #include <linux/slab.h>
-#include <linux/ioport.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/platform_device.h>
 
diff --git a/drivers/sh/pfc/gpio.c b/drivers/sh/pfc/gpio.c
index 0a85159..9f4f0fd 100644
--- a/drivers/sh/pfc/gpio.c
+++ b/drivers/sh/pfc/gpio.c
@@ -11,13 +11,13 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME " gpio: " fmt
 
-#include <linux/init.h>
 #include <linux/gpio.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
+#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/sh_pfc.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
 
 #include "core.h"
 
diff --git a/drivers/sh/pfc/pinctrl.c b/drivers/sh/pfc/pinctrl.c
index 21b8678..c0c8271 100644
--- a/drivers/sh/pfc/pinctrl.c
+++ b/drivers/sh/pfc/pinctrl.c
@@ -11,17 +11,17 @@
 #define DRV_NAME "sh-pfc"
 #define pr_fmt(fmt) KBUILD_MODNAME " pinctrl: " fmt
 
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/sh_pfc.h>
-#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/pinctrl/consumer.h>
-#include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinconf.h>
-#include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf-generic.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
 
 #include "core.h"
 
-- 
1.7.8.6

