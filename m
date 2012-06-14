Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2FNX4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:56:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2FNX4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:56:41 -0400
Date: Thu, 14 Jun 2012 16:56:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/42] 3.4.3-stable review
Message-ID: <20120614235636.GA5275@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.3 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jun 16 23:56:22 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                      |    4 +-
 arch/powerpc/kernel/module_32.c               |   11 ++-
 arch/powerpc/kernel/time.c                    |   14 +++-
 arch/x86/crypto/aesni-intel_asm.S             |    6 +-
 arch/x86/include/asm/uv/uv_bau.h              |    1 -
 arch/x86/kernel/cpu/mcheck/mce_amd.c          |   56 ++++++++++---
 arch/x86/platform/uv/tlb_uv.c                 |    1 -
 drivers/acpi/video.c                          |    5 +-
 drivers/ata/ata_piix.c                        |   36 +++++++++
 drivers/ata/libata-core.c                     |    6 ++
 drivers/bcma/driver_chipcommon_pmu.c          |    4 +-
 drivers/bcma/sprom.c                          |    4 +-
 drivers/char/agp/intel-agp.c                  |    1 +
 drivers/char/agp/intel-agp.h                  |    1 +
 drivers/char/hw_random/atmel-rng.c            |    7 ++
 drivers/gpu/drm/gma500/psb_drv.c              |    2 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c       |    5 ++
 drivers/gpu/drm/nouveau/nouveau_connector.c   |    8 +-
 drivers/gpu/drm/radeon/evergreen_cs.c         |   49 +++++++++++-
 drivers/gpu/drm/radeon/radeon_drv.c           |    3 +-
 drivers/gpu/drm/ttm/ttm_bo.c                  |   13 +--
 drivers/net/can/c_can/c_can.c                 |   16 ++--
 drivers/net/can/c_can/c_can.h                 |    1 +
 drivers/net/usb/sierra_net.c                  |   14 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |    3 +
 drivers/net/wireless/iwlwifi/iwl-prph.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    5 ++
 drivers/net/wireless/rt2x00/rt2800usb.c       |   25 ++++--
 drivers/net/wireless/rt2x00/rt2x00.h          |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c       |    1 -
 drivers/net/wireless/rt2x00/rt2x00queue.c     |   13 ++-
 fs/btrfs/inode.c                              |    5 +-
 fs/ext4/balloc.c                              |    8 +-
 fs/fuse/dir.c                                 |    1 +
 fs/fuse/fuse_i.h                              |    3 +
 fs/fuse/inode.c                               |   17 +++-
 include/linux/libata.h                        |    1 +
 include/linux/moduleparam.h                   |   10 +--
 init/main.c                                   |    2 +-
 kernel/sched/core.c                           |    9 +--
 kernel/time/timekeeping.c                     |    2 +
 lib/btree.c                                   |    4 +-
 net/mac80211/iface.c                          |   12 +++
 net/mac80211/offchannel.c                     |   16 ++++
 net/mac80211/sta_info.c                       |    4 +-
 net/mac80211/util.c                           |    2 +-
 net/wireless/util.c                           |   19 ++++-
 sound/pci/hda/patch_realtek.c                 |    9 +++
 sound/soc/codecs/wm8994.c                     |  105 ++++++++++++++++---------
 50 files changed, 408 insertions(+), 142 deletions(-)

