Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2A3OlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:41:20 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:55791 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab2A3OlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:41:19 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/15] several compiler warning fixes
Date: Mon, 30 Jan 2012 15:40:03 +0100
Message-Id: <1327934418-12674-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327934479;4deba2ad;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Danny Kukawka (15):
  eicon: fix -Warray-bounds warning
  max2165: trival fix for some -Wuninitialized warning
  mmc: trival fix for some -Wuninitialized warning
  vmw_balloon: trival fix for a -Wuninitialized warning
  cx18: fix handling of 'radio' module parameter
  hamradio: fix incompatible pointer in module parameter
  cpcihp: fix debug module parameter to be bool
  hdaps: trivial fix for -Wuninitialized
  ivtv-driver: fix handling of 'radio' module parameter
  spi: trivial fix for -Wuninitialized
  aic94xx: trivial fix for -Wuninitialized
  ixj: fix Wsequence-point compiler warnings
  ath5k: make ath5k_modparam_no_hw_rfkill_switch real bool
  kobil_sct: fix debug module parameter to be bool
  riva/fbdev: fix several -Wuninitialized

 drivers/isdn/hardware/eicon/capi20.h   |    2 +-
 drivers/media/common/tuners/max2165.c  |    3 +-
 drivers/media/video/cx18/cx18-driver.c |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c |    2 +-
 drivers/misc/vmw_balloon.c             |    2 +-
 drivers/mmc/card/block.c               |    2 +-
 drivers/net/hamradio/baycom_epp.c      |    2 +-
 drivers/net/hamradio/baycom_par.c      |    2 +-
 drivers/net/wireless/ath/ath5k/base.c  |    2 +-
 drivers/pci/hotplug/cpcihp_generic.c   |    2 +-
 drivers/platform/x86/hdaps.c           |    4 +-
 drivers/scsi/aic94xx/aic94xx_sds.c     |    2 +-
 drivers/spi/spi-topcliff-pch.c         |    2 +-
 drivers/telephony/ixj.c                |  194 ++++++++++++++++++--------------
 drivers/usb/serial/kobil_sct.c         |    2 +-
 drivers/video/riva/fbdev.c             |    5 +-
 16 files changed, 125 insertions(+), 105 deletions(-)

-- 
1.7.7.3

