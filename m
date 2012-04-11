Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455Ab2DKXTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:19:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56408 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DKXTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:19:43 -0400
Date: Wed, 11 Apr 2012 16:14:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/42] 3.0.28-stable review
Message-ID: <20120411231443.GA808@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.28 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Apr 13 23:13:06 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.28-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                             |    4 +-
 arch/m68k/mac/config.c               |    3 +
 arch/x86/include/asm/timer.h         |    8 +-
 arch/x86/kernel/amd_iommu_init.c     |   24 +++--
 arch/x86/kernel/apic/io_apic.c       |   40 ++-------
 arch/x86/kernel/kgdb.c               |   60 +++++++++++++
 arch/x86/kernel/tsc.c                |    3 +-
 arch/x86/net/bpf_jit_comp.c          |    2 +-
 arch/x86/pci/acpi.c                  |   10 +++
 drivers/acpi/acpica/tbfadt.c         |    8 +-
 drivers/acpi/processor_thermal.c     |   45 ++++++++--
 drivers/gpu/drm/drm_fb_helper.c      |    8 +-
 drivers/gpu/drm/i915/i915_drv.c      |    2 +
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_bios.c    |   23 ++++-
 drivers/gpu/drm/i915/intel_display.c |    6 ++
 drivers/gpu/drm/i915/intel_lvds.c    |    8 ++
 drivers/gpu/drm/radeon/atom.c        |   15 +++-
 drivers/gpu/drm/radeon/atom.h        |    1 +
 drivers/mfd/twl6030-irq.c            |   13 ++-
 drivers/misc/kgdbts.c                |  160 ++++++++++++++++++++++++----------
 drivers/mmc/host/atmel-mci.c         |    9 +-
 drivers/mtd/devices/block2mtd.c      |    1 +
 drivers/mtd/devices/lart.c           |    1 +
 drivers/mtd/devices/m25p80.c         |    1 +
 drivers/mtd/devices/sst25l.c         |    1 +
 drivers/net/usb/cdc_eem.c            |    1 +
 drivers/net/usb/zaurus.c             |    5 ++
 drivers/platform/x86/acer-wmi.c      |    1 +
 drivers/pnp/pnpacpi/core.c           |    7 +-
 include/linux/kernel.h               |   13 +++
 include/linux/kgdb.h                 |    7 +-
 kernel/cred.c                        |    2 +
 kernel/debug/debug_core.c            |   53 +++++------
 kernel/irq/migration.c               |   10 ++-
 kernel/sysctl.c                      |    8 +-
 kernel/trace/trace_entries.h         |   16 +++-
 kernel/trace/trace_export.c          |    2 +-
 net/bluetooth/hci_conn.c             |    4 +
 net/mac80211/agg-rx.c                |    3 +-
 net/rose/rose_dev.c                  |    4 +-
 scripts/mod/modpost.c                |   36 +++++++-
 scripts/mod/modpost.h                |    1 +
 security/tomoyo/mount.c              |   38 ++++----
 sound/soc/codecs/ak4642.c            |    2 +-
 45 files changed, 487 insertions(+), 183 deletions(-)

