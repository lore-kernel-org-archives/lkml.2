Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0L3XIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 18:08:07 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64019 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0L3XIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:08:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Voss64lOxYFG73f2PnnBpEW6i2LvV5y5FLwSTufahThlz66ReTrQSW4dKqxwQL41+A
         tRHrw0sXzvSOcBNd9vJPW5DYI/WYT0CgCmZBkZy1bRrBcaVVE9fl32VHpSm2F83zaUQt
         rcrgj28Y/E2xcMFsqdHSpJMRIIRYkceqinPEs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 01/15]arch:m68k:ifpsp060:src:fpsp.S Typo change diable to disable.
Date: Thu, 30 Dec 2010 15:07:50 -0800
Message-Id: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo "diable" to "disable". Please let me know if this 
is correct or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/m68k/ifpsp060/src/fpsp.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/ifpsp060/src/fpsp.S b/arch/m68k/ifpsp060/src/fpsp.S
index 73613b5..26e85e2 100644
--- a/arch/m68k/ifpsp060/src/fpsp.S
+++ b/arch/m68k/ifpsp060/src/fpsp.S
@@ -3881,7 +3881,7 @@ _fpsp_fline:
 # FP Unimplemented Instruction stack frame and jump to that entry
 # point.
 #
-# but, if the FPU is disabled, then we need to jump to the FPU diabled
+# but, if the FPU is disabled, then we need to jump to the FPU disabled
 # entry point.
 	movc		%pcr,%d0
 	btst		&0x1,%d0
-- 
1.6.5.2.180.gc5b3e

