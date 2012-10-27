Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab2J0WeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 18:34:25 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:37668 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547Ab2J0WeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 18:34:22 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix comment for set_real_mode_permissions
Date: Sat, 27 Oct 2012 20:34:14 -0200
Message-Id: <1351377255-21092-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function which gets called very early is setup_real_mode(). The
set_real_mode_permissions() function is the arch_initcall.

Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 arch/x86/realmode/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index cbca565..b4c92c5 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -84,7 +84,7 @@ void __init setup_real_mode(void)
 }
 
 /*
- * set_real_mode_permissions() gets called very early, to guarantee the
+ * setup_real_mode() gets called very early, to guarantee the
  * availability of low memory.  This is before the proper kernel page
  * tables are set up, so we cannot set page permissions in that
  * function.  Thus, we use an arch_initcall instead.
-- 
1.7.11.7

