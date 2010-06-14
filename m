Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab0FNMik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:38:40 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58031 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab0FNMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:38:35 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] parisc: Remove *(.text.*) pattern from the linker script
Date: Mon, 14 Jun 2010 13:38:31 +0100
Message-Id: <1276519112-11649-4-git-send-email-matt@console-pimps.org>
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
 arch/parisc/kernel/vmlinux.lds.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index d64a6bb..6784e39 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -61,7 +61,6 @@ SECTIONS
 		*(.text.sys_exit)
 		*(.text.do_sigaltstack)
 		*(.text.do_fork)
-		*(.text.*)
 		*(.fixup)
 		*(.lock.text)		/* out-of-line lock text */
 		*(.gnu.warning)
-- 
1.6.6.1

