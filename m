Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039Ab2J2VgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:36:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:46956 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab2J2VgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: =?UTF-8?q?=5B=20000/101=5D=203=2E6=2E5-stable=20review?=
Date: Mon, 29 Oct 2012 14:34:13 -0700
Message-Id: <20121029213240.128426598@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.6.5 release.
There are 101 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Oct 31 21:31:45 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.6.5-rc1

Peng Tao <bergwolf@gmail.com>
    pnfsblock: fix non-aligned DIO write

Peng Tao <bergwolf@gmail.com>
    pnfsblock: fix non-aligned DIO read

Yinghai Lu <yinghai@kernel.org>
    x86, mm: Use memblock memory loop instead of e820_RAM

Olof Johansson <olof@lixom.net>
    x86: efi: Turn off efi_enabled after setup on mixed fw/kernel

Josh Triplett <josh@joshtriplett.org>
    efi: Defer freeing boot services memory until after ACPI init

Stanislaw Gruszka <sgruszka@redhat.com>
    cfg80211/mac80211: avoid state mishmash on deauth

Yinghai Lu <yinghai@kernel.org>
    x86, mm: Undo incorrect revert in arch/x86/mm/init.c

Jacob Shin <jacob.shin@amd.com>
    x86, mm: Find_early_table_space based on ranges that are actually being mapped

Felix Fietkau <nbd@openwrt.org>
    Revert "ath9k_hw: Updated AR9003 tx gain table for 5GHz"

Andreas Herrmann <andreas.herrmann3@amd.com>
    cpufreq / powernow-k8: Remove usage of smp_processor_id() in preemptible code

Stanislav Yakovlev <stas.yakovlev@gmail.com>
    net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_tx()

Piotr Haber <phaber@broadcom.com>
    bcma: fix unregistration of cores

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix 6000 series channel switch command

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()

Barry Song <Baohua.Song@csr.com>
    dmaengine: sirf: fix a typo in moving running dma_desc to active queue

Barry Song <Baohua.Song@csr.com>
    dmaengine: sirf: fix a typo in dma_prep_interleaved

Oleg Nesterov <oleg@redhat.com>
    freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD

Dan Williams <dcbw@redhat.com>
    qmi_wwan/cdc_ether: move Novatel 551 and E362 to qmi_wwan

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: SMP: Fix setting unknown auth_req bits

Chris Metcalf <cmetcalf@tilera.com>
    tilegx: fix some issues in the SW TSO support

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix oops on unload when firmware not found

Felix Fietkau <nbd@openwrt.org>
    mac80211: use ieee80211_free_txskb in a few more places

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: check if key has TKIP type before updating IV

Johannes Berg <johannes.berg@intel.com>
    mac80211: connect with HT20 if HT40 is not permitted

Nicolas Ferre <nicolas.ferre@atmel.com>
    ARM: at91: fix external interrupt specification in board code

Nicolas Ferre <nicolas.ferre@atmel.com>
    ARM: at91: fix external interrupts in non-DT case

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
    USB: sierra: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix memory leak in probe error path

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix memory leak in attach error path

Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
    USB: serial: Fix memory leak in sierra_release()

Johan Hovold <jhovold@gmail.com>
    USB: quatech2: fix io after disconnect

Johan Hovold <jhovold@gmail.com>
    USB: quatech2: fix close and disconnect urb handling

Johan Hovold <jhovold@gmail.com>
    USB: quatech2: fix port-data memory leaks

Johan Hovold <jhovold@gmail.com>
    USB: quatech2: fix memory leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: metro-usb: fix io after disconnect

Johan Hovold <jhovold@gmail.com>
    USB: metro-usb: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: opticon: fix memory leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: opticon: fix DMA from stack

Johan Hovold <jhovold@gmail.com>
    USB: whiteheat: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: whiteheat: fix memory leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: qcserial: fix interface-data memory leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: omninet: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: keyspan: fix NULL-pointer dereferences and memory leaks

Johan Hovold <jhovold@gmail.com>
    USB: option: fix interface-data memory leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: mct_u232: fix broken close

