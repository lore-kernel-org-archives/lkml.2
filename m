Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0EFHAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:00:14 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47632 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab0EFHAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:00:08 -0400
Date: Thu, 6 May 2010 15:59:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] [RESEND] sh updates for 2.6.34-rc7
Message-ID: <20100506065932.GD25493@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of the pull request for 2.6.34-rc6 with the addition of
an lcdcfb patch. It hasn't been rebased, so if you've already pulled the
previous changes then you should just get that patch.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.34

Which contains:

Guennadi Liakhovetski (3):
      SH: fix TS field shift calculation for DMA drivers
      SH: fix error paths in DMA driver
      sh: fix a number of Oopses and leaks in SH framebuffer driver

Magnus Damm (2):
      sh: Fix maximum number of SCIF ports in R2D defconfigs
      sh: sh7751 pci controller io port fix

 arch/sh/configs/rts7751r2d1_defconfig      |    2 +-
 arch/sh/configs/rts7751r2dplus_defconfig   |    2 +-
 arch/sh/drivers/pci/pci-sh7751.c           |    5 +++--
 arch/sh/include/cpu-sh4/cpu/dma-register.h |    2 +-
 drivers/dma/shdma.c                        |   27 +++++++++++++++++++++------
 drivers/video/sh_mobile_lcdcfb.c           |   27 +++++++++++++--------------
 6 files changed, 40 insertions(+), 25 deletions(-)
