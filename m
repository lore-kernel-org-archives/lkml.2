Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2KJNt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:49:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52137 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2KJNtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:49:24 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Jon Masters <jonathan@jonmasters.org>,
        Jon Masters <jcm@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Luming Yu <luming.yu@intel.com>
Subject: [PATCH update 2/3] x86: Delete too many "Fast TSC .." in dmesg from HW_latency cyclic sampling
Date: Sat, 10 Nov 2012 21:48:21 -0500
Message-Id: <1352602102-2390-3-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
References: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Fast TSC calibration using PIT" should be a devel info.

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cfa5d4f..7765546 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -393,7 +393,7 @@ success:
 	 */
 	delta *= PIT_TICK_RATE;
 	do_div(delta, i*256*1000);
-	pr_info("Fast TSC calibration using PIT\n");
+	pr_devel("Fast TSC calibration using PIT\n");
 	return delta;
 }
 
-- 
1.7.12.1

