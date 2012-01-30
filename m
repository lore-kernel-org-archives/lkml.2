Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2A3WCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:02:14 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45883 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775Ab2A3WAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:00:40 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Scott Murray <scott@spiteful.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] cpcihp: fix debug module parameter to be bool
Date: Mon, 30 Jan 2012 23:00:10 +0100
Message-Id: <1327960820-11867-7-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327960840;836e2fd0;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix debug variable from module parameter to be really bool to
fix 'warning: return from incompatible pointer type'.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/pci/hotplug/cpcihp_generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
index fb3f846..81af764 100644
--- a/drivers/pci/hotplug/cpcihp_generic.c
+++ b/drivers/pci/hotplug/cpcihp_generic.c
@@ -62,7 +62,7 @@
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
 
 /* local variables */
-static int debug;
+static bool debug;
 static char *bridge;
 static u8 bridge_busnr;
 static u8 bridge_slot;
-- 
1.7.7.3

