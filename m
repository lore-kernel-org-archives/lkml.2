Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0KASuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:50:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33268 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab0KASld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P1/ebfW2gRt6gBZCv7TR27QNTCW4H0wep0DGFSI0e5j5TUpubiTIti6Zq8mAO2p1TG
         JPII1osIcg9dKsDbSOXgZReZQKycLfZJR4gdXa5/j5/AB+Hx1LO9jYyKwAUzL3SU+Iw6
         SX/Js2SU3Okn/f63sgPjsp+Zp9EB/b6W17gjk=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 01/29] Staging: Add yaffs2 support
Date: Mon,  1 Nov 2010 14:40:49 -0400
Message-Id: <1288636877-7964-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed files so that it could be compiled with yaffs2 enabled.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/Kconfig  |    2 ++
 drivers/staging/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index f9c9c8a..7f4287a86 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -93,6 +93,8 @@ source "drivers/staging/pohmelfs/Kconfig"
 
 source "drivers/staging/autofs/Kconfig"
 
+source "drivers/staging/yaffs2/Kconfig"
+
 source "drivers/staging/phison/Kconfig"
 
 source "drivers/staging/line6/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index a85074f..5f30c1b 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_TRANZPORT)		+= frontier/
 obj-$(CONFIG_DREAM)		+= dream/
 obj-$(CONFIG_POHMELFS)		+= pohmelfs/
 obj-$(CONFIG_AUTOFS_FS)		+= autofs/
+obj-$(CONFIG_YAFFS_FS)		+= yaffs2/
 obj-$(CONFIG_IDE_PHISON)	+= phison/
 obj-$(CONFIG_LINE6_USB)		+= line6/
 obj-$(CONFIG_USB_SERIAL_QUATECH2)	+= serqt_usb2/
-- 
1.7.3.2.146.gca209

