Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031249Ab2CSNlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:41:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36019 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819Ab2CSNlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:41:31 -0400
From: Laura Vasilescu <laura@rosedu.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, daniel.baluta@gmail.com,
        Laura Vasilescu <laura@rosedu.org>
Subject: [PATCH] kcore: fix spelling
Date: Mon, 19 Mar 2012 15:41:15 +0200
Message-Id: <1332164475-10382-1-git-send-email-laura@rosedu.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1332156983-9844-1-git-send-email-laura@rosedu.org>
References: <1332156983-9844-1-git-send-email-laura@rosedu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Laura Vasilescu <laura@rosedu.org>
Cc: Daniel Baluta <daniel.baluta@gmail.com>
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

