Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0CUAG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 20:06:26 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52363 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0CUAGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 20:06:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length:to
         :reply-to:content-type:message-id;
        b=UnwLixwrwP91ssjXWZz18faJoWW7FYgoAwyYX3n7OOpOfjvsooAGiAhBNGrLT7HoMU
         K+SZBaCkmQxZgJ9PEy0rN9gHh4/aKlGkZkfvtVk+zkad2+FOas70ebow+4a38A7aIWHg
         gO+EC9Q1D9qgcaWqtOemojWn+dLFmYvvoqt2o=
From: Florian Fainelli <florian@openwrt.org>
Date: Sun, 21 Mar 2010 01:06:17 +0100
Subject: [PATCH 4/4 v3] x86: remove rdc321x_defs.h
MIME-Version: 1.0
X-TUID: 0be376bb144ead0b
X-Length: 1559
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Reply-To: Florian Fainelli <florian@openwrt.org>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6LWpL4rz4hEMbjZ"
Message-Id: <201003210106.18169.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--Boundary-00=_6LWpL4rz4hEMbjZ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

This file is replaced by a cleaner version with the adding of a MFD driver for
the southbridge.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/arch/x86/include/asm/rdc321x_defs.h b/arch/x86/include/asm/rdc321x_defs.h
deleted file mode 100644
index c8e9c8b..0000000
--- a/arch/x86/include/asm/rdc321x_defs.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#define PFX	"rdc321x: "
-
-/* General purpose configuration and data registers */
-#define RDC3210_CFGREG_ADDR     0x0CF8
-#define RDC3210_CFGREG_DATA     0x0CFC
-
-#define RDC321X_GPIO_CTRL_REG1	0x48
-#define RDC321X_GPIO_CTRL_REG2	0x84
-#define RDC321X_GPIO_DATA_REG1	0x4c
-#define RDC321X_GPIO_DATA_REG2	0x88
-
-#define RDC321X_MAX_GPIO	58

--Boundary-00=_6LWpL4rz4hEMbjZ
Content-Type: text/x-patch;
  name="d4af98bfffe3e385b7a8f903789fd680d3b967e2.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="d4af98bfffe3e385b7a8f903789fd680d3b967e2.diff"

diff --git a/arch/x86/include/asm/rdc321x_defs.h b/arch/x86/include/asm/rdc321x_defs.h
deleted file mode 100644
index c8e9c8b..0000000
--- a/arch/x86/include/asm/rdc321x_defs.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#define PFX	"rdc321x: "
-
-/* General purpose configuration and data registers */
-#define RDC3210_CFGREG_ADDR     0x0CF8
-#define RDC3210_CFGREG_DATA     0x0CFC
-
-#define RDC321X_GPIO_CTRL_REG1	0x48
-#define RDC321X_GPIO_CTRL_REG2	0x84
-#define RDC321X_GPIO_DATA_REG1	0x4c
-#define RDC321X_GPIO_DATA_REG2	0x88
-
-#define RDC321X_MAX_GPIO	58

--Boundary-00=_6LWpL4rz4hEMbjZ--


