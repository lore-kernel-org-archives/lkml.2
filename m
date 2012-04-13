Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934995Ab2DMKKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:10:47 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:36562
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938Ab2DMKKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:10:45 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz936eKzz1202hzz8275dhz2dh668h839h944hd25hd2bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2EXLO-02-36T-02
X-M-MSG: 
Date: Fri, 13 Apr 2012 12:10:21 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: [GIT PULL] x86 microcode fix for 3.4
Message-ID: <20120413101021.GC27686@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull the following fix for 3.4 from Andreas. This is seen by
people using 3.3 too thus the stable tagging.

Thanks.

---
The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode-fix-for-3.4

for you to fetch changes up to 283c1f2558ef4a4411fe908364b15b73b6ab44cf:

  x86, microcode: Ensure that module is only loaded on supported AMD CPUs (2012-04-13 11:51:05 +0200)

----------------------------------------------------------------
A two-patch fix from Andreas taking care of a sysfs warning when the
microcode driver is loaded on unsupported platforms.

----------------------------------------------------------------
Andreas Herrmann (2):
      x86, microcode: Fix sysfs warning during module unload on unsupported CPUs
      x86, microcode: Ensure that module is only loaded on supported AMD CPUs

 arch/x86/kernel/microcode_amd.c  |   12 +++++++-----
 arch/x86/kernel/microcode_core.c |   10 ++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

