Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab2IJKqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:46:33 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:60046 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150Ab2IJKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:29 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/14] dt: Add empty of_find_node_by_name() function
Date: Mon, 10 Sep 2012 13:46:24 +0300
Message-Id: <1347273992-9107-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds an empty of_find_node_by_name() function for !CONFIG_OF
builds.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/of.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 1b11632..5c7a158 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -315,6 +315,12 @@ static inline const char* of_node_full_name(struct device_node *np)
 	return "<no-node>";
 }
 
+static inline struct device_node *of_find_node_by_name(struct device_node *from,
+	const char *name)
+{
+	return NULL;
+}
+
 static inline bool of_have_populated_dt(void)
 {
 	return false;
-- 
1.7.12

