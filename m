Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2CTDKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:10:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47448 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2CTDKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:10:02 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mjg@redhat.com, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH] MAINTAINERS: change the mail address of acer-wmi/msi-laptop maintainer
Date: Tue, 20 Mar 2012 11:08:17 +0800
Message-Id: <1332212897-12875-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to I moved to use suse.com mail address, so, add patch to change the
mail address in MAINTAINERS file.

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c63a43..1a31b43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -218,7 +218,7 @@ S:	Maintained
 F:	drivers/platform/x86/acerhdf.c
 
 ACER WMI LAPTOP EXTRAS
-M:	Joey Lee <jlee@novell.com>
+M:	"Lee, Chun-Yi" <jlee@suse.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/acer-wmi.c
@@ -4432,7 +4432,7 @@ F:	Documentation/serial/moxa-smartio
 F:	drivers/tty/mxser.*
 
 MSI LAPTOP SUPPORT
-M:	"Lee, Chun-Yi" <jlee@novell.com>
+M:	"Lee, Chun-Yi" <jlee@suse.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/msi-laptop.c
-- 
1.6.0.2

