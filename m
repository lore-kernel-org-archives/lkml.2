Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab0JHFzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:55:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37009 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab0JHFzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:55:06 -0400
Date: Fri, 08 Oct 2010 14:55:21 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL] Samsung fixes for 2.6.36
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, "'Ben Dooks'" <ben-linux@fluff.org>
Message-id: <00e101cb66ad$6788e030$369aa090$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActmrWRnHyKlUyOdSiOKlwocJjeTdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Samsung fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

These things are for bug fix on 2.6.36.
If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


The following changes since commit cb655d0f3d57c23db51b981648e452988c0223f9:

  Linux 2.6.36-rc7 (2010-10-06 13:39:52 -0700)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

Kukjin Kim (1):
      ARM: SAMSUNG: Fix build warnings because of unused codes

Marek Szyprowski (1):
      ARM: SAMSUNG: Add a workaround for get_clock() for serial driver

SeungChull Suh (1):
      ARM: S5P: Bug fix on errors of build with CONFIG_PREEMPT_NONE

 arch/arm/mach-s5p6440/cpu.c   |    1 +
 arch/arm/mach-s5p6442/cpu.c   |    1 +
 arch/arm/mach-s5pc100/cpu.c   |    1 +
 arch/arm/mach-s5pv210/clock.c |    5 -----
 arch/arm/mach-s5pv210/cpu.c   |    1 +
 arch/arm/plat-samsung/adc.c   |    1 -
 arch/arm/plat-samsung/clock.c |   27 ++++++++++++++++++++++++++-
 7 files changed, 30 insertions(+), 7 deletions(-)

