Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab2JAOUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:20:34 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56275 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2JAOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:20:32 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] MAINTAINERS: Add stk1160 driver
Date: Mon,  1 Oct 2012 11:20:13 -0300
Message-Id: <1349101213-21723-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0750c24..17f6fb0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3168,6 +3168,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	drivers/media/usb/gspca/
 
+STK1160 USB VIDEO CAPTURE DRIVER
+M:	Ezequiel Garcia <elezegarcia@redhat.com>
+L:	linux-media@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+S:	Maintained
+F:	drivers/media/usb/stk1160/
+
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 M:	Frank Seidel <frank@f-seidel.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
1.7.4.4

