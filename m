Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab2KHSag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 13:30:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48336 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab2KHS3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 13:29:40 -0500
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com
Cc: rjw@sisk.pl, wency@cn.fujitsu.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-mm@kvack.org,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Subject: [RFC PATCH 1/3] acpi: Introduce prepare_remove operation in acpi_device_ops
Date: Thu,  8 Nov 2012 19:29:29 +0100
Message-Id: <1352399371-8015-2-git-send-email-vasilis.liaskovitis@profitbricks.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1352399371-8015-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
References: <1352399371-8015-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
---
 include/acpi/acpi_bus.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 2242c10..6ef1692 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -94,6 +94,7 @@ typedef int (*acpi_op_start) (struct acpi_device * device);
 typedef int (*acpi_op_bind) (struct acpi_device * device);
 typedef int (*acpi_op_unbind) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
+typedef int (*acpi_op_prepare_remove) (struct acpi_device *device);
 
 struct acpi_bus_ops {
 	u32 acpi_op_add:1;
@@ -107,6 +108,7 @@ struct acpi_device_ops {
 	acpi_op_bind bind;
 	acpi_op_unbind unbind;
 	acpi_op_notify notify;
+	acpi_op_prepare_remove prepare_remove;
 };
 
 #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */
-- 
1.7.9

