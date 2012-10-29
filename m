Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab2J2V6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:58:01 -0400
Received: from mail.kernel.org ([198.145.19.201]:48353 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761418Ab2J2VlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: =?UTF-8?q?=5B=2000/54=5D=203=2E4=2E17-stable=20review?=
Date: Mon, 29 Oct 2012 14:40:01 -0700
Message-Id: <20121029213802.697479610@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.17 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Oct 31 21:37:26 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.17-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.17-rc1

Sjoerd Simons <sjoerd.simons@collabora.co.uk>
    drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13

Yinghai Lu <yinghai@kernel.org>
    x86, mm: Use memblock memory loop instead of e820_RAM

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: amplc_pc236: fix invalid register access during detach

Olof Johansson <olof@lixom.net>
    x86: efi: Turn off efi_enabled after setup on mixed fw/kernel

Josh Triplett <josh@joshtriplett.org>
    efi: Defer freeing boot services memory until after ACPI init

Yinghai Lu <yinghai@kernel.org>
    x86, mm: Undo incorrect revert in arch/x86/mm/init.c

Jacob Shin <jacob.shin@amd.com>
    x86, mm: Find_early_table_space based on ranges that are actually being mapped

Felix Fietkau <nbd@openwrt.org>
    Revert "ath9k_hw: Updated AR9003 tx gain table for 5GHz"

Andreas Herrmann <andreas.herrmann3@amd.com>
    cpufreq / powernow-k8: Remove usage of smp_processor_id() in preemptible code

Piotr Haber <phaber@broadcom.com>
    bcma: fix unregistration of cores

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()

Barry Song <Baohua.Song@csr.com>
    dmaengine: sirf: fix a typo in moving running dma_desc to active queue

Barry Song <Baohua.Song@csr.com>
    dmaengine: sirf: fix a typo in dma_prep_interleaved

Oleg Nesterov <oleg@redhat.com>
    freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: SMP: Fix setting unknown auth_req bits

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: check if key has TKIP type before updating IV

Ivan Shugov <ivan.shugov@gmail.com>
    ARM: at91: at91sam9g10: fix SOC type detection

Bo Shen <voice.shen@atmel.com>
    ARM: at91/i2c: change id to let i2c-gpio work

Josh Wu <josh.wu@atmel.com>
    ARM: at91/tc: fix typo in the DT document

Heiko Stuebner <heiko@sntech.de>
    ARM: SAMSUNG: Add naming of s3c64xx-spi devices

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix mergeable bufs on BE hosts

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: remove invalid disconnect handling

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: remove NULL-urb submission

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix port-device leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix urb leak at release

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix memory leak in probe error path

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix memory leak in attach error path

Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
    USB: serial: Fix memory leak in sierra_release()

Johan Hovold <jhovold@gmail.com>
    USB: opticon: fix memory leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: opticon: fix DMA from stack

Johan Hovold <jhovold@gmail.com>
    USB: whiteheat: fix memory leak in error path

Octavian Purdila <octavian.purdila@intel.com>
    usb hub: send clear_tt_buffer_complete events when canceling TT clear work

Michael Shigorin <mike@osdn.org.ua>
    usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Anisse Astier <anisse@astier.eu>
    ehci: Add yet-another Lucid nohandoff pci quirk

Anisse Astier <anisse@astier.eu>
    ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS versions

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: Cleanup error handling in vmbus_open()

Arve Hjønnevåg <arve@android.com>
    Staging: android: binder: Allow using highmem for binder buffers

Arve Hjønnevåg <arve@android.com>
    Staging: android: binder: Fix memory leak on thread/process exit

Geert Uytterhoeven <geert@linux-m68k.org>
    sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix potential NULL ptr deref in command cancellation.

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Prevent races in xs_abort_connection()

Trond Myklebust <Trond.Myklebust@netapp.com>
    Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Get rid of the xs_error_report socket callback

Jan Kara <jack@suse.cz>
    mm: fix XFS oops due to dirty pages without buffers on s390

Yinghai Lu <yinghai@kernel.org>
    x86, mm: Trim memory in memblock to be page aligned

Will Deacon <will.deacon@arm.com>
    ARM: 7559/1: smp: switch away from the idmap before updating init_mm.mm_count

Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
    genalloc: stop crashing the system when destroying a pool

Jan Luebbe <jlu@pengutronix.de>
    drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Kees Cook <keescook@chromium.org>
    fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Kees Cook <keescook@chromium.org>
    gen_init_cpio: avoid stack overflow when expanding

Stefán Freyr <stefan.freyr@gmail.com>
    ALSA: hda - add dock support for Thinkpad T430

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add error output if VM CS fails on cayman

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add some new SI PCI ids


-------------

Diffstat:

 .../devicetree/bindings/arm/atmel-at91.txt         |   2 +-
 Makefile                                           |   4 +-
 arch/arm/kernel/smp.c                              |  14 +-
 arch/arm/mach-at91/at91rm9200_devices.c            |   2 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |   2 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |   2 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |   2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |   2 +-
 arch/arm/mach-at91/setup.c                         |   2 +-
 arch/arm/mach-exynos/common.c                      |   5 +
 arch/arm/mach-s3c24xx/s3c2416.c                    |   2 +
 arch/arm/mach-s3c24xx/s3c2443.c                    |   4 +
 arch/arm/mach-s5p64x0/common.c                     |   3 +
 arch/arm/mach-s5pc100/common.c                     |   3 +
 arch/arm/mach-s5pv210/common.c                     |   3 +
 arch/arm/plat-samsung/include/plat/spi-core.h      |  30 ++++
 arch/x86/include/asm/efi.h                         |   1 +
 arch/x86/kernel/e820.c                             |   3 +
 arch/x86/kernel/setup.c                            |  27 +++-
 arch/x86/mm/init.c                                 |  69 +++++----
 arch/x86/platform/efi/efi.c                        |  43 +++---
 drivers/bcma/main.c                                |   5 +-
 drivers/cpufreq/powernow-k8.c                      |   9 +-
 drivers/dma/imx-dma.c                              |   4 +-
 drivers/dma/sirf-dma.c                             |   4 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   8 +
 drivers/gpu/drm/radeon/evergreen_cs.c              |   1 +
 drivers/hv/channel.c                               |  24 +--
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   | 164 ++++++++++-----------
 drivers/rtc/rtc-imxdi.c                            |   2 +
 drivers/staging/android/binder.c                   |  30 +++-
 drivers/staging/comedi/drivers/amplc_pc236.c       |   2 +-
 drivers/usb/core/hub.c                             |   7 +-
 drivers/usb/host/pci-quirks.c                      |   9 +-
 drivers/usb/host/xhci-ring.c                       |  11 ++
 drivers/usb/serial/mos7840.c                       |  30 +---
 drivers/usb/serial/opticon.c                       |  11 +-
 drivers/usb/serial/sierra.c                        |  26 +++-
 drivers/usb/serial/whiteheat.c                     |   1 +
 drivers/usb/storage/unusual_devs.h                 |   6 +
 drivers/vhost/net.c                                |   3 +-
 fs/compat_ioctl.c                                  |   2 +
 fs/exec.c                                          |   3 +-
 fs/sysfs/dir.c                                     |  16 +-
 include/drm/drm_pciids.h                           |   3 +
 include/linux/efi.h                                |   5 +
 include/linux/memblock.h                           |   1 +
 init/main.c                                        |   3 +
 lib/genalloc.c                                     |   2 +-
 mm/memblock.c                                      |  24 +++
 mm/rmap.c                                          |  20 ++-
 net/bluetooth/smp.c                                |   6 +-
 net/mac80211/wpa.c                                 |   3 +-
 net/sunrpc/xprtsock.c                              |  41 ++----
 sound/pci/hda/patch_realtek.c                      |   1 +
 usr/gen_init_cpio.c                                |  43 +++---
 56 files changed, 469 insertions(+), 286 deletions(-)


