Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0JHAEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:04:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0JHACh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PYd4TL5tF+RcTe0143cI27JSnp1eSBKtqUWoWZksF2g4rO1OeMUNx6gjZrecEPc/fU
         bO5ccusBdwd6loBtX0ktNu4/TsMWOuNQ04y1gut9yM4vkF3zqnKIqHuom1m+IeVEz7TJ
         ww7Nd0VRqzeZtBYLRiKjfsXJxRQAJfP4NRkAs=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 19/33] Staging: rt2870: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:39 -0400
Message-Id: <1286496113-11897-19-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rt2870/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2870/Makefile b/drivers/staging/rt2870/Makefile
index 7b29493..b499910 100644
--- a/drivers/staging/rt2870/Makefile
+++ b/drivers/staging/rt2870/Makefile
@@ -7,7 +7,7 @@ ccflags-y += -DRTMP_MAC_USB -DRTMP_USB_SUPPORT -DRT2870 -DRTMP_TIMER_TASK_SUPPOR
 ccflags-y += -DRTMP_RF_RW_SUPPORT -DRTMP_EFUSE_SUPPORT -DRT30xx -DRT3070
 ccflags-y += -DDBG
 
-rt2870sta-objs :=		\
+rt2870sta-y :=		\
 	common/crypt_md5.o	\
 	common/crypt_sha2.o	\
 	common/crypt_hmac.o	\
-- 
1.7.3.1.50.g1e633

