Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1HOVxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:53:33 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:36442
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753121Ab1HOVwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:52:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 5/8] Staging: hv: vmbus: Fixup indentation in vmbus_acpi_add()
Date: Mon, 15 Aug 2011 15:12:04 -0700
Message-Id: <1313446327-10650-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313446327-10650-1-git-send-email-kys@microsoft.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
 <1313446327-10650-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup some  indentation issues in vmbus_acpi_add().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 536466b..275c4ef 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -654,9 +654,8 @@ static int vmbus_acpi_add(struct acpi_device *device)
 
 	hv_acpi_dev = device;
 
-	result =
-	acpi_walk_resources(device->handle, METHOD_NAME__CRS,
-			vmbus_walk_resources, &irq);
+	result = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+					vmbus_walk_resources, &irq);
 
 	if (ACPI_FAILURE(result)) {
 		complete(&probe_event);
-- 
1.7.4.1

