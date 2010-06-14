Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0FNMih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:38:37 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58033 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559Ab0FNMig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:38:36 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Chen Liqin <liqin.chen@sunplusct.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] score: Remove *(.text.*) pattern from the linker script
Date: Mon, 14 Jun 2010 13:38:32 +0100
Message-Id: <1276519112-11649-5-git-send-email-matt@console-pimps.org>
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
 arch/score/kernel/vmlinux.lds.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/score/kernel/vmlinux.lds.S b/arch/score/kernel/vmlinux.lds.S
index eebcbaa..2ed49ad 100644
--- a/arch/score/kernel/vmlinux.lds.S
+++ b/arch/score/kernel/vmlinux.lds.S
@@ -42,7 +42,6 @@ SECTIONS
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
-		*(.text.*)
 		*(.fixup)
 		. = ALIGN (4) ;
 		_etext = .;	/* End of text section */
-- 
1.6.6.1

