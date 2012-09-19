Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab2ISRQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:16:25 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:12425
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756142Ab2ISRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:16:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zz936eId6f1izz1202h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MALXB6-01-7YS-02
X-M-MSG: 
Date: Wed, 19 Sep 2012 19:16:10 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] microcode fix for 3.6-rc7
Message-ID: <20120919171610.GM4577@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please pull this fix from Dan Carpenter which goes ontop of
tip/x86/microcode. It would be best if it goes in during the upcoming
merge window along with the rest from tip/x86/microcode so that we don't
have any breakages.

Thanks.

The following changes since commit 2efb05e8e9fa3510044e007b90263c73b6a83f84:

  x86, microcode, AMD: Rewrite patch application procedure (2012-08-22 16:16:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode_fix_3.7

for you to fetch changes up to 2d297480037e1d9100ca504737820c1bf65db6c0:

  x86, microcode, AMD: Fix use after free in free_cache() (2012-09-19 18:06:25 +0200)

----------------------------------------------------------------
A small list usage correction from Dan Carpenter.

----------------------------------------------------------------
Dan Carpenter (1):
      x86, microcode, AMD: Fix use after free in free_cache()

 arch/x86/kernel/microcode_amd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

