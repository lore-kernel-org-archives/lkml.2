Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab0IIW3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:29:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48162 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab0IIW3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mzj52rn7FbzTMOYXK+Ra55GW5SOWQgxQEp9KTvVCQWm8qnoEt4NkSBn7IHv0x7wqKU
         bTCfiUGv1BnDKALtuITdistlLzD/2hbo312+hXLaEbfMXzkF3ciK9CSoqop8aB7+qzFC
         JTJBd9KYTghewgM9lz6o5TWaJaBav6hq5lT9w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 079/223]drivers/mtd/maps/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:29:23 -0700
Message-Id: <1284071374-7867-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
References: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/mtd/maps/Kconfig |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 701d942..5d32e20 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -172,7 +172,7 @@ config MTD_OCTAGON
 	  This provides a 'mapping' driver which supports the way in which
 	  the flash chips are connected in the Octagon-5066 Single Board
 	  Computer. More information on the board is available at
-	  <http://www.octagonsystems.com/CPUpages/5066.html>.
+	  <http://www.octagonsystems.com/products/5066.aspx>.
 
 config MTD_VMAX
 	tristate "JEDEC Flash device mapped on Tempustech VMAX SBC301"
@@ -256,8 +256,7 @@ config MTD_DILNETPC
 	depends on X86 && MTD_CONCAT && MTD_PARTITIONS && MTD_CFI_INTELEXT && BROKEN
 	help
 	  MTD map driver for SSV DIL/Net PC Boards "DNP" and "ADNP".
-	  For details, see <http://www.ssv-embedded.de/ssv/pc104/p169.htm>
- 	  and <http://www.ssv-embedded.de/ssv/pc104/p170.htm>
+	  For details, see <http://www.ssv-embedded.de/>
 
 config MTD_DILNETPC_BOOTSIZE
 	hex "Size of DIL/Net PC flash boot partition"
@@ -284,7 +283,7 @@ config MTD_TQM8XXL
 	  chips, currently uses AMD one. This 'mapping' driver supports
 	  that arrangement, allowing the CFI probe and command set driver
 	  code to communicate with the chips on the TQM8xxL board. More at
-	  <http://www.denx.de/embedded-ppc-en.html>.
+	  <http://www.denx.de/en/News/WebHome>.
 
 config MTD_RPXLITE
 	tristate "CFI Flash device mapped on RPX Lite or CLLF"
@@ -351,7 +350,7 @@ config MTD_DC21285
 	help
 	  This provides a driver for the flash accessed using Intel's
 	  21285 bridge used with Intel's StrongARM processors. More info at
-	  <http://www.intel.com/design/bridge/docs/21285_documentation.htm>.
+	  <http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=5719&lang=eng>.
 
 config MTD_IXP4XX
 	tristate "CFI Flash device mapped on Intel IXP4xx based systems"
@@ -532,9 +531,9 @@ config MTD_PISMO
 	depends on ARCH_VERSATILE
 	help
 	  This driver allows for discovery of PISMO modules - see
-	  <http://www.pismoworld.org/>.  These are small modules containing
-	  up to five memory devices (eg, SRAM, flash, DOC) described by an
-	  I2C EEPROM.
+	  <http://web.archive.org/web/*/http://www.pismoworld.org/>. 
+	  These are small modules containing up to five memory devices 
+	  (eg, SRAM, flash, DOC) described by an I2C EEPROM.
 
 	  This driver does not create any MTD maps itself; instead it
 	  creates MTD physmap and MTD SRAM platform devices.  If you
-- 
1.7.2.1

