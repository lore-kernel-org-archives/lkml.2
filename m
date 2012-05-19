Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2ESLTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 07:19:18 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab2ESLTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 07:19:14 -0400
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] OpenRISC: Make do_signal() non-static
Date: Sat, 19 May 2012 13:19:07 +0200
Message-Id: <1337426347-3557-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to export this function.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index 44749d4..f0446ec 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -284,7 +284,7 @@ handle_signal(unsigned long sig,
  * mode below.
  */
 
-void do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
-- 
1.7.7.3

