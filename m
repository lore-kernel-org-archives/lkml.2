Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab0DVT7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:59:25 -0400
Received: from kroah.org ([198.145.64.141]:40704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab0DVT2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:18 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:13 2010
Message-Id: <20100422190913.199792032@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Subject: [065/197] thinkpad-acpi: fix some version quirks
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 90765c6aee568137521ba19347c744b5abde8161 upstream.

Update some of the BIOS/EC version quirks.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1779,7 +1779,7 @@ static const struct tpacpi_quirk tpacpi_
 
 	TPV_QL1('7', '9',  'E', '3',  '5', '0'), /* T60/p */
 	TPV_QL1('7', 'C',  'D', '2',  '2', '2'), /* R60, R60i */
-	TPV_QL0('7', 'E',  'D', '0'),		 /* R60e, R60i */
+	TPV_QL1('7', 'E',  'D', '0',  '1', '5'), /* R60e, R60i */
 
 	/*      BIOS FW    BIOS VERS  EC FW     EC VERS */
 	TPV_QI2('1', 'W',  '9', '0',  '1', 'V', '2', '8'), /* R50e (1) */
@@ -1795,8 +1795,8 @@ static const struct tpacpi_quirk tpacpi_
 	TPV_QI1('7', '4',  '6', '4',  '2', '7'), /* X41 (0) */
 	TPV_QI1('7', '5',  '6', '0',  '2', '0'), /* X41t (0) */
 
-	TPV_QL0('7', 'B',  'D', '7'),		 /* X60/s */
-	TPV_QL0('7', 'J',  '3', '0'),		 /* X60t */
+	TPV_QL1('7', 'B',  'D', '7',  '4', '0'), /* X60/s */
+	TPV_QL1('7', 'J',  '3', '0',  '1', '3'), /* X60t */
 
 	/* (0) - older versions lack DMI EC fw string and functionality */
 	/* (1) - older versions known to lack functionality */


