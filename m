Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2LXEGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 23:06:34 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36539 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab2LXEGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 23:06:31 -0500
Date: Sun, 23 Dec 2012 22:06:26 -0600
Message-Id: <E1TmzJ4-0003mm-3H@localhost>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org
Subject: MIPS: MSP71xx: Indicate new location of source files in Platform file
From: Shane McDonald <mcdonald.shane@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source files for the MSP71xx support code have been moved
in commit 13a347ef60c68e490809dad8fcf79c25eabc4d58,
"MIPS: MSP71xx: Move code." Update the Platform file
to indicate the new location.

Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
---
 arch/mips/pmcs-msp71xx/Platform |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pmcs-msp71xx/Platform b/arch/mips/pmcs-msp71xx/Platform
index 17299f9..9a86e29 100644
--- a/arch/mips/pmcs-msp71xx/Platform
+++ b/arch/mips/pmcs-msp71xx/Platform
@@ -1,7 +1,7 @@
 #
 # PMC-Sierra MSP SOCs
 #
-platform-$(CONFIG_PMC_MSP)	+= pmc-sierra/
-cflags-$(CONFIG_PMC_MSP)	+= -I$(srctree)/arch/mips/include/asm/pmc-sierra \
+platform-$(CONFIG_PMC_MSP)	+= pmcs-msp71xx/
+cflags-$(CONFIG_PMC_MSP)	+= -I$(srctree)/arch/mips/include/asm/pmc-sierra/msp71xx \
 					-mno-branch-likely
 load-$(CONFIG_PMC_MSP)		+= 0xffffffff80100000
-- 
1.7.2.5

