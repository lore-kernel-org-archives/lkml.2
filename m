Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1DQVWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:22:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14403 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1DQVWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:22:42 -0400
Date: Mon, 18 Apr 2011 06:22:31 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL] Samsung fixes for 2.6.39-rc4
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Message-id: <008701cbfd45$94dd8f70$be98ae50$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acv9RY/dRcKHpJCBQAykPrquB91Big==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Samsung fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

These things are small fixes for 2.6.39-rc4.
If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

The following changes since commit a6360dd37e1a144ed11e6548371bade559a1e4df:

  Linux 2.6.39-rc3 (2011-04-11 17:21:51 -0700)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

Abhilash Kesavan (2):
      ARM: S5P: Remove unused s3c_pm_check_resume_pin
      ARM: SAMSUNG: Fix build failure in PM CRC check code

Maurus Cuelenaere (1):
      ARM: SAMSUNG: Fix warning 's3c_pm_show_resume_irqs' defined but not
used

 arch/arm/plat-s5p/pm.c           |   11 -----------
 arch/arm/plat-samsung/pm-check.c |    6 ------
 arch/arm/plat-samsung/pm.c       |    5 +++--
 3 files changed, 3 insertions(+), 19 deletions(-)

