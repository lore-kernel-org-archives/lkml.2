Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab0EFRhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:37:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759261Ab0EFRhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:37:38 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/13] parisc: removing redundant ifdef
Date: Thu,  6 May 2010 19:36:13 +0200
Message-Id: <1273167377-14270-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/parisc/kernel/unaligned.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index 92d977b..6ea7a0d 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -620,14 +620,12 @@ void handle_unaligned(struct pt_regs *regs)
 		ret = emulate_std(regs, R2(regs->iir),1);
 		break;
 
-#ifdef CONFIG_PA20
 	case OPCODE_LDD_L:
 		ret = emulate_ldd(regs, R2(regs->iir),0);
 		break;
 	case OPCODE_STD_L:
 		ret = emulate_std(regs, R2(regs->iir),0);
 		break;
-#endif
 	}
 #endif
 	switch (regs->iir & OPCODE3_MASK)
-- 
1.6.6.1

