Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0EKSI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:08:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38677 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890Ab0EKSIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:08:54 -0400
From: "Arce, Abraham" <x0066660@ti.com>
To: "trivial@kernel.org" <trivial@kernel.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 May 2010 13:08:15 -0500
Subject: [PATCH 1/3] EEPROM: Header file cleanup
Thread-Topic: [PATCH 1/3] EEPROM: Header file cleanup
Thread-Index: AcrxNO1ls+HaxtRLTlGc3M4OS4xLZg==
Message-ID: <27F9C60D11D683428E133F85D2BB4A53043DFD5808@dlee03.ent.ti.com>
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

Change eeprom.c header file to format as in conventions

Signed-off-by: Abraham Arce <x0066660@ti.com>
---
 drivers/misc/eeprom/eeprom.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
index f939ebc..fffa2e8 100644
--- a/drivers/misc/eeprom/eeprom.c
+++ b/drivers/misc/eeprom/eeprom.c
@@ -1,24 +1,24 @@
 /*
-    Copyright (C) 1998, 1999  Frodo Looijaard <frodol@dds.nl> and
-			       Philip Edelbrock <phil@netroedge.com>
-    Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
-    Copyright (C) 2003 IBM Corp.
-    Copyright (C) 2004 Jean Delvare <khali@linux-fr.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
+ * Copyright (C) 1998, 1999  Frodo Looijaard <frodol@dds.nl> and
+ *                           Philip Edelbrock <phil@netroedge.com>
+ * Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
+ * Copyright (C) 2003 IBM Corp.
+ * Copyright (C) 2004 Jean Delvare <khali@linux-fr.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-- 
1.5.4.3

