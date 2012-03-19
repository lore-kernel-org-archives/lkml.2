Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162069Ab2CSQYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:24:43 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:54617 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab2CSQYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:24:41 -0400
Date: Mon, 19 Mar 2012 17:24:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/boot change for v3.4
Message-ID: <20120319162437.GA9289@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-boot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-boot-for-linus

   HEAD: 35f1790e6c6a7e4cae57b616cf36444d27fa6b28 x86, boot: Fix port argument to inl() function

 Thanks,

	Ingo

------------------>
He Chunhui (1):
      x86, boot: Fix port argument to inl() function


 arch/x86/boot/boot.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index c7093bd..18997e5 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -67,7 +67,7 @@ static inline void outl(u32 v, u16 port)
 {
 	asm volatile("outl %0,%1" : : "a" (v), "dN" (port));
 }
-static inline u32 inl(u32 port)
+static inline u32 inl(u16 port)
 {
 	u32 v;
 	asm volatile("inl %1,%0" : "=a" (v) : "dN" (port));
