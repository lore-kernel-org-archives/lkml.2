Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab2EVKb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:31:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2EVKby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:31:54 -0400
Date: Tue, 22 May 2012 12:31:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1205221220250.16396@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please consider pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive patches queued in trivial.git

As usual, it's mostly typo fixes, redundant code elimination and some 
documentation updates.

There are 2 known conflicts currently in linux-next between trivial.git 
and

- mips tree; arch/mips/lantiq/xway/gpio_ebu.c 
  arch/mips/lantiq/xway/gpio_stp.c are getting moved to drivers/gpio, but 
  still need the typo fix in the new place
- sound-asoc tree; sound/soc/imx/Kconfig gets folded into 
  sound/soc/fsl/Kconfig, and the typo fix is still needed there

Either I can wait until those two trees land in your tree, merge and 
resolve the conflict myself, and redo the pull request, or let you fix the 
conflict once the two trees reach you after merging trivial.git. The 
conflict resolutions are completely trivial.

Thanks.


Alexandra Vintila (1):
      atm: fix comments

David Mackey (1):
      edac: Fix spelling errors.

Dmitry Artamonow (1):
      w1: fix slave driver registration error message

Geert Uytterhoeven (1):
      fbdev: s/#if CONFIG/#ifdef CONFIG/

Jesper Juhl (14):
      Makefile: improve line wrapping
      radeon: remove redundant ';' from radeon_vm_bo_update_pte()
      btrfs: assignment in write_dev_flush() doesn't need two semi-colons
      gma500: Don't needlessly include version.h in mdfld_dsi_output.h
      radeon_cp: Remove unneeded tests for NULL before calling release_firmware()
      typhoon: get rid of redundant conditional before all to release_firmware()
      tg3: remove redundant NULL test before release_firmware() call
      bna: remove redundant NULL test before release_firmware()
      qlogic: get rid of a redundant test for NULL before call to release_firmware()
      tehuti: delete redundant NULL check before release_firmware()
      aic94xx: Get rid of redundant NULL check before release_firmware() call
      qla2xxx: Remove redundant NULL check before release_firmware() call.
      remoteproc: remove redundant NULL check before release_firmware()
      qla1280: Remove redundant NULL check before release_firmware() call

Jiri Kosina (2):
      Merge branch 'master' into for-next
      edac, mips: don't change code that has been removed in edac/mips tree

Joe Perches (5):
      scsi: Use vsprintf extention %pf with builtin_return_address
      gadget: Use vsprintf extention %pf with builtin_return_address
      alpha: Use vsprintf extention %pf with builtin_return_address
      arm: Use vsprintf extention %pf with builtin_return_address
      parisc: Use vsprintf extention %pf with builtin_return_address

Jonathan Woithe (1):
      Email/web address change

Josh Triplett (1):
      x86: Fix typo in MODULE_DEVICE_TABLE example: s/x86_cpu/x86cpu/

Justin P. Mattock (1):
      r8169.c: fix comment typo

Kusanagi Kouichi (1):
      x86, relocs: Remove an unused variable

Kyle McMartin (1):
      net: Fix tcp_build_and_update_options comment in struct tcp_sock

Lucia Rosculete (1):
      semaphore: fix improper comment reference to mutex

Masanari Iida (6):
      doc: fix a few typos
      mips: Fix printk typos in arc/mips
      radeon: Fix typo in radeon_gem.c
      Documentation: Fix typo in multiple files in Documentation
      Fix typo in various Kconfig file
      Fix "the the" in various Kconfig

Michael Witten (8):
      README: Use `X' and `x' consistently
      README: Grammar: `me has' -> `I have'
      README: Better comma usage
      README: `Alternately' -> `Alternatively'
      README: More consistent and readable white space
      README: Capitalize start of sentence
      README: Consolidate discussions of -stable patches
      README: Remove sporadic tabs

Octavian Moraru (1):
      mtg: docg3: fix comment errors

