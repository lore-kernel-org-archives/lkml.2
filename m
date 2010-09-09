Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0IIWY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:24:29 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35469 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0IIWY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:24:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HyfGtpJhLuZ5fSJyjLZWvCDZqdFFC00Z4QZFfFCt38Nlc1s91PvXsN8p4AJeZQevz3
         P4dl+83gtmneE9oQF9mAZRaEBFDhKa5bq06Q0D7Flmv4DmEAGjzerS4B+yYQI68Vmp+6
         TK2sITsYAH6rHdmHmK0Wb9GoHkuH8VYCHbwCI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/223] drivers/* Update broken web addresses. 
Date: Thu,  9 Sep 2010 15:24:36 -0700
Message-Id: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Below you will find patches consisting of updated web addresses to broken links found
in drivers/* .. I went through the best that I can for them.. some where non
existent, some where just a change of name, and some had a typo in them.Note:
patches 137-187 used a "-" instead of a "." causing them to not work when copy/pasting..
figured might as well submit the change, and if you guys like it, then keep it
if not, then oh-well.. Please have a look through and let me know..(I really appreciate 
the feedback with the last set I had sent...)

cheers, 


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
 drivers/ide/ht6560b.c                              |    1 -
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
 drivers/media/video/gspca/ov534.c                  |    1 +
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
 drivers/video/vgastate.c                           |    1 -
 drivers/video/vt8623fb.c                           |    1 -
 drivers/watchdog/pcwd.c                            |    1 -
 222 files changed, 292 insertions(+), 360 deletions(-)



Justin P. Mattock
 


