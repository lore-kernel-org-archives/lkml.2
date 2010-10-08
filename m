Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0JHACJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0JHACH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mdQ8aObXaqUEctQsc0mk1IdNgoVp0EsOBsgOAv26huqCDRdP+5WqIYLR3Df8sVOTSU
         JG0Nqdfggsou6HTRUW8+Un8M/g1OFaCnWNHBXjlE9WbXWiJhnshXMUj28DFsPlpti/WA
         waWYZx8+eFi4KtZYRrp1R5PM0wFN8aqiDaV9U=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 05/33] Staging: crystalhd: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:25 -0400
Message-Id: <1286496113-11897-5-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/crystalhd/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/crystalhd/Makefile b/drivers/staging/crystalhd/Makefile
index e2af0ce..c31657a 100644
--- a/drivers/staging/crystalhd/Makefile
+++ b/drivers/staging/crystalhd/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_CRYSTALHD)	+= crystalhd.o
 
-crystalhd-objs		:= crystalhd_cmds.o	\
+crystalhd-y		:= crystalhd_cmds.o	\
 			   crystalhd_hw.o	\
 			   crystalhd_lnx.o	\
 			   crystalhd_misc.o
-- 
1.7.3.1.50.g1e633

