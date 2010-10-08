Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0JHACb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45641 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab0JHAC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q7SqdPl1TQkciT7JVX29YSOi34Y3+NbNJwRPz4UU+TkuXBc1SmNGDLKOz0pABVEXb9
         GOMKRZH7t5sNoPCwc96iGQPigUAH3D7PQReoCf2jkjtooph+985lz1iIwh1gCffewTMO
         7woM5lOIV2j3m0/S3Xw+VlK5lI5ai1eHROOAY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 21/33] Staging: rtl8192u: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:41 -0400
Message-Id: <1286496113-11897-21-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192u/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192u/Makefile b/drivers/staging/rtl8192u/Makefile
index cba4344..206d924 100644
--- a/drivers/staging/rtl8192u/Makefile
+++ b/drivers/staging/rtl8192u/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -DUSE_ONE_PIPE
 ccflags-y += -DENABLE_DOT11D
 ccflags-y += -Idrivers/staging/rtl8192u/ieee80211
 
-r8192u_usb-objs := r8192U_core.o r8180_93cx6.o r8192U_wx.o		\
+r8192u_usb-y := r8192U_core.o r8180_93cx6.o r8192U_wx.o		\
 		  r8190_rtl8256.o r819xU_phy.o r819xU_firmware.o	\
 		  r819xU_cmdpkt.o r8192U_dm.o r819xU_firmware_img.o	\
 		  ieee80211/ieee80211_crypt.o				\
-- 
1.7.3.1.50.g1e633

