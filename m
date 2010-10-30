Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab0J3VJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:09:31 -0400
Received: from mail.perches.com ([173.55.12.10]:3692 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab0J3VJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:20 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/39] arch/alpha: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:19 -0700
Message-Id: <517a3d5c620dd4843a35a05c9a1c123b4b936cd9.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/alpha/kernel/pci-sysfs.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/kernel/pci-sysfs.c b/arch/alpha/kernel/pci-sysfs.c
index b899e95..6f30ac3 100644
--- a/arch/alpha/kernel/pci-sysfs.c
+++ b/arch/alpha/kernel/pci-sysfs.c
@@ -44,10 +44,9 @@ static int __pci_mmap_fits(struct pci_dev *pdev, int num,
 
 	if (start < size && size - start >= nr)
 		return 1;
-	WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on %s BAR %d "
-		"(size 0x%08lx)\n",
-		current->comm, sparse ? " sparse" : "", start, start + nr,
-		pci_name(pdev), num, size);
+	WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
+	     current->comm, sparse ? " sparse" : "", start, start + nr,
+	     pci_name(pdev), num, size);
 	return 0;
 }
 
@@ -261,10 +260,9 @@ static int __legacy_mmap_fits(struct pci_controller *hose,
 
 	if (start < size && size - start >= nr)
 		return 1;
-	WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on hose %d "
-		"(size 0x%08lx)\n",
-		current->comm, sparse ? " sparse" : "", start, start + nr,
-		hose->index, size);
+	WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on hose %d (size 0x%08lx)\n",
+	     current->comm, sparse ? " sparse" : "", start, start + nr,
+	     hose->index, size);
 	return 0;
 }
 
-- 
1.7.3.1.g432b3.dirty

