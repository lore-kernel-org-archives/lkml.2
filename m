Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab2JIEnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:43:21 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:30248
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab2JIEnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:43:17 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 22
X-BigFish: VS22(zz936eIzz1ce5h1202h1d1ah1cabh1d2ahzz8275dhz2ei87h2a8h668h839hd24he5bh107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441hff4s129fs1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, <sonic.zhang@analog.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [GIT PULL] Blackfin updates for 3.7-rc1
Date: Tue, 9 Oct 2012 12:42:54 +0800
Message-ID: <1349757774-4358-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

  Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus

for you to fetch changes up to 6594b982f6d5f957c8d72de7658bf8e240c7dfca:

  Blackfin: smp: add smp_mb() to keep coherency (2012-10-08 14:36:30 +0800)

----------------------------------------------------------------
Bob Liu (1):
      Blackfin: update defconfig for bf609-ezkit

Harald Krapfenbauer (1):
      Blackfin: CM-BF537E: Update SPORT support in board file.

James Cosin (1):
      Blackfin: cpufreq: fix dpm_state_table

Mike Frysinger (1):
      Blackfin: bf533-ezkit: enable flash drivers by default

Scott Jiang (1):
      Blackfin: bf537: fix lq035 platform device name

Sonic Zhang (2):
      Blackfin: bf60x: Add bf608 and bf609 specific perpheral MMRs
      Blackfin: add bf548 v0.4 revision

Steven Miao (4):
      Blackfin: bfin_gpio: proc: fix return value
      Blackfin: fix wrong place disabled irq
      Blackfin: drop irq enable in init_arch_irq()
      Blackfin: smp: add smp_mb() to keep coherency

 arch/blackfin/Kconfig                            |    2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig      |    7 +-
 arch/blackfin/configs/BF609-EZKIT_defconfig      |   16 +-
 arch/blackfin/kernel/bfin_gpio.c                 |    4 +-
 arch/blackfin/kernel/reboot.c                    |    1 -
 arch/blackfin/mach-bf537/boards/cm_bf537e.c      |  130 ++++++++++-
 arch/blackfin/mach-bf537/boards/stamp.c          |    2 +-
 arch/blackfin/mach-bf609/include/mach/defBF609.h |  271 ++++++++++++++++++++++
 arch/blackfin/mach-common/cpufreq.c              |    9 +-
 arch/blackfin/mach-common/ints-priority.c        |    1 -
 arch/blackfin/mach-common/smp.c                  |    4 +-
 11 files changed, 416 insertions(+), 31 deletions(-)

