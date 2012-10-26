Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2JZDSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:18:33 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39188 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab2JZDSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:18:31 -0400
Date: Thu, 25 Oct 2012 20:17:02 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH] x86, doc: fix grammar and typo in boot.txt
Message-ID: <20121026031702.GA23828@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes some minor issues in the x86 boot documentation.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/x86/boot.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9efceff..f15cb74 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -1013,7 +1013,7 @@ boot_params as that of 16-bit boot protocol, the boot loader should
 also fill the additional fields of the struct boot_params as that
 described in zero-page.txt.
 
-After setupping the struct boot_params, the boot loader can load the
+After setting up the struct boot_params, the boot loader can load the
 32/64-bit kernel in the same way as that of 16-bit boot protocol.
 
 In 32-bit boot protocol, the kernel is started by jumping to the
@@ -1023,7 +1023,7 @@ In 32-bit boot protocol, the kernel is started by jumping to the
 At entry, the CPU must be in 32-bit protected mode with paging
 disabled; a GDT must be loaded with the descriptors for selectors
 __BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
-segment; __BOOS_CS must have execute/read permission, and __BOOT_DS
+segment; __BOOT_CS must have execute/read permission, and __BOOT_DS
 must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
 must be __BOOT_DS; interrupt must be disabled; %esi must hold the base
 address of the struct boot_params; %ebp, %edi and %ebx must be zero.
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
