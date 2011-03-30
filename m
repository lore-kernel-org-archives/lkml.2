Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab1C3VFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:05:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:9182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933031Ab1C3VFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411276530"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: jens.taprogge@taprogge.org, jerone.young@canonical.com, hmh@hmh.eng.br,
        mjg@redhat.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [4/275] thinkpad-acpi: Add KEY_CAMERA (Fn-F6) for Lenovo keyboards
Message-Id: <20110330210357.E16D93E1A06@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:03:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jens Taprogge <jens.taprogge@taprogge.org>

[ upstream commit 2b75426282a8eb29d0a004ef0d289b0491c719be ]

On the T410s and most likely other current models, Fn-F6 is labeled as
Camera/Headphone key.  Report key presses as KEY_CAMERA.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Acked-by: Jerone Young <jerone.young@canonical.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/platform/x86/thinkpad_acpi.c
===================================================================
--- linux-2.6.35.y.orig/drivers/platform/x86/thinkpad_acpi.c	2011-03-29 23:02:58.181346706 -0700
+++ linux-2.6.35.y/drivers/platform/x86/thinkpad_acpi.c	2011-03-29 23:55:36.863523932 -0700
@@ -3173,7 +3173,7 @@
 	[TPACPI_KEYMAP_LENOVO_GENERIC] = {
 		/* Scan Codes 0x00 to 0x0B: ACPI HKEY FN+F1..F12 */
 		KEY_FN_F1,	KEY_COFFEE,	KEY_BATTERY,	KEY_SLEEP,
-		KEY_WLAN,	KEY_FN_F6, KEY_SWITCHVIDEOMODE, KEY_FN_F8,
+		KEY_WLAN,	KEY_CAMERA, KEY_SWITCHVIDEOMODE, KEY_FN_F8,
 		KEY_FN_F9,	KEY_FN_F10,	KEY_FN_F11,	KEY_SUSPEND,
 
 		/* Scan codes 0x0C to 0x1F: Other ACPI HKEY hot keys */
