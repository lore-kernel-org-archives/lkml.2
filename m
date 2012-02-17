Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2BQA45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:56:57 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59646 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224Ab2BQA44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:56:56 -0500
X-Sasl-enc: B7Jdlo07K8npEoPd46KaVjpxC/F0DglAhg95Ow40ahAx 1329440214
Date: Thu, 16 Feb 2012 16:56:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/28] 3.2.7-stable review
Message-ID: <20120217005609.GA17081@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.7 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Feb 19 00:55:33 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                       |    4 +-
 arch/x86/pci/xen.c                             |    2 +-
 crypto/sha512_generic.c                        |   70 ++++++------
 drivers/gpu/drm/i915/intel_dp.c                |   20 +---
 drivers/gpu/drm/i915/intel_lvds.c              |    8 ++
 drivers/hwmon/f75375s.c                        |    4 +-
 drivers/mmc/host/atmel-mci.c                   |    3 +
 drivers/mmc/host/dw_mmc.c                      |  144 ++++++++++++-----------
 drivers/net/ethernet/intel/igb/igb_main.c      |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c |    3 +-
 drivers/net/ethernet/toshiba/Kconfig           |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c            |    7 +-
 drivers/net/wireless/ath/ath9k/init.c          |    9 +-
 drivers/net/wireless/ath/ath9k/recv.c          |    8 ++
 fs/cifs/connect.c                              |    7 +-
 fs/cifs/dir.c                                  |    2 +-
 fs/fs-writeback.c                              |   16 ++--
 include/linux/mmc/dw_mmc.h                     |    6 +-
 include/linux/proportions.h                    |    4 +
 include/trace/events/writeback.h               |    7 +-
 kernel/relay.c                                 |   10 ++-
 mm/backing-dev.c                               |   25 +++-
 net/mac80211/rx.c                              |    2 +-
 sound/pci/hda/patch_realtek.c                  |   23 ++++
 sound/pci/hda/patch_via.c                      |    3 +
 sound/pci/intel8x0.c                           |    6 +
 tools/perf/bench/mem-memcpy-x86-64-asm.S       |    6 +
 tools/perf/util/evsel.c                        |    1 +
 28 files changed, 245 insertions(+), 160 deletions(-)

