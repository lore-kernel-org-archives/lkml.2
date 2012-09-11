Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab2IKCTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 22:19:02 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:17203
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757355Ab2IKCTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 22:19:00 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 17
X-BigFish: VS17(zz936eI4015Izz1ce5h1202h1d1ah1cabhzz8275dhz2ei87h2a8h668h839hd24he5bhe96h107ah1288h12a5h12bdhff4o129fs1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, <sonic.zhang@analog.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [GIT PULL] Blackfin updates for 3.6-rc6
Date: Tue, 11 Sep 2012 10:18:56 +0800
Message-ID: <1347329936-20944-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull blackfin updates for 3.6-rc6, one kbuild and a smp build fix.

Thanks,
-Bob

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus

for you to fetch changes up to 5ec683d2667636f79618bfe7670438d2848c95cc:

  kbuild: add symbol prefix arg to kallsyms (2012-09-07 17:54:56 +0800)

----------------------------------------------------------------
James Hogan (1):
      kbuild: add symbol prefix arg to kallsyms

Steven Miao (1):
      blackfin: smp: adapt to generic smp helpers

 arch/blackfin/Kconfig           |    1 +
 arch/blackfin/Makefile          |    1 -
 arch/blackfin/include/asm/smp.h |    2 +
 arch/blackfin/mach-common/smp.c |  223 ++++++++++++---------------------------
 scripts/link-vmlinux.sh         |    7 +-
 5 files changed, 75 insertions(+), 159 deletions(-)

