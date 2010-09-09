Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab0IIWem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:34:42 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57142 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab0IIWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hTOBQHkbzJyTR3VtMqfZjREbpBkA1tMDX4I5PNg9fItv0A3b1JPZAcSRWSz7fwgPxy
         Q7BBrEwN4dSDt162wKAI3l1IeUT2tfrlOzEhG4VADvumTsICPNZuMu/t94u6V/CCyVsV
         drxQIoTcuruBtuCotRKdTpagzvEncpGQYjvAI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 100/223]drivers/net/wireless/ath/ath5k/reg.h Update broken web addresses.
Date: Thu,  9 Sep 2010 15:34:58 -0700
Message-Id: <1284071703-7996-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/ath/ath5k/reg.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 55b4ac6..e1f7fa8 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -23,10 +23,7 @@
  *
  * I tried to document those registers by looking at ar5k code, some
  * 802.11 (802.11e mostly) papers and by reading various public available
- * Atheros presentations and papers like these:
- *
- * 5210 - http://nova.stanford.edu/~bbaas/ps/isscc2002_slides.pdf
- *        http://www.it.iitb.ac.in/~janak/wifire/01222734.pdf
+ * Atheros presentations and papers:
  *
  * 5211 - http://www.hotchips.org/archives/hc14/3_Tue/16_mcfarland.pdf
  *
@@ -1047,8 +1044,7 @@
  *        check the eeprom status register
  *
  * For more infos check eeprom_* functs and the ar5k.c
- * file posted in madwifi-devel mailing list.
- * http://sourceforge.net/mailarchive/message.php?msg_id=8966525
+ * http://wireless.kernel.org/en/users/Drivers/ath5k 
  *
  */
 #define AR5K_EEPROM_BASE	0x6000
-- 
1.7.2.1

