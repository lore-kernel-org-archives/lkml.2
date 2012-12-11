Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2LKAL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 19:11:26 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43181 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2LKALW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:11:22 -0500
From: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
To: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Michael Cree <mcree@orcon.net.nz>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Raphael S Carvalho <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] arch/alpha/include/asm: Comment fixed.
Date: Mon, 10 Dec 2012 22:11:12 -0200
Message-Id: <1355184672-22268-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raphael S Carvalho <raphael.scarv@gmail.com>

I know how much this patch is insignificant, though its
purpose is to teach me how to send patches properly.

Signed-off-by: Raphael S Carvalho <raphael.scarv@gmail.com>
---
 arch/alpha/include/asm/ptrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/ptrace.h b/arch/alpha/include/asm/ptrace.h
index b87755a..34b88ae 100644
--- a/arch/alpha/include/asm/ptrace.h
+++ b/arch/alpha/include/asm/ptrace.h
@@ -7,8 +7,8 @@
  * kernel stack during a system call or other kernel entry
  *
  * NOTE! I want to minimize the overhead of system calls, so this
- * struct has as little information as possible.  I does not have
- *
+ * struct has as little information as possible.
+ * It does not have:
  *  - floating point regs: the kernel doesn't change those
  *  - r9-15: saved by the C compiler
  *
-- 
1.7.2.5

