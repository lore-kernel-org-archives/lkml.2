Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0F2KPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab0F2KPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VvNoSe0+Q+ZQmnlgbT0YqBlQUX4lMejaZ4vfhXh1hhdk5cX47L8fR7LOc9aNaQoOtV
         yjIz+QykBr7UZFYwrE+7Qe5qxF5t/NFijyQGrEUCNBHl/Fc+pHBpS7o6qL2B5FmbU4Kk
         KamNu0SxaLXYdEHaR8AgpiikVPmZoQUw6/2lg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Michal Schmidt <mschmidt@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/25] pci-sysfs: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:28 +0400
Message-Id: <1277806529-31010-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/pci/pci-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index afd2fbf..7f8bc8c 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -734,7 +734,7 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
 						       struct device, kobj));
-	struct resource *res = (struct resource *)attr->private;
+	struct resource *res = attr->private;
 	enum pci_mmap_state mmap_type;
 	resource_size_t start, end;
 	int i;
-- 
1.7.0.4

