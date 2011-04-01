Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1DASAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:00:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41093 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752644Ab1DASAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:00:23 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 0/9] psb: further clean up and some more fixes
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:37:38 +0100
Message-ID: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More nuking 
---

Alan Cox (9):
      gma500: psb_reset actually holds lid functions
      gma500: Set the TWOD base
      gma500: cleanup the SDVO messages
      gma500: begin tidying up the power management
      gma500: prune more unused fields
      gma500: Add a test ioctl for issuing 2D accel ops via user space
      gma500: Fix some set up bugs found by comparing driver versions
      gma500: kill some more #if 0 bits
      gma500: Another file we don't need


 drivers/staging/gma500/Makefile                 |    2 
 drivers/staging/gma500/mrst_crtc.c              |   15 
 drivers/staging/gma500/mrst_lvds.c              |   10 
 drivers/staging/gma500/psb_2d.c                 |    2 
 drivers/staging/gma500/psb_bl.c                 |    9 
 drivers/staging/gma500/psb_drv.c                |   85 +--
 drivers/staging/gma500/psb_drv.h                |  149 -----
 drivers/staging/gma500/psb_fb.c                 |   26 +
 drivers/staging/gma500/psb_gtt.c                |    6 
 drivers/staging/gma500/psb_intel_display.c      |   35 -
 drivers/staging/gma500/psb_intel_lvds.c         |   20 -
 drivers/staging/gma500/psb_intel_sdvo.c         |    4 
 drivers/staging/gma500/psb_irq.c                |  178 ++---
 drivers/staging/gma500/psb_lid.c                |   90 +++
 drivers/staging/gma500/psb_mmu.c                |   61 --
 drivers/staging/gma500/psb_powermgmt.c          |  750 +++++++----------------
 drivers/staging/gma500/psb_powermgmt.h          |   55 --
 drivers/staging/gma500/psb_reset.c              |   90 ---
 drivers/staging/gma500/psb_ttm_placement_user.h |  252 --------
 19 files changed, 497 insertions(+), 1342 deletions(-)
 create mode 100644 drivers/staging/gma500/psb_lid.c
 delete mode 100644 drivers/staging/gma500/psb_reset.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_placement_user.h

-- 

