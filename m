Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657Ab2FDOrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:47:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65401 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab2FDOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:47:00 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dhowells@redhat.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]staging: "sbe-2t3e3" Fix typos in sbe-2t3e3
Date: Mon,  4 Jun 2012 07:46:52 -0700
Message-Id: <1338821212-2206-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes some typos found while reading through sbe-2t3e3.

 drivers/staging/sbe-2t3e3/dc.c |    2 +-
 drivers/staging/sbe-2t3e3/io.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/dc.c b/drivers/staging/sbe-2t3e3/dc.c
index 9dc4ec2..e897a43 100644
--- a/drivers/staging/sbe-2t3e3/dc.c
+++ b/drivers/staging/sbe-2t3e3/dc.c
@@ -81,7 +81,7 @@ void dc_init(struct channel *sc)
 		SBE_2T3E3_21143_VAL_NUMBER_OF_RECEIVE_PACKETS;
 	dc_write(sc->addr, SBE_2T3E3_21143_REG_GENERAL_PURPOSE_TIMER_AND_INTERRUPT_MITIGATION_CONTROL, val);
 
-	/* prepare descriptors and data for receive and transmit procecsses */
+	/* prepare descriptors and data for receive and transmit processes */
 	if (dc_init_descriptor_list(sc) != 0)
 		return;
 
diff --git a/drivers/staging/sbe-2t3e3/io.c b/drivers/staging/sbe-2t3e3/io.c
index 9a50bcc..d2391cb 100644
--- a/drivers/staging/sbe-2t3e3/io.c
+++ b/drivers/staging/sbe-2t3e3/io.c
@@ -17,7 +17,7 @@
 /* All access to registers done via the 21143 on port 0 must be
  * protected via the card->bootrom_lock. */
 
-/* priviate define to be used here only - must be protected by card->bootrom_lock */
+/* private define to be used here only - must be protected by card->bootrom_lock */
 #define cpld_write_nolock(channel, reg, val)			\
 	bootrom_write((channel), CPLD_MAP_REG(reg, channel), val)
 
-- 
1.7.5.4

