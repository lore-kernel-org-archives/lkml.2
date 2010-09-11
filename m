Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0IKBpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 21:45:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43424 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0IKBpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 21:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eTTlyGQ3DOjfqdLgcZROiHIhzvJN19q+rydnrgC1KxXD54QTDxf8AgVkryBcLWLxm1
         wEcJLJnfz8DAEKIDgyfsyOLncU9VbzFXqI3afE73lb/wP0TfI0eVWrtqAtUa1C56y4Ce
         WOs7SyoPM88nRLauZ00X08WUIgV7CDhPDyHeU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]firmware/keyspan_pda/ Update brokwn web addresses.
Date: Fri, 10 Sep 2010 18:45:40 -0700
Message-Id: <1284169540-6225-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates the broken web addresses(but not really broken, just not there)
to the proper address.(from reading anchorchips is now cypress semiconductor).

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 firmware/keyspan_pda/keyspan_pda.S |    2 +-
 firmware/keyspan_pda/xircom_pgs.S  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/firmware/keyspan_pda/keyspan_pda.S b/firmware/keyspan_pda/keyspan_pda.S
index 418fe69..f3acc19 100644
--- a/firmware/keyspan_pda/keyspan_pda.S
+++ b/firmware/keyspan_pda/keyspan_pda.S
@@ -74,7 +74,7 @@
  *  recognizes the new device ID and glues it to the real serial driver code.
  *
  * USEFUL DOCS:
- *  EzUSB Technical Reference Manual: <http://www.anchorchips.com>
+ *  EzUSB Technical Reference Manual: <http://www.cypress.com/>
  *  8051 manuals: everywhere, but try www.dalsemi.com because the EzUSB is
  *   basically the Dallas enhanced 8051 code. Remember that the EzUSB IO ports
  *   use totally different registers!
diff --git a/firmware/keyspan_pda/xircom_pgs.S b/firmware/keyspan_pda/xircom_pgs.S
index 05d99dd..0b79bbf 100644
--- a/firmware/keyspan_pda/xircom_pgs.S
+++ b/firmware/keyspan_pda/xircom_pgs.S
@@ -74,7 +74,7 @@
  *  recognizes the new device ID and glues it to the real serial driver code.
  *
  * USEFUL DOCS:
- *  EzUSB Technical Reference Manual: <http://www.anchorchips.com>
+ *  EzUSB Technical Reference Manual: <http://www.cypress.com/>
  *  8051 manuals: everywhere, but try www.dalsemi.com because the EzUSB is
  *   basically the Dallas enhanced 8051 code. Remember that the EzUSB IO ports
  *   use totally different registers!
-- 
1.7.2.1

