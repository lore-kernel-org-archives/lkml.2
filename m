Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2JMC36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:29:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2JMC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:54 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lGp0bJtgQKkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=sBAU9jrBWPEA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=xfJ0t36UAAAA:8 a=sozttTNsAAAA:8 a=guQhNskCHvFOL16jMRoA:9 a=jEp0ucaQiEUA:10 a=dLc0fEiwVTkA:10 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022953.134316543@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>
Subject: [PATCH 05/25] c6x: Use Kbuild infrastructure for kvm_para.h
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0005-c6x-Use-Kbuild-infrastructure-for-kvm_para.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

All the headers but kvm_para.h use the Kbuild infrastructure to
get to the asm-generic headers.

Cc: linux-kbuild@vger.kernel.org
Cc: linux-c6x-dev@linux-c6x.org
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/c6x/include/asm/Kbuild     |    1 +
 arch/c6x/include/asm/kvm_para.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)
 delete mode 100644 arch/c6x/include/asm/kvm_para.h

diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 4e4e98d..77d2617 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -24,6 +24,7 @@ generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
+generic-y += kvm_para.h
 generic-y += local.h
 generic-y += mman.h
 generic-y += mmu_context.h
diff --git a/arch/c6x/include/asm/kvm_para.h b/arch/c6x/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/c6x/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
-- 
1.7.10.4


