Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0JWPCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:02:47 -0400
Received: from www.tglx.de ([62.245.132.106]:49034 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab0JWPCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:02:46 -0400
Date: Sat, 23 Oct 2010 17:02:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 quirks for 2.6.37
Message-ID: <alpine.LFD.2.00.1010231633080.2516@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-quirks-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-quirks-for-linus

Thanks,

	tglx

------------------>
Udo van den Heuvel (1):
      x86: HPET force enable for CX700 / VIA Epia LT


 arch/x86/kernel/quirks.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 939b9e9..8bbe8c5 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -344,6 +344,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
 			 vt8237_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
 			 vt8237_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700,
+			 vt8237_force_enable_hpet);
 
 static void ati_force_hpet_resume(void)
 {
