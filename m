Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1KMUXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 15:23:39 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:48948 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1KMUXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 15:23:38 -0500
Subject: [PATCH] [TRIVIAL] MIPS: Sibyte: drop select of SIBYTE_CFE
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 21:23:35 +0100
Message-ID: <1321215815.20271.89.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SIBYTE_CFE got killed in commit 05f94eebd5 ("MIPS: Sibyte: Remove
standalone kernel support"). This means that since v2.6.31 there is no
Kconfig symbol SIBYTE_CFE. The select statement for that symbol is a
nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "make ARCH=mips menuconfig" before and after applying this
patch. Identical .config files were generated, as was expected

 arch/mips/sibyte/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/sibyte/Kconfig b/arch/mips/sibyte/Kconfig
index 3e639bd..3cd937e 100644
--- a/arch/mips/sibyte/Kconfig
+++ b/arch/mips/sibyte/Kconfig
@@ -71,7 +71,6 @@ config SIBYTE_SB1xxx_SOC
 	bool
 	select DMA_COHERENT
 	select IRQ_CPU
-	select SIBYTE_CFE
 	select SWAP_IO_SPACE
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_64BIT_KERNEL
-- 
1.7.4.4



