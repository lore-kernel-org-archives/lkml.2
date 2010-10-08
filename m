Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0JHAEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:04:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab0JHACd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=b17hQ5m9Gxrdpf0COnMbC4ibMEvKxckosiWDU6wIgQf2F8RjEizmOkUMaUL2BKAYce
         BHDhDZEAGJK4kaJnPCbH81pGu2zrODixcZGBI4SOoluRr2geS/MSzG8W9irFz2eZ1U0D
         4IDigKE+h/x8ZIaQ4GoK7ztrqPxw46h5dnIY4=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 23/33] Staging: sbe-2t3e3: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:43 -0400
Message-Id: <1286496113-11897-23-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/sbe-2t3e3/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/Makefile b/drivers/staging/sbe-2t3e3/Makefile
index 2c7b097..cce2a7a 100644
--- a/drivers/staging/sbe-2t3e3/Makefile
+++ b/drivers/staging/sbe-2t3e3/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_SBE_2T3E3) += sbe-2t3e3.o
 
-sbe-2t3e3-objs := module.o netdev.o maps.o	\
+sbe-2t3e3-y := module.o netdev.o maps.o	\
 	main.o cpld.o intr.o ctrl.o io.o dc.o exar7250.o exar7300.o
-- 
1.7.3.1.50.g1e633

