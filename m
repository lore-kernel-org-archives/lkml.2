Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966207Ab2B2Ap7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:45:59 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965840Ab2B2Ap5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:45:57 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: arnd@arndb.de, linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] OpenRISC: IRQ: Include module.h
Date: Wed, 29 Feb 2012 01:46:33 +0100
Message-Id: <1330476393-14264-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1330476393-14264-1-git-send-email-richard@nod.at>
References: <1330476393-14264-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:
  CC      arch/openrisc/kernel/irq.o
arch/openrisc/kernel/irq.c:35:1: warning: data definition has no type or storage class
arch/openrisc/kernel/irq.c:35:1: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL’
arch/openrisc/kernel/irq.c:35:1: warning: parameter names (without types) in function declaration
arch/openrisc/kernel/irq.c:42:1: warning: data definition has no type or storage class
arch/openrisc/kernel/irq.c:42:1: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL’
arch/openrisc/kernel/irq.c:42:1: warning: parameter names (without types) in function declaration
arch/openrisc/kernel/irq.c:173:1: warning: data definition has no type or storage class
arch/openrisc/kernel/irq.c:173:1: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL_GPL’
arch/openrisc/kernel/irq.c:173:1: warning: parameter names (without types) in function declaration

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/kernel/irq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
index 59b3023..f917925 100644
--- a/arch/openrisc/kernel/irq.c
+++ b/arch/openrisc/kernel/irq.c
@@ -14,6 +14,7 @@
  *      2 of the License, or (at your option) any later version.
  */
 
+#include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
-- 
1.7.6

