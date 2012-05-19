Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2ESQAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 12:00:18 -0400
Received: from nm32-vm7.bullet.mail.ne1.yahoo.com ([98.138.229.55]:20414 "HELO
	nm32-vm7.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750806Ab2ESQAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 12:00:16 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2012 12:00:16 EDT
X-Yahoo-Newman-Id: 338016.88235.bm@smtp202.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QSSPl7MVM1knyEwCUSXA3VIf73wmYpekvu_qtAfA65oi2EL
 9KbfCMf5rd6oZJ7300CJY7BzJaMrEx9tQgjf_5x9r8zNnfhBh3BhpGICbc1N
 t5gQr5l9SGQQ.OtvLvtwHwzy01Fq6Rrm2yZ6y439jii5gc4gOMtk5SxsUoln
 AUObiV1BSyqRb3UEUqjmEHDuhUih2eHkR82.uAZhEiEV0_ZNTM2CSfVnzm38
 JEatnVRtlSvRs5U_SN31p5skPOpJ5Hi7fsTFqA6aUyEZAEcDt.zXmPMK1eiF
 9TenMiHKipEbYCJjDGIdWfpGDHiAVA7GQdo3qN_x7FHYeilZOt8X_xgw2kd.
 BGIBPBL5j9isWRfLmKXNLIkV0nX.IbFBwinf4l2_SWkWdeocDHBp4CL3bjmA
 .L6VOy2pIOoCc82AaJ8IhZPBZNj0Ifq1kLtDTekFLuZZA4j3NKQK7quhEloz
 Y.RVK8LpkI4_7vyMr_NC15Esv2OFsVE4-
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH]fs:ext4:fixed space issue related to * operator.
Date: Sat, 19 May 2012 21:27:20 +0530
Message-Id: <1337443040-3609-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue relating to * operator found
by checkpath.pl tool in fs/ext4/fsync.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 fs/ext4/fsync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index bb6c7d8..b06e330 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -34,7 +34,7 @@
 
 #include <trace/events/ext4.h>
 
-static void dump_completed_IO(struct inode * inode)
+static void dump_completed_IO(struct inode *inode)
 {
 #ifdef	EXT4FS_DEBUG
 	struct list_head *cur, *before, *after;
-- 
1.7.10

