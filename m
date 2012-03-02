Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab2CBAz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:55:57 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47838 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757561Ab2CBAzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:55:25 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/5] OpenRISC: Export dump_stack()
Date: Fri,  2 Mar 2012 01:55:15 +0100
Message-Id: <1330649715-32438-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330649715-32438-1-git-send-email-richard@nod.at>
References: <1330649715-32438-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_stack() is used by modules and needs to be exported.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/kernel/traps.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index a4ec44a..ab68ffc 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -115,6 +115,7 @@ void dump_stack(void)
 
 	show_stack(current, &stack);
 }
+EXPORT_SYMBOL(dump_stack);
 
 void show_registers(struct pt_regs *regs)
 {
-- 
1.7.7.3

