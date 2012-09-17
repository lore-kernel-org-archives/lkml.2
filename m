Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab2IQSAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:00:10 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:41036
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756043Ab2IQSAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:00:08 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zz936eId6f1izz1202h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAIA00-01-K4Z-02
X-M-MSG: 
Date: Mon, 17 Sep 2012 19:59:55 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS changes for 3.7
Message-ID: <20120917175955.GK13879@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

just a "enable MCE by default" patch and a trivial cleanup.

Please pull,
Thanks.

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_queue_for_3.7

for you to fetch changes up to 57639bedd2b8268daa791efcfd0367b9031b057d:

  x86, MCE: Remove unused defines (2012-09-17 19:33:38 +0200)

----------------------------------------------------------------
Patch 1/2 which enables MCA by default because I still see bugreports
where CONFIG_X86_MCE is disabled and this is a bad idea so turning it on
by default makes sense to me. The second one is a trivial cleanup.

----------------------------------------------------------------
Borislav Petkov (2):
      x86, mce: Enable MCA support by default
      x86, MCE: Remove unused defines

 arch/x86/Kconfig           |  1 +
 arch/x86/include/asm/mce.h | 12 +-----------
 2 files changed, 2 insertions(+), 11 deletions(-)


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

