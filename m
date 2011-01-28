Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1A1TuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:50:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54934 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1A1TuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:50:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wiVbS626MyoxH+EJFSUSgrD/M1qX9eXu9UmXcQZvnRjKW8UcRhP2jy49uMREdKSAUj
         7VoSoz68HoWS8Vr/i1PCWT0P1SGyWplXhfQgWJp8cYDwwyNVygCQx4o716Qh44uwCQRu
         fEivlPHemPH25ObovERYcnU50Rm31fM+eKujk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:wireless:acx.h change initate to initiate
Date: Fri, 28 Jan 2011 11:50:04 -0800
Message-Id: <1296244204-3890-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is a typo or not. if it is then feel free to take this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/wl12xx/acx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 7bd8e4d..c56088b 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -987,7 +987,7 @@ struct wl1271_acx_ht_capabilities {
 	 *         Note, driver will still leave space for HT control in packets
 	 *         regardless of the value of this field. FW will be responsible
 	 *         to drop the HT field from any frame when this Bit set to 0.
-	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
+	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initiate RD.
 	 *         Exact policy setting for this feature is TBD.
 	 *         Note, this bit can only be set to 1 if bit 3 is set to 1.
 	 */
-- 
1.6.5.GIT

