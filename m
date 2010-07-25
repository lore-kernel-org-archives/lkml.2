Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0GYEuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 00:50:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63204 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab0GYEuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 00:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=C6NIx0pcZv/XNqcsWgkD6+fZX29Kn0wJuen+gVi7mWgPHfj9Doa5EksuLk3rZvqZ8K
         EibJsREiWcACIkjd3NDZ02M5+Q8Uvli6U5ifYGgdOU9mOnfdvztV5L8ozZvgAkC7KJIk
         z+Uh07TljrPUc49Z4r5w9ufkcex+ZDkQnXCb0=
Subject: [PATCH] x86, mrst: remove unused mrst_identify_cpu()
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Jul 2010 00:50:38 -0400
Message-ID: <1280033438.2419.5.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mrst_identify_cpu() function is not been used anymore (at today linux-next). This patch removes it.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 arch/x86/include/asm/mrst.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 1635074..0d0e702 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -26,10 +26,6 @@ enum mrst_cpu_type {
 };
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
-static enum mrst_cpu_type mrst_identify_cpu(void)
-{
-	return __mrst_cpu_chip;
-}
 
 enum mrst_timer_options {
 	MRST_TIMER_DEFAULT,
-- 
1.7.0.4



