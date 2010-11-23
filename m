Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0KWXWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:22:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54815 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0KWXWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w/gDm16/V5+vo8rpOBigMrWfDwISD8fZhisQRaojpK2Tdb8TQ7uJt5CZ6XfVaZzSsj
         1BE5K+fIOT/EDSU+3Hcw1ct62yptmFUpBkroAApccT7nbbhdSA1670fejAlBSPXRhu88
         qNXSIWpkn239Gygy+ZKQMa7PkkS0qftklm6H4=
From: Tracey Dent <tdent48227@gmail.com>
To: akpm@linux-foundation.org
Cc: andrea.gelmini@gelma.net, mmarek@suse.cz, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, randy.dunlap@oracle.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Readme: Add architecture
Date: Tue, 23 Nov 2010 18:22:00 -0500
Message-Id: <1290554520-1617-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Tilera Tile architecture to the list of the architectures
that Linux at least runs on.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 README |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/README b/README
index 1b81d28..c7c16d4 100644
--- a/README
+++ b/README
@@ -24,7 +24,7 @@ ON WHAT HARDWARE DOES IT RUN?
   today Linux also runs on (at least) the Compaq Alpha AXP, Sun SPARC and
   UltraSPARC, Motorola 68000, PowerPC, PowerPC64, ARM, Hitachi SuperH, Cell,
   IBM S/390, MIPS, HP PA-RISC, Intel IA-64, DEC VAX, AMD x86-64, AXIS CRIS,
-  Xtensa, AVR32 and Renesas M32R architectures.
+  Xtensa, Tilera Tile, AVR32 and Renesas M32R architectures.
 
   Linux is easily portable to most general-purpose 32- or 64-bit architectures
   as long as they have a paged memory management unit (PMMU) and a port of the
-- 
1.7.3.2.245.g03276

