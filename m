Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0JSSTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:19:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65477 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0JSSTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NbjBGNISTlz1Ttt6vrj4pridSTSmsh5AlmHWJtig9daTitpvHMksoLba5T5StUP4f9
         aM2TOaLZfJR50ue5q5Jr5mYDCARHu34pZUX3MK30lSdK9mCIo5ljRiPotqcHXEdCehK6
         T1dogh3IvuBCoxITXvbfmoJotQbG9ct5S6k0w=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: akpm@linux-foundation.org
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH] kernel: printk: Fix a coding style issue.
Date: Tue, 19 Oct 2010 20:19:01 +0200
Message-Id: <1287512341-13130-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue of "do_syslog" in
case of open or close the log.

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 kernel/printk.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 8fe465a..3539744 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -273,9 +273,8 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		return error;
 
 	switch (type) {
-	case SYSLOG_ACTION_CLOSE:	/* Close log */
-		break;
 	case SYSLOG_ACTION_OPEN:	/* Open log */
+	case SYSLOG_ACTION_CLOSE:	/* Close log */
 		break;
 	case SYSLOG_ACTION_READ:	/* Read from log */
 		error = -EINVAL;
-- 
1.7.1

