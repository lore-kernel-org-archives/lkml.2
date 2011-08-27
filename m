Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1H0SMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:35 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:38105
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751554Ab1H0SLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 39/46] Staging: hv: vmbus: Fixup indentation in vmbus_acpi_add()
Date: Sat, 27 Aug 2011 11:31:38 -0700
Message-Id: <1314469905-7058-39-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup indentation in vmbus_acpi_add().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 4e07d4f..d50fa89 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -678,9 +678,8 @@ static int vmbus_acpi_add(struct acpi_device *device)
 
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

