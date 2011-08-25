Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab1HYO24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:28:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45550 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1HYO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:28:53 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mjg@redhat.com
Subject: [PATCH] MAINTAINERS: add new entry for ideapad-laptop
Date: Thu, 25 Aug 2011 22:28:45 +0800
Message-Id: <1314282525-2247-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 069ee3b..cca2a91 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3183,6 +3183,13 @@ F:	Documentation/ide/
 F:	drivers/ide/
 F:	include/linux/ide.h
 
+IDEAPAD LAPTOP EXTRAS DRIVER
+M:	Ike Panhc <ike.pan@canonical.com>
+L:	platform-driver-x86@vger.kernel.org
+W:	http://launchpad.net/ideapad-laptop
+S:	Maintained
+F:	drivers/platform/x86/ideapad-laptop.c
+
 IDE/ATAPI DRIVERS
 M:	Borislav Petkov <petkovbb@gmail.com>
 L:	linux-ide@vger.kernel.org
-- 
1.7.5.4

