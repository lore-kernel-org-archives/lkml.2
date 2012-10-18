Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2JRCYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 22:24:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59443 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2JRCX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 22:23:58 -0400
X-IronPort-AV: E=Sophos;i="4.80,604,1344182400"; 
   d="scan'208";a="6019389"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: bhelgaas@google.com, lenb@kernel.org, yinghai@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Add PNP0A08 into acpi_pci_roots array.
Date: Thu, 18 Oct 2012 10:22:51 +0800
Message-Id: <1350526971-9427-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 10:23:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 10:23:35,
	Serialize complete at 2012/10/18 10:23:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_pci_roots array doesn't include PNP0A08, which is PCI Express
Root Bridge.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/pci_root.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 037b59c..dedc4d6 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -56,6 +56,7 @@ static int acpi_pci_root_start(struct acpi_device *device);
 
 static const struct acpi_device_id root_device_ids[] = {
 	{"PNP0A03", 0},
+	{"PNP0A08", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, root_device_ids);
-- 
1.7.1

