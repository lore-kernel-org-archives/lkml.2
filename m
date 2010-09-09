Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0IIW0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:26:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab0IIW0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hsPhdhjm7cEEQDgu6VCEPSYpmNzC3jMO8I0MjzkZpQmHT8uiZLI7TTHbxXIVpK92/c
         lYKn/t0haUMCiTFKfBK26erDXC06FmTTMlcpddaMr9y7ielXmcvMbDHLY4rfBtHjB/zL
         g5JrzamkUV1fy4bT12Vp//xAYWMnF5N1XAkCw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 037/223]drivers/input/misc/cm109.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:26:37 -0700
Message-Id: <1284071205-7756-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/input/misc/cm109.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 2b0eba6..9007600 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -230,7 +230,7 @@ static unsigned short keymap_gtalk(int scancode)
 
 /*
  * Keymap for Allied-Telesis Corega USBPH01
- * http://www.alliedtelesis-corega.com/2/1344/1437/1360/chprd.html
+ * http://web.archive.org/web/*/http://www.alliedtelesis-corega.com/2/1344/1437/1360/chprd.html 
  *
  * Contributed by july@nat.bg
  */
@@ -259,8 +259,8 @@ static unsigned short keymap_usbph01(int scancode)
 
 /*
  * Keymap for ATCom AU-100
- * http://www.atcom.cn/En_products_AU100.html
- * http://www.packetizer.com/products/au100/
+ * http://www.atcom.cn/products.html 
+ * http://web.archive.org/web/*/http://www.packetizer.com/products/au100/ 
  * http://www.voip-info.org/wiki/view/AU-100
  *
  * Contributed by daniel@gimpelevich.san-francisco.ca.us
-- 
1.7.2.1

