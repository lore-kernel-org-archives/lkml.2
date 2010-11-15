Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab0KODF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1221 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab0KODFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:55 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 31/44] drivers/xen: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:50 -0800
Message-Id: <b3f95cd997859d5d714de322ce17810fe73460cd.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 54469c3..65ea21a 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -54,7 +54,7 @@ u64 start_dma_addr;
 
 static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
 {
-	return phys_to_machine(XPADDR(paddr)).maddr;;
+	return phys_to_machine(XPADDR(paddr)).maddr;
 }
 
 static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
-- 
1.7.3.1.g432b3.dirty

