Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1FXGXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 02:23:14 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38042 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1FXGW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 02:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mljbwCcKm9B7OPmsohv2hx4fLIMoNA4oxeV4VDUW98dR9Vlm5S7smO27zdMTNZ+FkW
         RgUXoQ2y8M6aVCJ32nMYxfNN3v9H1tlhnGMwZQyTqzOKo/TbGxW1oTMH6ar41cRCdn0U
         F1GyfWkN06JHl1OnGc4e6Vfgc890HER0ykcHc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/3]Remove one to many lll's in some comments.
Date: Thu, 23 Jun 2011 23:22:29 -0700
Message-Id: <1308896549-4560-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308896549-4560-1-git-send-email-justinmattock@gmail.com>
References: <1308896549-4560-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below fixes some comments.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/acpi/acpica/hwxface.c  |    2 +-
 drivers/parport/parport_mfc3.c |    2 +-
 include/net/mac80211.h         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index f75f81a..f34ba22 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -355,7 +355,7 @@ ACPI_EXPORT_SYMBOL(acpi_read_bit_register)
  *
  * PARAMETERS:  register_id     - ID of ACPI Bit Register to access
  *              Value           - Value to write to the register, in bit
- *                                position zero. The bit is automaticallly
+ *                                position zero. The bit is automatically
  *                                shifted to the correct position.
  *
  * RETURN:      Status
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 362db31..1c0c642 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -397,7 +397,7 @@ static void __exit parport_mfc3_exit(void)
 
 
 MODULE_AUTHOR("Joerg Dorchain <joerg@dorchain.net>");
-MODULE_DESCRIPTION("Parport Driver for Multiface 3 expansion cards Paralllel Port");
+MODULE_DESCRIPTION("Parport Driver for Multiface 3 expansion cards Parallel Port");
 MODULE_SUPPORTED_DEVICE("Multiface 3 Parallel Port");
 MODULE_LICENSE("GPL");
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e6d6a66..7486e4d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1390,7 +1390,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * DOC: Beacon filter support
  *
  * Some hardware have beacon filter support to reduce host cpu wakeups
- * which will reduce system power consumption. It usuallly works so that
+ * which will reduce system power consumption. It usually works so that
  * the firmware creates a checksum of the beacon but omits all constantly
  * changing elements (TSF, TIM etc). Whenever the checksum changes the
  * beacon is forwarded to the host, otherwise it will be just dropped. That
-- 
1.7.5.4

