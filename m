Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab1E3Rcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:32:33 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:34208 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1E3Rcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nXXsGJq1bkqa0HKhLJYlT/zLsv0OmbPbJgM1C0wm77Uc3RnSgJEoWd4grhRRFU2qMT
         /8QsYGKQ/zky+/tUs8njAA2K4TCd4uipIdV40dl92sZFxARiGt93ShQKpr2pwuWqqIzJ
         t5WP/0ip3ifNNgLm5rlgAgYIQbD0khUjOrJrw=
From: Rohit Yadav <rohityadav89@gmail.com>
To: len.brown@intel.com
Cc: trenn@suse.de, linux-kernel@vger.kernel.org,
        Rohit Yadav <rohityadav89@gmail.com>
Subject: [PATCH] Arch: x86: process: Fix a compilation warning.
Date: Mon, 30 May 2011 23:00:29 +0530
Message-Id: <1306776629-13404-1-git-send-email-rohityadav89@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <rohityadav89@gmail.com>
References: <rohityadav89@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unknown escape sequence \i in idle_setup.

Signed-off-by: Rohit Yadav <rohityadav89@gmail.com>
---
 arch/x86/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 426a5b6..ed2da29 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -642,7 +642,7 @@ static int __init idle_setup(char *str)
 		boot_option_idle_override = IDLE_POLL;
 	} else if (!strcmp(str, "mwait")) {
 		boot_option_idle_override = IDLE_FORCE_MWAIT;
-		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
+		WARN_ONCE(1, "idle=mwait\" will be removed in 2012\"\n");
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
-- 
1.7.4.1

