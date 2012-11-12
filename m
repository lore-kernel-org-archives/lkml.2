Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab2KLQe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:34:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54031 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2KLQeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:34:24 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 2/4] avr32, kconfig: remove HAVE_ARCH_BOOTMEM
Date: Tue, 13 Nov 2012 01:31:53 +0900
Message-Id: <1352737915-30906-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352737915-30906-1-git-send-email-js1304@gmail.com>
References: <1352737915-30906-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, there is no code for CONFIG_HAVE_ARCH_BOOTMEM.
So remove it.

Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 06e73bf..c2bbc9a 100644
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
1.7.9.5

