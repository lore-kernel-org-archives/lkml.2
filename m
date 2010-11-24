Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0KXL4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:56:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62296 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0KXL4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:56:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=psmkwJp4WujCYl2NixqZ6HHTMwivFpE5KRTC8rgoNPm0GkrdiuAGAC/eEGtANCr0d3
         CL1WHlBPQrWl7PSlhdwTYSN/TrJHFm20LU2y/nuM9/SYd5G9EvkbyXCoeTVk+zSlloQY
         Bt0lm4freoBfgRVwTEZ+c5evFaqARL067vV8Q=
From: Tracey Dent <tdent48227@gmail.com>
To: akpm@linux-foundation.org
Cc: andrea.gelmini@gelma.net, mmarek@suse.cz, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, randy.dunlap@oracle.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Readme: Add architecture
Date: Wed, 24 Nov 2010 06:56:36 -0500
Message-Id: <1290599796-1596-1-git-send-email-tdent48227@gmail.com>
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
+  Xtensa, Tilera TILE, AVR32 and Renesas M32R architectures.
 
   Linux is easily portable to most general-purpose 32- or 64-bit architectures
   as long as they have a paged memory management unit (PMMU) and a port of the
-- 
1.7.3.2.245.g03276

