Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2K1Kzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 05:55:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35224 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2K1Kzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 05:55:39 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v3 0/3] Davinci VPSS helper functions for VPFE
Date: Wed, 28 Nov 2012 16:25:31 +0530
Message-Id: <1354100134-21095-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Hi Mauro,

This patchset, was part of the DM365 capture driver series, I have split
them up and made as separate series as the capture patches will now be going
under staging and made as version V3. This patches have undergone
several reviews along with the capture driver.

I am combining the patches with the pull request so we can get them into the
3.8 kernel. Please pull these patches.If you want a separate pull request,
please let me know.

The following changes since commit c6c22955f80f2db9614b01fe5a3d1cfcd8b3d848:

  [media] dma-mapping: fix dma_common_get_sgtable() conditional compilation (2012-11-27 09:42:31 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_mauro

Manjunath Hadli (3):
      davinci: vpss: dm365: enable ISP registers
      davinci: vpss: dm365: set vpss clk ctrl
      davinci: vpss: dm365: add vpss helper functions to be used in the main driver for setting hardware parameters

 drivers/media/platform/davinci/vpss.c |   59 +++++++++++++++++++++++++++++++++
 include/media/davinci/vpss.h          |   16 +++++++++
 2 files changed, 75 insertions(+), 0 deletions(-)


-- 
1.7.4.1

