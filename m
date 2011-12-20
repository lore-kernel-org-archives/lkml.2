Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1LTR64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:58:56 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:53510
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514Ab1LTR6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:58:50 -0500
X-SpamScore: 4
X-BigFish: VS4(zzzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <shawn.guo@freescale.com>
Subject: [PATCH 1/1] dt: fix some code indent issue in of.h
Date: Wed, 21 Dec 2011 02:10:09 +0800
Message-ID: <1324404609-3999-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Checkpatch script will report some warnings for the old coding style:
WARNING: suspect code indent for conditional statements (8, 0)
        for (child = of_get_next_child(parent, NULL); child != NULL; \
[...]
+static inline int of_get_child_count(const struct device_node *np)

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/of.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index f1a490c..95dee0a 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -163,22 +163,22 @@ extern struct device_node *of_find_node_by_name(struct device_node *from,
 	const char *name);
 #define for_each_node_by_name(dn, name) \
 	for (dn = of_find_node_by_name(NULL, name); dn; \
-	     dn = of_find_node_by_name(dn, name))
+		dn = of_find_node_by_name(dn, name))
 extern struct device_node *of_find_node_by_type(struct device_node *from,
 	const char *type);
 #define for_each_node_by_type(dn, type) \
 	for (dn = of_find_node_by_type(NULL, type); dn; \
-	     dn = of_find_node_by_type(dn, type))
+		dn = of_find_node_by_type(dn, type))
 extern struct device_node *of_find_compatible_node(struct device_node *from,
 	const char *type, const char *compat);
 #define for_each_compatible_node(dn, type, compatible) \
 	for (dn = of_find_compatible_node(NULL, type, compatible); dn; \
-	     dn = of_find_compatible_node(dn, type, compatible))
+		dn = of_find_compatible_node(dn, type, compatible))
 extern struct device_node *of_find_matching_node(struct device_node *from,
 	const struct of_device_id *matches);
 #define for_each_matching_node(dn, matches) \
 	for (dn = of_find_matching_node(NULL, matches); dn; \
-	     dn = of_find_matching_node(dn, matches))
+		dn = of_find_matching_node(dn, matches))
 extern struct device_node *of_find_node_by_path(const char *path);
 extern struct device_node *of_find_node_by_phandle(phandle handle);
 extern struct device_node *of_get_parent(const struct device_node *node);
@@ -187,13 +187,13 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
 					     struct device_node *prev);
 #define for_each_child_of_node(parent, child) \
 	for (child = of_get_next_child(parent, NULL); child != NULL; \
-	     child = of_get_next_child(parent, child))
+		child = of_get_next_child(parent, child))
 
 extern struct device_node *of_find_node_with_property(
 	struct device_node *from, const char *prop_name);
 #define for_each_node_with_property(dn, prop_name) \
 	for (dn = of_find_node_with_property(NULL, prop_name); dn; \
-	     dn = of_find_node_with_property(dn, prop_name))
+		dn = of_find_node_with_property(dn, prop_name))
 
 extern struct property *of_find_property(const struct device_node *np,
 					 const char *name,
-- 
1.7.0.4


