Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab0GXBmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 21:42:31 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16617 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab0GXBmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 21:42:17 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, wim@iguana.be
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 6/7] MIPS: Define ST0_NMI in asm/mipsregs.h
Date: Fri, 23 Jul 2010 18:41:46 -0700
Message-Id: <1279935707-3997-7-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com>
References: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 24 Jul 2010 01:42:17.0187 (UTC) FILETIME=[72BF6B30:01CB2AD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used by the forthcoming OCTEON watchdog patch.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/include/asm/mipsregs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index c6e3c93..335474c 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -408,6 +408,7 @@
 #define  STATUSB_IP15		7
 #define  STATUSF_IP15		(_ULCAST_(1) <<  7)
 #define ST0_CH			0x00040000
+#define ST0_NMI			0x00080000
 #define ST0_SR			0x00100000
 #define ST0_TS			0x00200000
 #define ST0_BEV			0x00400000
-- 
1.7.1.1

