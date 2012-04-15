Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2DOJ2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 05:28:09 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:37934 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2DOJ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 05:28:07 -0400
Date: Sun, 15 Apr 2012 11:28:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] avr32: drop HAVE_ARCH_BOOTMEM from Kconfig
Message-ID: <20120415092804.GA4947@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f58a1c9f6717a6754fde691fb10f8eab7170dbc2 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 15 Apr 2012 11:23:50 +0200
Subject: [PATCH] avr32: drop HAVE_ARCH_BOOTMEM from Kconfig

The symbol is default to n - so no point in adding a symbol
with def_bool n.
Noticed iby Tejun when we removed this symbol from x86.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tejun Heo <tj@kernel.org>
---

Other symbols looks like candidates too - but being on the
safe side this patch only removes this single symbol.

	Sam

 arch/avr32/Kconfig |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 3dea723..5065528 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -193,9 +193,6 @@ source "kernel/Kconfig.preempt"
 config QUICKLIST
 	def_bool y
 
-config HAVE_ARCH_BOOTMEM
-	def_bool n
-
 config ARCH_HAVE_MEMORY_PRESENT
 	def_bool n
 
-- 
1.6.0.6

