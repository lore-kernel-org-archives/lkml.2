Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030607Ab2HQD0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:26:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46714 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030548Ab2HQD0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:39 -0400
Message-Id: <20120817030243.807605523@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/37] 3.2.28-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.28 release.
There are 37 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Aug 19 10:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.27 will be posted as an additional
response to this, and the diffstat can be found below.

Ben.

-------------
 Makefile                                      |    4 +-
 arch/arm/configs/mxs_defconfig                |    1 -
 arch/arm/mach-pxa/raumfeld.c                  |    2 +-
 arch/s390/kernel/compat_linux.c               |    2 -
 arch/s390/kernel/compat_wrapper.S             |    4 +-
 arch/x86/kvm/vmx.c                            |    1 +
 drivers/gpu/drm/i915/i915_drv.h               |    7 +--
 drivers/gpu/drm/i915/i915_gem.c               |   23 ++++++++
 drivers/gpu/drm/i915/intel_ringbuffer.c       |   31 ++++-------
 drivers/gpu/drm/radeon/evergreen.c            |   71 ++++---------------------
 drivers/gpu/drm/radeon/ni.c                   |   14 +++--
 drivers/gpu/drm/radeon/radeon_asic.h          |    8 +--
 drivers/gpu/drm/radeon/rv515.c                |   13 -----
 drivers/input/touchscreen/eeti_ts.c           |   21 +++++---
 drivers/mfd/ezx-pcap.c                        |    2 +-
 drivers/net/caif/caif_serial.c                |    3 ++
 drivers/net/ethernet/broadcom/bnx2.c          |    6 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c |   10 ++--
 drivers/net/ethernet/intel/e1000e/82571.c     |    4 +-
 drivers/net/tun.c                             |    7 +--
 drivers/net/usb/kaweth.c                      |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    1 +
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 drivers/net/wireless/ath/ath9k/pci.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |   13 +++--
 drivers/net/wireless/rt2x00/rt61pci.c         |    3 +-
 drivers/net/wireless/rtlwifi/usb.c            |   14 +++--
 drivers/net/wireless/rtlwifi/wifi.h           |    1 +
 fs/hfsplus/wrapper.c                          |    2 +-
 include/linux/input/eeti_ts.h                 |    1 +
 include/linux/mfd/ezx-pcap.h                  |    1 +
 net/caif/caif_dev.c                           |    2 +-
 net/core/rtnetlink.c                          |    8 ++-
 net/ipv4/cipso_ipv4.c                         |    6 ++-
 net/ipv4/tcp.c                                |    5 +-
 net/ipv4/tcp_input.c                          |    4 +-
 net/mac80211/mesh.c                           |    1 +
 net/sched/sch_sfb.c                           |    2 +
 net/sctp/input.c                              |    7 +--
 net/sctp/socket.c                             |   12 ++++-
 net/wanrouter/wanmain.c                       |   51 ++++++++----------
 net/wireless/core.c                           |    5 ++
 net/wireless/core.h                           |    1 +
 net/wireless/util.c                           |    2 +-
 sound/pci/hda/patch_conexant.c                |    1 -
 sound/pci/hda/patch_realtek.c                 |    7 ++-
 46 files changed, 191 insertions(+), 197 deletions(-)

-- 
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

