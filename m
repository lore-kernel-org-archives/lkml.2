Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0JHACQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab0JHACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LozDaPser0f4c6MMct4X9ArBzoiY40MbfOnyDiGRutexRb/TLItzUA6allNgzi64jW
         vnQKg2yMZ4Y1JNjvQf/9Ko0CmzwPgrKZEGV70uAglPAFYEQLYUw9kbhL1hHP5E/DKSRh
         /KjHh9R8ooc/Fdnt1UjCzbvPm2syHdYYZLd/w=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 10/33] Staging: et131x: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:30 -0400
Message-Id: <1286496113-11897-10-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/et131x/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/Makefile b/drivers/staging/et131x/Makefile
index 95c645d..dfcd2bf 100644
--- a/drivers/staging/et131x/Makefile
+++ b/drivers/staging/et131x/Makefile
@@ -4,7 +4,7 @@
 
 obj-$(CONFIG_ET131X) += et131x.o
 
-et131x-objs :=	et1310_eeprom.o \
+et131x-y :=	et1310_eeprom.o \
 		et1310_mac.o \
 		et1310_phy.o \
 		et1310_pm.o \
-- 
1.7.3.1.50.g1e633

