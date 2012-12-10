Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab2LJTm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:42:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17145 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2LJTmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:23 -0500
X-AuditID: cbfee61b-b7f616d00000319b-41-50c63b1e79ca
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 07/13] of: Add empty of_get_next_child() function definition
Date: Mon, 10 Dec 2012 20:41:33 +0100
Message-id: <1355168499-5847-8-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t9jQV1562MBBus3M1lc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKOP13HUrCNveLAlo/sDYw9bF2MnBwSAiYSxz4uZoGw
	xSQu3FsPFhcSmM4oMeWMahcjF5DdwSTxZd1VsASbgKFE79E+RhBbRMBM4l3nYxaQImaBPiaJ
	k3d+sXYxcnAICwRIXNwTA2KyCKhKLO70AynnFXCV2PLqETNIWEJAQWLOJBuQMKeAm8TrQ62M
	EGtdJX7MXMc8gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYxgvz+T3sG4qsHiEKMA
	B6MSD6+G1rEAIdbEsuLK3EOMEhzMSiK8ERJAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzNHikB
	QgLpiSWp2ampBalFMFkmDk6pBsZuyRuG5679X6BklbXFpunmatXp/gv87jxpFj0j8q1ucXSy
	sZhws3WmNPctBWfdYxJHThw6mtGxzE4i7OiW+dEmZmJsXFtPrCuZ/i7jRcn0oJn69rJOc6fd
	1Q1cdu9CbEi562qvj3vF9cznR2vWiQltlV7kfF2QTV6MaYO4eWY2h5uzsOVpUyWW4oxEQy3m
	ouJEAPldtYf3AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an empty of_get_next_child() function definition so users can
be build when CONFIG_OF is disabled and are not required to exclude
OF specific parts explicitly with #ifdefs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/of.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 7df42cc..fb92acc 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -335,6 +335,13 @@ static inline bool of_have_populated_dt(void)
 #define for_each_available_child_of_node(parent, child) \
 	while (0)
 
+static inline struct device_node *of_get_next_child(
+					const struct device_node *node,
+					struct device_node *prev)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_get_child_by_name(
 					const struct device_node *node,
 					const char *name)
-- 
1.7.9.5

