Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab0LNIkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:40:24 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:32946 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab0LNIkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:40:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=P+dC7a8yl0vt76zAptgRzsXltpL0W4/UKgIxFY2xGvDAi1La2Jd1pXPO33+CF6xYrH
         fK0xp+lH+Hfsw0R8D3S+n1FOPNCwopVon1DNWUEJZ+cAv8caFN+GPAi6rZnzGD9q0IcR
         MwbDh4Z2JbrxopzKsQ7IK9QFnKjnGsKrVBQ6c=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/2] staging: ft1000: Rename ft1000_chdev.c to ft1000_debug.c.
Date: Tue, 14 Dec 2010 09:42:28 +0100
Message-Id: <1292316148-9769-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292316148-9769-1-git-send-email-marek.belisko@open-nandra.com>
References: <1292316148-9769-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Name of old file was misleading because it is currently
updated to debugfs so change also file name.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/Makefile         |    2 +-
 .../ft1000-usb/{ft1000_chdev.c => ft1000_debug.c}  |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/staging/ft1000/ft1000-usb/{ft1000_chdev.c => ft1000_debug.c} (100%)

diff --git a/drivers/staging/ft1000/ft1000-usb/Makefile b/drivers/staging/ft1000/ft1000-usb/Makefile
index dd87ecd..f0f5240 100644
--- a/drivers/staging/ft1000/ft1000-usb/Makefile
+++ b/drivers/staging/ft1000/ft1000-usb/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_FT1000_USB) += ft1000.o
 
-ft1000-y := ft1000_chdev.o ft1000_download.o ft1000_hw.o ft1000_proc.o ft1000_usb.o
+ft1000-y := ft1000_debug.o ft1000_download.o ft1000_hw.o ft1000_proc.o ft1000_usb.o
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
similarity index 100%
rename from drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
rename to drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
-- 
1.7.1

