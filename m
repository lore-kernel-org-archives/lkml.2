Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2IQPUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:20:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44476 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2IQPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:20:47 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: pe1dnn@amsat.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]staging: "wlags49_h25" Fix typos.
Date: Mon, 17 Sep 2012 08:20:24 -0700
Message-Id: <1347895224-7607-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes typos found while reading through staging "wlags49_h25"

 drivers/staging/wlags49_h25/Kconfig |    2 +-
 drivers/staging/wlags49_h25/TODO    |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlags49_h25/Kconfig b/drivers/staging/wlags49_h25/Kconfig
index bf5664a..dd8dc4d 100644
--- a/drivers/staging/wlags49_h25/Kconfig
+++ b/drivers/staging/wlags49_h25/Kconfig
@@ -8,4 +8,4 @@ config WLAGS49_H25
 	Driver for wireless cards using Agere's HERMES II.5 chipset
 	which are identified with Manufacture ID: 0156,0004
 	The software is a modified version of wl_lkm_722_abg.tar.gz
-	from the Agere Systems website, addapted for Ubuntu 9.04.
+	from the Agere Systems website, adapted for Ubuntu 9.04.
diff --git a/drivers/staging/wlags49_h25/TODO b/drivers/staging/wlags49_h25/TODO
index 94032b6..ec71ad3 100644
--- a/drivers/staging/wlags49_h25/TODO
+++ b/drivers/staging/wlags49_h25/TODO
@@ -1,4 +1,4 @@
-First of all, the best thing would be that this driver becomes obsolte by
+First of all, the best thing would be that this driver becomes obsolete by
 adding support for Hermes II and Hermes II.5 cards to the existing orinoco
 driver. The orinoco driver currently only supports Hermes I based cards.
 Since this will not happen by magic and has not happened until now this
@@ -10,11 +10,11 @@ list.
 
 TODO:
 	- verify against a Hermes II.5 card
-	- verify with WPA encription (both with H2 and H2.5 cards)
+	- verify with WPA encryption (both with H2 and H2.5 cards)
 	- sometimes the card does not initialize correctly, retry mechanisms
 	  are build in to catch most cases but not all
 	- once the driver runs it is very stable, but I have the impression
-	  some the crittical sections take to long
+	  some the critical sections take to long
 	- the driver is split into a Hermes II and a Hermes II.5 part, it
 	  would be nice to handle both with one module instead of two
 	- review by the wireless developer community
@@ -25,7 +25,7 @@ TODO:
 DONE:
 	- verified against a Hermes II card (Thomson Speedtouch 110 PCMCIA
 	  card)
-	- verified with WEP encription
+	- verified with WEP encryption
 
 Please send any patches or complaints about this driver to Greg
 Kroah-Hartman <greg@kroah.com> and Cc: Henk de Groot <pe1dnn@amsat.org>
-- 
1.7.9.5

