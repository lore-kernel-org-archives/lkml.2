Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab2J2RkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:40:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33365 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab2J2RkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:40:05 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH 3/3] MAINTAINERS: Change Boris' email address
Date: Mon, 29 Oct 2012 18:40:10 +0100
Message-Id: <1351532410-4887-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351532410-4887-1-git-send-email-bp@alien8.de>
References: <1351532410-4887-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move to private mail address.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 MAINTAINERS | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1fa907441f8f..e775b8749205 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2707,10 +2707,10 @@ F:	include/linux/edac.h
 
 EDAC-AMD64
 M:	Doug Thompson <dougthompson@xmission.com>
-M:	Borislav Petkov <borislav.petkov@amd.com>
+M:	Borislav Petkov <bp@alien8.de>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
-S:	Supported
+S:	Maintained
 F:	drivers/edac/amd64_edac*
 
 EDAC-E752X
@@ -3703,7 +3703,7 @@ S:	Maintained
 F:	drivers/platform/x86/ideapad-laptop.c
 
 IDE/ATAPI DRIVERS
-M:	Borislav Petkov <petkovbb@gmail.com>
+M:	Borislav Petkov <bp@alien8.de>
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 F:	Documentation/cdrom/ide-cd
@@ -8147,7 +8147,7 @@ F:	drivers/platform/x86
 
 X86 MCE INFRASTRUCTURE
 M:	Tony Luck <tony.luck@intel.com>
-M:	Borislav Petkov <bp@amd64.org>
+M:	Borislav Petkov <bp@alien8.de>
 L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	arch/x86/kernel/cpu/mcheck/*
-- 
1.8.0

