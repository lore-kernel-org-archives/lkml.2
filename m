Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0JZAic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:38:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55230 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0JZAi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:38:29 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 0/8] staging: tidspbridge - misc fixes
Date: Mon, 25 Oct 2010 19:51:38 -0500
Message-Id: <1288054306-4361-1-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches fix some issues found in lastest tree.

Fernando Guzman Lugo (8):
  staging: tidspbridge - remove req_addr from proc_map
  staging: tidspbridge - add kconfig parameter for DMM size
  staging: tidspbridge - change mmufault tasklet to a workqueue
  staging: tidspbridge - fix timeout in dsp_gpt_wait_overflow
  staging: tidspbridge - use GTP7 for DSP stack dump
  staging: tidspbridge - remove disabling twl when printing DSP stack
  staging: tidspbridge - fix some issues after iommu patches
  staging: tidspbridge - make sync_wait_on_event interruptible

 drivers/staging/tidspbridge/Kconfig                |    8 +++
 drivers/staging/tidspbridge/core/dsp-clock.c       |   13 +++--
 drivers/staging/tidspbridge/core/dsp-mmu.c         |   55 +++++++++++---------
 drivers/staging/tidspbridge/core/tiomap3430.c      |   20 ++++++-
 .../staging/tidspbridge/include/dspbridge/clk.h    |    4 +-
 .../tidspbridge/include/dspbridge/dsp-mmu.h        |    3 +
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |    1 -
 .../staging/tidspbridge/include/dspbridge/proc.h   |    3 -
 .../staging/tidspbridge/include/dspbridge/sync.h   |   13 ++++-
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    2 +-
 drivers/staging/tidspbridge/rmgr/node.c            |    4 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |   25 ++++-----
 12 files changed, 95 insertions(+), 56 deletions(-)

