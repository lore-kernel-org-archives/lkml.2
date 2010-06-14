Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0FNMjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:39:05 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58029 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374Ab0FNMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:38:35 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] mips: Remove *(.text.*) pattern from the linker script
Date: Mon, 14 Jun 2010 13:38:30 +0100
Message-Id: <1276519112-11649-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
In-Reply-To: <1276519112-11649-1-git-send-email-matt@console-pimps.org>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matthew.fleming@imgtec.com>

Drop the pattern from the linker script because the pattern is now
provided by TEXT_TEXT.

Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
---
 arch/mips/kernel/vmlinux.lds.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index f25df73..f51bca8 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -47,7 +47,6 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
-		*(.text.*)
 		*(.fixup)
 		*(.gnu.warning)
 	} :text = 0
-- 
1.6.6.1