Johan Hovold <jhovold@gmail.com>
    USB: mct_u232: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: ipw: fix interface-data memory leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: digi_acceleport: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: ch341: fix port-data memory leak

Octavian Purdila <octavian.purdila@intel.com>
    usb hub: send clear_tt_buffer_complete events when canceling TT clear work

Johan Hovold <jhovold@gmail.com>
    USB: usb-wwan: fix multiple memory leaks in error paths

Michael Shigorin <mike@osdn.org.ua>
    usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Anisse Astier <anisse@astier.eu>
    ehci: Add yet-another Lucid nohandoff pci quirk

Anisse Astier <anisse@astier.eu>
    ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS versions

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: Cleanup error handling in vmbus_open()

Peter Huewe <peterhuewe@gmx.de>
    extcon: unregister compat link on cleanup

Peter Huewe <peterhuewe@gmx.de>
    extcon: Unregister compat class at module unload to fix oops

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: amplc_pc236: fix possible NULL deref during detach

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: amplc_pc236: fix invalid register access during detach

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: amplc_pc263: fix possible NULL deref during detach

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: amplc_dio200: fix possible NULL deref during detach

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_labpc: fix possible NULL deref during detach

Fred Brooks <nsaspook@nsaspook.com>
    staging: comedi: ni_daq_700: fix dio subdevice regression

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das08: fix possible NULL deref during detach

Nitin Gupta <ngupta@vflare.org>
    staging: zram: Fix handling of incompressible pages

Arve Hjønnevåg <arve@android.com>
    Staging: android: binder: Allow using highmem for binder buffers

Arve Hjønnevåg <arve@android.com>
    Staging: android: binder: Fix memory leak on thread/process exit

Geert Uytterhoeven <geert@linux-m68k.org>
    sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Oliver Neukum <oliver@neukum.org>
    xhci: endianness xhci_calculate_intel_u2_timeout

Oliver Neukum <oliver@neukum.org>
    xhci: fix integer overflow

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix potential NULL ptr deref in command cancellation.

Trond Myklebust <Trond.Myklebust@netapp.com>
    LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Prevent races in xs_abort_connection()

Trond Myklebust <Trond.Myklebust@netapp.com>
    LOCKD: fix races in nsm_client_get

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

Dave Young <dyoung@redhat.com>
    Revert "x86/mm: Fix the size calculation of mapping tables"

Jan Beulich <JBeulich@suse.com>
    x86-64: Fix page table accounting

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

