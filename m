Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0H0Jsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:48:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44869 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0H0Jsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:48:37 -0400
Date: Fri, 27 Aug 2010 18:48:48 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL] Samsung fixes for 2.6.36-rc3
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Message-id: <006d01cb45cd$0e4e3610$2aeaa230$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActFzQvThlij3bJiSs6b7kylJHKAgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Samsung fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

These things are for bug fix on 2.6.36-rc3.
If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


The following changes since commit 76be97c1fc945db08aae1f1b746012662d643e97:

  Linux 2.6.36-rc2 (2010-08-22 17:43:29 -0700)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

Changhwan Youn (1):
      ARM: S5PV310: Fix on Secondary CPU startup

Jongpill Lee (4):
      ARM: S5PV310: Fix on PLL setting for S5PV310
      ARM: S5PV310: Should be clk_sclk_apll not clk_mout_apll
      ARM: S5PV310: Fix missed uart clocks
      ARM: S5PV310: Bug fix on uclk1 and sclk_pwm

Kukjin Kim (4):
      ARM: SAMSUNG: Fix on build warning regarding VMALLOC_END type
      ARM: S5PV310: Fix on default ZRELADDR of ARCH_S5PV310
      ARM: S5PV310: Fix on typo irqs.h of S5PV310
      ARM: S5PV310: Add CMU block for S5PV310 Clock

Kyungmin Park (2):
      ARM: S5P: VMALLOC_END should be unsigned long
      ARM: S5PV310: Fix on GPIO base addresses

 arch/arm/Kconfig                                |    3 +-
 arch/arm/mach-s3c2410/include/mach/vmalloc.h    |    2 +-
 arch/arm/mach-s3c64xx/include/mach/vmalloc.h    |    2 +-
 arch/arm/mach-s5p6440/include/mach/vmalloc.h    |    2 +-
 arch/arm/mach-s5p6442/include/mach/vmalloc.h    |    2 +-
 arch/arm/mach-s5pv210/include/mach/vmalloc.h    |    2 +-
 arch/arm/mach-s5pv310/clock.c                   |   82
+++++++++++++++++-----
 arch/arm/mach-s5pv310/cpu.c                     |   10 +++
 arch/arm/mach-s5pv310/include/mach/irqs.h       |   11 ++-
 arch/arm/mach-s5pv310/include/mach/map.h        |   16 ++++-
 arch/arm/mach-s5pv310/include/mach/regs-clock.h |   59 ++++++++--------
 arch/arm/mach-s5pv310/include/mach/vmalloc.h    |    2 +-
 arch/arm/mach-s5pv310/platsmp.c                 |    2 +-
 arch/arm/plat-s5p/include/plat/map-s5p.h        |    2 +
 14 files changed, 135 insertions(+), 62 deletions(-)

