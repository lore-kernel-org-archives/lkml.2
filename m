Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2CSLgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:36:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33709 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2CSLgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:36:21 -0400
From: Laura Vasilescu <laura@rosedu.org>
To: linux-kernel@vger.kernel.org
Cc: Laura Vasilescu <laura@rosedu.org>
Subject: [PATCH] Spell fix in fs/proc/kcore.c
Date: Mon, 19 Mar 2012 13:36:23 +0200
Message-Id: <1332156983-9844-1-git-send-email-laura@rosedu.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/proc/kcore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index d245cb2..e5e69af 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -513,7 +513,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 
 				n = copy_to_user(buffer, (char *)start, tsz);
 				/*
-				 * We cannot distingush between fault on source
+				 * We cannot distinguish between fault on source
 				 * and fault on destination. When this happens
 				 * we clear too and hope it will trigger the
 				 * EFAULT again.
-- 
1.7.2.5

