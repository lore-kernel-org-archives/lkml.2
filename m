Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2JMCaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:30:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2JMCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:30:00 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=-90lNwqLMv4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OP3jT6bbGi0A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=9AzMRrQhAAAA:8 a=-o4LH6fW1LhLtN191_YA:9 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022955.456205573@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 21/25] tile: Use Kbuild infrastructure for kvm_para.h
References: <20121013022632.024527228@goodmis.org>
Content-Disposition: inline; filename=0021-tile-Use-Kbuild-infrastructure-for-kvm_para.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

All the headers but kvm_para.h use the Kbuild infrastructure to
get to the asm-generic headers.

Cc: linux-kbuild@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/tile/include/asm/Kbuild     |    1 +
 arch/tile/include/asm/kvm_para.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)
 delete mode 100644 arch/tile/include/asm/kvm_para.h

diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 5cd98fa..0296734 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -21,6 +21,7 @@ generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
+generic-y += kvm_para.h
 generic-y += local.h
 generic-y += msgbuf.h
 generic-y += mutex.h
diff --git a/arch/tile/include/asm/kvm_para.h b/arch/tile/include/asm/kvm_para.h
deleted file mode 100644
index 14fab8f..0000000
--- a/arch/tile/include/asm/kvm_para.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kvm_para.h>
-- 
1.7.10.4


