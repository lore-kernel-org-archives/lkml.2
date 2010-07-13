Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0GMTLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:11:37 -0400
Received: from ip4-95-82-188-143.cust.nbox.cz ([95.82.188.143]:56980 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752364Ab0GMTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:11:36 -0400
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2010 15:11:35 EDT
From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH 0/2] x86: AMD C1E fix and cleanup
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 13 Jul 2010 20:59:50 +0200
Message-ID: <20100713185816.2866.17837.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fixes AMD C1E once again. The second one is a cleanup.

---

Michal Schmidt (2):
      x86: remove c1e_mask
      x86: fix keeping track of AMD C1E


 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/include/asm/idle.h       |    2 --
 arch/x86/include/asm/processor.h  |    1 -
 arch/x86/kernel/cpu/common.c      |    1 -
 arch/x86/kernel/process.c         |   34 ++++++++++++++--------------------
 arch/x86/kernel/smpboot.c         |    1 -
 6 files changed, 15 insertions(+), 26 deletions(-)

-- 
Michal
