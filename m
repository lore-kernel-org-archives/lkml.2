Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0HCSWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:22:53 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19477 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab0HCSWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:22:47 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org, hschauhan@nulltrace.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 1/5] MIPS: Define regs_return_value()
Date: Tue,  3 Aug 2010 11:22:18 -0700
Message-Id: <1280859742-26364-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
References: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 03 Aug 2010 18:22:47.0079 (UTC) FILETIME=[DF7B8370:01CB3338]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/include/asm/ptrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index cdc6a46..593b097 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -137,6 +137,7 @@ extern int ptrace_set_watch_regs(struct task_struct *child,
  */
 #define user_mode(regs) (((regs)->cp0_status & KU_MASK) == KU_USER)
 
+#define regs_return_value(regs) ((regs)->regs[2])
 #define instruction_pointer(regs) ((regs)->cp0_epc)
 #define profile_pc(regs) instruction_pointer(regs)
 
-- 
1.7.1.1

