Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1FAOVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:21:04 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:39308 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab1FAOU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:20:58 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] um: Add asm/percpu.h
Date: Wed,  1 Jun 2011 16:18:43 +0200
Message-Id: <1306937924-22135-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make SLUB work on UML we need this_cpu_cmpxchg from
asm-generic/percpu.h.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/percpu.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
 create mode 100644 arch/um/include/asm/percpu.h

diff --git a/arch/um/include/asm/percpu.h b/arch/um/include/asm/percpu.h
new file mode 100644
index 0000000..efe7508
--- /dev/null
+++ b/arch/um/include/asm/percpu.h
@@ -0,0 +1,6 @@
+#ifndef __UM_PERCPU_H
+#define __UM_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif /* __UM_PERCPU_H */
-- 
1.7.5.3

