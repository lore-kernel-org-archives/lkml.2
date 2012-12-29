Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab2L2E1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 23:27:34 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56267 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2L2E13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 23:27:29 -0500
Date: Fri, 28 Dec 2012 20:27:34 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: arm-soc fixes for 3.8-rc
Message-ID: <20121229042734.GA11208@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes

for you to fetch changes up to 2e376799b2f6af2e8baeb407b6437a4d7b650ac0:

  Merge tag 'sunxi-fixes-for-3.8-rc2' of git://github.com/mripard/linux into fixes (2012-12-28 08:53:01 +0100)

----------------------------------------------------------------

ARM: arm-soc: fixes for -rc2

It's been quiet over the holidays, but we have had a couple of trivial
fixes coming in for the newly introduced sunxi platform; one to add it
to the multiplatform defconfig for build coverage, and one fixup for
device tree strings.

----------------------------------------------------------------
Maxime Ripard (2):
      ARM: multi_v7_defconfig: Add ARCH_SUNXI
      sunxi: Change the machine compatible string.

Olof Johansson (1):
      Merge tag 'sunxi-fixes-for-3.8-rc2' of git://github.com/mripard/linux into fixes

 arch/arm/configs/multi_v7_defconfig | 1 +
 arch/arm/mach-sunxi/sunxi.c         | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)
