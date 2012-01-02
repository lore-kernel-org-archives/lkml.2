Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab2ABJtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 04:49:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41212 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2ABJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 04:49:05 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-38-4f017d8f1c45
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Donggeun Kim <dg77.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, len.brown@intel.com,
        pavel@ucw.cz, rjw@sisk.pl, rdunlap@xenotime.net,
        cbouatmailru@gmail.com, pali.rohar@gmail.com, prakity@mavell.com,
        lars@metafoo.de, kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: [PATCH] regulator: add regulator_force_disable() definition for
 !CONFIG_REGULATOR
Date: Mon, 02 Jan 2012 18:49:32 +0900
Message-id: <1325497772-1817-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <20111228110550.GB24405@opensource.wolfsonmicro.com>
References: <20111228110550.GB24405@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_force_disable() was omitted in consumer.h for
!CONFIG_REGULATOR case.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/regulator/consumer.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f7756d1..889ab5a 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -212,6 +212,11 @@ static inline int regulator_disable(struct regulator *regulator)
 	return 0;
 }
 
+static inline int regulator_force_disable(struct regulator *regulator)
+{
+	return 0;
+}
+
 static inline int regulator_disable_deferred(struct regulator *regulator,
 					     int ms)
 {
-- 
1.7.4.1

