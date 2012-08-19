Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2HSRGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:06:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36143 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2HSRGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:06:47 -0400
Message-ID: <1345396003.1771.9.camel@x61.thuisdomein>
Subject: [PATCH] x86, boot: remove RAMDISK
From: Paul Bolle <pebolle@tiscali.nl>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Aug 2012 19:06:43 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16)
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The named constant RAMDISK is unused. It used to set the (obsolete)
kernel boot header field ram_size, but its usage for that purpose got
dropped in commit 5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef ("x86: remove
zImage support"). Now remove this constant too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/x86/boot/header.S |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index b4e15dd..2a01744 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -32,10 +32,6 @@ SYSSEG		= 0x1000		/* historical load address >> 4 */
 #define SVGA_MODE ASK_VGA
 #endif
 
-#ifndef RAMDISK
-#define RAMDISK 0
-#endif
-
 #ifndef ROOT_RDONLY
 #define ROOT_RDONLY 1
 #endif
-- 
1.7.7.6

