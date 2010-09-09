Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab0IIWce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:32:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61959 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab0IIWcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Hrc153PWB9sm0PVSTu++8M2aUGnaAMAExwAAaTZ3s1igSVuZUNWoxQSRIVcuutFbyg
         922HyeVbdNAuZP9RGpbyB7D+JSeoHg9Dide3U1ALJ6nUeu8mkL7OgJuCOFLse7RW2tv+
         2RM884V2ra9c0CT9A6fjqPCbOC8YXvJS+6bsc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 097/223]drivers/net/wireless/prism54/islpci_hotplug.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:32:40 -0700
Message-Id: <1284071562-7948-7-git-send-email-justinmattock@gmail.com>
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
 drivers/net/wireless/prism54/islpci_hotplug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/prism54/islpci_hotplug.c b/drivers/net/wireless/prism54/islpci_hotplug.c
index dc14420..b5e64d7 100644
--- a/drivers/net/wireless/prism54/islpci_hotplug.c
+++ b/drivers/net/wireless/prism54/islpci_hotplug.c
@@ -38,7 +38,7 @@ module_param(init_pcitm, int, 0);
 /* In this order: vendor, device, subvendor, subdevice, class, class_mask,
  * driver_data
  * If you have an update for this please contact prism54-devel@prism54.org
- * The latest list can be found at http://prism54.org/supported_cards.php */
+ * The latest list can be found at http://wireless.kernel.org/en/users/Drivers/p54 */
 static DEFINE_PCI_DEVICE_TABLE(prism54_id_tbl) = {
 	/* Intersil PRISM Duette/Prism GT Wireless LAN adapter */
 	{
-- 
1.7.2.1

