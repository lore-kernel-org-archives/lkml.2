Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1GHIv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:51:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39995 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1GHIv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:51:57 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/12] Fixing and cleaning
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:42:26 +0100
Message-ID: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanup plus fixes from other. The important one here is the gtt
Mask out bits patch.


---

Alan Cox (8):
      gma500: Fix unused variable in cdv support
      gma500; clean mid files
      gma500: tidy the mrst files
      gma500: tidy up the CDV files
      gma500: Fix symbol clash with i915
      gma500: psb_intel_lvds style
      gma500: Re-order checks and dereferences in psb_intel_lvds
      gma500: strip unneeded version headers

Dan Carpenter (3):
      gma500: remove unneeded check in mdfld_crtc_mode_set()
      gma500: reversed test in mdfld_dbi_dsr_exit()
      Staging: gma500: typo in array initialization

Patrik Jakobsson (1):
      gma500: Mask out bits not part of the page table base address


 drivers/staging/gma500/cdv_device.c           |   23 +++--
 drivers/staging/gma500/cdv_intel_crt.c        |   23 +++--
 drivers/staging/gma500/cdv_intel_display.c    |  115 ++++++++++++-------------
 drivers/staging/gma500/cdv_intel_hdmi.c       |   81 +++++++++---------
 drivers/staging/gma500/cdv_intel_lvds.c       |   20 +++-
 drivers/staging/gma500/framebuffer.h          |    1 
 drivers/staging/gma500/gtt.c                  |    2 
 drivers/staging/gma500/intel_opregion.c       |    4 -
 drivers/staging/gma500/mdfld_dsi_dbi.c        |    2 
 drivers/staging/gma500/mdfld_dsi_dbi.h        |    1 
 drivers/staging/gma500/mdfld_dsi_output.h     |    1 
 drivers/staging/gma500/mdfld_dsi_pkg_sender.c |    2 
 drivers/staging/gma500/mdfld_intel_display.c  |    2 
 drivers/staging/gma500/mid_bios.c             |   10 +-
 drivers/staging/gma500/mrst_device.c          |    4 -
 drivers/staging/gma500/psb_device.c           |    2 
 drivers/staging/gma500/psb_drv.c              |    2 
 drivers/staging/gma500/psb_drv.h              |    5 -
 drivers/staging/gma500/psb_intel_lvds.c       |   58 +++++++------
 19 files changed, 179 insertions(+), 179 deletions(-)

-- 
Signature
