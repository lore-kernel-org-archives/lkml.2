Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1LIEWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:22:17 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54759 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753388Ab1LIEWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:22:13 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH v3.2 02/10] MAINTAINERS: Update amd-iommu F: patterns
Date: Thu,  8 Dec 2011 20:21:40 -0800
Message-Id: <381c92e63d0d3a7bcc1966308cd9ead92199dc1b.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 29b68415e335 ("x86: amd_iommu: move to drivers/iommu/")
moved the files, update the patterns.

CC: Ohad Ben-Cohen <ohad@wizery.com>
CC: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7daf771..80167e7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -511,8 +511,8 @@ M:	Joerg Roedel <joerg.roedel@amd.com>
 L:	iommu@lists.linux-foundation.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
-F:	arch/x86/kernel/amd_iommu*.c
-F:	arch/x86/include/asm/amd_iommu*.h
+F:	drivers/iommu/amd_iommu*.[ch]
+F:	include/linux/amd-iommu.h
 
 AMD MICROCODE UPDATE SUPPORT
 M:	Andreas Herrmann <andreas.herrmann3@amd.com>
-- 
1.7.8.111.gad25c.dirty

