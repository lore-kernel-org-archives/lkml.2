Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074Ab2BNLD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:03:58 -0500
Received: from skyrme.org ([193.175.80.135]:34715 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759569Ab2BNLDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:03:42 -0500
Date: 14 Feb 2012 10:34:29 +0000
Message-Id: <1329215672-15706-5-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: sameo@linux.intel.com
Cc: dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, philippe.retornaz@epfl.ch,
        michael.thalmeier@hale.at, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH 4/7] input/touchscreen: rename mc13783_ts.c
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1329215672-15706-1-git-send-email-oskar@scara.com>
References: <1329215672-15706-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to add support for mc13892 touch device,
rename mc13783 touch driver to more generic mc13xxx name.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 drivers/input/touchscreen/Makefile                 |    2 +-
 .../touchscreen/{mc13783_ts.c => mc13xxx_ts.c}     |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/input/touchscreen/{mc13783_ts.c => mc13xxx_ts.c} (100%)

diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 496091e..07c031b 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_TOUCHSCREEN_INEXIO)	+= inexio.o
 obj-$(CONFIG_TOUCHSCREEN_INTEL_MID)	+= intel-mid-touch.o
 obj-$(CONFIG_TOUCHSCREEN_LPC32XX)	+= lpc32xx_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MAX11801)	+= max11801_ts.o
-obj-$(CONFIG_TOUCHSCREEN_MC13783)	+= mc13783_ts.o
+obj-$(CONFIG_TOUCHSCREEN_MC13783)	+= mc13xxx_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MCS5000)	+= mcs5000_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MIGOR)		+= migor_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+= mtouch.o
diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13xxx_ts.c
similarity index 100%
rename from drivers/input/touchscreen/mc13783_ts.c
rename to drivers/input/touchscreen/mc13xxx_ts.c
-- 
1.7.5.4

