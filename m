Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0IUETL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:19:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39300 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0IUETE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=f+HwPODGmn8TPlONFD8Q34yspQzCqwmmAFjyTmML4j4JNupDciwszYrcvyvRnrfETr
         C7kzpnWkzrdVpN/fZfEg+cMKIVlbeV+h997sljn4geVcGyVbP0FVibu8QJynLa1G7Uda
         P5r7+fKLUftgqk6/zG78xnfW13eW5IZFMbPhU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5DUpdate-broken-web-addresses-in-the-kernel?=
Date: Mon, 20 Sep 2010 21:18:44 -0700
Message-Id: <1285042724-19135-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find a patch containing updates to broken web addresses in the kernel.
Some were easy to piece together, but some were knowhere to be found..Keep in mind this was 
just a grep for "http", not sure how many other protocol's in there are working or not..
Thanks for the replies, if you see anything that I might have missed let me know...
(as for the signed-off's not sure if it's the best way, but figured if you replied
with a correct link, then why not!!).  

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Dimitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Pfaff <blp@cs.stanford.edu>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>

---
 arch/alpha/Kconfig                                 |    4 +-
 arch/alpha/kernel/sys_sio.c                        |    2 +-
 arch/arm/Kconfig                                   |    4 +-
 arch/arm/common/icst.c                             |    2 +-
 arch/arm/include/asm/hardware/icst.h               |    2 +-
 arch/arm/mach-at91/Kconfig                         |    6 ++--
 arch/arm/mach-footbridge/Kconfig                   |    2 +-
 arch/arm/mach-omap1/Kconfig                        |    6 ++--
 arch/arm/mach-pxa/am200epd.c                       |    2 +-
 arch/arm/mach-pxa/am300epd.c                       |    2 +-
 arch/arm/mach-pxa/idp.c                            |    2 +-
 arch/arm/mach-pxa/include/mach/idp.h               |    2 +-
 arch/arm/mach-s3c2440/mach-at2440evb.c             |    2 +-
 arch/arm/mach-sa1100/Kconfig                       |    8 ++--
 arch/arm/mach-sa1100/cpu-sa1100.c                  |    2 +-
 arch/arm/mm/Kconfig                                |    2 +-
 arch/arm/mm/proc-xscale.S                          |    2 +-
 arch/arm/nwfpe/milieu.h                            |    4 +-
 arch/arm/nwfpe/softfloat-macros                    |    4 +-
 arch/arm/nwfpe/softfloat-specialize                |    4 +-
 arch/arm/nwfpe/softfloat.c                         |    4 +-
 arch/arm/nwfpe/softfloat.h                         |    4 +-
 arch/arm/plat-samsung/include/plat/adc.h           |    2 +-
 arch/avr32/Kconfig                                 |    2 +-
 arch/h8300/Kconfig.cpu                             |   14 ++++----
 arch/h8300/README                                  |   12 +++---
 arch/ia64/include/asm/machvec_sn2.h                |    2 +-
 arch/ia64/include/asm/numa.h                       |    2 +-
 arch/ia64/kernel/acpi.c                            |    2 +-
 arch/ia64/lib/idiv32.S                             |    2 +-
 arch/ia64/lib/idiv64.S                             |    2 +-
 arch/ia64/sn/kernel/setup.c                        |    2 +-
 arch/ia64/sn/kernel/sn2/timer_interrupt.c          |    4 +--
 arch/m32r/Kconfig                                  |    2 +-
 arch/m68k/Kconfig                                  |    2 +-
 arch/m68k/mac/macboing.c                           |    2 +-
 arch/m68k/mac/via.c                                |    7 +---
 arch/m68k/q40/README                               |    6 ++--
 arch/mips/Kconfig                                  |    2 +-
 arch/mips/math-emu/cp1emu.c                        |    2 +-
 arch/mips/math-emu/dp_add.c                        |    2 +-
 arch/mips/math-emu/dp_cmp.c                        |    2 +-
 arch/mips/math-emu/dp_div.c                        |    2 +-
 arch/mips/math-emu/dp_fint.c                       |    2 +-
 arch/mips/math-emu/dp_flong.c                      |    2 +-
 arch/mips/math-emu/dp_frexp.c                      |    2 +-
 arch/mips/math-emu/dp_fsp.c                        |    2 +-
 arch/mips/math-emu/dp_logb.c                       |    2 +-
 arch/mips/math-emu/dp_modf.c                       |    2 +-
 arch/mips/math-emu/dp_mul.c                        |    2 +-
 arch/mips/math-emu/dp_scalb.c                      |    2 +-
 arch/mips/math-emu/dp_simple.c                     |    2 +-
 arch/mips/math-emu/dp_sqrt.c                       |    2 +-
 arch/mips/math-emu/dp_sub.c                        |    2 +-
 arch/mips/math-emu/dp_tint.c                       |    2 +-
 arch/mips/math-emu/dp_tlong.c                      |    2 +-
 arch/mips/math-emu/ieee754.c                       |    2 +-
 arch/mips/math-emu/ieee754.h                       |    2 +-
 arch/mips/math-emu/ieee754d.c                      |    2 +-
 arch/mips/math-emu/ieee754dp.c                     |    2 +-
 arch/mips/math-emu/ieee754dp.h                     |    2 +-
 arch/mips/math-emu/ieee754int.h                    |    2 +-
 arch/mips/math-emu/ieee754m.c                      |    2 +-
 arch/mips/math-emu/ieee754sp.c                     |    2 +-
 arch/mips/math-emu/ieee754sp.h                     |    2 +-
 arch/mips/math-emu/ieee754xcpt.c                   |    2 +-
 arch/mips/math-emu/sp_add.c                        |    2 +-
 arch/mips/math-emu/sp_cmp.c                        |    2 +-
 arch/mips/math-emu/sp_div.c                        |    2 +-
 arch/mips/math-emu/sp_fdp.c                        |    2 +-
 arch/mips/math-emu/sp_fint.c                       |    2 +-
 arch/mips/math-emu/sp_flong.c                      |    2 +-
 arch/mips/math-emu/sp_frexp.c                      |    2 +-
 arch/mips/math-emu/sp_logb.c                       |    2 +-
 arch/mips/math-emu/sp_modf.c                       |    2 +-
 arch/mips/math-emu/sp_mul.c                        |    2 +-
 arch/mips/math-emu/sp_scalb.c                      |    2 +-
 arch/mips/math-emu/sp_simple.c                     |    2 +-
 arch/mips/math-emu/sp_sqrt.c                       |    2 +-
 arch/mips/math-emu/sp_sub.c                        |    2 +-
 arch/mips/math-emu/sp_tint.c                       |    2 +-
 arch/mips/math-emu/sp_tlong.c                      |    2 +-
 arch/powerpc/include/asm/hydra.h                   |    2 +-
 arch/sh/cchips/Kconfig                             |    2 +-
 arch/um/os-Linux/start_up.c                        |    2 +-
 arch/x86/kernel/apm_32.c                           |    2 +-
 arch/x86/kernel/cpu/amd.c                          |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c          |    2 +-
 arch/x86/kernel/microcode_core.c                   |    2 +-
 arch/x86/kernel/microcode_intel.c                  |    2 +-
 arch/x86/math-emu/README                           |    4 --
 drivers/ata/pata_it821x.c                          |    2 +-
 drivers/atm/Kconfig                                |    2 +-
 drivers/block/Kconfig                              |    2 +-
 drivers/char/agp/Kconfig                           |    2 +-
 drivers/char/agp/i460-agp.c                        |    2 +-
 drivers/char/apm-emulation.c                       |    2 +-
 drivers/char/ipmi/ipmi_bt_sm.c                     |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |    3 +-
 drivers/char/n_r3964.c                             |    2 +-
 drivers/char/pcmcia/Kconfig                        |    4 +-
 drivers/char/tpm/Kconfig                           |    2 +-
 drivers/char/tpm/tpm_infineon.c                    |    2 +-
 drivers/edac/edac_device_sysfs.c                   |    2 +-
 drivers/edac/i82443bxgx_edac.c                     |    2 +-
 drivers/edac/i82975x_edac.c                        |    2 +-
 drivers/firmware/Kconfig                           |    2 +-
 drivers/firmware/edd.c                             |    2 +-
 drivers/firmware/pcdp.h                            |    3 +-
 drivers/gpu/drm/README.drm                         |    2 +-
 drivers/gpu/drm/drm_modes.c                        |    2 +-
 drivers/hwmon/adcxx.c                              |    2 +-
 drivers/hwmon/adm1025.c                            |    2 +-
 drivers/hwmon/adm1026.c                            |    2 +-
 drivers/hwmon/f75375s.c                            |    4 +-
 drivers/hwmon/g760a.c                              |    2 +-
 drivers/hwmon/hwmon-vid.c                          |    8 ++--
 drivers/ide/hpt366.c                               |    2 +-
 drivers/ide/ht6560b.c                              |    2 -
 drivers/ide/sgiioc4.c                              |    2 +-
 drivers/infiniband/Kconfig                         |    4 +-
 drivers/infiniband/hw/cxgb3/Kconfig                |    2 +-
 drivers/infiniband/hw/cxgb4/Kconfig                |    2 +-
 drivers/infiniband/ulp/iser/Kconfig                |    2 +-
 drivers/input/joystick/gamecon.c                   |    3 +-
 drivers/input/misc/cm109.c                         |    6 ++--
 drivers/input/mouse/Kconfig                        |    5 +--
 drivers/input/mouse/touchkit_ps2.c                 |    2 +-
 drivers/input/touchscreen/mk712.c                  |    2 +-
 drivers/isdn/i4l/isdn_audio.c                      |    2 +-
 drivers/isdn/i4l/isdn_net.c                        |    2 +-
 drivers/macintosh/therm_adt746x.c                  |    4 +-
 drivers/media/IR/keymaps/rc-manli.c                |    1 -
 drivers/media/IR/keymaps/rc-rc5-tv.c               |    2 +-
 drivers/media/dvb/frontends/mt312.c                |    5 ++-
 drivers/media/dvb/frontends/mt312.h                |    5 ++-
 drivers/media/dvb/pluto2/pluto2.c                  |    2 +-
 drivers/media/dvb/ttpci/av7110.c                   |   10 +----
 drivers/media/dvb/ttpci/av7110_av.c                |    2 +-
 drivers/media/dvb/ttpci/av7110_ca.c                |    2 +-
 drivers/media/dvb/ttpci/av7110_hw.c                |    2 +-
 drivers/media/dvb/ttpci/av7110_v4l.c               |    2 +-
 drivers/media/dvb/ttpci/budget-av.c                |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c                |    2 +-
 drivers/media/dvb/ttpci/budget-core.c              |    2 +-
 drivers/media/dvb/ttpci/budget-patch.c             |    2 +-
 drivers/media/dvb/ttpci/budget.c                   |    2 +-
 drivers/media/radio/Kconfig                        |    4 +-
 drivers/media/radio/radio-aztech.c                 |    3 --
 drivers/media/radio/radio-maxiradio.c              |    2 +-
 drivers/media/radio/radio-typhoon.c                |    2 -
 drivers/media/video/Kconfig                        |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c             |    2 +-
 drivers/media/video/cafe_ccic.c                    |    2 +-
 drivers/media/video/cx18/cx18-cards.c              |    2 +-
 drivers/media/video/cx23885/cx23885-417.c          |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c          |    2 +-
 drivers/media/video/gspca/gspca.c                  |    2 +-
 drivers/media/video/ivtv/ivtv-cards.c              |    2 +-
 drivers/media/video/mxb.c                          |    2 +-
 drivers/media/video/pwc/philips.txt                |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c        |    4 +-
 drivers/media/video/sn9c102/sn9c102_pas202bcb.c    |    1 -
 drivers/misc/Kconfig                               |    4 +-
 drivers/mtd/Kconfig                                |    4 +-
 drivers/mtd/chips/cfi_cmdset_0002.c                |    3 +-
 drivers/mtd/devices/lart.c                         |    2 +-
 drivers/mtd/ftl.c                                  |    2 +-
 drivers/mtd/maps/Kconfig                           |   15 ++++----
 drivers/mtd/maps/dilnetpc.c                        |    3 +-
 drivers/mtd/maps/pismo.c                           |    2 +-
 drivers/mtd/maps/sc520cdp.c                        |    2 +-
 drivers/mtd/nand/cafe_nand.c                       |    2 +-
 drivers/mtd/rfd_ftl.c                              |    2 +-
 drivers/net/8139too.c                              |    2 +-
 drivers/net/Kconfig                                |   37 ++++++++------------
 drivers/net/acenic.c                               |    2 +-
 drivers/net/appletalk/Kconfig                      |    6 ++--
 drivers/net/atp.c                                  |    2 +-
 drivers/net/epic100.c                              |    7 ++--
 drivers/net/fealnx.c                               |    2 +-
 drivers/net/hamachi.c                              |    3 --
 drivers/net/hamradio/Kconfig                       |    2 +-
 drivers/net/ibmlana.c                              |    2 +-
 drivers/net/irda/donauboe.h                        |    2 +-
 drivers/net/irda/ma600-sir.c                       |    4 +-
 drivers/net/lne390.c                               |    4 +-
 drivers/net/natsemi.c                              |   10 ++----
 drivers/net/pci-skeleton.c                         |    4 +-
 drivers/net/pcmcia/3c574_cs.c                      |    2 +-
 drivers/net/sc92031.c                              |    2 +-
 drivers/net/sis900.h                               |    2 +-
 drivers/net/starfire.c                             |    6 +--
 drivers/net/sundance.c                             |    5 +--
 drivers/net/tlan.c                                 |    2 +-
 drivers/net/tokenring/Kconfig                      |    3 +-
 drivers/net/tokenring/tms380tr.c                   |    2 +-
 drivers/net/tulip/Kconfig                          |    2 +-
 drivers/net/usb/plusb.c                            |    2 +-
 drivers/net/wan/Kconfig                            |   14 ++++----
 drivers/net/wan/cosa.c                             |    3 +-
 drivers/net/wan/farsync.c                          |    4 +--
 drivers/net/wan/sbni.c                             |    2 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |    2 +-
 drivers/net/wireless/ath/ath5k/reg.h               |    8 +---
 drivers/net/wireless/hostap/hostap_cs.c            |    3 +-
 drivers/net/wireless/orinoco/main.c                |    2 +-
 drivers/net/wireless/p54/Kconfig                   |    6 ++--
 drivers/net/wireless/prism54/islpci_hotplug.c      |    2 +-
 drivers/net/yellowfin.c                            |    3 +-
 drivers/parisc/README.dino                         |    3 +-
 drivers/parport/Kconfig                            |    4 +-
 drivers/pci/quirks.c                               |    4 +-
 drivers/pcmcia/yenta_socket.c                      |    2 +-
 drivers/pnp/pnpbios/proc.c                         |    1 -
 drivers/scsi/Kconfig                               |   14 ++++----
 drivers/scsi/arm/Kconfig                           |    2 +-
 drivers/scsi/ibmmca.c                              |    2 -
 drivers/scsi/scsi_debug.c                          |    4 +-
 drivers/serial/8250.c                              |    2 +-
 drivers/serial/altera_uart.c                       |    2 +-
 drivers/serial/bfin_sport_uart.c                   |    2 +-
 drivers/serial/bfin_sport_uart.h                   |    2 +-
 drivers/serial/sn_console.c                        |    2 +-
 drivers/serial/uartlite.c                          |    2 +-
 drivers/staging/asus_oled/README                   |    2 +-
 drivers/staging/asus_oled/asus_oled.c              |    2 +-
 .../comedi/drivers/addi-data/APCI1710_82x54.c      |    2 +-
 .../comedi/drivers/addi-data/APCI1710_82x54.h      |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Chrono.c     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Dig_io.c     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Dig_io.h     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_INCCPT.c     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_INCCPT.h     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.c    |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.h    |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Pwm.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Pwm.h        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ssi.h        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.h        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ttl.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ttl.h        |    2 +-
 .../comedi/drivers/addi-data/addi_amcc_S5920.c     |    2 +-
 .../comedi/drivers/addi-data/addi_amcc_S5920.h     |    2 +-
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |    2 +-
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |    2 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.h       |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci16xx.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.h      |    2 +-
 drivers/staging/comedi/drivers/c6xdigio.c          |    2 -
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    2 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |    2 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |    2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |    2 +-
 drivers/staging/comedi/drivers/pcl711.c            |    2 +-
 drivers/staging/comedi/drivers/plx9080.h           |    2 +-
 drivers/staging/comedi/drivers/rtd520.c            |    2 +-
 drivers/staging/go7007/go7007.txt                  |   10 +++---
 drivers/staging/quickstart/quickstart.c            |    5 +--
 drivers/telephony/Kconfig                          |    2 +-
 drivers/telephony/ixj.c                            |    2 +-
 drivers/telephony/ixj.h                            |    2 +-
 drivers/uio/Kconfig                                |    2 +-
 drivers/usb/serial/Kconfig                         |    6 +--
 drivers/usb/serial/cypress_m8.c                    |    2 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |   16 ++++----
 drivers/usb/serial/keyspan.c                       |    2 -
 drivers/usb/serial/keyspan.h                       |    2 -
 drivers/usb/serial/mct_u232.h                      |    8 ++--
 drivers/usb/storage/Kconfig                        |    2 +-
 drivers/usb/storage/unusual_devs.h                 |    2 +-
 drivers/video/Kconfig                              |   10 +++---
 drivers/video/arcfb.c                              |    1 -
 drivers/video/epson1355fb.c                        |    2 +-
 drivers/video/fbcvt.c                              |    2 +-
 drivers/video/hecubafb.c                           |    2 +-
 drivers/video/macfb.c                              |    2 +-
 drivers/video/metronomefb.c                        |    2 +-
 drivers/video/s3fb.c                               |    2 -
 drivers/video/svgalib.c                            |    2 +-
 drivers/video/vga16fb.c                            |    1 -
 drivers/video/vgastate.c                           |    2 +-
 drivers/video/vt8623fb.c                           |    1 -
 drivers/watchdog/pcwd.c                            |    1 -
 firmware/keyspan_pda/keyspan_pda.S                 |    2 +-
 firmware/keyspan_pda/xircom_pgs.S                  |    2 +-
 fs/hostfs/hostfs.h                                 |    7 +---
 fs/ncpfs/Kconfig                                   |    3 +-
 fs/nls/Kconfig                                     |    4 +-
 fs/nls/nls_base.c                                  |    2 +-
 fs/nls/nls_euc-jp.c                                |    2 +-
 fs/partitions/ldm.c                                |    2 +-
 fs/partitions/ldm.h                                |    2 +-
 fs/reiserfs/Kconfig                                |    4 +-
 fs/reiserfs/README                                 |    2 +-
 fs/reiserfs/procfs.c                               |    2 -
 include/crypto/b128ops.h                           |    2 +-
 include/crypto/gf128mul.h                          |    6 ++--
 include/linux/edd.h                                |    5 ++-
 include/linux/fdreg.h                              |    2 +-
 include/linux/if_infiniband.h                      |    2 +-
 include/linux/ixjuser.h                            |    2 +-
 include/linux/mtd/pismo.h                          |    2 +-
 include/linux/n_r3964.h                            |    2 +-
 include/scsi/sg.h                                  |   10 +++---
 include/video/vga.h                                |    2 +-
 net/ax25/Kconfig                                   |    8 ++--
 net/ipv4/Kconfig                                   |   10 +++---
 net/ipv4/cipso_ipv4.c                              |    2 +-
 net/ipv4/fib_trie.c                                |    2 +-
 net/ipv4/netfilter/Kconfig                         |    2 +-
 net/ipv4/tcp_illinois.c                            |    4 +-
 net/ipv4/tcp_input.c                               |    4 +-
 net/ipv4/tcp_lp.c                                  |    2 +-
 net/ipv4/tcp_veno.c                                |    2 +-
 net/ipv4/tcp_westwood.c                            |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |    4 +-
 sound/isa/Kconfig                                  |    2 +-
 sound/isa/cmi8330.c                                |    1 -
 sound/oss/Kconfig                                  |    4 +-
 sound/oss/ac97_codec.c                             |    5 +--
 sound/pci/ac97/ac97_patch.c                        |    2 +-
 sound/pci/ens1370.c                                |    2 +-
 sound/pci/intel8x0.c                               |    2 +-
 sound/pci/nm256/nm256.c                            |    2 +-
 353 files changed, 471 insertions(+), 558 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index b9647bb..8da39ce 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -219,7 +219,7 @@ config ALPHA_LX164
 	bool "LX164"
 	help
 	  A technical overview of this board is available at
-	  <http://www.unix-ag.org/Linux-Alpha/Architectures/LX164.html>.
+	  <http://www.alphalinux.org/>.
 
 config ALPHA_LYNX
 	bool "Lynx"
@@ -483,7 +483,7 @@ config ALPHA_AVANTI
 	help
 	  Avanti AS 200, AS 205, AS 250, AS 255, AS 300, and AS 400-based
 	  Alphas. Info at
-	  <http://www.unix-ag.org/Linux-Alpha/Architectures/Avanti.html>.
+	  <http://www.alphalinux.org/>.
 
 config ALPHA_BROKEN_IRQ_MASK
 	bool
diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
index 85b4aea..c5051aa 100644
--- a/arch/alpha/kernel/sys_sio.c
+++ b/arch/alpha/kernel/sys_sio.c
@@ -154,7 +154,7 @@ noname_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 	 * bridge (PIRQ0-PIRQ3).  The table below is based on
 	 * information available at:
 	 *
