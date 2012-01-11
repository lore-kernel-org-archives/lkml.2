Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab2AKKBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:01:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15187 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab2AKKBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:01:35 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-93-4f0d5dfeaf51
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
Subject: [PATCH 2/2] PM / devfreq: fixed syntax errors.
Date: Wed, 11 Jan 2012 19:02:10 +0900
Message-id: <1326276130-4042-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1326276130-4042-1-git-send-email-myungjoo.ham@samsung.com>
References: <1326276130-4042-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If devfreq.h was included without CONFIG_PM_DEVFREQ, there has been a
compiler error with an additional semicolon added. This patch removes
that errorneous semicolon.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/devfreq.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index e9385bf..5862475 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -205,12 +205,12 @@ struct devfreq_simple_ondemand_data {
 static struct devfreq *devfreq_add_device(struct device *dev,
 					  struct devfreq_dev_profile *profile,
 					  struct devfreq_governor *governor,
-					  void *data);
+					  void *data)
 {
 	return NULL;
 }
 
-static int devfreq_remove_device(struct devfreq *devfreq);
+static int devfreq_remove_device(struct devfreq *devfreq)
 {
 	return 0;
 }
-- 
1.7.4.1

