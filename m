Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2KQAei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:34:38 -0500
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:55016 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2KQAea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:34:30 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2012 19:34:29 EST
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
Date: Fri, 16 Nov 2012 19:19:10 -0500
Message-Id: <1353112043-11800-1-git-send-email-wfp5p@virginia.edu>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HOTPLUG is no longer an optional setting.  In order to remove
it as on option code paths that check CONFIG_HOTPLUG will removed
along with the attributes __devexit_p, __devexit, __devinitconst, and
__devinitdata.

I'll save the list from the mailbomb of this huge patchset.  The
patches themselves are going to Greg KH for the driver core tree.


Bill Pemberton (493):
  AMBA: remove CONFIG_HOTPLUG ifdefs
  i2c: remove CONFIG_HOTPLUG ifdefs
  Input: serio - remove CONFIG_HOTPLUG ifdefs
  pcmcia: remove CONFIG_HOTPLUG ifdefs
  pnpbios: remove CONFIG_HOTPLUG ifdefs
  w1: remove CONFIG_HOTPLUG ifdefs
  usb-core: remove CONFIG_HOTPLUG ifdefs
  zorro: remove CONFIG_HOTPLUG ifdefs
  driver core: remove CONFIG_HOTPLUG ifdefs
  isdn: remove CONFIG_HOTPLUG ifdefs
  staging: ipack: remove CONFIG_HOTPLUG ifdefs
  kobject: remove CONFIG_HOTPLUG ifdefs
  staging: csr: remove CONFIG_HOTPLUG ifdefs
  PCI: remove CONFIG_HOTPLUG ifdefs
  PCI: move pci_uevent into pci-driver.c
  PCI: always build setup-bus when PCI is enabled
  wireless: remove CONFIG_HOTPLUG ifdefs
  net: remove CONFIG_HOTPLUG ifdefs
  mm: remove CONFIG_HOTPLUG ifdefs
  sysctl: remove CONFIG_HOTPLUG ifdefs
  kernel/ksysfs.c: remove CONFIG_HOTPLUG ifdefs
  ARM: remove CONFIG_HOTPLUG ifdefs
  ia64: iosapic: remove CONFIG_HOTPLUG ifdefs
  powerpc: remove CONFIG_HOTPLUG ifdefs
  staging: wlags49_h2: remove use of __devexit_p
  atm: remove use of __devexit_p in fore200e.c
  media: remove use of __devexit_p in bt878.c
  video: hpfb: remove use of __devexit_p
  ethernet: remove use of __devexit_p in hydra.c
  ASoC: max98088: remove use of __devexit_p
  docbook: remove references to __devexit_p
  arm: remove use of __devexit_p
  Blackfin: remove use of __devexit_p
  MIPS: remove use of __devexit_p
  powerpc: remove use of __devexit_p
  sparc: remove use of __devexit_p
  x86: OLPC: remove use of __devexit_p
  ata: remove use of __devexit_p
  atm: remove use of __devexit_p
  bcma: remove use of __devexit_p
  auxdisplay: remove use of __devexit_p
  drivers/block: remove use of __devexit_p
  drivers: bus: remove use of __devexit_p
  gdrom: bus: remove use of __devexit_p
  agp: remove use of __devexit_p
  hwrng: remove use of __devexit_p
  IPMI: remove use of __devexit_p
  tpm_infineon: remove use of __devexit_p
  char: remove use of __devexit_p
  clk: remove use of __devexit_p
  clocksource: remove use of __devexit_p
  cpufreq: remove use of __devexit_p
  crypto: remove use of __devexit_p
  devfreq: remove use of __devexit_p
  dma: remove use of __devexit_p
  edac: remove use of __devexit_p
  extcon: remove use of __devexit_p
  dcdbas: remove use of __devexit_p
  gpio: remove use of __devexit_p
  drm/exynos: remove use of __devexit_p
  gma500: remove use of __devexit_p
  drm: remove use of __devexit_p
  HSI: hsi_char: remove use of __devexit_p
  hwspinlock: remove use of __devexit_p
  i2c: remove use of __devexit_p
  ide: remove use of __devexit_p
  iio: remove use of __devexit_p
  infiniband: remove use of __devexit_p
  iommu/omap: remove use of __devexit_p
  isdn: remove use of __devexit_p
  leds: remove use of __devexit_p
  drivers/macintosh: remove use of __devexit_p
  drivers/message/fusion: remove use of __devexit_p
  drivers/message: remove use of __devexit_p
  mfd: remove use of __devexit_p
  mei: remove use of __devexit_p
  mmc: remove use of __devexit_p
  arcnet: remove use of __devexit_p
  can: remove use of __devexit_p
  fddi: remove use of __devexit_p
  hippi: remove use of __devexit_p
  ieee802154: remove use of __devexit_p
  irda: remove use of __devexit_p
  phy: remove use of __devexit_p
  net/wireless: remove use of __devexit_p
  net: remove use of __devexit_p
  parport: remove use of __devexit_p
  pci: remove use of __devexit_p
  pcmcia: remove use of __devexit_p
  platform/x86: remove use of __devexit_p
  power: remove use of __devexit_p
  pps: remove use of __devexit_p
  regulator: remove use of __devexit_p
  remoteproc: remove use of __devexit_p
  rpmsg: remove use of __devexit_p
  sbus: remove use of __devexit_p
  scsi: remove use of __devexit_p
  sh: remove use of __devexit_p
  ioc3: remove use of __devexit_p
  staging: crystalhd: remove use of __devexit_p
  staging: et131x: remove use of __devexit_p
  staging: drm/imx: remove use of __devexit_p
  staging: dt3155v4l: remove use of __devexit_p
  staging: lirc: remove use of __devexit_p
  staging: pc300: remove use of __devexit_p
  staging: nvec: remove use of __devexit_p
  staging: rtl8187se: remove use of __devexit_p
  staging: octeon_ethernet: remove use of __devexit_p
  staging: rtl8192e: remove use of __devexit_p
  staging: slicoss: remove use of __devexit_p
  staging: sm7xxfb: remove use of __devexit_p
  staging: tidspbridge: remove use of __devexit_p
  staging: usbip: remove use of __devexit_p
  staging: vme: remove use of __devexit_p
  staging: xgifb: remove use of __devexit_p
  thermal: exynos: remove use of __devexit_p
  tty: remove use of __devexit_p
  uio: remove use of __devexit_p
  usb: remove use of __devexit_p
  backlight: remove use of __devexit_p
  video: remove use of __devexit_p
  virtio: remove use of __devexit_p
  watchdog: remove use of __devexit_p
  vlynq: remove use of __devexit_p
  w1: remove use of __devexit_p
  rfkill: remove use of __devexit_p
  samples/rpmsg: remove use of __devexit_p
  sound: remove use of __devexit_p
  init: remove __devexit_p macro
  lib: kobject_uevent is no longer dependant on CONFIG_HOTPLUG
  hwmon: remove use of __devexit_p
  Input: remove use of __devexit_p
  remove use of __devexit_p
  drivers/misc: remove use of __devexit_p
  mtd: remove use of __devexit_p
  ethernet: remove use of __devexit_p
  NFC: remove use of __devexit_p
  pinctrl: remove use of __devexit_p
  pwm: remove use of __devexit_p
  rtc: remove use of __devexit_p
  spi: remove use of __devexit_p
  staging: ipack: remove use of __devexit_p
  staging: olpc_dcon: remove use of __devexit_p
  staging: ste_rmi4: remove use of __devexit_p
  tty: serial: remove use of __devexit_p
  ASoC: remove use of __devexit_p
  Input: remove use of __devexit_p in Retu driver
  staging: comedi: remove use of __devexit_p
  staging: iio: remove use of __devexit_p
  rtc: remove use of __devinit
  ioat: remove use of __devinit
  watchdog: remove use of __devinit
  xen: remove use of __devinit
  w1: remove use of __devinit
  vlynq: remove use of __devinit
  virtio: remove use of __devinit
  backlight: remove use of __devinit
  video: remove use of __devinit
  usb: remove use of __devinit
  uio: remove use of __devinit
  tty: remove use of __devinit
  thermal: exynos: remove use of __devinit
  staging: xgifb: remove use of __devinit
  staging: wlags49_h2: remove use of __devinit
  staging: vt6655: remove use of __devinit
  staging: vt6656: remove use of __devinit
  staging: vme: remove use of __devinit
  staging: iio: remove use of __devinit
  staging: comedi: remove use of __devinit
  staging: tidspbridge: remove use of __devinit
  staging: ste_rmi4: remove use of __devinit
  staging: sm7xxfb: remove use of __devinit
  staging: slicoss: remove use of __devinit
  staging: sep: remove use of __devinit
  staging: rtl8192u: remove use of __devinit
  staging: rtl8192e: remove use of __devinit
  staging: octeon: remove use of __devinit
  staging: nvec: remove use of __devinit
  staging: rtl8187se: remove use of __devinit
  staging: net: remove use of __devinit
  staging: crystalhd: remove use of __devinit
  staging: imx-drm: remove use of __devinit
  staging: et131x: remove use of __devinit
  staging: omap-thermal: remove use of __devinit
  staging: sbe-2t3e3: remove use of __devinit
  staging: lirc: remove use of __devinit
  staging: solo6x10: remove use of __devinit
  staging: dt3155v4l: remove use of __devinit
  ssb: remove use of __devinit
  spi: remove use of __devinit
  sh: remove use of __devinit
  scsi: remove use of __devinit
  regulator: remove use of __devinit
  power: remove use of __devinit
  pinctl: remove use of __devinit
  net/wireless: remove use of __devinit
  platform/x86: remove use of __devinit
  ethernet: remove use of __devinit
  ata: remove use of __devinit
  irda: remove use of __devinit
  phy: remove use of __devinit
  can: remove use of __devinit
  net: remove use of __devinit
  atm: remove use of __devinit
  gpio: remove use of __devinit
  hwmon: remove use of __devinit
  i2c: remove use of __devinit
  ide: remove use of __devinit
  iio: remove use of __devinit
  infiniband: remove use of __devinit
  hwrng: remove use of __devinit
  agp: remove use of __devinit
  tpm: remove use of __devinit
  drm: remove use of __devinit
  drivers/macintosh: remove use of __devinit
  memory: remove use of __devinit
  acpi: remove use of __devinit
  amba: remove use of __devinit
  auxdisplay: remove use of __devinit
  bcma: remove use of __devinit
  cdrom: remove use of __devinit
  char: remove use of __devinit
  clk: remove use of __devinit
  clocksource: remove use of __devinit
  crypto: remove use of __devinit
  dma: remove use of __devinit
  edac: remove use of __devinit
  firewire: remove use of __devinit
  hsi: remove use of __devinit
  input: remove use of __devinit
  iommu: remove use of __devinit
  isdn: remove use of __devinit
  leds: remove use of __devinit
  media: remove use of __devinit
  mfd: remove use of __devinit
  misc: remove use of __devinit
  mmc: remove use of __devinit
  mtd: remove use of __devinit
  nfc: remove use of __devinit
  parisc: remove use of __devinit
  parport: remove use of __devinit
  pci: remove use of __devinit
  pcmcia: remove use of __devinit
  ps3: remove use of __devinit
  pwm: remove use of __devinit
  sbus: remove use of __devinit
  drivers/block: remove use of __devinit
  drivers: bus: remove use of __devinit
  drivers: connector: remove use of __devinit
  cpufreq: remove use of __devinit
  devfreq: remove use of __devinit
  extcon: remove use of __devinit
  hwspinlock: remove use of __devinit
  dcdbas: remove use of __devinit
  drivers/message: remove use of __devinit
  rapidio: remove use of __devinit
  remoteproc: remove use of __devinit
  ioc3: remove use of __devinit
  ptp: remove use of __devinit
  ALSA: usb-audio: remove use of __devinit
  sound: remove use of __devinit
  fs/file: remove use of __devinit
  pstore: remove use of __devinit
  rfkill: remove use of __devinit
  mm/vmscan.c: remove use of __devinit
  x86/PCI: remove use of __devinit
  x86: remove use of __devinit
  Blackfin: remove use of __devinit
  alpha: remove use of __devinit
  arm: remove use of __devinit
  cris: remove use of __devinit
  frv: remove use of __devinit
  ia64: remove use of __devinit
  m32r: remove use of __devinit
  microblaze: remove use of __devinit
  mips: remove use of __devinit
  openrisc: remove use of __devinit
  s390: remove use of __devinit
  score: remove use of __devinit
  sparc: remove use of __devinit
  tile: remove use of __devinit
  unicore32: remove use of __devinit
  powerpc: remove use of __devinit
  arm64: remove use of __devinit
  avr32: remove use of __devinit
  m68k: remove use of __devinit
  mn10300: remove use of __devinit
  sh: remove use of __devinit
  docbook: remove discussion of __devinit
  kernel-doc: remove check for __devinit in function prototype
  asm-generic: remove use of __devinit
  pstore/ram: remove use of __devinit
  init: remove __devexitdata and __devexitconst macro
  ioc3: remove use of __devinitdata
  tty: remove use of __devinitdata
  watchdog: remove use of __devinitdata
  xen: remove use of __devinitdata
  video: remove use of __devinitdata
  ata: remove use of __devinitdata
  atm: remove use of __devinitdata
  auxdisplay: remove use of __devinitdata
  clocksource: remove use of __devinitdata
  crypto: remove use of __devinitdata
  firewire: remove use of __devinitdata
  gpio: remove use of __devinitdata
  i2c: remove use of __devinitdata
  ide: remove use of __devinitdata
  infiniband: remove use of __devinitdata
  input: remove use of __devinitdata
  iommu: remove use of __devinitdata
  isdn: remove use of __devinitdata
  mfd: remove use of __devinitdata
  mmc: remove use of __devinitdata
  mtd: remove use of __devinitdata
  parport: remove use of __devinitdata
  pci: remove use of __devinitdata
  pcmcia: remove use of __devinitdata
  pinctrl: remove use of __devinitdata
  scsi: remove use of __devinitdata
  regulator: remove use of __devinitdata
  rtc: remove use of __devinitdata
  spi: remove use of __devinitdata
  tty: remove use of __devinitdata
  uio: remove use of __devinitdata
  usb: remove use of __devinitdata
  block: remove use of __devinitdata
  char: remove use of __devinitdata
  hwmon: remove use of __devinitdata
  misc: remove use of __devinitdata
  platform/x86: remove use of __devinitdata
  ethernet: remove use of __devinitdata
  media: remove use of __devinitdata
  net: remove use of __devinitdata
  drivers/message: remove use of __devinitdata
  staging: rtl8187se: remove use of __devinitdata
  staging: rtl8192e: remove use of __devinitdata
  staging: sbe-2t3e3: remove use of __devinitdata
  staging: wlags49_h2: remove use of __devinitdata
  alpha: remove use of __devinitdata
  arm: remove use of __devinitdata
  ia64: remove use of __devinitdata
  mips: remove use of __devinitdata
  parisc: remove use of __devinitdata
  powerpc: remove use of __devinitdata
  sparc: remove use of __devinitdata
  tile: remove use of __devinitdata
  sound: remove use of __devinitdata
  ALSA: hda: remove DELAYED_INIT_MARK and DELAYED_INITDATA_MARK macros
  ALSA: docbook: remove discussion of __devinitdata in documentation
  amba: remove use of __devinitconst
  atm: remove use of __devinitconst
  block: remove use of __devinitconst
  char: remove use of __devinitconst
  clocksource: remove use of __devinitconst
  dma: remove use of __devinitconst
  gpio: remove use of __devinitconst
  i2c: remove use of __devinitconst
  ide: remove use of __devinitconst
  input: remove use of __devinitconst
  mfd: remove use of __devinitconst
  misc: remove use of __devinitconst
  mmc: remove use of __devinitconst
  mtd: remove use of __devinitconst
  pinctrl: remove use of __devinitconst
  power: remove use of __devinitconst
  regulator: remove use of __devinitconst
  rtc: remove use of __devinitconst
  scsi: remove use of __devinitconst
  spi: remove use of __devinitconst
  tty: remove use of __devinitconst
  usb: remove use of __devinitconst
  video: remove use of __devinitconst
  drivers/macintosh: remove use of __devinitconst
  memory: remove use of __devinitconst
  media: remove use of __devinitconst
  staging: ipack: remove use of __devinitconst
  staging: nvec: remove use of __devinitconst
  ethernet: remove use of __devinitconst
  net: remove use of __devinitconst
  platform/x86: remove use of __devinitconst
  m68k: remove use of __devinitconst
  powerpc: remove use of __devinitconst
  x86: remove use of __devinitconst
  sound: remove use of __devinitconst
  pci: remove use of __devinitconst
  spi: remove use of __devinitconst
  acpi: remove use of __devexit
  ata: remove use of __devexit
  atm: remove use of __devexit
  auxdisplay: remove use of __devexit
  bcma: remove use of __devexit
  block: remove use of __devexit
  cdrom: remove use of __devexit
  clk: remove use of __devexit
  clocksource: remove use of __devexit
  cpufreq: remove use of __devexit
  crypto: remove use of __devexit
  dma: remove use of __devexit
  edac: remove use of __devexit
  extcon: remove use of __devexit
  gpio: remove use of __devexit
  hwmon: remove use of __devexit
  hwspinlock: remove use of __devexit
  i2c: remove use of __devexit
  ide: remove use of __devexit
  iio: remove use of __devexit
  infiniband: remove use of __devexit
  input: remove use of __devexit
  iommu: remove use of __devexit
  isdn: remove use of __devexit
  leds: remove use of __devexit
  mfd: remove use of __devexit
  misc: remove use of __devexit
  mmc: remove use of __devexit
  mtd: remove use of __devexit
  pcmcia: remove use of __devexit
  pinctrl: remove use of __devexit
  power: remove use of __devexit
  ptp: remove use of __devexit
  pwm: remove use of __devexit
  regulator: remove use of __devexit
  rtc: remove use of __devexit
  remoteproc: remove use of __devexit
  sbus: remove use of __devexit
  scsi: remove use of __devexit
  sh: remove use of __devexit
  spi: remove use of __devexit
  thermal: remove use of __devexit
  tty: remove use of __devexit
  uio: remove use of __devexit
  usb: remove use of __devexit
  virtio: remove use of __devexit
  vlynq: remove use of __devexit
  w1: remove use of __devexit
  watchdog: remove use of __devexit
  drivers: bus: remove use of __devexit
  char: remove use of __devexit
  drivers: connector: remove use of __devexit
  devfreq: remove use of __devexit
  dcdbas: remove use of __devexit
  hsi: remove use of __devexit
  drm/exynos: remove use of __devexit
  drivers/macintosh: remove use of __devexit
  media: remove use of __devexit
  backlight: remove use of __devexit
  video: remove use of __devexit
  staging: comedi: remove use of __devexit
  staging: iio: remove use of __devexit
  staging: imx-drm: remove use of __devexit
  staging: ipack: remove use of __devexit
  staging: net: remove use of __devexit
  staging: nvec: remove use of __devexit
  staging: octeon: remove use of __devexit
  staging: omap-thermal: remove use of __devexit
  staging: rtl8187se: remove use of __devexit
  staging: rtl8192e: remove use of __devexit
  staging: rtl8192u: remove use of __devexit
  staging: sbe-2t3e3: remove use of __devexit
  staging: slicoss: remove use of __devexit
  staging: sm7xxfb: remove use of __devexit
  staging: ste_rmi4: remove use of __devexit
  staging: tidspbridge: remove use of __devexit
  staging: vme: remove use of __devexit
  staging: vt6655: remove use of __devexit
  staging: wlags49_h2: remove use of __devexit
  staging: xgifb: remove use of __devexit
  staging: crystalhd: remove use of __devexit
  staging: et131x: remove use of __devexit
  staging: vt6656: remove use of __devexit
  ethernet: remove use of __devexit
  net: remove use of __devexit
  drivers/message/fusion: remove use of __devexit
  nfc: remove use of __devexit
  parport: remove use of __devexit
  pci: remove use of __devexit
  drm: remove use of __devexit
  drivers/message: remove use of __devexit
  platform/x86: remove use of __devexit
  ioc3: remove use of __devexit
  rpmsg: remove use of __devexit
  staging: lirc: remove use of __devexit
  staging: dt3155v4l: remove use of __devexit
  staging: solo6x10: remove use of __devexit
  arm: remove use of __devexit
  mips: remove use of __devexit
  powerpc: remove use of __devexit
  sparc: remove use of __devexit
  x86: remove use of __devexit
  Blackfin: remove use of __devexit
  rfkill: remove use of __devexit
  sound: remove use of __devexit
  samples/rpmsg: remove use of __devexit
  docbook: remove use of __devexit

 Documentation/DocBook/media/v4l/driver.xml         |   6 +-
 Documentation/DocBook/writing-an-alsa-driver.tmpl  |  68 +++--------
 arch/alpha/include/asm/parport.h                   |   4 +-
 arch/alpha/kernel/pci.c                            |  12 +-
 arch/alpha/kernel/smp.c                            |   8 +-
 arch/alpha/kernel/sys_titan.c                      |   3 +-
 arch/arm/common/sa1111.c                           |   5 +-
 arch/arm/common/scoop.c                            |   6 +-
 arch/arm/kernel/bios32.c                           |  20 +--
 arch/arm/kernel/etm.c                              |   4 +-
 arch/arm/kernel/perf_event_cpu.c                   |  10 +-
 arch/arm/kernel/perf_event_v6.c                    |   4 +-
 arch/arm/kernel/perf_event_v7.c                    |  12 +-
 arch/arm/kernel/perf_event_xscale.c                |   4 +-
 arch/arm/kernel/vmlinux.lds.S                      |   2 -
 arch/arm/mach-davinci/board-dm646x-evm.c           |   2 +-
 arch/arm/mach-davinci/cdce949.c                    |   4 +-
 arch/arm/mach-dove/pcie.c                          |   2 +-
 arch/arm/mach-imx/cpufreq.c                        |   2 +-
 arch/arm/mach-imx/mmdc.c                           |   2 +-
 arch/arm/mach-iop13xx/pci.c                        |   2 +-
 arch/arm/mach-kirkwood/pcie.c                      |   2 +-
 arch/arm/mach-ks8695/board-acs5k.c                 |   2 +-
 arch/arm/mach-mmp/sram.c                           |   4 +-
 arch/arm/mach-msm/proc_comm.c                      |   2 +-
 arch/arm/mach-msm/smd.c                            |   2 +-
 arch/arm/mach-mv78xx0/pcie.c                       |   2 +-
 arch/arm/mach-omap1/mailbox.c                      |   6 +-
 arch/arm/mach-omap2/gpmc.c                         |  12 +-
 arch/arm/mach-omap2/mailbox.c                      |   6 +-
 arch/arm/mach-orion5x/pci.c                        |   2 +-
 arch/arm/mach-prima2/pm.c                          |   2 +-
 arch/arm/mach-prima2/rtciobrg.c                    |   2 +-
 arch/arm/mach-pxa/corgi_pm.c                       |   2 +-
 arch/arm/mach-pxa/sharpsl_pm.c                     |   4 +-
 arch/arm/mach-pxa/spitz_pm.c                       |   2 +-
 arch/arm/mach-pxa/tosa-bt.c                        |   4 +-
 arch/arm/mach-s3c24xx/h1940-bluetooth.c            |   2 +-
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c            |   6 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |   4 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |  68 +++++------
 arch/arm/mach-sa1100/jornada720_ssp.c              |   2 +-
 arch/arm/mach-sa1100/neponset.c                    |   8 +-
 arch/arm/mach-tegra/pcie.c                         |   6 +-
 arch/arm/mach-tegra/tegra2_emc.c                   |   6 +-
 arch/arm/mach-u300/dummyspichip.c                  |   6 +-
 arch/arm/plat-omap/dma.c                           |   6 +-
 arch/arm/plat-omap/dmtimer.c                       |   6 +-
 arch/arm/plat-pxa/ssp.c                            |   6 +-
 arch/arm/plat-samsung/adc.c                        |   4 +-
 arch/arm64/kernel/perf_event.c                     |   2 +-
 arch/avr32/lib/delay.c                             |   2 +-
 arch/blackfin/mach-common/dpmc.c                   |   6 +-
 arch/cris/arch-v32/drivers/pci/bios.c              |   2 +-
 arch/cris/arch-v32/kernel/smp.c                    |   2 +-
 arch/frv/kernel/setup.c                            |   2 +-
 arch/frv/mb93090-mb00/pci-vdk.c                    |   6 +-
 arch/ia64/include/asm/acpi.h                       |   2 +-
 arch/ia64/include/asm/iosapic.h                    |  10 +-
 arch/ia64/include/asm/parport.h                    |   5 +-
 arch/ia64/include/asm/smp.h                        |   2 +-
 arch/ia64/kernel/acpi.c                            |   5 +-
 arch/ia64/kernel/iosapic.c                         |  15 +--
 arch/ia64/kernel/smpboot.c                         |  11 +-
 arch/ia64/kernel/time.c                            |   3 +-
 arch/ia64/mm/init.c                                |   5 +-
 arch/ia64/mm/tlb.c                                 |   3 +-
 arch/ia64/pci/fixup.c                              |   2 +-
 arch/ia64/pci/pci.c                                |  28 ++---
 arch/ia64/sn/kernel/io_common.c                    |   3 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c                |   2 +-
 arch/ia64/xen/irq_xen.c                            |   3 +-
 arch/m32r/kernel/smpboot.c                         |   2 +-
 arch/m68k/emu/nfeth.c                              |   2 +-
 arch/m68k/include/asm/parport.h                    |   4 +-
 arch/m68k/kernel/pcibios.c                         |   4 +-
 arch/microblaze/pci/pci-common.c                   |  26 ++--
 arch/mips/cavium-octeon/serial.c                   |   2 +-
 arch/mips/include/asm/pci.h                        |   2 +-
 arch/mips/kernel/smp.c                             |   2 +-
 arch/mips/lantiq/xway/dma.c                        |   3 +-
 arch/mips/lantiq/xway/gptu.c                       |   2 +-
 arch/mips/lantiq/xway/xrx200_phy_fw.c              |   2 +-
 arch/mips/mti-sead3/sead3-i2c-drv.c                |   6 +-
 arch/mips/mti-sead3/sead3-pic32-i2c-drv.c          |   7 +-
 arch/mips/pci/fixup-cobalt.c                       |   8 +-
 arch/mips/pci/fixup-emma2rh.c                      |   4 +-
 arch/mips/pci/fixup-fuloong2e.c                    |  12 +-
 arch/mips/pci/fixup-lemote2f.c                     |  12 +-
 arch/mips/pci/fixup-malta.c                        |  10 +-
 arch/mips/pci/fixup-rc32434.c                      |   6 +-
 arch/mips/pci/fixup-sb1250.c                       |   6 +-
 arch/mips/pci/ops-bcm63xx.c                        |   2 +-
 arch/mips/pci/ops-tx4927.c                         |   6 +-
 arch/mips/pci/pci-alchemy.c                        |   2 +-
 arch/mips/pci/pci-ip27.c                           |   4 +-
 arch/mips/pci/pci-lantiq.c                         |   4 +-
 arch/mips/pci/pci.c                                |  10 +-
 arch/mips/sni/setup.c                              |   2 +-
 arch/mips/txx9/generic/pci.c                       |  11 +-
 arch/mn10300/kernel/smp.c                          |   4 +-
 arch/mn10300/unit-asb2305/pci.c                    |   6 +-
 arch/openrisc/lib/delay.c                          |   2 +-
 arch/parisc/include/asm/parport.h                  |   2 +-
 arch/parisc/kernel/hardware.c                      |   7 +-
 arch/powerpc/include/asm/eeh.h                     |   6 +-
 arch/powerpc/include/asm/io-workarounds.h          |   2 +-
 arch/powerpc/include/asm/parport.h                 |   2 +-
 arch/powerpc/include/asm/smp.h                     |   4 +-
 arch/powerpc/include/asm/vio.h                     |   2 +-
 arch/powerpc/kernel/io-workarounds.c               |   6 +-
 arch/powerpc/kernel/isa-bridge.c                   |   6 +-
 arch/powerpc/kernel/of_platform.c                  |   2 +-
 arch/powerpc/kernel/pci-common.c                   |  26 ++--
 arch/powerpc/kernel/pci_32.c                       |   2 +-
 arch/powerpc/kernel/pci_64.c                       |  10 +-
 arch/powerpc/kernel/pci_dn.c                       |   4 +-
 arch/powerpc/kernel/pci_of_scan.c                  |   8 +-
 arch/powerpc/kernel/rtas_pci.c                     |   4 +-
 arch/powerpc/kernel/smp-tbsync.c                   |   8 +-
 arch/powerpc/kernel/smp.c                          |   8 +-
 arch/powerpc/kernel/vio.c                          |   4 +-
 arch/powerpc/mm/tlb_hash64.c                       |   8 +-
 arch/powerpc/platforms/44x/currituck.c             |   2 +-
 arch/powerpc/platforms/44x/virtex_ml510.c          |   2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c          |   6 +-
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |   8 +-
 arch/powerpc/platforms/82xx/ep8248e.c              |   2 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c     |   8 +-
 arch/powerpc/platforms/85xx/corenet_ds.c           |   2 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |   2 +-
 arch/powerpc/platforms/85xx/tqm85xx.c              |   2 +-
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |   2 +-
 arch/powerpc/platforms/86xx/gef_sbc310.c           |   2 +-
 arch/powerpc/platforms/86xx/gef_sbc610.c           |   2 +-
 arch/powerpc/platforms/cell/setup.c                |   2 +-
 arch/powerpc/platforms/cell/smp.c                  |   6 +-
 arch/powerpc/platforms/chrp/pci.c                  |   2 +-
 arch/powerpc/platforms/chrp/smp.c                  |   4 +-
 arch/powerpc/platforms/fsl_uli1575.c               |  20 +--
 arch/powerpc/platforms/maple/pci.c                 |   4 +-
 arch/powerpc/platforms/pasemi/gpio_mdio.c          |   2 +-
 arch/powerpc/platforms/pasemi/pasemi.h             |   4 +-
 arch/powerpc/platforms/pasemi/setup.c              |   4 +-
 arch/powerpc/platforms/powermac/pci.c              |   6 +-
 arch/powerpc/platforms/powermac/smp.c              |   8 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  36 +++---
 arch/powerpc/platforms/powernv/pci-p5ioc2.c        |   2 +-
 arch/powerpc/platforms/powernv/pci.c               |   9 +-
 arch/powerpc/platforms/powernv/smp.c               |   2 +-
 arch/powerpc/platforms/ps3/repository.c            |   2 +-
 arch/powerpc/platforms/pseries/eeh_dev.c           |   4 +-
 arch/powerpc/platforms/pseries/eeh_pe.c            |   2 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |   2 +-
 arch/powerpc/platforms/pseries/smp.c               |   6 +-
 arch/powerpc/platforms/wsp/scom_smp.c              |   2 +-
 arch/powerpc/platforms/wsp/smp.c                   |   4 +-
 arch/powerpc/platforms/wsp/wsp.h                   |   2 +-
 arch/powerpc/platforms/wsp/wsp_pci.c               |   2 +-
 arch/powerpc/sysdev/bestcomm/bestcomm.c            |   7 +-
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c              |   6 +-
 arch/powerpc/sysdev/fsl_ifc.c                      |   4 +-
 arch/powerpc/sysdev/fsl_lbc.c                      |   4 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   4 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   4 +-
 arch/powerpc/sysdev/fsl_rio.c                      |   2 +-
 arch/powerpc/sysdev/mpic.c                         |   2 +-
 arch/powerpc/sysdev/mpic_msgr.c                    |   2 +-
 arch/powerpc/sysdev/mv64x60_pci.c                  |   2 +-
 arch/powerpc/sysdev/ppc4xx_msi.c                   |   2 +-
 arch/s390/kernel/smp.c                             |   6 +-
 arch/score/mm/cache.c                              |   2 +-
 arch/sh/drivers/pci/fixups-dreamcast.c             |   2 +-
 arch/sh/drivers/pci/pci.c                          |   8 +-
 arch/sh/drivers/pci/pcie-sh7786.c                  |   2 +-
 arch/sparc/include/asm/parport.h                   |   6 +-
 arch/sparc/include/asm/timer_64.h                  |   2 +-
 arch/sparc/kernel/apc.c                            |   4 +-
 arch/sparc/kernel/auxio_64.c                       |   2 +-
 arch/sparc/kernel/central.c                        |   6 +-
 arch/sparc/kernel/chmc.c                           |  20 +--
 arch/sparc/kernel/ds.c                             |   4 +-
 arch/sparc/kernel/ldc.c                            |   2 +-
 arch/sparc/kernel/leon_pci.c                       |   2 +-
 arch/sparc/kernel/leon_pci_grpci2.c                |   2 +-
 arch/sparc/kernel/pci.c                            |  18 +--
 arch/sparc/kernel/pci_fire.c                       |   4 +-
 arch/sparc/kernel/pci_psycho.c                     |   8 +-
 arch/sparc/kernel/pci_sabre.c                      |   6 +-
 arch/sparc/kernel/pci_schizo.c                     |  10 +-
 arch/sparc/kernel/pci_sun4v.c                      |  10 +-
 arch/sparc/kernel/pcic.c                           |   4 +-
 arch/sparc/kernel/pmc.c                            |   2 +-
 arch/sparc/kernel/power.c                          |   4 +-
 arch/sparc/kernel/smp_64.c                         |   4 +-
 arch/sparc/kernel/time_32.c                        |   2 +-
 arch/sparc/kernel/time_64.c                        |  10 +-
 arch/sparc/mm/init_64.c                            |   6 +-
 arch/tile/include/asm/pci.h                        |   2 +-
 arch/tile/kernel/pci.c                             |  12 +-
 arch/tile/kernel/pci_gx.c                          |  22 ++--
 arch/unicore32/kernel/pci.c                        |   4 +-
 arch/x86/include/asm/parport.h                     |   4 +-
 arch/x86/include/asm/pci_x86.h                     |   4 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   4 +-
 arch/x86/kernel/pci-dma.c                          |   2 +-
 arch/x86/kernel/quirks.c                           |   4 +-
 arch/x86/lib/delay.c                               |   2 +-
 arch/x86/pci/acpi.c                                |   8 +-
 arch/x86/pci/bus_numa.c                            |   2 +-
 arch/x86/pci/common.c                              |  26 ++--
 arch/x86/pci/fixup.c                               |  30 ++---
 arch/x86/pci/legacy.c                              |   4 +-
 arch/x86/pci/mmconfig-shared.c                     |  12 +-
 arch/x86/pci/mmconfig_32.c                         |   2 +-
 arch/x86/pci/mmconfig_64.c                         |   4 +-
 arch/x86/pci/mrst.c                                |   6 +-
 arch/x86/pci/numaq_32.c                            |   2 +-
 arch/x86/pci/pcbios.c                              |   4 +-
 arch/x86/platform/mrst/mrst.c                      |   2 +-
 arch/x86/platform/olpc/olpc-xo1-pm.c               |   8 +-
 arch/x86/platform/olpc/olpc-xo1-sci.c              |  18 +--
 arch/x86/platform/scx200/scx200_32.c               |   6 +-
 drivers/acpi/apei/ghes.c                           |   4 +-
 drivers/acpi/hed.c                                 |   4 +-
 drivers/acpi/pci_root.c                            |   2 +-
 drivers/amba/bus.c                                 |   4 -
 drivers/amba/tegra-ahb.c                           |   4 +-
 drivers/ata/ahci_platform.c                        |   4 +-
 drivers/ata/ata_piix.c                             |  10 +-
 drivers/ata/pata_arasan_cf.c                       |   6 +-
 drivers/ata/pata_at91.c                            |   6 +-
 drivers/ata/pata_bf54x.c                           |   6 +-
 drivers/ata/pata_cs5520.c                          |   2 +-
 drivers/ata/pata_ep93xx.c                          |   6 +-
 drivers/ata/pata_icside.c                          |  14 +--
 drivers/ata/pata_imx.c                             |   6 +-
 drivers/ata/pata_ixp4xx_cf.c                       |   6 +-
 drivers/ata/pata_macio.c                           |  16 +--
 drivers/ata/pata_mpc52xx.c                         |   4 +-
 drivers/ata/pata_octeon_cf.c                       |   2 +-
 drivers/ata/pata_of_platform.c                     |   6 +-
 drivers/ata/pata_palmld.c                          |   6 +-
 drivers/ata/pata_pdc2027x.c                        |   2 +-
 drivers/ata/pata_platform.c                        |   8 +-
 drivers/ata/pata_pxa.c                             |   6 +-
 drivers/ata/pata_rb532_cf.c                        |   6 +-
 drivers/ata/pata_rdc.c                             |   2 +-
 drivers/ata/pata_sch.c                             |   2 +-
 drivers/ata/pata_sil680.c                          |   2 +-
 drivers/ata/sata_highbank.c                        |   4 +-
 drivers/ata/sata_mv.c                              |   8 +-
 drivers/ata/sata_vsc.c                             |   4 +-
 drivers/atm/ambassador.c                           |  28 ++---
 drivers/atm/eni.c                                  |  16 +--
 drivers/atm/firestream.c                           |  26 ++--
 drivers/atm/fore200e.c                             |  52 ++++----
 drivers/atm/he.c                                   |  24 ++--
 drivers/atm/horizon.c                              |  10 +-
 drivers/atm/idt77252.c                             |  10 +-
 drivers/atm/iphase.c                               |  10 +-
 drivers/atm/lanai.c                                |  24 ++--
 drivers/atm/nicstar.c                              |  16 +--
 drivers/atm/solos-pci.c                            |   2 +-
 drivers/atm/zatm.c                                 |  20 +--
 drivers/auxdisplay/cfag12864bfb.c                  |  10 +-
 drivers/base/bus.c                                 |  14 ---
 drivers/bcma/bcma_private.h                        |   6 +-
 drivers/bcma/driver_gmac_cmn.c                     |   2 +-
 drivers/bcma/driver_pci.c                          |   4 +-
 drivers/bcma/driver_pci_host.c                     |   8 +-
 drivers/bcma/host_pci.c                            |   6 +-
 drivers/bcma/main.c                                |   2 +-
 drivers/block/cciss.c                              |  66 +++++-----
 drivers/block/cpqarray.c                           |  14 +--
 drivers/block/nvme.c                               |  14 +--
 drivers/block/ps3disk.c                            |   2 +-
 drivers/block/ps3vram.c                            |   4 +-
 drivers/block/sunvdc.c                             |   8 +-
 drivers/block/swim.c                               |  10 +-
 drivers/block/swim3.c                              |   2 +-
 drivers/block/umem.c                               |   2 +-
 drivers/block/virtio_blk.c                         |   8 +-
 drivers/block/xsysace.c                            |  16 +--
 drivers/bus/omap-ocp2scp.c                         |   6 +-
 drivers/bus/omap_l3_noc.c                          |   6 +-
 drivers/cdrom/gdrom.c                              |  18 +--
 drivers/char/agp/ali-agp.c                         |   6 +-
 drivers/char/agp/amd-k7-agp.c                      |   6 +-
 drivers/char/agp/amd64-agp.c                       |  14 +--
 drivers/char/agp/ati-agp.c                         |   6 +-
 drivers/char/agp/efficeon-agp.c                    |   4 +-
 drivers/char/agp/i460-agp.c                        |   6 +-
 drivers/char/agp/intel-agp.c                       |   6 +-
 drivers/char/agp/nvidia-agp.c                      |   4 +-
 drivers/char/agp/sgi-agp.c                         |   4 +-
 drivers/char/agp/sis-agp.c                         |  12 +-
 drivers/char/agp/sworks-agp.c                      |   4 +-
 drivers/char/agp/uninorth-agp.c                    |   6 +-
 drivers/char/agp/via-agp.c                         |   6 +-
 drivers/char/hw_random/atmel-rng.c                 |   4 +-
 drivers/char/hw_random/bcm63xx-rng.c               |   6 +-
 drivers/char/hw_random/exynos-rng.c                |   6 +-
 drivers/char/hw_random/n2-drv.c                    |  10 +-
 drivers/char/hw_random/octeon-rng.c                |   2 +-
 drivers/char/hw_random/omap-rng.c                  |   2 +-
 drivers/char/hw_random/pasemi-rng.c                |   4 +-
 drivers/char/hw_random/picoxcell-rng.c             |   4 +-
 drivers/char/hw_random/ppc4xx-rng.c                |   4 +-
 drivers/char/hw_random/timeriomem-rng.c            |   6 +-
 drivers/char/hw_random/virtio-rng.c                |   4 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  38 +++---
 drivers/char/mbcs.c                                |   2 +-
 drivers/char/ps3flash.c                            |   2 +-
 drivers/char/sonypi.c                              |  14 +--
 drivers/char/tb0219.c                              |   6 +-
 drivers/char/tpm/tpm_i2c_infineon.c                |   6 +-
 drivers/char/tpm/tpm_ibmvtpm.c                     |   6 +-
 drivers/char/tpm/tpm_infineon.c                    |   6 +-
 drivers/char/tpm/tpm_tis.c                         |   6 +-
 drivers/char/virtio_console.c                      |   2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |  14 +--
 drivers/clk/clk-max77686.c                         |   6 +-
 drivers/clk/clk-twl6040.c                          |   6 +-
 drivers/clk/clk-wm831x.c                           |   6 +-
 drivers/clocksource/acpi_pm.c                      |   6 +-
 drivers/clocksource/em_sti.c                       |   8 +-
 drivers/clocksource/sh_cmt.c                       |   6 +-
 drivers/clocksource/sh_mtu2.c                      |   6 +-
 drivers/clocksource/sh_tmu.c                       |   6 +-
 drivers/connector/connector.c                      |   4 +-
 drivers/cpufreq/cpufreq-cpu0.c                     |   2 +-
 drivers/cpufreq/longhaul.c                         |   4 +-
 drivers/cpufreq/powernow-k8.c                      |   4 +-
 drivers/crypto/atmel-aes.c                         |   6 +-
 drivers/crypto/atmel-sha.c                         |   6 +-
 drivers/crypto/atmel-tdes.c                        |   6 +-
 drivers/crypto/bfin_crc.c                          |   6 +-
 drivers/crypto/caam/ctrl.c                         |   2 +-
 drivers/crypto/geode-aes.c                         |   6 +-
 drivers/crypto/hifn_795x.c                         |   6 +-
 drivers/crypto/mv_cesa.c                           |   2 +-
 drivers/crypto/n2_core.c                           |  38 +++---
 drivers/crypto/nx/nx.c                             |   6 +-
 drivers/crypto/omap-sham.c                         |   4 +-
 drivers/crypto/picoxcell_crypto.c                  |   6 +-
 drivers/crypto/tegra-aes.c                         |   6 +-
 drivers/devfreq/exynos4_bus.c                      |   6 +-
 drivers/dma/dw_dmac.c                              |   8 +-
 drivers/dma/edma.c                                 |   6 +-
 drivers/dma/fsldma.c                               |   4 +-
 drivers/dma/intel_mid_dma.c                        |   6 +-
 drivers/dma/ioat/dca.c                             |   9 +-
 drivers/dma/ioat/dma.c                             |  12 +-
 drivers/dma/ioat/dma.h                             |  12 +-
 drivers/dma/ioat/dma_v2.c                          |   2 +-
 drivers/dma/ioat/dma_v2.h                          |   8 +-
 drivers/dma/ioat/dma_v3.c                          |   8 +-
 drivers/dma/ioat/pci.c                             |  10 +-
 drivers/dma/iop-adma.c                             |  12 +-
 drivers/dma/mmp_pdma.c                             |   8 +-
 drivers/dma/mmp_tdma.c                             |   8 +-
 drivers/dma/mpc512x_dma.c                          |   6 +-
 drivers/dma/mv_xor.c                               |  10 +-
 drivers/dma/pch_dma.c                              |   6 +-
 drivers/dma/pl330.c                                |   4 +-
 drivers/dma/ppc4xx/adma.c                          |   8 +-
 drivers/dma/sa11x0-dma.c                           |   8 +-
 drivers/dma/sh/shdma.c                             |   8 +-
 drivers/dma/sirf-dma.c                             |   6 +-
 drivers/dma/tegra20-apb-dma.c                      |  10 +-
 drivers/dma/timb_dma.c                             |   4 +-
 drivers/edac/amd64_edac.c                          |   6 +-
 drivers/edac/amd76x_edac.c                         |   6 +-
 drivers/edac/cell_edac.c                           |   8 +-
 drivers/edac/cpc925_edac.c                         |   2 +-
 drivers/edac/e752x_edac.c                          |   6 +-
 drivers/edac/e7xxx_edac.c                          |   6 +-
 drivers/edac/highbank_l2_edac.c                    |   2 +-
 drivers/edac/highbank_mc_edac.c                    |   6 +-
 drivers/edac/i3000_edac.c                          |   6 +-
 drivers/edac/i3200_edac.c                          |   6 +-
 drivers/edac/i5000_edac.c                          |   6 +-
 drivers/edac/i5100_edac.c                          |  18 +--
 drivers/edac/i5400_edac.c                          |   6 +-
 drivers/edac/i7300_edac.c                          |   8 +-
 drivers/edac/i7core_edac.c                         |   6 +-
 drivers/edac/i82443bxgx_edac.c                     |   6 +-
 drivers/edac/i82860_edac.c                         |   6 +-
 drivers/edac/i82875p_edac.c                        |   6 +-
 drivers/edac/i82975x_edac.c                        |   6 +-
 drivers/edac/mpc85xx_edac.c                        |   8 +-
 drivers/edac/mv64x60_edac.c                        |  10 +-
 drivers/edac/octeon_edac-l2c.c                     |   2 +-
 drivers/edac/octeon_edac-lmc.c                     |   2 +-
 drivers/edac/octeon_edac-pc.c                      |   2 +-
 drivers/edac/octeon_edac-pci.c                     |   2 +-
 drivers/edac/pasemi_edac.c                         |   6 +-
 drivers/edac/ppc4xx_edac.c                         |  14 +--
 drivers/edac/r82600_edac.c                         |   6 +-
 drivers/edac/sb_edac.c                             |   6 +-
 drivers/edac/tile_edac.c                           |   8 +-
 drivers/edac/x38_edac.c                            |   6 +-
 drivers/extcon/extcon-adc-jack.c                   |   6 +-
 drivers/extcon/extcon-arizona.c                    |   6 +-
 drivers/extcon/extcon-gpio.c                       |   6 +-
 drivers/extcon/extcon-max77693.c                   |   6 +-
 drivers/extcon/extcon-max8997.c                    |   6 +-
 drivers/firewire/nosy.c                            |   4 +-
 drivers/firewire/ohci.c                            |   2 +-
 drivers/firmware/dcdbas.c                          |   6 +-
 drivers/gpio/gpio-74x164.c                         |   6 +-
 drivers/gpio/gpio-ab8500.c                         |   6 +-
 drivers/gpio/gpio-adnp.c                           |  10 +-
 drivers/gpio/gpio-adp5520.c                        |   6 +-
 drivers/gpio/gpio-adp5588.c                        |   6 +-
 drivers/gpio/gpio-arizona.c                        |   6 +-
 drivers/gpio/gpio-cs5535.c                         |   6 +-
 drivers/gpio/gpio-da9052.c                         |   8 +-
 drivers/gpio/gpio-da9055.c                         |   8 +-
 drivers/gpio/gpio-em.c                             |   6 +-
 drivers/gpio/gpio-ep93xx.c                         |   2 +-
 drivers/gpio/gpio-generic.c                        |   6 +-
 drivers/gpio/gpio-ich.c                            |  10 +-
 drivers/gpio/gpio-janz-ttl.c                       |  10 +-
 drivers/gpio/gpio-langwell.c                       |   8 +-
 drivers/gpio/gpio-lpc32xx.c                        |   4 +-
 drivers/gpio/gpio-max7300.c                        |   6 +-
 drivers/gpio/gpio-max7301.c                        |   6 +-
 drivers/gpio/gpio-max730x.c                        |   4 +-
 drivers/gpio/gpio-max732x.c                        |   8 +-
 drivers/gpio/gpio-mc33880.c                        |   6 +-
 drivers/gpio/gpio-mcp23s08.c                       |   6 +-
 drivers/gpio/gpio-ml-ioh.c                         |   8 +-
 drivers/gpio/gpio-mpc5200.c                        |   4 +-
 drivers/gpio/gpio-msic.c                           |   2 +-
 drivers/gpio/gpio-msm-v2.c                         |   6 +-
 drivers/gpio/gpio-mvebu.c                          |   4 +-
 drivers/gpio/gpio-mxc.c                            |   4 +-
 drivers/gpio/gpio-mxs.c                            |   2 +-
 drivers/gpio/gpio-omap.c                           |   6 +-
 drivers/gpio/gpio-pca953x.c                        |   6 +-
 drivers/gpio/gpio-pch.c                            |   8 +-
 drivers/gpio/gpio-pxa.c                            |   6 +-
 drivers/gpio/gpio-rc5t583.c                        |   6 +-
 drivers/gpio/gpio-rdc321x.c                        |   6 +-
 drivers/gpio/gpio-sch.c                            |   6 +-
 drivers/gpio/gpio-sodaville.c                      |   4 +-
 drivers/gpio/gpio-sta2x11.c                        |   4 +-
 drivers/gpio/gpio-stmpe.c                          |   8 +-
 drivers/gpio/gpio-stp-xway.c                       |   2 +-
 drivers/gpio/gpio-sx150x.c                         |   6 +-
 drivers/gpio/gpio-tc3589x.c                        |   6 +-
 drivers/gpio/gpio-tegra.c                          |   4 +-
 drivers/gpio/gpio-timberdale.c                     |   4 +-
 drivers/gpio/gpio-tps6586x.c                       |   6 +-
 drivers/gpio/gpio-tps65910.c                       |   6 +-
 drivers/gpio/gpio-tps65912.c                       |   6 +-
 drivers/gpio/gpio-twl4030.c                        |   8 +-
 drivers/gpio/gpio-twl6040.c                        |   4 +-
 drivers/gpio/gpio-vr41xx.c                         |   6 +-
 drivers/gpio/gpio-vt8500.c                         |   2 +-
 drivers/gpio/gpio-vx855.c                          |   6 +-
 drivers/gpio/gpio-wm831x.c                         |   6 +-
 drivers/gpio/gpio-wm8350.c                         |   6 +-
 drivers/gpio/gpio-wm8994.c                         |   6 +-
 drivers/gpio/gpio-xilinx.c                         |   4 +-
 drivers/gpu/drm/ast/ast_drv.c                      |   2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c                |   2 +-
 drivers/gpu/drm/exynos/exynos_ddc.c                |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |   6 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   6 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |   6 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   6 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   8 +-
 drivers/gpu/drm/exynos/exynos_hdmiphy.c            |   2 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |   8 +-
 drivers/gpu/drm/gma500/tc35876x-dsi-lvds.c         |   4 +-
 drivers/gpu/drm/i915/i915_drv.c                    |   2 +-
 drivers/gpu/drm/mgag200/mgag200_drv.c              |   2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   2 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   2 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |  10 +-
 drivers/hsi/clients/hsi_char.c                     |   8 +-
 drivers/hwmon/abituguru.c                          |  12 +-
 drivers/hwmon/abituguru3.c                         |   6 +-
 drivers/hwmon/ad7314.c                             |   6 +-
 drivers/hwmon/ad7414.c                             |   4 +-
 drivers/hwmon/adcxx.c                              |   6 +-
 drivers/hwmon/ads7871.c                            |   6 +-
 drivers/hwmon/adt7411.c                            |   6 +-
 drivers/hwmon/coretemp.c                           |   8 +-
 drivers/hwmon/da9052-hwmon.c                       |   6 +-
 drivers/hwmon/da9055-hwmon.c                       |   6 +-
 drivers/hwmon/dme1737.c                            |   6 +-
 drivers/hwmon/f71805f.c                            |   8 +-
 drivers/hwmon/f71882fg.c                           |   8 +-
 drivers/hwmon/fam15h_power.c                       |  10 +-
 drivers/hwmon/gpio-fan.c                           |   8 +-
 drivers/hwmon/hih6130.c                            |   6 +-
 drivers/hwmon/i5k_amb.c                            |  18 +--
 drivers/hwmon/it87.c                               |  12 +-
 drivers/hwmon/jz4740-hwmon.c                       |   6 +-
 drivers/hwmon/k10temp.c                            |   8 +-
 drivers/hwmon/k8temp.c                             |   8 +-
 drivers/hwmon/lm70.c                               |   6 +-
 drivers/hwmon/lm78.c                               |   6 +-
 drivers/hwmon/max1111.c                            |   8 +-
 drivers/hwmon/max197.c                             |   6 +-
 drivers/hwmon/mc13783-adc.c                        |   4 +-
 drivers/hwmon/ntc_thermistor.c                     |   6 +-
 drivers/hwmon/pc87360.c                            |   8 +-
 drivers/hwmon/pc87427.c                            |  10 +-
 drivers/hwmon/s3c-hwmon.c                          |   6 +-
 drivers/hwmon/sch5627.c                            |   4 +-
 drivers/hwmon/sch5636.c                            |   2 +-
 drivers/hwmon/sht15.c                              |   6 +-
 drivers/hwmon/sht21.c                              |   6 +-
 drivers/hwmon/sis5595.c                            |  16 +--
 drivers/hwmon/smsc47b397.c                         |   6 +-
 drivers/hwmon/tmp102.c                             |   6 +-
 drivers/hwmon/twl4030-madc-hwmon.c                 |   4 +-
 drivers/hwmon/ultra45_env.c                        |   6 +-
 drivers/hwmon/vexpress.c                           |   4 +-
 drivers/hwmon/via-cputemp.c                        |   6 +-
 drivers/hwmon/via686a.c                            |  14 +--
 drivers/hwmon/vt1211.c                             |   8 +-
 drivers/hwmon/vt8231.c                             |  12 +-
 drivers/hwmon/w83627ehf.c                          |  12 +-
 drivers/hwmon/w83627hf.c                           |  14 +--
 drivers/hwmon/w83781d.c                            |   6 +-
 drivers/hwmon/wm831x-hwmon.c                       |   6 +-
 drivers/hwmon/wm8350-hwmon.c                       |   6 +-
 drivers/hwspinlock/omap_hwspinlock.c               |   6 +-
 drivers/hwspinlock/u8500_hsem.c                    |   6 +-
 drivers/i2c/busses/i2c-ali1535.c                   |   8 +-
 drivers/i2c/busses/i2c-ali1563.c                   |   8 +-
 drivers/i2c/busses/i2c-ali15x3.c                   |   8 +-
 drivers/i2c/busses/i2c-amd756.c                    |   6 +-
 drivers/i2c/busses/i2c-amd8111.c                   |   6 +-
 drivers/i2c/busses/i2c-at91.c                      |  10 +-
 drivers/i2c/busses/i2c-au1550.c                    |   6 +-
 drivers/i2c/busses/i2c-cpm.c                       |   8 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |   6 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   6 +-
 drivers/i2c/busses/i2c-eg20t.c                     |   6 +-
 drivers/i2c/busses/i2c-elektor.c                   |   8 +-
 drivers/i2c/busses/i2c-gpio.c                      |   8 +-
 drivers/i2c/busses/i2c-highlander.c                |   6 +-
 drivers/i2c/busses/i2c-hydra.c                     |   6 +-
 drivers/i2c/busses/i2c-i801.c                      |  24 ++--
 drivers/i2c/busses/i2c-ibm_iic.c                   |   8 +-
 drivers/i2c/busses/i2c-intel-mid.c                 |   6 +-
 drivers/i2c/busses/i2c-isch.c                      |   6 +-
 drivers/i2c/busses/i2c-mpc.c                       |  38 +++---
 drivers/i2c/busses/i2c-mv64xxx.c                   |  18 +--
 drivers/i2c/busses/i2c-mxs.c                       |   6 +-
 drivers/i2c/busses/i2c-nforce2.c                   |  10 +-
 drivers/i2c/busses/i2c-nuc900.c                    |   6 +-
 drivers/i2c/busses/i2c-ocores.c                    |   6 +-
 drivers/i2c/busses/i2c-octeon.c                    |  10 +-
 drivers/i2c/busses/i2c-omap.c                      |   6 +-
 drivers/i2c/busses/i2c-parport-light.c             |   6 +-
 drivers/i2c/busses/i2c-pasemi.c                    |   6 +-
 drivers/i2c/busses/i2c-pca-isa.c                   |   8 +-
 drivers/i2c/busses/i2c-pca-platform.c              |   6 +-
 drivers/i2c/busses/i2c-piix4.c                     |  20 +--
 drivers/i2c/busses/i2c-pmcmsp.c                    |   6 +-
 drivers/i2c/busses/i2c-pnx.c                       |   6 +-
 drivers/i2c/busses/i2c-powermac.c                  |  16 +--
 drivers/i2c/busses/i2c-puv3.c                      |   6 +-
 drivers/i2c/busses/i2c-pxa-pci.c                   |   6 +-
 drivers/i2c/busses/i2c-rcar.c                      |   6 +-
 drivers/i2c/busses/i2c-s6000.c                     |   8 +-
 drivers/i2c/busses/i2c-sh7760.c                    |   8 +-
 drivers/i2c/busses/i2c-sh_mobile.c                 |   2 +-
 drivers/i2c/busses/i2c-sirf.c                      |   8 +-
 drivers/i2c/busses/i2c-sis5595.c                   |   4 +-
 drivers/i2c/busses/i2c-sis630.c                    |   8 +-
 drivers/i2c/busses/i2c-sis96x.c                    |   6 +-
 drivers/i2c/busses/i2c-tegra.c                     |   8 +-
 drivers/i2c/busses/i2c-via.c                       |   6 +-
 drivers/i2c/busses/i2c-viapro.c                    |   2 +-
 drivers/i2c/busses/i2c-xiic.c                      |   8 +-
 drivers/i2c/busses/i2c-xlr.c                       |   6 +-
 drivers/i2c/busses/scx200_acb.c                    |  16 +--
 drivers/i2c/i2c-core.c                             |   7 --
 drivers/i2c/muxes/i2c-mux-gpio.c                   |   8 +-
 drivers/i2c/muxes/i2c-mux-pinctrl.c                |   8 +-
 drivers/ide/aec62xx.c                              |   8 +-
 drivers/ide/alim15x3.c                             |   8 +-
 drivers/ide/amd74xx.c                              |   4 +-
 drivers/ide/atiixp.c                               |   4 +-
 drivers/ide/cmd64x.c                               |   4 +-
 drivers/ide/cs5520.c                               |   4 +-
 drivers/ide/cs5530.c                               |   6 +-
 drivers/ide/cs5535.c                               |   4 +-
 drivers/ide/cy82c693.c                             |  10 +-
 drivers/ide/delkin_cb.c                            |   4 +-
 drivers/ide/hpt366.c                               |  42 +++----
 drivers/ide/icside.c                               |  10 +-
 drivers/ide/ide-pci-generic.c                      |   4 +-
 drivers/ide/ide_platform.c                         |   8 +-
 drivers/ide/it8172.c                               |   4 +-
 drivers/ide/it8213.c                               |   4 +-
 drivers/ide/it821x.c                               |  10 +-
 drivers/ide/jmicron.c                              |   4 +-
 drivers/ide/ns87415.c                              |   8 +-
 drivers/ide/opti621.c                              |   4 +-
 drivers/ide/palm_bk3710.c                          |   6 +-
 drivers/ide/pdc202xx_new.c                         |  10 +-
 drivers/ide/pdc202xx_old.c                         |   6 +-
 drivers/ide/piix.c                                 |   8 +-
 drivers/ide/pmac.c                                 |  10 +-
 drivers/ide/rapide.c                               |   6 +-
 drivers/ide/rz1000.c                               |   6 +-
 drivers/ide/sc1200.c                               |   4 +-
 drivers/ide/scc_pata.c                             |  18 +--
 drivers/ide/serverworks.c                          |   4 +-
 drivers/ide/sgiioc4.c                              |  12 +-
 drivers/ide/siimage.c                              |  12 +-
 drivers/ide/sis5513.c                              |  10 +-
 drivers/ide/sl82c105.c                             |   4 +-
 drivers/ide/slc90e66.c                             |   4 +-
 drivers/ide/tc86c001.c                             |  10 +-
 drivers/ide/triflex.c                              |   4 +-
 drivers/ide/trm290.c                               |   6 +-
 drivers/ide/via82cxxx.c                            |   8 +-
 drivers/iio/accel/hid-sensor-accel-3d.c            |   4 +-
 drivers/iio/adc/ad7266.c                           |   8 +-
 drivers/iio/adc/ad7476.c                           |   6 +-
 drivers/iio/adc/ad7791.c                           |   8 +-
 drivers/iio/adc/ad7887.c                           |   6 +-
 drivers/iio/adc/at91_adc.c                         |   6 +-
 drivers/iio/adc/lp8788_adc.c                       |   6 +-
 drivers/iio/adc/max1363.c                          |  10 +-
 drivers/iio/adc/ti_am335x_adc.c                    |   6 +-
 drivers/iio/amplifiers/ad8366.c                    |   6 +-
 drivers/iio/dac/ad5064.c                           |  16 +--
 drivers/iio/dac/ad5360.c                           |   8 +-
 drivers/iio/dac/ad5380.c                           |  18 +--
 drivers/iio/dac/ad5421.c                           |   6 +-
 drivers/iio/dac/ad5446.c                           |  14 +--
 drivers/iio/dac/ad5449.c                           |   6 +-
 drivers/iio/dac/ad5504.c                           |   6 +-
 drivers/iio/dac/ad5624r_spi.c                      |   6 +-
 drivers/iio/dac/ad5686.c                           |   6 +-
 drivers/iio/dac/ad5755.c                           |  12 +-
 drivers/iio/dac/ad5764.c                           |   6 +-
 drivers/iio/dac/ad5791.c                           |   6 +-
 drivers/iio/dac/max517.c                           |   6 +-
 drivers/iio/dac/mcp4725.c                          |   6 +-
 drivers/iio/frequency/ad9523.c                     |   6 +-
 drivers/iio/frequency/adf4350.c                    |   6 +-
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |   4 +-
 drivers/iio/light/adjd_s311.c                      |   6 +-
 drivers/iio/light/hid-sensor-als.c                 |   4 +-
 drivers/iio/light/lm3533-als.c                     |  16 +--
 drivers/iio/light/vcnl4000.c                       |   6 +-
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |   4 +-
 drivers/infiniband/hw/amso1100/c2.c                |   6 +-
 drivers/infiniband/hw/amso1100/c2.h                |   8 +-
 drivers/infiniband/hw/amso1100/c2_pd.c             |   4 +-
 drivers/infiniband/hw/amso1100/c2_qp.c             |   4 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c           |   4 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |   4 +-
 drivers/infiniband/hw/ipath/ipath_driver.c         |  10 +-
 drivers/infiniband/hw/mthca/mthca_main.c           |   8 +-
 drivers/infiniband/hw/nes/nes.c                    |   6 +-
 drivers/infiniband/hw/qib/qib_init.c               |  10 +-
 drivers/input/gameport/emu10k1-gp.c                |   6 +-
 drivers/input/gameport/fm801-gp.c                  |   6 +-
 drivers/input/joystick/as5011.c                    |   8 +-
 drivers/input/joystick/maplecontrol.c              |   6 +-
 drivers/input/keyboard/adp5520-keys.c              |   6 +-
 drivers/input/keyboard/adp5588-keys.c              |  16 +--
 drivers/input/keyboard/adp5589-keys.c              |  18 +--
 drivers/input/keyboard/bf54x-keys.c                |   6 +-
 drivers/input/keyboard/davinci_keyscan.c           |   4 +-
 drivers/input/keyboard/ep93xx_keypad.c             |   6 +-
 drivers/input/keyboard/gpio_keys.c                 |  11 +-
 drivers/input/keyboard/gpio_keys_polled.c          |   9 +-
 drivers/input/keyboard/hilkbd.c                    |  10 +-
 drivers/input/keyboard/imx_keypad.c                |   6 +-
 drivers/input/keyboard/jornada680_kbd.c            |   6 +-
 drivers/input/keyboard/jornada720_kbd.c            |   6 +-
 drivers/input/keyboard/lm8323.c                    |   6 +-
 drivers/input/keyboard/lm8333.c                    |   6 +-
 drivers/input/keyboard/locomokbd.c                 |   8 +-
 drivers/input/keyboard/lpc32xx-keys.c              |   8 +-
 drivers/input/keyboard/matrix_keypad.c             |   8 +-
 drivers/input/keyboard/max7359_keypad.c            |   6 +-
 drivers/input/keyboard/mcs_touchkey.c              |   6 +-
 drivers/input/keyboard/mpr121_touchkey.c           |  10 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |   4 +-
 drivers/input/keyboard/omap-keypad.c               |   6 +-
 drivers/input/keyboard/omap4-keypad.c              |   8 +-
 drivers/input/keyboard/opencores-kbd.c             |   6 +-
 drivers/input/keyboard/pmic8xxx-keypad.c           |  10 +-
 drivers/input/keyboard/pxa27x_keypad.c             |   6 +-
 drivers/input/keyboard/pxa930_rotary.c             |   6 +-
 drivers/input/keyboard/qt1070.c                    |   8 +-
 drivers/input/keyboard/qt2160.c                    |  12 +-
 drivers/input/keyboard/samsung-keypad.c            |   6 +-
 drivers/input/keyboard/sh_keysc.c                  |   6 +-
 drivers/input/keyboard/spear-keyboard.c            |   8 +-
 drivers/input/keyboard/stmpe-keypad.c              |  10 +-
 drivers/input/keyboard/tc3589x-keypad.c            |   6 +-
 drivers/input/keyboard/tca6416-keypad.c            |   8 +-
 drivers/input/keyboard/tca8418_keypad.c            |   8 +-
 drivers/input/keyboard/tegra-kbc.c                 |  16 +--
 drivers/input/keyboard/tnetv107x-keypad.c          |   6 +-
 drivers/input/keyboard/twl4030_keypad.c            |   8 +-
 drivers/input/keyboard/w90p910_keypad.c            |   6 +-
 drivers/input/misc/88pm80x_onkey.c                 |   6 +-
 drivers/input/misc/88pm860x_onkey.c                |   6 +-
 drivers/input/misc/ab8500-ponkey.c                 |   6 +-
 drivers/input/misc/ad714x-i2c.c                    |   6 +-
 drivers/input/misc/ad714x-spi.c                    |   6 +-
 drivers/input/misc/adxl34x-i2c.c                   |   6 +-
 drivers/input/misc/adxl34x-spi.c                   |   6 +-
 drivers/input/misc/bfin_rotary.c                   |   6 +-
 drivers/input/misc/bma150.c                        |  28 ++---
 drivers/input/misc/cma3000_d0x_i2c.c               |   6 +-
 drivers/input/misc/cobalt_btns.c                   |   6 +-
 drivers/input/misc/da9052_onkey.c                  |   6 +-
 drivers/input/misc/da9055_onkey.c                  |   6 +-
 drivers/input/misc/dm355evm_keys.c                 |   6 +-
 drivers/input/misc/gp2ap002a00f.c                  |   8 +-
 drivers/input/misc/gpio_tilt_polled.c              |   6 +-
 drivers/input/misc/ixp4xx-beeper.c                 |   6 +-
 drivers/input/misc/kxtj9.c                         |  16 +--
 drivers/input/misc/m68kspkr.c                      |   6 +-
 drivers/input/misc/max8925_onkey.c                 |   6 +-
 drivers/input/misc/max8997_haptic.c                |   6 +-
 drivers/input/misc/mc13783-pwrbutton.c             |   6 +-
 drivers/input/misc/mma8450.c                       |   6 +-
 drivers/input/misc/mpu3050.c                       |   8 +-
 drivers/input/misc/pcap_keys.c                     |   6 +-
 drivers/input/misc/pcf50633-input.c                |   6 +-
 drivers/input/misc/pcf8574_keypad.c                |   6 +-
 drivers/input/misc/pcspkr.c                        |   6 +-
 drivers/input/misc/pm8xxx-vibrator.c               |   6 +-
 drivers/input/misc/pmic8xxx-pwrkey.c               |   6 +-
 drivers/input/misc/pwm-beeper.c                    |   6 +-
 drivers/input/misc/rb532_button.c                  |   6 +-
 drivers/input/misc/retu-pwrbutton.c                |   6 +-
 drivers/input/misc/rotary_encoder.c                |   9 +-
 drivers/input/misc/sgi_btns.c                      |   6 +-
 drivers/input/misc/sparcspkr.c                     |  14 +--
 drivers/input/misc/twl4030-vibra.c                 |   6 +-
 drivers/input/misc/twl6040-vibra.c                 |   6 +-
 drivers/input/misc/wistron_btns.c                  |  20 +--
 drivers/input/misc/wm831x-on.c                     |   6 +-
 drivers/input/misc/xen-kbdfront.c                  |   2 +-
 drivers/input/mouse/gpio_mouse.c                   |   6 +-
 drivers/input/mouse/maplemouse.c                   |   6 +-
 drivers/input/mouse/navpoint.c                     |   6 +-
 drivers/input/mouse/pxa930_trkball.c               |   6 +-
 drivers/input/mouse/synaptics_i2c.c                |   6 +-
 drivers/input/serio/altera_ps2.c                   |   6 +-
 drivers/input/serio/ambakmi.c                      |   6 +-
 drivers/input/serio/arc_ps2.c                      |  12 +-
 drivers/input/serio/ct82c710.c                     |   6 +-
 drivers/input/serio/gscps2.c                       |   6 +-
 drivers/input/serio/i8042-sparcio.h                |   6 +-
 drivers/input/serio/i8042.c                        |   6 +-
 drivers/input/serio/maceps2.c                      |   8 +-
 drivers/input/serio/pcips2.c                       |   6 +-
 drivers/input/serio/q40kbd.c                       |   6 +-
 drivers/input/serio/rpckbd.c                       |   6 +-
 drivers/input/serio/sa1111ps2.c                    |  12 +-
 drivers/input/serio/serio.c                        |  11 --
 drivers/input/serio/xilinx_ps2.c                   |   8 +-
 drivers/input/touchscreen/88pm860x-ts.c            |   8 +-
 drivers/input/touchscreen/ad7877.c                 |   6 +-
 drivers/input/touchscreen/ad7879-i2c.c             |   6 +-
 drivers/input/touchscreen/ad7879-spi.c             |   6 +-
 drivers/input/touchscreen/ads7846.c                |  10 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           |   6 +-
 drivers/input/touchscreen/atmel_tsadcc.c           |   6 +-
 drivers/input/touchscreen/auo-pixcir-ts.c          |   8 +-
 drivers/input/touchscreen/bu21013_ts.c             |   6 +-
 drivers/input/touchscreen/cy8ctmg110_ts.c          |   6 +-
 drivers/input/touchscreen/cyttsp_i2c.c             |   6 +-
 drivers/input/touchscreen/cyttsp_spi.c             |   6 +-
 drivers/input/touchscreen/da9034-ts.c              |   6 +-
 drivers/input/touchscreen/da9052_tsi.c             |  10 +-
 drivers/input/touchscreen/edt-ft5x06.c             |  18 +--
 drivers/input/touchscreen/eeti_ts.c                |   6 +-
 drivers/input/touchscreen/egalax_ts.c              |   8 +-
 drivers/input/touchscreen/htcpen.c                 |   6 +-
 drivers/input/touchscreen/ili210x.c                |   6 +-
 drivers/input/touchscreen/intel-mid-touch.c        |  14 +--
 drivers/input/touchscreen/jornada720_ts.c          |   6 +-
 drivers/input/touchscreen/lpc32xx_ts.c             |   6 +-
 drivers/input/touchscreen/max11801_ts.c            |   8 +-
 drivers/input/touchscreen/mc13783_ts.c             |   4 +-
 drivers/input/touchscreen/mcs5000_ts.c             |   6 +-
 drivers/input/touchscreen/mms114.c                 |  10 +-
 drivers/input/touchscreen/pcap_ts.c                |   6 +-
 drivers/input/touchscreen/pixcir_i2c_ts.c          |   6 +-
 drivers/input/touchscreen/s3c2410_ts.c             |   6 +-
 drivers/input/touchscreen/st1232.c                 |   8 +-
 drivers/input/touchscreen/stmpe-ts.c               |   8 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          |   6 +-
 drivers/input/touchscreen/tnetv107x-ts.c           |   6 +-
 drivers/input/touchscreen/tps6507x-ts.c            |   4 +-
 drivers/input/touchscreen/tsc2005.c                |   8 +-
 drivers/input/touchscreen/tsc2007.c                |   6 +-
 drivers/input/touchscreen/ucb1400_ts.c             |   8 +-
 drivers/input/touchscreen/w90p910_ts.c             |   6 +-
 drivers/input/touchscreen/wacom_i2c.c              |   6 +-
 drivers/input/touchscreen/wm831x-ts.c              |   6 +-
 drivers/iommu/intel-iommu.c                        |   4 +-
 drivers/iommu/omap-iommu.c                         |   6 +-
 drivers/iommu/tegra-gart.c                         |   4 +-
 drivers/iommu/tegra-smmu.c                         |   4 +-
 drivers/isdn/hardware/avm/b1pci.c                  |   6 +-
 drivers/isdn/hardware/avm/c4.c                     |   2 +-
 drivers/isdn/hardware/avm/t1pci.c                  |   2 +-
 drivers/isdn/hardware/eicon/divasmain.c            |   8 +-
 drivers/isdn/hardware/mISDN/avmfritz.c             |  10 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |   6 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |   6 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |  17 ++-
 drivers/isdn/hardware/mISDN/netjet.c               |  10 +-
 drivers/isdn/hardware/mISDN/speedfax.c             |  14 +--
 drivers/isdn/hardware/mISDN/w6692.c                |   6 +-
 drivers/isdn/hisax/amd7930_fn.c                    |   2 +-
 drivers/isdn/hisax/asuscom.c                       |   8 +-
 drivers/isdn/hisax/avm_a1.c                        |   2 +-
 drivers/isdn/hisax/avm_a1p.c                       |   2 +-
 drivers/isdn/hisax/avm_pci.c                       |  16 +--
 drivers/isdn/hisax/avma1_cs.c                      |  12 +-
 drivers/isdn/hisax/bkm_a4t.c                       |   8 +-
 drivers/isdn/hisax/bkm_a8.c                        |  16 +--
 drivers/isdn/hisax/config.c                        |  19 ++-
 drivers/isdn/hisax/diva.c                          |  30 ++---
 drivers/isdn/hisax/elsa.c                          |  24 ++--
 drivers/isdn/hisax/elsa_cs.c                       |  12 +-
 drivers/isdn/hisax/enternow_pci.c                  |  10 +-
 drivers/isdn/hisax/gazel.c                         |   8 +-
 drivers/isdn/hisax/hfc4s8s_l1.c                    |  16 +--
 drivers/isdn/hisax/hfc_pci.c                       |   4 +-
 drivers/isdn/hisax/hfc_sx.c                        |   8 +-
 drivers/isdn/hisax/hfcscard.c                      |   8 +-
 drivers/isdn/hisax/hisax_fcpcipnp.c                |  21 ++--
 drivers/isdn/hisax/icc.c                           |   2 +-
 drivers/isdn/hisax/isac.c                          |   6 +-
 drivers/isdn/hisax/isurf.c                         |   4 +-
 drivers/isdn/hisax/ix1_micro.c                     |   8 +-
 drivers/isdn/hisax/mic.c                           |   2 +-
 drivers/isdn/hisax/niccy.c                         |   6 +-
 drivers/isdn/hisax/nj_s.c                          |  10 +-
 drivers/isdn/hisax/nj_u.c                          |  10 +-
 drivers/isdn/hisax/s0box.c                         |   2 +-
 drivers/isdn/hisax/saphir.c                        |   2 +-
 drivers/isdn/hisax/sedlbauer.c                     |  18 +--
 drivers/isdn/hisax/sedlbauer_cs.c                  |  12 +-
 drivers/isdn/hisax/sportster.c                     |   4 +-
 drivers/isdn/hisax/teleint.c                       |   2 +-
 drivers/isdn/hisax/teles0.c                        |   2 +-
 drivers/isdn/hisax/teles3.c                        |   8 +-
 drivers/isdn/hisax/teles_cs.c                      |  12 +-
 drivers/isdn/hisax/telespci.c                      |   4 +-
 drivers/isdn/hisax/w6692.c                         |   4 +-
 drivers/isdn/hysdn/hysdn_init.c                    |   6 +-
 drivers/isdn/mISDN/core.c                          |   4 -
 drivers/leds/leds-adp5520.c                        |   8 +-
 drivers/leds/leds-asic3.c                          |   6 +-
 drivers/leds/leds-atmel-pwm.c                      |   2 +-
 drivers/leds/leds-bd2802.c                         |   2 +-
 drivers/leds/leds-blinkm.c                         |   6 +-
 drivers/leds/leds-clevo-mail.c                     |   2 +-
 drivers/leds/leds-cobalt-qube.c                    |   6 +-
 drivers/leds/leds-cobalt-raq.c                     |   6 +-
 drivers/leds/leds-da903x.c                         |   6 +-
 drivers/leds/leds-da9052.c                         |   6 +-
 drivers/leds/leds-gpio.c                           |  12 +-
 drivers/leds/leds-lm3530.c                         |   6 +-
 drivers/leds/leds-lm3533.c                         |   8 +-
 drivers/leds/leds-lm355x.c                         |   8 +-
 drivers/leds/leds-lm3642.c                         |   8 +-
 drivers/leds/leds-lp3944.c                         |   6 +-
 drivers/leds/leds-lp5521.c                         |   8 +-
 drivers/leds/leds-lp5523.c                         |   4 +-
 drivers/leds/leds-lp8788.c                         |   6 +-
 drivers/leds/leds-lt3593.c                         |   8 +-
 drivers/leds/leds-max8997.c                        |   6 +-
 drivers/leds/leds-mc13783.c                        |  10 +-
 drivers/leds/leds-netxbig.c                        |  10 +-
 drivers/leds/leds-ns2.c                            |   8 +-
 drivers/leds/leds-ot200.c                          |   6 +-
 drivers/leds/leds-pca955x.c                        |   6 +-
 drivers/leds/leds-pca9633.c                        |   6 +-
 drivers/leds/leds-pwm.c                            |   4 +-
 drivers/leds/leds-rb532.c                          |   6 +-
 drivers/leds/leds-regulator.c                      |   6 +-
 drivers/leds/leds-renesas-tpu.c                    |   6 +-
 drivers/leds/leds-ss4200.c                         |   4 +-
 drivers/leds/leds-sunfire.c                        |  12 +-
 drivers/leds/leds-tca6507.c                        |   6 +-
 drivers/macintosh/macio_asic.c                     |   6 +-
 drivers/macintosh/mediabay.c                       |   2 +-
 drivers/macintosh/rack-meter.c                     |  10 +-
 drivers/macintosh/windfarm_ad7417_sensor.c         |  12 +-
 drivers/macintosh/windfarm_fcu_controls.c          |  16 +--
 drivers/macintosh/windfarm_pm112.c                 |   4 +-
 drivers/macintosh/windfarm_pm121.c                 |   4 +-
 drivers/macintosh/windfarm_pm72.c                  |   2 +-
 drivers/macintosh/windfarm_pm81.c                  |   4 +-
 drivers/macintosh/windfarm_pm91.c                  |   4 +-
 drivers/macintosh/windfarm_rm31.c                  |   2 +-
 drivers/media/i2c/adv7180.c                        |   6 +-
 drivers/media/i2c/adv7183.c                        |   2 +-
 drivers/media/i2c/as3645a.c                        |   8 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   6 +-
 drivers/media/i2c/vs6624.c                         |   6 +-
 drivers/media/mmc/siano/smssdio.c                  |   4 +-
 drivers/media/pci/bt8xx/bt878.c                    |  16 +--
 drivers/media/pci/bt8xx/bttv-cards.c               |  30 ++---
 drivers/media/pci/bt8xx/bttv-driver.c              |   8 +-
 drivers/media/pci/bt8xx/bttv-i2c.c                 |   6 +-
 drivers/media/pci/bt8xx/bttv-input.c               |   4 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                |   6 +-
 drivers/media/pci/cx18/cx18-driver.c               |  12 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   6 +-
 drivers/media/pci/cx25821/cx25821-core.c           |   6 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |  12 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |   6 +-
 drivers/media/pci/cx88/cx88-video.c                |   6 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   8 +-
 drivers/media/pci/dm1105/dm1105.c                  |  20 +--
 drivers/media/pci/ivtv/ivtv-driver.c               |   8 +-
 drivers/media/pci/mantis/hopper_cards.c            |   8 +-
 drivers/media/pci/mantis/mantis_cards.c            |   8 +-
 drivers/media/pci/mantis/mantis_dvb.c              |   4 +-
 drivers/media/pci/mantis/mantis_i2c.c              |   2 +-
 drivers/media/pci/mantis/mantis_pci.c              |   2 +-
 drivers/media/pci/meye/meye.c                      |   6 +-
 drivers/media/pci/ngene/ngene-cards.c              |   4 +-
 drivers/media/pci/ngene/ngene-core.c               |   4 +-
 drivers/media/pci/ngene/ngene.h                    |   4 +-
 drivers/media/pci/pluto2/pluto2.c                  |  24 ++--
 drivers/media/pci/pt1/pt1.c                        |   6 +-
 drivers/media/pci/saa7134/saa7134-core.c           |   8 +-
 drivers/media/pci/saa7134/saa7134.h                |   2 +-
 drivers/media/pci/saa7164/saa7164-core.c           |   6 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   6 +-
 drivers/media/pci/ttpci/av7110.c                   |   6 +-
 drivers/media/pci/ttpci/av7110_ir.c                |   4 +-
 drivers/media/pci/zoran/zoran_card.c               |  15 ++-
 drivers/media/pci/zoran/zoran_driver.c             |   2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   6 +-
 drivers/media/platform/coda.c                      |   4 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |   4 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |   4 +-
 drivers/media/platform/davinci/isif.c              |   4 +-
 drivers/media/platform/davinci/vpbe.c              |   2 +-
 drivers/media/platform/davinci/vpbe_display.c      |   8 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   6 +-
 drivers/media/platform/davinci/vpif.c              |   6 +-
 drivers/media/platform/davinci/vpss.c              |   6 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   4 +-
 drivers/media/platform/fsl-viu.c                   |   6 +-
 drivers/media/platform/omap24xxcam.c               |   2 +-
 drivers/media/platform/omap3isp/isp.c              |   6 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |   4 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   6 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |   4 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |   6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   4 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   6 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |   6 +-
 drivers/media/platform/s5p-tv/mixer.h              |   2 +-
 drivers/media/platform/s5p-tv/mixer_drv.c          |  12 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   6 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |   6 +-
 drivers/media/platform/sh_vou.c                    |   6 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   6 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |   8 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |   6 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |   6 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   6 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |   6 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   6 +-
 drivers/media/platform/timblogiw.c                 |  12 +-
 drivers/media/platform/via-camera.c                |   6 +-
 drivers/media/radio/radio-maxiradio.c              |   6 +-
 drivers/media/radio/radio-sf16fmi.c                |   2 +-
 drivers/media/radio/radio-sf16fmr2.c               |  18 +--
 drivers/media/radio/radio-tea5764.c                |   6 +-
 drivers/media/radio/radio-timb.c                   |   6 +-
 drivers/media/radio/radio-wl1273.c                 |   4 +-
 drivers/media/radio/saa7706h.c                     |   6 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   6 +-
 drivers/media/radio/tef6862.c                      |   6 +-
 drivers/media/rc/ene_ir.c                          |   2 +-
 drivers/media/rc/fintek-cir.c                      |   4 +-
 drivers/media/rc/gpio-ir-recv.c                    |   6 +-
 drivers/media/rc/iguanair.c                        |   6 +-
 drivers/media/rc/imon.c                            |   6 +-
 drivers/media/rc/ir-rx51.c                         |   2 +-
 drivers/media/rc/ite-cir.c                         |   4 +-
 drivers/media/rc/mceusb.c                          |   6 +-
 drivers/media/rc/nuvoton-cir.c                     |   4 +-
 drivers/media/rc/redrat3.c                         |   6 +-
 drivers/media/rc/streamzap.c                       |   2 +-
 drivers/media/rc/ttusbir.c                         |   6 +-
 drivers/media/rc/winbond-cir.c                     |   6 +-
 drivers/media/usb/gspca/spca506.c                  |   2 +-
 drivers/media/usb/siano/smsusb.c                   |   2 +-
 drivers/media/usb/usbvision/usbvision-video.c      |   8 +-
 drivers/memory/tegra20-mc.c                        |   4 +-
 drivers/memory/tegra30-mc.c                        |   4 +-
 drivers/message/fusion/mptfc.c                     |   6 +-
 drivers/message/fusion/mptsas.c                    |   4 +-
 drivers/message/fusion/mptspi.c                    |   2 +-
 drivers/message/i2o/pci.c                          |  10 +-
 drivers/mfd/88pm800.c                              |  12 +-
 drivers/mfd/88pm805.c                              |  10 +-
 drivers/mfd/88pm80x.c                              |   2 +-
 drivers/mfd/88pm860x-core.c                        | 104 ++++++++--------
 drivers/mfd/ab3100-core.c                          |  13 +-
 drivers/mfd/ab8500-core.c                          |  40 +++---
 drivers/mfd/ab8500-debugfs.c                       |   6 +-
 drivers/mfd/ab8500-gpadc.c                         |   6 +-
 drivers/mfd/ab8500-sysctrl.c                       |   6 +-
 drivers/mfd/adp5520.c                              |   6 +-
 drivers/mfd/arizona-core.c                         |   4 +-
 drivers/mfd/arizona-i2c.c                          |   6 +-
 drivers/mfd/arizona-spi.c                          |   6 +-
 drivers/mfd/asic3.c                                |   4 +-
 drivers/mfd/cs5535-mfd.c                           |  12 +-
 drivers/mfd/da903x.c                               |  10 +-
 drivers/mfd/da9052-core.c                          |   4 +-
 drivers/mfd/da9052-i2c.c                           |   6 +-
 drivers/mfd/da9052-spi.c                           |   6 +-
 drivers/mfd/da9055-core.c                          |   4 +-
 drivers/mfd/da9055-i2c.c                           |   6 +-
 drivers/mfd/davinci_voicecodec.c                   |   4 +-
 drivers/mfd/db8500-prcmu.c                         |   2 +-
 drivers/mfd/ezx-pcap.c                             |   8 +-
 drivers/mfd/htc-i2cpld.c                           |  12 +-
 drivers/mfd/intel_msic.c                           |  10 +-
 drivers/mfd/janz-cmodio.c                          |  10 +-
 drivers/mfd/jz4740-adc.c                           |   6 +-
 drivers/mfd/lm3533-core.c                          |  18 +--
 drivers/mfd/lp8788.c                               |   4 +-
 drivers/mfd/lpc_ich.c                              |  20 +--
 drivers/mfd/lpc_sch.c                              |   6 +-
 drivers/mfd/max77686.c                             |   2 +-
 drivers/mfd/max8907.c                              |   4 +-
 drivers/mfd/max8925-core.c                         |  58 ++++-----
 drivers/mfd/max8925-i2c.c                          |   6 +-
 drivers/mfd/mc13xxx-i2c.c                          |   4 +-
 drivers/mfd/mc13xxx-spi.c                          |   4 +-
 drivers/mfd/omap-usb-host.c                        |   4 +-
 drivers/mfd/omap-usb-tll.c                         |   6 +-
 drivers/mfd/palmas.c                               |   6 +-
 drivers/mfd/pcf50633-adc.c                         |   6 +-
 drivers/mfd/pcf50633-core.c                        |   6 +-
 drivers/mfd/pm8921-core.c                          |   8 +-
 drivers/mfd/pm8xxx-irq.c                           |   4 +-
 drivers/mfd/rc5t583.c                              |   6 +-
 drivers/mfd/rdc321x-southbridge.c                  |   6 +-
 drivers/mfd/rtsx_pcr.c                             |   6 +-
 drivers/mfd/sm501.c                                |  16 +--
 drivers/mfd/sta2x11-mfd.c                          |  20 +--
 drivers/mfd/stmpe-i2c.c                            |   6 +-
 drivers/mfd/stmpe-spi.c                            |   6 +-
 drivers/mfd/stmpe.c                                |  12 +-
 drivers/mfd/syscon.c                               |   6 +-
 drivers/mfd/tc3589x.c                              |   8 +-
 drivers/mfd/tc6387xb.c                             |   6 +-
 drivers/mfd/tc6393xb.c                             |  12 +-
 drivers/mfd/ti-ssp.c                               |   6 +-
 drivers/mfd/ti_am335x_tscadc.c                     |   6 +-
 drivers/mfd/timberdale.c                           |  64 +++++-----
 drivers/mfd/tps6105x.c                             |   8 +-
 drivers/mfd/tps65090.c                             |   8 +-
 drivers/mfd/tps65217.c                             |   6 +-
 drivers/mfd/tps6586x.c                             |  10 +-
 drivers/mfd/tps65910.c                             |  10 +-
 drivers/mfd/tps65911-comparator.c                  |   6 +-
 drivers/mfd/tps65912-spi.c                         |   6 +-
 drivers/mfd/twl-core.c                             |   2 +-
 drivers/mfd/twl4030-audio.c                        |   6 +-
 drivers/mfd/twl4030-madc.c                         |   4 +-
 drivers/mfd/twl4030-power.c                        |  20 +--
 drivers/mfd/twl6040.c                              |   8 +-
 drivers/mfd/vexpress-sysreg.c                      |   2 +-
 drivers/mfd/vx855.c                                |   6 +-
 drivers/mfd/wl1273-core.c                          |   4 +-
 drivers/mfd/wm831x-spi.c                           |   6 +-
 drivers/mfd/wm8994-core.c                          |  16 +--
 drivers/misc/ad525x_dpot-i2c.c                     |   6 +-
 drivers/misc/ad525x_dpot-spi.c                     |   6 +-
 drivers/misc/ad525x_dpot.c                         |   4 +-
 drivers/misc/apds9802als.c                         |   4 +-
 drivers/misc/apds990x.c                            |   6 +-
 drivers/misc/atmel-ssc.c                           |   4 +-
 drivers/misc/bh1770glc.c                           |   6 +-
 drivers/misc/bh1780gli.c                           |   6 +-
 drivers/misc/bmp085-i2c.c                          |   4 +-
 drivers/misc/bmp085-spi.c                          |   4 +-
 drivers/misc/bmp085.c                              |   2 +-
 drivers/misc/cb710/core.c                          |  10 +-
 drivers/misc/cs5535-mfgpt.c                        |   6 +-
 drivers/misc/eeprom/at24.c                         |   4 +-
 drivers/misc/eeprom/at25.c                         |   4 +-
 drivers/misc/eeprom/eeprom_93xx46.c                |   6 +-
 drivers/misc/fsa9480.c                             |   6 +-
 drivers/misc/hpilo.c                               |   6 +-
 drivers/misc/ibmasm/module.c                       |   6 +-
 drivers/misc/ioc4.c                                |  10 +-
 drivers/misc/isl29003.c                            |   6 +-
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c             |   6 +-
 drivers/misc/lis3lv02d/lis3lv02d_spi.c             |   6 +-
 drivers/misc/mei/main.c                            |  10 +-
 drivers/misc/pch_phub.c                            |   6 +-
 drivers/misc/phantom.c                             |  10 +-
 drivers/misc/pti.c                                 |   8 +-
 drivers/misc/spear13xx_pcie_gadget.c               |   4 +-
 drivers/misc/ti_dac7512.c                          |   6 +-
 drivers/misc/tsl2550.c                             |   6 +-
 drivers/mmc/host/atmel-mci.c                       |   2 +-
 drivers/mmc/host/au1xmmc.c                         |   4 +-
 drivers/mmc/host/bfin_sdh.c                        |   6 +-
 drivers/mmc/host/cb710-mmc.c                       |   6 +-
 drivers/mmc/host/dw_mmc-pci.c                      |   6 +-
 drivers/mmc/host/dw_mmc-pltfm.c                    |   6 +-
 drivers/mmc/host/dw_mmc-pltfm.h                    |   2 +-
 drivers/mmc/host/jz4740_mmc.c                      |  12 +-
 drivers/mmc/host/mmc_spi.c                         |   6 +-
 drivers/mmc/host/mmci.c                            |  10 +-
 drivers/mmc/host/omap.c                            |   8 +-
 drivers/mmc/host/omap_hsmmc.c                      |   6 +-
 drivers/mmc/host/pxamci.c                          |   4 +-
 drivers/mmc/host/s3cmci.c                          |   6 +-
 drivers/mmc/host/sdhci-cns3xxx.c                   |   6 +-
 drivers/mmc/host/sdhci-dove.c                      |   8 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   8 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   6 +-
 drivers/mmc/host/sdhci-of-hlwd.c                   |   6 +-
 drivers/mmc/host/sdhci-pci.c                       |  14 +--
 drivers/mmc/host/sdhci-pxav2.c                     |   6 +-
 drivers/mmc/host/sdhci-pxav3.c                     |   6 +-
 drivers/mmc/host/sdhci-s3c.c                       |  10 +-
 drivers/mmc/host/sdhci-spear.c                     |  12 +-
 drivers/mmc/host/sdhci-tegra.c                     |  10 +-
 drivers/mmc/host/sh_mmcif.c                        |   4 +-
 drivers/mmc/host/sh_mobile_sdhi.c                  |   4 +-
 drivers/mmc/host/tmio_mmc.c                        |   6 +-
 drivers/mmc/host/tmio_mmc_pio.c                    |   2 +-
 drivers/mmc/host/via-sdmmc.c                       |   6 +-
 drivers/mmc/host/wbsd.c                            |  28 ++---
 drivers/mtd/devices/bcm47xxsflash.c                |   4 +-
 drivers/mtd/devices/block2mtd.c                    |   2 +-
 drivers/mtd/devices/m25p80.c                       |   8 +-
 drivers/mtd/devices/mtd_dataflash.c                |  14 +--
 drivers/mtd/devices/spear_smi.c                    |  10 +-
 drivers/mtd/devices/sst25l.c                       |  10 +-
 drivers/mtd/maps/amd76xrom.c                       |   4 +-
 drivers/mtd/maps/autcpu12-nvram.c                  |   6 +-
 drivers/mtd/maps/bfin-async-flash.c                |   8 +-
 drivers/mtd/maps/ck804xrom.c                       |   4 +-
 drivers/mtd/maps/esb2rom.c                         |   6 +-
 drivers/mtd/maps/gpio-addr-flash.c                 |   8 +-
 drivers/mtd/maps/ichxrom.c                         |   6 +-
 drivers/mtd/maps/intel_vr_nor.c                    |  18 +--
 drivers/mtd/maps/lantiq-flash.c                    |   8 +-
 drivers/mtd/maps/latch-addr-flash.c                |   4 +-
 drivers/mtd/maps/pci.c                             |   6 +-
 drivers/mtd/maps/physmap_of.c                      |   8 +-
 drivers/mtd/maps/pismo.c                           |  18 +--
 drivers/mtd/maps/pxa2xx-flash.c                    |   6 +-
 drivers/mtd/maps/sa1100-flash.c                    |   5 +-
 drivers/mtd/maps/scb2_flash.c                      |   8 +-
 drivers/mtd/maps/sun_uflash.c                      |   6 +-
 drivers/mtd/maps/vmu-flash.c                       |  10 +-
 drivers/mtd/nand/ams-delta.c                       |   6 +-
 drivers/mtd/nand/atmel_nand.c                      |  12 +-
 drivers/mtd/nand/au1550nd.c                        |   8 +-
 drivers/mtd/nand/bf5xx_nand.c                      |   8 +-
 drivers/mtd/nand/cafe_nand.c                       |  12 +-
 drivers/mtd/nand/denali_dt.c                       |   6 +-
 drivers/mtd/nand/denali_pci.c                      |   4 +-
 drivers/mtd/nand/fsl_elbc_nand.c                   |   2 +-
 drivers/mtd/nand/fsl_ifc_nand.c                    |   2 +-
 drivers/mtd/nand/fsl_upm.c                         |   8 +-
 drivers/mtd/nand/fsmc_nand.c                       |   4 +-
 drivers/mtd/nand/gpio.c                            |   4 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |  20 +--
 drivers/mtd/nand/jz4740_nand.c                     |   8 +-
 drivers/mtd/nand/lpc32xx_mlc.c                     |   6 +-
 drivers/mtd/nand/lpc32xx_slc.c                     |   6 +-
 drivers/mtd/nand/mpc5121_nfc.c                     |   8 +-
 drivers/mtd/nand/mxc_nand.c                        |   6 +-
 drivers/mtd/nand/ndfc.c                            |   6 +-
 drivers/mtd/nand/nuc900_nand.c                     |   6 +-
 drivers/mtd/nand/omap2.c                           |   2 +-
 drivers/mtd/nand/orion_nand.c                      |   4 +-
 drivers/mtd/nand/pasemi_nand.c                     |   4 +-
 drivers/mtd/nand/plat_nand.c                       |   6 +-
 drivers/mtd/nand/sh_flctl.c                        |   4 +-
 drivers/mtd/nand/sharpsl.c                         |   6 +-
 drivers/mtd/nand/socrates_nand.c                   |   6 +-
 drivers/mtd/onenand/generic.c                      |   6 +-
 drivers/mtd/onenand/omap2.c                        |   6 +-
 drivers/mtd/onenand/samsung.c                      |   4 +-
 drivers/net/arcnet/com20020-pci.c                  |   6 +-
 drivers/net/can/at91_can.c                         |   8 +-
 drivers/net/can/bfin_can.c                         |   6 +-
 drivers/net/can/c_can/c_can_pci.c                  |   6 +-
 drivers/net/can/c_can/c_can_platform.c             |   6 +-
 drivers/net/can/cc770/cc770_isa.c                  |  18 +--
 drivers/net/can/cc770/cc770_platform.c             |  12 +-
 drivers/net/can/flexcan.c                          |  10 +-
 drivers/net/can/janz-ican3.c                       |  24 ++--
 drivers/net/can/mcp251x.c                          |   6 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |  24 ++--
 drivers/net/can/pch_can.c                          |   6 +-
 drivers/net/can/sja1000/ems_pci.c                  |   2 +-
 drivers/net/can/sja1000/ems_pcmcia.c               |   4 +-
 drivers/net/can/sja1000/kvaser_pci.c               |   6 +-
 drivers/net/can/sja1000/peak_pci.c                 |   6 +-
 drivers/net/can/sja1000/peak_pcmcia.c              |   2 +-
 drivers/net/can/sja1000/plx_pci.c                  |  18 +--
 drivers/net/can/sja1000/sja1000_isa.c              |  16 +--
 drivers/net/can/sja1000/sja1000_of_platform.c      |   8 +-
 drivers/net/can/sja1000/tscan1.c                   |   8 +-
 drivers/net/can/softing/softing_cs.c               |  10 +-
 drivers/net/can/softing/softing_main.c             |  12 +-
 drivers/net/can/ti_hecc.c                          |   4 +-
 drivers/net/ethernet/3com/3c509.c                  |  24 ++--
 drivers/net/ethernet/3com/3c59x.c                  |  16 +--
 drivers/net/ethernet/3com/typhoon.c                |  10 +-
 drivers/net/ethernet/8390/etherh.c                 |   8 +-
 drivers/net/ethernet/8390/hydra.c                  |  22 ++--
 drivers/net/ethernet/8390/ne2k-pci.c               |  10 +-
 drivers/net/ethernet/8390/ne3210.c                 |   4 +-
 drivers/net/ethernet/8390/zorro8390.c              |  12 +-
 drivers/net/ethernet/adaptec/starfire.c            |  10 +-
 drivers/net/ethernet/adi/bfin_mac.c                |  12 +-
 drivers/net/ethernet/aeroflex/greth.c              |   6 +-
 drivers/net/ethernet/alteon/acenic.c               |  26 ++--
 drivers/net/ethernet/amd/a2065.c                   |  12 +-
 drivers/net/ethernet/amd/am79c961a.c               |   2 +-
 drivers/net/ethernet/amd/amd8111e.c                |   8 +-
 drivers/net/ethernet/amd/ariadne.c                 |   8 +-
 drivers/net/ethernet/amd/au1000_eth.c              |   6 +-
 drivers/net/ethernet/amd/declance.c                |   8 +-
 drivers/net/ethernet/amd/depca.c                   |  10 +-
 drivers/net/ethernet/amd/hplance.c                 |  14 +--
 drivers/net/ethernet/amd/pcnet32.c                 |  10 +-
 drivers/net/ethernet/amd/sunlance.c                |   8 +-
 drivers/net/ethernet/apple/bmac.c                  |   4 +-
 drivers/net/ethernet/apple/mace.c                  |   4 +-
 drivers/net/ethernet/apple/macmace.c               |   6 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  14 +--
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  10 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_param.c   |   6 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |  14 +--
 drivers/net/ethernet/atheros/atlx/atl2.c           |  16 +--
 drivers/net/ethernet/broadcom/b44.c                |   8 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |  12 +-
 drivers/net/ethernet/broadcom/bnx2.c               |  21 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  64 +++++-----
 drivers/net/ethernet/broadcom/cnic.c               |   2 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c         |   2 +-
 drivers/net/ethernet/broadcom/tg3.c                |  94 +++++++--------
 drivers/net/ethernet/brocade/bna/bnad.c            |   6 +-
 drivers/net/ethernet/cadence/at91_ether.c          |   4 +-
 drivers/net/ethernet/cadence/macb.c                |   8 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |   6 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c            |   2 +-
 drivers/net/ethernet/chelsio/cxgb/subr.c           |   8 +-
 drivers/net/ethernet/chelsio/cxgb/tp.c             |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |  12 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  22 ++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |  12 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  20 +--
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h |   4 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c     |   6 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   6 +-
 drivers/net/ethernet/davicom/dm9000.c              |   6 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |  14 +--
 drivers/net/ethernet/dec/tulip/de4x5.c             |  16 +--
 drivers/net/ethernet/dec/tulip/dmfe.c              |  10 +-
 drivers/net/ethernet/dec/tulip/eeprom.c            |  10 +-
 drivers/net/ethernet/dec/tulip/media.c             |   2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |  10 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |  10 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |   8 +-
 drivers/net/ethernet/dec/tulip/xircom_cb.c         |   6 +-
 drivers/net/ethernet/dlink/dl2k.c                  |   8 +-
 drivers/net/ethernet/dlink/sundance.c              |  12 +-
 drivers/net/ethernet/dnet.c                        |   8 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   4 +-
 drivers/net/ethernet/ethoc.c                       |   8 +-
 drivers/net/ethernet/fealnx.c                      |  10 +-
 drivers/net/ethernet/freescale/fec.c               |  10 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |   2 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |   2 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |   4 +-
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |   2 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |   4 +-
 drivers/net/ethernet/hp/hp100.c                    |  14 +--
 drivers/net/ethernet/i825xx/ether1.c               |  14 +--
 drivers/net/ethernet/i825xx/lasi_82596.c           |   8 +-
 drivers/net/ethernet/i825xx/lib82596.c             |   2 +-
 drivers/net/ethernet/i825xx/sni_82596.c            |   8 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |  10 +-
 drivers/net/ethernet/ibm/emac/core.c               |  18 +--
 drivers/net/ethernet/ibm/emac/mal.c                |   6 +-
 drivers/net/ethernet/ibm/emac/rgmii.c              |   6 +-
 drivers/net/ethernet/ibm/emac/tah.c                |   6 +-
 drivers/net/ethernet/ibm/emac/zmii.c               |   6 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   6 +-
 drivers/net/ethernet/icplus/ipg.c                  |   6 +-
 drivers/net/ethernet/intel/e100.c                  |   6 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  12 +-
 drivers/net/ethernet/intel/e1000/e1000_param.c     |  10 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  10 +-
 drivers/net/ethernet/intel/e1000e/param.c          |   6 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  12 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |  10 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |  10 +-
 drivers/net/ethernet/intel/ixgb/ixgb_param.c       |   6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   8 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   8 +-
 drivers/net/ethernet/jme.c                         |   6 +-
 drivers/net/ethernet/lantiq_etop.c                 |   4 +-
 drivers/net/ethernet/marvell/skge.c                |   8 +-
 drivers/net/ethernet/marvell/sky2.c                |  16 +--
 drivers/net/ethernet/mellanox/mlx4/main.c          |   6 +-
 drivers/net/ethernet/micrel/ks8695net.c            |  10 +-
 drivers/net/ethernet/micrel/ks8842.c               |   6 +-
 drivers/net/ethernet/micrel/ks8851.c               |   6 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |   6 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   4 +-
 drivers/net/ethernet/microchip/enc28j60.c          |   6 +-
 drivers/net/ethernet/natsemi/ibmlana.c             |   4 +-
 drivers/net/ethernet/natsemi/jazzsonic.c           |   8 +-
 drivers/net/ethernet/natsemi/macsonic.c            |  18 +--
 drivers/net/ethernet/natsemi/natsemi.c             |  12 +-
 drivers/net/ethernet/natsemi/ns83820.c             |   6 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |   6 +-
 drivers/net/ethernet/neterion/s2io.c               |   6 +-
 drivers/net/ethernet/neterion/s2io.h               |   4 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c   |   6 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.h   |   6 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |  16 +--
 drivers/net/ethernet/nuvoton/w90p910_ether.c       |   6 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   6 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |   2 +-
 drivers/net/ethernet/octeon/octeon_mgmt.c          |   6 +-
 drivers/net/ethernet/packetengines/hamachi.c       |  10 +-
 drivers/net/ethernet/packetengines/yellowfin.c     |  10 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |   6 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  10 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |   6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |  10 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |   8 +-
 drivers/net/ethernet/rdc/r6040.c                   |   8 +-
 drivers/net/ethernet/realtek/8139too.c             |  12 +-
 drivers/net/ethernet/realtek/r8169.c               |  18 +--
 drivers/net/ethernet/s6gmac.c                      |   6 +-
 drivers/net/ethernet/seeq/ether3.c                 |  16 +--
 drivers/net/ethernet/seeq/sgiseeq.c                |   2 +-
 drivers/net/ethernet/sfc/efx.c                     |   2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                |  10 +-
 drivers/net/ethernet/sgi/meth.c                    |   2 +-
 drivers/net/ethernet/silan/sc92031.c               |   6 +-
 drivers/net/ethernet/sis/sis190.c                  |  20 +--
 drivers/net/ethernet/sis/sis900.c                  |  20 +--
 drivers/net/ethernet/smsc/epic100.c                |  12 +-
 drivers/net/ethernet/smsc/smc911x.c                |  10 +-
 drivers/net/ethernet/smsc/smc91x.c                 |  10 +-
 drivers/net/ethernet/smsc/smsc911x.c               |  14 +--
 drivers/net/ethernet/smsc/smsc9420.c               |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   6 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   6 +-
 drivers/net/ethernet/sun/cassini.c                 |  12 +-
 drivers/net/ethernet/sun/niu.c                     |  90 +++++++-------
 drivers/net/ethernet/sun/sunbmac.c                 |   8 +-
 drivers/net/ethernet/sun/sungem.c                  |   6 +-
 drivers/net/ethernet/sun/sunhme.c                  |  18 +--
 drivers/net/ethernet/sun/sunqe.c                   |  12 +-
 drivers/net/ethernet/sun/sunvnet.c                 |  14 +--
 drivers/net/ethernet/tehuti/tehuti.c               |   6 +-
 drivers/net/ethernet/ti/cpmac.c                    |  10 +-
 drivers/net/ethernet/ti/cpsw.c                     |   6 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   6 +-
 drivers/net/ethernet/ti/davinci_mdio.c             |   6 +-
 drivers/net/ethernet/ti/tlan.c                     |   8 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |  14 +--
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c  |   6 +-
 drivers/net/ethernet/toshiba/spider_net.c          |   6 +-
 drivers/net/ethernet/toshiba/tc35815.c             |  16 +--
 drivers/net/ethernet/via/via-rhine.c               |  12 +-
 drivers/net/ethernet/via/via-velocity.c            |  20 +--
 drivers/net/ethernet/wiznet/w5100.c                |   8 +-
 drivers/net/ethernet/wiznet/w5300.c                |   8 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   8 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   8 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |   4 +-
 drivers/net/fddi/defxx.c                           |  40 +++---
 drivers/net/fddi/skfp/skfddi.c                     |   4 +-
 drivers/net/hippi/rrunner.c                        |  10 +-
 drivers/net/ieee802154/at86rf230.c                 |   6 +-
 drivers/net/ieee802154/fakehard.c                  |   6 +-
 drivers/net/ieee802154/fakelb.c                    |   6 +-
 drivers/net/ieee802154/mrf24j40.c                  |   6 +-
 drivers/net/irda/au1k_ir.c                         |   8 +-
 drivers/net/irda/bfin_sir.c                        |   8 +-
 drivers/net/irda/sh_irda.c                         |   6 +-
 drivers/net/irda/sh_sir.c                          |   6 +-
 drivers/net/irda/smsc-ircc2.c                      |   4 +-
 drivers/net/irda/via-ircc.c                        |  12 +-
 drivers/net/irda/vlsi_ir.c                         |   6 +-
 drivers/net/phy/mdio-gpio.c                        |  10 +-
 drivers/net/phy/mdio-mux-gpio.c                    |   6 +-
 drivers/net/phy/mdio-mux-mmioreg.c                 |   6 +-
 drivers/net/phy/mdio-octeon.c                      |   6 +-
 drivers/net/phy/spi_ks8995.c                       |   6 +-
 drivers/net/virtio_net.c                           |   4 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   6 +-
 drivers/net/wan/dscc4.c                            |   6 +-
 drivers/net/wan/farsync.c                          |  10 +-
 drivers/net/wan/hd64570.c                          |   4 +-
 drivers/net/wan/hd64572.c                          |   4 +-
 drivers/net/wan/ixp4xx_hss.c                       |   4 +-
 drivers/net/wan/lmc/lmc_main.c                     |   6 +-
 drivers/net/wan/pc300too.c                         |   2 +-
 drivers/net/wan/pci200syn.c                        |   2 +-
 drivers/net/wan/wanxl.c                            |   2 +-
 drivers/net/wireless/adm8211.c                     |   6 +-
 drivers/net/wireless/airo.c                        |   6 +-
 drivers/net/wireless/ath/ath5k/base.c              |   4 +-
 drivers/net/wireless/ath/ath5k/led.c               |   2 +-
 drivers/net/wireless/ath/ath5k/pci.c               |   6 +-
 drivers/net/wireless/atmel_pci.c                   |   6 +-
 drivers/net/wireless/b43/pcmcia.c                  |   6 +-
 drivers/net/wireless/b43/sdio.c                    |   6 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   4 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |   4 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |   8 +-
 drivers/net/wireless/iwlegacy/3945-mac.c           |   4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   4 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |   4 +-
 drivers/net/wireless/libertas/if_spi.c             |   6 +-
 drivers/net/wireless/mwl8k.c                       |  12 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c      |   4 +-
 drivers/net/wireless/orinoco/orinoco_pci.c         |   4 +-
 drivers/net/wireless/orinoco/orinoco_plx.c         |   4 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c         |   4 +-
 drivers/net/wireless/p54/p54pci.c                  |   6 +-
 drivers/net/wireless/p54/p54spi.c                  |   6 +-
 drivers/net/wireless/p54/p54usb.c                  |   6 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |   2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |   2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c            |   4 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |   6 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |   6 +-
 drivers/net/wireless/rtlwifi/pci.c                 |   2 +-
 drivers/net/wireless/rtlwifi/pci.h                 |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c        |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c        |   2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c        |   2 +-
 drivers/net/wireless/rtlwifi/usb.c                 |   2 +-
 drivers/net/wireless/rtlwifi/usb.h                 |   2 +-
 drivers/net/wireless/ti/wl1251/sdio.c              |   4 +-
 drivers/net/wireless/ti/wl1251/spi.c               |   6 +-
 drivers/net/wireless/ti/wl12xx/main.c              |   6 +-
 drivers/net/wireless/ti/wl18xx/main.c              |   6 +-
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/net/wireless/ti/wlcore/sdio.c              |   8 +-
 drivers/net/wireless/ti/wlcore/spi.c               |   6 +-
 drivers/net/wireless/ti/wlcore/wlcore.h            |   4 +-
 drivers/net/xen-netfront.c                         |   8 +-
 drivers/nfc/pn544/i2c.c                            |   6 +-
 drivers/parisc/dino.c                              |   2 +-
 drivers/parisc/lba_pci.c                           |   2 +-
 drivers/parport/parport_gsc.c                      |  18 +--
 drivers/parport/parport_pc.c                       |  48 ++++----
 drivers/parport/parport_serial.c                   |  16 +--
 drivers/parport/parport_sunbpp.c                   |   6 +-
 drivers/pci/Makefile                               |   7 +-
 drivers/pci/hotplug.c                              |  37 ------
 drivers/pci/hotplug/cpcihp_zt5550.c                |   4 +-
 drivers/pci/ioapic.c                               |   6 +-
 drivers/pci/pci-driver.c                           |  42 +++++--
 drivers/pci/pci-sysfs.c                            |   7 --
 drivers/pci/pci.c                                  |   4 +-
 drivers/pci/pci.h                                  |   5 -
 drivers/pci/pcie/aer/aerdrv.c                      |   4 +-
 drivers/pci/pcie/portdrv_pci.c                     |   2 +-
 drivers/pci/probe.c                                |  20 ++-
 drivers/pci/quirks.c                               | 134 ++++++++++-----------
 drivers/pci/xen-pcifront.c                         |  10 +-
 drivers/pcmcia/bcm63xx_pcmcia.c                    |  12 +-
 drivers/pcmcia/bfin_cf_pcmcia.c                    |   6 +-
 drivers/pcmcia/db1xxx_ss.c                         |   6 +-
 drivers/pcmcia/ds.c                                |  13 +-
 drivers/pcmcia/electra_cf.c                        |   4 +-
 drivers/pcmcia/i82092.c                            |   6 +-
 drivers/pcmcia/pd6729.c                            |   8 +-
 drivers/pcmcia/pxa2xx_sharpsl.c                    |   2 +-
 drivers/pcmcia/rsrc_nonstatic.c                    |   6 +-
 drivers/pcmcia/sa1100_assabet.c                    |   2 +-
 drivers/pcmcia/sa1100_cerf.c                       |   2 +-
 drivers/pcmcia/sa1100_generic.c                    |   4 +-
 drivers/pcmcia/sa1100_h3600.c                      |   2 +-
 drivers/pcmcia/sa1100_shannon.c                    |   2 +-
 drivers/pcmcia/sa1100_simpad.c                     |   2 +-
 drivers/pcmcia/sa1111_generic.c                    |   4 +-
 drivers/pcmcia/sa1111_jornada720.c                 |   2 +-
 drivers/pcmcia/vrc4171_card.c                      |   8 +-
 drivers/pcmcia/vrc4173_cardu.c                     |   8 +-
 drivers/pcmcia/xxs1500_ss.c                        |   6 +-
 drivers/pcmcia/yenta_socket.c                      |   6 +-
 drivers/pinctrl/mvebu/pinctrl-armada-370.c         |   8 +-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c          |   8 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c               |   8 +-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c           |   8 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c              |   8 +-
 drivers/pinctrl/pinctrl-at91.c                     |  24 ++--
 drivers/pinctrl/pinctrl-bcm2835.c                  |  10 +-
 drivers/pinctrl/pinctrl-imx.c                      |  10 +-
 drivers/pinctrl/pinctrl-imx23.c                    |   6 +-
 drivers/pinctrl/pinctrl-imx28.c                    |   6 +-
 drivers/pinctrl/pinctrl-imx35.c                    |   6 +-
 drivers/pinctrl/pinctrl-imx51.c                    |   6 +-
 drivers/pinctrl/pinctrl-imx53.c                    |   6 +-
 drivers/pinctrl/pinctrl-imx6q.c                    |   6 +-
 drivers/pinctrl/pinctrl-mmp2.c                     |   6 +-
 drivers/pinctrl/pinctrl-mxs.c                      |   8 +-
 drivers/pinctrl/pinctrl-nomadik-db8500.c           |   2 +-
 drivers/pinctrl/pinctrl-nomadik-db8540.c           |   2 +-
 drivers/pinctrl/pinctrl-nomadik-stn8815.c          |   2 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |   4 +-
 drivers/pinctrl/pinctrl-pxa168.c                   |   6 +-
 drivers/pinctrl/pinctrl-pxa910.c                   |   6 +-
 drivers/pinctrl/pinctrl-samsung.c                  |  12 +-
 drivers/pinctrl/pinctrl-single.c                   |  12 +-
 drivers/pinctrl/pinctrl-sirf.c                     |   6 +-
 drivers/pinctrl/pinctrl-tegra.c                    |   4 +-
 drivers/pinctrl/pinctrl-tegra20.c                  |   6 +-
 drivers/pinctrl/pinctrl-tegra30.c                  |   6 +-
 drivers/pinctrl/pinctrl-u300.c                     |   6 +-
 drivers/pinctrl/pinctrl-xway.c                     |   2 +-
 drivers/pinctrl/spear/pinctrl-plgpio.c             |   4 +-
 drivers/pinctrl/spear/pinctrl-spear.c              |   8 +-
 drivers/pinctrl/spear/pinctrl-spear.h              |   8 +-
 drivers/pinctrl/spear/pinctrl-spear1310.c          |   8 +-
 drivers/pinctrl/spear/pinctrl-spear1340.c          |   8 +-
 drivers/pinctrl/spear/pinctrl-spear300.c           |   8 +-
 drivers/pinctrl/spear/pinctrl-spear310.c           |   8 +-
 drivers/pinctrl/spear/pinctrl-spear320.c           |   8 +-
 drivers/platform/x86/acer-wmi.c                    |   8 +-
 drivers/platform/x86/acerhdf.c                     |   2 +-
 drivers/platform/x86/amilo-rfkill.c                |   4 +-
 drivers/platform/x86/apple-gmux.c                  |   6 +-
 drivers/platform/x86/asus-laptop.c                 |   6 +-
 drivers/platform/x86/compal-laptop.c               |  10 +-
 drivers/platform/x86/dell-laptop.c                 |   4 +-
 drivers/platform/x86/eeepc-laptop.c                |   6 +-
 drivers/platform/x86/fujitsu-tablet.c              |  14 +--
 drivers/platform/x86/hp-wmi.c                      |   8 +-
 drivers/platform/x86/ideapad-laptop.c              |  12 +-
 drivers/platform/x86/intel_mid_powerbtn.c          |   6 +-
 drivers/platform/x86/intel_mid_thermal.c           |   2 +-
 drivers/platform/x86/intel_oaktrail.c              |   6 +-
 drivers/platform/x86/intel_pmic_gpio.c             |   2 +-
 drivers/platform/x86/samsung-q10.c                 |   6 +-
 drivers/platform/x86/tc1100-wmi.c                  |   4 +-
 drivers/platform/x86/thinkpad_acpi.c               |   4 +-
 drivers/platform/x86/toshiba_acpi.c                |  12 +-
 drivers/platform/x86/xo1-rfkill.c                  |   6 +-
 drivers/pnp/pnpbios/core.c                         |  20 ++-
 drivers/power/88pm860x_battery.c                   |   6 +-
 drivers/power/88pm860x_charger.c                   |   6 +-
 drivers/power/ab8500_btemp.c                       |   6 +-
 drivers/power/ab8500_charger.c                     |   6 +-
 drivers/power/ab8500_fg.c                          |   6 +-
 drivers/power/abx500_chargalg.c                    |   6 +-
 drivers/power/avs/smartreflex.c                    |   8 +-
 drivers/power/bq27x00_battery.c                    |   6 +-
 drivers/power/charger-manager.c                    |   4 +-
 drivers/power/collie_battery.c                     |   6 +-
 drivers/power/da9052-battery.c                     |   6 +-
 drivers/power/ds2780_battery.c                     |   6 +-
 drivers/power/ds2781_battery.c                     |   6 +-
 drivers/power/generic-adc-battery.c                |   6 +-
 drivers/power/gpio-charger.c                       |   6 +-
 drivers/power/intel_mid_battery.c                  |   8 +-
 drivers/power/isp1704_charger.c                    |   6 +-
 drivers/power/jz4740-battery.c                     |   6 +-
 drivers/power/lp8727_charger.c                     |   4 +-
 drivers/power/lp8788-charger.c                     |   6 +-
 drivers/power/max17040_battery.c                   |   6 +-
 drivers/power/max17042_battery.c                   |   6 +-
 drivers/power/max8903_charger.c                    |   6 +-
 drivers/power/max8925_power.c                      |  10 +-
 drivers/power/max8997_charger.c                    |   6 +-
 drivers/power/max8998_charger.c                    |   6 +-
 drivers/power/olpc_battery.c                       |   8 +-
 drivers/power/pcf50633-charger.c                   |   6 +-
 drivers/power/s3c_adc_battery.c                    |   2 +-
 drivers/power/sbs-battery.c                        |   6 +-
 drivers/power/smb347-charger.c                     |   2 +-
 drivers/power/tosa_battery.c                       |   6 +-
 drivers/power/wm831x_backup.c                      |   6 +-
 drivers/power/wm831x_power.c                       |   6 +-
 drivers/power/wm8350_power.c                       |   6 +-
 drivers/power/wm97xx_battery.c                     |   6 +-
 drivers/power/z2_battery.c                         |   6 +-
 drivers/pps/clients/pps-gpio.c                     |   2 +-
 drivers/ps3/ps3-lpm.c                              |   2 +-
 drivers/ps3/ps3-sys-manager.c                      |   2 +-
 drivers/ps3/ps3av.c                                |   2 +-
 drivers/ptp/ptp_pch.c                              |   4 +-
 drivers/pwm/pwm-ab8500.c                           |   6 +-
 drivers/pwm/pwm-bfin.c                             |   4 +-
 drivers/pwm/pwm-imx.c                              |   6 +-
 drivers/pwm/pwm-jz4740.c                           |   6 +-
 drivers/pwm/pwm-lpc32xx.c                          |   4 +-
 drivers/pwm/pwm-mxs.c                              |   4 +-
 drivers/pwm/pwm-puv3.c                             |   6 +-
 drivers/pwm/pwm-pxa.c                              |   6 +-
 drivers/pwm/pwm-samsung.c                          |   4 +-
 drivers/pwm/pwm-tegra.c                            |   4 +-
 drivers/pwm/pwm-tiecap.c                           |   6 +-
 drivers/pwm/pwm-tiehrpwm.c                         |   6 +-
 drivers/pwm/pwm-twl6030.c                          |   2 +-
 drivers/rapidio/devices/tsi721.c                   |   4 +-
 drivers/rapidio/devices/tsi721.h                   |   2 +-
 drivers/rapidio/devices/tsi721_dma.c               |   2 +-
 drivers/rapidio/rio-scan.c                         |  14 +--
 drivers/rapidio/rio.c                              |   6 +-
 drivers/regulator/88pm8607.c                       |   6 +-
 drivers/regulator/aat2870-regulator.c              |   4 +-
 drivers/regulator/ab3100.c                         |   6 +-
 drivers/regulator/ab8500.c                         |  12 +-
 drivers/regulator/ad5398.c                         |   6 +-
 drivers/regulator/anatop-regulator.c               |   8 +-
 drivers/regulator/arizona-ldo1.c                   |   6 +-
 drivers/regulator/arizona-micsupp.c                |   6 +-
 drivers/regulator/da903x.c                         |   6 +-
 drivers/regulator/da9052-regulator.c               |   6 +-
 drivers/regulator/db8500-prcmu.c                   |   6 +-
 drivers/regulator/dbx500-prcmu.c                   |   4 +-
 drivers/regulator/dummy.c                          |   2 +-
 drivers/regulator/fan53555.c                       |   6 +-
 drivers/regulator/fixed.c                          |   8 +-
 drivers/regulator/gpio-regulator.c                 |   8 +-
 drivers/regulator/isl6271a-regulator.c             |   6 +-
 drivers/regulator/lp3971.c                         |   8 +-
 drivers/regulator/lp3972.c                         |   8 +-
 drivers/regulator/lp872x.c                         |   4 +-
 drivers/regulator/lp8788-buck.c                    |   6 +-
 drivers/regulator/lp8788-ldo.c                     |  12 +-
 drivers/regulator/max1586.c                        |   6 +-
 drivers/regulator/max77686.c                       |   6 +-
 drivers/regulator/max8649.c                        |   6 +-
 drivers/regulator/max8660.c                        |   6 +-
 drivers/regulator/max8907-regulator.c              |   6 +-
 drivers/regulator/max8925-regulator.c              |   6 +-
 drivers/regulator/max8952.c                        |   6 +-
 drivers/regulator/max8997.c                        |   6 +-
 drivers/regulator/max8998.c                        |   6 +-
 drivers/regulator/mc13783-regulator.c              |   6 +-
 drivers/regulator/mc13892-regulator.c              |   6 +-
 drivers/regulator/mc13xxx-regulator-core.c         |   4 +-
 drivers/regulator/palmas-regulator.c               |  10 +-
 drivers/regulator/pcap-regulator.c                 |   6 +-
 drivers/regulator/pcf50633-regulator.c             |   6 +-
 drivers/regulator/rc5t583-regulator.c              |   6 +-
 drivers/regulator/s2mps11.c                        |   6 +-
 drivers/regulator/s5m8767.c                        |   6 +-
 drivers/regulator/tps51632-regulator.c             |   8 +-
 drivers/regulator/tps6105x-regulator.c             |   6 +-
 drivers/regulator/tps62360-regulator.c             |   8 +-
 drivers/regulator/tps65023-regulator.c             |   6 +-
 drivers/regulator/tps6507x-regulator.c             |   6 +-
 drivers/regulator/tps65090-regulator.c             |  12 +-
 drivers/regulator/tps65217-regulator.c             |   6 +-
 drivers/regulator/tps6524x-regulator.c             |   4 +-
 drivers/regulator/tps6586x-regulator.c             |   6 +-
 drivers/regulator/tps65910-regulator.c             |   6 +-
 drivers/regulator/tps65912-regulator.c             |   6 +-
 drivers/regulator/tps80031-regulator.c             |   6 +-
 drivers/regulator/twl-regulator.c                  |   8 +-
 drivers/regulator/vexpress.c                       |   4 +-
 drivers/regulator/virtual.c                        |   6 +-
 drivers/regulator/wm831x-dcdc.c                    |  26 ++--
 drivers/regulator/wm831x-isink.c                   |   6 +-
 drivers/regulator/wm831x-ldo.c                     |  18 +--
 drivers/regulator/wm8400-regulator.c               |   6 +-
 drivers/regulator/wm8994-regulator.c               |   6 +-
 drivers/remoteproc/omap_remoteproc.c               |   6 +-
 drivers/rpmsg/virtio_rpmsg_bus.c                   |   4 +-
 drivers/rtc/rtc-88pm80x.c                          |   6 +-
 drivers/rtc/rtc-88pm860x.c                         |   8 +-
 drivers/rtc/rtc-ab8500.c                           |   6 +-
 drivers/rtc/rtc-at91sam9.c                         |   6 +-
 drivers/rtc/rtc-au1xxx.c                           |   6 +-
 drivers/rtc/rtc-bfin.c                             |   6 +-
 drivers/rtc/rtc-bq32k.c                            |   4 +-
 drivers/rtc/rtc-bq4802.c                           |   6 +-
 drivers/rtc/rtc-cmos.c                             |   9 +-
 drivers/rtc/rtc-da9052.c                           |   6 +-
 drivers/rtc/rtc-davinci.c                          |   4 +-
 drivers/rtc/rtc-dm355evm.c                         |   6 +-
 drivers/rtc/rtc-ds1286.c                           |   6 +-
 drivers/rtc/rtc-ds1302.c                           |   4 +-
 drivers/rtc/rtc-ds1305.c                           |   6 +-
 drivers/rtc/rtc-ds1307.c                           |   6 +-
 drivers/rtc/rtc-ds1374.c                           |   4 +-
 drivers/rtc/rtc-ds1390.c                           |   6 +-
 drivers/rtc/rtc-ds1511.c                           |   6 +-
 drivers/rtc/rtc-ds1553.c                           |   6 +-
 drivers/rtc/rtc-ds1742.c                           |   6 +-
 drivers/rtc/rtc-ds3232.c                           |   6 +-
 drivers/rtc/rtc-ds3234.c                           |   6 +-
 drivers/rtc/rtc-ep93xx.c                           |   6 +-
 drivers/rtc/rtc-fm3130.c                           |   6 +-
 drivers/rtc/rtc-imxdi.c                            |   4 +-
 drivers/rtc/rtc-jz4740.c                           |   6 +-
 drivers/rtc/rtc-lpc32xx.c                          |   6 +-
 drivers/rtc/rtc-ls1x.c                             |   6 +-
 drivers/rtc/rtc-m41t93.c                           |   6 +-
 drivers/rtc/rtc-m41t94.c                           |   6 +-
 drivers/rtc/rtc-m48t35.c                           |   6 +-
 drivers/rtc/rtc-m48t59.c                           |   6 +-
 drivers/rtc/rtc-m48t86.c                           |   6 +-
 drivers/rtc/rtc-max6902.c                          |   6 +-
 drivers/rtc/rtc-max8907.c                          |   6 +-
 drivers/rtc/rtc-max8925.c                          |   6 +-
 drivers/rtc/rtc-max8998.c                          |   6 +-
 drivers/rtc/rtc-mpc5121.c                          |   8 +-
 drivers/rtc/rtc-mrst.c                             |  10 +-
 drivers/rtc/rtc-mv.c                               |   2 +-
 drivers/rtc/rtc-mxc.c                              |   6 +-
 drivers/rtc/rtc-nuc900.c                           |   6 +-
 drivers/rtc/rtc-pcap.c                             |   6 +-
 drivers/rtc/rtc-pcf2123.c                          |   6 +-
 drivers/rtc/rtc-pcf50633.c                         |   6 +-
 drivers/rtc/rtc-pcf8563.c                          |   2 +-
 drivers/rtc/rtc-pcf8583.c                          |   4 +-
 drivers/rtc/rtc-pm8xxx.c                           |   6 +-
 drivers/rtc/rtc-puv3.c                             |   6 +-
 drivers/rtc/rtc-r9701.c                            |   6 +-
 drivers/rtc/rtc-rc5t583.c                          |   6 +-
 drivers/rtc/rtc-rs5c313.c                          |   4 +-
 drivers/rtc/rtc-rs5c348.c                          |   6 +-
 drivers/rtc/rtc-rv3029c2.c                         |   6 +-
 drivers/rtc/rtc-rx8025.c                           |   6 +-
 drivers/rtc/rtc-rx8581.c                           |   6 +-
 drivers/rtc/rtc-s3c.c                              |   6 +-
 drivers/rtc/rtc-snvs.c                             |   8 +-
 drivers/rtc/rtc-spear.c                            |   6 +-
 drivers/rtc/rtc-stk17ta8.c                         |   6 +-
 drivers/rtc/rtc-tegra.c                            |   6 +-
 drivers/rtc/rtc-test.c                             |   4 +-
 drivers/rtc/rtc-tile.c                             |   6 +-
 drivers/rtc/rtc-tps65910.c                         |   6 +-
 drivers/rtc/rtc-twl.c                              |   6 +-
 drivers/rtc/rtc-vr41xx.c                           |   6 +-
 drivers/rtc/rtc-vt8500.c                           |   6 +-
 drivers/rtc/rtc-wm831x.c                           |   4 +-
 drivers/rtc/rtc-wm8350.c                           |   4 +-
 drivers/sbus/char/bbc_i2c.c                        |   6 +-
 drivers/sbus/char/display7seg.c                    |   6 +-
 drivers/sbus/char/envctrl.c                        |   6 +-
 drivers/sbus/char/flash.c                          |   6 +-
 drivers/sbus/char/uctrl.c                          |   6 +-
 drivers/scsi/3w-9xxx.c                             |   4 +-
 drivers/scsi/3w-sas.c                              |   4 +-
 drivers/scsi/3w-xxxx.c                             |   4 +-
 drivers/scsi/BusLogic.c                            |   2 +-
 drivers/scsi/NCR5380.c                             |   2 +-
 drivers/scsi/NCR_D700.c                            |  12 +-
 drivers/scsi/NCR_Q720.c                            |   2 +-
 drivers/scsi/a100u2w.c                             |   6 +-
 drivers/scsi/a2091.c                               |   8 +-
 drivers/scsi/aacraid/linit.c                       |  10 +-
 drivers/scsi/advansys.c                            | 124 +++++++++----------
 drivers/scsi/aha152x.c                             |   2 +-
 drivers/scsi/aha1740.c                             |   4 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |  22 ++--
 drivers/scsi/arm/acornscsi.c                       |   6 +-
 drivers/scsi/arm/arxescsi.c                        |   6 +-
 drivers/scsi/arm/cumana_1.c                        |   6 +-
 drivers/scsi/arm/cumana_2.c                        |   6 +-
 drivers/scsi/arm/eesox.c                           |   6 +-
 drivers/scsi/arm/oak.c                             |   6 +-
 drivers/scsi/arm/powertec.c                        |   6 +-
 drivers/scsi/atp870u.c                             |   2 +-
 drivers/scsi/be2iscsi/be_main.c                    |   2 +-
 drivers/scsi/bfa/bfad.c                            |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   2 +-
 drivers/scsi/bnx2i/bnx2i_init.c                    |   2 +-
 drivers/scsi/bvme6000_scsi.c                       |   6 +-
 drivers/scsi/dc395x.c                              |  48 ++++----
 drivers/scsi/dmx3191d.c                            |   6 +-
 drivers/scsi/fdomain.c                             |   2 +-
 drivers/scsi/fnic/fnic_main.c                      |   6 +-
 drivers/scsi/g_NCR5380.c                           |   2 +-
 drivers/scsi/gdth.c                                |  12 +-
 drivers/scsi/gvp11.c                               |  10 +-
 drivers/scsi/hpsa.c                                |  66 +++++-----
 drivers/scsi/hptiop.c                              |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   2 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c                   |   2 +-
 drivers/scsi/initio.c                              |   2 +-
 drivers/scsi/ipr.c                                 |  27 ++---
 drivers/scsi/ips.c                                 |  10 +-
 drivers/scsi/isci/init.c                           |   8 +-
 drivers/scsi/jazz_esp.c                            |   6 +-
 drivers/scsi/lasi700.c                             |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  14 +--
 drivers/scsi/mac_esp.c                             |   6 +-
 drivers/scsi/megaraid.c                            |   6 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |   6 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   6 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |   4 +-
 drivers/scsi/mvme16x_scsi.c                        |   6 +-
 drivers/scsi/mvsas/mv_64xx.c                       |   8 +-
 drivers/scsi/mvsas/mv_94xx.c                       |   6 +-
 drivers/scsi/mvsas/mv_chips.h                      |   2 +-
 drivers/scsi/mvsas/mv_init.c                       |  18 +--
 drivers/scsi/mvsas/mv_sas.c                        |   2 +-
 drivers/scsi/mvsas/mv_sas.h                        |   2 +-
 drivers/scsi/mvumi.c                               |   4 +-
 drivers/scsi/nsp32.c                               |  12 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  22 ++--
 drivers/scsi/pm8001/pm8001_init.c                  |  19 ++-
 drivers/scsi/pmcraid.c                             |  18 +--
 drivers/scsi/ps3rom.c                              |   2 +-
 drivers/scsi/qla1280.c                             |   8 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   4 +-
 drivers/scsi/qlogicfas.c                           |   2 +-
 drivers/scsi/qlogicpti.c                           |  20 +--
 drivers/scsi/sgiwd93.c                             |   4 +-
 drivers/scsi/sim710.c                              |   6 +-
 drivers/scsi/sni_53c710.c                          |   4 +-
 drivers/scsi/stex.c                                |   4 +-
 drivers/scsi/sun3x_esp.c                           |   6 +-
 drivers/scsi/sun_esp.c                             |  26 ++--
 drivers/scsi/sym53c416.c                           |   2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |  18 +--
 drivers/scsi/tmscsim.c                             |  22 ++--
 drivers/scsi/ufs/ufshcd.c                          |   4 +-
 drivers/scsi/virtio_scsi.c                         |   6 +-
 drivers/scsi/vmw_pvscsi.c                          |   8 +-
 drivers/scsi/zalon.c                               |   2 +-
 drivers/scsi/zorro7xx.c                            |  10 +-
 drivers/sh/pfc/gpio.c                              |   6 +-
 drivers/sh/pfc/pinctrl.c                           |  12 +-
 drivers/sn/ioc3.c                                  |  12 +-
 drivers/spi/spi-altera.c                           |   6 +-
 drivers/spi/spi-ath79.c                            |   6 +-
 drivers/spi/spi-atmel.c                            |   4 +-
 drivers/spi/spi-bcm63xx.c                          |   6 +-
 drivers/spi/spi-bfin-sport.c                       |   6 +-
 drivers/spi/spi-bfin5xx.c                          |   4 +-
 drivers/spi/spi-coldfire-qspi.c                    |   6 +-
 drivers/spi/spi-davinci.c                          |   6 +-
 drivers/spi/spi-dw-mmio.c                          |   6 +-
 drivers/spi/spi-dw-pci.c                           |   6 +-
 drivers/spi/spi-dw.c                               |   6 +-
 drivers/spi/spi-ep93xx.c                           |   6 +-
 drivers/spi/spi-falcon.c                           |   6 +-
 drivers/spi/spi-fsl-espi.c                         |   8 +-
 drivers/spi/spi-fsl-lib.c                          |   4 +-
 drivers/spi/spi-fsl-spi.c                          |  14 +--
 drivers/spi/spi-gpio.c                             |  10 +-
 drivers/spi/spi-imx.c                              |   6 +-
 drivers/spi/spi-mpc512x-psc.c                      |  10 +-
 drivers/spi/spi-mpc52xx-psc.c                      |   8 +-
 drivers/spi/spi-mpc52xx.c                          |   8 +-
 drivers/spi/spi-mxs.c                              |   6 +-
 drivers/spi/spi-nuc900.c                           |   6 +-
 drivers/spi/spi-oc-tiny.c                          |  10 +-
 drivers/spi/spi-octeon.c                           |   6 +-
 drivers/spi/spi-omap-100k.c                        |   2 +-
 drivers/spi/spi-omap2-mcspi.c                      |   8 +-
 drivers/spi/spi-orion.c                            |   2 +-
 drivers/spi/spi-pl022.c                            |   8 +-
 drivers/spi/spi-pxa2xx-pci.c                       |   6 +-
 drivers/spi/spi-pxa2xx.c                           |   4 +-
 drivers/spi/spi-rspi.c                             |  10 +-
 drivers/spi/spi-s3c24xx.c                          |   6 +-
 drivers/spi/spi-s3c64xx.c                          |   4 +-
 drivers/spi/spi-sh-hspi.c                          |   6 +-
 drivers/spi/spi-sh.c                               |   6 +-
 drivers/spi/spi-sirf.c                             |   6 +-
 drivers/spi/spi-stmp.c                             |   6 +-
 drivers/spi/spi-tegra20-sflash.c                   |   8 +-
 drivers/spi/spi-tegra20-slink.c                    |   8 +-
 drivers/spi/spi-ti-ssp.c                           |   6 +-
 drivers/spi/spi-tle62x0.c                          |   6 +-
 drivers/spi/spi-topcliff-pch.c                     |  12 +-
 drivers/spi/spi-xcomm.c                            |   6 +-
 drivers/spi/spi-xilinx.c                           |   6 +-
 drivers/spi/spi.c                                  |   2 +-
 drivers/spi/spidev.c                               |   6 +-
 drivers/ssb/driver_gige.c                          |   6 +-
 drivers/ssb/driver_pcicore.c                       |  10 +-
 drivers/ssb/main.c                                 |  12 +-
 drivers/ssb/pcihost_wrapper.c                      |   4 +-
 drivers/staging/comedi/drivers/8255_pci.c          |   8 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |   2 +-
 drivers/staging/comedi/drivers/addi_apci_035.c     |   6 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    |   8 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |   6 +-
 drivers/staging/comedi/drivers/addi_apci_1516.c    |   8 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |   6 +-
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |   6 +-
 drivers/staging/comedi/drivers/addi_apci_1710.c    |   8 +-
 drivers/staging/comedi/drivers/addi_apci_2032.c    |   6 +-
 drivers/staging/comedi/drivers/addi_apci_2200.c    |   6 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |   8 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c    |   6 +-
 drivers/staging/comedi/drivers/addi_apci_3501.c    |   6 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |   6 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |   8 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |   8 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |   8 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |   8 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |   8 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |   8 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |   8 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |   8 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |   8 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |   8 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |   8 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |   8 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   8 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   8 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   8 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |   8 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   8 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |   8 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |   8 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |   8 +-
 drivers/staging/comedi/drivers/das08.c             |   8 +-
 drivers/staging/comedi/drivers/dt3000.c            |   8 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |   8 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   8 +-
 drivers/staging/comedi/drivers/icp_multi.c         |   8 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |   8 +-
 drivers/staging/comedi/drivers/ke_counter.c        |   8 +-
 drivers/staging/comedi/drivers/me4000.c            |   8 +-
 drivers/staging/comedi/drivers/me_daq.c            |   8 +-
 drivers/staging/comedi/drivers/ni_6527.c           |   8 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |   8 +-
 drivers/staging/comedi/drivers/ni_660x.c           |   8 +-
 drivers/staging/comedi/drivers/ni_670x.c           |   8 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |   8 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |   8 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |   8 +-
 drivers/staging/comedi/drivers/rtd520.c            |   8 +-
 drivers/staging/comedi/drivers/s626.c              |   8 +-
 drivers/staging/comedi/drivers/skel.c              |  12 +-
 drivers/staging/crystalhd/crystalhd_cmds.c         |   4 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |  14 +--
 drivers/staging/crystalhd/crystalhd_misc.c         |   2 +-
 drivers/staging/csr/firmware.c                     |   6 -
 drivers/staging/et131x/et131x.c                    |   6 +-
 drivers/staging/iio/accel/adis16201_core.c         |   6 +-
 drivers/staging/iio/accel/adis16203_core.c         |   6 +-
 drivers/staging/iio/accel/adis16204_core.c         |   6 +-
 drivers/staging/iio/accel/adis16209_core.c         |   6 +-
 drivers/staging/iio/accel/adis16220_core.c         |   6 +-
 drivers/staging/iio/accel/adis16240_core.c         |   6 +-
 drivers/staging/iio/accel/kxsd9.c                  |   8 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |   6 +-
 drivers/staging/iio/accel/sca3000_core.c           |   6 +-
 drivers/staging/iio/adc/ad7192.c                   |   6 +-
 drivers/staging/iio/adc/ad7280a.c                  |   6 +-
 drivers/staging/iio/adc/ad7291.c                   |   6 +-
 drivers/staging/iio/adc/ad7298_core.c              |   6 +-
 drivers/staging/iio/adc/ad7606_par.c               |   6 +-
 drivers/staging/iio/adc/ad7606_spi.c               |   6 +-
 drivers/staging/iio/adc/ad7780.c                   |   6 +-
 drivers/staging/iio/adc/ad7793.c                   |   6 +-
 drivers/staging/iio/adc/ad7816.c                   |   6 +-
 drivers/staging/iio/adc/ad799x_core.c              |   6 +-
 drivers/staging/iio/adc/adt7410.c                  |  16 +--
 drivers/staging/iio/adc/lpc32xx_adc.c              |   6 +-
 drivers/staging/iio/adc/mxs-lradc.c                |   6 +-
 drivers/staging/iio/adc/spear_adc.c                |   6 +-
 drivers/staging/iio/addac/adt7316-i2c.c            |   6 +-
 drivers/staging/iio/addac/adt7316-spi.c            |   6 +-
 drivers/staging/iio/addac/adt7316.c                |   4 +-
 drivers/staging/iio/cdc/ad7150.c                   |   6 +-
 drivers/staging/iio/cdc/ad7152.c                   |   6 +-
 drivers/staging/iio/cdc/ad7746.c                   |   6 +-
 drivers/staging/iio/frequency/ad5930.c             |   6 +-
 drivers/staging/iio/frequency/ad9832.c             |   6 +-
 drivers/staging/iio/frequency/ad9834.c             |   6 +-
 drivers/staging/iio/frequency/ad9850.c             |   6 +-
 drivers/staging/iio/frequency/ad9852.c             |   6 +-
 drivers/staging/iio/frequency/ad9910.c             |   6 +-
 drivers/staging/iio/frequency/ad9951.c             |   6 +-
 drivers/staging/iio/gyro/adis16060_core.c          |  12 +-
 drivers/staging/iio/gyro/adis16080_core.c          |   6 +-
 drivers/staging/iio/gyro/adis16130_core.c          |   6 +-
 drivers/staging/iio/gyro/adis16260_core.c          |   6 +-
 drivers/staging/iio/gyro/adxrs450_core.c           |   6 +-
 drivers/staging/iio/iio_hwmon.c                    |   6 +-
 drivers/staging/iio/iio_simple_dummy.c             |   2 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   6 +-
 drivers/staging/iio/imu/adis16400_core.c           |   6 +-
 drivers/staging/iio/light/isl29018.c               |   6 +-
 drivers/staging/iio/light/isl29028.c               |   6 +-
 drivers/staging/iio/light/tsl2563.c                |   6 +-
 drivers/staging/iio/light/tsl2583.c                |   6 +-
 drivers/staging/iio/light/tsl2x7x_core.c           |   6 +-
 drivers/staging/iio/magnetometer/ak8975.c          |   6 +-
 drivers/staging/iio/magnetometer/hmc5843.c         |   6 +-
 drivers/staging/iio/meter/ade7753.c                |   6 +-
 drivers/staging/iio/meter/ade7754.c                |   6 +-
 drivers/staging/iio/meter/ade7758_core.c           |   6 +-
 drivers/staging/iio/meter/ade7759.c                |   6 +-
 drivers/staging/iio/meter/ade7854-i2c.c            |   6 +-
 drivers/staging/iio/meter/ade7854-spi.c            |   6 +-
 drivers/staging/iio/resolver/ad2s1200.c            |   6 +-
 drivers/staging/iio/resolver/ad2s1210.c            |   8 +-
 drivers/staging/iio/resolver/ad2s90.c              |   6 +-
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c  |   6 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c        |   6 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |   6 +-
 drivers/staging/imx-drm/imx-drm-core.c             |   2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |   6 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |   6 +-
 drivers/staging/imx-drm/parallel-display.c         |   6 +-
 drivers/staging/ipack/carriers/tpci200.c           |   4 +-
 drivers/staging/ipack/ipack.c                      |   8 --
 drivers/staging/ipack/ipack.h                      |   3 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |  12 +-
 drivers/staging/media/lirc/lirc_parallel.c         |   6 +-
 drivers/staging/media/lirc/lirc_serial.c           |   6 +-
 drivers/staging/media/lirc/lirc_sir.c              |   6 +-
 drivers/staging/media/solo6x10/core.c              |   4 +-
 drivers/staging/net/pc300_drv.c                    |   6 +-
 drivers/staging/nvec/nvec.c                        |   8 +-
 drivers/staging/nvec/nvec_kbd.c                    |   6 +-
 drivers/staging/nvec/nvec_paz00.c                  |   6 +-
 drivers/staging/nvec/nvec_power.c                  |   6 +-
 drivers/staging/nvec/nvec_ps2.c                    |   6 +-
 drivers/staging/octeon/ethernet.c                  |  12 +-
 drivers/staging/olpc_dcon/olpc_dcon.c              |   2 +-
 drivers/staging/omap-thermal/omap-bandgap.c        |   4 +-
 drivers/staging/rtl8187se/r8180_core.c             |  12 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |  12 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   8 +-
 drivers/staging/sbe-2t3e3/module.c                 |   8 +-
 drivers/staging/sep/sep_main.c                     |   2 +-
 drivers/staging/slicoss/slicoss.c                  |   6 +-
 drivers/staging/sm7xxfb/sm7xxfb.c                  |   6 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      |   6 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |   6 +-
 drivers/staging/usbip/vhci_hcd.c                   |   2 +-
 drivers/staging/vme/devices/vme_pio2.h             |   2 +-
 drivers/staging/vme/devices/vme_pio2_core.c        |  10 +-
 drivers/staging/vme/devices/vme_pio2_gpio.c        |   2 +-
 drivers/staging/vme/devices/vme_user.c             |  10 +-
 drivers/staging/vt6655/device_main.c               |   6 +-
 drivers/staging/vt6656/main_usb.c                  |   4 +-
 drivers/staging/wlags49_h2/wl_pci.c                |  25 ++--
 drivers/staging/xgifb/XGI_main_26.c                |   6 +-
 drivers/thermal/exynos_thermal.c                   |   6 +-
 drivers/tty/cyclades.c                             |  20 +--
 drivers/tty/ehv_bytechan.c                         |   2 +-
 drivers/tty/hvc/hvc_opal.c                         |   8 +-
 drivers/tty/hvc/hvc_vio.c                          |   6 +-
 drivers/tty/hvc/hvc_xen.c                          |   2 +-
 drivers/tty/hvc/hvcs.c                             |  16 +--
 drivers/tty/isicom.c                               |  12 +-
 drivers/tty/moxa.c                                 |   6 +-
 drivers/tty/mxser.c                                |  10 +-
 drivers/tty/nozomi.c                               |  10 +-
 drivers/tty/rocket.c                               |   2 +-
 drivers/tty/serial/8250/8250.c                     |   6 +-
 drivers/tty/serial/8250/8250_acorn.c               |   6 +-
 drivers/tty/serial/8250/8250_dw.c                  |   6 +-
 drivers/tty/serial/8250/8250_em.c                  |   8 +-
 drivers/tty/serial/8250/8250_hp300.c               |  10 +-
 drivers/tty/serial/8250/8250_pci.c                 |  68 +++++------
 drivers/tty/serial/8250/8250_pnp.c                 |  14 +--
 drivers/tty/serial/altera_jtaguart.c               |   6 +-
 drivers/tty/serial/altera_uart.c                   |   6 +-
 drivers/tty/serial/apbuart.c                       |   2 +-
 drivers/tty/serial/ar933x_uart.c                   |   6 +-
 drivers/tty/serial/arc_uart.c                      |  14 +--
 drivers/tty/serial/atmel_serial.c                  |  10 +-
 drivers/tty/serial/bcm63xx_uart.c                  |   6 +-
 drivers/tty/serial/bfin_sport_uart.c               |   6 +-
 drivers/tty/serial/bfin_uart.c                     |   4 +-
 drivers/tty/serial/clps711x.c                      |   6 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   4 +-
 drivers/tty/serial/efm32-uart.c                    |   6 +-
 drivers/tty/serial/icom.c                          |  14 +--
 drivers/tty/serial/ifx6x60.c                       |   2 +-
 drivers/tty/serial/ioc3_serial.c                   |   2 +-
 drivers/tty/serial/jsm/jsm_driver.c                |   6 +-
 drivers/tty/serial/jsm/jsm_tty.c                   |   2 +-
 drivers/tty/serial/lpc32xx_hs.c                    |   6 +-
 drivers/tty/serial/max3100.c                       |   6 +-
 drivers/tty/serial/max310x.c                       |  10 +-
 drivers/tty/serial/mcf.c                           |   6 +-
 drivers/tty/serial/mfd.c                           |   4 +-
 drivers/tty/serial/mpc52xx_uart.c                  |   2 +-
 drivers/tty/serial/mrst_max3110.c                  |   6 +-
 drivers/tty/serial/msm_serial.c                    |   2 +-
 drivers/tty/serial/msm_serial_hs.c                 |   8 +-
 drivers/tty/serial/mux.c                           |   6 +-
 drivers/tty/serial/mxs-auart.c                     |   6 +-
 drivers/tty/serial/of_serial.c                     |   6 +-
 drivers/tty/serial/omap-serial.c                   |  10 +-
 drivers/tty/serial/pch_uart.c                      |   4 +-
 drivers/tty/serial/sa1100.c                        |   2 +-
 drivers/tty/serial/samsung.c                       |   4 +-
 drivers/tty/serial/sc26xx.c                        |   6 +-
 drivers/tty/serial/sccnxp.c                        |   6 +-
 drivers/tty/serial/serial_txx9.c                   |  16 +--
 drivers/tty/serial/sh-sci.c                        |  14 +--
 drivers/tty/serial/sirfsoc_uart.c                  |   4 +-
 drivers/tty/serial/sunhv.c                         |   6 +-
 drivers/tty/serial/sunsab.c                        |   8 +-
 drivers/tty/serial/sunsu.c                         |  10 +-
 drivers/tty/serial/sunzilog.c                      |  14 +--
 drivers/tty/serial/timbuart.c                      |   6 +-
 drivers/tty/serial/uartlite.c                      |  14 +--
 drivers/tty/serial/vr41xx_siu.c                    |   8 +-
 drivers/tty/serial/vt8500_serial.c                 |   6 +-
 drivers/tty/serial/xilinx_uartps.c                 |   6 +-
 drivers/tty/synclink.c                             |   6 +-
 drivers/tty/synclink_gt.c                          |   6 +-
 drivers/tty/synclinkmp.c                           |   6 +-
 drivers/uio/uio_aec.c                              |   2 +-
 drivers/uio/uio_cif.c                              |   4 +-
 drivers/uio/uio_netx.c                             |   2 +-
 drivers/uio/uio_pci_generic.c                      |   2 +-
 drivers/uio/uio_pruss.c                            |   6 +-
 drivers/uio/uio_sercos3.c                          |   4 +-
 drivers/usb/c67x00/c67x00-drv.c                    |   6 +-
 drivers/usb/chipidea/ci13xxx_imx.c                 |   8 +-
 drivers/usb/chipidea/ci13xxx_msm.c                 |   6 +-
 drivers/usb/chipidea/ci13xxx_pci.c                 |   6 +-
 drivers/usb/chipidea/core.c                        |   6 +-
 drivers/usb/chipidea/usbmisc_imx6q.c               |   6 +-
 drivers/usb/core/driver.c                          |  25 ----
 drivers/usb/core/message.c                         |   9 --
 drivers/usb/core/usb.c                             |   9 --
 drivers/usb/dwc3/core.c                            |  15 ++-
 drivers/usb/dwc3/debugfs.c                         |   4 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |   8 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   8 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   8 +-
 drivers/usb/dwc3/gadget.c                          |   4 +-
 drivers/usb/gadget/at91_udc.c                      |   4 +-
 drivers/usb/gadget/bcm63xx_udc.c                   |   6 +-
 drivers/usb/gadget/f_uac2.c                        |   2 +-
 drivers/usb/gadget/fsl_qe_udc.c                    |  14 +--
 drivers/usb/gadget/hid.c                           |   4 +-
 drivers/usb/gadget/lpc32xx_udc.c                   |   4 +-
 drivers/usb/gadget/mv_u3d_core.c                   |   2 +-
 drivers/usb/gadget/mv_udc_core.c                   |   4 +-
 drivers/usb/gadget/net2272.c                       |  29 +++--
 drivers/usb/gadget/omap_udc.c                      |  10 +-
 drivers/usb/gadget/s3c-hsotg.c                     |  12 +-
 drivers/usb/gadget/s3c-hsudc.c                     |   2 +-
 drivers/usb/host/bcma-hcd.c                        |  15 ++-
 drivers/usb/host/ehci-atmel.c                      |   6 +-
 drivers/usb/host/ehci-grlib.c                      |   2 +-
 drivers/usb/host/ehci-msm.c                        |   4 +-
 drivers/usb/host/ehci-orion.c                      |   4 +-
 drivers/usb/host/ehci-platform.c                   |   6 +-
 drivers/usb/host/ehci-ppc-of.c                     |   4 +-
 drivers/usb/host/ehci-ps3.c                        |   2 +-
 drivers/usb/host/ehci-s5p.c                        |   6 +-
 drivers/usb/host/ehci-spear.c                      |   2 +-
 drivers/usb/host/ehci-tegra.c                      |   2 +-
 drivers/usb/host/ehci-w90x900.c                    |   8 +-
 drivers/usb/host/ehci-xilinx-of.c                  |   2 +-
 drivers/usb/host/fhci-hcd.c                        |   8 +-
 drivers/usb/host/fsl-mph-dr-of.c                   |  16 +--
 drivers/usb/host/imx21-hcd.c                       |   2 +-
 drivers/usb/host/isp116x-hcd.c                     |   2 +-
 drivers/usb/host/isp1362-hcd.c                     |   6 +-
 drivers/usb/host/isp1760-if.c                      |   8 +-
 drivers/usb/host/ohci-at91.c                       |  20 +--
 drivers/usb/host/ohci-ep93xx.c                     |   2 +-
 drivers/usb/host/ohci-exynos.c                     |   6 +-
 drivers/usb/host/ohci-jz4740.c                     |   6 +-
 drivers/usb/host/ohci-nxp.c                        |   4 +-
 drivers/usb/host/ohci-octeon.c                     |   2 +-
 drivers/usb/host/ohci-omap3.c                      |   6 +-
 drivers/usb/host/ohci-pci.c                        |   2 +-
 drivers/usb/host/ohci-platform.c                   |   6 +-
 drivers/usb/host/ohci-ppc-of.c                     |   4 +-
 drivers/usb/host/ohci-ps3.c                        |   4 +-
 drivers/usb/host/ohci-pxa27x.c                     |   6 +-
 drivers/usb/host/ohci-s3c2410.c                    |   6 +-
 drivers/usb/host/ohci-sa1111.c                     |   2 +-
 drivers/usb/host/ohci-spear.c                      |   4 +-
 drivers/usb/host/ohci-tmio.c                       |   6 +-
 drivers/usb/host/pci-quirks.c                      |  16 +--
 drivers/usb/host/r8a66597-hcd.c                    |   6 +-
 drivers/usb/host/sl811-hcd.c                       |   6 +-
 drivers/usb/host/ssb-hcd.c                         |  19 ++-
 drivers/usb/host/u132-hcd.c                        |   6 +-
 drivers/usb/host/uhci-grlib.c                      |   2 +-
 drivers/usb/host/uhci-platform.c                   |   2 +-
 drivers/usb/musb/am35x.c                           |   6 +-
 drivers/usb/musb/blackfin.c                        |   4 +-
 drivers/usb/musb/cppi_dma.c                        |   3 +-
 drivers/usb/musb/da8xx.c                           |   6 +-
 drivers/usb/musb/davinci.c                         |   6 +-
 drivers/usb/musb/musb_core.c                       |  41 +++----
 drivers/usb/musb/musb_debugfs.c                    |   2 +-
 drivers/usb/musb/musb_dma.h                        |   3 +-
 drivers/usb/musb/musb_dsps.c                       |  14 +--
 drivers/usb/musb/musb_gadget.c                     |   6 +-
 drivers/usb/musb/musbhsdma.c                       |   3 +-
 drivers/usb/musb/omap2430.c                        |   6 +-
 drivers/usb/musb/tusb6010.c                        |   6 +-
 drivers/usb/musb/tusb6010_omap.c                   |   3 +-
 drivers/usb/musb/ux500.c                           |   6 +-
 drivers/usb/musb/ux500_dma.c                       |   3 +-
 drivers/usb/otg/ab8500-usb.c                       |   6 +-
 drivers/usb/otg/fsl_otg.c                          |   6 +-
 drivers/usb/otg/isp1301_omap.c                     |   2 +-
 drivers/usb/otg/msm_otg.c                          |   4 +-
 drivers/usb/otg/mxs-phy.c                          |   4 +-
 drivers/usb/otg/nop-usb-xceiv.c                    |   6 +-
 drivers/usb/otg/twl4030-usb.c                      |   2 +-
 drivers/usb/otg/twl6030-usb.c                      |   2 +-
 drivers/usb/phy/mv_u3d_phy.c                       |   4 +-
 drivers/usb/phy/omap-usb2.c                        |   6 +-
 drivers/usb/phy/rcar-phy.c                         |   6 +-
 drivers/usb/renesas_usbhs/common.c                 |   4 +-
 drivers/usb/serial/bus.c                           |  10 --
 drivers/video/acornfb.c                            |  22 ++--
 drivers/video/arcfb.c                              |  10 +-
 drivers/video/arkfb.c                              |  10 +-
 drivers/video/asiliantfb.c                         |  16 +--
 drivers/video/aty/aty128fb.c                       |  48 ++++----
 drivers/video/aty/atyfb_base.c                     |  74 ++++++------
 drivers/video/aty/mach64_ct.c                      |   4 +-
 drivers/video/aty/mach64_cursor.c                  |   2 +-
 drivers/video/aty/radeon_base.c                    |  18 +--
 drivers/video/aty/radeon_monitor.c                 |  16 +--
 drivers/video/au1100fb.c                           |   6 +-
 drivers/video/au1200fb.c                           |   6 +-
 drivers/video/auo_k1900fb.c                        |   6 +-
 drivers/video/auo_k1901fb.c                        |   6 +-
 drivers/video/auo_k190x.c                          |   4 +-
 drivers/video/backlight/adp5520_bl.c               |   6 +-
 drivers/video/backlight/adp8860_bl.c               |  14 +--
 drivers/video/backlight/adp8870_bl.c               |  14 +--
 drivers/video/backlight/ams369fg06.c               |   6 +-
 drivers/video/backlight/apple_bl.c                 |   4 +-
 drivers/video/backlight/corgi_lcd.c                |   6 +-
 drivers/video/backlight/ep93xx_bl.c                |   6 +-
 drivers/video/backlight/hp680_bl.c                 |   6 +-
 drivers/video/backlight/ili9320.c                  |   6 +-
 drivers/video/backlight/l4f00242t03.c              |   6 +-
 drivers/video/backlight/ld9040.c                   |   4 +-
 drivers/video/backlight/lm3533_bl.c                |   8 +-
 drivers/video/backlight/lm3630_bl.c                |   8 +-
 drivers/video/backlight/lm3639_bl.c                |   8 +-
 drivers/video/backlight/lms283gf05.c               |   6 +-
 drivers/video/backlight/lp855x_bl.c                |   4 +-
 drivers/video/backlight/ltv350qv.c                 |   6 +-
 drivers/video/backlight/max8925_bl.c               |   6 +-
 drivers/video/backlight/pcf50633-backlight.c       |   6 +-
 drivers/video/backlight/platform_lcd.c             |   6 +-
 drivers/video/backlight/s6e63m0.c                  |   6 +-
 drivers/video/backlight/tdo24m.c                   |   6 +-
 drivers/video/backlight/tosa_bl.c                  |   6 +-
 drivers/video/backlight/tosa_lcd.c                 |   6 +-
 drivers/video/backlight/vgg2432a4.c                |   6 +-
 drivers/video/bf537-lq035.c                        |  16 +--
 drivers/video/bf54x-lq043fb.c                      |   6 +-
 drivers/video/bfin-lq035q1-fb.c                    |  12 +-
 drivers/video/bfin-t350mcqb-fb.c                   |   6 +-
 drivers/video/bfin_adv7393fb.c                     |   8 +-
 drivers/video/broadsheetfb.c                       |  16 +--
 drivers/video/bw2.c                                |  20 +--
 drivers/video/carminefb.c                          |  12 +-
 drivers/video/cg14.c                               |  10 +-
 drivers/video/cg3.c                                |  22 ++--
 drivers/video/cg6.c                                |  12 +-
 drivers/video/chipsfb.c                            |  12 +-
 drivers/video/cirrusfb.c                           |  38 +++---
 drivers/video/cobalt_lcdfb.c                       |   8 +-
 drivers/video/console/sticore.c                    |  53 ++++----
 drivers/video/cyber2000fb.c                        |  20 +--
 drivers/video/da8xx-fb.c                           |  10 +-
 drivers/video/dnfb.c                               |   6 +-
 drivers/video/efifb.c                              |   4 +-
 drivers/video/ep93xx-fb.c                          |   8 +-
 drivers/video/exynos/exynos_dp_core.c              |   6 +-
 drivers/video/exynos/exynos_mipi_dsi.c             |   4 +-
 drivers/video/ffb.c                                |   6 +-
 drivers/video/fm2fb.c                              |  12 +-
 drivers/video/fsl-diu-fb.c                         |   6 +-
 drivers/video/gbefb.c                              |  24 ++--
 drivers/video/geode/gx1fb_core.c                   |  14 +--
 drivers/video/geode/gxfb_core.c                    |  16 +--
 drivers/video/geode/lxfb_core.c                    |  16 +--
 drivers/video/grvga.c                              |  10 +-
 drivers/video/gxt4500.c                            |  12 +-
 drivers/video/hecubafb.c                           |  10 +-
 drivers/video/hgafb.c                              |  12 +-
 drivers/video/hitfb.c                              |  10 +-
 drivers/video/hpfb.c                               |  14 +--
 drivers/video/i740fb.c                             |  14 +--
 drivers/video/i810/i810_main.c                     |  64 +++++-----
 drivers/video/i810/i810_main.h                     |   2 +-
 drivers/video/igafb.c                              |   2 +-
 drivers/video/imsttfb.c                            |  14 +--
 drivers/video/imxfb.c                              |   4 +-
 drivers/video/intelfb/intelfbdrv.c                 |  24 ++--
 drivers/video/jz4740_fb.c                          |   8 +-
 drivers/video/kyro/fbdev.c                         |  20 +--
 drivers/video/leo.c                                |   6 +-
 drivers/video/mb862xx/mb862xxfbdrv.c               |  18 +--
 drivers/video/mbx/mbxdebugfs.c                     |   4 +-
 drivers/video/mbx/mbxfb.c                          |  18 +--
 drivers/video/metronomefb.c                        |  20 +--
 drivers/video/msm/mddi.c                           |   6 +-
 drivers/video/mxsfb.c                              |  12 +-
 drivers/video/neofb.c                              |  20 +--
 drivers/video/nuc900fb.c                           |   4 +-
 drivers/video/nvidia/nvidia.c                      |  48 ++++----
 drivers/video/omap/lcd_mipid.c                     |   2 +-
 drivers/video/omap2/displays/panel-acx565akm.c     |   2 +-
 .../omap2/displays/panel-lgphilips-lb035q02.c      |   6 +-
 drivers/video/omap2/displays/panel-n8x0.c          |   2 +-
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |   2 +-
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |   4 +-
 drivers/video/p9100.c                              |   6 +-
 drivers/video/platinumfb.c                         |  10 +-
 drivers/video/pm2fb.c                              |  16 +--
 drivers/video/pm3fb.c                              |  16 +--
 drivers/video/pmag-ba-fb.c                         |   6 +-
 drivers/video/pmagb-b-fb.c                         |  12 +-
 drivers/video/ps3fb.c                              |   4 +-
 drivers/video/pvr2fb.c                             |  24 ++--
 drivers/video/pxa168fb.c                           |   8 +-
 drivers/video/pxa3xx-gcu.c                         |   6 +-
 drivers/video/pxafb.c                              |  28 ++---
 drivers/video/q40fb.c                              |   6 +-
 drivers/video/riva/fbdev.c                         |  42 +++----
 drivers/video/riva/rivafb-i2c.c                    |   6 +-
 drivers/video/s1d13xxxfb.c                         |   8 +-
 drivers/video/s3c-fb.c                             |  10 +-
 drivers/video/s3c2410fb.c                          |  14 +--
 drivers/video/s3fb.c                               |  16 +--
 drivers/video/sa1100fb.c                           |   8 +-
 drivers/video/savage/savagefb_driver.c             |  18 +--
 drivers/video/sgivwfb.c                            |  12 +-
 drivers/video/sh7760fb.c                           |   6 +-
 drivers/video/sh_mipi_dsi.c                        |   4 +-
 drivers/video/sh_mobile_lcdcfb.c                   |  18 +--
 drivers/video/sh_mobile_meram.c                    |   2 +-
 drivers/video/sis/sis_main.c                       |  88 +++++++-------
 drivers/video/sis/sis_main.h                       |  20 +--
 drivers/video/skeletonfb.c                         |  15 ++-
 drivers/video/sm501fb.c                            |  10 +-
 drivers/video/sstfb.c                              |  32 ++---
 drivers/video/sunxvr1000.c                         |  10 +-
 drivers/video/sunxvr2500.c                         |  10 +-
 drivers/video/sunxvr500.c                          |  10 +-
 drivers/video/tcx.c                                |   6 +-
 drivers/video/tdfxfb.c                             |  24 ++--
 drivers/video/tgafb.c                              |  34 +++---
 drivers/video/tmiofb.c                             |   8 +-
 drivers/video/tridentfb.c                          |  26 ++--
 drivers/video/uvesafb.c                            |  56 ++++-----
 drivers/video/vermilion/vermilion.c                |   6 +-
 drivers/video/vfb.c                                |   6 +-
 drivers/video/vga16fb.c                            |  10 +-
 drivers/video/via/dvi.c                            |   8 +-
 drivers/video/via/dvi.h                            |   4 +-
 drivers/video/via/hw.c                             |  16 +--
 drivers/video/via/hw.h                             |   4 +-
 drivers/video/via/lcd.c                            |  10 +-
 drivers/video/via/lcd.h                            |   6 +-
 drivers/video/via/via-core.c                       |  16 +--
 drivers/video/via/via-gpio.c                       |   2 +-
 drivers/video/via/viafbdev.c                       |  12 +-
 drivers/video/vt8500lcdfb.c                        |   6 +-
 drivers/video/vt8623fb.c                           |   8 +-
 drivers/video/w100fb.c                             |  10 +-
 drivers/video/wm8505fb.c                           |   6 +-
 drivers/video/wmt_ge_rops.c                        |   6 +-
 drivers/video/xen-fbfront.c                        |   4 +-
 drivers/video/xilinxfb.c                           |   8 +-
 drivers/virtio/virtio_balloon.c                    |   4 +-
 drivers/virtio/virtio_mmio.c                       |   6 +-
 drivers/virtio/virtio_pci.c                        |   6 +-
 drivers/vlynq/vlynq.c                              |   6 +-
 drivers/w1/masters/matrox_w1.c                     |  10 +-
 drivers/w1/masters/mxc_w1.c                        |   4 +-
 drivers/w1/masters/omap_hdq.c                      |  10 +-
 drivers/w1/w1.c                                    |   7 --
 drivers/watchdog/acquirewdt.c                      |   6 +-
 drivers/watchdog/advantechwdt.c                    |   6 +-
 drivers/watchdog/ar7_wdt.c                         |   6 +-
 drivers/watchdog/at91rm9200_wdt.c                  |   6 +-
 drivers/watchdog/ath79_wdt.c                       |   6 +-
 drivers/watchdog/bcm63xx_wdt.c                     |   6 +-
 drivers/watchdog/bfin_wdt.c                        |   6 +-
 drivers/watchdog/cpu5wdt.c                         |   8 +-
 drivers/watchdog/cpwd.c                            |   6 +-
 drivers/watchdog/da9052_wdt.c                      |   6 +-
 drivers/watchdog/davinci_wdt.c                     |   6 +-
 drivers/watchdog/dw_wdt.c                          |   6 +-
 drivers/watchdog/ep93xx_wdt.c                      |   6 +-
 drivers/watchdog/gef_wdt.c                         |   4 +-
 drivers/watchdog/geodewdt.c                        |   6 +-
 drivers/watchdog/hpwdt.c                           |  30 ++---
 drivers/watchdog/i6300esb.c                        |  10 +-
 drivers/watchdog/iTCO_wdt.c                        |   8 +-
 drivers/watchdog/ib700wdt.c                        |   6 +-
 drivers/watchdog/ie6xx_wdt.c                       |  10 +-
 drivers/watchdog/jz4740_wdt.c                      |   6 +-
 drivers/watchdog/ks8695_wdt.c                      |   6 +-
 drivers/watchdog/lantiq_wdt.c                      |   6 +-
 drivers/watchdog/max63xx_wdt.c                     |   6 +-
 drivers/watchdog/mixcomwd.c                        |   2 +-
 drivers/watchdog/mpc8xxx_wdt.c                     |   6 +-
 drivers/watchdog/mpcore_wdt.c                      |   6 +-
 drivers/watchdog/mtx-1_wdt.c                       |   6 +-
 drivers/watchdog/mv64x60_wdt.c                     |   6 +-
 drivers/watchdog/nuc900_wdt.c                      |   6 +-
 drivers/watchdog/nv_tco.c                          |  10 +-
 drivers/watchdog/of_xilinx_wdt.c                   |   8 +-
 drivers/watchdog/omap_wdt.c                        |   6 +-
 drivers/watchdog/orion_wdt.c                       |   8 +-
 drivers/watchdog/pcwd.c                            |   8 +-
 drivers/watchdog/pcwd_pci.c                        |   6 +-
 drivers/watchdog/pnx4008_wdt.c                     |   6 +-
 drivers/watchdog/rc32434_wdt.c                     |   6 +-
 drivers/watchdog/rdc321x_wdt.c                     |   6 +-
 drivers/watchdog/riowd.c                           |   6 +-
 drivers/watchdog/s3c2410_wdt.c                     |   6 +-
 drivers/watchdog/sch311x_wdt.c                     |   6 +-
 drivers/watchdog/shwdt.c                           |   6 +-
 drivers/watchdog/sp5100_tco.c                      |  10 +-
 drivers/watchdog/sp805_wdt.c                       |   6 +-
 drivers/watchdog/stmp3xxx_wdt.c                    |   6 +-
 drivers/watchdog/ts72xx_wdt.c                      |   6 +-
 drivers/watchdog/twl4030_wdt.c                     |   6 +-
 drivers/watchdog/via_wdt.c                         |   6 +-
 drivers/watchdog/wdt_pci.c                         |   6 +-
 drivers/watchdog/wm831x_wdt.c                      |   6 +-
 drivers/watchdog/wm8350_wdt.c                      |   6 +-
 drivers/watchdog/xen_wdt.c                         |   6 +-
 drivers/xen/grant-table.c                          |   2 +-
 drivers/xen/platform-pci.c                         |   4 +-
 drivers/xen/xen-pciback/pci_stub.c                 |  10 +-
 drivers/zorro/zorro-driver.c                       |   4 -
 fs/file.c                                          |   2 +-
 fs/pstore/ram.c                                    |   6 +-
 fs/pstore/ram_core.c                               |   4 +-
 include/asm-generic/parport.h                      |   4 +-
 include/asm-generic/vmlinux.lds.h                  |   5 -
 include/linux/ata_platform.h                       |   4 +-
 include/linux/bcma/bcma_driver_gmac_cmn.h          |   2 +-
 include/linux/bcma/bcma_driver_pci.h               |   2 +-
 include/linux/init.h                               |  14 ---
 include/linux/kobject.h                            |  18 ---
 include/linux/mfd/88pm80x.h                        |   2 +-
 include/linux/mfd/abx500/ab8500.h                  |   4 +-
 include/linux/mfd/pm8xxx/irq.h                     |   8 +-
 include/linux/pci.h                                |   8 +-
 include/linux/pstore_ram.h                         |   2 +-
 include/linux/vmstat.h                             |   6 -
 kernel/ksysfs.c                                    |   5 +-
 kernel/sysctl.c                                    |   4 +-
 lib/Makefile                                       |   4 +-
 mm/vmscan.c                                        |   2 +-
 mm/vmstat.c                                        |   2 -
 net/core/net-sysfs.c                               |   4 -
 net/rfkill/rfkill-gpio.c                           |   2 +-
 net/rfkill/rfkill-regulator.c                      |   6 +-
 net/wireless/reg.c                                 |   7 --
 net/wireless/sysfs.c                               |   4 -
 samples/rpmsg/rpmsg_client_sample.c                |   4 +-
 scripts/kernel-doc                                 |   1 -
 sound/arm/aaci.c                                   |  16 +--
 sound/arm/pxa2xx-ac97-lib.c                        |   2 +-
 sound/arm/pxa2xx-ac97.c                            |   6 +-
 sound/atmel/abdac.c                                |   8 +-
 sound/atmel/ac97c.c                                |  10 +-
 sound/drivers/aloop.c                              |  14 +--
 sound/drivers/dummy.c                              |  12 +-
 sound/drivers/ml403-ac97cr.c                       |  14 +--
 sound/drivers/mpu401/mpu401.c                      |  14 +--
 sound/drivers/mtpav.c                              |  12 +-
 sound/drivers/mts64.c                              |  34 +++---
 sound/drivers/pcsp/pcsp.c                          |  14 +--
 sound/drivers/pcsp/pcsp_input.c                    |   2 +-
 sound/drivers/pcsp/pcsp_input.h                    |   2 +-
 sound/drivers/pcsp/pcsp_lib.c                      |   2 +-
 sound/drivers/pcsp/pcsp_mixer.c                    |   8 +-
 sound/drivers/portman2x4.c                         |  14 +--
 sound/drivers/serial-u16550.c                      |  14 +--
 sound/drivers/virmidi.c                            |   6 +-
 sound/firewire/speakers.c                          |   8 +-
 sound/isa/ad1816a/ad1816a.c                        |  12 +-
 sound/isa/ad1816a/ad1816a_lib.c                    |  14 +--
 sound/isa/ad1848/ad1848.c                          |   8 +-
 sound/isa/adlib.c                                  |   8 +-
 sound/isa/als100.c                                 |  12 +-
 sound/isa/azt2320.c                                |  16 +--
 sound/isa/cmi8328.c                                |   8 +-
 sound/isa/cmi8330.c                                |  30 ++---
 sound/isa/cs423x/cs4231.c                          |   8 +-
 sound/isa/cs423x/cs4236.c                          |  32 ++---
 sound/isa/es1688/es1688.c                          |  20 +--
 sound/isa/es18xx.c                                 |  48 ++++----
 sound/isa/galaxy/galaxy.c                          |  26 ++--
 sound/isa/gus/gusclassic.c                         |  12 +-
 sound/isa/gus/gusextreme.c                         |  16 +--
 sound/isa/gus/gusmax.c                             |  14 +--
 sound/isa/gus/interwave.c                          |  34 +++---
 sound/isa/msnd/msnd.h                              |   2 +-
 sound/isa/msnd/msnd_pinnacle.c                     |  40 +++---
 sound/isa/msnd/msnd_pinnacle_mixer.c               |   2 +-
 sound/isa/opl3sa2.c                                |  28 ++---
 sound/isa/opti9xx/miro.c                           |  50 ++++----
 sound/isa/opti9xx/opti92x-ad1848.c                 |  26 ++--
 sound/isa/sb/emu8000.c                             |  33 ++---
 sound/isa/sb/jazz16.c                              |  14 +--
 sound/isa/sb/sb16.c                                |  20 +--
 sound/isa/sb/sb8.c                                 |   8 +-
 sound/isa/sc6000.c                                 |  28 ++---
 sound/isa/sscape.c                                 |  26 ++--
 sound/isa/wavefront/wavefront.c                    |  29 ++---
 sound/isa/wavefront/wavefront_fx.c                 |   3 +-
 sound/isa/wavefront/wavefront_midi.c               |   3 +-
 sound/isa/wavefront/wavefront_synth.c              |  21 ++--
 sound/mips/au1x00.c                                |   6 +-
 sound/mips/hal2.c                                  |  14 +--
 sound/mips/sgio2audio.c                            |  26 ++--
 sound/oss/ad1848.c                                 |   2 +-
 sound/oss/kahlua.c                                 |  10 +-
 sound/oss/swarm_cs4297a.c                          |   2 +-
 sound/parisc/harmony.c                             |  16 +--
 sound/pci/ad1889.c                                 |  25 ++--
 sound/pci/ak4531_codec.c                           |   7 +-
 sound/pci/ali5451/ali5451.c                        |  20 +--
 sound/pci/als300.c                                 |  10 +-
 sound/pci/als4000.c                                |  10 +-
 sound/pci/asihpi/asihpi.c                          |  32 ++---
 sound/pci/asihpi/hpioctl.c                         |   4 +-
 sound/pci/asihpi/hpioctl.h                         |   4 +-
 sound/pci/atiixp.c                                 |  24 ++--
 sound/pci/atiixp_modem.c                           |  14 +--
 sound/pci/au88x0/au88x0.c                          |  12 +-
 sound/pci/au88x0/au88x0_a3d.c                      |   6 +-
 sound/pci/au88x0/au88x0_core.c                     |   2 +-
 sound/pci/au88x0/au88x0_eq.c                       |  10 +-
 sound/pci/au88x0/au88x0_game.c                     |   2 +-
 sound/pci/au88x0/au88x0_mixer.c                    |   2 +-
 sound/pci/au88x0/au88x0_mpu401.c                   |   2 +-
 sound/pci/au88x0/au88x0_pcm.c                      |   6 +-
 sound/pci/aw2/aw2-alsa.c                           |  20 +--
 sound/pci/azt3328.c                                |  29 ++---
 sound/pci/bt87x.c                                  |  16 +--
 sound/pci/ca0106/ca0106_main.c                     |  12 +-
 sound/pci/ca0106/ca0106_mixer.c                    |  28 ++---
 sound/pci/ca0106/ca0106_proc.c                     |   2 +-
 sound/pci/ca0106/ca_midi.c                         |   2 +-
 sound/pci/cmipci.c                                 |  44 +++----
 sound/pci/cs4281.c                                 |  18 +--
 sound/pci/cs46xx/cs46xx.c                          |   6 +-
 sound/pci/cs46xx/cs46xx_lib.c                      |  28 ++---
 sound/pci/cs5530.c                                 |  10 +-
 sound/pci/cs5535audio/cs5535audio.c                |  12 +-
 sound/pci/cs5535audio/cs5535audio.h                |   8 +-
 sound/pci/cs5535audio/cs5535audio_olpc.c           |   8 +-
 sound/pci/cs5535audio/cs5535audio_pcm.c            |   2 +-
 sound/pci/ctxfi/ctatc.c                            |  14 +--
 sound/pci/ctxfi/ctatc.h                            |   4 +-
 sound/pci/ctxfi/cthardware.c                       |   2 +-
 sound/pci/ctxfi/cthw20k1.c                         |   4 +-
 sound/pci/ctxfi/cthw20k2.c                         |   4 +-
 sound/pci/ctxfi/xfi.c                              |   7 +-
 sound/pci/echoaudio/echoaudio.c                    |  40 +++---
 sound/pci/echoaudio/echoaudio.h                    |   2 +-
 sound/pci/echoaudio/midi.c                         |   2 +-
 sound/pci/emu10k1/emu10k1.c                        |   6 +-
 sound/pci/emu10k1/emu10k1_main.c                   |   4 +-
 sound/pci/emu10k1/emu10k1x.c                       |  20 +--
 sound/pci/emu10k1/emufx.c                          |  28 ++---
 sound/pci/emu10k1/emumixer.c                       |  20 +--
 sound/pci/emu10k1/emumpu401.c                      |   6 +-
 sound/pci/emu10k1/emupcm.c                         |   8 +-
 sound/pci/emu10k1/emuproc.c                        |   2 +-
 sound/pci/emu10k1/p16v.c                           |   8 +-
 sound/pci/emu10k1/timer.c                          |   2 +-
 sound/pci/ens1370.c                                |  38 +++---
 sound/pci/es1938.c                                 |  14 +--
 sound/pci/es1968.c                                 |  27 ++---
 sound/pci/fm801.c                                  |  16 +--
 sound/pci/hda/hda_intel.c                          |  60 ++++-----
 sound/pci/ice1712/amp.c                            |   6 +-
 sound/pci/ice1712/aureon.c                         |  24 ++--
 sound/pci/ice1712/delta.c                          |  42 +++----
 sound/pci/ice1712/ews.c                            |  28 ++---
 sound/pci/ice1712/hoontech.c                       |  26 ++--
 sound/pci/ice1712/ice1712.c                        |  74 ++++++------
 sound/pci/ice1712/ice1724.c                        |  54 ++++-----
 sound/pci/ice1712/juli.c                           |  21 ++--
 sound/pci/ice1712/maya44.c                         |  14 +--
 sound/pci/ice1712/phase.c                          |  22 ++--
 sound/pci/ice1712/pontis.c                         |  10 +-
 sound/pci/ice1712/prodigy192.c                     |  12 +-
 sound/pci/ice1712/prodigy_hifi.c                   |  20 +--
 sound/pci/ice1712/psc724.c                         |   8 +-
 sound/pci/ice1712/quartet.c                        |  21 ++--
 sound/pci/ice1712/revo.c                           |  28 ++---
 sound/pci/ice1712/se.c                             |  20 +--
 sound/pci/ice1712/vt1720_mobo.c                    |  10 +-
 sound/pci/ice1712/wtm.c                            |  10 +-
 sound/pci/intel8x0.c                               |  42 +++----
 sound/pci/intel8x0m.c                              |  20 +--
 sound/pci/korg1212/korg1212.c                      |  11 +-
 sound/pci/lola/lola.c                              |  10 +-
 sound/pci/lola/lola_clock.c                        |   2 +-
 sound/pci/lola/lola_mixer.c                        |  24 ++--
 sound/pci/lola/lola_pcm.c                          |   4 +-
 sound/pci/lola/lola_proc.c                         |   2 +-
 sound/pci/lx6464es/lx6464es.c                      |  24 ++--
 sound/pci/lx6464es/lx_core.c                       |   2 +-
 sound/pci/lx6464es/lx_core.h                       |   2 +-
 sound/pci/maestro3.c                               |  27 ++---
 sound/pci/mixart/mixart.c                          |  10 +-
 sound/pci/nm256/nm256.c                            |  20 ++-
 sound/pci/oxygen/oxygen.c                          |   6 +-
 sound/pci/oxygen/virtuoso.c                        |   6 +-
 sound/pci/oxygen/xonar_cs43xx.c                    |   2 +-
 sound/pci/oxygen/xonar_pcm179x.c                   |   2 +-
 sound/pci/oxygen/xonar_wm87x6.c                    |   2 +-
 sound/pci/pcxhr/pcxhr.c                            |  10 +-
 sound/pci/riptide/riptide.c                        |  24 ++--
 sound/pci/rme32.c                                  |  11 +-
 sound/pci/rme96.c                                  |  14 +--
 sound/pci/rme9652/hdsp.c                           |  10 +-
 sound/pci/rme9652/hdspm.c                          |  24 ++--
 sound/pci/rme9652/rme9652.c                        |  14 +--
 sound/pci/sis7019.c                                |  12 +-
 sound/pci/sonicvibes.c                             |  24 ++--
 sound/pci/trident/trident.c                        |   6 +-
 sound/pci/trident/trident_main.c                   |  40 +++---
 sound/pci/via82xx.c                                |  38 +++---
 sound/pci/via82xx_modem.c                          |  14 +--
 sound/pci/vx222/vx222.c                            |   8 +-
 sound/pci/ymfpci/ymfpci.c                          |   8 +-
 sound/pci/ymfpci/ymfpci_main.c                     |  36 +++---
 sound/ppc/awacs.c                                  |  55 +++++----
 sound/ppc/beep.c                                   |   2 +-
 sound/ppc/burgundy.c                               |  22 ++--
 sound/ppc/daca.c                                   |   2 +-
 sound/ppc/keywest.c                                |   4 +-
 sound/ppc/pmac.c                                   |  12 +-
 sound/ppc/powermac.c                               |   6 +-
 sound/ppc/snd_ps3.c                                |  12 +-
 sound/ppc/tumbler.c                                |  16 +--
 sound/sh/aica.c                                    |  12 +-
 sound/sh/sh_dac_audio.c                            |   6 +-
 sound/soc/atmel/atmel-pcm.c                        |   6 +-
 sound/soc/atmel/atmel_ssc_dai.c                    |   6 +-
 sound/soc/atmel/sam9g20_wm8731.c                   |   6 +-
 sound/soc/au1x/ac97c.c                             |   6 +-
 sound/soc/au1x/db1000.c                            |   6 +-
 sound/soc/au1x/db1200.c                            |   8 +-
 sound/soc/au1x/dbdma2.c                            |   6 +-
 sound/soc/au1x/dma.c                               |   6 +-
 sound/soc/au1x/i2sc.c                              |   6 +-
 sound/soc/au1x/psc-ac97.c                          |   6 +-
 sound/soc/au1x/psc-i2s.c                           |   6 +-
 sound/soc/blackfin/bf5xx-ac97-pcm.c                |   6 +-
 sound/soc/blackfin/bf5xx-ac97.c                    |   6 +-
 sound/soc/blackfin/bf5xx-ad1836.c                  |   6 +-
 sound/soc/blackfin/bf5xx-i2s-pcm.c                 |   6 +-
 sound/soc/blackfin/bf5xx-i2s.c                     |   6 +-
 sound/soc/blackfin/bf5xx-tdm-pcm.c                 |   6 +-
 sound/soc/blackfin/bf5xx-tdm.c                     |   6 +-
 sound/soc/blackfin/bf6xx-i2s.c                     |   6 +-
 sound/soc/blackfin/bfin-eval-adau1373.c            |   4 +-
 sound/soc/blackfin/bfin-eval-adau1701.c            |   4 +-
 sound/soc/blackfin/bfin-eval-adav80x.c             |   4 +-
 sound/soc/cirrus/edb93xx.c                         |   6 +-
 sound/soc/cirrus/ep93xx-ac97.c                     |   6 +-
 sound/soc/cirrus/ep93xx-i2s.c                      |   4 +-
 sound/soc/cirrus/ep93xx-pcm.c                      |   6 +-
 sound/soc/cirrus/simone.c                          |   6 +-
 sound/soc/cirrus/snappercl15.c                     |   6 +-
 sound/soc/codecs/88pm860x-codec.c                  |   6 +-
 sound/soc/codecs/ab8500-codec.c                    |   6 +-
 sound/soc/codecs/ac97.c                            |   6 +-
 sound/soc/codecs/ad1836.c                          |   6 +-
 sound/soc/codecs/ad193x.c                          |  12 +-
 sound/soc/codecs/ad1980.c                          |   6 +-
 sound/soc/codecs/ad73311.c                         |   4 +-
 sound/soc/codecs/adau1373.c                        |   6 +-
 sound/soc/codecs/adau1701.c                        |   6 +-
 sound/soc/codecs/adav80x.c                         |  16 +--
 sound/soc/codecs/ads117x.c                         |   6 +-
 sound/soc/codecs/ak4104.c                          |   4 +-
 sound/soc/codecs/ak4535.c                          |   6 +-
 sound/soc/codecs/ak4641.c                          |   6 +-
 sound/soc/codecs/ak4642.c                          |   6 +-
 sound/soc/codecs/ak4671.c                          |   6 +-
 sound/soc/codecs/alc5623.c                         |   6 +-
 sound/soc/codecs/alc5632.c                         |   6 +-
 sound/soc/codecs/cq93vc.c                          |   2 +-
 sound/soc/codecs/cs4271.c                          |  12 +-
 sound/soc/codecs/cs42l52.c                         |   2 +-
 sound/soc/codecs/cs42l73.c                         |   6 +-
 sound/soc/codecs/da7210.c                          |  12 +-
 sound/soc/codecs/da732x.c                          |   6 +-
 sound/soc/codecs/da9055.c                          |   6 +-
 sound/soc/codecs/dfbmcs320.c                       |   6 +-
 sound/soc/codecs/dmic.c                            |   6 +-
 sound/soc/codecs/isabelle.c                        |   6 +-
 sound/soc/codecs/jz4740.c                          |   6 +-
 sound/soc/codecs/lm4857.c                          |   6 +-
 sound/soc/codecs/lm49453.c                         |   6 +-
 sound/soc/codecs/max9768.c                         |   6 +-
 sound/soc/codecs/max98088.c                        |  16 +--
 sound/soc/codecs/max98095.c                        |   4 +-
 sound/soc/codecs/max9850.c                         |   6 +-
 sound/soc/codecs/max9877.c                         |   6 +-
 sound/soc/codecs/mc13783.c                         |   2 +-
 sound/soc/codecs/ml26124.c                         |   6 +-
 sound/soc/codecs/omap-hdmi.c                       |   6 +-
 sound/soc/codecs/pcm3008.c                         |   6 +-
 sound/soc/codecs/rt5631.c                          |   4 +-
 sound/soc/codecs/sgtl5000.c                        |   6 +-
 sound/soc/codecs/si476x.c                          |   6 +-
 sound/soc/codecs/sn95031.c                         |   6 +-
 sound/soc/codecs/ssm2602.c                         |  12 +-
 sound/soc/codecs/sta32x.c                          |   6 +-
 sound/soc/codecs/sta529.c                          |   6 +-
 sound/soc/codecs/stac9766.c                        |   6 +-
 sound/soc/codecs/tlv320aic32x4.c                   |   6 +-
 sound/soc/codecs/tlv320dac33.c                     |   6 +-
 sound/soc/codecs/tpa6130a2.c                       |   6 +-
 sound/soc/codecs/twl4030.c                         |   6 +-
 sound/soc/codecs/twl6040.c                         |   6 +-
 sound/soc/codecs/uda134x.c                         |   6 +-
 sound/soc/codecs/uda1380.c                         |   6 +-
 sound/soc/codecs/wl1273.c                          |   6 +-
 sound/soc/codecs/wm0010.c                          |   6 +-
 sound/soc/codecs/wm1250-ev1.c                      |   8 +-
 sound/soc/codecs/wm2000.c                          |   6 +-
 sound/soc/codecs/wm2200.c                          |   6 +-
 sound/soc/codecs/wm5100.c                          |   8 +-
 sound/soc/codecs/wm5102.c                          |   6 +-
 sound/soc/codecs/wm5110.c                          |   6 +-
 sound/soc/codecs/wm8350.c                          |   6 +-
 sound/soc/codecs/wm8400.c                          |   6 +-
 sound/soc/codecs/wm8510.c                          |  12 +-
 sound/soc/codecs/wm8523.c                          |   6 +-
 sound/soc/codecs/wm8711.c                          |  12 +-
 sound/soc/codecs/wm8727.c                          |   6 +-
 sound/soc/codecs/wm8728.c                          |  12 +-
 sound/soc/codecs/wm8731.c                          |  12 +-
 sound/soc/codecs/wm8737.c                          |  12 +-
 sound/soc/codecs/wm8741.c                          |   6 +-
 sound/soc/codecs/wm8750.c                          |  12 +-
 sound/soc/codecs/wm8753.c                          |  12 +-
 sound/soc/codecs/wm8770.c                          |   6 +-
 sound/soc/codecs/wm8776.c                          |  12 +-
 sound/soc/codecs/wm8782.c                          |   6 +-
 sound/soc/codecs/wm8804.c                          |  12 +-
 sound/soc/codecs/wm8900.c                          |  12 +-
 sound/soc/codecs/wm8903.c                          |   6 +-
 sound/soc/codecs/wm8904.c                          |   6 +-
 sound/soc/codecs/wm8940.c                          |   6 +-
 sound/soc/codecs/wm8955.c                          |   6 +-
 sound/soc/codecs/wm8960.c                          |   6 +-
 sound/soc/codecs/wm8961.c                          |   6 +-
 sound/soc/codecs/wm8962.c                          |   6 +-
 sound/soc/codecs/wm8971.c                          |   6 +-
 sound/soc/codecs/wm8974.c                          |   6 +-
 sound/soc/codecs/wm8978.c                          |   6 +-
 sound/soc/codecs/wm8983.c                          |  12 +-
 sound/soc/codecs/wm8985.c                          |  12 +-
 sound/soc/codecs/wm8988.c                          |  12 +-
 sound/soc/codecs/wm8990.c                          |   6 +-
 sound/soc/codecs/wm8991.c                          |   6 +-
 sound/soc/codecs/wm8993.c                          |   6 +-
 sound/soc/codecs/wm8994.c                          |   6 +-
 sound/soc/codecs/wm8995.c                          |  12 +-
 sound/soc/codecs/wm8996.c                          |   6 +-
 sound/soc/codecs/wm9081.c                          |   6 +-
 sound/soc/codecs/wm9090.c                          |   4 +-
 sound/soc/codecs/wm9705.c                          |   6 +-
 sound/soc/codecs/wm9712.c                          |   6 +-
 sound/soc/codecs/wm9713.c                          |   6 +-
 sound/soc/fsl/eukrea-tlv320.c                      |   6 +-
 sound/soc/fsl/fsl_dma.c                            |   6 +-
 sound/soc/fsl/fsl_ssi.c                            |   2 +-
 sound/soc/fsl/imx-audmux.c                         |   8 +-
 sound/soc/fsl/imx-mc13783.c                        |   6 +-
 sound/soc/fsl/imx-pcm-dma.c                        |   6 +-
 sound/soc/fsl/imx-pcm-fiq.c                        |   6 +-
 sound/soc/fsl/imx-sgtl5000.c                       |   6 +-
 sound/soc/fsl/imx-ssi.c                            |   4 +-
 sound/soc/fsl/mpc5200_psc_ac97.c                   |   8 +-
 sound/soc/fsl/mpc5200_psc_i2s.c                    |   8 +-
 sound/soc/fsl/mpc8610_hpcd.c                       |   4 +-
 sound/soc/fsl/mx27vis-aic32x4.c                    |   6 +-
 sound/soc/fsl/p1022_ds.c                           |   4 +-
 sound/soc/fsl/p1022_rdk.c                          |   4 +-
 sound/soc/fsl/pcm030-audio-fabric.c                |   4 +-
 sound/soc/jz4740/jz4740-i2s.c                      |   6 +-
 sound/soc/jz4740/jz4740-pcm.c                      |   6 +-
 sound/soc/jz4740/qi_lb60.c                         |   6 +-
 sound/soc/kirkwood/kirkwood-dma.c                  |   6 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |   6 +-
 sound/soc/kirkwood/kirkwood-openrd.c               |   6 +-
 sound/soc/kirkwood/kirkwood-t5325.c                |   6 +-
 sound/soc/mid-x86/mfld_machine.c                   |   6 +-
 sound/soc/mxs/mxs-pcm.c                            |   4 +-
 sound/soc/mxs/mxs-saif.c                           |   6 +-
 sound/soc/mxs/mxs-sgtl5000.c                       |   8 +-
 sound/soc/nuc900/nuc900-ac97.c                     |   6 +-
 sound/soc/nuc900/nuc900-pcm.c                      |   6 +-
 sound/soc/omap/ams-delta.c                         |   6 +-
 sound/soc/omap/mcbsp.c                             |   6 +-
 sound/soc/omap/mcbsp.h                             |   4 +-
 sound/soc/omap/omap-abe-twl6040.c                  |   6 +-
 sound/soc/omap/omap-dmic.c                         |   6 +-
 sound/soc/omap/omap-hdmi-card.c                    |   6 +-
 sound/soc/omap/omap-hdmi.c                         |   6 +-
 sound/soc/omap/omap-mcbsp.c                        |   6 +-
 sound/soc/omap/omap-mcpdm.c                        |   6 +-
 sound/soc/omap/omap-pcm.c                          |   6 +-
 sound/soc/omap/omap-twl4030.c                      |   6 +-
 sound/soc/pxa/brownstone.c                         |   6 +-
 sound/soc/pxa/corgi.c                              |   6 +-
 sound/soc/pxa/e740_wm9705.c                        |   6 +-
 sound/soc/pxa/e750_wm9705.c                        |   6 +-
 sound/soc/pxa/e800_wm9712.c                        |   6 +-
 sound/soc/pxa/hx4700.c                             |   6 +-
 sound/soc/pxa/imote2.c                             |   6 +-
 sound/soc/pxa/mioa701_wm9713.c                     |   6 +-
 sound/soc/pxa/mmp-pcm.c                            |   6 +-
 sound/soc/pxa/mmp-sspa.c                           |   6 +-
 sound/soc/pxa/palm27x.c                            |   4 +-
 sound/soc/pxa/poodle.c                             |   6 +-
 sound/soc/pxa/pxa-ssp.c                            |   6 +-
 sound/soc/pxa/pxa2xx-ac97.c                        |   8 +-
 sound/soc/pxa/pxa2xx-i2s.c                         |   4 +-
 sound/soc/pxa/pxa2xx-pcm.c                         |   6 +-
 sound/soc/pxa/tosa.c                               |   6 +-
 sound/soc/pxa/ttc-dkb.c                            |   6 +-
 sound/soc/s6000/s6000-i2s.c                        |   6 +-
 sound/soc/s6000/s6000-pcm.c                        |   6 +-
 sound/soc/samsung/ac97.c                           |   6 +-
 sound/soc/samsung/bells.c                          |   6 +-
 sound/soc/samsung/dma.c                            |   6 +-
 sound/soc/samsung/i2s.c                            |   9 +-
 sound/soc/samsung/idma.c                           |   6 +-
 sound/soc/samsung/littlemill.c                     |   6 +-
 sound/soc/samsung/lowland.c                        |   6 +-
 sound/soc/samsung/pcm.c                            |   6 +-
 sound/soc/samsung/s3c2412-i2s.c                    |   6 +-
 sound/soc/samsung/s3c24xx-i2s.c                    |   6 +-
 sound/soc/samsung/s3c24xx_simtec.c                 |   4 +-
 sound/soc/samsung/s3c24xx_simtec_hermes.c          |   4 +-
 sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c     |   4 +-
 sound/soc/samsung/smdk_wm8580pcm.c                 |   6 +-
 sound/soc/samsung/smdk_wm8994.c                    |   6 +-
 sound/soc/samsung/smdk_wm8994pcm.c                 |   6 +-
 sound/soc/samsung/spdif.c                          |   6 +-
 sound/soc/samsung/speyside.c                       |   6 +-
 sound/soc/samsung/tobermory.c                      |   6 +-
 sound/soc/sh/dma-sh7760.c                          |   6 +-
 sound/soc/sh/hac.c                                 |   6 +-
 sound/soc/sh/siu_dai.c                             |   6 +-
 sound/soc/sh/ssi.c                                 |   6 +-
 sound/soc/soc-core.c                               |   2 +-
 sound/soc/soc-utils.c                              |   6 +-
 sound/soc/spear/spear_pcm.c                        |   6 +-
 sound/soc/tegra/tegra20_das.c                      |   8 +-
 sound/soc/tegra/tegra20_i2s.c                      |  10 +-
 sound/soc/tegra/tegra20_spdif.c                    |   8 +-
 sound/soc/tegra/tegra30_ahub.c                     |  14 +--
 sound/soc/tegra/tegra30_i2s.c                      |  10 +-
 sound/soc/tegra/tegra_alc5632.c                    |   8 +-
 sound/soc/tegra/tegra_pcm.c                        |   4 +-
 sound/soc/tegra/tegra_wm8753.c                     |   8 +-
 sound/soc/tegra/tegra_wm8903.c                     |   8 +-
 sound/soc/tegra/trimslice.c                        |   8 +-
 sound/soc/txx9/txx9aclc-ac97.c                     |   6 +-
 sound/soc/txx9/txx9aclc.c                          |   6 +-
 sound/soc/ux500/mop500.c                           |   8 +-
 sound/soc/ux500/ux500_msp_dai.c                    |   4 +-
 sound/soc/ux500/ux500_pcm.c                        |   6 +-
 sound/sparc/amd7930.c                              |  10 +-
 sound/sparc/cs4231.c                               |  30 ++---
 sound/sparc/dbri.c                                 |  24 ++--
 sound/spi/at73c213.c                               |  18 +--
 sound/usb/6fire/chip.c                             |   2 +-
 sound/usb/6fire/comm.c                             |   2 +-
 sound/usb/6fire/comm.h                             |   2 +-
 sound/usb/6fire/control.c                          |   8 +-
 sound/usb/6fire/control.h                          |   2 +-
 sound/usb/6fire/firmware.h                         |   2 +-
 sound/usb/6fire/midi.c                             |   2 +-
 sound/usb/6fire/midi.h                             |   2 +-
 sound/usb/6fire/pcm.c                              |   4 +-
 sound/usb/6fire/pcm.h                              |   2 +-
 sound/usb/caiaq/control.c                          |   6 +-
 sound/usb/caiaq/device.c                           |   6 +-
 2942 files changed, 11645 insertions(+), 12116 deletions(-)
 delete mode 100644 drivers/pci/hotplug.c

-- 
1.8.0

