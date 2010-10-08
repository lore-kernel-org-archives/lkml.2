Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0JHADQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:03:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab0JHACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YCYztvTAngd91AIRigMvpI+IvYEsLNLluWMg0WQ975F458vBKAyziej4rnYSnIERc6
         9cqLrdNr8Rnlxxg/tL2342aa+Pt7Td5A+E0uGJgPjX8NA8cQMweviL77x0R7iAgRcvQr
         Hg9M29czS/5iHcBIVqNZoyvjsQXyxTFgf3roY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 27/33] Staging: ti-st: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:47 -0400
Message-Id: <1286496113-11897-27-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/ti-st/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ti-st/Makefile b/drivers/staging/ti-st/Makefile
index 0167d1d..4b6ca18 100644
--- a/drivers/staging/ti-st/Makefile
+++ b/drivers/staging/ti-st/Makefile
@@ -3,5 +3,5 @@
 # and its protocol drivers (BT, FM, GPS)
 #
 obj-$(CONFIG_TI_ST) 		+= st_drv.o
-st_drv-objs			:= st_core.o st_kim.o st_ll.o
+st_drv-y			:= st_core.o st_kim.o st_ll.o
 obj-$(CONFIG_ST_BT) 		+= bt_drv.o
-- 
1.7.3.1.50.g1e633

