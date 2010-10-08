Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0JHACL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0JHACJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I0yhKmJkL7mOhOySm6RbzLTBMjdxWhbKIs12N2WRjJgqoHRNQ8ivqDzmPe768TKR/h
         NPJ0M2W0fKGl7YSF9fEA1jfe6fvRQiXL9v2mcDa4b/mCELqnLsDNPOFdc3S9TkJBlwJk
         lffBPeQjv1Rr77J5u2pyecpXBQKU/4/4rvCPY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 07/33] Staging: cxt1e1: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:27 -0400
Message-Id: <1286496113-11897-7-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/cxt1e1/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cxt1e1/Makefile b/drivers/staging/cxt1e1/Makefile
index a524a62..e99b823 100644
--- a/drivers/staging/cxt1e1/Makefile
+++ b/drivers/staging/cxt1e1/Makefile
@@ -4,7 +4,7 @@ ccflags-y := -DSBE_PMCC4_ENABLE
 ccflags-y += -DSBE_ISR_TASKLET
 ccflags-y += -DSBE_INCLUDE_SYMBOLS
 
-cxt1e1-objs += 	\
+cxt1e1-y := 	\
   ossiRelease.o 	\
   musycc.o 		\
   pmcc4_drv.o 		\
-- 
1.7.3.1.50.g1e633

