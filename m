Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab2LJVcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:32:13 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58923 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2LJVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:32:12 -0500
Message-ID: <50C654C7.1050200@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 15:31:51 -0600
From: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: KVM list <kvm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jlarrew@linux.vnet.ibm.com
Subject: [PATCH][TRIVIAL] kvm_para: fix typo in hypercall comments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121021-5406-0000-0000-000002FA763A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct a typo in the comment explaining hypercalls.

Signed-off-by: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_para.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index eb3e9d8..f49c16d 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -122,7 +122,7 @@ static inline bool kvm_check_and_clear_guest_paused(void)
  *
  * Up to four arguments may be passed in rbx, rcx, rdx, and rsi respectively.
  * The hypercall number should be placed in rax and the return value will be
- * placed in rax.  No other registers will be clobbered unless explicited
+ * placed in rax.  No other registers will be clobbered unless explicitly
  * noted by the particular hypercall.
  */
 
-- 
1.7.11.7

Jesse Larrew
Software Engineer, KVM Team
IBM Linux Technology Center
Phone: (512) 973-2052 (T/L: 363-2052)
jlarrew@linux.vnet.ibm.com

