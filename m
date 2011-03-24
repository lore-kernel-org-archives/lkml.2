Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1CXPFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:05:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1CXPFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KcS63WLaseAMm+/CK6+t1KrTVj5+6NIOLsn8LnMKRF59GiGKKrjl/SJaKDh9h560IW
         vZKaH3XqQo9PSNwwaJCP45Hg2WfI+vJFqjhAKbmYgpLQ9p+eezmqVQzSxCByNqpWIHhO
         EszSwWP2D1VJsr6w2fmJN+EPj8pVtkilGu+2k=
Date: Thu, 24 Mar 2011 16:05:17 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc: add clock_adjtime for powerpc
Message-ID: <20110324150517.GA6710@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the clock_adjtime system call to the powerpc architecture.

The call was introduced in f1f1d5ebd10ffa4242bce7a90a56a222d6b7bc77

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 arch/powerpc/include/asm/systbl.h |    1 +
 arch/powerpc/include/asm/unistd.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index aa0f1eb..6a1152c 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -348,3 +348,4 @@ COMPAT_SYS_SPU(sendmsg)
 COMPAT_SYS_SPU(recvmsg)
 COMPAT_SYS_SPU(recvmmsg)
 SYSCALL_SPU(accept4)
+COMPAT_SYS_SPU(clock_adjtime)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 6151937..386de07 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -367,10 +367,11 @@
 #define __NR_recvmsg		342
 #define __NR_recvmmsg		343
 #define __NR_accept4		344
+#define __NR_clock_adjtime	345
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		345
+#define __NR_syscalls		346
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
-- 
1.7.0.4

