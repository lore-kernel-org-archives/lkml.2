Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356Ab0COQTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:19:00 -0400
Received: from kroah.org ([198.145.64.141]:34690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965237Ab0COQS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:18:57 -0400
Date: Mon, 15 Mar 2010 09:17:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.10
Message-ID: <20100315161748.GA22091@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.10 kernel.

All users of the 2.6.32 kernel series should upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt     |    7 
 Makefile                                |    2 
 arch/Kconfig                            |    2 
 arch/ia64/include/asm/acpi.h            |    1 
 arch/sparc/include/asm/io_32.h          |    2 
 arch/sparc/include/asm/page_32.h        |    2 
 arch/sparc/include/asm/stat.h           |    4 
 arch/sparc/kernel/central.c             |    4 
 arch/sparc/kernel/process_32.c          |    2 
 arch/sparc/kernel/process_64.c          |    8 
 arch/sparc/kernel/signal32.c            |   10 
 arch/sparc/kernel/signal_32.c           |    6 
 arch/sparc/kernel/signal_64.c           |    8 
 arch/sparc/kernel/tsb.S                 |    6 
 arch/x86/ia32/ia32_aout.c               |    1 
 arch/x86/include/asm/io_apic.h          |    1 
 arch/x86/include/asm/pgalloc.h          |    5 
 arch/x86/kernel/acpi/boot.c             |   17 
 arch/x86/kernel/apic/io_apic.c          |   68 +-
 arch/x86/kernel/reboot.c                |    8 
 arch/x86/kvm/emulate.c                  |   55 +
 arch/x86/mm/pgtable.c                   |   31 
 arch/x86/oprofile/nmi_int.c             |   17 
 arch/x86/oprofile/op_model_amd.c        |   42 -
 arch/x86/oprofile/op_model_p4.c         |    6 
 arch/x86/oprofile/op_model_ppro.c       |    6 
 arch/x86/xen/enlighten.c                |    7 
 arch/x86/xen/mmu.c                      |   11 
 drivers/acpi/processor_idle.c           |   28 
 drivers/acpi/tables.c                   |    4 
 drivers/ata/ahci.c                      |   12 
 drivers/ata/pata_hpt3x2n.c              |   20 
 drivers/base/core.c                     |   13 
 drivers/base/devtmpfs.c                 |   13 
 drivers/char/tpm/tpm_tis.c              |   10 
 drivers/char/tty_ldisc.c                |   50 -
 drivers/clocksource/sh_cmt.c            |   32 -
 drivers/clocksource/sh_mtu2.c           |    6 
 drivers/clocksource/sh_tmu.c            |    6 
 drivers/gpio/wm831x-gpio.c              |   22 
 drivers/gpu/drm/i915/intel_display.c    |    2 
 drivers/gpu/drm/i915/intel_lvds.c       |    7 
 drivers/gpu/drm/i915/intel_sdvo.c       |   23 
 drivers/gpu/drm/i915/intel_tv.c         |    2 
 drivers/gpu/drm/radeon/r600.c           |   13 
 drivers/gpu/drm/radeon/r600_cs.c        |   83 ++
 drivers/gpu/drm/radeon/r600d.h          |   26 
 drivers/gpu/drm/radeon/radeon.h         |    1 
 drivers/gpu/drm/radeon/radeon_cs.c      |    1 
 drivers/gpu/drm/radeon/radeon_display.c |    6 
 drivers/gpu/drm/radeon/rv770.c          |   13 
 drivers/gpu/drm/ttm/ttm_tt.c            |   18 
 drivers/hid/hid-core.c                  |    2 
 drivers/hid/hid-ids.h                   |    7 
 drivers/hid/usbhid/hid-core.c           |   28 
 drivers/hid/usbhid/hid-quirks.c         |    1 
 drivers/hid/usbhid/usbhid.h             |    2 
 drivers/hwmon/ams/ams-core.c            |   11 
 drivers/hwmon/ams/ams-i2c.c             |    2 
 drivers/hwmon/ams/ams-pmu.c             |    2 
 drivers/hwmon/ams/ams.h                 |    1 
 drivers/hwmon/tmp421.c                  |   20 
 drivers/macintosh/therm_adt746x.c       |   34 -
 drivers/md/dm.c                         |    4 
 drivers/media/dvb/dvb-core/dvb_net.c    |    1 
 drivers/media/dvb/dvb-usb/Kconfig       |    2 
 drivers/media/dvb/frontends/l64781.c    |    4 
 drivers/media/video/bt8xx/bttv-driver.c |    1 
 drivers/media/video/bt8xx/bttv-i2c.c    |    8 
 drivers/media/video/bt8xx/bttvp.h       |    1 
 drivers/media/video/gspca/mr97310a.c    |    6 
 drivers/media/video/pwc/pwc-ctrl.c      |    2 
 drivers/media/video/uvc/uvc_ctrl.c      |    7 
 drivers/mmc/host/s3cmci.c               |    2 
 drivers/net/ks8851_mll.c                |    4 
 drivers/net/sky2.c                      |    8 
 drivers/net/via-rhine.c                 |   41 -
 drivers/net/wireless/airo.c             |   34 -
 drivers/net/wireless/ath/ath5k/ath5k.h  |    1 
 drivers/net/wireless/ath/ath5k/base.c   |   26 
 drivers/net/wireless/ath/ath9k/beacon.c |    9 
 drivers/net/wireless/ath/ath9k/hw.c     |   10 
 drivers/net/wireless/ath/ath9k/phy.h    |    3 
 drivers/net/wireless/ath/ath9k/rc.c     |   15 
 drivers/net/wireless/b43/main.c         |    3 
 drivers/net/wireless/b43legacy/main.c   |    2 
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   21 
 drivers/net/wireless/p54/p54pci.c       |   18 
 drivers/net/wireless/p54/p54usb.c       |    1 
 drivers/net/wireless/rndis_wlan.c       |   13 
 drivers/pci/hotplug/ibmphp_ebda.c       |   13 
 drivers/platform/x86/thinkpad_acpi.c    |   64 +-
 drivers/rtc/class.c                     |    1 
 drivers/rtc/rtc-coh901331.c             |    5 
 drivers/scsi/arm/fas216.c               |    2 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c    |   17 
 drivers/scsi/qla1280.c                  |    4 
 drivers/scsi/qla2xxx/qla_gbl.h          |    1 
 drivers/scsi/qla2xxx/qla_isr.c          |   29 
 drivers/scsi/qla2xxx/qla_mid.c          |    6 
 drivers/serial/imx.c                    |    6 
 drivers/staging/Kconfig                 |    2 
 drivers/staging/Makefile                |    1 
 drivers/staging/hv/vmbus_drv.c          |   30 
 drivers/staging/mimio/Kconfig           |   10 
 drivers/staging/mimio/Makefile          |    1 
 drivers/staging/mimio/mimio.c           |  914 ----------------------------
 drivers/usb/core/driver.c               |    4 
 drivers/usb/core/hcd.c                  |    2 
 drivers/usb/core/hcd.h                  |    2 
 drivers/usb/core/hub.c                  |   12 
 drivers/usb/core/usb.c                  |    3 
 drivers/usb/host/ohci-pnx4008.c         |    6 
 drivers/usb/host/uhci-hcd.c             |    1 
 drivers/usb/host/xhci-ext-caps.h        |    7 
 drivers/usb/misc/sisusbvga/sisusb.c     |    1 
 drivers/usb/serial/cp210x.c             |    3 
 drivers/usb/serial/ftdi_sio.c           |   31 
 drivers/usb/serial/ftdi_sio.h           |  959 ------------------------------
 drivers/usb/serial/ftdi_sio_ids.h       | 1019 ++++++++++++++++++++++++++++++++
 drivers/usb/serial/sierra.c             |   19 
 drivers/usb/storage/unusual_devs.h      |   88 ++
 drivers/video/offb.c                    |   15 
 drivers/video/sunxvr500.c               |    1 
 drivers/watchdog/bfin_wdt.c             |   13 
 fs/exec.c                               |    1 
 fs/file_table.c                         |    2 
 fs/namei.c                              |   14 
 fs/nfs/dns_resolve.c                    |   18 
 fs/nfsd/nfs4state.c                     |    2 
 fs/ocfs2/aops.c                         |    5 
 fs/proc/base.c                          |   24 
 include/linux/fs.h                      |    3 
 include/linux/irq.h                     |    2 
 include/linux/sched.h                   |    5 
 kernel/irq/chip.c                       |   52 +
 kernel/power/snapshot.c                 |    2 
 kernel/sched.c                          |   21 
 lib/idr.c                               |    4 
 mm/fadvise.c                            |   10 
 mm/oom_kill.c                           |    2 
 mm/readahead.c                          |    6 
 mm/slab.c                               |    6 
 net/core/dev.c                          |    2 
 net/core/net-sysfs.c                    |    3 
 net/core/scm.c                          |    2 
 net/ipv4/devinet.c                      |    7 
 net/ipv4/igmp.c                         |    2 
 net/ipv6/addrconf.c                     |   16 
 net/ipv6/netfilter/nf_conntrack_reasm.c |    1 
 net/mac80211/agg-tx.c                   |    3 
 net/netfilter/xt_recent.c               |    4 
 net/sunrpc/svc_xprt.c                   |    5 
 net/sunrpc/xprtsock.c                   |    5 
 security/selinux/ss/ebitmap.c           |    2 
 sound/core/pcm_native.c                 |    8 
 sound/pci/hda/hda_intel.c               |    5 
 sound/pci/hda/patch_analog.c            |    2 
 sound/pci/via82xx.c                     |    6 
 sound/soc/codecs/ak4104.c               |    6 
 sound/usb/usbaudio.c                    |   32 +
 sound/usb/usbmidi.c                     |    6 
 sound/usb/usbquirks.h                   |   27 
 167 files changed, 2358 insertions(+), 2378 deletions(-)

Aaro Koskinen (1):
      rtc-core: fix memory leak

Ajit Khaparde (1):
      net: bug fix for vlan + gro issue

Al Viro (2):
      fix LOOKUP_FOLLOW on automount "symlinks"
      Switch proc/self to nd_set_link()

Alan Cox (2):
      tty: Fix the ldisc hangup race
      USB: cp210x: Add 81E8 (Zephyr Bioharness)

Alan Stern (2):
      USB: fix the idProduct value for USB-3.0 root hubs
      USB: remove debugging message for uevent constructions

Andreas Mohr (3):
      USB: ftdi_sio: isolate all device IDs to new ftdi_sio_ids.h header
      USB: ftdi_sio: sort PID/VID entries in new ftdi_sio_ids.h header
      USB: ftdi_sio: add device IDs (several ELV, one Mindstorms NXT)

Andrew Morton (1):
      PCI hotplug: check ioremap() return value in ibmphp_ebda.c

Ang Way Chuang (1):
      dvb-core: Fix DoS bug in ULE decapsulation code that can be triggered by an invalid Payload Pointer

Anirban Chakraborty (1):
      SCSI: qla2xxx: Obtain proper host structure during response-queue processing.

Baruch Siach (1):
      serial: imx: fix NULL dereference Oops when pdata == NULL

Ben Hutchings (3):
      V4L/DVB: cxusb: Select all required frontend and tuner modules
      SCSI: qla1280: Drop host_lock while requesting firmware
      sunxvr500: Additional PCI id for sunxvr500 driver

Bob Copeland (1):
      ath5k: use correct packet type when transmitting

Brandon Phiilps (1):
      x86: Avoid race condition in pci_enable_msix()

Chandru (1):
      PCI hotplug: ibmphp: read the length of ebda and map entire ebda region

Choi, David (1):
      drivers/net: ks8851_mll ethernet network driver

Christian Lamparter (1):
      p54pci: handle dma mapping errors

Clemens Ladisch (1):
      ALSA: via82xx: add quirk for D1289 motherboard

Dan Halperin (1):
      iwlwifi: set HT flags after channel in rxon

Daniel Mack (1):
      ASoC: fix ak4104 register array access

Daniel Sangorrin (1):
      USB: serial: ftdi: add CONTEC vendor and product id

Daniel T Chen (3):
      ALSA: hda: Use 3stack quirk for Toshiba Satellite L40-10Q
      ALSA: hda: Use LPIB for Dell Latitude 131L
      ALSA: hda: Use LPIB for a Biostar Microtech board

Daniel Vetter (1):
      drm/i915: fix get_core_clock_speed for G33 class desktop chips

Dave Airlie (1):
      offb: Add support for framebuffer handoff to offb.

David S. Miller (4):
      sparc: Align clone and signal stacks to 16 bytes.
      sparc32: Fix page_to_phys().
      sparc32: Fix struct stat uid/gid types.
      sparc64: Fix sun4u execute bit check in TSB I-TLB load.

Edward Shao (1):
      USB: xhci: Fix finding extended capabilities registers

Elina Pasheva (1):
      USB: serial: sierra driver indat_callback fix

Eric W. Biederman (3):
      net: Fix sysctl restarts...
      net-sysfs: Use rtnl_trylock in wireless sysfs methods.
      scm: Only support SCM_RIGHTS on unix domain sockets.

Felix Fietkau (3):
      ath9k: fix beacon timer restart after a card reset
      ath9k: fix rate control fallback rate selection
      ath9k: disable RIFS search for AR91xx based chips

Gleb Natapov (4):
      KVM: x86 emulator: Add group8 instruction decoding
      KVM: x86 emulator: Forbid modifying CS segment register by mov instruction
      KVM: x86 emulator: Add group9 instruction decoding
      KVM: x86 emulator: Check CPL level during privilege instruction emulation

Greg Kroah-Hartman (4):
      Staging: hv: add a pci device table
      Staging: hv: match on DMI values to know if we should run.
      Staging: mimio: remove the mimio driver
      Linux 2.6.32.10

Guennadi Liakhovetski (1):
      ARM: 5944/1: scsi: fix timer setup in fas216.c

Haicheng Li (1):
      slab: initialize unused alien cache entry as NULL at alloc_alien_cache().

Henrique de Moraes Holschuh (5):
      thinkpad-acpi: fix poll thread auto-start
      thinkpad-acpi: R52 brightness_mode has been confirmed
      thinkpad-acpi: document HKEY event 3006
      thinkpad-acpi: make driver events work in NVRAM poll mode
      thinkpad-acpi: fix bluetooth/wwan resume

Herbert Xu (2):
      inet: Remove bogus IGMPv3 report handling
      USB: Move hcd free_dev call into usb_disconnect to fix oops

Ian Campbell (2):
      x86, xen: Disable highmem PTE allocation even when CONFIG_HIGHPTE=y
      x86, mm: Allow highmem user page tables to be disabled at boot time

James Hogan (1):
      rtc-coh901331: fix braces in resume code

Jan Dumon (1):
      USB: unusual_devs: Add support for multiple Option 3G sticks

Jarek Poplawski (1):
      net/via-rhine: Fix scheduling while atomic bugs

Jaroslav Kysela (1):
      ALSA: pcm core - fix fifo_size channels interval check

Jean Delvare (5):
      V4L/DVB: bttv: Move I2C IR initialization
      macintosh/therm_adt746x: Fix sysfs attributes lifetime
      macintosh/hwmon/ams: Fix device removal sequence
      hwmon: (tmp421) Fix temperature conversions
      hwmon: (tmp421) Restore missing inputs

Jean-François Moine (1):
      p54usb: Add the USB ID for Belkin (Accton) FD7050E ver 1010ec

Jerome Glisse (3):
      drm/radeon/kms: Forbid creation of framebuffer with no valid GEM object
      drm/radeon/kms: r600/r700 don't test ib if ib initialization fails
      drm/radeon: r6xx/r7xx possible security issue, system ram access

Jiri Kosina (1):
      HID: remove TENX iBuddy from blacklist

Jiri Slaby (1):
      x86, ia32_aout: do not kill argument mapping

Joshua Roys (1):
      netlabel: fix export of SELinux categories > 127

Jussi Kivilinna (3):
      rndis_wlan: handle NL80211_AUTHTYPE_AUTOMATIC
      rndis_wlan: fix buffer overflow in rndis_query_oid
      rndis_wlan: disable stall workaround

Justin P. Mattock (1):
      x86: Add iMac9,1 to pci_reboot_dmi_table

KAMEZAWA Hiroyuki (1):
      memcg: fix oom killing a child process in an other cgroup

Kashyap, Desai (1):
      mpt2sas: Delete volume before HBA detach.

Kay Sievers (1):
      Driver-Core: devtmpfs - reset inode permissions before unlinking

Larry Finger (1):
      b43/b43legacy: Wake queues in wireless_core_start

Lars-Peter Clausen (1):
      s3cmci: s3cmci_card_present: Use no_detect to decide whether there is a card detect pin

Laurent Pinchart (1):
      V4L/DVB (13148): uvcvideo: Handle V4L2_CTRL_TYPE_BUTTON control type in VIDIOC_QUERYCTRL

Len Brown (2):
      ACPI: remove Asus P2B-DS from acpi=ht blacklist
      ACPI: fix "acpi=ht" boot option

Luotao Fu (1):
      USB: fix I2C API usage in ohci-pnx4008.

Maarten Maathuis (1):
      drm/ttm: handle OOM in ttm_tt_swapout

Mark Brown (1):
      gpiolib: Actually set output state in wm831x_gpio_direction_output()

Martin Fuzzey (1):
      V4L/DVB: Video : pwc : Fix regression in pwc_set_shutter_speed caused by bad constant => sizeof conversion.

Michael Neuling (1):
      fs/exec.c: fix initial stack reservation

Mike Frysinger (1):
      bfin: fix max timeout calculation

Mikulas Patocka (1):
      dm: free dm_io before bio_endio not after

Mitchell Solomon (1):
      USB: add new ftdi_sio device ids

Neil Brown (1):
      sunrpc: remove unnecessary svc_xprt_put

Oliver Neukum (1):
      HID: usbhid: introduce timeout for stuck ctrl/out URBs

Pallipadi, Venkatesh (1):
      ACPI: Be in TS_POLLING state during mwait based C-state entry

Paul Menzel (1):
      ALSA: hda-intel: Add position_fix quirk for ASUS M2V-MX SE.

Paul Mundt (1):
      clocksource: Fix up a registration/IRQ race in the sh drivers.

Pete Zaitcev (1):
      USB: fix crash in uhci_scan_schedule

Peter Hutterer (1):
      HID: add multi-input quirk for NextWindow Touchscreen.

Radek Liboska (1):
      USB: ftdi_sio: new device id for papouch AD4USB

Rafael J. Wysocki (1):
      PM / Hibernate: Fix preallocating of memory

Rajiv Andrade (1):
      tpm_tis: TPM_STS_DATA_EXPECT workaround

Richard Guenther (1):
      V4L/DVB: dvb: l64781.ko broken with gcc 4.5

Robert Hancock (1):
      ahci: disable FPDMA auto-activate optimization on NVIDIA AHCI

Robert Richter (5):
      oprofile/x86: fix perfctr nmi reservation for mulitplexing
      oprofile: remove tracing build dependency
      oprofile/x86: remove node check in AMD IBS initialization
      oprofile/x86: use kzalloc() instead of kmalloc()
      oprofile/x86: fix msr access to reserved counters

Roel Kluin (2):
      thinkpad-acpi: wrong thermal attribute_group removed in thermal_exit()
      sparc: leds_resource.end assigned to itself in clock_board_probe()

Sebastien Alaiwan (1):
      ALSA: USB MIDI support for Access Music VirusTI

Sergei Shtylyov (1):
      pata_hpt3x2n: always stretch UltraDMA timing

Shan Wei (1):
      ipv6: conntrack: Add member of user to nf_ct_frag6_queue structure

Stanislaw Gruszka (2):
      iwlwifi: sanity check before counting number of tfds can be free
      airo: fix setting zero length WEP key

Suresh Siddha (1):
      sched: Fix SMT scheduler regression in find_busiest_queue()

Takashi Iwai (2):
      ALSA: hda - Add a position_fix quirk for MSI Wind U115
      ALSA: hda - Add position_fix quirk for HP dv3

Tanaka Akira (1):
      USB: SIS USB2VGA DRIVER: support KAIREN's USB VGA adaptor USB20SVGA-MB-PLUS

Tao Ma (1):
      ocfs2: Only bug out in direct io write for reflinked extent.

Tejun Heo (2):
      idr: fix a critical misallocation bug, take#2
      driver-core: fix race condition in get_device_parent()

Theodore Kilgore (1):
      V4L/DVB (13991): gspca_mr973010a: Fix cif type 1 cameras not streaming on UHCI controllers

Thomas Gleixner (1):
      sched: Don't use possibly stale sched_class

Tim Gardner (2):
      netfilter: xt_recent: fix buffer overflow
      netfilter: xt_recent: fix false match

Trond Myklebust (2):
      SUNRPC: Handle EINVAL error returns from the TCP connect operation
      NFS: Fix an allocation-under-spinlock bug

Vaidyanathan Srinivasan (1):
      sched: Fix sched_mv_power_savings for !SMT

Wey-Yi Guy (1):
      iwlwifi: error checking for number of tfds in queue

Wu Fengguang (2):
      vfs: take f_lock on modifying f_mode after open time
      readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM

Yinghai Lu (1):
      x86: Fix SCI on IOAPIC != 0

Zhang Rui (1):
      ACPI, i915: blacklist Clevo M5x0N bad_lid state

Zhao Yakui (1):
      drm/i915: Use a dmi quirk to skip a broken SDVO TV output.

Zhenyu Wang (1):
      drm/i915: disable TV hotplug status check

Zhu Yi (1):
      mac80211: quit addba_resp_timer if Tx BA session is torn down

stephen hemminger (1):
      sky2: fix transmit DMA map leakage

