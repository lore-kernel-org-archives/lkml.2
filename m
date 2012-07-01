Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2GASQF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46889 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173Ab2GASQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:03 -0400
Message-Id: <20120701172006.535271340@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/48] 3.2.22-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.22 release.
There are 48 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Jul  3 19:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.21 will be posted as an additional
response to this, and the diffstat can be found below.

Ben.

-------------
 Documentation/stable_kernel_rules.txt              |    6 ++
 Makefile                                           |    4 +-
 arch/arm/plat-samsung/include/plat/map-s3c.h       |    2 +-
 .../arm/plat-samsung/include/plat/watchdog-reset.h |    2 +-
 arch/x86/include/asm/cpufeature.h                  |    2 +-
 arch/x86/include/asm/pgtable-3level.h              |   54 ++++++++++++++++
 arch/x86/kernel/cpu/scattered.c                    |    2 +-
 drivers/acpi/acpi_pad.c                            |    7 ++-
 drivers/base/power/main.c                          |    6 +-
 drivers/char/hw_random/atmel-rng.c                 |    2 +-
 drivers/edac/i7core_edac.c                         |   15 ++---
 drivers/edac/sb_edac.c                             |   10 ++-
 drivers/gpu/drm/drm_edid.c                         |    2 +-
 drivers/gpu/drm/i915/i915_gem.c                    |    4 ++
 drivers/gpu/drm/i915/i915_irq.c                    |   57 +++++++++--------
 drivers/gpu/drm/i915/i915_suspend.c                |    5 +-
 drivers/gpu/drm/i915/intel_display.c               |   65 ++++++++++++++------
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   14 +----
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    2 +-
 drivers/hwmon/applesmc.c                           |    4 +-
 drivers/hwmon/coretemp.c                           |    2 +-
 drivers/md/dm-thin.c                               |    9 ++-
 drivers/media/dvb/siano/smsusb.c                   |    2 +
 drivers/media/video/gspca/gspca.c                  |    4 +-
 drivers/net/can/c_can/c_can.c                      |    4 +-
 drivers/net/can/flexcan.c                          |    4 +-
 drivers/net/ethernet/intel/e1000e/82571.c          |    3 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    8 ---
 drivers/net/wireless/ath/ath9k/hw.c                |   14 ++++-
 drivers/net/wireless/ath/ath9k/main.c              |   18 +++---
 drivers/net/wireless/ath/ath9k/xmit.c              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |    6 ++
 drivers/net/xen-netfront.c                         |    8 +--
 drivers/oprofile/oprofile_perf.c                   |    2 +-
 drivers/scsi/sd.c                                  |    2 +
 drivers/staging/iio/adc/ad7606_core.c              |    1 +
 drivers/staging/rtl8712/usb_intf.c                 |    2 +
 drivers/staging/rts_pstor/rtsx_transport.c         |   11 ++--
 drivers/usb/serial/cp210x.c                        |   11 ++++
 drivers/usb/serial/option.c                        |    8 +++
 drivers/usb/storage/scsiglue.c                     |    6 ++
 fs/exec.c                                          |    2 +-
 fs/nilfs2/gcinode.c                                |    2 +
 fs/nilfs2/segment.c                                |    2 +
 include/asm-generic/pgtable.h                      |   32 +++++++++-
 include/linux/mm_types.h                           |   10 +++
 include/scsi/scsi_device.h                         |    1 +
 kernel/exit.c                                      |    1 +
 net/batman-adv/routing.c                           |    2 +
 net/batman-adv/translation-table.c                 |    8 +--
 net/wireless/reg.c                                 |    2 +-
 sound/pci/hda/patch_realtek.c                      |    1 +
 tools/hv/hv_kvp_daemon.c                           |   10 ++-
 53 files changed, 320 insertions(+), 145 deletions(-)

-- 
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

