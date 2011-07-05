Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1GEQEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:04:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52178 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab1GEQEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:04:39 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 2/3] h8300: Use generic config PREEMPT definition
Date: Tue,  5 Jul 2011 18:04:27 +0200
Message-Id: <1309881868-9483-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309881868-9483-1-git-send-email-fweisbec@gmail.com>
References: <1309881868-9483-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it can handle the new CONFIG_PREEMPT_COUNT.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/Kconfig.cpu |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
index d236ab4..15c2228 100644
--- a/arch/h8300/Kconfig.cpu
+++ b/arch/h8300/Kconfig.cpu
@@ -162,9 +162,7 @@ config H8300_TPU_CH
 	int "TPU channel"
 	depends on H8300_TPU
 
-config PREEMPT
-	bool "Preemptible Kernel"
-	default n
+source "kernel/Kconfig.preempt"
 
 source "mm/Kconfig"
 
-- 
1.7.5.4

