Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1HYQky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:40:54 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48429
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753444Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 03/59] Staging: hv: Add struct hv_vmbus_device_id to mod_devicetable.h
Date: Thu, 25 Aug 2011 09:48:29 -0700
Message-Id: <1314290965-2698-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for implementing vmbus aliases for auto-loading
Hyper-V drivers, define vmbus specific device ID.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 include/linux/mod_devicetable.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index ae28e93..5a12377 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -405,6 +405,13 @@ struct virtio_device_id {
 };
 #define VIRTIO_DEV_ANY_ID	0xffffffff
 
+/*
+ * For Hyper-V devices we use the device guid as the id.
+ */
+struct hv_vmbus_device_id {
+	__u8 guid[16];
+};
+
 /* i2c */
 
 #define I2C_NAME_SIZE	20
-- 
1.7.4.1

