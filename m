Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab1HVUEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:04:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1HVUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:04:39 -0400
From: Tom Lane <tom.lane0@gmail.com>
To: airlied@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Tom Lane <tom.lane0@gmail.com>
Subject: [PATCH] Drivers Gpu: Vga driver: fixed a brace issue.
Date: Mon, 22 Aug 2011 21:03:04 +0100
Message-Id: <1314043384-6148-1-git-send-email-tom.lane0@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a coding style error in vga driver and removed following whitespace.

Signed-off-by: Tom Lane <tom.lane0@gmail.com>
---
 drivers/gpu/vga/vgaarb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index c72f1c0..c5b5375 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -285,9 +285,9 @@ enable_them:
 
 	pci_set_vga_state(vgadev->pdev, true, pci_bits, flags);
 
-	if (!vgadev->bridge_has_one_vga) {
+	if (!vgadev->bridge_has_one_vga)
 		vga_irq_set_state(vgadev, true);
-	}
+
 	vgadev->owns |= (wants & vgadev->decodes);
 lock_them:
 	vgadev->locks |= (rsrc & VGA_RSRC_LEGACY_MASK);
-- 
1.7.6

