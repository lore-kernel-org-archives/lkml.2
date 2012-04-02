Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2DBLkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:40:23 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:38414 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2DBLkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:40:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: starvik@axis.com
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 1/1] cris: posix_types.h, include asm-generic/posix_types.h
Date: Mon,  2 Apr 2012 13:40:17 +0200
Message-Id: <1333366817-26121-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without that I cannot build anything:
In file included from include/linux/page-flags.h:8:0,
                 from kernel/bounds.c:9:
include/linux/types.h:25:1: error: unknown type name '__kernel_ino_t'
include/linux/types.h:29:1: error: unknown type name '__kernel_off_t'
...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/include/asm/posix_types.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/cris/include/asm/posix_types.h b/arch/cris/include/asm/posix_types.h
index 72b3cd6..234891c 100644
--- a/arch/cris/include/asm/posix_types.h
+++ b/arch/cris/include/asm/posix_types.h
@@ -33,4 +33,6 @@ typedef int		__kernel_ptrdiff_t;
 typedef unsigned short	__kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
+#include <asm-generic/posix_types.h>
+
 #endif /* __ARCH_CRIS_POSIX_TYPES_H */
-- 
1.7.9.2


