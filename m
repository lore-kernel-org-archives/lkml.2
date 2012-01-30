Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2A3WAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:00:44 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45876 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab2A3WAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:00:40 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 00/16] some compiler warning fixes
Date: Mon, 30 Jan 2012 23:00:04 +0100
Message-Id: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327960840;836e2fd0;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend due to problems with suppressed CC list and misconfigured
git-send-email. Sorry.

For some of the patches I send new reworked/fixed versions (v2)
with this series.

Danny Kukawka (16):
  eicon: fix -Warray-bounds warning
  max2165: trival fix for some -Wuninitialized warning
  mmc: fix for some -Wuninitialized warning
  vmw_balloon: fix for a -Wuninitialized warning
  cx18: fix handling of 'radio' module parameter
  cpcihp: fix debug module parameter to be bool
  hdaps: trivial fix for -Wuninitialized
  ivtv-driver: fix handling of 'radio' module parameter
  [RFC] aic94xx: fix for -Wuninitialized
  ixj: fix Wsequence-point compiler warnings
  ath5k: make ath5k_modparam_no_hw_rfkill_switch real
  kobil_sct: fix debug module parameter to be bool
  riva/fbdev: fix several -Wuninitialized
  hamradio: fix incompatible pointer in module parameter
  leds-lp5521: fix compiler warning
  leds-lp5523: fix compiler warning

 drivers/isdn/hardware/eicon/capi20.h   |    2 +-
 drivers/leds/leds-lp5521.c             |   14 ++-
 drivers/leds/leds-lp5523.c             |   17 ++-
 drivers/media/common/tuners/max2165.c  |    9 +-
 drivers/media/video/cx18/cx18-driver.c |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c |    4 +-
 drivers/misc/vmw_balloon.c             |   14 +-
 drivers/mmc/card/block.c               |    3 +-
 drivers/net/hamradio/baycom_epp.c      |    2 +-
 drivers/net/hamradio/baycom_par.c      |    2 +-
 drivers/net/wireless/ath/ath5k/base.c  |    2 +-
 drivers/pci/hotplug/cpcihp_generic.c   |    2 +-
 drivers/platform/x86/hdaps.c           |    4 +-
 drivers/scsi/aic94xx/aic94xx_sds.c     |    2 +-
 drivers/telephony/ixj.c                |  194 ++++++++++++++++++--------------
 drivers/usb/serial/kobil_sct.c         |    2 +-
 drivers/video/riva/fbdev.c             |    5 +-
 17 files changed, 161 insertions(+), 119 deletions(-)

-- 
1.7.7.3

