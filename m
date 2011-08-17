Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1HQSA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:00:56 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44772 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443Ab1HQSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:00:54 -0400
X-Sasl-enc: 90+HmDhM6vJPUNlXdY4weGMLjhewZn6HnD6JaRC3xxci 1313604047
Date: Wed, 17 Aug 2011 11:00:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.3
Message-ID: <20110817180027.GA16619@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 3.0.3 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-3.0.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-3.0.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/virtual/lguest/lguest.c      |    3 +++
 Makefile                                   |    2 +-
 drivers/gpu/drm/radeon/atombios_dp.c       |   12 ++++++++++++
 drivers/gpu/drm/radeon/radeon_connectors.c |   16 +++++++++-------
 drivers/gpu/drm/radeon/radeon_encoders.c   |    3 +++
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 +
 drivers/hwmon/ibmaem.c                     |   15 ++++++++++-----
 drivers/net/wireless/ath/ath5k/base.c      |   23 ++++++++++++++---------
 drivers/staging/rtl8192u/r819xU_firmware.c |    9 +++------
 drivers/usb/class/usbtmc.c                 |    2 +-
 drivers/usb/core/config.c                  |   11 ++++++-----
 drivers/usb/host/pci-quirks.c              |    2 +-
 drivers/usb/host/xhci.c                    |   19 ++++++++++++++-----
 drivers/usb/musb/musb_gadget.c             |    5 +++++
 drivers/usb/serial/ftdi_sio.c              |    2 +-
 drivers/usb/serial/option.c                |   12 ++++++++++++
 drivers/usb/serial/qcserial.c              |    1 +
 drivers/usb/storage/unusual_devs.h         |   10 ++++++++++
 mm/vmalloc.c                               |    7 ++++---
 net/atm/br2684.c                           |    2 --
 sound/soc/samsung/jive_wm8750.c            |    2 +-
 sound/soc/tegra/tegra_pcm.c                |    9 +++++++--
 sound/soc/tegra/tegra_wm8903.c             |   15 +++++++++++----
 sound/usb/caiaq/audio.c                    |    6 ++++--
 tools/perf/util/config.c                   |    7 -------
 25 files changed, 134 insertions(+), 62 deletions(-)
Alex Deucher (3):
      drm/radeon/kms: don't enable connectors that are off in the hotplug handler
      drm/radeon/kms: fix regression is handling >2 heads on cedar/caicos
      drm/radeon/kms: don't try to be smart in the hpd handler

Andrew Bird (4):
      USB: option driver: add PID for Vodafone-Huawei K3770
      USB: option driver: add PID for Vodafone-Huawei K3771
      USB: option driver: add PID for Vodafone-Huawei K4510
      USB: option driver: add PID for Vodafone-Huawei K4511

Bob Copeland (1):
      ath5k: fix error handling in ath5k_beacon_send

Chas Williams (1):
      atm: br2864: sent packets truncated in VC routed mode

Clemens Ladisch (1):
      mm: fix wrong vmap address calculations with odd NR_CPUS values

Daniel Mack (1):
      ALSA: snd-usb-caiaq: Correct offset fields of outbound iso_frame_desc

Greg Kroah-Hartman (1):
      Linux 3.0.3

Ionut Nicu (1):
      USB: ftdi_sio: fix minor typo in get_ftdi_divisor

JiSheng Zhang (1):
      USB: xhci: fix OS want to own HC

John Stultz (1):
      usb: musb: fix oops on musb_gadget_pullup

Jonathan Nieder (1):
      perf tools: do not look at ./config for configuration

Julia Lawall (1):
      hwmon: (ibmaem) add missing kfree

Mark Brown (1):
      ASoC: Fix binding of WM8750 on Jive

Maxim Nikulin (1):
      USB: assign instead of equal in usbtmc.c

Nick Bowler (1):
      USB: usb-storage: unusual_devs entry for ARM V2M motherboard.

Rusty Russell (1):
      lguest: allow booting guest with CONFIG_RELOCATABLE=y

Sarah Sharp (1):
      xhci: Don't submit commands or URBs to halted hosts.

Sebastian Andrzej Siewior (1):
      usb/config: use proper endian access for wMaxPacketSize

Stefan Lippers-Hollmann (1):
      staging: rtl8192u: declare MODULE_FIRMWARE

Stephen Warren (2):
      ASoC: Tegra: tegra_pcm_deallocate_dma_buffer: Don't OOPS
      ASoC: Tegra: wm8903 machine driver: Allow re-insertion of module

Vijay Chavan (1):
      USB: Serial: Added device ID for Qualcomm Modem in Sagemcom's HiLo3G

