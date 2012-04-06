Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2DFC7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 22:59:10 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:39067 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383Ab2DFC7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 22:59:08 -0400
X-SpamScore: 0
X-BigFish: VS0(zz4015Izz1202hzz8275dhz2ei87h2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, <sonic.zhang@analog.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [GIT PULL] Blackfin fixes for 3.4-rc1
Date: Fri, 6 Apr 2012 10:58:58 +0800
Message-ID: <1333681138-2080-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linus,

Please pull a few blackfin fixes for 3.4-rc1.
All of them are fix compile issue.

Thanks,
-Bob
----
The following changes since commit 5d32c88f0b94061b3af2e3ade92422407282eb12:
  Linus Torvalds (1):
        Merge branch 'akpm' (Andrew's patch-bomb)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus

Bob Liu (2):
      blackfin: gpio: fix compile error if !CONFIG_GPIOLIB
      blackfin: update defconfig for bf527-ezkit

Mike Frysinger (1):
      blackfin: fix L1 data A overflow link issue

 arch/blackfin/Kconfig                       |    2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig |    1 +
 arch/blackfin/include/asm/gpio.h            |   14 ++++++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

