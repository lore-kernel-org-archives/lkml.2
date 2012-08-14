Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2HNO2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:28:07 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:39524 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901Ab2HNOWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:22:55 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/14] dt: Add empty of_find_node_by_name() function
Date: Tue, 14 Aug 2012 17:22:34 +0300
Message-Id: <1344954162-7985-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>
References: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds an empty of_find_node_by_name() function for !CONFIG_OF
builds.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/of.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 5919ee3..c90e59a 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -308,6 +308,12 @@ static inline const char* of_node_full_name(struct device_node *np)
 	return "<no-node>";
 }
 
+static inline device_node *of_find_node_by_name(struct device_node *from,
+	const char *name)
+{
+	return NULL;
+}
+
 static inline bool of_have_populated_dt(void)
 {
 	return false;
-- 
1.7.8.6

