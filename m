Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2LCKTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:19:16 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65334 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2LCKTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:19:14 -0500
From: Cong Ding <dinggnu@gmail.com>
To: JBottomley@parallels.com, Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] scsi:gdth.c: fix compilation warning
Date: Mon,  3 Dec 2012 10:19:09 +0000
Message-Id: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not allow old-style function definition.  Always spell foo(void) if
a function does not take any parameters.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/scsi/gdth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d72274..950c095 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -204,7 +204,7 @@ static char strbuf[MAX_SERBUF+1];
 #else
 #define COM_BASE 0x3f8
 #endif
-static void ser_init()
+static void ser_init(void)
 {
     unsigned port=COM_BASE;
 
-- 
1.7.4.5

