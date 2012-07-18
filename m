Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2GRWmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:42:49 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35893
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753294Ab2GRWmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:42:44 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: Change the hex constant to a decimal constant
Date: Wed, 18 Jul 2012 15:57:25 -0700
Message-Id: <1342652245-931-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hex constant chosen for HV_LINUX_GUEST_ID_HI was offensive, update to use
the decimal equivalent instead.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hyperv_vmbus.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index b9426a6..0614ff3 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -411,7 +411,7 @@ enum {
 #define HV_PRESENT_BIT			0x80000000
 
 #define HV_LINUX_GUEST_ID_LO		0x00000000
-#define HV_LINUX_GUEST_ID_HI		0xB16B00B5
+#define HV_LINUX_GUEST_ID_HI		2976579765
 #define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI << 32) | \
 					   HV_LINUX_GUEST_ID_LO)
 
-- 
1.7.4.1

