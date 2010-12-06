Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab0LFWF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:05:27 -0500
Received: from mail.perches.com ([173.55.12.10]:2327 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab0LFWFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:20 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/29] arch/alpha: Update WARN uses
Date: Mon,  6 Dec 2010 14:04:52 -0800
Message-Id: <a9d2a8354fff08552ee1e9e8054a56467a9ea6b2.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
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
1.7.3.2.245.g03276.dirty

