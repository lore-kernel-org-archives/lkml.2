Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0HCUxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:53:34 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4311 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab0HCUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:53:33 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org, hschauhan@nulltrace.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] MIPS: Define regs_return_value()
Date: Tue,  3 Aug 2010 13:53:24 -0700
Message-Id: <1280868804-2595-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <20100803202607.GA25233@linux-mips.org>
References: <20100803202607.GA25233@linux-mips.org>
X-OriginalArrivalTime: 03 Aug 2010 20:53:33.0512 (UTC) FILETIME=[EF93A480:01CB334D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---

Use this version instead of the original 1/5

 arch/mips/include/asm/ptrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index cdc6a46..9f1b8db 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -137,6 +137,7 @@ extern int ptrace_set_watch_regs(struct task_struct *child,
  */
 #define user_mode(regs) (((regs)->cp0_status & KU_MASK) == KU_USER)
 
+#define regs_return_value(_regs) ((_regs)->regs[2])
 #define instruction_pointer(regs) ((regs)->cp0_epc)
 #define profile_pc(regs) instruction_pointer(regs)
 
-- 
1.7.1.1

