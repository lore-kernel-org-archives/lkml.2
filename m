Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2BTTpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:45:08 -0500
Received: from 16.mo3.mail-out.ovh.net ([188.165.56.217]:50185 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751653Ab2BTTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:45:06 -0500
X-Greylist: delayed 6600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Feb 2012 14:45:06 EST
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [FOR 3.2 stable PATCH V2] avr32: select generic atomic64_t support
Date: Tue, 21 Feb 2012 01:18:37 +0800
Message-Id: <1329758317-16772-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.7
X-Ovh-Tracer-Id: 9257993459983297304
X-Ovh-Remote: 114.91.36.118 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegtddrtdefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpefhvffufffkofestddtredtredttd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdekucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpefhvffufffkofestddtredtredttd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Baltieri <fabio.baltieri@gmail.com>

Enable use of the generic atomic64 implementation on AVR32 platforms.
Without this the kernel fails to build as the architecture does not
provide its version.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
---
v2:

	add Cc: stable@vger.kernel.org

	Can we have this applied on the 3.2 stable as it's suffer too
	from this bug

Best Regards,
J.

 arch/avr32/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 197e96f..3dea7231 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -8,6 +8,7 @@ config AVR32
 	select HAVE_KPROBES
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
+	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-- 
1.7.7

