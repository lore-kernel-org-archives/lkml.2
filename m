Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0CUAOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 20:14:06 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42226 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab0CUAOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 20:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=o5EiSsUnVl9dtvFSlngxopwNl6m3p3ueTq4S+20rjTBJgPKpIuGgQ7ozUOsEXk4UOf
         ugXrbfMsv0nXqYgn0UQUPzlBtaQeF2ad6MVqeepJlZBO6OgN3VNAU4hl2ZmBH5/6Cgzp
         k+7OEIbHW/auOl0ojb3/rayGhpNfzQTlfy23Y=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v3] x86: remove rdc321x_defs.h
Date: Sun, 21 Mar 2010 01:13:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-2-686; KDE/4.3.4; i686; ; )
Cc: sameo@linux.intel.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
References: <201003210106.18169.florian@openwrt.org>
In-Reply-To: <201003210106.18169.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003210113.59099.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch got inlined and attached, corrected version below.
---
From: Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 4/4 v3] x86: remove rdc321x_defs.h

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



