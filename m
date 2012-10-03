Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2JCJEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:04:36 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34497 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab2JCJEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:04:34 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH] MAINTAINERS: Add EFI maintainer entry
Date: Wed,  3 Oct 2012 10:04:02 +0100
Message-Id: <1349255042-20971-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

We're starting to need a channel through which we can funnel EFI
patches to make sure they get merged in a timely fashion. Matthew and
Peter seem happy enough for me to take that bullet.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Len Brown <len.brown@intel.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8c22b7f..a2a2756 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2632,6 +2632,18 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
 S:	Maintained
 F:	sound/usb/misc/ua101.c
 
+EXTENSIBLE FIRMWARE INTERFACE (EFI)
+M:	Matt Fleming <matt.fleming@intel.com>
+L:	linux-efi@vger.kernel.org
+S:	Maintained
+F:	Documentation/x86/efi-stub.txt
+F:	arch/ia64/kernel/efi.c
+F:	arch/x86/boot/compressed/eboot.[ch]
+F:	arch/x86/include/asm/efi.h
+F:	arch/x86/platform/efi/*
+F:	drivers/firmware/efivars.c
+F:	include/linux/efi*.h
+
 EFIFB FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 M:	Peter Jones <pjones@redhat.com>
-- 
1.7.11.4