-	 *   http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt
+	 *  http://web.archive.org/web/*/http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt 
 	 *
 	 * I have no information on the Avanti interrupt routing, but
 	 * the routing seems to be identical to the Noname except
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 553b7cf..c562c68 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -647,7 +647,7 @@ config ARCH_S3C2410
 	select HAVE_S3C2410_I2C
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
-	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
+	  BAST (<http://www.simtec.co.uk/products/EB110ATX/>), the IPAQ 1940 or
 	  the Samsung SMDK2410 development board (and derivatives).
 
 	  Note, the S3C2416 and the S3C2450 are so close that they even share
@@ -1162,7 +1162,7 @@ config SMP
 
 	  See also <file:Documentation/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
-	  <http://www.linuxdoc.org/docs.html#howto>.
+	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
 	  If you don't know what to do here, say N.
 
diff --git a/arch/arm/common/icst.c b/arch/arm/common/icst.c
index 9a7f09c..2dc6da70 100644
--- a/arch/arm/common/icst.c
+++ b/arch/arm/common/icst.c
@@ -8,7 +8,7 @@
  * published by the Free Software Foundation.
  *
  *  Support functions for calculating clocks/divisors for the ICST307
- *  clock generators.  See http://www.icst.com/ for more information
+ *  clock generators.  See http://www.idt.com/ for more information
  *  on these devices.
  *
  *  This is an almost identical implementation to the ICST525 clock generator.
diff --git a/arch/arm/include/asm/hardware/icst.h b/arch/arm/include/asm/hardware/icst.h
index 10382a3..794220b 100644
--- a/arch/arm/include/asm/hardware/icst.h
+++ b/arch/arm/include/asm/hardware/icst.h
@@ -8,7 +8,7 @@
  * published by the Free Software Foundation.
  *
  *  Support functions for calculating clocks/divisors for the ICST
- *  clock generators.  See http://www.icst.com/ for more information
+ *  clock generators.  See http://www.idt.com/ for more information
  *  on these devices.
  */
 #ifndef ASMARM_HARDWARE_ICST_H
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 939bccd..c0bcfb8 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -105,7 +105,7 @@ config MACH_ONEARM
 	bool "Ajeco 1ARM Single Board Computer"
 	help
 	  Select this if you are using Ajeco's 1ARM Single Board Computer.
-	  <http://www.ajeco.fi/products.htm>
+	  <http://www.ajeco.fi/index.php?language=fin>
 
 config ARCH_AT91RM9200DK
 	bool "Atmel AT91RM9200-DK Development board"
@@ -137,7 +137,7 @@ config MACH_CARMEVA
 	bool "Conitec ARM&EVA"
 	help
 	  Select this if you are using Conitec's AT91RM9200-MCU-Module.
-	  <http://www.conitec.net/english/linuxboard.htm>
+	  <http://www.conitec.net/english/linuxboard.php>
 
 config MACH_ATEB9200
 	bool "Embest ATEB9200"
@@ -149,7 +149,7 @@ config MACH_KB9200
 	bool "KwikByte KB920x"
 	help
 	  Select this if you are using KwikByte's KB920x board.
-	  <http://kwikbyte.com/KB9202_description_new.htm>
+	  <http://www.kwikbyte.com/KB9202.html>
 
 config MACH_PICOTUX2XX
 	bool "picotux 200"
diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index bdd2579..7654764 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -29,7 +29,7 @@ config ARCH_PERSONAL_SERVER
 	  There are no product plans beyond the current research
 	  prototypes at this time.  Information is available at:
 
-	  <http://www.crl.hpl.hp.com/projects/personalserver/>
+	  <http://web.archive.org/web/*/http://www.crl.hpl.hp.com/projects/personalserver/>
 
 	  If you have any questions or comments about the  Compaq Personal
 	  Server, send e-mail to <skiff@crl.dec.com>.
diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 3b02d3b..4ec4c2e 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -119,8 +119,8 @@ config MACH_OMAP_PALMZ71
 	help
 	 Support for the Palm Zire71 PDA. To boot the kernel,
 	 you'll need a PalmOS compatible bootloader; check out
-	 http://hackndev.com/palm/z71 for more information.
-	 Say Y here if you have such a PDA, say N otherwise.
+	 http://web.archive.org/web/*/http://old.hackndev.com/palm/z71
+	 for more information. Say Y here if you have such a PDA, say N otherwise.
 
 config MACH_OMAP_PALMTT
 	bool "Palm Tungsten|T"
@@ -128,7 +128,7 @@ config MACH_OMAP_PALMTT
 	help
 	  Support for the Palm Tungsten|T PDA. To boot the kernel, you'll
 	  need a PalmOS compatible bootloader (Garux); check out
-	  http://www.hackndev.com/palm/tt/ for more information.
+	  http://garux.sourceforge.net/ for more information.
 	  Say Y here if you have this PDA model, say N otherwise.
 
 config MACH_SX1
diff --git a/arch/arm/mach-pxa/am200epd.c b/arch/arm/mach-pxa/am200epd.c
index 3499fad..0fd6a08 100644
--- a/arch/arm/mach-pxa/am200epd.c
+++ b/arch/arm/mach-pxa/am200epd.c
@@ -10,7 +10,7 @@
  * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
  *
  * This work was made possible by help and equipment support from E-Ink
- * Corporation. http://support.eink.com/community
+ * Corporation. http://www.support.eink.com/
  *
  * This driver is written to be used with the Metronome display controller.
  * on the AM200 EPD prototype kit/development kit with an E-Ink 800x600
diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
index 993d75e..01aa021 100644
--- a/arch/arm/mach-pxa/am300epd.c
+++ b/arch/arm/mach-pxa/am300epd.c
@@ -8,7 +8,7 @@
  * more details.
  *
  * This work was made possible by help and equipment support from E-Ink
- * Corporation. http://support.eink.com/community
+ * Corporation. http://www.support.eink.com/
  *
  * This driver is written to be used with the Broadsheet display controller.
  * on the AM300 EPD prototype kit/development kit with an E-Ink 800x600
diff --git a/arch/arm/mach-pxa/idp.c b/arch/arm/mach-pxa/idp.c
index bc78c4d..20779c1 100644
--- a/arch/arm/mach-pxa/idp.c
+++ b/arch/arm/mach-pxa/idp.c
@@ -11,7 +11,7 @@
  *              Initial code
  *
  *  2005-02-15: Cliff Brake <cliff.brake@gmail.com>
- *  		<http://www.vibren.com> <http://bec-systems.com>
+ *  		<http://www.bsquare.com/> <http://bec-systems.com>
  *              Updated for 2.6 kernel
  *
  */
diff --git a/arch/arm/mach-pxa/include/mach/idp.h b/arch/arm/mach-pxa/include/mach/idp.h
index 5eff96f..b3fc966 100644
--- a/arch/arm/mach-pxa/include/mach/idp.h
+++ b/arch/arm/mach-pxa/include/mach/idp.h
@@ -11,7 +11,7 @@
  *             Initial code
  *
  * 2005-02-15: Cliff Brake <cliff.brake@gmail.com>
- *             <http://www.vibren.com> <http://bec-systems.com>
+ *             <http://www.bsquare.com/> <http://bec-systems.com>
  *             Changes for 2.6 kernel.
  */
 
diff --git a/arch/arm/mach-s3c2440/mach-at2440evb.c b/arch/arm/mach-s3c2440/mach-at2440evb.c
index 8472579..67b6ba0 100644
--- a/arch/arm/mach-s3c2440/mach-at2440evb.c
+++ b/arch/arm/mach-s3c2440/mach-at2440evb.c
@@ -5,7 +5,7 @@
  *      and modifications by SBZ <sbz@spgui.org> and
  *      Weibing <http://weibing.blogbus.com>
  *
- * For product information, visit http://www.arm9e.com/
+ * For product information, visit http://www.arm.com/
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/arm/mach-sa1100/Kconfig b/arch/arm/mach-sa1100/Kconfig
index fd4c52b..253f194 100644
--- a/arch/arm/mach-sa1100/Kconfig
+++ b/arch/arm/mach-sa1100/Kconfig
@@ -90,8 +90,8 @@ config SA1100_JORNADA720
 	# FIXME: select CPU_FREQ_SA11x0
 	help
 	  Say Y here if you want to build a kernel for the HP Jornada 720
-	  handheld computer.  See <http://www.hp.com/jornada/products/720>
-	  for details.
+	  handheld computer. For details see: 
+	  <http://h10025.www1.hp.com/ewfrf/wc/product?product=61677&cc=us&lc=en&dlc=en&product=61677#> 
 
 config SA1100_JORNADA720_SSP
 	bool "HP Jornada 720 Extended SSP driver"
@@ -108,7 +108,7 @@ config SA1100_HACKKIT
 	select CPU_FREQ_SA1100
 	help
 	  Say Y here to support the HackKit Core CPU Board
-	  <http://hackkit.eletztrick.de>;
+	  <http://web.archive.org/web/*/http://hackkit.eletztrick.de>;
 
 config SA1100_LART
 	bool "LART"
@@ -145,7 +145,7 @@ config SA1100_SIMPAD
 	  FLASH. The SL4 version got 64 MB RAM and 32 MB FLASH and a
 	  PCMCIA-Slot. The version for the Germany Telecom (DTAG) is the same
 	  like CL4 in additional it has a PCMCIA-Slot. For more information
-	  visit <http://www.my-siemens.com/> or <http://www.siemens.ch/>.
+	  visit <http://www.siemens.ch/>.
 
 config SA1100_SSP
 	tristate "Generic PIO SSP"
diff --git a/arch/arm/mach-sa1100/cpu-sa1100.c b/arch/arm/mach-sa1100/cpu-sa1100.c
index ef81787..c0a13ef 100644
--- a/arch/arm/mach-sa1100/cpu-sa1100.c
+++ b/arch/arm/mach-sa1100/cpu-sa1100.c
@@ -13,7 +13,7 @@
  * This software has been developed while working on the LART
  * computing board (http://www.lartmaker.nl/), which is
  * sponsored by the Mobile Multi-media Communications
- * (http://www.mmc.tudelft.nl/) and Ubiquitous Communications
+ * (http://www.mobimedia.org/) and Ubiquitous Communications
  * (http://www.ubicom.tudelft.nl/) projects.
  *
  * The authors can be reached at:
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index a0a2928..7747cad 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -314,7 +314,7 @@ config CPU_SA110
 	  The Intel StrongARM(R) SA-110 is a 32-bit microprocessor and
 	  is available at five speeds ranging from 100 MHz to 233 MHz.
 	  More information is available at
-	  <http://developer.intel.com/design/strong/sa110.htm>.
+	  <http://developer.intel.com/design/>.
 
 	  Say Y if you want support for the SA-110 processor.
 	  Otherwise, say N.
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index 1407597..887975f 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -418,7 +418,7 @@ ENTRY(xscale_cache_fns)
  *
  * See erratum #25 of "Intel 80200 Processor Specification Update",
  * revision January 22, 2003, available at:
- *     http://www.intel.com/design/iio/specupdt/273415.htm
+ *     http://www.intel.com/design/
  */
 ENTRY(xscale_80200_A0_A1_cache_fns)
 	.long	xscale_flush_kern_cache_all
diff --git a/arch/arm/nwfpe/milieu.h b/arch/arm/nwfpe/milieu.h
index a3892ab..af0c1c6 100644
--- a/arch/arm/nwfpe/milieu.h
+++ b/arch/arm/nwfpe/milieu.h
@@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980.  The original version
 of this code was written as part of a project to build a fixed-point vector
 processor in collaboration with the University of California at Berkeley,
 overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
-is available through the Web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
-arithmetic/softfloat.html'.
+is available through the Web page:
+http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
 
 THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
 has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
diff --git a/arch/arm/nwfpe/softfloat-macros b/arch/arm/nwfpe/softfloat-macros
index 5a060f9..64d6c4d 100644
--- a/arch/arm/nwfpe/softfloat-macros
+++ b/arch/arm/nwfpe/softfloat-macros
@@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980.  The original version
 of this code was written as part of a project to build a fixed-point vector
 processor in collaboration with the University of California at Berkeley,
 overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
-is available through the web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
-arithmetic/softfloat.html'.
+is available through the web page:
+http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
 
 THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
 has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
diff --git a/arch/arm/nwfpe/softfloat-specialize b/arch/arm/nwfpe/softfloat-specialize
index d4a4c8e..a11b8ea 100644
--- a/arch/arm/nwfpe/softfloat-specialize
+++ b/arch/arm/nwfpe/softfloat-specialize
@@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980.  The original version
 of this code was written as part of a project to build a fixed-point vector
 processor in collaboration with the University of California at Berkeley,
 overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
-is available through the Web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
-arithmetic/softfloat.html'.
+is available through the Web page:
+http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
 
 THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
 has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
diff --git a/arch/arm/nwfpe/softfloat.c b/arch/arm/nwfpe/softfloat.c
index 0f9656e..56f368d 100644
--- a/arch/arm/nwfpe/softfloat.c
+++ b/arch/arm/nwfpe/softfloat.c
@@ -11,8 +11,8 @@ National Science Foundation under grant MIP-9311980.  The original version
 of this code was written as part of a project to build a fixed-point vector
 processor in collaboration with the University of California at Berkeley,
 overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
-is available through the web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
-arithmetic/softfloat.html'.
+is available through the web page:
+http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
 
 THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
 has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
diff --git a/arch/arm/nwfpe/softfloat.h b/arch/arm/nwfpe/softfloat.h
index 13e479c..1e5ffba 100644
--- a/arch/arm/nwfpe/softfloat.h
+++ b/arch/arm/nwfpe/softfloat.h
@@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980.  The original version
 of this code was written as part of a project to build a fixed-point vector
 processor in collaboration with the University of California at Berkeley,
 overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
-is available through the Web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
-arithmetic/softfloat.html'.
+is available through the Web page:
+http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
 
 THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
 has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
diff --git a/arch/arm/plat-samsung/include/plat/adc.h b/arch/arm/plat-samsung/include/plat/adc.h
index e8382c7..357de61 100644
--- a/arch/arm/plat-samsung/include/plat/adc.h
+++ b/arch/arm/plat-samsung/include/plat/adc.h
@@ -1,7 +1,7 @@
 /* arch/arm/plat-samsung/include/plat/adc.h
  *
  * Copyright (c) 2008 Simtec Electronics
- *	http://armlinux.simnte.co.uk/
+ *	http://armlinux.simtec.co.uk/
  *	Ben Dooks <ben@simtec.co.uk>
  *
  * S3C ADC driver information
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index f515727..787dcba 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -145,7 +145,7 @@ config BOARD_HAMMERHEAD
 	  will cover even the most exceptional need of memory bandwidth. Together with the onboard
 	  video decoder the board is ready for video processing.
 
-	  For more information see: http://www.miromico.com/hammerhead
+	  For more information see: http://www.hammerhead.ch/index.php/getting-started.html 
 
 config BOARD_FAVR_32
 	bool "Favr-32 LCD-board"
diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
index 6e2ecff..d69fc26 100644
--- a/arch/h8300/Kconfig.cpu
+++ b/arch/h8300/Kconfig.cpu
@@ -17,10 +17,10 @@ config H8300H_AKI3068NET
 	help
 	  AKI-H8/3068F / AKI-H8/3069F Flashmicom LAN Board Support
 	  More Information. (Japanese Only)
-	  <http://akizukidensi.com/catalog/h8.html>
+	  <http://akizukidenshi.com/catalog/default.aspx>
 	  AE-3068/69 Evaluation Board Support
 	  More Information.
-	  <http://www.microtronique.com/ae3069lan.htm>
+	  <http://www.microtronique.com/>
 
 config H8300H_H8MAX
 	bool "H8MAX"
@@ -28,7 +28,7 @@ config H8300H_H8MAX
 	help
 	  H8MAX Evaluation Board Support
 	  More Information. (Japanese Only)
-	  <http://strawberry-linux.com/h8/index.html>
+	  <http://strawberry-linux.com/h8/>
 
 config H8300H_SIM
 	bool "H8/300H Simulator"
@@ -36,7 +36,7 @@ config H8300H_SIM
 	help
 	  GDB Simulator Support
 	  More Information.
-	  arch/h8300/Doc/simulator.txt
+	  <http://www.gnu.org/software/gdb/> 
 
 config H8S_GENERIC
 	bool "H8S Generic"
@@ -49,15 +49,15 @@ config H8S_EDOSK2674
 	help
 	  Renesas EDOSK-2674 Evaluation Board Support
 	  More Information.
-	  <http://www.azpower.com/H8-uClinux/index.html>
- 	  <http://www.eu.renesas.com/tools/edk/support/edosk2674.html>
+	  <http://h8-uclinux.sourceforge.net/>
+ 	  <http://www.renesas.eu/>
 
 config H8S_SIM
 	bool "H8S Simulator"
 	help
 	  GDB Simulator Support
 	  More Information.
-	  arch/h8300/Doc/simulator.txt
+	  http://www.gnu.org/software/gdb/ 
 
 endchoice
 
diff --git a/arch/h8300/README b/arch/h8300/README
index 2fd6f6d..bb5aae5 100644
--- a/arch/h8300/README
+++ b/arch/h8300/README
@@ -11,14 +11,14 @@ H8/300H and H8S
 2.AE 3068/AE 3069
   more information 
   MICROTRONIQUE <http://www.microtronique.com/>
-  Akizuki Denshi Tsusho Ltd. <http://www.akizuki.ne.jp> (Japanese Only)
+  Akizuki Denshi Tsusho Ltd. <http://akizukidenshi.com/catalog/default.aspx> (Japanese Only)
 
 3.H8MAX 
-  see http://ip-sol.jp/h8max/ (Japanese Only)
+  see http://strawberry-linux.com/h8/h8max.html (Japanese Only)
 
 4.EDOSK2674
-  see http://www.eu.renesas.com/products/mpumcu/tool/edk/support/edosk2674.html
-      http://www.azpower.com/H8-uClinux/
+  see http://www.renesas.eu/ 
+      http://h8-uclinux.sourceforge.net/
 
 * Toolchain Version
 gcc-3.1 or higher and patch
@@ -33,5 +33,5 @@ see http://www.uclinux.org/pub/uClinux/ports/h8/
 
 * A few words of thanks
 Porting to H8/300 serieses is support of Information-technology Promotion Agency, Japan.
-I thank support.
-and All developer/user.
+I thank you for all the developer/user support.
+
diff --git a/arch/ia64/include/asm/machvec_sn2.h b/arch/ia64/include/asm/machvec_sn2.h
index f061a30..e9d032e 100644
--- a/arch/ia64/include/asm/machvec_sn2.h
+++ b/arch/ia64/include/asm/machvec_sn2.h
@@ -22,7 +22,7 @@
  * 
  * For further information regarding this notice, see: 
  * 
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://oss.sgi.com/
  */
 
 #ifndef _ASM_IA64_MACHVEC_SN2_H
diff --git a/arch/ia64/include/asm/numa.h b/arch/ia64/include/asm/numa.h
index 6a8a27c..4f8a45e 100644
--- a/arch/ia64/include/asm/numa.h
+++ b/arch/ia64/include/asm/numa.h
@@ -52,7 +52,7 @@ extern struct node_cpuid_s node_cpuid[NR_CPUS];
 
 /*
  * ACPI 2.0 SLIT (System Locality Information Table)
- * http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf
+ * http://web.archive.org/web/*/http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf 
  *
  * This is a matrix with "distances" between nodes, they should be
  * proportional to the memory access latency ratios.
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index c6c90f3..82e5c96 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -452,7 +452,7 @@ static int get_memory_proximity_domain(struct acpi_srat_mem_affinity *ma)
 
 /*
  * ACPI 2.0 SLIT (System Locality Information Table)
- * http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf
+ * http://web.archive.org/web/*/http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf 
  */
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
diff --git a/arch/ia64/lib/idiv32.S b/arch/ia64/lib/idiv32.S
index 2ac28bf..f4938e1 100644
--- a/arch/ia64/lib/idiv32.S
+++ b/arch/ia64/lib/idiv32.S
@@ -7,7 +7,7 @@
  * This code is based on the application note entitled "Divide, Square Root
  * and Remainder Algorithms for the IA-64 Architecture".  This document
  * is available as Intel document number 248725-002 or via the web at
- * http://developer.intel.com/software/opensource/numerics/
+ * http://web.archive.org/web/20020611073250/developer.intel.com/software/products/opensource/libraries/num.htm 
  *
  * For more details on the theory behind these algorithms, see "IA-64
  * and Elementary Functions" by Peter Markstein; HP Professional Books
diff --git a/arch/ia64/lib/idiv64.S b/arch/ia64/lib/idiv64.S
index f69bd2b..5c3fb6d 100644
--- a/arch/ia64/lib/idiv64.S
+++ b/arch/ia64/lib/idiv64.S
@@ -7,7 +7,7 @@
  * This code is based on the application note entitled "Divide, Square Root
  * and Remainder Algorithms for the IA-64 Architecture".  This document
  * is available as Intel document number 248725-002 or via the web at
- * http://developer.intel.com/software/opensource/numerics/
+ * http://web.archive.org/web/20020611073250/developer.intel.com/software/products/opensource/libraries/num.htm 
  *
  * For more details on the theory behind these algorithms, see "IA-64
  * and Elementary Functions" by Peter Markstein; HP Professional Books
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index dbc4cbe..b359a9a 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -234,7 +234,7 @@ static void __cpuinit sn_check_for_wars(void)
  * Since pcdp support in SN is not supported in the 2.4 kernel (or at least
  * the one lbs is based on) just declare the needed structs here.
  *
- * Reference spec http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
+ * Reference spec http://web.archive.org/web/*/http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
  *
  * Returns 0 if no acceptable vga is found, !0 otherwise.
  *
diff --git a/arch/ia64/sn/kernel/sn2/timer_interrupt.c b/arch/ia64/sn/kernel/sn2/timer_interrupt.c
index 103d6ea..9f9d5f2 100644
--- a/arch/ia64/sn/kernel/sn2/timer_interrupt.c
+++ b/arch/ia64/sn/kernel/sn2/timer_interrupt.c
@@ -1,6 +1,4 @@
 /*
- *
- *
  * Copyright (c) 2005, 2006 Silicon Graphics, Inc.  All Rights Reserved.
  * 
  * This program is free software; you can redistribute it and/or modify it 
@@ -24,7 +22,7 @@
  * 
  * For further information regarding this notice, see: 
  * 
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://oss.sgi.com/
  */
 
 #include <linux/interrupt.h>
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 836abbb..3867fd2 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -315,7 +315,7 @@ config SMP
 	  Management" code will be disabled if you say Y here.
 
 	  See also the SMP-HOWTO available at
-	  <http://www.linuxdoc.org/docs.html#howto>.
+	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
 	  If you don't know what to do here, say N.
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 8030e24..b092426 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -221,7 +221,7 @@ config SUN3X
 	  Be warned that this support is very experimental.
 	  Note that Sun 3x kernels are not compatible with Sun 3 hardware.
 	  General Linux information on the Sun 3x series (now discontinued)
-	  is at <http://www.angelfire.com/ca2/tech68k/sun3.html>.
+	  is at <http://web.archive.org/web/*/angelfire.com/ca2/tech68k/sun3.html>.
 
 	  If you don't want to compile a kernel for a Sun 3x, say N.
 
diff --git a/arch/m68k/mac/macboing.c b/arch/m68k/mac/macboing.c
index 8f06408..f01f0db 100644
--- a/arch/m68k/mac/macboing.c
+++ b/arch/m68k/mac/macboing.c
@@ -114,7 +114,7 @@ static void mac_init_asc( void )
 			 *   16-bit I/O functionality.  The PowerBook 500 series computers
 			 *   support 16-bit stereo output, but only mono input."
 			 *
-			 *   http://til.info.apple.com/techinfo.nsf/artnum/n16405
+			 *   http://support.apple.com/kb/TA32601
 			 *
 			 * --David Kilzer
 			 */
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index e71166d..0cfa2cf 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -6,11 +6,8 @@
  *
  * CSA: Motorola seems to have removed documentation on the 6522 from
  * their web site; try
- *     http://nerini.drf.com/vectrex/other/text/chips/6522/
- *     http://www.zymurgy.net/classic/vic20/vicdet1.htm
- * and
- *     http://193.23.168.87/mikro_laborversuche/via_iobaustein/via6522_1.html
- * for info.  A full-text web search on 6522 AND VIA will probably also
+ *     http://web.archive.org/web/*/http://www.zymurgy.net/classic/vic20/vicdet1.htm
+ * A full-text web search on 6522 AND VIA will probably also
  * net some usefulness. <cananian@alumni.princeton.edu> 20apr1999
  *
  * Additional data is here (the SY6522 was used in the Mac II etc):
diff --git a/arch/m68k/q40/README b/arch/m68k/q40/README
index 6bdbf48..5ba4ef8 100644
--- a/arch/m68k/q40/README
+++ b/arch/m68k/q40/README
@@ -1,9 +1,9 @@
 Linux for the Q40
 =================
 
-You may try http://www.geocities.com/SiliconValley/Bay/2602/ for
-some up to date information. Booter and other tools will be also
-available from this place or ftp.uni-erlangen.de/linux/680x0/q40/
+You may try http://web.archive.org/web/*/http://geocities.com/SiliconValley/Bay/2602/ 
+for some up to date information. Booter and other tools will be also
+available from this place or http://ftp.uni-erlangen.de/pub/unix/Linux/680x0/q40/
 and mirrors.
 
 Hints to documentation usually refer to the linux source tree in
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3ad59dd..ab2330c 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2178,7 +2178,7 @@ config TC
 	  TurboChannel is a DEC (now Compaq (now HP)) bus for Alpha and MIPS
 	  processors.  Documentation on writing device drivers for TurboChannel
 	  is available at:
-	  <http://www.cs.arizona.edu/computer.help/policy/DIGITAL_unix/AA-PS3HD-TET1_html/TITLE.html>.
+	  <http://www.linux-mips.org/wiki/Main_Page>.
 
 #config ACCESSBUS
 #	bool "Access.Bus support"
diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index 47842b7..11326c7 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -3,7 +3,7 @@
  *
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * Kevin D. Kissell, kevink@mips.com and Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2000  MIPS Technologies, Inc.
diff --git a/arch/mips/math-emu/dp_add.c b/arch/mips/math-emu/dp_add.c
index bcf73bb..4b3a8e6 100644
--- a/arch/mips/math-emu/dp_add.c
+++ b/arch/mips/math-emu/dp_add.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_cmp.c b/arch/mips/math-emu/dp_cmp.c
index 8ab4f32..0e9f91a 100644
--- a/arch/mips/math-emu/dp_cmp.c
+++ b/arch/mips/math-emu/dp_cmp.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_div.c b/arch/mips/math-emu/dp_div.c
index 6acedce..e6aeaea 100644
--- a/arch/mips/math-emu/dp_div.c
+++ b/arch/mips/math-emu/dp_div.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_fint.c b/arch/mips/math-emu/dp_fint.c
index 39a71de1..bb1e85e 100644
--- a/arch/mips/math-emu/dp_fint.c
+++ b/arch/mips/math-emu/dp_fint.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_flong.c b/arch/mips/math-emu/dp_flong.c
index f08f223..c335384 100644
--- a/arch/mips/math-emu/dp_flong.c
+++ b/arch/mips/math-emu/dp_flong.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_frexp.c b/arch/mips/math-emu/dp_frexp.c
index e650cb1..bc4b3d6 100644
--- a/arch/mips/math-emu/dp_frexp.c
+++ b/arch/mips/math-emu/dp_frexp.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_fsp.c b/arch/mips/math-emu/dp_fsp.c
index 494d19a..3c2ef64 100644
--- a/arch/mips/math-emu/dp_fsp.c
+++ b/arch/mips/math-emu/dp_fsp.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_logb.c b/arch/mips/math-emu/dp_logb.c
index 6033886..e1de666 100644
--- a/arch/mips/math-emu/dp_logb.c
+++ b/arch/mips/math-emu/dp_logb.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_modf.c b/arch/mips/math-emu/dp_modf.c
index a8570e5..6360201 100644
--- a/arch/mips/math-emu/dp_modf.c
+++ b/arch/mips/math-emu/dp_modf.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_mul.c b/arch/mips/math-emu/dp_mul.c
index 48908a8..366e2c6 100644
--- a/arch/mips/math-emu/dp_mul.c
+++ b/arch/mips/math-emu/dp_mul.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_scalb.c b/arch/mips/math-emu/dp_scalb.c
index b84e633..fad2180 100644
--- a/arch/mips/math-emu/dp_scalb.c
+++ b/arch/mips/math-emu/dp_scalb.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_simple.c b/arch/mips/math-emu/dp_simple.c
index b909742..8336418 100644
--- a/arch/mips/math-emu/dp_simple.c
+++ b/arch/mips/math-emu/dp_simple.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_sqrt.c b/arch/mips/math-emu/dp_sqrt.c
index 032328c..3c87408 100644
--- a/arch/mips/math-emu/dp_sqrt.c
+++ b/arch/mips/math-emu/dp_sqrt.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_sub.c b/arch/mips/math-emu/dp_sub.c
index a2127d6..2593cf1 100644
--- a/arch/mips/math-emu/dp_sub.c
+++ b/arch/mips/math-emu/dp_sub.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_tint.c b/arch/mips/math-emu/dp_tint.c
index 2447862..234d520 100644
--- a/arch/mips/math-emu/dp_tint.c
+++ b/arch/mips/math-emu/dp_tint.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/dp_tlong.c b/arch/mips/math-emu/dp_tlong.c
index 0f07ec2..f174efc 100644
--- a/arch/mips/math-emu/dp_tlong.c
+++ b/arch/mips/math-emu/dp_tlong.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/ieee754.c b/arch/mips/math-emu/ieee754.c
index cb1b682..9743d18 100644
--- a/arch/mips/math-emu/ieee754.c
+++ b/arch/mips/math-emu/ieee754.c
@@ -9,7 +9,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/ieee754.h b/arch/mips/math-emu/ieee754.h
index dd91733..a3d0893 100644
--- a/arch/mips/math-emu/ieee754.h
+++ b/arch/mips/math-emu/ieee754.h
@@ -1,7 +1,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  *  This program is free software; you can distribute it and/or modify it
  *  under the terms of the GNU General Public License (Version 2) as
diff --git a/arch/mips/math-emu/ieee754d.c b/arch/mips/math-emu/ieee754d.c
index a032533..9ac53d7 100644
--- a/arch/mips/math-emu/ieee754d.c
+++ b/arch/mips/math-emu/ieee754d.c
@@ -4,7 +4,7 @@
  * MIPS floating point support
  *
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  *  This program is free software; you can distribute it and/or modify it
  *  under the terms of the GNU General Public License (Version 2) as
diff --git a/arch/mips/math-emu/ieee754dp.c b/arch/mips/math-emu/ieee754dp.c
index 2f22fd7..d2cedf5 100644
--- a/arch/mips/math-emu/ieee754dp.c
+++ b/arch/mips/math-emu/ieee754dp.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/ieee754dp.h b/arch/mips/math-emu/ieee754dp.h
index 7627865..b90bd7a 100644
--- a/arch/mips/math-emu/ieee754dp.h
+++ b/arch/mips/math-emu/ieee754dp.h
@@ -5,7 +5,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/ieee754int.h b/arch/mips/math-emu/ieee754int.h
index 1a846c5..91eb7d2 100644
--- a/arch/mips/math-emu/ieee754int.h
+++ b/arch/mips/math-emu/ieee754int.h
@@ -5,7 +5,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/ieee754m.c b/arch/mips/math-emu/ieee754m.c
index d66896c..9f8559c 100644
--- a/arch/mips/math-emu/ieee754m.c
+++ b/arch/mips/math-emu/ieee754m.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/ieee754sp.c b/arch/mips/math-emu/ieee754sp.c
index a19b721..60b8aea 100644
--- a/arch/mips/math-emu/ieee754sp.c
+++ b/arch/mips/math-emu/ieee754sp.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/ieee754sp.h b/arch/mips/math-emu/ieee754sp.h
index d9e3586..36585e5 100644
--- a/arch/mips/math-emu/ieee754sp.h
+++ b/arch/mips/math-emu/ieee754sp.h
@@ -5,7 +5,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/ieee754xcpt.c b/arch/mips/math-emu/ieee754xcpt.c
index e02423a..2399e44 100644
--- a/arch/mips/math-emu/ieee754xcpt.c
+++ b/arch/mips/math-emu/ieee754xcpt.c
@@ -1,7 +1,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_add.c b/arch/mips/math-emu/sp_add.c
index d8c4211..dba0126 100644
--- a/arch/mips/math-emu/sp_add.c
+++ b/arch/mips/math-emu/sp_add.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_cmp.c b/arch/mips/math-emu/sp_cmp.c
index d3eff6b..0ba0aaf 100644
--- a/arch/mips/math-emu/sp_cmp.c
+++ b/arch/mips/math-emu/sp_cmp.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_div.c b/arch/mips/math-emu/sp_div.c
index 2b437fc..94a835c 100644
--- a/arch/mips/math-emu/sp_div.c
+++ b/arch/mips/math-emu/sp_div.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_fdp.c b/arch/mips/math-emu/sp_fdp.c
index 4093723..9d44208 100644
--- a/arch/mips/math-emu/sp_fdp.c
+++ b/arch/mips/math-emu/sp_fdp.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_fint.c b/arch/mips/math-emu/sp_fint.c
index e88e125..9d7f2e7 100644
--- a/arch/mips/math-emu/sp_fint.c
+++ b/arch/mips/math-emu/sp_fint.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_flong.c b/arch/mips/math-emu/sp_flong.c
index 26d6919..f917142 100644
--- a/arch/mips/math-emu/sp_flong.c
+++ b/arch/mips/math-emu/sp_flong.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_frexp.c b/arch/mips/math-emu/sp_frexp.c
index 359c648..4211a1a 100644
--- a/arch/mips/math-emu/sp_frexp.c
+++ b/arch/mips/math-emu/sp_frexp.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_logb.c b/arch/mips/math-emu/sp_logb.c
index 3c33721..69520c5 100644
--- a/arch/mips/math-emu/sp_logb.c
+++ b/arch/mips/math-emu/sp_logb.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_modf.c b/arch/mips/math-emu/sp_modf.c
index 7656894..9b4fea1 100644
--- a/arch/mips/math-emu/sp_modf.c
+++ b/arch/mips/math-emu/sp_modf.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_mul.c b/arch/mips/math-emu/sp_mul.c
index 3f070f8..e31f04b 100644
--- a/arch/mips/math-emu/sp_mul.c
+++ b/arch/mips/math-emu/sp_mul.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_scalb.c b/arch/mips/math-emu/sp_scalb.c
index 44ceb87..1b88cf3 100644
--- a/arch/mips/math-emu/sp_scalb.c
+++ b/arch/mips/math-emu/sp_scalb.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_simple.c b/arch/mips/math-emu/sp_simple.c
index 2fd53c9..90b6b85 100644
--- a/arch/mips/math-emu/sp_simple.c
+++ b/arch/mips/math-emu/sp_simple.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_sqrt.c b/arch/mips/math-emu/sp_sqrt.c
index 8a934b9..d638915 100644
--- a/arch/mips/math-emu/sp_sqrt.c
+++ b/arch/mips/math-emu/sp_sqrt.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_sub.c b/arch/mips/math-emu/sp_sub.c
index dbb802c..c055ba9 100644
--- a/arch/mips/math-emu/sp_sub.c
+++ b/arch/mips/math-emu/sp_sub.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_tint.c b/arch/mips/math-emu/sp_tint.c
index 352dc3a..5268743 100644
--- a/arch/mips/math-emu/sp_tint.c
+++ b/arch/mips/math-emu/sp_tint.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/mips/math-emu/sp_tlong.c b/arch/mips/math-emu/sp_tlong.c
index 92cd9c5..7acf15b 100644
--- a/arch/mips/math-emu/sp_tlong.c
+++ b/arch/mips/math-emu/sp_tlong.c
@@ -4,7 +4,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
diff --git a/arch/powerpc/include/asm/hydra.h b/arch/powerpc/include/asm/hydra.h
index 1ad4eed..d529a2c 100644
--- a/arch/powerpc/include/asm/hydra.h
+++ b/arch/powerpc/include/asm/hydra.h
@@ -10,7 +10,7 @@
  *
  *	© Copyright 1995 Apple Computer, Inc. All rights reserved.
  *
- *  It's available online from http://chrp.apple.com/MacTech.pdf.
+ *  It's available online from http://www.cpu.lu/~mlan/ftp/MacTech.pdf.
  *  You can obtain paper copies of this book from computer bookstores or by
  *  writing Morgan Kaufmann Publishers, Inc., 340 Pine Street, Sixth Floor, San
  *  Francisco, CA 94104. Reference ISBN 1-55860-393-X.
diff --git a/arch/sh/cchips/Kconfig b/arch/sh/cchips/Kconfig
index a5ab2ec..ab22ac1 100644
--- a/arch/sh/cchips/Kconfig
+++ b/arch/sh/cchips/Kconfig
@@ -17,7 +17,7 @@ config HD64461
 	  PCMCIA controller supporting 2 slots.
 
 	  More information is available at
-	  <http://semiconductor.hitachi.com/windowsce/superh/sld013.htm>.
+	  <http://web.archive.org/web/*/http://semiconductor.hitachi.com/windowsce/superh/sld013.htm>.
 
 	  Say Y if you want support for the HD64461.
 	  Otherwise, say N.
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 02ee9ad..48bbefa 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -195,7 +195,7 @@ __uml_setup("nosysemu", nosysemu_cmd_param,
 "    SYSEMU is a performance-patch introduced by Laurent Vivier. It changes\n"
 "    behaviour of ptrace() and helps reducing host context switch rate.\n"
 "    To make it working, you need a kernel patch for your host, too.\n"
-"    See http://perso.wanadoo.fr/laurent.vivier/UML/ for further \n"
+"    See http://web.archive.org/web/*/http://perso.wanadoo.fr/laurent.vivier/UML/ for further \n"
 "    information.\n\n");
 
 static void __init check_sysemu(void)
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 4c9c67b..ef07a46 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -190,7 +190,7 @@
  *
  * [This document is available free from Intel by calling 800.628.8686 (fax
  * 916.356.6100) or 800.548.4725; or via anonymous ftp from
- * ftp://ftp.intel.com/pub/IAL/software_specs/apmv11.doc.  It is also
+ * ftp://ftp.intel.com/pub/.  It is also
  * available from Microsoft by calling 206.882.8080.]
  *
  * APM 1.2 Reference:
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ba5f62f..8c03911 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -23,7 +23,7 @@
  *	contact AMD for precise details and a CPU swap.
  *
  *	See	http://www.multimania.com/poulot/k6bug.html
- *		http://www.amd.com/K6/k6docs/revgd.html
+ *		http://web.archive.org/web/*/http://www.amd.com/K6/k6docs/revgd.html	
  *
  *	The following test is erm.. interesting. AMD neglected to up
  *	the chip setting when fixing the bug but they also tweaked some
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 491977b..d5f04c2 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -21,7 +21,7 @@
  *  Opteron Processors" available for download from www.amd.com
  *
  *  Tables for specific CPUs can be inferred from
- *     http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30430.pdf
+ *  http://web.archive.org/web/*/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30430.pdf   
  */
 
 #include <linux/kernel.h>
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index fa6551d..b9c5c54 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -12,7 +12,7 @@
  *	Software Developer's Manual
  *	Order Number 253668 or free download from:
  *
- *	http://developer.intel.com/design/pentium4/manuals/253668.htm
+ *	http://developer.intel.com/Assets/PDF/manual/253668.pdf	
  *
  *	For more information, go to http://www.urbanmyth.org/microcode
  *
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 3561702..dcb65cc 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -12,7 +12,7 @@
  *	Software Developer's Manual
  *	Order Number 253668 or free download from:
  *
- *	http://developer.intel.com/design/pentium4/manuals/253668.htm
+ *	http://developer.intel.com/Assets/PDF/manual/253668.pdf	
  *
  *	For more information, go to http://www.urbanmyth.org/microcode
  *
diff --git a/arch/x86/math-emu/README b/arch/x86/math-emu/README
index e623549..be83144 100644
--- a/arch/x86/math-emu/README
+++ b/arch/x86/math-emu/README
@@ -45,10 +45,6 @@ Please report bugs, etc to me at:
        billm@melbpc.org.au
 or     b.metzenthen@medoto.unimelb.edu.au
 
-For more information on the emulator and on floating point topics, see
-my web pages, currently at  http://www.suburbia.net/~billm/
-
-
 --Bill Metzenthen
   December 1999
 
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index bf88f71..ec1392d 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -16,7 +16,7 @@
  *  Based in part on the ITE vendor provided SCSI driver.
  *
  *  Documentation available from
- * 	http://www.ite.com.tw/pc/IT8212F_V04.pdf
+ * 	http://www.ite.com.tw/EN/products_more.aspx?CategoryID=3&ID=5,91	
  *  Some other documents are NDA.
  *
  *  The ITE8212 isn't exactly a standard IDE controller. It has two
diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index be7461c..a01f6b2 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -301,7 +301,7 @@ config ATM_IA
 	  control memory (128K-1KVC, 512K-4KVC), the size of the packet
 	  memory (128K, 512K, 1M), and the PHY type (Single/Multi mode OC3,
 	  UTP155, UTP25, DS3 and E3). Go to:
-	  	<http://www.iphase.com/products/ClassSheet.cfm?ClassID=ATM>
+	  	<http://www.iphase.com/products/whitepapers/>
 	  for more info about the cards. Say Y (or M to compile as a module
 	  named iphase) here if you have one of these cards.
 
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index de27768..645a3f8 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -169,7 +169,7 @@ config BLK_DEV_UMEM
 	---help---
 	  Saying Y here will include support for the MM5415 family of
 	  battery backed (Non-volatile) RAM cards.
-	  <http://www.umem.com/>
+	  <http://web.archive.org/web/*/http://www.umem.com/>
 
 	  The cards appear as block devices that can be partitioned into
 	  as many as 15 partitions.
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 4b66c69..c8ad619 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -34,7 +34,7 @@ config AGP_ALI
 	  X on the following ALi chipsets.  The supported chipsets
 	  include M1541, M1621, M1631, M1632, M1641,M1647,and M1651.
 	  For the ALi-chipset question, ALi suggests you refer to
-	  <http://www.ali.com.tw/eng/support/index.shtml>.
+	  <http://www.ali.com.tw/>.
 
 	  The M1541 chipset can do AGP 1x and 2x, but note that there is an
 	  acknowledged incompatibility with Matrox G200 cards. Due to
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index e763d33..75b763c 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -1,7 +1,7 @@
 /*
  * For documentation on the i460 AGP interface, see Chapter 7 (AGP Subsystem) of
  * the "Intel 460GTX Chipset Software Developer's Manual":
- * http://developer.intel.com/design/itanium/downloads/24870401s.htm
+ * http://www.intel.com/design/archives/itanium/downloads/248704.htm 
  */
 /*
  * 460GX support by Chris Ahna <christopher.j.ahna@intel.com>
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 033e150..d7d9a78 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -8,7 +8,7 @@
  *   (APM) BIOS Interface Specification, Revision 1.2, February 1996.
  *
  * [This document is available from Microsoft at:
- *    http://www.microsoft.com/hwdev/busbios/amp_12.htm]
+ *    http://www.microsoft.com/whdc/archive/amp_12.mspx]
  */
 #include <linux/module.h>
 #include <linux/poll.h>
diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index 7b98c06..1dda5bc 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -2,7 +2,7 @@
  *  ipmi_bt_sm.c
  *
  *  The state machine for an Open IPMI BT sub-driver under ipmi_si.c, part
- *  of the driver architecture at http://sourceforge.net/project/openipmi
+ *  of the driver architecture at http://sourceforge.net/projects/openipmi
  *
  *  Author:	Rocky Craig <first.last@hp.com>
  *
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 3822b4f..967e620 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1971,8 +1971,7 @@ static int acpi_gpe_irq_setup(struct smi_info *info)
 
 /*
  * Defined at
- * http://h21007.www2.hp.com/portal/download/files
- * /unprot/hpspmi.pdf
+ * http://h21007.www2.hp.com/portal/download/files/unprot/hpspmi.pdf
  */
 struct SPMITable {
 	s8	Signature[4];
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index a98290d..7e526ea 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -4,7 +4,7 @@
  * Copyright by 
  * Philips Automation Projects
  * Kassel (Germany)
- * http://www.pap-philips.de
+ * http://www.pronto.philips.com/ 
  * -----------------------------------------------------------
  * This software may be used and distributed according to the terms of
  * the GNU General Public License, incorporated herein by reference.
diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
index ffa0efc..6614416 100644
--- a/drivers/char/pcmcia/Kconfig
+++ b/drivers/char/pcmcia/Kconfig
@@ -28,7 +28,7 @@ config CARDMAN_4000
 
 	  This kernel driver requires additional userspace support, either
 	  by the vendor-provided PC/SC ifd_handler (http://www.omnikey.com/),
-	  or via the cm4000 backend of OpenCT (http://www.opensc.com/).
+	  or via the cm4000 backend of OpenCT (http://www.opensc-project.org/opensc).
 
 config CARDMAN_4040
 	tristate "Omnikey CardMan 4040 support"
@@ -41,7 +41,7 @@ config CARDMAN_4040
 	  in I/O space.  To use the kernel driver, you will need either the
 	  PC/SC ifdhandler provided from the Omnikey homepage
 	  (http://www.omnikey.com/), or a current development version of OpenCT
-	  (http://www.opensc.org/).
+	  (http://www.opensc-project.org/opensc).
 
 config IPWIRELESS
 	tristate "IPWireless 3G UMTS PCMCIA card support"
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 4dc338f..f6595ab 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -58,6 +58,6 @@ config TCG_INFINEON
 	  To compile this driver as a module, choose M here; the module
 	  will be called tpm_infineon.
 	  Further information on this driver and the supported hardware
-	  can be found at http://www.prosec.rub.de/tpm
+	  can be found at http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/ 
 
 endif # TCG_TPM
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index f584407..76da32e 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -7,7 +7,7 @@
  * Copyright (C) 2005, Marcel Selhorst <m.selhorst@sirrix.com>
  * Sirrix AG - security technologies, http://www.sirrix.com and
  * Applied Data Security Group, Ruhr-University Bochum, Germany
- * Project-Homepage: http://www.prosec.rub.de/tpm
+ * Project-Homepage: http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/ 
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index 0709681..413f0df 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -1,7 +1,7 @@
 /*
  * file for managing the edac_device class of devices for EDAC
  *
- * (C) 2007 SoftwareBitMaker (http://www.softwarebitmaker.com)
+ * (C) 2007 SoftwareBitMaker 
  *
  * This file may be distributed under the terms of the
  * GNU General Public License.
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index a2fa1fe..adb6574 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -12,7 +12,7 @@
  * 440GX fix by Jason Uhlenkott <juhlenko@akamai.com>.
  *
  * Written with reference to 82443BX Host Bridge Datasheet:
- * http://www.intel.com/design/chipsets/440/documentation.htm
+ * http://ark.intel.com/Product.aspx?id=27151 
  * references to this document given in [].
  *
  * This module doesn't support the 440LX, but it may be possible to
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 3218819..b2e6c21 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -1,6 +1,6 @@
 /*
  * Intel 82975X Memory Controller kernel module
- * (C) 2007 aCarLab (India) Pvt. Ltd. (http://acarlab.com)
+ * (C) 2007 aCarLab (India) Pvt. Ltd. (http://web.archive.org/web/*/http://acarlab.com)
  * (C) 2007 jetzbroadband (http://jetzbroadband.com)
  * This file may be distributed under the terms of the
  * GNU General Public License.
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 280c9b5..de0aca5 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -74,7 +74,7 @@ config EFI_PCDP
 
 	  You must also enable the appropriate drivers (serial, VGA, etc.)
 
-	  See <http://www.dig64.org/specifications/DIG64_HCDPv20_042804.pdf>
+	  See <http://www.dig64.org/specifications/agreement>
 
 config DELL_RBU
 	tristate "BIOS update support for DELL systems via sysfs"
diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index f287fe7..acabed6 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -15,7 +15,7 @@
  * made in setup.S, copied to safe structures in setup.c,
  * and presents it in sysfs.
  *
- * Please see http://linux.dell.com/edd30/results.html for
+ * Please see http://linux.dell.com/ for
  * the list of BIOSs which have been reported to implement EDD.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/firmware/pcdp.h b/drivers/firmware/pcdp.h
index ce910d6..faa0225 100644
--- a/drivers/firmware/pcdp.h
+++ b/drivers/firmware/pcdp.h
@@ -1,8 +1,7 @@
 /*
  * Definitions for PCDP-defined console devices
  *
- * v1.0a: http://www.dig64.org/specifications/DIG64_HCDPv10a_01.pdf
- * v2.0:  http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
+ * Specification's: http://www.dig64.org/specifications/agreement 
  *
  * (c) Copyright 2002, 2004 Hewlett-Packard Development Company, L.P.
  *	Khalid Aziz <khalid.aziz@hp.com>
diff --git a/drivers/gpu/drm/README.drm b/drivers/gpu/drm/README.drm
index b5b3327..f2d7040 100644
--- a/drivers/gpu/drm/README.drm
+++ b/drivers/gpu/drm/README.drm
@@ -28,7 +28,7 @@ ways:
 Documentation on the DRI is available from:
     http://dri.freedesktop.org/wiki/Documentation
     http://sourceforge.net/project/showfiles.php?group_id=387
-    http://dri.sourceforge.net/doc/
+    http://dri.freedesktop.org/wiki/Documentation 
 
 For specific information about kernel-level support, see:
 
diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 949326d..59251d2 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -76,7 +76,7 @@ EXPORT_SYMBOL(drm_mode_debug_printmodeline);
  * according to the hdisplay, vdisplay, vrefresh.
  * It is based from the VESA(TM) Coordinated Video Timing Generator by
  * Graham Loveridge April 9, 2003 available at
- * http://www.vesa.org/public/CVT/CVTd6r1.xls
+ * http://www.vesa.org/
  *
  * And it is copied from xf86CVTmode in xserver/hw/xfree86/modes/xf86cvt.c.
  * What I have done is to translate it by using integer calculation.
diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index fbdc765..8803ed9 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -14,7 +14,7 @@
  *   and 101 for 1 MSPS)
  *
  * Complete datasheets are available at National's website here:
- * http://www.national.com/ds/DC/ADC<bb><c>S<sss>.pdf
+ * http://www.national.com/products/catalog.do 
  *
  * Handling of 8, 10 and 12 bits converters are the same, the
  * unavailable bits are 0 :)
diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
index 251b631..7b7f9c2 100644
--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -12,7 +12,7 @@
  * resolution of about 0.5% of the nominal value). Temperature values are
  * reported with a 1 deg resolution and a 3 deg accuracy. Complete
  * datasheet can be obtained from Analog's website at:
- *   http://www.analog.com/Analog_Root/productPage/productHome/0,2121,ADM1025,00.html
+ *  http://www.analog.com/en/content/Parts_List_Sold_to_On_Semiconductor/fca.html 
  *
  * This driver also supports the ADM1025A, which differs from the ADM1025
  * only in that it has "open-drain VID inputs while the ADM1025 has
diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
index 65335b2..b1e0882 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -6,7 +6,7 @@
 
     Chip details at:
 
-    <http://www.analog.com/UploadedFiles/Data_Sheets/779263102ADM1026_a.pdf>
+    <http://www.analog.com/en/content/Parts_List_Sold_to_On_Semiconductor/fca.html>
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 9638d58..95cbfb3 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -6,10 +6,10 @@
  * Datasheets available at:
  *
  * f75375:
- * http://www.fintek.com.tw/files/productfiles/2005111152950.pdf
+ * http://www.fintek.com.tw/files/productfiles/F75375_V026P.pdf 
  *
  * f75373:
- * http://www.fintek.com.tw/files/productfiles/2005111153128.pdf
+ * http://www.fintek.com.tw/files/productfiles/F75373_V025P.pdf
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/hwmon/g760a.c b/drivers/hwmon/g760a.c
index 1f63d1a..905e194 100644
--- a/drivers/hwmon/g760a.c
+++ b/drivers/hwmon/g760a.c
@@ -5,7 +5,7 @@
     Copyright (C) 2007  Herbert Valerio Riedel <hvr@gnu.org>
 
     Complete datasheet is available at GMT's website:
-      http://www.gmt.com.tw/datasheet/g760a.pdf
+      http://www.gmt.com.tw/product/datasheet/EDS-760A.pdf
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
index bf0862a..ce42c21 100644
--- a/drivers/hwmon/hwmon-vid.c
+++ b/drivers/hwmon/hwmon-vid.c
@@ -38,20 +38,20 @@
  * available at http://developer.intel.com/.
  *
  * AMD Athlon 64 and AMD Opteron Processors, AMD Publication 26094,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/26094.PDF
+ * http://developer.amd.com/documentation/articles/pages/1212200690_2.aspx 
  * Table 74. VID Code Voltages
  * This corresponds to an arbitrary VRM code of 24 in the functions below.
  * These CPU models (K8 revision <= E) have 5 VID pins. See also:
  * Revision Guide for AMD Athlon 64 and AMD Opteron Processors, AMD Publication 25759,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25759.pdf
+ * http://web.archive.org/web/*/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25759.pdf
  *
  * AMD NPT Family 0Fh Processors, AMD Publication 32559,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/32559.pdf
+ * http://web.archive.org/web/*/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/32559.pdf
  * Table 71. VID Code Voltages
  * This corresponds to an arbitrary VRM code of 25 in the functions below.
  * These CPU models (K8 revision >= F) have 6 VID pins. See also:
  * Revision Guide for AMD NPT Family 0Fh Processors, AMD Publication 33610,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/33610.pdf
+ * http://web.archive.org/web/*/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/33610.pdf
  *
  * The 17 specification is in fact Intel Mobile Voltage Positioning -
  * (IMVP-II). You can find more information in the datasheet of Max1718
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 4516369..d876275 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -12,7 +12,7 @@
  *
  *
  * HighPoint has its own drivers (open source except for the RAID part)
- * available from http://www.highpoint-tech.com/BIOS%20+%20Driver/.
+ * available from http://www.highpoint-tech.com/.
  * This may be useful to anyone wanting to work on this driver, however  do not
  * trust  them too much since the code tends to become less and less meaningful
  * as the time passes... :-/
diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
index d81e496..c1d4d06 100644
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -9,8 +9,6 @@
  *
  *  Author:    Mikko Ala-Fossi            <maf@iki.fi>
  *             Jan Evert van Grootheest   <j.e.van.grootheest@caiway.nl>
- *
- *  Try:  http://www.maf.iki.fi/~maf/ht6560b/
  */
 
 #define DRV_NAME	"ht6560b"
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index e3ea591..baecd2b 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -16,7 +16,7 @@
  *
  * For further information regarding this notice, see:
  *
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://oss.sgi.com/projects/failsafe/docs/LnxFailSafe_PG/html/fpcontent.html 
  */
 
 #include <linux/module.h>
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 89d70de..cf769f1 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -16,7 +16,7 @@ config INFINIBAND_USER_MAD
 	  Userspace InfiniBand Management Datagram (MAD) support.  This
 	  is the kernel side of the userspace MAD support, which allows
 	  userspace processes to send and receive MADs. You will also
-	  need libibumad from <http://www.openib.org>.
+	  need libibumad from <http://openfabrics.org/>.
 
 config INFINIBAND_USER_ACCESS
 	tristate "InfiniBand userspace access (verbs and CM)"
@@ -28,7 +28,7 @@ config INFINIBAND_USER_ACCESS
 	  to set up connections and directly access InfiniBand
 	  hardware for fast-path operations.  You will also need
 	  libibverbs, libibcm and a hardware driver library from
-	  <http://www.openib.org>.
+	  <git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git>.
 
 config INFINIBAND_USER_MEM
 	bool
diff --git a/drivers/infiniband/hw/cxgb3/Kconfig b/drivers/infiniband/hw/cxgb3/Kconfig
index 2acec3f..2b6352b 100644
--- a/drivers/infiniband/hw/cxgb3/Kconfig
+++ b/drivers/infiniband/hw/cxgb3/Kconfig
@@ -10,7 +10,7 @@ config INFINIBAND_CXGB3
 	  our website at <http://www.chelsio.com>.
 
 	  For customer support, please visit our customer support page at
-	  <http://www.chelsio.com/support.htm>.
+	  <http://www.chelsio.com/support.html>.
 
 	  Please send feedback to <linux-bugs@chelsio.com>.
 
diff --git a/drivers/infiniband/hw/cxgb4/Kconfig b/drivers/infiniband/hw/cxgb4/Kconfig
index ccb85ea..6b7e6c5 100644
--- a/drivers/infiniband/hw/cxgb4/Kconfig
+++ b/drivers/infiniband/hw/cxgb4/Kconfig
@@ -10,7 +10,7 @@ config INFINIBAND_CXGB4
 	  our website at <http://www.chelsio.com>.
 
 	  For customer support, please visit our customer support page at
-	  <http://www.chelsio.com/support.htm>.
+	  <http://www.chelsio.com/support.html>.
 
 	  Please send feedback to <linux-bugs@chelsio.com>.
 
diff --git a/drivers/infiniband/ulp/iser/Kconfig b/drivers/infiniband/ulp/iser/Kconfig
index b411c51..9273f44 100644
--- a/drivers/infiniband/ulp/iser/Kconfig
+++ b/drivers/infiniband/ulp/iser/Kconfig
@@ -9,4 +9,4 @@ config INFINIBAND_ISER
 
 	  The iSER protocol is defined by IETF.
 	  See <http://www.ietf.org/rfc/rfc5046.txt>
-	  and <http://www.infinibandta.org/members/spec/Annex_iSER.PDF>
+	  and <http://www.infinibandta.org/content/pages.php?pg=technology_download>
diff --git a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/gamecon.c
index 0ffaf2c..2463b95 100644
--- a/drivers/input/joystick/gamecon.c
+++ b/drivers/input/joystick/gamecon.c
@@ -521,9 +521,8 @@ static void gc_multi_process_packet(struct gc *gc)
  * PSX support
  *
  * See documentation at:
- *	http://www.dim.com/~mackys/psxmemcard/ps-eng2.txt
+ *	http://forethought.net/	
  *	http://www.gamesx.com/controldata/psxcont/psxcont.htm
- *	ftp://milano.usal.es/pablo/
  *
  */
 
diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 2b0eba6..9007600 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -230,7 +230,7 @@ static unsigned short keymap_gtalk(int scancode)
 
 /*
  * Keymap for Allied-Telesis Corega USBPH01
- * http://www.alliedtelesis-corega.com/2/1344/1437/1360/chprd.html
+ * http://web.archive.org/web/*/http://www.alliedtelesis-corega.com/2/1344/1437/1360/chprd.html 
  *
  * Contributed by july@nat.bg
  */
@@ -259,8 +259,8 @@ static unsigned short keymap_usbph01(int scancode)
 
 /*
  * Keymap for ATCom AU-100
- * http://www.atcom.cn/En_products_AU100.html
- * http://www.packetizer.com/products/au100/
+ * http://www.atcom.cn/products.html 
+ * http://web.archive.org/web/*/http://www.packetizer.com/products/au100/ 
  * http://www.voip-info.org/wiki/view/AU-100
  *
  * Contributed by daniel@gimpelevich.san-francisco.ca.us
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index c714ca2..a29a870 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -27,10 +27,7 @@ config MOUSE_PS2
 
 	  Synaptics, ALPS or Elantech TouchPad users might be interested
 	  in a specialized Xorg/XFree86 driver at:
-		<http://w1.894.telia.com/~u89404340/touchpad/index.html>
-	  and a new version of GPM at:
-		<http://www.geocities.com/dt_or/gpm/gpm.html>
-	  to take advantage of the advanced features of the touchpad.
+		<http://cgit.freedesktop.org/xorg/driver/xf86-input-synaptics/>
 
 	  If unsure, say Y.
 
diff --git a/drivers/input/mouse/touchkit_ps2.c b/drivers/input/mouse/touchkit_ps2.c
index 88121c5..d362c7a 100644
--- a/drivers/input/mouse/touchkit_ps2.c
+++ b/drivers/input/mouse/touchkit_ps2.c
@@ -22,7 +22,7 @@
  * Based upon touchkitusb.c
  *
  * Vendor documentation is available in support section of:
- * http://www.egalax.com.tw/
+ * http://home.eeti.com.tw/web20/eg/drivers.htm 
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscreen/mk712.c
index efd3aeb..094f590 100644
--- a/drivers/input/touchscreen/mk712.c
+++ b/drivers/input/touchscreen/mk712.c
@@ -17,7 +17,7 @@
  * found in Gateway AOL Connected Touchpad computers.
  *
  * Documentation for ICS MK712 can be found at:
- *	http://www.icst.com/pdf/mk712.pdf
+ *	http://www.idt.com/products/getDoc.cfm?docID=18713923	
  */
 
 /*
diff --git a/drivers/isdn/i4l/isdn_audio.c b/drivers/isdn/i4l/isdn_audio.c
index 861bdf3..d501393 100644
--- a/drivers/isdn/i4l/isdn_audio.c
+++ b/drivers/isdn/i4l/isdn_audio.c
@@ -439,7 +439,7 @@ isdn_audio_xlaw2adpcm(adpcm_state * s, int fmt, unsigned char *in,
 
 /*
  * Goertzel algorithm.
- * See http://ptolemy.eecs.berkeley.edu/~pino/Ptolemy/papers/96/dtmf_ict/
+ * See http://ptolemy.eecs.berkeley.edu/papers/96/dtmf_ict/ 
  * for more info.
  * Result is stored into an sk_buff and queued up for later
  * evaluation.
diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index 26d44c3..6aab456 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -19,7 +19,7 @@
  *
  * Jan 2001: fix CISCO HDLC      Bjoern A. Zeeb <i4l@zabbadoz.net>
  *           for info on the protocol, see 
- *           http://i4l.zabbadoz.net/i4l/cisco-hdlc.txt
+ *          http://www.nethelp.no/net/cisco-hdlc.txt 
  */
 
 #include <linux/isdn.h>
diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
index d0d2213..e9425b5 100644
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -4,8 +4,8 @@
  * Copyright (C) 2003, 2004 Colin Leroy, Rasmus Rohde, Benjamin Herrenschmidt
  *
  * Documentation from
- * http://www.analog.com/UploadedFiles/Data_Sheets/115254175ADT7467_pra.pdf
- * http://www.analog.com/UploadedFiles/Data_Sheets/3686221171167ADT7460_b.pdf
+ * http://www.onsemi.com/PowerSolutions/product.do?id=ADT7467 
+ * http://www.onsemi.com/PowerSolutions/product.do?id=ADT7460 
  *
  */
 
diff --git a/drivers/media/IR/keymaps/rc-manli.c b/drivers/media/IR/keymaps/rc-manli.c
index 1e9fbfa..0f590b3 100644
--- a/drivers/media/IR/keymaps/rc-manli.c
+++ b/drivers/media/IR/keymaps/rc-manli.c
@@ -13,7 +13,6 @@
 #include <media/rc-map.h>
 
 /* Michael Tokarev <mjt@tls.msk.ru>
-   http://www.corpit.ru/mjt/beholdTV/remote_control.jpg
    keytable is used by MANLI MTV00[0x0c] and BeholdTV 40[13] at
    least, and probably other cards too.
    The "ascii-art picture" below (in comments, first row
diff --git a/drivers/media/IR/keymaps/rc-rc5-tv.c b/drivers/media/IR/keymaps/rc-rc5-tv.c
index 73cce2f..61be0bd 100644
--- a/drivers/media/IR/keymaps/rc-rc5-tv.c
+++ b/drivers/media/IR/keymaps/rc-rc5-tv.c
@@ -13,7 +13,7 @@
 #include <media/rc-map.h>
 
 /* generic RC5 keytable                                          */
-/* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
+/* see http://web.archive.org/web/*/http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
 /* used by old (black) Hauppauge remotes                         */
 
 static struct ir_scancode rc5_tv[] = {
diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb/frontends/mt312.c
index 472907d..5172311 100644
--- a/drivers/media/dvb/frontends/mt312.c
+++ b/drivers/media/dvb/frontends/mt312.c
@@ -20,8 +20,9 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
     References:
-    http://products.zarlink.com/product_profiles/MT312.htm
-    http://products.zarlink.com/product_profiles/SL1935.htm
+    http://www.zarlink.com/zarlink/hs/71.htm 
+    http://www.chipcatalog.com/Zarlink/MT312.htm
+    http://www.chipcatalog.com/Zarlink/SL1935.htm
 */
 
 #include <linux/delay.h>
diff --git a/drivers/media/dvb/frontends/mt312.h b/drivers/media/dvb/frontends/mt312.h
index 29e3bb5..8fdfe6c 100644
--- a/drivers/media/dvb/frontends/mt312.h
+++ b/drivers/media/dvb/frontends/mt312.h
@@ -19,8 +19,9 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
     References:
-    http://products.zarlink.com/product_profiles/MT312.htm
-    http://products.zarlink.com/product_profiles/SL1935.htm
+    http://www.zarlink.com/zarlink/hs/71.htm
+    http://www.chipcatalog.com/Zarlink/MT312.htm 
+    http://www.chipcatalog.com/Zarlink/SL1935.htm
 */
 
 #ifndef MT312_H
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 1c79821..c709289 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2005 Andreas Oberritter <obi@linuxtv.org>
  *
- * based on pluto2.c 1.10 - http://instinct-wp8.no-ip.org/pluto/
+ * based on pluto2.c 1.10 - http://web.archive.org/web/*/http://instinct-wp8.no-ip.org/pluto/ 
  * 	by Dany Salman <salmandany@yahoo.fr>
  *	Copyright (c) 2004 TDF
  *
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index a6be529..87279d9 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -26,7 +26,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 
@@ -2290,13 +2290,7 @@ static int frontend_init(struct av7110 *av7110)
 /* Budgetpatch note:
  * Original hardware design by Roberto Deza:
  * There is a DVB_Wiki at
- * http://212.227.36.83/linuxtv/wiki/index.php/Main_Page
- * where is described this 'DVB TT Budget Patch', on Card Modding:
- * http://212.227.36.83/linuxtv/wiki/index.php/DVB_TT_Budget_Patch
- * On the short description there is also a link to a external file,
- * with more details:
- * http://perso.wanadoo.es/jesussolano/Ttf_tsc1.zip
- *
+ * http://www.linuxtv.org/
  * New software triggering design by Emard that works on
  * original Roberto Deza's hardware:
  *
diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/dvb/ttpci/av7110_av.c
index 13efba9..878da6a 100644
--- a/drivers/media/dvb/ttpci/av7110_av.c
+++ b/drivers/media/dvb/ttpci/av7110_av.c
@@ -25,7 +25,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 #include <linux/types.h>
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index 4eba35a..7564c26 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -25,7 +25,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/media/dvb/ttpci/av7110_hw.c b/drivers/media/dvb/ttpci/av7110_hw.c
index e162691..f1cbfe5 100644
--- a/drivers/media/dvb/ttpci/av7110_hw.c
+++ b/drivers/media/dvb/ttpci/av7110_hw.c
@@ -22,7 +22,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 /* for debugging ARM communication: */
diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/dvb/ttpci/av7110_v4l.c
index 8986d96..ac20c5b 100644
--- a/drivers/media/dvb/ttpci/av7110_v4l.c
+++ b/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -22,7 +22,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index 983672a..97afc01 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -30,7 +30,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 #include "budget.h"
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 13ac9e3..a9c2c32 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -26,7 +26,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/dvb/ttpci/budget-core.c b/drivers/media/dvb/ttpci/budget-core.c
index ba18e56..0546613 100644
--- a/drivers/media/dvb/ttpci/budget-core.c
+++ b/drivers/media/dvb/ttpci/budget-core.c
@@ -31,7 +31,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 
diff --git a/drivers/media/dvb/ttpci/budget-patch.c b/drivers/media/dvb/ttpci/budget-patch.c
index 9c92f9d..5798355 100644
--- a/drivers/media/dvb/ttpci/budget-patch.c
+++ b/drivers/media/dvb/ttpci/budget-patch.c
@@ -27,7 +27,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 #include "av7110.h"
diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index 874a10a..d238fb9 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -31,7 +31,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/dvb/
+ * the project's page is at http://www.linuxtv.org/ 
  */
 
 #include "budget.h"
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 83567b8..c199ed9 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -24,7 +24,7 @@ config RADIO_CADET
 	  <file:Documentation/video4linux/API.html>.
 
 	  Further documentation on this driver can be found on the WWW at
-	  <http://linux.blackhawke.net/cadet/>.
+	  <http://web.archive.org/web/*/http://linux.blackhawke.net/cadet/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-cadet.
@@ -237,7 +237,7 @@ config RADIO_SF16FMR2
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux API.  Information on
 	  this API and pointers to "v4l" programs may be found on the WWW at
-	  <http://roadrunner.swansea.uk.linux.org/v4l.shtml>.
+	  <http://web.archive.org/web/*/http://roadrunner.swansea.uk.linux.org/v4l.shtml>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-sf16fmr2.
diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index c223113..6068610 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -10,9 +10,6 @@
  * Scott McGrath    (smcgrath@twilight.vtc.vsc.edu)
  * William McGrath  (wmcgrath@twilight.vtc.vsc.edu)
  *
- * The basis for this code may be found at http://bigbang.vtc.vsc.edu/fmradio/
- * along with more information on the card itself.
- *
  * History:
  * 1999-02-24	Russell Kroll <rkroll@exploits.org>
  *		Fine tuning/VIDEO_TUNER_LOW
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 4349213..78a777d 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -13,7 +13,7 @@
  * anybody does please mail me.
  *
  * For the pdf file see:
- * http://www.semiconductors.philips.com/pip/TEA5757H/V1
+ * http://www.nxp.com/ 
  *
  *
  * CHANGES:
diff --git a/drivers/media/radio/radio-typhoon.c b/drivers/media/radio/radio-typhoon.c
index 0343928..a5363ed 100644
--- a/drivers/media/radio/radio-typhoon.c
+++ b/drivers/media/radio/radio-typhoon.c
@@ -1,8 +1,6 @@
 /* Typhoon Radio Card driver for radio support
  * (c) 1999 Dr. Henrik Seidel <Henrik.Seidel@gmx.de>
  *
- * Card manufacturer:
- * http://194.18.155.92/idc/prod2.idc?nr=50753&lang=e
  *
  * Notes on the hardware
  *
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f6e4d04..0f669ee 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -978,7 +978,7 @@ config USB_STKWEBCAM
 	  Supported devices are typically found in some Asus laptops,
 	  with USB id 174f:a311 and 05e1:0501. Other Syntek cameras
 	  may be supported by the stk11xx driver, from which this is
-	  derived, see http://stk11xx.sourceforge.net
+	  derived, see http://sourceforge.net/projects/syntekdriver/ 
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called stkwebcam.
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 7af56cd..0c2f677 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -2290,7 +2290,7 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_addr	= ADDR_UNSET,
 	},
 	[BTTV_BOARD_SPIRIT_TV] = {
-		/* Spirit TV Tuner from http://spiritmodems.com.au */
+		/* Spirit TV Tuner from http://web.archive.org/web/*/http://spiritmodems.com.au */
 		/* Stafford Goodsell <surge@goliath.homeunix.org> */
 		.name           = "Spirit TV Tuner",
 		.video_inputs   = 3,
diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index be35e69..15cb0e1 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -4,7 +4,7 @@
  * sensor.
  *
  * The data sheet for this device can be found at:
- *    http://www.marvell.com/products/pcconn/88ALP01.jsp
+ *   http://www.marvell.com/products/pc_connectivity/88alp01/ 
  *
  * Copyright 2006 One Laptop Per Child Association, Inc.
  * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
diff --git a/drivers/media/video/cx18/cx18-cards.c b/drivers/media/video/cx18/cx18-cards.c
index 6b805af..7f65a4d 100644
--- a/drivers/media/video/cx18/cx18-cards.c
+++ b/drivers/media/video/cx18/cx18-cards.c
@@ -39,7 +39,7 @@ static struct cx18_card_tuner_i2c cx18_i2c_std = {
 	.tv    = { 0x61, 0x60, I2C_CLIENT_END },
 };
 
-/* Please add new PCI IDs to: http://pci-ids.ucw.cz/iii
+/* Please add new PCI IDs to: http://pci-ids.ucw.cz/
    This keeps the PCI ID database up to date. Note that the entries
    must be added under vendor 0x4444 (Conexant) as subsystem IDs.
    New vendor IDs should still be added to the vendor ID list. */
diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index abd64e8..64ae3f9 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -7,7 +7,7 @@
  *    (c) 2008 Steven Toth <stoth@linuxtv.org>
  *      - CX23885/7/8 support
  *
- *  Includes parts from the ivtv driver( http://ivtv.sourceforge.net/),
+ *  Includes parts from the ivtv driver(http://ivtvdriver.org/index.php/Main_Page),
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index e46e1ce..645f840 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -9,7 +9,7 @@
  *    (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
  *        - video_ioctl2 conversion
  *
- *  Includes parts from the ivtv driver( http://ivtv.sourceforge.net/),
+ *  Includes parts from the ivtv driver(http://ivtvdriver.org/index.php/Main_Page),
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index b984610..a76b468 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -2337,7 +2337,7 @@ EXPORT_SYMBOL(gspca_resume);
 /* -- cam driver utility functions -- */
 
 /* auto gain and exposure algorithm based on the knee algorithm described here:
-   http://ytse.tricolour.net/docs/LowLightOptimization.html
+   http://81.209.78.62:8080/docs/LowLightOptimization.html 
 
    Returns 0 if no changes were made, 1 if the gain and or exposure settings
    where changed. */
diff --git a/drivers/media/video/ivtv/ivtv-cards.c b/drivers/media/video/ivtv/ivtv-cards.c
index ca1fd32..4f9dbca 100644
--- a/drivers/media/video/ivtv/ivtv-cards.c
+++ b/drivers/media/video/ivtv/ivtv-cards.c
@@ -65,7 +65,7 @@ static struct ivtv_card_tuner_i2c ivtv_i2c_tda8290 = {
 
 /********************** card configuration *******************************/
 
-/* Please add new PCI IDs to: http://pci-ids.ucw.cz/iii
+/* Please add new PCI IDs to: http://pci-ids.ucw.cz/
    This keeps the PCI ID database up to date. Note that the entries
    must be added under vendor 0x4444 (Conexant) as subsystem IDs.
    New vendor IDs should still be added to the vendor ID list. */
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index ef0c817..b1dbcf1 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -3,7 +3,7 @@
 
     Copyright (C) 1998-2006 Michael Hunold <michael@mihu.de>
 
-    Visit http://www.mihu.de/linux/saa7146/mxb/
+    Visit http://www.themm.net/~mihu/linux/saa7146/mxb.html 
     for further details about this card.
 
     This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/video/pwc/philips.txt b/drivers/media/video/pwc/philips.txt
index d38dd79..751f114 100644
--- a/drivers/media/video/pwc/philips.txt
+++ b/drivers/media/video/pwc/philips.txt
@@ -1,6 +1,6 @@
 This file contains some additional information for the Philips and OEM webcams.
 E-mail: webcam@smcc.demon.nl                        Last updated: 2004-01-19
-Site: http://www.smcc.demon.nl/webcam/
+Site: http://web.archive.org/web/*/http://www.smcc.demon.nl/webcam/ 
 
 As of this moment, the following cameras are supported:
  * Philips PCA645
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index ec697fc..647169d 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -2343,8 +2343,8 @@ struct saa7134_board saa7134_boards[] = {
 		},
 	},
 	[SAA7134_BOARD_BEHOLD_409FM] = {
-		/* <http://tuner.beholder.ru>, Sergey <skiv@orel.ru> */
-		/*       Beholder Intl. Ltd. 2008      */
+		/* <http://www.beholder.ru/bb/viewtopic.php?t=1142>, */
+		/*  Sergey <skiv@orel.ru> Beholder Intl. Ltd. 2008 */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV 409 FM",
 		.audio_clock    = 0x00187de7,
diff --git a/drivers/media/video/sn9c102/sn9c102_pas202bcb.c b/drivers/media/video/sn9c102/sn9c102_pas202bcb.c
index 2782f94..2e86fdc 100644
--- a/drivers/media/video/sn9c102/sn9c102_pas202bcb.c
+++ b/drivers/media/video/sn9c102/sn9c102_pas202bcb.c
@@ -4,7 +4,6 @@
  *                                                                         *
  * Copyright (C) 2004 by Carlos Eduardo Medaglia Dyonisio                  *
  *                       <medaglia@undl.org.br>                            *
- *                       http://cadu.homelinux.com:8080/                   *
  *                                                                         *
  * Support for SN9C103, DAC Magnitude, exposure and green gain controls    *
  * added by Luca Risolia <luca.risolia@studio.unibo.it>                    *
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0b591b6..c6744ea 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -112,8 +112,8 @@ config IBM_ASM
 
 	  WARNING: This software may not be supported or function
 	  correctly on your IBM server. Please consult the IBM ServerProven
-	  website <http://www.pc.ibm.com/ww/eserver/xseries/serverproven> for
-	  information on the specific driver level and support statement
+	  website <http://www-03.ibm.com/systems/info/x86servers/serverproven/compat/us/> 
+	  for information on the specific driver level and support statement
 	  for your IBM server.
 
 config PHANTOM
diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 1e2cbf5..6f08a26 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -292,9 +292,9 @@ config RFD_FTL
 	---help---
 	  This provides support for the flash translation layer known
 	  as the Resident Flash Disk (RFD), as used by the Embedded BIOS
-	  of General Software. There is a blurb at:
+	  of General Software. 
 
-		http://www.gensw.com/pages/prod/bios/rfd.htm
+		http://www.phoenix.com/	
 
 config SSFDC
 	tristate "NAND SSFDC (SmartMedia) read only translation layer"
diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 3e6c47b..17f5305 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -418,8 +418,7 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
 
 			/*
 			 * Valid primary extension versions are: 1.0, 1.1, 1.2, 1.3, 1.4
-			 * see: http://www.amd.com/us-en/assets/content_type/DownloadableAssets/cfi_r20.pdf, page 19
-			 *      http://www.amd.com/us-en/assets/content_type/DownloadableAssets/cfi_100_20011201.pdf
+			 * see: http://www.amd.com/
 			 *      http://www.spansion.com/Support/Datasheets/s29ws-p_00_a12_e.pdf
 			 */
 			if (extp->MajorVersion != '1' ||
diff --git a/drivers/mtd/devices/lart.c b/drivers/mtd/devices/lart.c
index f4359fe..56599e8 100644
--- a/drivers/mtd/devices/lart.c
+++ b/drivers/mtd/devices/lart.c
@@ -17,7 +17,7 @@
  *           - January 2000
  *
  *    [2] MTD internal API documentation
- *           - http://www.linux-mtd.infradead.org/tech/
+ *           - http://www.linux-mtd.infradead.org/
  *
  * Limitations:
  *
diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index 4d6a64c..030e963 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -51,7 +51,7 @@
 
     Use of the FTL format for non-PCMCIA applications may be an
     infringement of these patents.  For additional information,
-    contact M-Systems (http://www.m-sys.com) directly.
+    contact (http://www.sandisk.com/).
 
 ======================================================================*/
 #include <linux/mtd/blktrans.h>
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 701d942..5d32e20 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -172,7 +172,7 @@ config MTD_OCTAGON
 	  This provides a 'mapping' driver which supports the way in which
 	  the flash chips are connected in the Octagon-5066 Single Board
 	  Computer. More information on the board is available at
-	  <http://www.octagonsystems.com/CPUpages/5066.html>.
+	  <http://www.octagonsystems.com/products/5066.aspx>.
 
 config MTD_VMAX
 	tristate "JEDEC Flash device mapped on Tempustech VMAX SBC301"
@@ -256,8 +256,7 @@ config MTD_DILNETPC
 	depends on X86 && MTD_CONCAT && MTD_PARTITIONS && MTD_CFI_INTELEXT && BROKEN
 	help
 	  MTD map driver for SSV DIL/Net PC Boards "DNP" and "ADNP".
-	  For details, see <http://www.ssv-embedded.de/ssv/pc104/p169.htm>
- 	  and <http://www.ssv-embedded.de/ssv/pc104/p170.htm>
+	  For details, see <http://www.ssv-embedded.de/>
 
 config MTD_DILNETPC_BOOTSIZE
 	hex "Size of DIL/Net PC flash boot partition"
@@ -284,7 +283,7 @@ config MTD_TQM8XXL
 	  chips, currently uses AMD one. This 'mapping' driver supports
 	  that arrangement, allowing the CFI probe and command set driver
 	  code to communicate with the chips on the TQM8xxL board. More at
-	  <http://www.denx.de/embedded-ppc-en.html>.
+	  <http://www.denx.de/en/News/WebHome>.
 
 config MTD_RPXLITE
 	tristate "CFI Flash device mapped on RPX Lite or CLLF"
@@ -351,7 +350,7 @@ config MTD_DC21285
 	help
 	  This provides a driver for the flash accessed using Intel's
 	  21285 bridge used with Intel's StrongARM processors. More info at
-	  <http://www.intel.com/design/bridge/docs/21285_documentation.htm>.
+	  <http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=5719&lang=eng>.
 
 config MTD_IXP4XX
 	tristate "CFI Flash device mapped on Intel IXP4xx based systems"
@@ -532,9 +531,9 @@ config MTD_PISMO
 	depends on ARCH_VERSATILE
 	help
 	  This driver allows for discovery of PISMO modules - see
-	  <http://www.pismoworld.org/>.  These are small modules containing
-	  up to five memory devices (eg, SRAM, flash, DOC) described by an
-	  I2C EEPROM.
+	  <http://web.archive.org/web/*/http://www.pismoworld.org/>. 
+	  These are small modules containing up to five memory devices 
+	  (eg, SRAM, flash, DOC) described by an I2C EEPROM.
 
 	  This driver does not create any MTD maps itself; instead it
 	  creates MTD physmap and MTD SRAM platform devices.  If you
diff --git a/drivers/mtd/maps/dilnetpc.c b/drivers/mtd/maps/dilnetpc.c
index 0713e3a..63d0997 100644
--- a/drivers/mtd/maps/dilnetpc.c
+++ b/drivers/mtd/maps/dilnetpc.c
@@ -19,8 +19,7 @@
  * board: DNP/1486 and ADNP/1486. The DNP version has 2 megs of flash
  * ROM (Intel 28F016S3) and 8 megs of DRAM, the ADNP version has 4 megs
  * flash and 16 megs of RAM.
- * For details, see http://www.ssv-embedded.de/ssv/pc104/p169.htm
- * and http://www.ssv-embedded.de/ssv/pc104/p170.htm
+ * For details, see http://www.ssv-comm.de/en/products/index.php 
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/maps/pismo.c b/drivers/mtd/maps/pismo.c
index f4ce273..b42eecb 100644
--- a/drivers/mtd/maps/pismo.c
+++ b/drivers/mtd/maps/pismo.c
@@ -1,5 +1,5 @@
 /*
- * PISMO memory driver - http://www.pismoworld.org/
+ * PISMO memory driver - http://web.archive.org/web/*/http://www.pismoworld.org/ 
  *
  * For ARM Realview and Versatile platforms
  *
diff --git a/drivers/mtd/maps/sc520cdp.c b/drivers/mtd/maps/sc520cdp.c
index 85c1e56..c3eb3c0 100644
--- a/drivers/mtd/maps/sc520cdp.c
+++ b/drivers/mtd/maps/sc520cdp.c
@@ -20,7 +20,7 @@
  * The SC520CDP is an evaluation board for the Elan SC520 processor available
  * from AMD. It has two banks of 32-bit Flash ROM, each 8 Megabytes in size,
  * and up to 512 KiB of 8-bit DIL Flash ROM.
- * For details see http://www.amd.com/products/epd/desiging/evalboards/18.elansc520/520_cdp_brief/index.html
+ * For details see http://web.archive.org/web/*/http://www.amd.com/products/epd/desiging/evalboards/18.elansc520/520_cdp_brief/index.html 
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index db1dfc5..9fc8145 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -2,7 +2,7 @@
  * Driver for One Laptop Per Child ‘CAFÉ’ controller, aka Marvell 88ALP01
  *
  * The data sheet for this device can be found at:
- *    http://www.marvell.com/products/pcconn/88ALP01.jsp
+ *   http://www.marvell.com/products/pc_connectivity/88alp01/ 
  *
  * Copyright © 2006 Red Hat, Inc.
  * Copyright © 2006 David Woodhouse <dwmw2@infradead.org>
diff --git a/drivers/mtd/rfd_ftl.c b/drivers/mtd/rfd_ftl.c
index cc4d180..482493d 100644
--- a/drivers/mtd/rfd_ftl.c
+++ b/drivers/mtd/rfd_ftl.c
@@ -6,7 +6,7 @@
  * This type of flash translation layer (FTL) is used by the Embedded BIOS
  * by General Software. It is known as the Resident Flash Disk (RFD), see:
  *
- *	http://www.gensw.com/pages/prod/bios/rfd.htm
+ *	http://www.phoenix.com/	
  *
  * based on ftl.c
  */
diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index f5166dc..d6f23e5 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -28,7 +28,7 @@
 		MD 21403
 
 		Support and updates available at
-		http://www.scyld.com/network/rtl8139.html
+		http://www.penguincomputing.com/	
 
 		Twister-tuning table provided by Kinston
 		<shangh@realtek.com.tw>.
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 2cc81a5..a026fd7 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -169,9 +169,7 @@ config NET_SB1000
 	  a connection. Further documentation and the necessary scripts can be
 	  found at:
 
-	  <http://www.jacksonville.net/~fventuri/>
-	  <http://home.adelphia.net/~siglercm/sb1000.html>
-	  <http://linuxpower.cx/~cable/>
+	  <http://web.archive.org/web/*/http://www.jacksonville.net/~fventuri/>
 
 	  If you don't have this card, of course say N.
 
@@ -921,7 +919,7 @@ config SMC91X
 	  including the SMC91C94 and the SMC91C111. Say Y if you want it
 	  compiled into the kernel, and read the file
 	  <file:Documentation/networking/smc9.txt>  and the Ethernet-HOWTO,
-	  available from  <http://www.linuxdoc.org/docs.html#howto>.
+	  available from  <http://www.tldp.org/docs.html#howto>.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
@@ -1031,7 +1029,7 @@ config SMC911X
 	  including the new LAN9115, LAN9116, LAN9117, and LAN9118.
 	  Say Y if you want it compiled into the kernel, 
 	  and read the Ethernet-HOWTO, available from
-	  <http://www.linuxdoc.org/docs.html#howto>.
+	  <http://www.tldp.org/docs.html#howto>.
 
 	  This driver is also available as a module. The module will be 
 	  called smc911x.  If you want to compile it as a module, say M 
@@ -1511,10 +1509,6 @@ config E100
 
           to identify the adapter.
 
-	  For the latest Intel PRO/100 network driver for Linux, see:
-
-	  <http://appsr.intel.com/scripts-df/support_intel.asp>
-
 	  More specific information on configuring the driver is in 
 	  <file:Documentation/networking/e100.txt>.
 
@@ -1541,7 +1535,7 @@ config FEALNX
 	help
 	  Say Y here to support the Mysom MTD-800 family of PCI-based Ethernet
 	  cards. Specifications and data at
-	  <http://www.myson.com.hk/mtd/datasheet/>.
+	  <http://www.datasheetarchive.com/datasheet-pdf/022/DSA00384882.html>.
 
 config NATSEMI
 	tristate "National Semiconductor DP8381x series PCI Ethernet support"
@@ -1552,7 +1546,7 @@ config NATSEMI
 	  which is used in cards from PureData, NetGear, Linksys
 	  and others, including the 83815 chip.
 	  More specific information and updates are available from
-	  <http://www.scyld.com/network/natsemi.html>.
+	  <http://www.penguincomputing.com/>.
 
 config NE2K_PCI
 	tristate "PCI NE2000 and clones support (see help)"
@@ -1703,7 +1697,7 @@ config EPIC100
 	  This driver is for the SMC EtherPower II 9432 PCI Ethernet NIC,
 	  which is based on the SMC83c17x (EPIC/100).
 	  More specific information and updates are available from
-	  <http://www.scyld.com/network/epic100.html>.
+	  <http://www.penguincomputing.com/>.
 
 config SMSC9420
 	tristate "SMSC LAN9420 PCI ethernet adapter support"
@@ -1715,7 +1709,7 @@ config SMSC9420
 	  This is a driver for SMSC's LAN9420 PCI ethernet adapter.
 	  Say Y if you want it compiled into the kernel,
 	  and read the Ethernet-HOWTO, available from
-	  <http://www.linuxdoc.org/docs.html#howto>.
+	  <http://www.tldp.org/docs.html#howto>.
 
 	  This driver is also available as a module. The module will be
 	  called smsc9420.  If you want to compile it as a module, say M
@@ -1729,7 +1723,7 @@ config SUNDANCE
 	help
 	  This driver is for the Sundance "Alta" chip.
 	  More specific information and updates are available from
-	  <http://www.scyld.com/network/sundance.html>.
+	  <http://www.penguincomputing.com/>.
 
 config SUNDANCE_MMIO
 	bool "Use MMIO instead of PIO"
@@ -2201,7 +2195,7 @@ config YELLOWFIN
 	  Say Y here if you have a Packet Engines G-NIC PCI Gigabit Ethernet
 	  adapter or the SYM53C885 Ethernet controller. The Gigabit adapter is
 	  used by the Beowulf Linux cluster project.  See
-	  <http://cesdis.gsfc.nasa.gov/linux/drivers/yellowfin.html> for more
+	  <http://www.beowulf.org/> for more
 	  information about this driver in particular and Beowulf in general.
 
 	  To compile this driver as a module, choose M here: the module
@@ -2550,7 +2544,7 @@ config CHELSIO_T1
           our website at <http://www.chelsio.com>.
 
           For customer support, please visit our customer support page at
-          <http://www.chelsio.com/support.htm>.
+          <http://www.chelsio.com/support.html>.
 
           Please send feedback to <linux-bugs@chelsio.com>.
 
@@ -2582,7 +2576,7 @@ config CHELSIO_T3
 	  our website at <http://www.chelsio.com>.
 
 	  For customer support, please visit our customer support page at
-	  <http://www.chelsio.com/support.htm>.
+	  <http://www.chelsio.com/support.html>.
 
 	  Please send feedback to <linux-bugs@chelsio.com>.
 
@@ -2607,7 +2601,7 @@ config CHELSIO_T4
 	  our website at <http://www.chelsio.com>.
 
 	  For customer support, please visit our customer support page at
-	  <http://www.chelsio.com/support.htm>.
+	  <http://www.chelsio.com/support.html>.
 
 	  Please send feedback to <linux-bugs@chelsio.com>.
 
@@ -2630,7 +2624,7 @@ config CHELSIO_T4VF
 	  our website at <http://www.chelsio.com>.
 
 	  For customer support, please visit our customer support page at
-	  <http://www.chelsio.com/support.htm>.
+	  <http://www.chelsio.com/support.html>.
 
 	  Please send feedback to <linux-bugs@chelsio.com>.
 
@@ -3048,7 +3042,6 @@ config PLIP
 	  <file:Documentation/networking/PLIP.txt>.  The cables can be up to
 	  15m long.  Mode 0 works also if one of the machines runs DOS/Windows
 	  and has some PLIP software installed, e.g. the Crynwr PLIP packet
-	  driver (<http://oak.oakland.edu/simtel.net/msdos/pktdrvr-pre.html>)
 	  and winsock or NCSA's telnet.
 
 	  If you want to use PLIP, say Y and read the PLIP mini-HOWTO as well
@@ -3262,8 +3255,8 @@ config SLIP_COMPRESSED
 	  <ftp://ibiblio.org/pub/Linux/system/network/serial/>) which
 	  allows you to use SLIP over a regular dial up shell connection, you
 	  definitely want to say Y here. The NET-3-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, explains how to configure
-	  CSLIP. This won't enlarge your kernel.
+	  <http://web.archive.org/web/*/http://www.bart.nl/~patrickr/term-howto/Term-HOWTO.html>,
+	  explains how to configure CSLIP. This won't enlarge your kernel.
 
 config SLHC
 	tristate
diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index b9a5916..ecfa01a 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -440,7 +440,7 @@ MODULE_PARM_DESC(tx_ratio, "AceNIC/3C985/GA620 ratio of NIC memory used for TX/R
 
 static const char version[] __devinitconst =
   "acenic.c: v0.92 08/05/2002  Jes Sorensen, linux-acenic@SunSITE.dk\n"
-  "                            http://home.cern.ch/~jes/gige/acenic.html\n";
+  "                            http://web.archive.org/web/20071219235833/jes.web.cern.ch/jes/gige/acenic.html\n";
 
 static int ace_get_settings(struct net_device *, struct ethtool_cmd *);
 static int ace_set_settings(struct net_device *, struct ethtool_cmd *);
diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index 0a0e0cd..9368cfa 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -10,15 +10,15 @@ config ATALK
 	  wish to connect to it, say Y.  You will need to use the netatalk package
 	  so that your Linux box can act as a print and file server for Macs as
 	  well as access AppleTalk printers.  Check out
-	  <http://www.zettabyte.net/netatalk/> on the WWW for details.
+	  <http://cgi.zettabyte.net/> on the WWW for details.
 	  EtherTalk is the name used for AppleTalk over Ethernet and the
 	  cheaper and slower LocalTalk is AppleTalk over a proprietary Apple
 	  network using serial links.  EtherTalk and LocalTalk are fully
 	  supported by Linux.
 
 	  General information about how to connect Linux, Windows machines and
-	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.  The
-	  NET-3-HOWTO, available from
+	  Macs is on the WWW at <http://en.wikibooks.org/wiki/Linux_Networking/Appletalk_%28AF_APPLETALK%29>.
+	  The NET-3-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>, contains valuable
 	  information as well.
 
diff --git a/drivers/net/atp.c b/drivers/net/atp.c
index bd2f9d3..7219604 100644
--- a/drivers/net/atp.c
+++ b/drivers/net/atp.c
@@ -68,7 +68,7 @@ static int xcvr[NUM_UNITS]; 			/* The data transfer mode. */
 
 	In 1997 Realtek made available the documentation for the second generation
 	RTL8012 chip, which has lead to several driver improvements.
-	  http://www.realtek.com.tw/cn/cn.html
+	 http://www.realtek.com.tw/ 
 
 					Theory of Operation
 
diff --git a/drivers/net/epic100.c b/drivers/net/epic100.c
index 57c8ac0..b9a934b 100644
--- a/drivers/net/epic100.c
+++ b/drivers/net/epic100.c
@@ -18,8 +18,7 @@
 	Annapolis MD 21403
 
 	Information and updates available at
-	http://www.scyld.com/network/epic100.html
-	[this link no longer provides anything useful -jgarzik]
+	http://www.silan.com.cn/All/Default.aspx	
 
 	---------------------------------------------------------------------
 
@@ -131,8 +130,8 @@ IIIa. Ring buffers
 
 IVb. References
 
-http://www.smsc.com/main/tools/discontinued/83c171.pdf
-http://www.smsc.com/main/tools/discontinued/83c175.pdf
+http://www.smsc.com/media/Downloads_Public/discontinued/83c171.pdf
+http://www.smsc.com/media/Downloads_Public/discontinued/83c175.pdf
 http://scyld.com/expert/NWay.html
 http://www.national.com/pf/DP/DP83840A.html
 
diff --git a/drivers/net/fealnx.c b/drivers/net/fealnx.c
index d7e8f6b..759d456 100644
--- a/drivers/net/fealnx.c
+++ b/drivers/net/fealnx.c
@@ -14,7 +14,7 @@
 	Annapolis MD 21403
 
 	Support information and updates available at
-	http://www.scyld.com/network/pci-skeleton.html
+	http://www.penguincomputing.com/	
 
 	Linux kernel updates:
 
diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index 49aac70..f4523cd 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -20,9 +20,6 @@
 
 	Support and updates available at
 	http://www.scyld.com/network/hamachi.html
-	[link no longer provides useful info -jgarzik]
-	or
-	http://www.parl.clemson.edu/~keithu/hamachi.html
 
 */
 
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index 62d5d5c..1faa85b 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -73,7 +73,7 @@ config DMASCC
 	  certain parameters, such as channel access timing, clock mode, and
 	  DMA channel. This is accomplished with a small utility program,
 	  dmascc_cfg, available at
-	  <http://cacofonix.nt.tuwien.ac.at/~oe1kib/Linux/>. Please be sure to
+	  <http://www.linux-ax25.org/wiki/LinuxAX25>. Please be sure to
 	  get at least version 1.27 of dmascc_cfg, as older versions will not
 	  work with the current driver.
 
diff --git a/drivers/net/ibmlana.c b/drivers/net/ibmlana.c
index 294ccfb..8de3273 100644
--- a/drivers/net/ibmlana.c
+++ b/drivers/net/ibmlana.c
@@ -23,7 +23,7 @@ paper sources:
   'LAN Technical Reference Ethernet Adapter Interface Version 1 Release 1.0
    Document Number SC30-3661-00' by IBM for info on the adapter itself
 
-  Also see http://www.natsemi.com/
+  Also see http://www.national.com/analog 
 
 special acknowledgements to:
   - Bob Eager for helping me out with documentation from IBM
diff --git a/drivers/net/irda/donauboe.h b/drivers/net/irda/donauboe.h
index 36c3060..9e9a82d 100644
--- a/drivers/net/irda/donauboe.h
+++ b/drivers/net/irda/donauboe.h
@@ -54,7 +54,7 @@
 /* anyone who has. HOWEVER the chip bears a striking resemblence */
 /* to the IrDA controller in the Toshiba RISC TMPR3922 chip      */
 /* the documentation for this is freely available at             */
-/* http://www.toshiba.com/taec/components/Generic/TMPR3922.shtml */
+/* http://www.toshiba.com/tai/					 */
 /* The mapping between the registers in that document and the    */
 /* Registers in the 701 oboe chip are as follows    */
 
diff --git a/drivers/net/irda/ma600-sir.c b/drivers/net/irda/ma600-sir.c
index e912164..186697f 100644
--- a/drivers/net/irda/ma600-sir.c
+++ b/drivers/net/irda/ma600-sir.c
@@ -4,7 +4,7 @@
  * Version:       0.1
  * Description:   Implementation of the MA600 dongle
  * Status:        Experimental.
- * Author:        Leung <95Etwl@alumni.ee.ust.hk> http://www.engsvr.ust/~eetwl95
+ * Author:        Leung <95Etwl@alumni.ee.ust.hk> 
  * Created at:    Sat Jun 10 20:02:35 2000
  * Modified at:   Sat Aug 16 09:34:13 2003
  * Modified by:   Martin Diehl <mad@mdiehl.de> (modified for new sir_dev)
@@ -253,7 +253,7 @@ static int ma600_reset(struct sir_dev *dev)
 	return 0;
 }
 
-MODULE_AUTHOR("Leung <95Etwl@alumni.ee.ust.hk> http://www.engsvr.ust/~eetwl95");
+MODULE_AUTHOR("Leung <95Etwl@alumni.ee.ust.hk>");
 MODULE_DESCRIPTION("MA600 dongle driver version 0.1");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("irda-dongle-11"); /* IRDA_MA600_DONGLE */
diff --git a/drivers/net/lne390.c b/drivers/net/lne390.c
index 8a1097c..a154ca4 100644
--- a/drivers/net/lne390.c
+++ b/drivers/net/lne390.c
@@ -23,8 +23,8 @@
 	The shared memory address selection is also slightly different.
 	Note that shared memory address > 1MB are supported with this driver.
 
-	You can try <http://www.mylex.com> if you want more info, as I've
-	never even seen one of these cards.  :)
+	You can try <http://web.archive.org/web/*/http://www.mylex.com>
+	if you want more info, as I've never even seen one of these cards.  :)
 
 	Arnaldo Carvalho de Melo <acme@conectiva.com.br> - 2000/09/01
 	- get rid of check_region
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index a6033d4..a8c6d3c 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -19,9 +19,7 @@
 	Annapolis MD 21403
 
 	Support information and updates available at
-	http://www.scyld.com/network/netsemi.html
-	[link no longer provides useful info -jgarzik]
-
+	http://www.penguincomputing.com/	
 
 	TODO:
 	* big endian support with CFG:BEM instead of cpu_to_le32
@@ -207,9 +205,7 @@ recieve and transmit paths which are synchronised using a combination of
 hardware descriptor ownership, disabling interrupts and NAPI poll scheduling.
 
 IVb. References
-
-http://www.scyld.com/expert/100mbps.html
-http://www.scyld.com/expert/NWay.html
+http://www.penguincomputing.com/
 Datasheet is available from:
 http://www.national.com/pf/DP/DP83815.html
 
@@ -223,7 +219,7 @@ None characterised.
 /*
  * Support for fibre connections on Am79C874:
  * This phy needs a special setup when connected to a fibre cable.
- * http://www.amd.com/files/connectivitysolutions/networking/archivednetworking/22235.pdf
+ * http://web.archive.org/web/*/http://www.amd.com/files/connectivitysolutions/networking/archivednetworking/22235.pdf 
  */
 #define PHYID_AM79C874	0x0022561b
 
diff --git a/drivers/net/pci-skeleton.c b/drivers/net/pci-skeleton.c
index 56f3fc4..d654eff 100644
--- a/drivers/net/pci-skeleton.c
+++ b/drivers/net/pci-skeleton.c
@@ -78,7 +78,7 @@ that almost all frames will need to be copied to an alignment buffer.
 
 IVb. References
 
-http://www.realtek.com.tw/cn/cn.html
+http://www.realtek.com.tw/
 http://www.scyld.com/expert/NWay.html
 
 IVc. Errata
@@ -106,7 +106,7 @@ IVc. Errata
 
 static char version[] __devinitdata =
 	KERN_INFO NETDRV_DRIVER_LOAD_MSG "\n"
-	"  Support available from http://foo.com/bar/baz.html\n";
+	"  Support available from linux-wireless@vger.kernel.org\n";
 
 /* define to 1 to enable PIO instead of MMIO */
 #undef USE_IO_OPS
diff --git a/drivers/net/pcmcia/3c574_cs.c b/drivers/net/pcmcia/3c574_cs.c
index c683f77..230158b 100644
--- a/drivers/net/pcmcia/3c574_cs.c
+++ b/drivers/net/pcmcia/3c574_cs.c
@@ -62,7 +62,7 @@ invalid ramWidth is Very Bad.
 V. References
 
 http://www.scyld.com/expert/NWay.html
-http://www.national.com/pf/DP/DP83840.html
+http://www.national.com/opf/DP/DP83840A.html#Overview
 
 Thanks to Terry Murphy of 3Com for providing development information for
 earlier 3Com products.
diff --git a/drivers/net/sc92031.c b/drivers/net/sc92031.c
index 8c4067a..fd94fa1 100644
--- a/drivers/net/sc92031.c
+++ b/drivers/net/sc92031.c
@@ -15,7 +15,7 @@
  *  Rewritten for 2.6 by Cesar Eduardo Barros
  *
  *  A datasheet for this chip can be found at
- *  http://www.silan.com.cn/english/products/pdf/SC92031AY.pdf
+ *  http://www.silan.com.cn/All/Default.aspx 
  */
 
 /* Note about set_mac_address: I don't know how to change the hardware
diff --git a/drivers/net/sis900.h b/drivers/net/sis900.h
index 150511a..41f6d03 100644
--- a/drivers/net/sis900.h
+++ b/drivers/net/sis900.h
@@ -7,7 +7,7 @@
  *	preliminary Rev. 1.0 Nov. 10, 1998
  *   SiS 7014 Single Chip 100BASE-TX/10BASE-T Physical Layer Solution,
  *	preliminary Rev. 1.0 Jan. 18, 1998
- *   http://www.sis.com.tw/support/databook.htm
+ *   http://www.sis.com.tw/
  */
 
 /*
diff --git a/drivers/net/starfire.c b/drivers/net/starfire.c
index a42b687..3ce0c78 100644
--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -21,8 +21,7 @@
 	Annapolis MD 21403
 
 	Support and updates available at
-	http://www.scyld.com/network/starfire.html
-	[link no longer provides useful info -jgarzik]
+	http://www.penguincomputing.com/	
 
 */
 
@@ -282,8 +281,7 @@ IV. Notes
 IVb. References
 
 The Adaptec Starfire manuals, available only from Adaptec.
-http://www.scyld.com/expert/100mbps.html
-http://www.scyld.com/expert/NWay.html
+http://www.penguincomputing.com/
 
 IVc. Errata
 
diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
index 2678588..02bdc27 100644
--- a/drivers/net/sundance.c
+++ b/drivers/net/sundance.c
@@ -15,7 +15,7 @@
 	Annapolis MD 21403
 
 	Support and updates available at
-	http://www.scyld.com/network/sundance.html
+	http://www.penguincomputing.com/	
 	[link no longer provides useful info -jgarzik]
 	Archives of the mailing list are still available at
 	http://www.beowulf.org/pipermail/netdrivers/
@@ -193,8 +193,7 @@ IVb. References
 The Sundance ST201 datasheet, preliminary version.
 The Kendin KS8723 datasheet, preliminary version.
 The ICplus IP100 datasheet, preliminary version.
-http://www.scyld.com/expert/100mbps.html
-http://www.scyld.com/expert/NWay.html
+http://www.penguincomputing.com/
 
 IVc. Errata
 
diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
index ccee3ed..ef000b2 100644
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -78,7 +78,7 @@
  * 			     - Updated tlan.txt accordingly.
  * 			     - Adjusted minimum/maximum frame length.
  * 			     - There is now a TLAN website up at
- * 			       http://tlan.kernel.dk
+ * 			       http://hp.sourceforge.net/ 
  *
  * 	v1.7 April 07, 2000  - Started to implement custom ioctls. Driver now
  * 			       reports PHY information when used with Donald
diff --git a/drivers/net/tokenring/Kconfig b/drivers/net/tokenring/Kconfig
index c4137b0..d490b50 100644
--- a/drivers/net/tokenring/Kconfig
+++ b/drivers/net/tokenring/Kconfig
@@ -100,8 +100,7 @@ config TMS380TR
 	  read the Token-Ring mini-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  Also read the file <file:Documentation/networking/tms380tr.txt> or
-	  check <http://www.auk.cx/tms380tr/>.
+	  Also read the file <file:Documentation/networking/tms380tr.txt>
 
 	  To compile this driver as a module, choose M here: the module will be
 	  called tms380tr.
diff --git a/drivers/net/tokenring/tms380tr.c b/drivers/net/tokenring/tms380tr.c
index 435ef7d..ccc16d6 100644
--- a/drivers/net/tokenring/tms380tr.c
+++ b/drivers/net/tokenring/tms380tr.c
@@ -5,7 +5,7 @@
  *  Originally sktr.c: Written 1997 by Christoph Goos
  *
  *  A fine result of the Linux Systems Network Architecture Project.
- *  http://www.linux-sna.org
+ *  http://www.vanheusden.com/sna/ 
  *
  *  This software may be used and distributed according to the terms
  *  of the GNU General Public License, incorporated herein by reference.
diff --git a/drivers/net/tulip/Kconfig b/drivers/net/tulip/Kconfig
index 516713f..14c02e1 100644
--- a/drivers/net/tulip/Kconfig
+++ b/drivers/net/tulip/Kconfig
@@ -151,7 +151,7 @@ config ULI526X
 	select CRC32
 	---help---
 	  This driver is for ULi M5261/M5263 10/100M Ethernet Controller
-	  (<http://www.uli.com.tw/>).
+	  (<http://www.nvidia.com/page/uli_drivers.html>).
 
 	  To compile this driver as a module, choose M here. The module will
 	  be called uli526x.
diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
index 08555f8..c928261 100644
--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -32,7 +32,7 @@
 
 
 /*
- * Prolific PL-2301/PL-2302 driver ... http://www.prolifictech.com
+ * Prolific PL-2301/PL-2302 driver ...http://www.prolific.com.tw/ 
  *
  * The protocol and handshaking used here should be bug-compatible
  * with the Linux 2.2 "plusb" driver, by Deti Fliegl.
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index d08ce6a..c19f166 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -305,7 +305,7 @@ config DSCC4
 	  DSCC4 chipset.
 
 	  This is supposed to work with the four port card. Take a look at
-	  <http://www.cogenit.fr/dscc4/> for further information about the
+	  <http://www.cogenit.fr/> for further information about the
 	  driver.
 
 	  To compile this driver as a module, choose M here: the
@@ -409,15 +409,15 @@ config CYCLADES_SYNC
 	tristate "Cyclom 2X(tm) cards (EXPERIMENTAL)"
 	depends on WAN_ROUTER_DRIVERS && (PCI || ISA)
 	---help---
-	  Cyclom 2X from Cyclades Corporation <http://www.cyclades.com/> is an
+	  Cyclom 2X from Cyclades Corporation <http://www.avocent.com/> is an
 	  intelligent multiprotocol WAN adapter with data transfer rates up to
 	  512 Kbps. These cards support the X.25 and SNA related protocols.
 
 	  While no documentation is available at this time please grab the
 	  wanconfig tarball in
-	  <http://www.conectiva.com.br/~acme/cycsyn-devel/> (with minor changes
-	  to make it compile with the current wanrouter include files; efforts
-	  are being made to use the original package available at
+	  <http://web.archive.org/web/*/http://www.conectiva.com.br/~acme/cycsyn-devel/> 
+	  (with minor changes to make it compile with the current wanrouter include files;
+	  efforts are being made to use the original package available at
 	  <ftp://ftp.sangoma.com/>).
 
 	  Feel free to contact me or the cycsyn-devel mailing list at
@@ -481,8 +481,8 @@ config SBNI
 	  leased line modems.
 
 	  You can find more information and last versions of drivers and
-	  utilities at <http://www.granch.ru/>. If you have any question you
-	  can send email to <sbni@granch.ru>.
+	  utilities at <http://web.archive.org/web/*/http://www.granch.ru>.
+	  If you have any question you can send email to <sbni@granch.ru>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called sbni.
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 04c6cd4..bc8b3fa 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -28,8 +28,7 @@
  * Masaryk University (http://www.ics.muni.cz/). The hardware is
  * developed by Jiri Novotny <novotny@ics.muni.cz>. More information
  * and the photo of both cards is available at
- * http://www.pavoucek.cz/cosa.html. The card documentation, firmwares
- * and other goods can be downloaded from ftp://ftp.ics.muni.cz/pub/cosa/.
+ * http://web.archive.org/web/20010412025813/http://www.pavoucek.cz/cosa.html.
  * For Linux-specific utilities, see below in the "Software info" section.
  * If you want to order the card, contact Jiri Novotny.
  *
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index e050bd6..5ee8372 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -125,9 +125,7 @@ module_param_array(fst_excluded_list, int, NULL, 0);
 
 /*      The Am186CH/CC processors support a SmartDMA mode using circular pools
  *      of buffer descriptors. The structure is almost identical to that used
- *      in the LANCE Ethernet controllers. Details available as PDF from the
- *      AMD web site: http://www.amd.com/products/epd/processors/\
- *                    2.16bitcont/3.am186cxfa/a21914/21914.pdf
+ *      in the LANCE Ethernet controllers. 
  */
 struct txdesc {			/* Transmit descriptor */
 	volatile u16 ladr;	/* Low order address of packet. This is a
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index cff13a9..e8e77e9 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -8,7 +8,7 @@
  *	Driver supports SBNI12-02,-04,-05,-10,-11 cards, single and
  *	double-channel, PCI and ISA modifications.
  *	More info and useful utilities to work with SBNI12 cards you can find
- *	at http://www.granch.com (English) or http://www.granch.ru (Russian)
+ *	at http://web.archive.org/web/*/http://www.granch.com 
  *
  *	This software may be used and distributed according to the terms
  *	of the GNU General Public License.
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ea6362a..97659a0 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -351,7 +351,7 @@ struct ath5k_srev_name {
 /*
  * Some of this information is based on Documentation from:
  *
- * http://madwifi.org/wiki/ChipsetFeatures/SuperAG
+ * http://madwifi-project.org/wiki/ChipsetFeatures/SuperAG 
  *
  * Modulation for Atheros' eXtended Range - range enhancing extension that is
  * supposed to double the distance an Atheros client device can keep a
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 55b4ac6..e1f7fa8 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -23,10 +23,7 @@
  *
  * I tried to document those registers by looking at ar5k code, some
  * 802.11 (802.11e mostly) papers and by reading various public available
- * Atheros presentations and papers like these:
- *
- * 5210 - http://nova.stanford.edu/~bbaas/ps/isscc2002_slides.pdf
- *        http://www.it.iitb.ac.in/~janak/wifire/01222734.pdf
+ * Atheros presentations and papers:
  *
  * 5211 - http://www.hotchips.org/archives/hc14/3_Tue/16_mcfarland.pdf
  *
@@ -1047,8 +1044,7 @@
  *        check the eeprom status register
  *
  * For more infos check eeprom_* functs and the ar5k.c
- * file posted in madwifi-devel mailing list.
- * http://sourceforge.net/mailarchive/message.php?msg_id=8966525
+ * http://wireless.kernel.org/en/users/Drivers/ath5k 
  *
  */
 #define AR5K_EEPROM_BASE	0x6000
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index ba54d1b..813518a 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -214,8 +214,7 @@ static int prism2_pccard_card_present(local_info_t *local)
 
 /*
  * SanDisk CompactFlash WLAN Flashcard - Product Manual v1.0
- * Document No. 20-10-00058, January 2004
- * http://www.sandisk.com/pdf/industrial/ProdManualCFWLANv1.0.pdf
+ * http://www.sandisk.com
  */
 #define SANDISK_WLAN_ACTIVATION_OFF 0x40
 #define SANDISK_HCR_OFF 0x42
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index e8e2d0f..9f7e1d6 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -17,7 +17,7 @@
  *
  * Portions based on wvlan_cs.c 1.0.6, Copyright Andreas Neuhaus <andy
  * AT fasta.fh-dortmund.de>
- *      http://www.stud.fh-dortmund.de/~andy/wvlan/
+ *      http://www.stud.fh-dortmund.de/
  *
  * The contents of this file are subject to the Mozilla Public License
  * Version 1.1 (the "License"); you may not use this file except in
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index b0342a5..024fccc 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -8,7 +8,7 @@ config P54_COMMON
 	  also need to be enabled in order to support any devices.
 
 	  These devices require softmac firmware which can be found at
-	  http://prism54.org/
+	  http://wireless.kernel.org/en/users/Drivers/p54 
 
 	  If you choose to build a module, it'll be called p54common.
 
@@ -20,7 +20,7 @@ config P54_USB
 	  This driver is for USB isl38xx based wireless cards.
 
 	  These devices require softmac firmware which can be found at
-	  http://prism54.org/
+	  http://wireless.kernel.org/en/users/Drivers/p54 
 
 	  If you choose to build a module, it'll be called p54usb.
 
@@ -34,7 +34,7 @@ config P54_PCI
 	  supported by the fullmac driver/firmware.
 
 	  This driver requires softmac firmware which can be found at
-	  http://prism54.org/
+	  http://wireless.kernel.org/en/users/Drivers/p54
 
 	  If you choose to build a module, it'll be called p54pci.
 
diff --git a/drivers/net/wireless/prism54/islpci_hotplug.c b/drivers/net/wireless/prism54/islpci_hotplug.c
index dc14420..b5e64d7 100644
--- a/drivers/net/wireless/prism54/islpci_hotplug.c
+++ b/drivers/net/wireless/prism54/islpci_hotplug.c
@@ -38,7 +38,7 @@ module_param(init_pcitm, int, 0);
 /* In this order: vendor, device, subvendor, subdevice, class, class_mask,
  * driver_data
  * If you have an update for this please contact prism54-devel@prism54.org
- * The latest list can be found at http://prism54.org/supported_cards.php */
+ * The latest list can be found at http://wireless.kernel.org/en/users/Drivers/p54 */
 static DEFINE_PCI_DEVICE_TABLE(prism54_id_tbl) = {
 	/* Intersil PRISM Duette/Prism GT Wireless LAN adapter */
 	{
diff --git a/drivers/net/yellowfin.c b/drivers/net/yellowfin.c
index 4eb67ae..2900193 100644
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@ -198,8 +198,7 @@ IVb. References
 Yellowfin Engineering Design Specification, 4/23/97 Preliminary/Confidential
 Symbios SYM53C885 PCI-SCSI/Fast Ethernet Multifunction Controller Preliminary
    Data Manual v3.0
-http://cesdis.gsfc.nasa.gov/linux/misc/NWay.html
-http://cesdis.gsfc.nasa.gov/linux/misc/100mbps.html
+http://www.beowulf.org/
 
 IVc. Errata
 
diff --git a/drivers/parisc/README.dino b/drivers/parisc/README.dino
index 097324f..8194037 100644
--- a/drivers/parisc/README.dino
+++ b/drivers/parisc/README.dino
@@ -10,8 +10,7 @@
 ** PCI bus. HP-supplied graphics cards that utilize the PCI bus are
 ** not affected."
 **
-** REVISIT: "go/pci_defect" link below is stale.
-**	HP Internal can use <http://hpfcdma.fc.hp.com:80/Dino/>
+** http://www.hp.com/#Product 
 **
 **	Product		First Good Serial Number
 **  C200/C240 (US)	US67350000
diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 855f389..b578d2c 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -18,8 +18,8 @@ menuconfig PARPORT
 	  <file:drivers/parport/BUGS-parport>.
 
 	  For extensive information about drivers for many devices attaching
-	  to the parallel port see <http://www.torque.net/linux-pp.html> on
-	  the WWW.
+	  to the parallel port see 
+	  http://web.archive.org/web/*/http://www.torque.net/linux-pp.html.
 
 	  It is possible to share a single parallel port among several devices
 	  and it is safe to compile all the corresponding drivers into the
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 89ed181..58fc076 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -205,7 +205,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 	PCI_DEVICE_ID_INTEL_82439TX, 	quir
 /*
  *	VIA Apollo KT133 needs PCI latency patch
  *	Made according to a windows driver based patch by George E. Breese
- *	see PCI Latency Adjust on http://www.viahardware.com/download/viatweak.shtm
+ *	see PCI Latency Adjust on http://www.sudhian.com/ 
  *      Also see http://www.au-ja.org/review-kt133a-1-en.phtml for
  *      the info on which Mr Breese based his work.
  *
@@ -996,7 +996,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TOSHIBA,	0x605,	quirk_transparent_bridge)
 /*
  * Common misconfiguration of the MediaGX/Geode PCI master that will
  * reduce PCI bandwidth from 70MB/s to 25MB/s.  See the GXM/GXLV/GX1
- * datasheets found at http://www.national.com/ds/GX for info on what
+ * datasheets found at http://www.national.com/analog for info on what
  * these bits do.  <christer@weinigel.se>
  */
 static void quirk_mediagx_master(struct pci_dev *dev)
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 414d9a6..91a7225 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1073,7 +1073,7 @@ static void yenta_config_init(struct yenta_socket *socket)
  * invisible during PCI scans because of a misconfigured subordinate number
  * of the parent brige - some BIOSes seem to be too lazy to set it right.
  * Does the fixup carefully by checking how far it can go without conflicts.
- * See http\://bugzilla.kernel.org/show_bug.cgi?id=2944 for more information.
+ * See http://bugzilla.kernel.org/show_bug.cgi?id=2944 for more information.
  */
 static void yenta_fixup_parent_bridge(struct pci_bus *cardbus_bridge)
 {
diff --git a/drivers/pnp/pnpbios/proc.c b/drivers/pnp/pnpbios/proc.c
index 2d8ac43..bc89f39 100644
--- a/drivers/pnp/pnpbios/proc.c
+++ b/drivers/pnp/pnpbios/proc.c
@@ -11,7 +11,6 @@
  *
  * The .../escd file is utilized by the lsescd utility written by
  * Gunther Mayer.
- *     http://home.t-online.de/home/gunther.mayer/lsescd
  *
  * The .../legacy_device_resources file is not used yet.
  *
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index bbf91ae..ea98d4d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -116,7 +116,7 @@ config CHR_DEV_OSST
 	  <http://www.tldp.org/docs.html#howto>  and
 	  <file:Documentation/scsi/osst.txt>  in the kernel source.
 	  More info on the OnStream driver may be found on
-	  <http://linux1.onstream.nl/test/>
+	  <http://web.archive.org/web/*/http://linux1.onstream.nl/test/>
 	  Please also have a look at the standard st docu, as most of it
 	  applies to osst as well.
 
@@ -156,9 +156,9 @@ config CHR_DEV_SG
 	  directly, so you need some additional software which knows how to
 	  talk to these devices using the SCSI protocol:
 
-	  For scanners, look at SANE (<http://www.mostang.com/sane/>). For CD
+	  For scanners, look at SANE (<http://www.sane-project.org/>). For CD
 	  writer software look at Cdrtools
-	  (<http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/cdrecord.html>)
+	  (<http://cdrecord.berlios.de/private/cdrecord.html>)
 	  and for burning a "disk at once": CDRDAO
 	  (<http://cdrdao.sourceforge.net/>). Cdparanoia is a high
 	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
@@ -949,7 +949,7 @@ config SCSI_IPS
 	depends on PCI && SCSI
 	---help---
 	  This is support for the IBM ServeRAID hardware RAID controllers.
-	  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
+	  See <http://www.ibm.com/us/en/>
 	  for more information.  If this driver does not work correctly
 	  without modification please contact the author by email at
 	  <ipslinux@adaptec.com>.
@@ -1608,9 +1608,9 @@ config SCSI_DEBUG
 	  each with multiple dummy SCSI devices (disks). It defaults to one
 	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
 	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
-	  dummy disks are simulated, they share the same kernel RAM for 
-	  their storage. See <http://www.torque.net/sg/sdebug.html> for more
-	  information. This driver is primarily of use to those testing the
+	  dummy disks are simulated, they share the same kernel RAM for their 
+	  storage. See <http://sg.danny.cz/sg/sdebug26.html> 
+	  for more information. This driver is primarily of use to those testing the
 	  SCSI and block subsystems. If unsure, say N.
 
 config SCSI_MESH
diff --git a/drivers/scsi/arm/Kconfig b/drivers/scsi/arm/Kconfig
index a8587f1..53c645a 100644
--- a/drivers/scsi/arm/Kconfig
+++ b/drivers/scsi/arm/Kconfig
@@ -39,7 +39,7 @@ config SCSI_ARXESCSI
 	  HD discs from the then new A5000 on earlier models. This interface
 	  was either sold on its own or with an integral SCSI controller.
 	  Technical details on this NCR53c94-based device are available at
-	  <http://www.cryton.demon.co.uk/acornbits/scsi_arxe.html>
+	  <http://web.archive.org/web/*/http://www.cryton.demon.co.uk/acornbits/scsi_arxe.html>
 	  Say Y here to compile in support for the SCSI controller.
 
 config SCSI_CUMANA_2
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 9a4b69d..be29702 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -7,8 +7,6 @@
  See the file Documentation/scsi/ibmmca.txt for a detailed description
  of this driver, the commandline arguments and the history of its
  development.
- See the WWW-page: http://www.uni-mainz.de/~langm000/linux.html for latest
- updates, info and ADF-files for adapters supported by this driver.
 
  Alan Cox <alan@lxorguk.ukuu.org.uk>
  Updated for Linux 2.5.45 to use the new error handler, cleaned up the
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b02bdc6..705f541 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -555,8 +555,8 @@ static int inquiry_evpd_84(unsigned char * arr)
 static int inquiry_evpd_85(unsigned char * arr)
 {
 	int num = 0;
-	const char * na1 = "https://www.kernel.org/config";
-	const char * na2 = "http://www.kernel.org/log";
+	const char * na1 = "https://www.kernel.org";
+	const char * na2 = "http://www.kernel.org";
 	int plen, olen;
 
 	arr[num++] = 0x1;	/* lu, storage config */
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 24110f6..538f13f 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -924,7 +924,7 @@ static int broken_efr(struct uart_8250_port *up)
 	/*
 	 * Exar ST16C2550 "A2" devices incorrectly detect as
 	 * having an EFR, and report an ID of 0x0201.  See
-	 * http://www.exar.com/info.php?pdf=dan180_oct2004.pdf
+	 * http://www.exar.com/ 
 	 */
 	if (autoconfig_read_divisor_id(up) == 0x0201 && size_fifo(up) == 16)
 		return 1;
diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index f8d8a00..8e8ba66 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -30,7 +30,7 @@
 
 /*
  * Altera UART register definitions according to the Nios UART datasheet:
- * http://www.altera.com/literature/ds/ds_nios_uart.pdf
+ * http://web.archive.org/web/*/http://www.altera.com/literature/ds/ds_nios_uart.pdf 
  */
 
 #define ALTERA_UART_SIZE		32
diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 5318dd3..3e41fff 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -10,7 +10,7 @@
 
 /*
  * This driver and the hardware supported are in term of EE-191 of ADI.
- * http://www.analog.com/UploadedFiles/Application_Notes/399447663EE191.pdf
+ * http://www.analog.com/static/imported-files/application_notes/EE191.pdf
  * This application note describe how to implement a UART on a Sharc DSP,
  * but this driver is implemented on Blackfin Processor.
  * Transmit Frame Sync is not used by this driver to transfer data out.
diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport_uart.h
index 9ce253e..6d06ce1 100644
--- a/drivers/serial/bfin_sport_uart.h
+++ b/drivers/serial/bfin_sport_uart.h
@@ -10,7 +10,7 @@
 
 /*
  * This driver and the hardware supported are in term of EE-191 of ADI.
- * http://www.analog.com/UploadedFiles/Application_Notes/399447663EE191.pdf
+ * http://www.analog.com/static/imported-files/application_notes/EE191.pdf 
  * This application note describe how to implement a UART on a Sharc DSP,
  * but this driver is implemented on Blackfin Processor.
  * Transmit Frame Sync is not used by this driver to transfer data out.
diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index cff9a30..daead24 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -34,7 +34,7 @@
  *
  * For further information regarding this notice, see:
  *
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://oss.sgi.com/projects/failsafe/docs/LnxFailSafe_PG/html/fpcontent.html 
  */
 
 #include <linux/interrupt.h>
diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index 9b03d7b..3fa2e16 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -44,7 +44,7 @@ MODULE_DEVICE_TABLE(of, ulite_of_match);
  * Register definitions
  *
  * For register details see datasheet:
- * http://www.xilinx.com/bvdocs/ipcenter/data_sheet/opb_uartlite.pdf
+ * http://www.xilinx.com/support/documentation/ip_documentation/opb_uartlite.pdf 
  */
 
 #define ULITE_RX		0x00
diff --git a/drivers/staging/asus_oled/README b/drivers/staging/asus_oled/README
index 96b9717..b6f77c5 100644
--- a/drivers/staging/asus_oled/README
+++ b/drivers/staging/asus_oled/README
@@ -2,7 +2,7 @@
     Driver for Asus OLED display present in some Asus laptops.
 
     The code of this driver is based on 'asusoled' program taken from
-    https://launchpad.net/asusoled/. I just wanted to have a simple
+    http://lapsus.berlios.de/asus_oled.html. I just wanted to have a simple
     kernel driver for controlling this device, but I didn't know how
     to do that. Now I know ;) Also, that program can not be used
     with usbhid loaded, which means no USB mouse/keyboard while
diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 5b279fb..1cb2116 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -24,7 +24,7 @@
  *
  *
  *  Asus OLED support is based on asusoled program taken from
- *  https://launchpad.net/asusoled/.
+ *  http://lapsus.berlios.de/asus_oled.html.
  *
  *
  */
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c
index 60213d2..b59f2d4 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h
index 9698ae1..81346db 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
index fbc26a0..644bda4 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c
index a6898e4..07108f9 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h
index af1b9cd..cc3973d 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
index 0e498e9..14b13ea 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h
index 7b48110..358298b 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c
index 204d798..3f9cfa2 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h
index 61a21cc..31fbb0b 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c
index 148ce6f..8883e66 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h
index bf1b4c3..d8ad0b9 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
index 6360de5..0c890a9 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h
index eb7f101..ef4d887 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
index 344df94..7361d50 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h
index 03a93cb..537d475 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c
index de6f772..9e177f4 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h
index c4f1134..adcab82 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
index 97c10aa..90e71e1 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
index 622a4ac..9afdb13 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
index 8ed19bc..35a3ea1 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 5ed4b94..93d7c05 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index 1a28169..13621d4 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
index e0213a9..0aa11a0 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index d7d768e..b748efc 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h
index 22b3e56..89c99eb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 1369e22..74012e0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h
index 68db9c1..3c700c7 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
index faea003..6e06d9d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h
index e29a72a..7114acb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index b3b9218..b5d7d98 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h
index 0579033..647f9eb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
index 7948c41..70edc38 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h
index 21c09ed..4472829 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 4299ff5..806f76d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h
index 0780c44..c91594d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
index 8bc88ad..8ebb254 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
index 89783b1eb..7090c24 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h
index 639944c..c42612a 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
index d7d2223..73802ab 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h
index c971d14..ab145e7 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
index e01889c..ced101f 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h
index 63e5f1f..83f42af 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 851f71b..a813fdb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h
index fedfc9c..b3c8197 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h
@@ -9,7 +9,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index 560c848..5fd0303 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h
index f3e7ebf..812a9c4 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index 4ed441a..517e9ab 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h
index 743523e..63df635 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
index 2e20bc7..d3c5963 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
index 788d7c1..cce9e12 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index e0ac825..d3f29c8 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -2,7 +2,6 @@
    comedi/drivers/c6xdigio.c
 
    Hardware driver for Mechatronic Systems Inc. C6x_DIGIO DSP daughter card.
-   (http://robot0.ge.uiuc.edu/~spong/mecha/)
 
    COMEDI - Linux Control and Measurement Device Interface
    Copyright (C) 1999 Dan Block
@@ -31,7 +30,6 @@ Devices: [Mechatronic Systems Inc.] C6x_DIGIO DSP daughter card (c6xdigio)
 Updated: Sun Nov 20 20:18:34 EST 2005
 
 This driver will not work with a 2.4 kernel.
-http://robot0.ge.uiuc.edu/~spong/mecha/
 
 */
 
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index ced346a..e4cf861 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -37,7 +37,7 @@ Configuration Options:
 Developed from cb_pcidas and skel by Richard Bytheway (mocelet@sucs.org).
 Only supports DIO, AO and simple AI in it's present form.
 No interrupts, multi channel or FIFO AI, although the card looks like it could support this.
-See http://www.measurementcomputing.com/PDFManuals/pcim-das1602_16.pdf for more details.
+See http://www.mccdaq.com/specs.aspx for more details.
 */
 
 #include "../comedidev.h"
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 6af6c83..d3c9dbc 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -51,7 +51,7 @@ Configuration options:
    for the card, and here are the findings so far.
 
    1. A good document that describes the PCI interface chip is found at:
-      http://plx.plxtech.com/download/9080/databook/9080db-106.pdf
+      http://plx.plxtech.com/
 
    2. The initialization done so far is:
         a. program the FPGA (windows code sans a lot of error messages)
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 3acf7e6..1411dd8 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -37,7 +37,7 @@ boards has not
 yet been added to the driver, mainly due to the fact that
 I don't know the device id numbers.  If you have one
 of these boards,
-please file a bug report at https://bugs.comedi.org/
+please file a bug report at http://comedi.org/ 
 so I can get the necessary information from you.
 
 The 1200 series boards have onboard calibration dacs for correcting
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index bd16f91..a29a7bd 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -34,7 +34,7 @@
 	   340747b.pdf  AT-MIO E series Register Level Programmer Manual
 	   341079b.pdf  PCI E Series RLPM
 	   340934b.pdf  DAQ-STC reference manual
-	67xx and 611x registers (from http://www.ni.com/pdf/daq/us)
+	67xx and 611x registers (from http://www.ni.com/)
 	release_ni611x.pdf
 	release_ni67xx.pdf
 	Other possibly relevant info:
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index b44386a..b86dda1 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -41,7 +41,7 @@ supported.
    driver for the PCL-711.  I used a few ideas from his driver
    here.  His driver also has more comments, if you are
    interested in understanding how this driver works.
-   http://tech.buffalostate.edu/~dave/driver/
+   http://web.archive.org/web/*/http://tech.buffalostate.edu/~dave/driver/ 
 
    The ACL-8112 driver was hacked from the sources of the PCL-711
    driver (the 744 chip used on the 8112 is almost the same as
diff --git a/drivers/staging/comedi/drivers/plx9080.h b/drivers/staging/comedi/drivers/plx9080.h
index 485d63f..2a40a2b 100644
--- a/drivers/staging/comedi/drivers/plx9080.h
+++ b/drivers/staging/comedi/drivers/plx9080.h
@@ -13,7 +13,7 @@
  *
  ********************************************************************
  *
- * Copyright (C) 1999 RG Studio s.c., http://www.rgstudio.com.pl/
+ * Copyright (C) 1999 RG Studio s.c. 
  * Written by Krzysztof Halasa <khc@rgstudio.com.pl>
  *
  * Portions (C) SBE Inc., used by permission.
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 0367d2b..ddcc701 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -59,7 +59,7 @@ Configuration options:
     Data sheet: http://www.rtdusa.com/pdf/dm7520.pdf
     Example source: http://www.rtdusa.com/examples/dm/dm7520.zip
     Call them and ask for the register level manual.
-    PCI chip: http://www.plxtech.com/products/toolbox/9080.htm
+    PCI chip: http://www.plxtech.com/products/
 
     Notes:
     This board is memory mapped.  There is some IO stuff, but it isn't needed.
diff --git a/drivers/staging/go7007/go7007.txt b/drivers/staging/go7007/go7007.txt
index 06a76da..c053a1d 100644
--- a/drivers/staging/go7007/go7007.txt
+++ b/drivers/staging/go7007/go7007.txt
@@ -414,11 +414,11 @@ in the TDA8290/TDA8275 tuner driver.
 
 The following patches must be downloaded from Gerd Knorr's website and
 applied in the order listed:
-
-	http://dl.bytesex.org/patches/2.6.11-2/i2c-tuner
-	http://dl.bytesex.org/patches/2.6.11-2/i2c-tuner2
-	http://dl.bytesex.org/patches/2.6.11-2/v4l2-api-mpeg
-	http://dl.bytesex.org/patches/2.6.11-2/saa7134-update
+	
+	http://dl.bytesex.org/patches/`uname -r`/i2c-tuner
+	*i2c-tuner2
+	*v4l2-api-mpeg
+	*saa7134-update
 
 The following patches are included with this SDK and can be applied in any
 order:
diff --git a/drivers/staging/quickstart/quickstart.c b/drivers/staging/quickstart/quickstart.c
index 6612247..d58d769 100644
--- a/drivers/staging/quickstart/quickstart.c
+++ b/drivers/staging/quickstart/quickstart.c
@@ -4,9 +4,8 @@
  *
  *  Copyright (C) 2007-2010 Angelo Arrifano <miknix@gmail.com>
  *
- *  Information gathered from disassebled dsdt and from here:
- *  "http://download.microsoft.com/download/9/c/5/
- *  9c5b2167-8017-4bae-9fde-d599bac8184a/DirAppLaunch_Vista.doc"
+ *  Information gathered from disassebled dsdt here:
+ *  http://download.microsoft.com/
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/telephony/Kconfig b/drivers/telephony/Kconfig
index b5f78b6..fda68f7 100644
--- a/drivers/telephony/Kconfig
+++ b/drivers/telephony/Kconfig
@@ -31,7 +31,7 @@ config PHONE_IXJ
 	  isapnp support.  Please read <file:Documentation/telephony/ixj.txt>.
 
 	  For more information on these cards, see Quicknet's web site at:
-	  <http://www.quicknet.net/>.
+	  <http://www.qn.net/>.
 
 	  If you do not have any Quicknet telephony cards, you can safely
 	  say N here.
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index b53deee..496bd85 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -26,7 +26,7 @@
  *                  Daniele Bellucci, <bellucda@tiscali.it>
  *
  * More information about the hardware related to this driver can be found  
- * at our website:    http://www.quicknet.net
+ * at our website:   http://www.qn.net/ 
  *
  * IN NO EVENT SHALL QUICKNET TECHNOLOGIES, INC. BE LIABLE TO ANY PARTY FOR
  * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
diff --git a/drivers/telephony/ixj.h b/drivers/telephony/ixj.h
index 4c32a43..bed0c30 100644
--- a/drivers/telephony/ixj.h
+++ b/drivers/telephony/ixj.h
@@ -22,7 +22,7 @@
  *                  Mike Preston, <mpreston@quicknet.net>
  *
  * More information about the hardware related to this driver can be found
- * at our website:    http://www.quicknet.net
+ * at our website:   http://www.qn.net/ 
  *
  * Fixes:
  *
diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 1da73ec..e8cb825 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -19,7 +19,7 @@ config UIO_CIF
 	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
 	  driver requires a userspace component that handles all of the
 	  heavy lifting and can be found at:
-	  	http://www.osadl.org/projects/downloads/UIO/user/cif-*
+	  http://www.osadl.org/projects/downloads/UIO/user/	
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called uio_cif.
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 916b2b6..de86d92 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -176,7 +176,7 @@ config USB_SERIAL_VISOR
 	help
 	  Say Y here if you want to connect to your HandSpring Visor, Palm
 	  m500 or m505 through its USB docking station. See
-	  <http://usbvisor.sourceforge.net/> for more information on using this
+	  <http://usbvisor.sourceforge.net/index.php3> for more information on using this
 	  driver.
 
 	  To compile this driver as a module, choose M here: the
@@ -264,7 +264,7 @@ config USB_SERIAL_IUU
 	help
 	  Say Y here if you want to use a IUU in phoenix mode and get
 	  an extra ttyUSBx device. More information available on
-	  http://eczema.ecze.com/iuu_phoenix.html
+	  http://www.opensc-project.org/openct/wiki/wbeiuu 
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called iuu_phoenix.o
@@ -289,8 +289,6 @@ config USB_SERIAL_KEYSPAN
 	  and was developed with their support.  You must also include
 	  firmware to support your particular device(s).
 
-	  See <http://misc.nu/hugh/keyspan.html> for more information.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called keyspan.
 
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index f5d0674..1eca35d 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -14,7 +14,7 @@
  * See Documentation/usb/usb-serial.txt for more information on using this
  * driver
  *
- * See http://geocities.com/i0xox0i for information on this driver and the
+ * See http://web.archive.org/web/*/http://geocities.com/i0xox0i for information on this driver and the
  * earthmate usb device.
  *
  *  Lonnie Mendez <dignome@gmail.com>
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 15a4583..8443643 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -46,7 +46,7 @@
 #define FTDI_USINT_RS232_PID	0xb812	/* Navigator RS232 and CONFIG lines */
 
 /* OOCDlink by Joern Kaipf <joernk@web.de>
- * (http://www.joernonline.de/dw/doku.php?id=start&idx=projects:oocdlink) */
+ * (http://www.joernonline.de/) */
 #define FTDI_OOCDLINK_PID	0xbaf8	/* Amontec JTAGkey */
 
 /* Luminary Micro Stellaris Boards, VID = FTDI_VID */
@@ -335,7 +335,7 @@
 #define FTDI_PIEGROUP_PID	0xF208	/* Product Id */
 
 /* ACT Solutions HomePro ZWave interface
-   (http://www.act-solutions.com/HomePro.htm) */
+   (http://www.act-solutions.com/index.php) */
 #define FTDI_ACTZWAVE_PID	0xF2D0
 
 /*
@@ -366,7 +366,7 @@
 #define FTDI_SUUNTO_SPORTS_PID	0xF680	/* Suunto Sports instrument */
 
 /* USB-UIRT - An infrared receiver and transmitter using the 8U232AM chip */
-/* http://home.earthlink.net/~jrhees/USBUIRT/index.htm */
+/* http://www.usbuirt.com/ */
 #define FTDI_USB_UIRT_PID	0xF850	/* Product Id */
 
 /* CCS Inc. ICDU/ICDU40 product ID -
@@ -395,7 +395,7 @@
  */
 #define FTDI_HE_TIRA1_PID	0xFA78	/* Tira-1 IR transceiver */
 
-/* Inside Accesso contactless reader (http://www.insidefr.com) */
+/* Inside Accesso contactless reader (http://www.insidecontactless.com/) */
 #define INSIDE_ACCESSO		0xFAD0
 
 /*
@@ -434,7 +434,7 @@
 
 /*
  * PCDJ use ftdi based dj-controllers. The following PID is
- * for their DAC-2 device http://www.pcdjhardware.com/DAC2.asp
+ * for their DAC-2 device 
  * (the VID is the standard ftdi vid (FTDI_VID), PID sent by Wouter Paesen)
  */
 #define FTDI_PCDJ_DAC2_PID 0xFA88
@@ -634,14 +634,14 @@
 
 /*
  * JETI SPECTROMETER SPECBOS 1201
- * http://www.jeti.com/products/sys/scb/scb1201.php
+ * http://www.jeti.com/cms/index.php 
  */
 #define JETI_VID		0x0c6c
 #define JETI_SPC1201_PID	0x04b2
 
 /*
  * FTDI USB UART chips used in construction projects from the
- * Elektor Electronics magazine (http://elektor-electronics.co.uk)
+ * Elektor Electronics magazine (http://www.elektor.com/)
  */
 #define ELEKTOR_VID		0x0C7D
 #define ELEKTOR_FT323R_PID	0x0005	/* RFID-Reader, issue 09-2006 */
@@ -723,7 +723,7 @@
 
 /*
  * Bayer Ascensia Contour blood glucose meter USB-converter cable.
- * http://winglucofacts.com/cables/
+ * http://www.simplewins.com/Default.aspx 
  */
 #define BAYER_VID                      0x1A79
 #define BAYER_CONTOUR_CABLE_PID        0x6001
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 297163c..71c9576 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -9,8 +9,6 @@
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
 
-  See http://misc.nu/hugh/keyspan.html for more information.
-
   Code in this driver inspired by and in a number of places taken
   from Brian Warner's original Keyspan-PDA driver.
 
diff --git a/drivers/usb/serial/keyspan.h b/drivers/usb/serial/keyspan.h
index bf3297d..946ff95 100644
--- a/drivers/usb/serial/keyspan.h
+++ b/drivers/usb/serial/keyspan.h
@@ -9,8 +9,6 @@
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
 
-  See http://misc.nu/hugh/keyspan.html for more information.
-  
   Code in this driver inspired by and in a number of places taken
   from Brian Warner's original Keyspan-PDA driver.
 
diff --git a/drivers/usb/serial/mct_u232.h b/drivers/usb/serial/mct_u232.h
index 3a3f5e6..850a152 100644
--- a/drivers/usb/serial/mct_u232.h
+++ b/drivers/usb/serial/mct_u232.h
@@ -10,10 +10,10 @@
  *
  * This driver is for the device MCT USB-RS232 Converter (25 pin, Model No.
  * U232-P25) from Magic Control Technology Corp. (there is also a 9 pin
- * Model No. U232-P9). See http://www.mct.com.tw/p_u232.html for further
+ * Model No. U232-P9). See http://www.mct.com.tw/ for further
  * information. The properties of this device are listed at the end of this
- * file. This device is available from various distributors. I know Hana,
- * http://www.hana.de and D-Link, http://www.dlink.com/products/usb/dsbs25.
+ * file. This device is available from various distributors.
+ * D-Link, http://www.dlink.com/products/usb/dsbs25.
  *
  * All of the information about the device was acquired by using SniffUSB
  * on Windows98. The technical details of the reverse engineering are
@@ -457,8 +457,8 @@ static int mct_u232_calculate_baud_rate(struct usb_serial *serial,
  * USB endpoint chip and a Philips P87C52UBAA microcontroller with
  * embedded UART.  Exhaustive documentation for these is available at:
  *
+ *   http://www.nxp.com/ 
  *   http://www.semiconductors.philips.com/pip/p87c52ubaa
- *   http://www.semiconductors.philips.com/pip/pdiusbd12
  *
  * Thanks to Julian Highfield for the pointer to the Philips database.
  *
diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 8a372ba..b356e15 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -36,7 +36,7 @@ config USB_STORAGE_DATAFAB
 	depends on USB_STORAGE
 	help
 	  Support for certain Datafab CompactFlash readers.
-	  Datafab has a web page at <http://www.datafabusa.com/>.
+	  Datafab has a web page at <http://www.datafab.com/>.
 
 	  If this driver is compiled as a module, it will be named ums-datafab.
 
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 2c897ee..db641d8 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -962,7 +962,7 @@ UNUSUAL_DEV(  0x07af, 0x0006, 0x0100, 0x0100,
  * Only revision 1.13 tested (same for all of the above devices,
  * based on the Datafab DF-UG-07 chip).  Needed for US_FL_FIX_INQUIRY.
  * Submitted by Marek Michalkiewicz <marekm@amelek.gda.pl>.
- * See also http://martin.wilck.bei.t-online.de/#kecf .
+ * See also http://web.archive.org/web/20030808203106/http://martin.wilck.bei.t-online.de/.
  */
 UNUSUAL_DEV(  0x07c4, 0xa400, 0x0000, 0xffff,
 		"Datafab",
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 8b31fdf..e93d380 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -49,7 +49,7 @@ menuconfig FB
 	  You need an utility program called fbset to make full use of frame
 	  buffer devices. Please read <file:Documentation/fb/framebuffer.txt>
 	  and the Framebuffer-HOWTO at
-	  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.2.html> for more
+	  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.3.html> for more
 	  information.
 
 	  Say Y here and to the driver for your graphics board below if you
@@ -955,7 +955,7 @@ config FB_EPSON1355
 	  Build in support for the SED1355 Epson Research Embedded RAMDAC
 	  LCD/CRT Controller (since redesignated as the S1D13505) as a
 	  framebuffer.  Product specs at
-	  <http://www.erd.epson.com/vdc/html/products.htm>.
+	  <http://www.erd.epson.com/>.
 
 config FB_S1D13XXX
 	tristate "Epson S1D13XXX framebuffer support"
@@ -966,7 +966,7 @@ config FB_S1D13XXX
 	help
 	  Support for S1D13XXX framebuffer device family (currently only
 	  working with S1D13806). Product specs at
-	  <http://www.erd.epson.com/vdc/html/legacy_13xxx.htm>
+	  <http://www.erd.epson.com/>
 
 config FB_ATMEL
 	tristate "AT91/AT32 LCD Controller support"
@@ -1323,7 +1323,7 @@ config FB_RADEON
 	  don't need to choose this to run the Radeon in plain VGA mode.
 
 	  There is a product page at
-	  http://apps.ati.com/ATIcompare/
+	  http://www.amd.com/us/products/technologies/ati-catalyst/Pages/catalyst.aspx 
 
 config FB_RADEON_I2C
 	bool "DDC/I2C for ATI Radeon support"
@@ -1395,7 +1395,7 @@ config FB_ATY_CT
 	  Say Y here to support use of ATI's 64-bit Rage boards (or other
 	  boards based on the Mach64 CT, VT, GT, and LT chipsets) as a
 	  framebuffer device.  The ATI product support page for these boards
-	  is at <http://support.ati.com/products/pc/mach64/>.
+	  is at <http://www.amd.com/us/products/technologies/ati-catalyst/Pages/catalyst.aspx>.
 
 config FB_ATY_GENERIC_LCD
 	bool "Mach64 generic LCD support (EXPERIMENTAL)"
diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
index f3d7440..3ec4923 100644
--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -2,7 +2,6 @@
  * linux/drivers/video/arcfb.c -- FB driver for Arc monochrome LCD board
  *
  * Copyright (C) 2005, Jaya Kumar <jayalk@intworks.biz>
- * http://www.intworks.biz/arclcd
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License. See the file COPYING in the main directory of this archive for
diff --git a/drivers/video/epson1355fb.c b/drivers/video/epson1355fb.c
index db9713b..138dfd4 100644
--- a/drivers/video/epson1355fb.c
+++ b/drivers/video/epson1355fb.c
@@ -4,7 +4,7 @@
  * Epson Research S1D13505 Embedded RAMDAC LCD/CRT Controller
  *   (previously known as SED1355)
  *
- * Cf. http://www.erd.epson.com/vdc/html/S1D13505.html
+ * Cf. http://www.erd.epson.com/ 
  *
  *
  * Copyright (C) Hewlett-Packard Company.  All rights reserved.
diff --git a/drivers/video/fbcvt.c b/drivers/video/fbcvt.c
index 7293eac..08183ce 100644
--- a/drivers/video/fbcvt.c
+++ b/drivers/video/fbcvt.c
@@ -5,7 +5,7 @@
  *
  *      Based from the VESA(TM) Coordinated Video Timing Generator by
  *      Graham Loveridge April 9, 2003 available at
- *      http://www.vesa.org/public/CVT/CVTd6r1.xls
+ *      http://www.vesa.org/
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive
diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
index c77bcc6..3059827 100644
--- a/drivers/video/hecubafb.c
+++ b/drivers/video/hecubafb.c
@@ -10,7 +10,7 @@
  *
  * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
  * This work was possible because of apollo display code from E-Ink's website
- * http://support.eink.com/community
+ * http://eink.com/ 
  * All information used to write this code is from public material made
  * available by E-Ink on its support site. Some commands such as 0xA4
  * were found by looping through cmd=0x00 thru 0xFF and supplying random
diff --git a/drivers/video/macfb.c b/drivers/video/macfb.c
index 43207cc..6cc8363 100644
--- a/drivers/video/macfb.c
+++ b/drivers/video/macfb.c
@@ -16,7 +16,7 @@
  * Jacobowitz, Paul Mackerras, Fabio Riccardi, and Geert Uytterhoeven.
  *
  * The VideoToolbox "Bugs" web page at
- * http://rajsky.psych.nyu.edu/Tips/VideoBugs.html
+ * http://web.archive.org/web/*/http://rajsky.psych.nyu.edu/Tips/VideoBugs.html 
  *
  * This code is free software.  You may copy, modify, and distribute
  * it subject to the terms and conditions of the GNU General Public
diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
index 9b3d6e4..c9117cd 100644
--- a/drivers/video/metronomefb.c
+++ b/drivers/video/metronomefb.c
@@ -10,7 +10,7 @@
  * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
  *
  * This work was made possible by help and equipment support from E-Ink
- * Corporation. http://support.eink.com/community
+ * Corporation. http://www.eink.com/ 
  *
  * This driver is written to be used with the Metronome display controller.
  * It is intended to be architecture independent. A board specific driver
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index dce8c97..eeed200 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -7,8 +7,6 @@
  * License.  See the file COPYING in the main directory of this archive for
  * more details.
  *
- * Code is based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
- * which is based on the code of neofb.
  */
 
 #include <linux/module.h>
diff --git a/drivers/video/svgalib.c b/drivers/video/svgalib.c
index fdb4567..b4c87d0 100644
--- a/drivers/video/svgalib.c
+++ b/drivers/video/svgalib.c
@@ -7,7 +7,7 @@
  * License.  See the file COPYING in the main directory of this archive for
  * more details.
  *
- * Some parts are based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
+ * Some parts are based on David Boucher's viafb (http://web.archive.org/web/20071125103157/http://davesdomain.org.uk/viafb/)
  */
 
 #include <linux/module.h>
diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 28ccab4..43d63e5 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -2,7 +2,6 @@
  * linux/drivers/video/vga16.c -- VGA 16-color framebuffer driver
  * 
  * Copyright 1999 Ben Pfaff <pfaffben@debian.org> and Petr Vandrovec <VANDROVE@vc.cvut.cz>
- * Based on VGA info at http://www.goodnet.com/~tinara/FreeVGA/home.htm
  * Based on VESA framebuffer (c) 1998 Gerd Knorr <kraxel@goldbach.in-berlin.de>
  *
  * This file is subject to the terms and conditions of the GNU General
diff --git a/drivers/video/vgastate.c b/drivers/video/vgastate.c
index b91c466..d0680f6 100644
--- a/drivers/video/vgastate.c
+++ b/drivers/video/vgastate.c
@@ -5,7 +5,7 @@
  * 
  * Copyright history from vga16fb.c:
  *	Copyright 1999 Ben Pfaff and Petr Vandrovec
- *	Based on VGA info at http://www.goodnet.com/~tinara/FreeVGA/home.htm
+ *	Based on VGA info at http://www.osdever.net/FreeVGA/home.htm
  *	Based on VESA framebuffer (c) 1998 Gerd Knorr
  *
  * This file is subject to the terms and conditions of the GNU General
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index 85d76ec..10d944b 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -9,7 +9,6 @@
  * more details.
  *
  * Code is based on s3fb, some parts are from David Boucher's viafb
- * (http://davesdomain.org.uk/viafb/)
  */
 
 #include <linux/module.h>
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index 06f7922..d4bbd31 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -46,7 +46,6 @@
  */
 
 /*
- *	A bells and whistles driver is available from http://www.pcwd.de/
  *	More info available at http://www.berkprod.com/ or
  *	http://www.pcwatchdog.com/
  */
diff --git a/firmware/keyspan_pda/keyspan_pda.S b/firmware/keyspan_pda/keyspan_pda.S
index 418fe69..f3acc19 100644
--- a/firmware/keyspan_pda/keyspan_pda.S
+++ b/firmware/keyspan_pda/keyspan_pda.S
@@ -74,7 +74,7 @@
  *  recognizes the new device ID and glues it to the real serial driver code.
  *
  * USEFUL DOCS:
- *  EzUSB Technical Reference Manual: <http://www.anchorchips.com>
+ *  EzUSB Technical Reference Manual: <http://www.cypress.com/>
  *  8051 manuals: everywhere, but try www.dalsemi.com because the EzUSB is
  *   basically the Dallas enhanced 8051 code. Remember that the EzUSB IO ports
  *   use totally different registers!
diff --git a/firmware/keyspan_pda/xircom_pgs.S b/firmware/keyspan_pda/xircom_pgs.S
index 05d99dd..0b79bbf 100644
--- a/firmware/keyspan_pda/xircom_pgs.S
+++ b/firmware/keyspan_pda/xircom_pgs.S
@@ -74,7 +74,7 @@
  *  recognizes the new device ID and glues it to the real serial driver code.
  *
  * USEFUL DOCS:
- *  EzUSB Technical Reference Manual: <http://www.anchorchips.com>
+ *  EzUSB Technical Reference Manual: <http://www.cypress.com/>
  *  8051 manuals: everywhere, but try www.dalsemi.com because the EzUSB is
  *   basically the Dallas enhanced 8051 code. Remember that the EzUSB IO ports
  *   use totally different registers!
diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
index 6bbd75c..2e58848 100644
--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -28,12 +28,7 @@
  * #define ATTR_KILL_SUID	2048
  * #define ATTR_KILL_SGID	4096
  *
- * and this is because they were added in 2.5 development in this patch:
- *
- * http://linux.bkbits.net:8080/linux-2.5/
- * cset@3caf4a12k4XgDzK7wyK-TGpSZ9u2Ww?nav=index.html
- * |src/.|src/include|src/include/linux|related/include/linux/fs.h
- *
+ * and this is because they were added in 2.5 development.  
  * Actually, they are not needed by most ->setattr() methods - they are set by
  * callers of notify_change() to notify that the setuid/setgid bits must be
  * dropped.
diff --git a/fs/ncpfs/Kconfig b/fs/ncpfs/Kconfig
index c931cf2..4956638 100644
--- a/fs/ncpfs/Kconfig
+++ b/fs/ncpfs/Kconfig
@@ -17,7 +17,8 @@ config NCP_FS
 	  file *server* for Novell NetWare clients.
 
 	  General information about how to connect Linux, Windows machines and
-	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.
+	  Macs is on the WWW at 
+	  <http://web.archive.org/web/20011204193118/http://www.eats.com/linux_mac_win.html>.
 
 	  To compile this as a module, choose M here: the module will be called
 	  ncpfs.  Say N unless you are connected to a Novell network.
diff --git a/fs/nls/Kconfig b/fs/nls/Kconfig
index a39edc4..83f617c 100644
--- a/fs/nls/Kconfig
+++ b/fs/nls/Kconfig
@@ -415,8 +415,8 @@ config NLS_ISO8859_14
 	  correctly on the screen, you need to include the appropriate
 	  input/output character sets. Say Y here for the Latin 8 character
 	  set, which adds the last accented vowels for Welsh (aka Cymraeg)
-	  (and Manx Gaelic) that were missing in Latin 1.
-	  <http://linux.speech.cymru.org/> has further information.
+	  (and Manx Gaelic) that were missing in Latin 1. For more info:
+	  <http://web.archive.org/web/*/http://linux.speech.cymru.org>.
 
 config NLS_ISO8859_15
 	tristate "NLS ISO 8859-15 (Latin 9; Western European Languages with Euro)"
diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 44a88a9..7ef7118 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -23,7 +23,7 @@ static DEFINE_SPINLOCK(nls_lock);
 
 /*
  * Sample implementation from Unicode home page.
- * http://www.stonehand.com/unicode/standard/fss-utf.html
+ * http://web.archive.org/web/19970105220809/http://stonehand.com/unicode/standard/fss-utf.html 
  */
 struct utf8_table {
 	int     cmask;
diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
index 7424929..d7d5526 100644
--- a/fs/nls/nls_euc-jp.c
+++ b/fs/nls/nls_euc-jp.c
@@ -3,7 +3,7 @@
  *
  * Added `OSF/JVC Recommended Code Set Conversion Specification
  * between Japanese EUC and Shift-JIS' support: <hirofumi@mail.parknet.co.jp>
- * (http://www.opengroup.or.jp/jvc/cde/sjis-euc-e.html)
+ * (http://www.opengroup.or.jp/)
  */
 
 #include <linux/module.h>
diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 5bf8a04..7125949 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2001-2007 Anton Altaparmakov
  * Copyright (C) 2001,2002 Jakob Kemi <jakob.kemi@telia.com>
  *
- * Documentation is available at http://www.linux-ntfs.org/content/view/19/37/
+ * Documentation is available at http://www.linux-ntfs.org/
  *
  * This program is free software; you can redistribute it and/or modify it under
  * the terms of the GNU General Public License as published by the Free Software
diff --git a/fs/partitions/ldm.h b/fs/partitions/ldm.h
index d1fb50b..9a3c75b 100644
--- a/fs/partitions/ldm.h
+++ b/fs/partitions/ldm.h
@@ -5,7 +5,7 @@
  * Copyright (c) 2001-2007 Anton Altaparmakov
  * Copyright (C) 2001,2002 Jakob Kemi <jakob.kemi@telia.com>
  *
- * Documentation is available at http://www.linux-ntfs.org/content/view/19/37/
+ * Documentation is available at http://www.linux-ntfs.org/
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
index 513f431..b395d95 100644
--- a/fs/reiserfs/Kconfig
+++ b/fs/reiserfs/Kconfig
@@ -10,7 +10,7 @@ config REISERFS_FS
 
 	  In general, ReiserFS is as fast as ext2, but is very efficient with
 	  large directories and small files.  Additional patches are needed
-	  for NFS and quotas, please see <http://www.namesys.com/> for links.
+	  for NFS and quotas, please see <http://en.wikipedia.org/wiki/Namesys>.
 
 	  It is more easily extended to have features currently found in
 	  database and keyword search systems than block allocation based file
@@ -18,7 +18,7 @@ config REISERFS_FS
 	  plugins consistent with our motto ``It takes more than a license to
 	  make source code open.''
 
-	  Read <http://www.namesys.com/> to learn more about reiserfs.
+	  Read <http://en.wikipedia.org/wiki/Namesys> to learn more about reiserfs.
 
 	  Sponsored by Threshold Networks, Emusic.com, and Bigstorage.com.
 
diff --git a/fs/reiserfs/README b/fs/reiserfs/README
index 14e8c9d..44d1abd 100644
--- a/fs/reiserfs/README
+++ b/fs/reiserfs/README
@@ -43,7 +43,7 @@ to address the fair crediting issue in the next GPL version.)
 [END LICENSING]
 
 Reiserfs is a file system based on balanced tree algorithms, which is
-described at http://devlinux.com/namesys.
+described at http://devlinux.net/.
 
 Stop reading here.  Go there, then return.
 
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 7a99811..6b387b0 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -555,13 +555,11 @@ int reiserfs_proc_info_global_done(void)
  *  . remove remove_save_link() from reiserfs_do_truncate()
  *
  * I accept terms and conditions stated in the Legal Agreement
- * (available at http://www.namesys.com/legalese.html)
  *
  * Revision 1.1.8.1  2001/07/11 16:48:50  god
  * proc info support
  *
  * I accept terms and conditions stated in the Legal Agreement
- * (available at http://www.namesys.com/legalese.html)
  *
  */
 
diff --git a/include/crypto/b128ops.h b/include/crypto/b128ops.h
index 0b8e6bc..499741c 100644
--- a/include/crypto/b128ops.h
+++ b/include/crypto/b128ops.h
@@ -4,7 +4,7 @@
  * Copyright (c) 2006, Rik Snel <rsnel@cube.dyndns.org>
  *
  * Based on Dr Brian Gladman's (GPL'd) work published at
- * http://fp.gladman.plus.com/cryptography_technology/index.htm
+ * http://www.gladman.me.uk/ 
  * See the original copyright notice below.
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index 4086b8e..7021c6c 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -4,7 +4,7 @@
  * Copyright (c) 2006 Rik Snel <rsnel@cube.dyndns.org>
  *
  * Based on Dr Brian Gladman's (GPL'd) work published at
- * http://fp.gladman.plus.com/cryptography_technology/index.htm
+ * http://www.gladman.me.uk/ 
  * See the original copyright notice below.
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -54,8 +54,8 @@
 
 /* Comment by Rik:
  *
- * For some background on GF(2^128) see for example: http://-
- * csrc.nist.gov/CryptoToolkit/modes/proposedmodes/gcm/gcm-revised-spec.pdf
+ * For some background on GF(2^128) see for example: 
+ * http://www.cryptobarn.com/papers/gcm-spec.pdf 
  *
  * The elements of GF(2^128) := GF(2)[X]/(X^128-X^7-X^2-X^1-1) can
  * be mapped to computer memory in a variety of ways. Let's examine
diff --git a/include/linux/edd.h b/include/linux/edd.h
index 4cbd0fe..557227c 100644
--- a/include/linux/edd.h
+++ b/include/linux/edd.h
@@ -6,8 +6,9 @@
  * structures and definitions for the int 13h, ax={41,48}h
  * BIOS Enhanced Disk Drive Services
  * This is based on the T13 group document D1572 Revision 0 (August 14 2002)
- * available at http://www.t13.org/docs2002/d1572r0.pdf.  It is
- * very similar to D1484 Revision 3 http://www.t13.org/docs2002/d1484r3.pdf
+ * available at http://web.archive.org/web/*/http://www.t13.org/docs2002/d1572r0.pdf.
+ * It is very similar to D1484 Revision 3 
+ * http://web.archive.org/web/*/http://www.t13.org/docs2002/d1484r3.pdf
  *
  * In a nutshell, arch/{i386,x86_64}/boot/setup.S populates a scratch
  * table in the boot_params that contains a list of BIOS-enumerated
diff --git a/include/linux/fdreg.h b/include/linux/fdreg.h
index c2eeb63..b153223 100644
--- a/include/linux/fdreg.h
+++ b/include/linux/fdreg.h
@@ -89,7 +89,7 @@
 /* the following commands are new in the 82078. They are not used in the
  * floppy driver, except the first three. These commands may be useful for apps
  * which use the FDRAWCMD interface. For doc, get the 82078 spec sheets at
- * http://www-techdoc.intel.com/docs/periph/fd_contr/datasheets/ */
+ * http://www.intel.com/p/en_US/business/design */
 
 #define FD_PARTID		0x18	/* part id ("extended" version cmd) */
 #define FD_SAVE			0x2e	/* save fdc regs for later restore */
diff --git a/include/linux/if_infiniband.h b/include/linux/if_infiniband.h
index 3e659ec..6c9f662 100644
--- a/include/linux/if_infiniband.h
+++ b/include/linux/if_infiniband.h
@@ -5,7 +5,7 @@
  * <http://www.fsf.org/copyleft/gpl.html>, or the OpenIB.org BSD
  * license, available in the LICENSE.TXT file accompanying this
  * software.  These details are also available at
- * <http://openib.org/license.html>.
+ * <http://www.openfabrics.org/>.
  *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
diff --git a/include/linux/ixjuser.h b/include/linux/ixjuser.h
index 88b4589..594d871 100644
--- a/include/linux/ixjuser.h
+++ b/include/linux/ixjuser.h
@@ -25,7 +25,7 @@
  *                  Mike Preston, <mpreston@quicknet.net>
  *
  * More information about the hardware related to this driver can be found
- * at our website:    http://www.quicknet.net
+ * at our website:   http://www.qn.net/ 
  *
  * Fixes:
  *
diff --git a/include/linux/mtd/pismo.h b/include/linux/mtd/pismo.h
index 8dfb7e1..c2d6e75 100644
--- a/include/linux/mtd/pismo.h
+++ b/include/linux/mtd/pismo.h
@@ -1,5 +1,5 @@
 /*
- * PISMO memory driver - http://www.pismoworld.org/
+ * PISMO memory driver - http://web.archive.org/web/*/http://www.pismoworld.org/ 
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/include/linux/n_r3964.h b/include/linux/n_r3964.h
index de24af7..60d73a6 100644
--- a/include/linux/n_r3964.h
+++ b/include/linux/n_r3964.h
@@ -4,7 +4,7 @@
  * Copyright by
  * Philips Automation Projects
  * Kassel (Germany)
- * http://www.pap-philips.de
+ * http://www.pronto.philips.com/index.cfm?id=1292 
  * -----------------------------------------------------------
  * This software may be used and distributed according to the terms of
  * the GNU General Public License, incorporated herein by reference.
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index a9f3c6f..19d4d85 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -16,7 +16,7 @@ Version 2 and 3 extensions to driver:
     Version: 3.5.34 (20060920)
     This version is for 2.6 series kernels.
 
-    For a full changelog see http://www.torque.net/sg
+    For a full changelog see http://web.archive.org/web/*/http://www.torque.net/sg 
 
 Map of SG verions to the Linux kernels in which they appear:
        ----------        ----------------------------------
@@ -52,17 +52,17 @@ Major new features in SG 3.x driver (cf SG 2.x drivers)
  Documentation
  =============
  A web site for the SG device driver can be found at:
-	http://www.torque.net/sg  [alternatively check the MAINTAINERS file]
+	http://web.archive.org/web/*/http://www.torque.net/sg	
  The documentation for the sg version 3 driver can be found at:
- 	http://www.torque.net/sg/p/sg_v3_ho.html
+ 	http://web.archive.org/web/*/http://www.torque.net/sg/p/sg_v3_ho.html
  This is a rendering from DocBook source [change the extension to "sgml"
  or "xml"]. There are renderings in "ps", "pdf", "rtf" and "txt" (soon).
  The SG_IO ioctl is now found in other parts kernel (e.g. the block layer).
  For more information see http://www.torque.net/sg/sg_io.html
 
  The older, version 2 documents discuss the original sg interface in detail:
-	http://www.torque.net/sg/p/scsi-generic.txt
-	http://www.torque.net/sg/p/scsi-generic_long.txt
+	http://web.archive.org/web/*/http://www.torque.net/sg/p/scsi-generic.txt
+	http://web.archive.org/web/*/http://www.torque.net/sg/p/scsi-generic_long.txt
  Also available: <kernel_source>/Documentation/scsi/scsi-generic.txt
 
  Utility and test programs are available at the sg web site. They are 
diff --git a/include/video/vga.h b/include/video/vga.h
index b49a512..2b8691f 100644
--- a/include/video/vga.h
+++ b/include/video/vga.h
@@ -5,7 +5,7 @@
  * 
  * Copyright history from vga16fb.c:
  *	Copyright 1999 Ben Pfaff and Petr Vandrovec
- *	Based on VGA info at http://www.goodnet.com/~tinara/FreeVGA/home.htm
+ *	Based on VGA info at http://www.osdever.net/FreeVGA/home.htm 
  *	Based on VESA framebuffer (c) 1998 Gerd Knorr
  *
  * This file is subject to the terms and conditions of the GNU General
diff --git a/net/ax25/Kconfig b/net/ax25/Kconfig
index 2a72aa9..705e53e 100644
--- a/net/ax25/Kconfig
+++ b/net/ax25/Kconfig
@@ -7,7 +7,7 @@ menuconfig HAMRADIO
 	bool "Amateur Radio support"
 	help
 	  If you want to connect your Linux box to an amateur radio, answer Y
-	  here. You want to read <http://www.tapr.org/tapr/html/pkthome.html>
+	  here. You want to read <http://www.tapr.org/>
 	  and more specifically about AX.25 on Linux
 	  <http://www.linux-ax25.org/>.
 
@@ -42,7 +42,7 @@ config AX25
 	  check out the file <file:Documentation/networking/ax25.txt> in the
 	  kernel source. More information about digital amateur radio in
 	  general is on the WWW at
-	  <http://www.tapr.org/tapr/html/pkthome.html>.
+	  <http://www.tapr.org/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ax25.
@@ -89,7 +89,7 @@ config NETROM
 	  <http://www.linux-ax25.org>. You also might want to check out the
 	  file <file:Documentation/networking/ax25.txt>. More information about
 	  digital amateur radio in general is on the WWW at
-	  <http://www.tapr.org/tapr/html/pkthome.html>.
+	  <http://www.tapr.org/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called netrom.
@@ -108,7 +108,7 @@ config ROSE
 	  <http://www.linux-ax25.org>.  You also might want to check out the
 	  file <file:Documentation/networking/ax25.txt>. More information about
 	  digital amateur radio in general is on the WWW at
-	  <http://www.tapr.org/tapr/html/pkthome.html>.
+	  <http://www.tapr.org/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rose.
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 571f895..9406f76 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -84,7 +84,7 @@ config IP_FIB_TRIE
 
 	  An experimental study of compression methods for dynamic tries
 	  Stefan Nilsson and Matti Tikkanen. Algorithmica, 33(1):19-33, 2002.
-	  http://www.nada.kth.se/~snilsson/public/papers/dyntrie2/
+	  http://www.kth.se/csc 
 
 endchoice
 
@@ -271,8 +271,8 @@ config IP_PIMSM_V1
 	  Kernel side support for Sparse Mode PIM (Protocol Independent
 	  Multicast) version 1. This multicast routing protocol is used widely
 	  because Cisco supports it. You need special software to use it
-	  (pimd-v1). Please see <http://netweb.usc.edu/pim/> for more
-	  information about PIM.
+	  (pimd-v1). Information is at: 
+	  http://web.archive.org/web/*/http://netweb.usc.edu/pim/.
 
 	  Say Y if you want to use PIM-SM v1. Note that you can say N here if
 	  you just want to use Dense Mode PIM.
@@ -555,7 +555,7 @@ config TCP_CONG_VENO
 	distinguishing to circumvent the difficult judgment of the packet loss
 	type. TCP Veno cuts down less congestion window in response to random
 	loss packets.
-	See http://www.ntu.edu.sg/home5/ZHOU0022/papers/CPFu03a.pdf
+	See http://www.ntu.edu.sg/Pages/default.aspx 
 
 config TCP_CONG_YEAH
 	tristate "YeAH TCP"
@@ -583,7 +583,7 @@ config TCP_CONG_ILLINOIS
 	throughput and maintain fairness.
 
 	For further details see:
-	  http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html
+	 http://web.archive.org/web/*/http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html 
 
 choice
 	prompt "Default TCP congestion control"
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 3a92a76..65dc808 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -9,7 +9,7 @@
  *
  * The CIPSO draft specification can be found in the kernel's Documentation
  * directory as well as the following URL:
- *   http://netlabel.sourceforge.net/files/draft-ietf-cipso-ipsecurity-01.txt
+ *  http://tools.ietf.org/id/draft-ietf-cipso-ipsecurity-01.txt 
  * The FIPS-188 specification can be found at the following URL:
  *   http://www.itl.nist.gov/fipspubs/fip188.htm
  *
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 4a8e370..c98c82d 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -16,7 +16,7 @@
  *
  * An experimental study of compression methods for dynamic tries
  * Stefan Nilsson and Matti Tikkanen. Algorithmica, 33(1):19-33, 2002.
- * http://www.nada.kth.se/~snilsson/public/papers/dyntrie2/
+ * http://www.nada.kth.se/
  *
  *
  * IP-address lookup using LC-tries. Stefan Nilsson and Gunnar Karlsson
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1833bdb..83731a4 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -147,7 +147,7 @@ config IP_NF_TARGET_ULOG
 	  which can only be viewed through syslog.
 
 	  The appropriate userspace logging daemon (ulogd) may be obtained from
-	  <http://www.gnumonks.org/projects/ulogd/>
+	  <http://www.gnumonks.org/>
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index 1eba160..8bedf6c 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -1,12 +1,12 @@
 /*
  * TCP Illinois congestion control.
  * Home page:
- *	http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html
+ * http://web.archive.org/web/*/http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html	
  *
  * The algorithm is described in:
  * "TCP-Illinois: A Loss and Delay-Based Congestion Control Algorithm
  *  for High-Speed Networks"
- * http://www.ews.uiuc.edu/~shaoliu/papersandslides/liubassri06perf.pdf
+ * http://www.ifp.illinois.edu/~srikant/Papers/liubassri06perf.pdf
  *
  * Implemented from description in paper and ns-2 simulation.
  * Copyright (C) 2007 Stephen Hemminger <shemminger@linux-foundation.org>
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e663b78..f5b7628 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -428,10 +428,10 @@ EXPORT_SYMBOL(tcp_initialize_rcv_mss);
  *
  * The algorithm for RTT estimation w/o timestamps is based on
  * Dynamic Right-Sizing (DRS) by Wu Feng and Mike Fisk of LANL.
- * <http://www.lanl.gov/radiant/website/pubs/drs/lacsi2001.ps>
+ * <http://public.lanl.gov/radiant/pubs.htm>
  *
  * More detail on this code can be found at
- * <http://www.psc.edu/~jheffner/senior_thesis.ps>,
+ * <http://staff.psc.edu/jheffner/>,
  * though this reference is out of date.  A new paper
  * is pending.
  */
diff --git a/net/ipv4/tcp_lp.c b/net/ipv4/tcp_lp.c
index de87037..b88c17b 100644
--- a/net/ipv4/tcp_lp.c
+++ b/net/ipv4/tcp_lp.c
@@ -22,7 +22,7 @@
  * Original Author:
  *   Aleksandar Kuzmanovic <akuzma@northwestern.edu>
  * Available from:
- *   http://www.ece.rice.edu/~akuzma/Doc/akuzma/TCP-LP.pdf
+ *   http://web.archive.org/web/*/http://www.ece.rice.edu/~akuzma/Doc/akuzma/TCP-LP.pdf 
  * Original implementation for 2.4.19:
  *   http://www-ece.rice.edu/networks/TCP-LP/
  *
diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index b612acf..16cd91d 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -6,7 +6,7 @@
  *    "TCP Veno: TCP Enhancement for Transmission over Wireless Access Networks."
  *    IEEE Journal on Selected Areas in Communication,
  *    Feb. 2003.
- * 	See http://www.ntu.edu.sg/home5/ZHOU0022/papers/CPFu03a.pdf
+ * 	See http://www.ntu.edu.sg/Pages/default.aspx 
  */
 
 #include <linux/mm.h>
diff --git a/net/ipv4/tcp_westwood.c b/net/ipv4/tcp_westwood.c
index 20151d6..bbf0e99 100644
--- a/net/ipv4/tcp_westwood.c
+++ b/net/ipv4/tcp_westwood.c
@@ -3,7 +3,7 @@
  *
  *      Angelo Dell'Aera: author of the first version of TCP Westwood+ in Linux 2.4
  *
- * Support at http://c3lab.poliba.it/index.php/Westwood
+ * Support at http://www.cs.ucla.edu/NRL/hpi/tcpw/ 
  * Main references in literature:
  *
  * - Mascolo S, Casetti, M. Gerla et al.
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index c4c885d..a695842 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -329,8 +329,8 @@ static unsigned int get_conntrack_index(const struct tcphdr *tcph)
 /* TCP connection tracking based on 'Real Stateful TCP Packet Filtering
    in IP Filter' by Guido van Rooij.
 
-   http://www.nluug.nl/events/sane2000/papers.html
-   http://www.iae.nl/users/guido/papers/tcp_filtering.ps.gz
+   http://www.sane.nl/events/sane2000/papers.html 
+   http://www.darkart.com/mirrors/www.obfuscation.org/ipf/
 
    The boundaries and the conditions are changed according to RFC793:
    the packet must intersect the window (i.e. segments may be
diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index c6990c6..e12cc63 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -421,7 +421,7 @@ config SND_MSND_CLASSIC
 	  See <file:Documentation/sound/oss/MultiSound> for important information
 	  about this driver.  Note that it has been discontinued, but the
 	  Voyetra Turtle Beach knowledge base entry for it is still available
-	  at <http://www.turtlebeach.com/site/kb_ftp/790.asp>.
+	  at <http://www.turtlebeach.com/>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-msnd-classic.
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index fe79a16..0657aa0 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -1,7 +1,6 @@
 /*
  *  Driver for C-Media's CMI8330 and CMI8329 soundcards.
  *  Copyright (c) by George Talusan <gstalusan@uwaterloo.ca>
- *    http://www.undergrad.math.uwaterloo.ca/~gstalusa
  *
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index a513651..bd6c171 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -36,7 +36,7 @@ config SOUND_MSNDCLAS
 	  See <file:Documentation/sound/oss/MultiSound> for important information
 	  about this driver.  Note that it has been discontinued, but the
 	  Voyetra Turtle Beach knowledge base entry for it is still available
-	  at <http://www.turtlebeach.com/site/kb_ftp/790.asp>.
+	  at <http://www.turtlebeach.com/>.
 
 comment "Compiled-in MSND Classic support requires firmware during compilation."
 	depends on SOUND_PRIME && SOUND_MSNDCLAS=y
@@ -98,7 +98,7 @@ config SOUND_MSNDPIN
 	  See <file:Documentation/sound/oss/MultiSound> for important information
 	  about this driver. Note that it has been discontinued, but the
 	  Voyetra Turtle Beach knowledge base entry for it is still available
-	  at <http://www.turtlebeach.com/site/kb_ftp/600.asp>.
+	  at <http://www.turtlebeach.com/>.
 
 comment "Compiled-in MSND Pinnacle support requires firmware during compilation."
 	depends on SOUND_PRIME && SOUND_MSNDPIN=y
diff --git a/sound/oss/ac97_codec.c b/sound/oss/ac97_codec.c
index 456a1b4..e2c5fe9 100644
--- a/sound/oss/ac97_codec.c
+++ b/sound/oss/ac97_codec.c
@@ -22,10 +22,7 @@
  **************************************************************************
  *
  * The Intel Audio Codec '97 specification is available at the Intel
- * audio homepage: http://developer.intel.com/ial/scalableplatforms/audio/
- *
- * The specification itself is currently available at:
- * ftp://download.intel.com/ial/scalableplatforms/ac97r22.pdf
+ * http://download.intel.com/support/motherboards/desktop/sb/ac97_r23.pdf
  *
  **************************************************************************
  *
diff --git a/sound/pci/ac97/ac97_patch.c b/sound/pci/ac97/ac97_patch.c
index e68c98e..de4641c 100644
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -3874,7 +3874,7 @@ static int patch_lm4550(struct snd_ac97 *ac97)
 }
 
 /* 
- *  UCB1400 codec (http://www.semiconductors.philips.com/acrobat_download/datasheets/UCB1400-02.pdf)
+ *  UCB1400 codec (http://web.archive.org/web/*/http://www.semiconductors.philips.com/acrobat_download/datasheets/UCB1400-02.pdf)
  */
 static const struct snd_kcontrol_new snd_ac97_controls_ucb1400[] = {
 /* enable/disable headphone driver which allows direct connection to
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index c7fba53..deffcc8 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -22,7 +22,7 @@
 /* Power-Management-Code ( CONFIG_PM )
  * for ens1371 only ( FIXME )
  * derived from cs4281.c, atiixp.c and via82xx.c
- * using http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c1540.htm
+ * using http://www.kernel.org/pub/linux/kernel/people/tiwai/docs/writing-an-alsa-driver/index.html 
  * by Kurt J. Bosch
  */
 
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 4677492..400f9eb 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -716,7 +716,7 @@ static void snd_intel8x0_setup_periods(struct intel8x0 *chip, struct ichdev *ich
  * Intel 82443MX running a 100MHz processor system bus has a hardware bug,
  * which aborts PCI busmaster for audio transfer.  A workaround is to set
  * the pages as non-cached.  For details, see the errata in
- *	http://www.intel.com/design/chipsets/specupdt/245051.htm
+ *	http://download.intel.com/design/chipsets/specupdt/24505108.pdf
  */
 static void fill_nocache(void *buf, int size, int nocache)
 {
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 5a60492..c6f0791 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -6,7 +6,7 @@
  * The original author of OSS nm256 driver wishes to remain anonymous,
  * so I just put my acknoledgment to him/her here.
  * The original author's web page is found at
- *	http://www.uglx.org/sony.html
+ * http://web.archive.org/web/*/http://www.uglx.org/sony.html	
  *
  *
  *   This program is free software; you can redistribute it and/or modify
-- 
1.7.2.1

