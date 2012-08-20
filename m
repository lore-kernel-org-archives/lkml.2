Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2HTUUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:20:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab2HTUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:20:04 -0400
Date: Mon, 20 Aug 2012 13:19:47 -0700
From: tip-bot for Paul Bolle <pebolle@tiscali.nl>
Message-ID: <tip-0570a365a6b8ccbfe7baa459de2b7396ddf2de90@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1345396003.1771.9.camel@x61.thuisdomein>
References: <1345396003.1771.9.camel@x61.thuisdomein>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, boot:
  Remove obsolete and unused constant RAMDISK
Git-Commit-ID: 0570a365a6b8ccbfe7baa459de2b7396ddf2de90
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Aug 2012 13:19:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0570a365a6b8ccbfe7baa459de2b7396ddf2de90
Gitweb:     http://git.kernel.org/tip/0570a365a6b8ccbfe7baa459de2b7396ddf2de90
Author:     Paul Bolle <pebolle@tiscali.nl>
AuthorDate: Sun, 19 Aug 2012 19:06:43 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 20 Aug 2012 11:34:48 -0700

x86, boot: Remove obsolete and unused constant RAMDISK

The named constant RAMDISK is unused. It used to set the (obsolete)
kernel boot header field ram_size, but its usage for that purpose got
dropped in commit 5e47c478b0b69bc9bc3ba544e4b1ca3268f98fef ("x86: remove
zImage support"). Now remove this constant too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Link: http://lkml.kernel.org/r/1345396003.1771.9.camel@x61.thuisdomein
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
