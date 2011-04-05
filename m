Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1DEQ7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:59:02 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59830 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1DEQ65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:58:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QUgE/9dGlklhDfPsbjFndiUjGXIcLQVnjAXUVAaM1hZTWdTwRuf15Bf0Dk2bGDPl+L
         p33TtVKV4vnjKhNfoyZoPwu78p6k3tBBD24Mujl+00fCiigFzNIdv6akbbGUiwAc8gcg
         hFHl34Qy0OMwj5yxLf2avHVTi+HuVZkoZPTzM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [RFC 3/5]arch:mips:pmc-sierra:msp71xx:Makefile Remove unused config in the Makefile.
Date: Tue,  5 Apr 2011 09:58:20 -0700
Message-Id: <1302022702-24541-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unused config variable found by using a kernel
cleanup script.
Note: I did try to cross compile these but hit erros while doing so..
(gcc is not setup to cross compile) and am unsure if anymore needs to be done.
Please have a look if/when anybody has free time.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org

---
 arch/mips/pmc-sierra/msp71xx/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/pmc-sierra/msp71xx/Makefile b/arch/mips/pmc-sierra/msp71xx/Makefile
index cefba77..9201c8b 100644
--- a/arch/mips/pmc-sierra/msp71xx/Makefile
+++ b/arch/mips/pmc-sierra/msp71xx/Makefile
@@ -3,7 +3,6 @@
 #
 obj-y += msp_prom.o msp_setup.o msp_irq.o \
 	 msp_time.o msp_serial.o msp_elb.o
-obj-$(CONFIG_HAVE_GPIO_LIB) += gpio.o gpio_extended.o
 obj-$(CONFIG_PMC_MSP7120_GW) += msp_hwbutton.o
 obj-$(CONFIG_IRQ_MSP_SLP) += msp_irq_slp.o
 obj-$(CONFIG_IRQ_MSP_CIC) += msp_irq_cic.o msp_irq_per.o
-- 
1.7.4.2

