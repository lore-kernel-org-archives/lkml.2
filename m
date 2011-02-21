Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1BUJ6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:58:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21620 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1BUJ6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:58:35 -0500
Date: Mon, 21 Feb 2011 18:58:25 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL] Samsung fixes for 2.6.38-rc6
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Message-id: <000001cbd1ad$e634f9d0$b29eed70$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvRoj3N/vBUhZpOTmOe+hdCr+vODQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Samsung fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

These things are for small fix and cleanup on 2.6.38-rc6.
As a note, cleanup patch includes fixing coding style such as removing
useless braces, and re-ordering.

If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

The following changes since commit 85e2efbb1db9a18d218006706d6e4fbeb0216213:

  Linux 2.6.38-rc5 (2011-02-15 19:23:45 -0800)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

Axel Lin (1):
      ARM: SAMSUNG: Drop exporting s3c24xx_ts_set_platdata

Kukjin Kim (5):
      ARM: S5PV310: Cleanup map.h file
      ARM: S5PV210: Cleanup map.h file
      ARM: S5PC100: Clenaup map.h file
      ARM: S5P6442: Cleanup map.h file
      ARM: S5P64X0: Cleanup map.h file

Marek Szyprowski (2):
      ARM: S5PV210: Update max8998_platform_data
      ARM: S5PV210: Fix regulator names

Thomas Abraham (1):
      ARM: S5P: Fix end address in memory resource information for UART
devices

 arch/arm/mach-s5p6442/include/mach/map.h |   69 ++++++-----
 arch/arm/mach-s5p64x0/include/mach/map.h |   83 +++++++-------
 arch/arm/mach-s5pc100/include/mach/map.h |  193
+++++++++++++-----------------
 arch/arm/mach-s5pv210/include/mach/map.h |  168 +++++++++++++-------------
 arch/arm/mach-s5pv210/mach-aquila.c      |   15 ++-
 arch/arm/mach-s5pv210/mach-goni.c        |   15 ++-
 arch/arm/mach-s5pv310/include/mach/map.h |  149 +++++++++++------------
 arch/arm/plat-s5p/dev-uart.c             |   12 +-
 arch/arm/plat-samsung/dev-ts.c           |    1 -
 9 files changed, 342 insertions(+), 363 deletions(-)

