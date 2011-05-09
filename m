Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1EJIln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:41:43 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35341
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756077Ab1EJIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 159/206] Staging: hv: Include the contents of version_info.h
Date: Mon,  9 May 2011 14:57:21 -0700
Message-Id: <1304978288-22999-159-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 include/linux/hyperv.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 2e72a47..fc05036 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -706,4 +706,24 @@ extern unsigned int vmbus_loglevel;
 	} while (0)
 
 
+/*
+ * We use the same version numbering for all Hyper-V modules.
+ *
+ * Definition of versioning is as follows;
+ *
+ *	Major Number	Changes for these scenarios;
+ *			1.	When a new version of Windows Hyper-V
+ *				is released.
+ *			2.	A Major change has occurred in the
+ *				Linux IC's.
+ *			(For example the merge for the first time
+ *			into the kernel) Every time the Major Number
+ *			changes, the Revision number is reset to 0.
+ *	Minor Number	Changes when new functionality is added
+ *			to the Linux IC's that is not a bug fix.
+ *
+ * 3.1 - Added completed hv_utils driver. Shutdown/Heartbeat/Timesync
+ */
+#define HV_DRV_VERSION           "3.1"
+
 #endif /* _HYPERV_H_ */
-- 
1.7.4.1

