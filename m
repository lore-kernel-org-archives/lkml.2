Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0KPGLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:11:54 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53147 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab0KPGLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:11:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=MLqmB7ijHSrPavlUA4EuZirekxIc2HIv3Je4qA6BWEsqRHW8CIhRtGfebw7jyp2Mak
         ZZRRE6eX5GolMbWnuTi+N1AstrpGqemySItFGUOEner5PlFotIF+WgViRTH0uS2ut2/G
         0E8IGXuHNPuIFXSLOrsXhoV7YNdpbj3nussic=
From: Al Cho <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw, jlee@novell.com, acho@novell.com,
        segooon@gmail.com
Subject: [PATCH 2/3] staging/keucr: fix keucr common code style
Date: Tue, 16 Nov 2010 14:12:47 +0800
Message-Id: <1289887967-2924-1-git-send-email-acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix keucr common code style

Signed-off-by: Al Cho <acho@novell.com>
---
 drivers/staging/keucr/common.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/keucr/common.h b/drivers/staging/keucr/common.h
index 8693c54..f2be045 100644
--- a/drivers/staging/keucr/common.h
+++ b/drivers/staging/keucr/common.h
@@ -1,7 +1,6 @@
 #ifndef COMMON_INCD
 #define COMMON_INCD
 
-typedef void VOID;
 typedef u8 BOOLEAN;
 typedef u8 BYTE;
 typedef u8 *PBYTE;
-- 
1.7.1

