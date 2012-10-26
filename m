Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab2JZLQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:16:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab2JZLQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:16:43 -0400
Date: Fri, 26 Oct 2012 04:16:30 -0700
From: tip-bot for Kees Cook <keescook@chromium.org>
Message-ID: <tip-c6039f4a00901259517b7c027007697105209968@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, rob@landley.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, rob@landley.net
In-Reply-To: <20121026031702.GA23828@www.outflux.net>
References: <20121026031702.GA23828@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86/boot/doc: Fix grammar and typo in boot.txt
Git-Commit-ID: c6039f4a00901259517b7c027007697105209968
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 04:16:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6039f4a00901259517b7c027007697105209968
Gitweb:     http://git.kernel.org/tip/c6039f4a00901259517b7c027007697105209968
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 25 Oct 2012 20:17:02 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 26 Oct 2012 12:18:38 +0200

x86/boot/doc: Fix grammar and typo in boot.txt

Fixes some minor issues in the x86 boot documentation.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rob Landley <rob@landley.net>
Link: http://lkml.kernel.org/r/20121026031702.GA23828@www.outflux.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/x86/boot.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
