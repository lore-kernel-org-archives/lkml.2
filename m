Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0GHLTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:19:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21757 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab0GHLTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:19:33 -0400
Date: Thu, 08 Jul 2010 20:19:36 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL] Samsung fixes for 2.6.35-rc5
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Message-id: <020501cb1e8f$756067c0$60213740$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcsaO2wg/xeAv8YWQKqiEpUo8omZLQB5VtsQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull Samsung fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

These things are for bug fix on 2.6.35-rc.
If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


The following changes since commit 815c4163b6c8ebf8152f42b0a5fd015cfdcedc78

  Linux 2.6.35-rc4

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

Boojin Kim (1):
      ARM: S5P: Bug fix on external interrupt for S5P SoCs

Hyuk Lee (1):
      ARM: SAMSUNG: Fix on wrong function name for S5PV210 sdhci0

Marek Szyprowski (1):
      ARM: SAMSUNG: Fix build without SDHCI controllers for S3C64XX

MyungJoo Ham (1):
      ARM: S5PV210: Correct clock register properties

Thomas Abraham (1):
      ARM: S5P6442: Fix PLL setting announce message.

 arch/arm/mach-s5p6442/clock.c              |    2 +-
 arch/arm/mach-s5pv210/clock.c              |  115
+++++++++++++++-------------
 arch/arm/plat-s5p/irq-eint.c               |    2 +-
 arch/arm/plat-samsung/include/plat/sdhci.h |    4 +-
 4 files changed, 67 insertions(+), 56 deletions(-)


