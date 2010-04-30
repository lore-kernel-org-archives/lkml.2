Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0D3RvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:51:19 -0400
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:55744 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416Ab0D3RvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:51:00 -0400
From: Bill Pemberton <wfp5p@virginia.edu>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] printk: remove duplicate const
Date: Fri, 30 Apr 2010 09:34:37 -0400
Message-Id: <1272634478-4127-11-git-send-email-wfp5p@virginia.edu>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <1272634478-4127-1-git-send-email-wfp5p@virginia.edu>
References: <1272634478-4127-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warnings:

kernel/printk.c:1485:25: warning: duplicate const

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
CC: linux-kernel@vger.kernel.org
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 444b770..c3b14c9 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1482,7 +1482,7 @@ int kmsg_dump_unregister(struct kmsg_dumper *dumper)
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
 
-static const char const *kmsg_reasons[] = {
+static const char *kmsg_reasons[] = {
 	[KMSG_DUMP_OOPS]	= "oops",
 	[KMSG_DUMP_PANIC]	= "panic",
 	[KMSG_DUMP_KEXEC]	= "kexec",
-- 
1.7.0.6

