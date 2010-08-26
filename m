Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0HZFxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 01:53:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28212 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab0HZFxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 01:53:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6085"; a="52151621"
From: Saravana Kannan <skannan@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] pm_qos: Fix inline documentation.
Date: Wed, 25 Aug 2010 22:52:55 -0700
Message-Id: <1282801975-18348-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change-Id: I32f95b5a7e92236931b38fc4f1474f46ad22e298
Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 kernel/pm_qos_params.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 996a4de..132471f 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -212,15 +212,17 @@ EXPORT_SYMBOL_GPL(pm_qos_request_active);
 
 /**
  * pm_qos_add_request - inserts new qos request into the list
- * @pm_qos_class: identifies which list of qos request to us
+ * @dep: pointer to a preallocated handle
+ * @pm_qos_class: identifies which list of qos request to use
  * @value: defines the qos request
  *
  * This function inserts a new entry in the pm_qos_class list of requested qos
  * performance characteristics.  It recomputes the aggregate QoS expectations
- * for the pm_qos_class of parameters, and returns the pm_qos_request list
- * element as a handle for use in updating and removal.  Call needs to save
- * this handle for later use.
+ * for the pm_qos_class of parameters and initializes the pm_qos_request_list
+ * handle.  Caller needs to save this handle for later use in updates and
+ * removal.
  */
+
 void pm_qos_add_request(struct pm_qos_request_list *dep,
 			int pm_qos_class, s32 value)
 {
-- 
1.7.1.1
---
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
