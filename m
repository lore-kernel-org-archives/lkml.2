Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0JPDln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 23:41:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57079 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0JPDll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 23:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Eh6nr59zCqvc27eL+4t5YEqt7292uWUt4JX7J6/H0G2JaV9bFmz9pdp62LMP6cS7nY
         Yy3uwtlqm73PEF2hvASmKrgmMfjbER7wMkKKH3V2eBMVKSILhV6HjZdOdsuXiYFfiq48
         zQ76eis5nGPt/NLPuLqeF0v3/SfkN5+n/bEN0=
From: Tracey Dent <tdent48227@gmail.com>
To: jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com,
        linux-ide@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Drivers: ata: Makefile: replace the use of <module>-objs with <module>-y
Date: Fri, 15 Oct 2010 23:41:33 -0400
Message-Id: <1287200493-2024-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/ata/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index ccd461b..c501af5 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -99,7 +99,7 @@ obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
 # Should be last libata driver
 obj-$(CONFIG_PATA_LEGACY)	+= pata_legacy.o
 
-libata-objs	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
+libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
-- 
1.7.3.1.104.gc752e

