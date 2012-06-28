Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab2F1JWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:22:18 -0400
Received: from linux-sh.org ([111.68.239.195]:53955 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab2F1JWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:22:17 -0400
Date: Thu, 28 Jun 2012 18:22:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 3.5-rc5
Message-ID: <20120628092213.GB28162@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 47b514cd476db2eca066a2ad31501b079d6c9cce:

  Merge tag 'usb-3.5-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2012-06-27 12:54:05 -0700)

are available in the git repository at:


  git://github.com/pmundt/linux-sh.git tags/sh-for-linus

for you to fetch changes up to e9bcd470d814473c31ffc5d09e249396a2196ad4:

  Merge branches 'sh/urgent' and 'sh/trivial' into sh-fixes-for-linus (2012-06-28 16:46:13 +0900)

----------------------------------------------------------------

SuperH fixes for 3.5-rc5

----------------------------------------------------------------
Guennadi Liakhovetski (1):
      sh: kfr2r09: fix compile breakage

Nobuhiro Iwamatsu (1):
      sh: Convert sh_clk_mstp32_register to sh_clk_mstp_register

Paul Mundt (1):
      Merge branches 'sh/urgent' and 'sh/trivial' into sh-fixes-for-linus

 arch/sh/boards/mach-kfr2r09/setup.c    | 4 ++--
 arch/sh/drivers/pci/pcie-sh7786.c      | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7366.c | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7734.c | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c | 2 +-
 arch/sh/kernel/cpu/sh4a/clock-shx3.c   | 2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)
