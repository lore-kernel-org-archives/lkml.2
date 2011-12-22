Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1LVQAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:00:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:35097 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1LVQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:00:50 -0500
From: Richard Weinberger <rw@linutronix.de>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Richard Weinberger <rw@linutronix.de>
Subject: [PATCH] [RFC] ubi: Make vid_hdr non-static
Date: Thu, 22 Dec 2011 16:12:57 +0100
Message-Id: <1324566777-1918-1-git-send-email-rw@linutronix.de>
X-Mailer: git-send-email 1.7.7
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to have vid_hdr static.

Signed-off-by: Richard Weinberger <rw@linutronix.de>
---
 drivers/mtd/ubi/vtbl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index 9ad18da..890754c 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -306,7 +306,7 @@ static int create_vtbl(struct ubi_device *ubi, struct ubi_scan_info *si,
 		       int copy, void *vtbl)
 {
 	int err, tries = 0;
-	static struct ubi_vid_hdr *vid_hdr;
+	struct ubi_vid_hdr *vid_hdr;
 	struct ubi_scan_leb *new_seb;
 
 	ubi_msg("create volume table (copy #%d)", copy + 1);
-- 
1.7.7

