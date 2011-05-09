Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab1EJIoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:44:14 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53135
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756043Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 202/206] Staging: hv: Get rid of vmbus.h
Date: Mon,  9 May 2011 14:58:04 -0700
Message-Id: <1304978288-22999-202-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of vmbus.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus.h |   51 --------------------------------------------
 1 files changed, 0 insertions(+), 51 deletions(-)
 delete mode 100644 drivers/staging/hv/vmbus.h

diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
deleted file mode 100644
index 73087f2..0000000
--- a/drivers/staging/hv/vmbus.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- *
- * Copyright (c) 2009, Microsoft Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
- * Authors:
- *   Haiyang Zhang <haiyangz@microsoft.com>
- *   Hank Janssen  <hjanssen@microsoft.com>
- *
- */
-
-
-#ifndef _VMBUS_H_
-#define _VMBUS_H_
-
-#include <linux/device.h>
-#include "vmbus_api.h"
-
-
-
-
-static inline struct hv_device *device_to_hv_device(struct device *d)
-{
-	return container_of(d, struct hv_device, device);
-}
-
-static inline struct hv_driver *drv_to_hv_drv(struct device_driver *d)
-{
-	return container_of(d, struct hv_driver, driver);
-}
-
-
-/* Vmbus interface */
-int vmbus_child_driver_register(struct device_driver *drv);
-void vmbus_child_driver_unregister(struct device_driver *drv);
-
-extern struct completion hv_channel_ready;
-
-#endif /* _VMBUS_H_ */
-- 
1.7.4.1

