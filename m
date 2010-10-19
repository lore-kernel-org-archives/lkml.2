Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0JSPyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:54:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0JSPya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:54:30 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=mLPS_VH-7X8A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=NW928xBcoRxyB8_P8tMA:9 a=hiwZ2u9Oc3RwgfErI-QA:7 a=LbU9yJ5LHqgIFNFrn3QehzkOu08A:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Tue, 19 Oct 2010 10:54:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] linux-firmware: Add firmware file for r8712u (RTL8192SU)
Message-ID: <4cbdbf3b.Ek+PDAiA1jX27HRq%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e08609526c289eb678578b5c01cd007574939a48 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 18 Oct 2010 08:55:36 -0500
Subject: [PATCH] Add firmware for Realtek RTL8192SU, aka rtl8712u, to linux-firmware.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

David,

Despite the indication below, this patch file does not actually contain the firmware.
I have sent it this way to avoid spamming mailboxes with the 122 KB binary file, yet
have the revised text of WHENCE available for reviewing.

To obtain everything, please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/r8712u_firmware.git

Larry
---

 WHENCE       |   27 +++++++++++++++++++++++++++
 rtl8712u.bin |  Bin 0 -> 122328 bytes
 2 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 rtl8712u.bin

diff --git a/WHENCE b/WHENCE
index 01a1262..7d362fc 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1401,3 +1401,30 @@ File: bcm4329-fullmac-4-218-248-5.bin
 File: bcm4329-fullmac-4-218-248-5.txt
 
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
+
+--------------------------------------------------------------------------
+
+Driver: r8712u - Reaktek 802.11n wireless LAN driver
+
+File: rtl8712u.bin
+
+Licence:
+
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ * Linux device driver for RTL8192SU
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+
+The firmware is included as hex in the original source.
+

