Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2LJTov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:44:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17132 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2LJTmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:15 -0500
X-AuditID: cbfee61b-b7f616d00000319b-28-50c63b167e3b
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 05/13] of: Add empty for_each_available_child_of_node()
 macro definition
Date: Mon, 10 Dec 2012 20:41:31 +0100
Message-id: <1355168499-5847-6-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jQV0x62MBBhdnWllc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ+rNvGWLCHreLWi2/sDYzrWbsYOTkkBEwk3rWcYoGw
	xSQu3FvP1sXIxSEkMJ1RovfsEWYIp4NJ4lbXMzaQKjYBQ4neo32MILaIgJnEu87HLCBFzAJ9
	TBIn7/wCGyssECdxfE4/mM0ioCpx8vMEsBW8Aq4Si2dsYu9i5ABapyAxZ5INSJhTwE3i9aFW
	sJlCQCU/Zq5jnsDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGsPefSe9gXNVgcYhR
	gINRiYdXQ+tYgBBrYllxZe4hRgkOZiUR3ggJoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeZo+U
	ACGB9MSS1OzU1ILUIpgsEwenVAOj0zV5Vjte9pd//nc/E/zrf8oj9JL0z00rfun/UhX6+fj/
	KRfTJ2eNjBq2H//NpXzm6Yyb2Xzt7Qxvn/275uho82OtVGtjOFsZS8STy69uqM/7GDbxBNcH
	5/0K0qt/dRacnH/p/QEjWbNILb9fKcvco/7kubyOZNiwqvXGhhVlojkqnEZtyq+VlFiKMxIN
	tZiLihMBiTY7wPoBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this empty macro definition so users can be compiled without
excluding this macro call with preprocessor directives when CONFIG_OF
is disabled.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/of.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 2fb0dbe..7df42cc 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -332,6 +332,9 @@ static inline bool of_have_populated_dt(void)
 #define for_each_child_of_node(parent, child) \
 	while (0)
 
+#define for_each_available_child_of_node(parent, child) \
+	while (0)
+
 static inline struct device_node *of_get_child_by_name(
 					const struct device_node *node,
 					const char *name)
-- 
1.7.9.5

