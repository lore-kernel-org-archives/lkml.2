Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab0EMUFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:05:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33794 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0EMUF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:05:27 -0400
From: "Arce, Abraham" <x0066660@ti.com>
To: "trivial@kernel.org" <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "khali@linux-fr.org" <khali@linux-fr.org>,
       "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
       "gregkh@suse.de" <gregkh@suse.de>
Date: Thu, 13 May 2010 15:05:02 -0500
Subject: [PATCH v2 2/3] EEPROM: 93cx6: Header file cleanup
Thread-Topic: [PATCH v2 2/3] EEPROM: 93cx6: Header file cleanup
Thread-Index: Acry15LHueiddpNHQ6uud2VESmhfFQ==
Message-ID: <27F9C60D11D683428E133F85D2BB4A53043E113B61@dlee03.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change eeprom_93cx6.c header file to format as in conventions

Signed-off-by: Abraham Arce <x0066660@ti.com>
---
 drivers/misc/eeprom/eeprom_93cx6.c |   39 ++++++++++++++---------------------
 1 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/misc/eeprom/eeprom_93cx6.c b/drivers/misc/eeprom/eeprom_93cx6.c
index 15b1780..7b33de9 100644
--- a/drivers/misc/eeprom/eeprom_93cx6.c
+++ b/drivers/misc/eeprom/eeprom_93cx6.c
@@ -1,27 +1,20 @@
 /*
-	Copyright (C) 2004 - 2006 rt2x00 SourceForge Project
-	<http://rt2x00.serialmonkey.com>
-
-	This program is free software; you can redistribute it and/or modify
-	it under the terms of the GNU General Public License as published by
-	the Free Software Foundation; either version 2 of the License, or
-	(at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty of
-	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-	GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-/*
-	Module: eeprom_93cx6
-	Abstract: EEPROM reader routines for 93cx6 chipsets.
-	Supported chipsets: 93c46 & 93c66.
+ * Copyright (C) 2004 - 2006 rt2x00 SourceForge Project
+ * <http://rt2x00.serialmonkey.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * Module: eeprom_93cx6
+ * Abstract: EEPROM reader routines for 93cx6 chipsets.
+ * Supported chipsets: 93c46 & 93c66.
  */
 
 #include <linux/kernel.h>
-- 
1.5.4.3