Linus Torvalds <torvalds@linux-foundation.org>
    VFS: don't do protected {sym,hard}links by default

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix silent headphone output from Toshiba P200

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
 arch/arm/mach-at91/board-neocore926.c              |   2 +-
 arch/arm/mach-at91/board-sam9261ek.c               |   2 +-
 arch/arm/mach-at91/board-sam9263ek.c               |   2 +-
 arch/arm/mach-at91/generic.h                       |   3 +-
 arch/arm/mach-at91/irq.c                           |   9 +-
 arch/arm/mach-at91/setup.c                         |   4 +-
 arch/arm/mach-exynos/common.c                      |   5 +
 arch/arm/mach-s3c24xx/s3c2416.c                    |   2 +
 arch/arm/mach-s3c24xx/s3c2443.c                    |   4 +
 arch/arm/mach-s5p64x0/common.c                     |   3 +
 arch/arm/mach-s5pc100/common.c                     |   3 +
 arch/arm/mach-s5pv210/common.c                     |   3 +
 arch/arm/plat-samsung/include/plat/spi-core.h      |  30 ++++
 arch/x86/include/asm/efi.h                         |   1 +
 arch/x86/kernel/e820.c                             |   3 +
 arch/x86/kernel/setup.c                            |  27 ++-
 arch/x86/mm/init.c                                 |  58 ++++---
 arch/x86/mm/init_64.c                              |   7 +-
 arch/x86/platform/efi/efi.c                        |  43 +++--
 drivers/bcma/main.c                                |   5 +-
 drivers/cpufreq/powernow-k8.c                      |   9 +-
 drivers/dma/imx-dma.c                              |   4 +-
 drivers/dma/sirf-dma.c                             |   4 +-
 drivers/extcon/extcon_class.c                      |   7 +
 drivers/gpu/drm/radeon/evergreen_cs.c              |   1 +
 drivers/hv/channel.c                               |  24 +--
 drivers/net/ethernet/tile/tilegx.c                 |  35 ++--
 drivers/net/usb/cdc_ether.c                        |  41 +++--
 drivers/net/usb/qmi_wwan.c                         |  14 ++
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   | 164 +++++++++---------
 drivers/net/wireless/b43/main.c                    |   4 +
 drivers/net/wireless/ipw2x00/ipw2200.c             |   2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c         |  39 +++--
 drivers/rtc/rtc-imxdi.c                            |   2 +
 drivers/staging/android/binder.c                   |  30 +++-
 drivers/staging/comedi/drivers/amplc_dio200.c      |   2 +
 drivers/staging/comedi/drivers/amplc_pc236.c       |   6 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |   3 +
 drivers/staging/comedi/drivers/das08.c             |   2 +
 drivers/staging/comedi/drivers/ni_daq_700.c        |   2 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |   2 +
 drivers/staging/zram/zram_drv.c                    |  12 +-
 drivers/usb/core/hub.c                             |   7 +-
 drivers/usb/host/pci-quirks.c                      |   9 +-
 drivers/usb/host/xhci-ring.c                       |  11 ++
 drivers/usb/host/xhci.c                            |   4 +-
 drivers/usb/serial/ch341.c                         |  23 ++-
 drivers/usb/serial/digi_acceleport.c               | 117 +++++++------
 drivers/usb/serial/ipw.c                           |   7 +-
 drivers/usb/serial/keyspan.c                       | 183 ++++++++++-----------
 drivers/usb/serial/keyspan.h                       |   8 +
 drivers/usb/serial/mct_u232.c                      |  59 ++++---
 drivers/usb/serial/metro-usb.c                     |  65 +++-----
 drivers/usb/serial/mos7720.c                       |  62 +++----
 drivers/usb/serial/mos7840.c                       |  30 +---
 drivers/usb/serial/omninet.c                       |  36 ++--
 drivers/usb/serial/opticon.c                       |  11 +-
 drivers/usb/serial/option.c                        |  23 ++-
 drivers/usb/serial/qcserial.c                      |  33 ++--
 drivers/usb/serial/quatech2.c                      | 135 +++++++--------
 drivers/usb/serial/sierra.c                        | 133 +++++++--------
 drivers/usb/serial/usb-wwan.h                      |   2 +-
 drivers/usb/serial/usb_wwan.c                      | 130 ++++++---------
 drivers/usb/serial/whiteheat.c                     |  60 +++----
 drivers/usb/storage/unusual_devs.h                 |   6 +
 drivers/vhost/net.c                                |   3 +-
 fs/compat_ioctl.c                                  |   2 +
 fs/exec.c                                          |   3 +-
 fs/lockd/mon.c                                     |  57 ++++---
 fs/namei.c                                         |   4 +-
 fs/nfs/blocklayout/blocklayout.c                   |  93 ++++++++---
 fs/sysfs/dir.c                                     |  16 +-
 include/drm/drm_pciids.h                           |   3 +
 include/linux/efi.h                                |   5 +
 include/linux/memblock.h                           |   1 +
 include/net/cfg80211.h                             |   1 +
 init/main.c                                        |   3 +
 lib/genalloc.c                                     |   2 +-
 mm/memblock.c                                      |  24 +++
 mm/rmap.c                                          |  20 ++-
 net/bluetooth/smp.c                                |   6 +-
 net/mac80211/iface.c                               |   2 +-
 net/mac80211/mlme.c                                |  35 ++--
 net/mac80211/sta_info.c                            |   4 +-
 net/mac80211/util.c                                |   4 +-
 net/mac80211/wpa.c                                 |   3 +-
 net/sunrpc/xprtsock.c                              |  41 ++---
 net/wireless/mlme.c                                |  12 +-
 sound/pci/hda/patch_realtek.c                      |  20 ++-
 usr/gen_init_cpio.c                                |  43 ++---
 98 files changed, 1255 insertions(+), 961 deletions(-)