Oskar Schirmer (5):
      i2c: Change mail address of Oskar Schirmer
      arm/m68k: Change mail address of Sebastian Hess
      net: Change mail address of Oskar Schirmer
      lib: Change mail address of Oskar Schirmer
      xtensa: Change mail addresses of Hannes Weiner and Oskar Schirmer

Paul Bolle (2):
      c2port: fix bogus Kconfig "default no"
      Kconfig: replace "--- help ---" with "---help---"

Philipp Hahn (1):
      atomic64_32.h: fix parameter naming mismatch

Santosh Y (1):
      scsi: fix comment spelling fix recory->recovery

Stephen Boyd (1):
      workqueue: Fix workqueue_execute_end() comment

Thomas Weber (1):
      Fix typo milivolt => millivolt

Wang YanQing (1):
      mmzone: fix comment typo coelesce -> coalesce

 CREDITS                                            |    4 +-
 Documentation/ABI/testing/sysfs-bus-usb            |    4 +-
 Documentation/DocBook/kernel-hacking.tmpl          |    2 +-
 Documentation/DocBook/libata.tmpl                  |    2 +-
 Documentation/DocBook/media/v4l/controls.xml       |    6 +-
 Documentation/blackfin/bfin-gpio-notes.txt         |    2 +-
 .../devicetree/bindings/net/can/fsl-flexcan.txt    |    2 +-
 Documentation/dvb/opera-firmware.txt               |    4 +-
 Documentation/edac.txt                             |    2 +-
 Documentation/filesystems/nfs/pnfs.txt             |    2 +-
 Documentation/filesystems/qnx6.txt                 |   28 ++--
 Documentation/hwmon/it87                           |    2 +-
 Documentation/hwmon/wm831x                         |    2 +-
 Documentation/memory-hotplug.txt                   |    2 +-
 Documentation/networking/can.txt                   |    2 +-
 Documentation/parisc/debugging                     |    2 +-
 Documentation/sound/alsa/compress_offload.txt      |    2 +-
 Documentation/sound/oss/ALS                        |    4 +-
 Documentation/static-keys.txt                      |    2 +-
 Documentation/usb/dwc3.txt                         |    2 +-
 Documentation/usb/wusb-cbaf                        |    2 +-
 Documentation/video4linux/README.cpia2             |    2 +-
 MAINTAINERS                                        |    2 +-
 Makefile                                           |   12 +-
 README                                             |  222 +++++++++++---------
 arch/alpha/kernel/pci_iommu.c                      |   20 +-
 arch/arm/Kconfig                                   |    4 +-
 arch/arm/mach-s3c64xx/Kconfig                      |    4 +-
 arch/arm/nwfpe/fpmodule.c                          |    2 +-
 arch/blackfin/Kconfig                              |    2 +-
 arch/m68k/Kconfig.cpu                              |    2 +-
 arch/m68k/platform/532x/config.c                   |    2 +-
 arch/mips/Kconfig                                  |    4 +-
 arch/mips/Kconfig.debug                            |    2 +-
 arch/mips/kernel/mips-mt.c                         |    2 +-
 arch/mips/lantiq/xway/gpio.c                       |    2 +-
 arch/mips/lantiq/xway/gpio_ebu.c                   |    2 +-
 arch/mips/lantiq/xway/gpio_stp.c                   |    2 +-
 arch/mips/sni/pcimt.c                              |    2 +-
 arch/openrisc/Kconfig                              |    2 +-
 arch/powerpc/platforms/Kconfig.cputype             |    4 +-
 arch/powerpc/platforms/pseries/Kconfig             |    2 +-
 arch/sh/Kconfig.cpu                                |    2 +-
 arch/x86/boot/compressed/relocs.c                  |    2 -
 arch/x86/include/asm/atomic64_32.h                 |   10 +-
 arch/x86/kernel/cpu/match.c                        |    2 +-
 arch/xtensa/variants/s6000/dmac.c                  |    2 +-
 arch/xtensa/variants/s6000/gpio.c                  |    4 +-
 arch/xtensa/variants/s6000/include/variant/dmac.h  |    2 +-
 arch/xtensa/variants/s6000/irq.c                   |    4 +-
 drivers/devfreq/Kconfig                            |    2 +-
 drivers/edac/edac_core.h                           |    4 +-
 drivers/edac/edac_device.c                         |    8 +-
 drivers/edac/i7core_edac.c                         |   10 +-
 drivers/edac/sb_edac.c                             |    6 +-
 drivers/gpu/drm/gma500/mdfld_dsi_output.h          |    1 -
 drivers/gpu/drm/radeon/radeon_cp.c                 |   12 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |    2 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |    2 +-
 drivers/hid/Kconfig                                |    2 +-
 drivers/hwmon/Kconfig                              |    2 +-
 drivers/i2c/busses/Kconfig                         |    2 +-
 drivers/i2c/busses/i2c-s6000.c                     |    2 +-
 drivers/i2c/busses/i2c-s6000.h                     |    2 +-
 drivers/iommu/Kconfig                              |    4 +-
 drivers/mfd/Kconfig                                |    6 +-
 drivers/mfd/tps65911-comparator.c                  |    2 +-
 drivers/misc/c2port/Kconfig                        |    6 +-
 drivers/mtd/devices/docg3.c                        |   16 +-
 drivers/net/can/sja1000/Kconfig                    |    2 +-
 drivers/net/ethernet/3com/typhoon.c                |    3 +-
 drivers/net/ethernet/broadcom/tg3.c                |    3 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |    4 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   |    3 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |    3 +-
 drivers/net/ethernet/realtek/r8169.c               |    2 +-
 drivers/net/ethernet/s6gmac.c                      |    4 +-
 drivers/net/ethernet/tehuti/tehuti.c               |    4 +-
 drivers/net/irda/Kconfig                           |    2 +-
 drivers/parisc/superio.c                           |    2 +-
 drivers/platform/x86/fujitsu-laptop.c              |    2 +-
 drivers/power/bq27x00_battery.c                    |    2 +-
 drivers/ptp/Kconfig                                |    2 +-
 drivers/regulator/tps65910-regulator.c             |   20 +-
 drivers/remoteproc/remoteproc_core.c               |    3 +-
 drivers/scsi/aic94xx/aic94xx_seq.c                 |    3 +-
 drivers/scsi/esp_scsi.c                            |    2 +-
 drivers/scsi/qla1280.c                             |    7 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    3 +-
 drivers/scsi/scsi_error.c                          |    6 +-
 drivers/usb/gadget/u_serial.c                      |    2 +-
 drivers/usb/host/Kconfig                           |    2 +-
 drivers/usb/storage/unusual_devs.h                 |    2 +-
 drivers/video/au1100fb.c                           |    2 +-
 drivers/w1/Kconfig                                 |    2 +-
 drivers/w1/w1.c                                    |    2 +-
 drivers/watchdog/Kconfig                           |    2 +-
 drivers/xen/Kconfig                                |    2 +-
 fs/btrfs/disk-io.c                                 |    2 +-
 include/linux/mfd/wm831x/pdata.h                   |    2 +-
 include/linux/mmzone.h                             |    2 +-
 include/linux/rational.h                           |    2 +-
 include/linux/tcp.h                                |    2 +-
 include/trace/events/workqueue.h                   |    2 +-
 kernel/semaphore.c                                 |    2 +-
 kernel/trace/Kconfig                               |    2 +-
 lib/rational.c                                     |    2 +-
 net/atm/lec.h                                      |    4 +-
 net/caif/Kconfig                                   |    2 +-
 sound/isa/als100.c                                 |    2 +-
 sound/pci/hda/patch_realtek.c                      |    2 +-
 sound/soc/imx/Kconfig                              |    2 +-
 112 files changed, 311 insertions(+), 314 deletions(-)

-- 
Jiri Kosina
SUSE Labs
