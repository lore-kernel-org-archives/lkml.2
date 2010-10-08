Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab0JHACl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab0JHACi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q0Cfq1eLb44Aqshx4IO1R1569tE6BB9nGv7NFzU88vbxpgjjK6cow/Rstn50M6VwZh
         0P9AN1lgQceB+1FyKyML5yfhnwCESprMPTaOCNzQMHQEckzaAqE94oCMuXSTt0A7FwLc
         kJpSgUb9hc2HZm4nxxNVLEilkb25Cj57wz0So=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 26/33] Staging: tidspbridge: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:46 -0400
Message-Id: <1286496113-11897-26-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/tidspbridge/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index 7c122fa..50decc2 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -12,7 +12,7 @@ librmgr = rmgr/dbdcd.o rmgr/disp.o rmgr/drv.o rmgr/mgr.o rmgr/node.o \
 libdload = dynload/cload.o dynload/getsection.o dynload/reloc.o \
 		 dynload/tramp.o
 
-bridgedriver-objs = $(libgen) $(libservices) $(libcore) $(libpmgr) $(librmgr) \
+bridgedriver-y := $(libgen) $(libservices) $(libcore) $(libpmgr) $(librmgr) \
 			$(libdload)
 
 #Machine dependent
-- 
1.7.3.1.50.g1e633

