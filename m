Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0KOMlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 07:41:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38323 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0KOMlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 07:41:35 -0500
Date: Mon, 15 Nov 2010 21:41:56 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL] Samsung fixes for 2.6.37-rc2
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Message-id: <007901cb84c2$7f465a30$7dd30e90$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcuEwnxpFQxPPwmfTmSjEeZ9hJ6Q0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Samsung fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

These things are for fix build warnings on 2.6.37-rc2.
If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


The following changes since commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4:

  Linux 2.6.37-rc1 (2010-11-01 07:54:12 -0400)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

Kukjin Kim (2):
      ARM: SAMSUNG: Fix HAVE_S3C2410_I2C warnings
      ARM: SAMSUNG: Fix HAVE_S3C_RTC warnings

Kyungmin Park (1):
      ARM: SAMSUNG: Fix HAVE_S3C2410_WATCHDOG warnings

 arch/arm/Kconfig              |   32 ++++++++++++++++----------------
 arch/arm/mach-s3c64xx/Kconfig |    2 +-
 2 files changed, 17 insertions(+), 17 deletions(-)

