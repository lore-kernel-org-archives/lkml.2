Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1HPCsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:48:03 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53201 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab1HPCsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:48:01 -0400
X-Sasl-enc: 8SsUQsTgWkYLQN2IhCmmLtNdWqyviQFvqOn5aC22eQgj 1313462880
Date: Mon, 15 Aug 2011 19:45:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/26] 3.0.3-stable review
Message-ID: <20110816024553.GA5631@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 3.0.3 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wed, August 17, 2010, 12:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/virtual/lguest/lguest.c      |    3 +++
 Makefile                                   |    4 ++--
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
 25 files changed, 135 insertions(+), 63 deletions(-)
