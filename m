Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068Ab2C3KZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:25:01 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52218 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760644Ab2C3KSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:34 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 73/76] ACPI: export acpi_kobj
Date: Fri, 30 Mar 2012 06:14:16 -0400
Message-id: <f2d4753fbd4d15c65d6ba48167aa83916ddbe518.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Drivers may wish to add entries to /sys/firmware/acpi, so export acpi_kobj
in order to let them do that.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/bus.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 9ecec98..3263b68 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1010,6 +1010,7 @@ static int __init acpi_bus_init(void)
 }
 
 struct kobject *acpi_kobj;
+EXPORT_SYMBOL_GPL(acpi_kobj);
 
 static int __init acpi_init(void)
 {
-- 
1.7.10.rc2.19.gfae9d

