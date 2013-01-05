Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab3AEONy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 09:13:54 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54313 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab3AEONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 09:13:51 -0500
From: Lijo Antony <lijo.kernel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Lijo Antony <lijo.kernel@gmail.com>
Subject: [PATCH 1/2] Staging: comedi: addi_common.c: checkpatch.pl fixes
Date: Sat,  5 Jan 2013 18:12:54 +0400
Message-Id: <1357395175-6077-1-git-send-email-lijo.kernel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl style fixes:
- Broken license text into 80 char lines
- fixed two space before tab issues
- Removed unnecessary braces from if-else

Signed-off-by: Lijo Antony <lijo.kernel@gmail.com>
---
 .../staging/comedi/drivers/addi-data/addi_common.c |   26 +++++++++++++-------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 90cc432..1051fa5 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -11,13 +11,21 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	http://www.addi-data.com
 	info@addi-data.com
 
-This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
+This program is free software; you can redistribute it and/or modify it under
+the terms of the GNU General Public License as published by the Free Software
+Foundation; either version 2 of the License, or (at your option) any later
+version.
 
-This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
+This program is distributed in the hope that it will be useful, but WITHOUT ANY
+WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
+PARTICULAR PURPOSE. See the GNU General Public License for more details.
 
-You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+You should have received a copy of the GNU General Public License along with
+this program; if not, write to the Free Software Foundation, Inc.,
+59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
-You should also find the complete GPL in the COPYING file accompanying this source code.
+You should also find the complete GPL in the COPYING file accompanying this
+source code.
 
 @endverbatim
 */
@@ -29,10 +37,10 @@ You should also find the complete GPL in the COPYING file accompanying this sour
   | Tel : +49 (0) 7223/9493-0     | email    : info@addi-data.com         |
   | Fax : +49 (0) 7223/9493-92    | Internet : http://www.addi-data.com   |
   +-----------------------------------------------------------------------+
-  | Project   : ADDI DATA         | Compiler : GCC 		          |
+  | Project   : ADDI DATA         | Compiler : GCC                        |
   | Modulname : addi_common.c     | Version  : 2.96                       |
   +-------------------------------+---------------------------------------+
-  | Author    :           | Date     :                    		  |
+  | Author    :           | Date     :                                    |
   +-----------------------------------------------------------------------+
   | Description : ADDI COMMON Main Module                                 |
   +-----------------------------------------------------------------------+
@@ -167,11 +175,11 @@ static int addi_auto_attach(struct comedi_device *dev,
 	if (this_board->i_PCIEeprom) {
 		if (!(strcmp(this_board->pc_EepromChip, "S5920"))) {
 			/*  Set 3 wait stait */
-			if (!(strcmp(dev->board_name, "apci035"))) {
+			if (!(strcmp(dev->board_name, "apci035")))
 				outl(0x80808082, devpriv->i_IobaseAmcc + 0x60);
-			} else {
+			else
 				outl(0x83838383, devpriv->i_IobaseAmcc + 0x60);
-			}
+
 			/*  Enable the interrupt for the controller */
 			dw_Dummy = inl(devpriv->i_IobaseAmcc + 0x38);
 			outl(dw_Dummy | 0x2000, devpriv->i_IobaseAmcc + 0x38);
-- 
1.7.10.4

