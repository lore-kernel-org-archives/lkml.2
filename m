Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab0IIWd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:33:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61959 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab0IIWc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:32:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M93m7rIyi/rAwdfDgZUIrGC6qmc7TSxZPv15hbnKYZboLAPE3fvBKafasVin17txfQ
         eeH3uVoACNiIkYOF7ldmJ3dLM10BbrlOTezNsYNXB/d7kiEw2bqpHzwwxTOwlOBPiSUb
         mu/AJbXFoSsw2IfbfQnlg0VrhpSGGKg/inlgw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 096/223]drivers/net/wireless/hostap/hostap_cs.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:32:39 -0700
Message-Id: <1284071562-7948-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071562-7948-1-git-send-email-justinmattock@gmail.com>
References: <1284071562-7948-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/hostap/hostap_cs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index ba54d1b..813518a 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -214,8 +214,7 @@ static int prism2_pccard_card_present(local_info_t *local)
 
 /*
  * SanDisk CompactFlash WLAN Flashcard - Product Manual v1.0
- * Document No. 20-10-00058, January 2004
- * http://www.sandisk.com/pdf/industrial/ProdManualCFWLANv1.0.pdf
+ * http://www.sandisk.com
  */
 #define SANDISK_WLAN_ACTIVATION_OFF 0x40
 #define SANDISK_HCR_OFF 0x42
-- 
1.7.2.1

