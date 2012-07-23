Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2GWXeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:34:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2GWXeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:34:12 -0400
Date: Mon, 23 Jul 2012 16:33:56 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-nq318h0okuaem8x9dpv9854k@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sebastian-plotz@web.de, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sebastian-plotz@web.de, tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, doc: Assign a bootloader ID for "
 Minimal Linux Bootloader"
Git-Commit-ID: c5e5c42a68be66cb87573e5c2fcce6f1b5d82bd5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 23 Jul 2012 16:34:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5e5c42a68be66cb87573e5c2fcce6f1b5d82bd5
Gitweb:     http://git.kernel.org/tip/c5e5c42a68be66cb87573e5c2fcce6f1b5d82bd5
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 23 Jul 2012 16:16:17 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 23 Jul 2012 16:16:17 -0700

x86, doc: Assign a bootloader ID for "Minimal Linux Bootloader"

Assign a bootloader ID for Sebastian Plotz' "Minimal Linux Bootloader"
(http://sebastian-plotz.blogspot.de).  Sebastian has agreed to make
this the pilot for the use of extended boot loader IDs, so this is
assigned version ID 0x11 (avoid assigning 0x10 for now to catch bugs
with people putting E in the primary ID but leaving the extended ID as
zero.)

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Sebastian Plotz <sebastian-plotz@web.de>
Link: http://lkml.kernel.org/n/tip-nq318h0okuaem8x9dpv9854k@git.kernel.org
---
 Documentation/x86/boot.txt |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 7c3a880..473b32f 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -363,7 +363,8 @@ Protocol:	2.00+
   ext_loader_type <- 0x05
   ext_loader_ver  <- 0x23
 
-  Assigned boot loader ids:
+  Assigned boot loader ids (hexadecimal):
+
 	0  LILO			(0x00 reserved for pre-2.00 bootloader)
 	1  Loadlin
 	2  bootsect-loader	(0x20, all other values reserved)
@@ -378,6 +379,8 @@ Protocol:	2.00+
 	C  Arcturus Networks uCbootloader
 	E  Extended		(see ext_loader_type)
 	F  Special		(0xFF = undefined)
+       10  Reserved
+       11  Minimal Linux Bootloader <http://sebastian-plotz.blogspot.de>
 
   Please contact <hpa@zytor.com> if you need a bootloader ID
   value assigned.
