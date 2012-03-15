Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032380Ab2COVBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161746Ab2COVBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:01:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 37/38] Remove all #inclusions of asm/system.h [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>
Date: Thu, 15 Mar 2012 21:00:58 +0000
Message-ID: <20120315210057.28759.68223.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all #inclusions of asm/system.h preparatory to splitting and killing
it.  Performed with the following command:

perl -p -i -e 's!^#\s*include\s*<asm/system[.]h>.*\n!!' `grep -Irl '^#\s*include\s*<asm/system[.]h>' *`

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/um/include/asm/fixmap.h                       |    1 -
 drivers/acpi/processor_driver.c                    |    1 -
 drivers/atm/eni.c                                  |    1 -
 drivers/atm/firestream.c                           |    1 -
 drivers/atm/horizon.c                              |    1 -
 drivers/atm/idt77105.c                             |    1 -
 drivers/atm/iphase.c                               |    1 -
 drivers/atm/suni.c                                 |    1 -
 drivers/atm/zatm.c                                 |    1 -
 drivers/block/floppy.c                             |    1 -
 drivers/block/hd.c                                 |    1 -
 drivers/block/nbd.c                                |    1 -
 drivers/block/xd.c                                 |    1 -
 drivers/bluetooth/bt3c_cs.c                        |    1 -
 drivers/bluetooth/btuart_cs.c                      |    1 -
 drivers/bluetooth/dtl1_cs.c                        |    1 -
 drivers/char/apm-emulation.c                       |    1 -
 drivers/char/ds1302.c                              |    1 -
 drivers/char/efirtc.c                              |    1 -
 drivers/char/genrtc.c                              |    1 -
 drivers/char/hpet.c                                |    1 -
 drivers/char/ipmi/ipmi_devintf.c                   |    1 -
 drivers/char/ipmi/ipmi_msghandler.c                |    1 -
 drivers/char/ipmi/ipmi_si_intf.c                   |    1 -
 drivers/char/lp.c                                  |    1 -
 drivers/char/mbcs.c                                |    1 -
 drivers/char/mspec.c                               |    1 -
 drivers/char/mwave/3780i.c                         |    1 -
 drivers/char/nvram.c                               |    1 -
 drivers/char/nwflash.c                             |    1 -
 drivers/char/pcmcia/synclink_cs.c                  |    1 -
 drivers/char/rtc.c                                 |    1 -
 drivers/char/sonypi.c                              |    1 -
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    1 -
 drivers/cpufreq/omap-cpufreq.c                     |    1 -
 drivers/cpufreq/powernow-k7.c                      |    1 -
 drivers/firewire/core-cdev.c                       |    1 -
 drivers/firewire/core-device.c                     |    1 -
 drivers/firewire/core-topology.c                   |    1 -
 drivers/firewire/ohci.c                            |    1 -
 drivers/firewire/sbp2.c                            |    1 -
 drivers/i2c/busses/i2c-acorn.c                     |    1 -
 drivers/ide/ide-cs.c                               |    1 -
 drivers/ide/qd65xx.c                               |    1 -
 drivers/infiniband/hw/ehca/ehca_reqs.c             |    1 -
 drivers/input/joydev.c                             |    1 -
 drivers/input/joystick/amijoy.c                    |    1 -
 drivers/input/mouse/amimouse.c                     |    1 -
 drivers/input/mouse/atarimouse.c                   |    1 -
 drivers/input/serio/hp_sdc.c                       |    1 -
 drivers/input/serio/maceps2.c                      |    1 -
 drivers/input/serio/rpckbd.c                       |    1 -
 drivers/input/serio/sa1111ps2.c                    |    1 -
 drivers/isdn/hardware/avm/avm_cs.c                 |    1 -
 drivers/isdn/hisax/avma1_cs.c                      |    1 -
 drivers/isdn/hisax/elsa_cs.c                       |    1 -
 drivers/isdn/hisax/sedlbauer_cs.c                  |    1 -
 drivers/isdn/hisax/teles_cs.c                      |    1 -
 drivers/isdn/i4l/isdn_bsdcomp.c                    |    1 -
 drivers/isdn/pcbit/layer2.c                        |    1 -
 drivers/macintosh/macio-adb.c                      |    1 -
 drivers/macintosh/therm_adt746x.c                  |    1 -
 drivers/macintosh/therm_pm72.c                     |    1 -
 drivers/macintosh/therm_windtunnel.c               |    1 -
 drivers/macintosh/via-cuda.c                       |    1 -
 drivers/macintosh/via-macii.c                      |    1 -
 drivers/macintosh/via-pmu.c                        |    1 -
 drivers/macintosh/via-pmu68k.c                     |    1 -
 drivers/macintosh/windfarm_lm75_sensor.c           |    1 -
 drivers/macintosh/windfarm_pm121.c                 |    1 -
 drivers/macintosh/windfarm_pm81.c                  |    1 -
 drivers/macintosh/windfarm_pm91.c                  |    1 -
 drivers/macintosh/windfarm_smu_controls.c          |    1 -
 drivers/macintosh/windfarm_smu_sensors.c           |    1 -
 drivers/media/dvb/dvb-core/dmxdev.c                |    1 -
 drivers/media/dvb/firewire/firedtv-fw.c            |    1 -
 drivers/media/dvb/ttpci/av7110.c                   |    1 -
 drivers/media/media-devnode.c                      |    1 -
 drivers/media/video/ivtv/ivtv-driver.h             |    1 -
 drivers/media/video/v4l2-common.c                  |    1 -
 drivers/media/video/v4l2-dev.c                     |    1 -
 drivers/message/i2o/i2o_scsi.c                     |    1 -
 drivers/mfd/mcp-core.c                             |    1 -
 drivers/mfd/mcp-sa11x0.c                           |    1 -
 drivers/misc/sgi-xp/xp.h                           |    1 -
 drivers/mmc/card/block.c                           |    1 -
 drivers/mtd/devices/pmc551.c                       |    1 -
 drivers/mtd/devices/slram.c                        |    1 -
 drivers/mtd/maps/pcmciamtd.c                       |    1 -
 drivers/mtd/nand/bcm_umi_nand.c                    |    1 -
 drivers/net/appletalk/cops.c                       |    1 -
 drivers/net/appletalk/ltpc.c                       |    1 -
 drivers/net/arcnet/com20020_cs.c                   |    1 -
 drivers/net/bonding/bond_main.c                    |    1 -
 drivers/net/can/slcan.c                            |    1 -
 drivers/net/cris/eth_v10.c                         |    1 -
 drivers/net/ethernet/3com/3c574_cs.c               |    1 -
 drivers/net/ethernet/3com/3c589_cs.c               |    1 -
 drivers/net/ethernet/8390/3c503.c                  |    1 -
 drivers/net/ethernet/8390/ac3200.c                 |    1 -
 drivers/net/ethernet/8390/apne.c                   |    1 -
 drivers/net/ethernet/8390/ax88796.c                |    1 -
 drivers/net/ethernet/8390/axnet_cs.c               |    1 -
 drivers/net/ethernet/8390/e2100.c                  |    1 -
 drivers/net/ethernet/8390/es3210.c                 |    1 -
 drivers/net/ethernet/8390/etherh.c                 |    1 -
 drivers/net/ethernet/8390/hp-plus.c                |    1 -
 drivers/net/ethernet/8390/hp.c                     |    1 -
 drivers/net/ethernet/8390/lib8390.c                |    1 -
 drivers/net/ethernet/8390/lne390.c                 |    1 -
 drivers/net/ethernet/8390/mac8390.c                |    1 -
 drivers/net/ethernet/8390/ne-h8300.c               |    1 -
 drivers/net/ethernet/8390/ne.c                     |    1 -
 drivers/net/ethernet/8390/ne2.c                    |    1 -
 drivers/net/ethernet/8390/ne2k-pci.c               |    1 -
 drivers/net/ethernet/8390/ne3210.c                 |    1 -
 drivers/net/ethernet/8390/pcnet_cs.c               |    1 -
 drivers/net/ethernet/8390/smc-mca.c                |    1 -
 drivers/net/ethernet/8390/smc-ultra.c              |    1 -
 drivers/net/ethernet/8390/smc-ultra32.c            |    1 -
 drivers/net/ethernet/8390/stnic.c                  |    1 -
 drivers/net/ethernet/8390/wd.c                     |    1 -
 drivers/net/ethernet/8390/zorro8390.c              |    1 -
 drivers/net/ethernet/alteon/acenic.c               |    1 -
 drivers/net/ethernet/amd/7990.c                    |    1 -
 drivers/net/ethernet/amd/am79c961a.c               |    1 -
 drivers/net/ethernet/amd/amd8111e.c                |    1 -
 drivers/net/ethernet/amd/declance.c                |    1 -
 drivers/net/ethernet/amd/hplance.c                 |    1 -
 drivers/net/ethernet/amd/mvme147.c                 |    1 -
 drivers/net/ethernet/amd/nmclan_cs.c               |    1 -
 drivers/net/ethernet/amd/sunlance.c                |    1 -
 drivers/net/ethernet/broadcom/tg3.c                |    1 -
 drivers/net/ethernet/cirrus/cs89x0.c               |    1 -
 drivers/net/ethernet/cirrus/mac89x0.c              |    1 -
 drivers/net/ethernet/dlink/de600.c                 |    1 -
 drivers/net/ethernet/dlink/de620.c                 |    1 -
 drivers/net/ethernet/fujitsu/at1700.c              |    1 -
 drivers/net/ethernet/fujitsu/eth16i.c              |    1 -
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |    1 -
 drivers/net/ethernet/i825xx/3c507.c                |    1 -
 drivers/net/ethernet/i825xx/3c527.c                |    1 -
 drivers/net/ethernet/i825xx/eepro.c                |    1 -
 drivers/net/ethernet/i825xx/eexpress.c             |    1 -
 drivers/net/ethernet/i825xx/ether1.c               |    1 -
 drivers/net/ethernet/i825xx/znet.c                 |    1 -
 drivers/net/ethernet/korina.c                      |    1 -
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    1 -
 drivers/net/ethernet/marvell/pxa168_eth.c          |    1 -
 drivers/net/ethernet/natsemi/jazzsonic.c           |    1 -
 drivers/net/ethernet/natsemi/macsonic.c            |    1 -
 drivers/net/ethernet/natsemi/ns83820.c             |    1 -
 drivers/net/ethernet/neterion/s2io.c               |    1 -
 drivers/net/ethernet/nvidia/forcedeth.c            |    1 -
 drivers/net/ethernet/realtek/atp.c                 |    1 -
 drivers/net/ethernet/realtek/r8169.c               |    1 -
 drivers/net/ethernet/seeq/ether3.c                 |    1 -
 drivers/net/ethernet/seeq/seeq8005.c               |    1 -
 drivers/net/ethernet/smsc/smc91c92_cs.c            |    1 -
 drivers/net/ethernet/sun/cassini.c                 |    1 -
 drivers/net/ethernet/sun/sunbmac.c                 |    1 -
 drivers/net/ethernet/sun/sungem.c                  |    1 -
 drivers/net/ethernet/sun/sunhme.c                  |    1 -
 drivers/net/ethernet/sun/sunqe.c                   |    1 -
 drivers/net/ethernet/tundra/tsi108_eth.c           |    1 -
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    1 -
 drivers/net/hamradio/6pack.c                       |    1 -
 drivers/net/hamradio/baycom_par.c                  |    1 -
 drivers/net/hamradio/bpqether.c                    |    1 -
 drivers/net/hamradio/mkiss.c                       |    1 -
 drivers/net/hamradio/scc.c                         |    1 -
 drivers/net/hamradio/yam.c                         |    1 -
 drivers/net/hippi/rrunner.c                        |    1 -
 drivers/net/irda/donauboe.c                        |    1 -
 drivers/net/loopback.c                             |    1 -
 drivers/net/plip/plip.c                            |    1 -
 drivers/net/slip/slhc.c                            |    1 -
 drivers/net/slip/slip.c                            |    1 -
 drivers/net/tokenring/3c359.c                      |    1 -
 drivers/net/tokenring/abyss.c                      |    1 -
 drivers/net/tokenring/ibmtr_cs.c                   |    1 -
 drivers/net/tokenring/lanstreamer.c                |    1 -
 drivers/net/tokenring/madgemc.c                    |    1 -
 drivers/net/tokenring/olympic.c                    |    1 -
 drivers/net/tokenring/proteon.c                    |    1 -
 drivers/net/tokenring/skisa.c                      |    1 -
 drivers/net/tokenring/smctr.c                      |    1 -
 drivers/net/tokenring/tms380tr.c                   |    1 -
 drivers/net/tokenring/tmspci.c                     |    1 -
 drivers/net/tun.c                                  |    1 -
 drivers/net/wan/dlci.c                             |    1 -
 drivers/net/wan/dscc4.c                            |    1 -
 drivers/net/wan/hd64570.c                          |    1 -
 drivers/net/wan/hd64572.c                          |    1 -
 drivers/net/wan/lapbether.c                        |    1 -
 drivers/net/wan/sdla.c                             |    1 -
 drivers/net/wan/x25_asy.c                          |    1 -
 drivers/net/wireless/airo.c                        |    1 -
 drivers/net/wireless/airo_cs.c                     |    1 -
 drivers/net/wireless/atmel.c                       |    1 -
 drivers/net/wireless/atmel_cs.c                    |    1 -
 drivers/net/wireless/prism54/islpci_mgt.c          |    1 -
 drivers/net/wireless/ray_cs.c                      |    1 -
 drivers/net/wireless/wl3501_cs.c                   |    1 -
 drivers/nubus/nubus.c                              |    1 -
 drivers/parisc/dino.c                              |    1 -
 drivers/parisc/iosapic.c                           |    1 -
 drivers/parisc/lba_pci.c                           |    1 -
 drivers/pcmcia/cs.c                                |    1 -
 drivers/pcmcia/i82092.c                            |    1 -
 drivers/pcmcia/i82365.c                            |    1 -
 drivers/pcmcia/m32r_cfc.c                          |    1 -
 drivers/pcmcia/m32r_pcc.c                          |    1 -
 drivers/pcmcia/m8xx_pcmcia.c                       |    1 -
 drivers/pcmcia/pd6729.c                            |    1 -
 drivers/pcmcia/pxa2xx_base.c                       |    1 -
 drivers/pcmcia/sa11xx_base.c                       |    1 -
 drivers/pcmcia/soc_common.c                        |    1 -
 drivers/pcmcia/socket_sysfs.c                      |    1 -
 drivers/pcmcia/tcic.c                              |    1 -
 drivers/pcmcia/xxs1500_ss.c                        |    1 -
 drivers/pnp/pnpbios/bioscalls.c                    |    1 -
 drivers/pnp/pnpbios/core.c                         |    1 -
 drivers/s390/crypto/ap_bus.c                       |    1 -
 drivers/sbus/char/flash.c                          |    1 -
 drivers/sbus/char/openprom.c                       |    1 -
 drivers/sbus/char/uctrl.c                          |    1 -
 drivers/scsi/53c700.c                              |    1 -
 drivers/scsi/BusLogic.c                            |    1 -
 drivers/scsi/advansys.c                            |    1 -
 drivers/scsi/aha152x.c                             |    1 -
 drivers/scsi/aha1542.c                             |    1 -
 drivers/scsi/aha1740.c                             |    1 -
 drivers/scsi/arcmsr/arcmsr_hba.c                   |    1 -
 drivers/scsi/arm/acornscsi.c                       |    1 -
 drivers/scsi/arm/cumana_1.c                        |    1 -
 drivers/scsi/arm/oak.c                             |    1 -
 drivers/scsi/atp870u.c                             |    1 -
 drivers/scsi/dtc.c                                 |    1 -
 drivers/scsi/fd_mcs.c                              |    1 -
 drivers/scsi/fdomain.c                             |    1 -
 drivers/scsi/g_NCR5380.c                           |    1 -
 drivers/scsi/gdth.c                                |    1 -
 drivers/scsi/ibmmca.c                              |    1 -
 drivers/scsi/in2000.c                              |    1 -
 drivers/scsi/mac53c94.c                            |    1 -
 drivers/scsi/mac_scsi.c                            |    1 -
 drivers/scsi/mesh.c                                |    1 -
 drivers/scsi/ncr53c8xx.c                           |    1 -
 drivers/scsi/nsp32.c                               |    1 -
 drivers/scsi/osst.c                                |    1 -
 drivers/scsi/pas16.c                               |    1 -
 drivers/scsi/qla1280.c                             |    1 -
 drivers/scsi/qlogicpti.c                           |    1 -
 drivers/scsi/st.c                                  |    1 -
 drivers/scsi/sun3_scsi.c                           |    1 -
 drivers/scsi/sun3_scsi_vme.c                       |    1 -
 drivers/scsi/sym53c416.c                           |    1 -
 drivers/scsi/t128.c                                |    1 -
 drivers/scsi/u14-34f.c                             |    1 -
 drivers/scsi/ultrastor.c                           |    1 -
 drivers/scsi/wd7000.c                              |    1 -
 drivers/spi/spi-omap-uwire.c                       |    1 -
 drivers/staging/comedi/drivers.c                   |    1 -
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    1 -
 drivers/staging/comedi/drivers/mite.c              |    1 -
 drivers/staging/crystalhd/crystalhd_lnx.h          |    1 -
 drivers/staging/crystalhd/crystalhd_misc.h         |    1 -
 drivers/staging/et131x/et131x.c                    |    1 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    1 -
 drivers/staging/media/go7007/go7007-driver.c       |    1 -
 drivers/staging/media/go7007/go7007-i2c.c          |    1 -
 drivers/staging/media/go7007/go7007-v4l2.c         |    1 -
 drivers/staging/media/go7007/snd-go7007.c          |    1 -
 drivers/staging/media/lirc/lirc_serial.c           |    1 -
 drivers/staging/media/lirc/lirc_sir.c              |    1 -
 drivers/staging/panel/panel.c                      |    1 -
 drivers/staging/sbe-2t3e3/io.c                     |    1 -
 .../tidspbridge/include/dspbridge/host_os.h        |    1 -
 drivers/staging/wlags49_h2/wl_cs.c                 |    1 -
 drivers/staging/wlags49_h2/wl_main.c               |    3 +--
 drivers/staging/wlags49_h2/wl_netdev.c             |    3 +--
 drivers/staging/wlags49_h2/wl_pci.c                |    1 -
 drivers/staging/wlags49_h2/wl_util.c               |    3 +--
 drivers/telephony/phonedev.c                       |    1 -
 drivers/tty/amiserial.c                            |    1 -
 drivers/tty/isicom.c                               |    1 -
 drivers/tty/moxa.c                                 |    1 -
 drivers/tty/mxser.c                                |    1 -
 drivers/tty/n_hdlc.c                               |    1 -
 drivers/tty/n_tty.c                                |    1 -
 drivers/tty/pty.c                                  |    1 -
 drivers/tty/serial/68328serial.c                   |    1 -
 drivers/tty/serial/8250/serial_cs.c                |    1 -
 drivers/tty/serial/crisv10.c                       |    1 -
 drivers/tty/serial/dz.c                            |    1 -
 drivers/tty/serial/icom.c                          |    1 -
 drivers/tty/serial/msm_serial_hs.c                 |    1 -
 drivers/tty/serial/zs.c                            |    1 -
 drivers/tty/synclink.c                             |    1 -
 drivers/tty/synclink_gt.c                          |    1 -
 drivers/tty/synclinkmp.c                           |    1 -
 drivers/tty/tty_io.c                               |    1 -
 drivers/tty/tty_ioctl.c                            |    1 -
 drivers/tty/vt/vt.c                                |    1 -
 drivers/usb/gadget/amd5536udc.c                    |    1 -
 drivers/usb/gadget/at91_udc.c                      |    1 -
 drivers/usb/gadget/dummy_hcd.c                     |    1 -
 drivers/usb/gadget/fsl_udc_core.c                  |    1 -
 drivers/usb/gadget/goku_udc.c                      |    1 -
 drivers/usb/gadget/langwell_udc.c                  |    1 -
 drivers/usb/gadget/mv_udc_core.c                   |    1 -
 drivers/usb/gadget/net2272.c                       |    1 -
 drivers/usb/gadget/net2280.c                       |    1 -
 drivers/usb/gadget/omap_udc.c                      |    1 -
 drivers/usb/gadget/printer.c                       |    1 -
 drivers/usb/gadget/pxa25x_udc.c                    |    1 -
 drivers/usb/gadget/rndis.c                         |    1 -
 drivers/usb/gadget/s3c2410_udc.c                   |    1 -
 drivers/usb/host/ehci-hcd.c                        |    1 -
 drivers/usb/host/isp116x-hcd.c                     |    1 -
 drivers/usb/host/isp1362-hcd.c                     |    1 -
 drivers/usb/host/ohci-hcd.c                        |    1 -
 drivers/usb/host/oxu210hp-hcd.c                    |    1 -
 drivers/usb/host/sl811-hcd.c                       |    1 -
 drivers/usb/host/u132-hcd.c                        |    1 -
 drivers/usb/host/uhci-hcd.c                        |    1 -
 drivers/video/amifb.c                              |    1 -
 drivers/video/bt431.h                              |    1 -
 drivers/video/bt455.h                              |    1 -
 drivers/video/console/fbcon.c                      |    1 -
 drivers/video/console/newport_con.c                |    1 -
 drivers/video/cyber2000fb.c                        |    1 -
 drivers/video/dnfb.c                               |    1 -
 drivers/video/neofb.c                              |    1 -
 drivers/video/pmag-ba-fb.c                         |    1 -
 drivers/video/pmagb-b-fb.c                         |    1 -
 drivers/video/q40fb.c                              |    1 -
 drivers/video/savage/savagefb_driver.c             |    1 -
 drivers/virtio/config.c                            |    1 -
 drivers/watchdog/advantechwdt.c                    |    1 -
 drivers/watchdog/alim7101_wdt.c                    |    1 -
 drivers/watchdog/booke_wdt.c                       |    1 -
 drivers/watchdog/eurotechwdt.c                     |    1 -
 drivers/watchdog/ib700wdt.c                        |    1 -
 drivers/watchdog/it87_wdt.c                        |    1 -
 drivers/watchdog/machzwd.c                         |    1 -
 drivers/watchdog/pc87413_wdt.c                     |    1 -
 drivers/watchdog/sbc60xxwdt.c                      |    1 -
 drivers/watchdog/sbc7240_wdt.c                     |    1 -
 drivers/watchdog/sbc8360.c                         |    1 -
 drivers/watchdog/sbc_fitpc2_wdt.c                  |    1 -
 drivers/watchdog/sc520_wdt.c                       |    1 -
 drivers/watchdog/smsc37b787_wdt.c                  |    1 -
 drivers/watchdog/w83627hf_wdt.c                    |    1 -
 drivers/watchdog/w83697hf_wdt.c                    |    1 -
 drivers/watchdog/w83697ug_wdt.c                    |    1 -
 drivers/watchdog/w83877f_wdt.c                     |    1 -
 drivers/watchdog/w83977f_wdt.c                     |    1 -
 drivers/watchdog/wdt.c                             |    1 -
 drivers/watchdog/wdt977.c                          |    1 -
 drivers/watchdog/wdt_pci.c                         |    1 -
 fs/binfmt_aout.c                                   |    1 -
 fs/binfmt_flat.c                                   |    1 -
 fs/coda/inode.c                                    |    1 -
 fs/coda/psdev.c                                    |    1 -
 fs/coda/upcall.c                                   |    1 -
 fs/eventpoll.c                                     |    1 -
 fs/jbd2/commit.c                                   |    1 -
 fs/jbd2/journal.c                                  |    1 -
 fs/ncpfs/file.c                                    |    1 -
 fs/ncpfs/inode.c                                   |    1 -
 fs/ncpfs/mmap.c                                    |    1 -
 fs/nfs/client.c                                    |    1 -
 fs/nfs/direct.c                                    |    1 -
 fs/nfs/file.c                                      |    1 -
 fs/nfs/getroot.c                                   |    1 -
 fs/nfs/inode.c                                     |    1 -
 fs/nfs/read.c                                      |    1 -
 fs/nfs/super.c                                     |    1 -
 fs/proc/inode.c                                    |    1 -
 fs/reiserfs/journal.c                              |    1 -
 fs/ufs/inode.c                                     |    1 -
 fs/ufs/super.c                                     |    1 -
 fs/xfs/xfs_buf.h                                   |    1 -
 include/acpi/platform/aclinux.h                    |    1 -
 include/asm-generic/atomic.h                       |    1 -
 include/linux/cnt32_to_63.h                        |    1 -
 include/linux/debug_locks.h                        |    1 -
 include/linux/efi.h                                |    1 -
 include/linux/ide.h                                |    1 -
 include/linux/interrupt.h                          |    1 -
 include/linux/lsm_audit.h                          |    1 -
 include/linux/mtd/map.h                            |    1 -
 include/linux/parport.h                            |    1 -
 include/linux/rwsem.h                              |    1 -
 include/linux/sched.h                              |    1 -
 include/linux/skbuff.h                             |    1 -
 include/linux/spinlock.h                           |    1 -
 include/linux/stop_machine.h                       |    1 -
 include/linux/tty.h                                |    1 -
 include/linux/wait.h                               |    1 -
 kernel/debug/debug_core.c                          |    1 -
 kernel/debug/kdb/kdb_bt.c                          |    1 -
 kernel/dma.c                                       |    1 -
 kernel/kexec.c                                     |    1 -
 kernel/rwsem.c                                     |    1 -
 kernel/sysctl.c                                    |    1 -
 lib/llist.c                                        |    1 -
 lib/raid6/altivec.uc                               |    1 -
 net/802/fc.c                                       |    1 -
 net/802/fddi.c                                     |    1 -
 net/802/hippi.c                                    |    1 -
 net/802/tr.c                                       |    1 -
 net/atm/clip.c                                     |    1 -
 net/ax25/af_ax25.c                                 |    1 -
 net/ax25/ax25_addr.c                               |    1 -
 net/ax25/ax25_dev.c                                |    1 -
 net/ax25/ax25_ds_in.c                              |    1 -
 net/ax25/ax25_ds_subr.c                            |    1 -
 net/ax25/ax25_ds_timer.c                           |    1 -
 net/ax25/ax25_iface.c                              |    1 -
 net/ax25/ax25_in.c                                 |    1 -
 net/ax25/ax25_ip.c                                 |    1 -
 net/ax25/ax25_out.c                                |    1 -
 net/ax25/ax25_route.c                              |    1 -
 net/ax25/ax25_std_in.c                             |    1 -
 net/ax25/ax25_std_subr.c                           |    1 -
 net/ax25/ax25_std_timer.c                          |    1 -
 net/ax25/ax25_subr.c                               |    1 -
 net/ax25/ax25_timer.c                              |    1 -
 net/ax25/ax25_uid.c                                |    1 -
 net/bluetooth/bnep/sock.c                          |    1 -
 net/bluetooth/cmtp/sock.c                          |    1 -
 net/bluetooth/hci_conn.c                           |    1 -
 net/bluetooth/hci_core.c                           |    1 -
 net/bluetooth/hci_event.c                          |    1 -
 net/bluetooth/hci_sock.c                           |    1 -
 net/bluetooth/l2cap_core.c                         |    1 -
 net/bluetooth/rfcomm/sock.c                        |    1 -
 net/bluetooth/sco.c                                |    1 -
 net/core/datagram.c                                |    1 -
 net/core/dev.c                                     |    1 -
 net/core/filter.c                                  |    1 -
 net/core/gen_estimator.c                           |    1 -
 net/core/rtnetlink.c                               |    1 -
 net/core/scm.c                                     |    1 -
 net/core/skbuff.c                                  |    1 -
 net/core/sock.c                                    |    1 -
 net/core/utils.c                                   |    1 -
 net/decnet/af_decnet.c                             |    1 -
 net/decnet/dn_dev.c                                |    1 -
 net/decnet/dn_nsp_in.c                             |    1 -
 net/decnet/dn_nsp_out.c                            |    1 -
 net/econet/af_econet.c                             |    1 -
 net/ethernet/eth.c                                 |    1 -
 net/ipv4/af_inet.c                                 |    1 -
 net/ipv4/arp.c                                     |    1 -
 net/ipv4/devinet.c                                 |    1 -
 net/ipv4/fib_frontend.c                            |    1 -
 net/ipv4/fib_semantics.c                           |    1 -
 net/ipv4/fib_trie.c                                |    1 -
 net/ipv4/icmp.c                                    |    1 -
 net/ipv4/igmp.c                                    |    1 -
 net/ipv4/ip_input.c                                |    1 -
 net/ipv4/ip_output.c                               |    1 -
 net/ipv4/ipmr.c                                    |    1 -
 net/ipv4/ping.c                                    |    1 -
 net/ipv4/route.c                                   |    1 -
 net/ipv4/udp.c                                     |    1 -
 net/ipv6/af_inet6.c                                |    1 -
 net/ipv6/icmp.c                                    |    1 -
 net/ipv6/ip6mr.c                                   |    1 -
 net/irda/irlan/irlan_client.c                      |    1 -
 net/irda/irlan/irlan_common.c                      |    1 -
 net/irda/irlan/irlan_provider.c                    |    1 -
 net/irda/timer.c                                   |    1 -
 net/lapb/lapb_iface.c                              |    1 -
 net/lapb/lapb_in.c                                 |    1 -
 net/lapb/lapb_out.c                                |    1 -
 net/lapb/lapb_subr.c                               |    1 -
 net/lapb/lapb_timer.c                              |    1 -
 net/netfilter/ipvs/ip_vs_app.c                     |    1 -
 net/netfilter/ipvs/ip_vs_proto.c                   |    1 -
 net/netfilter/nfnetlink.c                          |    1 -
 net/netrom/af_netrom.c                             |    1 -
 net/netrom/nr_dev.c                                |    1 -
 net/netrom/nr_in.c                                 |    1 -
 net/netrom/nr_out.c                                |    1 -
 net/netrom/nr_route.c                              |    1 -
 net/netrom/nr_subr.c                               |    1 -
 net/netrom/nr_timer.c                              |    1 -
 net/openvswitch/datapath.c                         |    1 -
 net/packet/af_packet.c                             |    1 -
 net/rose/af_rose.c                                 |    1 -
 net/rose/rose_dev.c                                |    1 -
 net/rose/rose_in.c                                 |    1 -
 net/rose/rose_link.c                               |    1 -
 net/rose/rose_out.c                                |    1 -
 net/rose/rose_route.c                              |    1 -
 net/rose/rose_subr.c                               |    1 -
 net/rose/rose_timer.c                              |    1 -
 net/sunrpc/clnt.c                                  |    1 -
 security/selinux/include/avc.h                     |    1 -
 sound/oss/os.h                                     |    1 -
 sound/oss/vidc.c                                   |    1 -
 sound/oss/waveartist.c                             |    1 -
 sound/pci/asihpi/hpios.h                           |    1 -
 sound/pci/aw2/aw2-saa7146.c                        |    1 -
 509 files changed, 3 insertions(+), 512 deletions(-)

diff --git a/arch/um/include/asm/fixmap.h b/arch/um/include/asm/fixmap.h
index 69c0252..21a423b 100644
--- a/arch/um/include/asm/fixmap.h
+++ b/arch/um/include/asm/fixmap.h
@@ -2,7 +2,6 @@
 #define __UM_FIXMAP_H
 
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/kmap_types.h>
 #include <asm/archparam.h>
 #include <asm/page.h>
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 8ae05ce..28b3f24 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/cpu.h>
 #include <asm/delay.h>
 #include <asm/uaccess.h>
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 956e9ac..0f3068b 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -19,7 +19,6 @@
 #include <linux/atm_eni.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
 #include <asm/uaccess.h>
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 5072f8a..86fed1b 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -49,7 +49,6 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/string.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index b812103..75fd691 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -43,7 +43,6 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
 #include <asm/uaccess.h>
diff --git a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
index 487a547..45d5063 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -16,7 +16,6 @@
 #include <linux/atm_idt77105.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/param.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 9e373ba..d438601 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -56,7 +56,6 @@
 #include <linux/interrupt.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
-#include <asm/system.h>  
 #include <asm/io.h>  
 #include <linux/atomic.h>
 #include <asm/uaccess.h>  
diff --git a/drivers/atm/suni.c b/drivers/atm/suni.c
index 90f1ccc..0215934 100644
--- a/drivers/atm/suni.c
+++ b/drivers/atm/suni.c
@@ -22,7 +22,6 @@
 #include <linux/capability.h>
 #include <linux/atm_suni.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/param.h>
 #include <asm/uaccess.h>
 #include <linux/atomic.h>
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index d889f56..abe4e20 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -24,7 +24,6 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/string.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 744f078..76a0823 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -202,7 +202,6 @@ static int slow_floppy;
 
 #include <asm/dma.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 static int FLOPPY_IRQ = 6;
 static int FLOPPY_DMA = 2;
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index b52c9ca..bf397bf 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -44,7 +44,6 @@
 #define HD_IRQ 14
 
 #define REALLY_SLOW_IO
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c3f0ee1..c7ba11f 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -34,7 +34,6 @@
 #include <linux/kthread.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/types.h>
 
 #include <linux/nbd.h>
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 51a9727..ff54052 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -52,7 +52,6 @@
 #include <linux/io.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
 
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 0c97e5d..6bed9ae 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -39,7 +39,6 @@
 #include <linux/serial.h>
 #include <linux/serial_reg.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <linux/device.h>
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index 200b3a2..5b52cd3 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -38,7 +38,6 @@
 #include <linux/serial.h>
 #include <linux/serial_reg.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <pcmcia/cistpl.h>
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 969bb22..b5bf4ed 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -38,7 +38,6 @@
 #include <linux/serial.h>
 #include <linux/serial_reg.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <pcmcia/cistpl.h>
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index f4837a8..57501ca 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -31,7 +31,6 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 
 /*
  * The apm_bios device is one of the misc char devices.
diff --git a/drivers/char/ds1302.c b/drivers/char/ds1302.c
index ed8303f9..7d34b20 100644
--- a/drivers/char/ds1302.c
+++ b/drivers/char/ds1302.c
@@ -24,7 +24,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/rtc.h>
 #if defined(CONFIG_M32R)
 #include <asm/m32r.h>
diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index 53c524e..a082d00 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -37,7 +37,6 @@
 #include <linux/efi.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define EFI_RTC_VERSION		"0.4"
 
diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index f773a9d..21cb980 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -56,7 +56,6 @@
 #include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/rtc.h>
 
 /*
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 0833896..3845ab4 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -36,7 +36,6 @@
 #include <linux/io.h>
 
 #include <asm/current.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/div64.h>
 
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 2aa3977..9eb360f 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
-#include <asm/system.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 58c0e63..c90e939 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -33,7 +33,6 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <asm/system.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 50fcf9c..f9fdc11 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -41,7 +41,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <asm/system.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/timer.h>
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index f434856..0fbf1a7 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -135,7 +135,6 @@
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 /* if you have more than 8 printers, remember to increase LP_NO */
 #define LP_NO 8
diff --git a/drivers/char/mbcs.c b/drivers/char/mbcs.c
index 1aeaaba..47ff7e4 100644
--- a/drivers/char/mbcs.c
+++ b/drivers/char/mbcs.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/intr.h>
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 5c0d96a..8b78750 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -44,7 +44,6 @@
 #include <linux/slab.h>
 #include <linux/numa.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <linux/atomic.h>
 #include <asm/tlbflush.h>
diff --git a/drivers/char/mwave/3780i.c b/drivers/char/mwave/3780i.c
index 492dbfb..881c9e5 100644
--- a/drivers/char/mwave/3780i.c
+++ b/drivers/char/mwave/3780i.c
@@ -56,7 +56,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include "smapi.h"
 #include "mwavedd.h"
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index da3cfee..c8be0b2 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -111,7 +111,6 @@
 #include <linux/uaccess.h>
 #include <linux/mutex.h>
 
-#include <asm/system.h>
 
 static DEFINE_MUTEX(nvram_mutex);
 static DEFINE_SPINLOCK(nvram_state_lock);
diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index bf586ae..d45c334 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -32,7 +32,6 @@
 #include <asm/io.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /*****************************************************************************/
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 07f6a5a..9dc49f6 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -60,7 +60,6 @@
 #include <linux/ioctl.h>
 #include <linux/synclink.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index ccd124a..3bef48e 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -83,7 +83,6 @@
 #include <linux/ratelimit.h>
 
 #include <asm/current.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_X86
 #include <asm/hpet.h>
diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 1ee8ce7..45713f0 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -54,7 +54,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <linux/sonypi.h>
 
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index e90e1c7..31ba11c 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -89,7 +89,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_OF
 /* For open firmware. */
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 5d04c57..3093ca6 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -26,7 +26,6 @@
 #include <linux/cpu.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/smp_plat.h>
 #include <asm/cpu.h>
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index d71d9f3..a02956f 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -27,7 +27,6 @@
 
 #include <asm/timer.h>		/* Needed for recalibrate_cpu_khz() */
 #include <asm/msr.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_X86_POWERNOW_K7_ACPI
 #include <linux/acpi.h>
diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 4799393..1d6681b 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -44,7 +44,6 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
-#include <asm/system.h>
 
 #include "core.h"
 
diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index f3b890d..4c5ae39 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -40,7 +40,6 @@
 
 #include <linux/atomic.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 #include "core.h"
 
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 94d3b49..00be322 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -31,7 +31,6 @@
 
 #include <linux/atomic.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 #include "core.h"
 
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 7f5f0da..c7ce8a8 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -46,7 +46,6 @@
 
 #include <asm/byteorder.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_PPC_PMAC
 #include <asm/pmac_feature.h>
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 80e95aa..054bae4 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -52,7 +52,6 @@
 #include <linux/workqueue.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/i2c/busses/i2c-acorn.c b/drivers/i2c/busses/i2c-acorn.c
index 8679648..ed9f48d 100644
--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -19,7 +19,6 @@
 
 #include <mach/hardware.h>
 #include <asm/hardware/ioc.h>
-#include <asm/system.h>
 
 #define FORCE_ONES	0xdc
 #define SCL		0x02
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index d2f3db3..28e344e 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -41,7 +41,6 @@
 #include <linux/major.h>
 #include <linux/delay.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 8bbfe55..e03f4f1 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -29,7 +29,6 @@
 #include <linux/blkdev.h>
 #include <linux/ide.h>
 #include <linux/init.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #define DRV_NAME "qd65xx"
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 9a3fbfc..fd05f48 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -42,7 +42,6 @@
  */
 
 
-#include <asm/system.h>
 #include "ehca_classes.h"
 #include "ehca_tools.h"
 #include "ehca_qes.h"
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index c24ec2d..26043cc 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -13,7 +13,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/joystick.h>
diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index 0bc8620..24044da 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -35,7 +35,6 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 
-#include <asm/system.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
 
diff --git a/drivers/input/mouse/amimouse.c b/drivers/input/mouse/amimouse.c
index ff5f61a..5fa9934 100644
--- a/drivers/input/mouse/amimouse.c
+++ b/drivers/input/mouse/amimouse.c
@@ -25,7 +25,6 @@
 
 #include <asm/irq.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
diff --git a/drivers/input/mouse/atarimouse.c b/drivers/input/mouse/atarimouse.c
index 5c4a692..d1c4323 100644
--- a/drivers/input/mouse/atarimouse.c
+++ b/drivers/input/mouse/atarimouse.c
@@ -47,7 +47,6 @@
 
 #include <asm/irq.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/atarihw.h>
 #include <asm/atarikb.h>
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index be33160..09a0899 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -71,7 +71,6 @@
 #include <linux/slab.h>
 #include <linux/hil.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /* Machine-specific abstraction */
 
diff --git a/drivers/input/serio/maceps2.c b/drivers/input/serio/maceps2.c
index 558200e..61da763 100644
--- a/drivers/input/serio/maceps2.c
+++ b/drivers/input/serio/maceps2.c
@@ -21,7 +21,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/ip32/mace.h>
 #include <asm/ip32/ip32_ints.h>
 
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 8b44ddc..d8aac17 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -39,7 +39,6 @@
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <asm/hardware/iomd.h>
-#include <asm/system.h>
 
 MODULE_AUTHOR("Vojtech Pavlik, Russell King");
 MODULE_DESCRIPTION("Acorn RiscPC PS/2 keyboard controller driver");
diff --git a/drivers/input/serio/sa1111ps2.c b/drivers/input/serio/sa1111ps2.c
index 44fc8b4..e3c85fa 100644
--- a/drivers/input/serio/sa1111ps2.c
+++ b/drivers/input/serio/sa1111ps2.c
@@ -20,7 +20,6 @@
 #include <linux/spinlock.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <asm/hardware/sa1111.h>
 
diff --git a/drivers/isdn/hardware/avm/avm_cs.c b/drivers/isdn/hardware/avm/avm_cs.c
index 61f516f..c263ce6 100644
--- a/drivers/isdn/hardware/avm/avm_cs.c
+++ b/drivers/isdn/hardware/avm/avm_cs.c
@@ -18,7 +18,6 @@
 #include <linux/serial.h>
 #include <linux/major.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ciscode.h>
diff --git a/drivers/isdn/hisax/avma1_cs.c b/drivers/isdn/hisax/avma1_cs.c
index 8f0ad2a..568e6dc 100644
--- a/drivers/isdn/hisax/avma1_cs.c
+++ b/drivers/isdn/hisax/avma1_cs.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
diff --git a/drivers/isdn/hisax/elsa_cs.c b/drivers/isdn/hisax/elsa_cs.c
index f0b6c0e..4a57e9a 100644
--- a/drivers/isdn/hisax/elsa_cs.c
+++ b/drivers/isdn/hisax/elsa_cs.c
@@ -44,7 +44,6 @@
 #include <linux/timer.h>
 #include <linux/ioport.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/isdn/hisax/sedlbauer_cs.c b/drivers/isdn/hisax/sedlbauer_cs.c
index 06473f8..cb59b40 100644
--- a/drivers/isdn/hisax/sedlbauer_cs.c
+++ b/drivers/isdn/hisax/sedlbauer_cs.c
@@ -44,7 +44,6 @@
 #include <linux/timer.h>
 #include <linux/ioport.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/isdn/hisax/teles_cs.c b/drivers/isdn/hisax/teles_cs.c
index 161a193..81832a3 100644
--- a/drivers/isdn/hisax/teles_cs.c
+++ b/drivers/isdn/hisax/teles_cs.c
@@ -25,7 +25,6 @@
 #include <linux/timer.h>
 #include <linux/ioport.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/isdn/i4l/isdn_bsdcomp.c b/drivers/isdn/i4l/isdn_bsdcomp.c
index aa0b6a6..9f72702 100644
--- a/drivers/isdn/i4l/isdn_bsdcomp.c
+++ b/drivers/isdn/i4l/isdn_bsdcomp.c
@@ -69,7 +69,6 @@
 #include <linux/signal.h>	/* used in new tty drivers */
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/types.h>
 
diff --git a/drivers/isdn/pcbit/layer2.c b/drivers/isdn/pcbit/layer2.c
index 30f0f45..13e2c37 100644
--- a/drivers/isdn/pcbit/layer2.c
+++ b/drivers/isdn/pcbit/layer2.c
@@ -36,7 +36,6 @@
 
 #include <linux/isdnif.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 
diff --git a/drivers/macintosh/macio-adb.c b/drivers/macintosh/macio-adb.c
index b6ef8f5..87de8d9 100644
--- a/drivers/macintosh/macio-adb.c
+++ b/drivers/macintosh/macio-adb.c
@@ -14,7 +14,6 @@
 #include <asm/pgtable.h>
 #include <asm/hydra.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 
diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
index c60d025..fc71723 100644
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -29,7 +29,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 
 #undef DEBUG
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index 0ff92c2..97cfc5a 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -127,7 +127,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/macio.h>
 
diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 46c4e95..3b4a157 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -41,7 +41,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/macio.h>
 
diff --git a/drivers/macintosh/via-cuda.c b/drivers/macintosh/via-cuda.c
index 971bc95..86511c5 100644
--- a/drivers/macintosh/via-cuda.c
+++ b/drivers/macintosh/via-cuda.c
@@ -26,7 +26,6 @@
 #include <asm/mac_via.h>
 #endif
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/init.h>
 
 static volatile unsigned char __iomem *via;
diff --git a/drivers/macintosh/via-macii.c b/drivers/macintosh/via-macii.c
index c9570fc..3725f08 100644
--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -34,7 +34,6 @@
 #include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/mac_via.h>
-#include <asm/system.h>
 
 static volatile unsigned char *via;
 
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 6cccd60..22b8ce4 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -50,7 +50,6 @@
 #include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/irq.h>
 #include <asm/pmac_feature.h>
diff --git a/drivers/macintosh/via-pmu68k.c b/drivers/macintosh/via-pmu68k.c
index aeb30d0..a00ee41 100644
--- a/drivers/macintosh/via-pmu68k.c
+++ b/drivers/macintosh/via-pmu68k.c
@@ -37,7 +37,6 @@
 #include <asm/mac_via.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index 647c6ad..4d6a90a 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -18,7 +18,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/pmac_low_i2c.h>
 
diff --git a/drivers/macintosh/windfarm_pm121.c b/drivers/macintosh/windfarm_pm121.c
index 30e6195..04067e0 100644
--- a/drivers/macintosh/windfarm_pm121.c
+++ b/drivers/macintosh/windfarm_pm121.c
@@ -215,7 +215,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/macintosh/windfarm_pm81.c b/drivers/macintosh/windfarm_pm81.c
index 749d174..fc13d0f 100644
--- a/drivers/macintosh/windfarm_pm81.c
+++ b/drivers/macintosh/windfarm_pm81.c
@@ -107,7 +107,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/macintosh/windfarm_pm91.c b/drivers/macintosh/windfarm_pm91.c
index 3442732..a9430ed 100644
--- a/drivers/macintosh/windfarm_pm91.c
+++ b/drivers/macintosh/windfarm_pm91.c
@@ -41,7 +41,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/macintosh/windfarm_smu_controls.c b/drivers/macintosh/windfarm_smu_controls.c
index 43137b4..3c2be51 100644
--- a/drivers/macintosh/windfarm_smu_controls.c
+++ b/drivers/macintosh/windfarm_smu_controls.c
@@ -18,7 +18,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/macintosh/windfarm_smu_sensors.c b/drivers/macintosh/windfarm_smu_sensors.c
index 3c19350..1cc4e49 100644
--- a/drivers/macintosh/windfarm_smu_sensors.c
+++ b/drivers/macintosh/windfarm_smu_sensors.c
@@ -18,7 +18,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index e4b5c03..73970cd 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -29,7 +29,6 @@
 #include <linux/ioctl.h>
 #include <linux/wait.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include "dmxdev.h"
 
 static int debug;
diff --git a/drivers/media/dvb/firewire/firedtv-fw.c b/drivers/media/dvb/firewire/firedtv-fw.c
index 864b627..e24ec53 100644
--- a/drivers/media/dvb/firewire/firedtv-fw.c
+++ b/drivers/media/dvb/firewire/firedtv-fw.c
@@ -20,7 +20,6 @@
 #include <linux/workqueue.h>
 
 #include <asm/page.h>
-#include <asm/system.h>
 
 #include <dvb_demux.h>
 
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 6ecbcf6..4bd8bd5 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -53,7 +53,6 @@
 #include <asm/unaligned.h>
 #include <asm/byteorder.h>
 
-#include <asm/system.h>
 
 #include <linux/dvb/frontend.h>
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 7b42ace..04d6d54 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -40,7 +40,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #include <media/media-devnode.h>
 
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 06f3d78..52d5dd7 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -54,7 +54,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include <linux/dvb/video.h>
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 5c6100f..1baec83 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -55,7 +55,6 @@
 #include <linux/spi/spi.h>
 #endif
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/div64.h>
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 96e9615..8546f81 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -26,7 +26,6 @@
 #include <linux/kmod.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index c8ed7b6..1d31d72 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -57,7 +57,6 @@
 #include <linux/scatterlist.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
 
diff --git a/drivers/mfd/mcp-core.c b/drivers/mfd/mcp-core.c
index 86cc3f7..32c82de 100644
--- a/drivers/mfd/mcp-core.c
+++ b/drivers/mfd/mcp-core.c
@@ -20,7 +20,6 @@
 #include <linux/mfd/mcp.h>
 
 #include <mach/dma.h>
-#include <asm/system.h>
 
 
 #define to_mcp(d)		container_of(d, struct mcp, attached_device)
diff --git a/drivers/mfd/mcp-sa11x0.c b/drivers/mfd/mcp-sa11x0.c
index 02c53a0..4a27c2b 100644
--- a/drivers/mfd/mcp-sa11x0.c
+++ b/drivers/mfd/mcp-sa11x0.c
@@ -23,7 +23,6 @@
 #include <mach/dma.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 #include <mach/mcp.h>
 
 #include <mach/assabet.h>
diff --git a/drivers/misc/sgi-xp/xp.h b/drivers/misc/sgi-xp/xp.h
index 851b2f2..c862cd4 100644
--- a/drivers/misc/sgi-xp/xp.h
+++ b/drivers/misc/sgi-xp/xp.h
@@ -25,7 +25,6 @@
 #endif
 
 #if defined CONFIG_IA64
-#include <asm/system.h>
 #include <asm/sn/arch.h>	/* defines is_shub1() and is_shub2() */
 #define is_shub()	ia64_platform_is("sn2")
 #endif
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index c6a383d..b869dfb 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -41,7 +41,6 @@
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/sd.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "queue.h"
diff --git a/drivers/mtd/devices/pmc551.c b/drivers/mtd/devices/pmc551.c
index ecff765..5d53c57 100644
--- a/drivers/mtd/devices/pmc551.c
+++ b/drivers/mtd/devices/pmc551.c
@@ -93,7 +93,6 @@
 #include <linux/fs.h>
 #include <linux/ioctl.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/pci.h>
 
 #include <linux/mtd/mtd.h>
diff --git a/drivers/mtd/devices/slram.c b/drivers/mtd/devices/slram.c
index e585263..2885941 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -42,7 +42,6 @@
 #include <linux/ioctl.h>
 #include <linux/init.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <linux/mtd/mtd.h>
 
diff --git a/drivers/mtd/maps/pcmciamtd.c b/drivers/mtd/maps/pcmciamtd.c
index e8e9fec..0259cf5 100644
--- a/drivers/mtd/maps/pcmciamtd.c
+++ b/drivers/mtd/maps/pcmciamtd.c
@@ -14,7 +14,6 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
index 50387fd..64c9cba 100644
--- a/drivers/mtd/nand/bcm_umi_nand.c
+++ b/drivers/mtd/nand/bcm_umi_nand.c
@@ -31,7 +31,6 @@
 #include <linux/mtd/partitions.h>
 
 #include <asm/mach-types.h>
-#include <asm/system.h>
 
 #include <mach/reg_nand.h>
 #include <mach/reg_umi.h>
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index 9abd4eb..dd5e048 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -70,7 +70,6 @@ static const char *version =
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index 6057b30..0910dce 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -229,7 +229,6 @@ static int dma;
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/io.h>
 
diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
index 980e65c..5bed4c4 100644
--- a/drivers/net/arcnet/com20020_cs.c
+++ b/drivers/net/arcnet/com20020_cs.c
@@ -47,7 +47,6 @@
 #include <pcmcia/ds.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #define VERSION "arcnet: COM20020 PCMCIA support loaded.\n"
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 435984a..5306c2b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -54,7 +54,6 @@
 #include <linux/inet.h>
 #include <linux/bitops.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <linux/uaccess.h>
 #include <linux/errno.h>
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 3f1ebcc..48377da 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -40,7 +40,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 7cb2785..ec03b40 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -35,7 +35,6 @@
 #include <asm/io.h>         /* CRIS_LED_* I/O functions */
 #include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/ethernet.h>
 #include <asm/cache.h>
 #include <arch/io_interface_mux.h>
diff --git a/drivers/net/ethernet/3com/3c574_cs.c b/drivers/net/ethernet/3com/3c574_cs.c
index 9c01bc9..4638d66 100644
--- a/drivers/net/ethernet/3com/3c574_cs.c
+++ b/drivers/net/ethernet/3com/3c574_cs.c
@@ -95,7 +95,6 @@ earlier 3Com products.
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /*====================================================================*/
 
diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
index da410f0..61c0f22 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -50,7 +50,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /* To minimize the size of the driver source I only define operating
    constants if they are used several times.  You'll need the manual
diff --git a/drivers/net/ethernet/8390/3c503.c b/drivers/net/ethernet/8390/3c503.c
index fbab136..49d76bd 100644
--- a/drivers/net/ethernet/8390/3c503.c
+++ b/drivers/net/ethernet/8390/3c503.c
@@ -54,7 +54,6 @@ static const char version[] =
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include "8390.h"
diff --git a/drivers/net/ethernet/8390/ac3200.c b/drivers/net/ethernet/8390/ac3200.c
index 5337dd0..ccf0794 100644
--- a/drivers/net/ethernet/8390/ac3200.c
+++ b/drivers/net/ethernet/8390/ac3200.c
@@ -34,7 +34,6 @@ static const char version[] =
 #include <linux/init.h>
 #include <linux/interrupt.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index 3ad5d2f..9239592 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -39,7 +39,6 @@
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/setup.h>
 #include <asm/amigaints.h>
diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/8390/ax88796.c
index 0f92e35..a0d654d 100644
--- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -31,7 +31,6 @@
 
 #include <net/ax88796.h>
 
-#include <asm/system.h>
 
 /* Rename the lib8390.c functions to show that they are in this driver */
 #define __ei_open ax_ei_open
diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index bba51cd..631aafd 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -46,7 +46,6 @@
 #include <pcmcia/cisreg.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/net/ethernet/8390/e2100.c b/drivers/net/ethernet/8390/e2100.c
index d16dc53..ed55ce8 100644
--- a/drivers/net/ethernet/8390/e2100.c
+++ b/drivers/net/ethernet/8390/e2100.c
@@ -48,7 +48,6 @@ static const char version[] =
 #include <linux/delay.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/es3210.c b/drivers/net/ethernet/8390/es3210.c
index 6428f9e..ba1b5c9 100644
--- a/drivers/net/ethernet/8390/es3210.c
+++ b/drivers/net/ethernet/8390/es3210.c
@@ -59,7 +59,6 @@ static const char version[] =
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/etherh.c b/drivers/net/ethernet/8390/etherh.c
index a45b0d8..dbefd56 100644
--- a/drivers/net/ethernet/8390/etherh.c
+++ b/drivers/net/ethernet/8390/etherh.c
@@ -45,7 +45,6 @@
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/ecard.h>
 #include <asm/io.h>
 #include <asm/system_info.h>
diff --git a/drivers/net/ethernet/8390/hp-plus.c b/drivers/net/ethernet/8390/hp-plus.c
index d42938b..52f70f9 100644
--- a/drivers/net/ethernet/8390/hp-plus.c
+++ b/drivers/net/ethernet/8390/hp-plus.c
@@ -33,7 +33,6 @@ static const char version[] =
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "8390.h"
diff --git a/drivers/net/ethernet/8390/hp.c b/drivers/net/ethernet/8390/hp.c
index 113f1e0..37fa89a 100644
--- a/drivers/net/ethernet/8390/hp.c
+++ b/drivers/net/ethernet/8390/hp.c
@@ -33,7 +33,6 @@ static const char version[] =
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "8390.h"
diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
index 05ae214..fda5348 100644
--- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -57,7 +57,6 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <asm/irq.h>
diff --git a/drivers/net/ethernet/8390/lne390.c b/drivers/net/ethernet/8390/lne390.c
index 69490ae..479409b 100644
--- a/drivers/net/ethernet/8390/lne390.c
+++ b/drivers/net/ethernet/8390/lne390.c
@@ -46,7 +46,6 @@ static const char *version =
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8390/mac8390.c
index af5d982..88ccc8b 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -37,7 +37,6 @@
 #include <linux/bitops.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/hwtest.h>
 #include <asm/macints.h>
diff --git a/drivers/net/ethernet/8390/ne-h8300.c b/drivers/net/ethernet/8390/ne-h8300.c
index 9b9c77d..7fc28f2 100644
--- a/drivers/net/ethernet/8390/ne-h8300.c
+++ b/drivers/net/ethernet/8390/ne-h8300.c
@@ -29,7 +29,6 @@ static const char version1[] =
 #include <linux/etherdevice.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index f92ea2a..d04911d 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -53,7 +53,6 @@ static const char version2[] =
 #include <linux/jiffies.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "8390.h"
diff --git a/drivers/net/ethernet/8390/ne2.c b/drivers/net/ethernet/8390/ne2.c
index 922b320..ef85839 100644
--- a/drivers/net/ethernet/8390/ne2.c
+++ b/drivers/net/ethernet/8390/ne2.c
@@ -76,7 +76,6 @@ static const char *version = "ne2.c:v0.91 Nov 16 1998 Wim Dumon <wimpie@kotnet.o
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8390/ne2k-pci.c
index 3fab04a..5e8845f 100644
--- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -54,7 +54,6 @@ static int options[MAX_UNITS];
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/ethernet/8390/ne3210.c b/drivers/net/ethernet/8390/ne3210.c
index 2a3e805..a2f8b2b 100644
--- a/drivers/net/ethernet/8390/ne3210.c
+++ b/drivers/net/ethernet/8390/ne3210.c
@@ -39,7 +39,6 @@
 #include <linux/mm.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
index 053b255..e29d5f1 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -49,7 +49,6 @@
 #include <pcmcia/cisreg.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/net/ethernet/8390/smc-mca.c b/drivers/net/ethernet/8390/smc-mca.c
index 77efec4..7a68590 100644
--- a/drivers/net/ethernet/8390/smc-mca.c
+++ b/drivers/net/ethernet/8390/smc-mca.c
@@ -47,7 +47,6 @@
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/smc-ultra.c b/drivers/net/ethernet/8390/smc-ultra.c
index 1cc306a..b0fbce3 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -69,7 +69,6 @@ static const char version[] =
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/smc-ultra32.c b/drivers/net/ethernet/8390/smc-ultra32.c
index bb87053..923e42a 100644
--- a/drivers/net/ethernet/8390/smc-ultra32.c
+++ b/drivers/net/ethernet/8390/smc-ultra32.c
@@ -57,7 +57,6 @@ static const char *version = "smc-ultra32.c: 06/97 v1.00\n";
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/stnic.c b/drivers/net/ethernet/8390/stnic.c
index 3b90375..8df4c41 100644
--- a/drivers/net/ethernet/8390/stnic.c
+++ b/drivers/net/ethernet/8390/stnic.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <mach-se/mach/se.h>
 #include <asm/machvec.h>
diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index c175fad..03eb3ee 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -39,7 +39,6 @@ static const char version[] =
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/zorro8390.c b/drivers/net/ethernet/8390/zorro8390.c
index bcd2732..7818e63 100644
--- a/drivers/net/ethernet/8390/zorro8390.c
+++ b/drivers/net/ethernet/8390/zorro8390.c
@@ -31,7 +31,6 @@
 #include <linux/zorro.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index f872748..5a441e2 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -78,7 +78,6 @@
 #include <net/sock.h>
 #include <net/ip.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/ethernet/amd/7990.c b/drivers/net/ethernet/amd/7990.c
index 60b35fb..eafe266 100644
--- a/drivers/net/ethernet/amd/7990.c
+++ b/drivers/net/ethernet/amd/7990.c
@@ -33,7 +33,6 @@
 #include <linux/socket.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/pgtable.h>
diff --git a/drivers/net/ethernet/amd/am79c961a.c b/drivers/net/ethernet/amd/am79c961a.c
index 7d5ded8..6f7b4e8 100644
--- a/drivers/net/ethernet/amd/am79c961a.c
+++ b/drivers/net/ethernet/amd/am79c961a.c
@@ -30,7 +30,6 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/system.h>
 
 #define TX_BUFFERS 15
 #define RX_BUFFERS 25
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 33e0a8c..135ddbe 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -88,7 +88,6 @@ Revision History:
 #include <linux/crc32.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
index 73f8d4f..4b1fb99 100644
--- a/drivers/net/ethernet/amd/declance.c
+++ b/drivers/net/ethernet/amd/declance.c
@@ -64,7 +64,6 @@
 #include <linux/types.h>
 
 #include <asm/addrspace.h>
-#include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
 #include <asm/dec/ioasic.h>
diff --git a/drivers/net/ethernet/amd/hplance.c b/drivers/net/ethernet/amd/hplance.c
index 86aa0d5..fd5babe 100644
--- a/drivers/net/ethernet/amd/hplance.c
+++ b/drivers/net/ethernet/amd/hplance.c
@@ -22,7 +22,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 
diff --git a/drivers/net/ethernet/amd/mvme147.c b/drivers/net/ethernet/amd/mvme147.c
index 56bc47a9..9af3c30 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -22,7 +22,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/mvme147hw.h>
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 6be0dd6..c636a18 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -154,7 +154,6 @@ Include Files
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /* ----------------------------------------------------------------------------
 Defines
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
index 7ea16d3..bbb73ba 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -95,7 +95,6 @@ static char lancestr[] = "LANCE";
 #include <linux/of_device.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/pgtable.h>
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 35c2a20..004fff6 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -48,7 +48,6 @@
 #include <net/checksum.h>
 #include <net/ip.h>
 
-#include <asm/system.h>
 #include <linux/io.h>
 #include <asm/byteorder.h>
 #include <linux/uaccess.h>
diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index f328da2..7b7c925 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -148,7 +148,6 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #if ALLOW_DMA
diff --git a/drivers/net/ethernet/cirrus/mac89x0.c b/drivers/net/ethernet/cirrus/mac89x0.c
index 83781f3..966ac81 100644
--- a/drivers/net/ethernet/cirrus/mac89x0.c
+++ b/drivers/net/ethernet/cirrus/mac89x0.c
@@ -99,7 +99,6 @@ static char *version =
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/hwtest.h>
 #include <asm/macints.h>
diff --git a/drivers/net/ethernet/dlink/de600.c b/drivers/net/ethernet/dlink/de600.c
index c24fab1..e3a3273 100644
--- a/drivers/net/ethernet/dlink/de600.c
+++ b/drivers/net/ethernet/dlink/de600.c
@@ -46,7 +46,6 @@ static const char version[] = "de600.c: $Revision: 1.41-2.5 $,  Bjorn Ekwall (bj
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/in.h>
-#include <asm/system.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff --git a/drivers/net/ethernet/dlink/de620.c b/drivers/net/ethernet/dlink/de620.c
index 3b934ab..5a4513b 100644
--- a/drivers/net/ethernet/dlink/de620.c
+++ b/drivers/net/ethernet/dlink/de620.c
@@ -122,7 +122,6 @@ static const char version[] =
 #include <linux/skbuff.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 /* Constant definitions for the DE-620 registers, commands and bits */
 #include "de620.h"
diff --git a/drivers/net/ethernet/fujitsu/at1700.c b/drivers/net/ethernet/fujitsu/at1700.c
index 7c6c908..c8e92bc 100644
--- a/drivers/net/ethernet/fujitsu/at1700.c
+++ b/drivers/net/ethernet/fujitsu/at1700.c
@@ -52,7 +52,6 @@
 #include <linux/crc32.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/fujitsu/eth16i.c b/drivers/net/ethernet/fujitsu/eth16i.c
index b0e2313..2485e87 100644
--- a/drivers/net/ethernet/fujitsu/eth16i.c
+++ b/drivers/net/ethernet/fujitsu/eth16i.c
@@ -163,7 +163,6 @@ static char *version =
 #include <linux/jiffies.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/dma.h>
 
 
diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index ee84b47..f4c2dd7 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -57,7 +57,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /*====================================================================*/
 
diff --git a/drivers/net/ethernet/i825xx/3c507.c b/drivers/net/ethernet/i825xx/3c507.c
index 1e94555..7e2a936 100644
--- a/drivers/net/ethernet/i825xx/3c507.c
+++ b/drivers/net/ethernet/i825xx/3c507.c
@@ -63,7 +63,6 @@ static const char version[] =
 
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /* use 0 for production, 1 for verification, 2..7 for debug */
diff --git a/drivers/net/ethernet/i825xx/3c527.c b/drivers/net/ethernet/i825xx/3c527.c
index 474b5e7..c5ba6a2 100644
--- a/drivers/net/ethernet/i825xx/3c527.c
+++ b/drivers/net/ethernet/i825xx/3c527.c
@@ -106,7 +106,6 @@ DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE " Richard Procter <rnp@paradise.net.
 #include <linux/semaphore.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/i825xx/eepro.c b/drivers/net/ethernet/i825xx/eepro.c
index 114cda77..dac995d 100644
--- a/drivers/net/ethernet/i825xx/eepro.c
+++ b/drivers/net/ethernet/i825xx/eepro.c
@@ -148,7 +148,6 @@ static const char version[] =
 #include <linux/bitops.h>
 #include <linux/ethtool.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/i825xx/eexpress.c b/drivers/net/ethernet/i825xx/eexpress.c
index 3a9580f..31054f2 100644
--- a/drivers/net/ethernet/i825xx/eexpress.c
+++ b/drivers/net/ethernet/i825xx/eexpress.c
@@ -116,7 +116,6 @@
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
index 42e90a9..b87eff6 100644
--- a/drivers/net/ethernet/i825xx/ether1.c
+++ b/drivers/net/ethernet/i825xx/ether1.c
@@ -48,7 +48,6 @@
 #include <linux/skbuff.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/ecard.h>
diff --git a/drivers/net/ethernet/i825xx/znet.c b/drivers/net/ethernet/i825xx/znet.c
index 962b4c4..f0ea476 100644
--- a/drivers/net/ethernet/i825xx/znet.c
+++ b/drivers/net/ethernet/i825xx/znet.c
@@ -100,7 +100,6 @@
 #include <linux/if_arp.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 6ad094f..e3198bc 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -55,7 +55,6 @@
 #include <linux/crc32.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 9edecfa..97b7709 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -57,7 +57,6 @@
 #include <linux/types.h>
 #include <linux/inet_lro.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 
 static char mv643xx_eth_driver_name[] = "mv643xx_eth";
 static char mv643xx_eth_driver_version[] = "1.4";
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 953ba58..44da3ec 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -43,7 +43,6 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 #include <linux/pxa168_eth.h>
 
diff --git a/drivers/net/ethernet/natsemi/jazzsonic.c b/drivers/net/ethernet/natsemi/jazzsonic.c
index 5b89fd3..95dd39f 100644
--- a/drivers/net/ethernet/natsemi/jazzsonic.c
+++ b/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -38,7 +38,6 @@
 #include <linux/slab.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/dma.h>
diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index f1b8556..b8d2c34 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -53,7 +53,6 @@
 #include <linux/slab.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/hwtest.h>
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index c24b46c..d52728b 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -121,7 +121,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #define DRV_NAME "ns83820"
 
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 97f63e1..da472d8 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -81,7 +81,6 @@
 #include <linux/prefetch.h>
 #include <net/tcp.h>
 
-#include <asm/system.h>
 #include <asm/div64.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 4c4e7f4..33d551e 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -69,7 +69,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #define TX_WORK_PER_LOOP  64
 #define RX_WORK_PER_LOOP  64
diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/realtek/atp.c
index e3f57fd..3049264 100644
--- a/drivers/net/ethernet/realtek/atp.c
+++ b/drivers/net/ethernet/realtek/atp.c
@@ -140,7 +140,6 @@ static int xcvr[NUM_UNITS]; 			/* The data transfer mode. */
 #include <linux/delay.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index bbacb37..eebd985 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -29,7 +29,6 @@
 #include <linux/pci-aspm.h>
 #include <linux/prefetch.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index 893c880..4d511c2 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -64,7 +64,6 @@
 #include <linux/delay.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/ecard.h>
 #include <asm/io.h>
 
diff --git a/drivers/net/ethernet/seeq/seeq8005.c b/drivers/net/ethernet/seeq/seeq8005.c
index 6056145..7474e8c 100644
--- a/drivers/net/ethernet/seeq/seeq8005.c
+++ b/drivers/net/ethernet/seeq/seeq8005.c
@@ -47,7 +47,6 @@ static const char version[] =
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet/smsc/smc91c92_cs.c
index ada927a..210e6ee 100644
--- a/drivers/net/ethernet/smsc/smc91c92_cs.c
+++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
@@ -53,7 +53,6 @@
 #include <pcmcia/ss.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /*====================================================================*/
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index f10665f..b414f2f 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -99,7 +99,6 @@
 #include <net/checksum.h>
 
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index 220f724..14e6af9 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -35,7 +35,6 @@
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #include "sunbmac.h"
 
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 31441a8..543c5f2 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -41,7 +41,6 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 09c5186..f0f395e 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -36,7 +36,6 @@
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/ethernet/sun/sunqe.c b/drivers/net/ethernet/sun/sunqe.c
index b28f743..b02584c 100644
--- a/drivers/net/ethernet/sun/sunqe.c
+++ b/drivers/net/ethernet/sun/sunqe.c
@@ -28,7 +28,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 164fb77..75cd722 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -50,7 +50,6 @@
 #include <linux/platform_device.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/tsi108.h>
 
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 33979c3..4f29ed2 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -89,7 +89,6 @@
 #include <pcmcia/ciscode.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #ifndef MANFID_COMPAQ
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 2a5a34d..64783a0 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/module.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 279d229..3d73bf9 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -86,7 +86,6 @@
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /* --------------------------------------------------------------------- */
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 18d8aff..76d5477 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -69,7 +69,6 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index bc02968..aed1a61 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -17,7 +17,6 @@
  * Copyright (C) 2004, 05 Thomas Osterried DL9SAU <thomas@x-berg.in-berlin.de>
  */
 #include <linux/module.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <asm/uaccess.h>
 #include <linux/crc16.h>
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 3365581..efc6c97 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -177,7 +177,6 @@
 #include <net/ax25.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 96a98d2..bdb9750 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -52,7 +52,6 @@
 #include <linux/bitops.h>
 #include <linux/random.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/firmware.h>
diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index e68c941..4e689d3 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <asm/cache.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
index 64f403d..1569bca 100644
--- a/drivers/net/irda/donauboe.c
+++ b/drivers/net/irda/donauboe.c
@@ -156,7 +156,6 @@
 #include <linux/pci.h>
 #include <linux/rtnetlink.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <net/irda/wrapper.h>
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index b71998d..32eb94e 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -41,7 +41,6 @@
 #include <linux/in.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index a9e9ca8..5c4209b 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -113,7 +113,6 @@ static const char version[] = "NET3 PLIP version 2.4-parport gniibe@mri.co.jp\n"
 
 #include <net/neighbour.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
 
diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
index 0a0a664..1252d9c 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -75,7 +75,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <linux/timer.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <net/checksum.h>
 #include <asm/unaligned.h>
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index ba08341..0b08f3c 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -64,7 +64,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/sched.h>
diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index ef9fdf3..fb99a0a 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -68,7 +68,6 @@
 #include <net/checksum.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "3c359.h"
 
diff --git a/drivers/net/tokenring/abyss.c b/drivers/net/tokenring/abyss.c
index 515f122..b715e6b 100644
--- a/drivers/net/tokenring/abyss.c
+++ b/drivers/net/tokenring/abyss.c
@@ -33,7 +33,6 @@
 #include <linux/netdevice.h>
 #include <linux/trdevice.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/tokenring/ibmtr_cs.c b/drivers/net/tokenring/ibmtr_cs.c
index 91b6846..356e28e 100644
--- a/drivers/net/tokenring/ibmtr_cs.c
+++ b/drivers/net/tokenring/ibmtr_cs.c
@@ -63,7 +63,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #define PCMCIA
 #include "ibmtr.c"
diff --git a/drivers/net/tokenring/lanstreamer.c b/drivers/net/tokenring/lanstreamer.c
index 8d71e0d..3e4b4f0 100644
--- a/drivers/net/tokenring/lanstreamer.c
+++ b/drivers/net/tokenring/lanstreamer.c
@@ -127,7 +127,6 @@
 #include <net/checksum.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "lanstreamer.h"
 
diff --git a/drivers/net/tokenring/madgemc.c b/drivers/net/tokenring/madgemc.c
index 6153cfd..ff78d5c 100644
--- a/drivers/net/tokenring/madgemc.c
+++ b/drivers/net/tokenring/madgemc.c
@@ -28,7 +28,6 @@ static const char version[] = "madgemc.c: v0.91 23/01/2000 by Adam Fritzler\n";
 #include <linux/netdevice.h>
 #include <linux/trdevice.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/tokenring/olympic.c b/drivers/net/tokenring/olympic.c
index fd8dce9..0e23474 100644
--- a/drivers/net/tokenring/olympic.c
+++ b/drivers/net/tokenring/olympic.c
@@ -106,7 +106,6 @@
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "olympic.h"
 
diff --git a/drivers/net/tokenring/proteon.c b/drivers/net/tokenring/proteon.c
index 8d362e6..62d90e4 100644
--- a/drivers/net/tokenring/proteon.c
+++ b/drivers/net/tokenring/proteon.c
@@ -31,7 +31,6 @@ static const char version[] = "proteon.c: v1.00 02/01/2003 by Jochen Friedrich\n
 #include <linux/trdevice.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pci.h>
diff --git a/drivers/net/tokenring/skisa.c b/drivers/net/tokenring/skisa.c
index 46db5c5..ee11e93 100644
--- a/drivers/net/tokenring/skisa.c
+++ b/drivers/net/tokenring/skisa.c
@@ -38,7 +38,6 @@ static const char version[] = "skisa.c: v1.03 09/12/2002 by Jochen Friedrich\n";
 #include <linux/trdevice.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pci.h>
diff --git a/drivers/net/tokenring/smctr.c b/drivers/net/tokenring/smctr.c
index 029846a..cb35fb7 100644
--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -49,7 +49,6 @@
 #include <linux/bitops.h>
 #include <linux/firmware.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
diff --git a/drivers/net/tokenring/tms380tr.c b/drivers/net/tokenring/tms380tr.c
index 65e9cf3..0c4303a 100644
--- a/drivers/net/tokenring/tms380tr.c
+++ b/drivers/net/tokenring/tms380tr.c
@@ -98,7 +98,6 @@ static const char version[] = "tms380tr.c: v1.10 30/12/2002 by Christoph Goos, A
 #include <linux/firmware.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
diff --git a/drivers/net/tokenring/tmspci.c b/drivers/net/tokenring/tmspci.c
index d3e788a..fb9918d 100644
--- a/drivers/net/tokenring/tmspci.c
+++ b/drivers/net/tokenring/tmspci.c
@@ -34,7 +34,6 @@
 #include <linux/netdevice.h>
 #include <linux/trdevice.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2d7601d..71d8771 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -69,7 +69,6 @@
 #include <net/rtnetlink.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /* Uncomment to enable debugging */
diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 48ab38a..147614e 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -50,7 +50,6 @@
 
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index 058e169..c31e7c0 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -93,7 +93,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/cache.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index 33b67d8..cf49033 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -40,7 +40,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include "hd64570.h"
 
diff --git a/drivers/net/wan/hd64572.c b/drivers/net/wan/hd64572.c
index efc0db1..e2779fa 100644
--- a/drivers/net/wan/hd64572.c
+++ b/drivers/net/wan/hd64572.c
@@ -40,7 +40,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include "hd64572.h"
 
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 7beeb9b..a73b49e 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -35,7 +35,6 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index c853161..de3bbf4 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -54,7 +54,6 @@
 #include <linux/sdla.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 8a10bb7..04581dc 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -18,7 +18,6 @@
 
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 1c008c6..5d3123c 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -37,7 +37,6 @@
 #include <linux/scatterlist.h>
 #include <linux/crypto.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index c983c10..630577d 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -37,7 +37,6 @@
 #include <pcmcia/ds.h>
 
 #include <linux/io.h>
-#include <asm/system.h>
 
 #include "airo.h"
 
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 7e45ca2..370f7ae 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -50,7 +50,6 @@
 #include <linux/timer.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/atmel_cs.c b/drivers/net/wireless/atmel_cs.c
index ec295c4..ded03d2 100644
--- a/drivers/net/wireless/atmel_cs.c
+++ b/drivers/net/wireless/atmel_cs.c
@@ -48,7 +48,6 @@
 #include <pcmcia/ciscode.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/wireless.h>
 
 #include "atmel.h"
diff --git a/drivers/net/wireless/prism54/islpci_mgt.c b/drivers/net/wireless/prism54/islpci_mgt.c
index a5224f6..8be83e1 100644
--- a/drivers/net/wireless/prism54/islpci_mgt.c
+++ b/drivers/net/wireless/prism54/islpci_mgt.c
@@ -24,7 +24,6 @@
 #include <linux/slab.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/if_arp.h>
 
 #include "prismcompat.h"
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 04fec1f..86a738b 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -53,7 +53,6 @@
 #include <net/iw_handler.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 98fbf54..00f6e69 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -53,7 +53,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include "wl3501.h"
 
diff --git a/drivers/nubus/nubus.c b/drivers/nubus/nubus.c
index b764ac22d..44d01af 100644
--- a/drivers/nubus/nubus.c
+++ b/drivers/nubus/nubus.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/hwtest.h>
 #include <linux/proc_fs.h>
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 7ff10c1..9c5aae5 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -55,7 +55,6 @@
 
 #include <asm/pdc.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/hardware.h>
 
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 95930d0..1f9e9fe 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -140,7 +140,6 @@
 #include <asm/pdc.h>
 #include <asm/pdcpat.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/io.h>		/* read/write functions */
 #ifdef CONFIG_SUPERIO
 #include <asm/superio.h>
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index d5f3d75..320e43a 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -43,7 +43,6 @@
 #include <asm/pdc.h>
 #include <asm/pdcpat.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
 #include <asm/ropes.h>
 #include <asm/hardware.h>	/* for register_parisc_driver() stuff */
diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index d9ea192..673c14e 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -29,7 +29,6 @@
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 
 #include <pcmcia/ss.h>
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index 3e447d0..0b66bfc 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -17,7 +17,6 @@
 
 #include <pcmcia/ss.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "i82092aa.h"
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 72a033a..e6f3d17 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -48,7 +48,6 @@
 #include <linux/bitops.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/ss.h>
 
diff --git a/drivers/pcmcia/m32r_cfc.c b/drivers/pcmcia/m32r_cfc.c
index 2adb010..a26f38c 100644
--- a/drivers/pcmcia/m32r_cfc.c
+++ b/drivers/pcmcia/m32r_cfc.c
@@ -24,7 +24,6 @@
 #include <linux/bitops.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/ss.h>
 
diff --git a/drivers/pcmcia/m32r_pcc.c b/drivers/pcmcia/m32r_pcc.c
index 1511ff7..2965141 100644
--- a/drivers/pcmcia/m32r_pcc.c
+++ b/drivers/pcmcia/m32r_pcc.c
@@ -24,7 +24,6 @@
 #include <linux/bitops.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/addrspace.h>
 
 #include <pcmcia/ss.h>
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 271a590..a317def 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -52,7 +52,6 @@
 #include <linux/of_platform.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/mpc8xx.h>
 #include <asm/8xx_immap.h>
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index 96c72e9..0f8b70b 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -19,7 +19,6 @@
 
 #include <pcmcia/ss.h>
 
-#include <asm/system.h>
 
 #include "pd6729.h"
 #include "i82365.h"
diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
index 64d433e..85ac095 100644
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -29,7 +29,6 @@
 #include <mach/smemc.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <mach/pxa2xx-regs.h>
 #include <asm/mach-types.h>
 
diff --git a/drivers/pcmcia/sa11xx_base.c b/drivers/pcmcia/sa11xx_base.c
index 0c62fe3..79ecc23 100644
--- a/drivers/pcmcia/sa11xx_base.c
+++ b/drivers/pcmcia/sa11xx_base.c
@@ -41,7 +41,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "soc_common.h"
 #include "sa11xx_base.h"
diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index a0a9c2a..5d22c6a 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -45,7 +45,6 @@
 #include <linux/timer.h>
 
 #include <mach/hardware.h>
-#include <asm/system.h>
 
 #include "soc_common.h"
 
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index 71aeed9..d688151 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -23,7 +23,6 @@
 #include <linux/pm.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 
 #include <pcmcia/ss.h>
diff --git a/drivers/pcmcia/tcic.c b/drivers/pcmcia/tcic.c
index 310160b..cbe15fc 100644
--- a/drivers/pcmcia/tcic.c
+++ b/drivers/pcmcia/tcic.c
@@ -47,7 +47,6 @@
 #include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/ss.h>
 #include "tcic.h"
diff --git a/drivers/pcmcia/xxs1500_ss.c b/drivers/pcmcia/xxs1500_ss.c
index 379f421..8f66980 100644
--- a/drivers/pcmcia/xxs1500_ss.c
+++ b/drivers/pcmcia/xxs1500_ss.c
@@ -21,7 +21,6 @@
 #include <pcmcia/cistpl.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/mach-au1x00/au1000.h>
 
 #define MEM_MAP_SIZE	0x400000
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index b859d16..769d265 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -17,7 +17,6 @@
 
 #include <asm/page.h>
 #include <asm/desc.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include "pnpbios.h"
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index cfe8685..9d42226 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -65,7 +65,6 @@
 
 #include <asm/page.h>
 #include <asm/desc.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include "../base.h"
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 1f56b3b..be0caae 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -42,7 +42,6 @@
 #include <asm/reset.h>
 #include <asm/airq.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/isc.h>
 #include <linux/hrtimer.h>
 #include <linux/ktime.h>
diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index 826157f..327657e 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -16,7 +16,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index 8d6e508..2236aea 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -40,7 +40,6 @@
 #include <linux/fs.h>
 #include <asm/oplib.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/openpromio.h>
 #ifdef CONFIG_PCI
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 0b31658..a9e468c 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -19,7 +19,6 @@
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f672491..a3adfb4 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -129,7 +129,6 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/byteorder.h>
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index f66c33b..d4da370 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -47,7 +47,6 @@
 
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index bfd618a..374c4ed 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -41,7 +41,6 @@
 #include <linux/firmware.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f17c92c..19a3694 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -239,7 +239,6 @@
 #include <asm/irq.h>
 #include <linux/io.h>
 #include <linux/blkdev.h>
-#include <asm/system.h>
 #include <linux/completion.h>
 #include <linux/errno.h>
 #include <linux/string.h>
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ed119ce..ede91f3 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -42,7 +42,6 @@
 #include <linux/slab.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 1c10b79..a3e6ed3 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -53,7 +53,6 @@
 #include <linux/gfp.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f980600..013e17d 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -61,7 +61,6 @@
 #include <linux/aer.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index c454e44..b330438 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -138,7 +138,6 @@
 #include <linux/stringify.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/ecard.h>
 
 #include "../scsi.h"
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index a3398fe..c3b99c9 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -12,7 +12,6 @@
 
 #include <asm/ecard.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 849cdf8..d25f944 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -13,7 +13,6 @@
 
 #include <asm/ecard.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7e6eca4..f29d512 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -30,7 +30,6 @@
 #include <linux/blkdev.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index c2677ba..4b11bb0 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -72,7 +72,6 @@
 #endif
 
 
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/signal.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index a2c6135..53bfcaa 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -93,7 +93,6 @@
 #include <linux/mca-legacy.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 643f6d5..1a2a1e5 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -282,7 +282,6 @@
 #include <linux/slab.h>
 #include <scsi/scsicam.h>
 
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 81182ba..1a5954f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -100,7 +100,6 @@
 #undef NCR5380_STAT_LIMIT
 #endif
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/signal.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3242bca..609efa3 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -129,7 +129,6 @@
 #include <linux/reboot.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 67fc8ff..cd09132 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -32,7 +32,6 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 112f1be..deb5b6d 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -123,7 +123,6 @@
 #include <linux/stat.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index e617337..e5cd8d8 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -22,7 +22,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/pci-bridge.h>
 #include <asm/macio.h>
 
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 2bccfbe..24828b5 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -43,7 +43,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <asm/macintosh.h>
 #include <asm/macints.h>
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 4944747..e8a04ae 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -33,7 +33,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/hydra.h>
 #include <asm/processor.h>
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 4b3b475..5982a58 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -115,7 +115,6 @@
 
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 0029249..62b6168 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -38,7 +38,6 @@
 #include <linux/dma-mapping.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index de0b1a7..21883a2 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -54,7 +54,6 @@ static const char * osst_version = "0.99.4";
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 
 /* The driver prints some debugging information on the console if DEBUG
    is defined and non-zero. */
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index f2018b4..2f72c98 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -113,7 +113,6 @@
  
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <linux/signal.h>
 #include <linux/proc_fs.h>
 #include <asm/io.h>
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index d838205..6c6486f 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -359,7 +359,6 @@
 #include <asm/byteorder.h>
 #include <asm/processor.h>
 #include <asm/types.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index e40dc1c..b191dd5 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -35,7 +35,6 @@
 #include "qlogicpti.h"
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/pgtable.h>
 #include <asm/oplib.h>
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9b28f39..81d05d2 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -42,7 +42,6 @@ static const char *verstr = "20101219";
 
 #include <asm/uaccess.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index baf7328..6e25889 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -63,7 +63,6 @@
 #include <linux/blkdev.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <asm/sun3ints.h>
 #include <asm/dvma.h>
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index fbba78e..a3dd55d 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -25,7 +25,6 @@
 #include <linux/blkdev.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <asm/sun3ints.h>
 #include <asm/dvma.h>
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 012c86e..ac4eca6 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -37,7 +37,6 @@
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/blkdev.h>
 #include <linux/isapnp.h>
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 041eaaa..d672d97 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -106,7 +106,6 @@
  * $Log: t128.c,v $
  */
 
-#include <asm/system.h>
 #include <linux/signal.h>
 #include <linux/io.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 90e104d..9c216e5 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -410,7 +410,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 7e22b73..14e0c40 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -141,7 +141,6 @@
 #include <linux/delay.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 
 #define ULTRASTOR_PRIVATE	/* Get the private stuff from ultrastor.h */
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 9ee0afe..d89a5df 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -179,7 +179,6 @@
 #include <linux/stat.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/dma.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index 610f739..9b0d716 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -47,7 +47,6 @@
 #include <linux/spi/spi_bitbang.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <asm/io.h>
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index db1fd63..bf185e2 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -42,7 +42,6 @@
 #include <linux/cdev.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
-#include <asm/system.h>
 
 #include "comedidev.h"
 #include "internal.h"
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index c9e8c47..915157d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -86,7 +86,6 @@ TODO:
 #include "../comedidev.h"
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <asm/system.h>
 
 #include "comedi_pci.h"
 #include "8253.h"
diff --git a/drivers/staging/comedi/drivers/mite.c b/drivers/staging/comedi/drivers/mite.c
index fd274e9..13e9c80 100644
--- a/drivers/staging/comedi/drivers/mite.c
+++ b/drivers/staging/comedi/drivers/mite.c
@@ -55,7 +55,6 @@
 #include "comedi_pci.h"
 #include "../comedidev.h"
 
-#include <asm/system.h>
 
 #define PCI_MITE_SIZE		4096
 #define PCI_DAQ_SIZE		4096
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index a2b5a56..784d14b 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -45,7 +45,6 @@
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 
 #include "crystalhd_cmds.h"
diff --git a/drivers/staging/crystalhd/crystalhd_misc.h b/drivers/staging/crystalhd/crystalhd_misc.h
index 4d61723..d3d117d 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -35,7 +35,6 @@
 #include <linux/ioctl.h>
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
-#include <asm/system.h>
 #include "bc_dts_glob_lnx.h"
 
 /* Global log level variable defined in crystal_misc.c file */
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2c4069f..185b2e2 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -70,7 +70,6 @@
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/io.h>
-#include <asm/system.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 917bbb0..1a2475b 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -29,7 +29,6 @@
 #include <linux/interrupt.h>
 #include <linux/in.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 
 #include <linux/netdevice.h>
diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 6c9279a..ece2dd1 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -30,7 +30,6 @@
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <linux/videodev2.h>
 #include <media/tuner.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/staging/media/go7007/go7007-i2c.c b/drivers/staging/media/go7007/go7007-i2c.c
index b8cfa1a..6bc82aa 100644
--- a/drivers/staging/media/go7007/go7007-i2c.c
+++ b/drivers/staging/media/go7007/go7007-i2c.c
@@ -26,7 +26,6 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #include "go7007-priv.h"
 #include "wis-i2c.h"
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 2b27d8d..c8c96e2 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -34,7 +34,6 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #include "go7007.h"
 #include "go7007-priv.h"
diff --git a/drivers/staging/media/go7007/snd-go7007.c b/drivers/staging/media/go7007/snd-go7007.c
index d071c83..5af29ff 100644
--- a/drivers/staging/media/go7007/snd-go7007.c
+++ b/drivers/staging/media/go7007/snd-go7007.c
@@ -29,7 +29,6 @@
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/initval.h>
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 8dd8897..18a798c 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -66,7 +66,6 @@
 #include <linux/poll.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/fcntl.h>
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index c94382b..945d962 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -49,7 +49,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/poll.h>
-#include <asm/system.h>
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <linux/fcntl.h>
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 4683d5f..6183573 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -58,7 +58,6 @@
 
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #define LCD_MINOR		156
 #define KEYPAD_MINOR		185
diff --git a/drivers/staging/sbe-2t3e3/io.c b/drivers/staging/sbe-2t3e3/io.c
index b458ff0..9a50bcc 100644
--- a/drivers/staging/sbe-2t3e3/io.c
+++ b/drivers/staging/sbe-2t3e3/io.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/ip.h>
-#include <asm/system.h>
 #include "2t3e3.h"
 #include "ctrl.h"
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index a2f31c6..ed00d3d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -17,7 +17,6 @@
 #ifndef _HOST_OS_H_
 #define _HOST_OS_H_
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <linux/semaphore.h>
 #include <linux/uaccess.h>
diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 2faee2d..6e169328 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -74,7 +74,6 @@
 #include <linux/in.h>
 #include <linux/delay.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 
 #include <linux/netdevice.h>
diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index dab603e..d5bf0a7 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -86,8 +86,7 @@
 // #include <linux/in.h>
 // #include <linux/delay.h>
 // #include <asm/io.h>
-// #include <asm/system.h>
-// #include <asm/bitops.h>
+// // #include <asm/bitops.h>
 #include <linux/unistd.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 9c16f54..90820ff 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -79,8 +79,7 @@
 // #include <linux/delay.h>
 // #include <linux/skbuff.h>
 // #include <asm/io.h>
-// #include <asm/system.h>
-// #include <asm/bitops.h>
+// // #include <asm/bitops.h>
 
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
diff --git a/drivers/staging/wlags49_h2/wl_pci.c b/drivers/staging/wlags49_h2/wl_pci.c
index 2bd9b84..3df990c 100644
--- a/drivers/staging/wlags49_h2/wl_pci.c
+++ b/drivers/staging/wlags49_h2/wl_pci.c
@@ -77,7 +77,6 @@
 #include <linux/interrupt.h>
 #include <linux/in.h>
 #include <linux/delay.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/bitops.h>
diff --git a/drivers/staging/wlags49_h2/wl_util.c b/drivers/staging/wlags49_h2/wl_util.c
index b748a3f..f104e6f 100644
--- a/drivers/staging/wlags49_h2/wl_util.c
+++ b/drivers/staging/wlags49_h2/wl_util.c
@@ -73,8 +73,7 @@
 // #include <linux/in.h>
 // #include <linux/delay.h>
 // #include <asm/io.h>
-// #include <asm/system.h>
-// #include <asm/bitops.h>
+// // #include <asm/bitops.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/telephony/phonedev.c b/drivers/telephony/phonedev.c
index 1915af2..1dd0b67 100644
--- a/drivers/telephony/phonedev.c
+++ b/drivers/telephony/phonedev.c
@@ -24,7 +24,6 @@
 #include <linux/phonedev.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/kmod.h>
 #include <linux/sem.h>
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index b84c834..35fc4b0 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -85,7 +85,6 @@ static char *serial_version = "4.30";
 
 #include <asm/setup.h>
 
-#include <asm/system.h>
 
 #include <asm/irq.h>
 
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index e5c295a..bffb73f 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -133,7 +133,6 @@
 
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <asm/system.h>
 
 #include <linux/pci.h>
 
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index d15a071..d0255e4 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 8998d52..d605f2f 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -41,7 +41,6 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index a09ce3e..1b2db9a 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -102,7 +102,6 @@
 #include <linux/if.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/termios.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d2256d0..94b6eda 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -50,7 +50,6 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 
 /* number of characters left in xmit buffer before select has we have room */
 #define WAKEUP_CHARS 256
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d8653ab..5c3a467 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -28,7 +28,6 @@
 #include <linux/devpts_fs.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 
 #ifdef CONFIG_UNIX98_PTYS
 static struct tty_driver *ptm_driver;
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index a88ef97..c78230f 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -39,7 +39,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/tty/serial/8250/serial_cs.c b/drivers/tty/serial/8250/serial_cs.c
index 8609060..29b695d 100644
--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -43,7 +43,6 @@
 #include <linux/delay.h>
 #include <linux/major.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ciscode.h>
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index fb13a17..a900954 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -34,7 +34,6 @@ static char *serial_version = "$Revision: 1.25 $";
 
 #include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 
 #include <arch/svinto.h>
 #include <arch/system.h>
diff --git a/drivers/tty/serial/dz.c b/drivers/tty/serial/dz.c
index e3699a8..6491b86 100644
--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -52,7 +52,6 @@
 #include <linux/atomic.h>
 #include <asm/bootinfo.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
 #include <asm/dec/kn01.h>
diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index d55709a..defc4e3 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -52,7 +52,6 @@
 #include <linux/firmware.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index 5e85e1e..fca13dc 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -50,7 +50,6 @@
 
 #include <linux/atomic.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <mach/hardware.h>
 #include <mach/dma.h>
diff --git a/drivers/tty/serial/zs.c b/drivers/tty/serial/zs.c
index b7455b5..4001eee 100644
--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -67,7 +67,6 @@
 #include <linux/types.h>
 
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
 #include <asm/dec/ioasic_addrs.h>
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index ff8017f..c3ec75e 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -86,7 +86,6 @@
 #include <linux/ioctl.h>
 #include <linux/synclink.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 18b48cd..e8d68a6 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -73,7 +73,6 @@
 #include <linux/hdlc.h>
 #include <linux/synclink.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index a7efe53..2e06260 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -58,7 +58,6 @@
 #include <linux/delay.h>
 #include <linux/ioctl.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e41b9bb..a80d572 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -97,7 +97,6 @@
 #include <linux/ratelimit.h>
 
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/vt_kern.h>
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 9314d93..a1b9a2f 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -23,7 +23,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #undef TTY_DEBUG_WAIT_UNTIL_SENT
 
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index e716839..ce43206 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -99,7 +99,6 @@
 #include <linux/notifier.h>
 #include <linux/device.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/kdb.h>
 #include <linux/ctype.h>
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index c16ff55..fe798e4 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -54,7 +54,6 @@
 #include <linux/prefetch.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 /* gadget stack */
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 143a725..a8c7ebf 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -35,7 +35,6 @@
 #include <mach/hardware.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/gpio.h>
 
 #include <mach/board.h>
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index db815c2..0af2615 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -43,7 +43,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index b04712f..dde4b2d 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -43,7 +43,6 @@
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 #include <asm/dma.h>
 
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 5af70fc..d3b5736 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -43,7 +43,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index e2293c1..83849c8 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -32,7 +32,6 @@
 #include <linux/pm.h>
 #include <linux/io.h>
 #include <linux/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include "langwell_udc.h"
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index f97e737..9578055 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -34,7 +34,6 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/platform_data/mv_usb.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include "mv_udc.h"
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index 7322d29..bb10c97 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -42,7 +42,6 @@
 #include <linux/usb/gadget.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include "net2272.h"
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index cdedd13..a4a9383 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -59,7 +59,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 576cd85..fc97c31 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -40,7 +40,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 #include <asm/mach-types.h>
 
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index d83134b..4e4dc1f 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -34,7 +34,6 @@
 #include <asm/byteorder.h>
 #include <linux/io.h>
 #include <linux/irq.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index dd47063..78458f3 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -41,7 +41,6 @@
 #include <asm/byteorder.h>
 #include <asm/dma.h>
 #include <asm/gpio.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index d3cdffe..73a934a 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -34,7 +34,6 @@
 
 #include <asm/io.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 3f87cb9..060566c 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -37,7 +37,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 #include <mach/irqs.h>
 
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index a007a9f..62e3836 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -45,7 +45,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #if defined(CONFIG_PPC_PS3)
diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index d91e5f2..5fd2955 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -70,7 +70,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include "isp116x.h"
diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index e5fd8aa..2385797 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -84,7 +84,6 @@
 #include <linux/prefetch.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 34b9edd..7407ae6 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -42,7 +42,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 #include <asm/byteorder.h>
 
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 015c7c6..3b38030 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -40,7 +40,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include <linux/irq.h>
diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 961d663..bf11cdb 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -51,7 +51,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 16dd6a6..dbbd1ba 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -55,7 +55,6 @@
 #include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 	/* FIXME ohci.h is ONLY for internal use by the OHCI driver.
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 6b5eb10..3199af1 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -45,7 +45,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "uhci-hcd.h"
 
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index f23cae0..887df9d 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -53,7 +53,6 @@
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
diff --git a/drivers/video/bt431.h b/drivers/video/bt431.h
index c826f27..04e0cfb 100644
--- a/drivers/video/bt431.h
+++ b/drivers/video/bt431.h
@@ -8,7 +8,6 @@
  *	archive for more details.
  */
 #include <linux/types.h>
-#include <asm/system.h>
 
 /*
  * Bt431 cursor generator registers, 32-bit aligned.
diff --git a/drivers/video/bt455.h b/drivers/video/bt455.h
index b7591fe..80f61b0 100644
--- a/drivers/video/bt455.h
+++ b/drivers/video/bt455.h
@@ -8,7 +8,6 @@
  *	archive for more details.
  */
 #include <linux/types.h>
-#include <asm/system.h>
 
 /*
  * Bt455 byte-wide registers, 32-bit aligned.
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 8745637..2e471c2 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -77,7 +77,6 @@
 #include <linux/crc32.h> /* For counting font checksums */
 #include <asm/fb.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "fbcon.h"
 
diff --git a/drivers/video/console/newport_con.c b/drivers/video/console/newport_con.c
index a122d92..6d15966 100644
--- a/drivers/video/console/newport_con.c
+++ b/drivers/video/console/newport_con.c
@@ -22,7 +22,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/gio_device.h>
diff --git a/drivers/video/cyber2000fb.c b/drivers/video/cyber2000fb.c
index 8503807..c1527f5 100644
--- a/drivers/video/cyber2000fb.c
+++ b/drivers/video/cyber2000fb.c
@@ -51,7 +51,6 @@
 #include <linux/i2c-algo-bit.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #ifdef __arm__
 #include <asm/mach-types.h>
diff --git a/drivers/video/dnfb.c b/drivers/video/dnfb.c
index ec56d25..49e3dda 100644
--- a/drivers/video/dnfb.c
+++ b/drivers/video/dnfb.c
@@ -7,7 +7,6 @@
 #include <linux/platform_device.h>
 
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
index fb3f673..afc9521 100644
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -71,7 +71,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
diff --git a/drivers/video/pmag-ba-fb.c b/drivers/video/pmag-ba-fb.c
index 0c69fa2..9b4a60b 100644
--- a/drivers/video/pmag-ba-fb.c
+++ b/drivers/video/pmag-ba-fb.c
@@ -33,7 +33,6 @@
 #include <linux/types.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <video/pmag-ba-fb.h>
 
diff --git a/drivers/video/pmagb-b-fb.c b/drivers/video/pmagb-b-fb.c
index 22fcb9a..4e7a9c4 100644
--- a/drivers/video/pmagb-b-fb.c
+++ b/drivers/video/pmagb-b-fb.c
@@ -29,7 +29,6 @@
 #include <linux/types.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <video/pmagb-b-fb.h>
 
diff --git a/drivers/video/q40fb.c b/drivers/video/q40fb.c
index f5a39f5..a104e8c 100644
--- a/drivers/video/q40fb.c
+++ b/drivers/video/q40fb.c
@@ -20,7 +20,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/q40_master.h>
 #include <linux/fb.h>
 #include <linux/module.h>
diff --git a/drivers/video/savage/savagefb_driver.c b/drivers/video/savage/savagefb_driver.c
index beb4950..cee7803 100644
--- a/drivers/video/savage/savagefb_driver.c
+++ b/drivers/video/savage/savagefb_driver.c
@@ -56,7 +56,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
diff --git a/drivers/virtio/config.c b/drivers/virtio/config.c
index 983d482..f70bcd2 100644
--- a/drivers/virtio/config.c
+++ b/drivers/virtio/config.c
@@ -9,5 +9,4 @@
 #include <linux/virtio.h>
 #include <linux/virtio_config.h>
 #include <linux/bug.h>
-#include <asm/system.h>
 
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 4d40965..6112bef 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -40,7 +40,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define DRV_NAME "advantechwdt"
 #define PFX DRV_NAME ": "
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 46f4b85..4868418 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -34,7 +34,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define OUR_NAME "alim7101_wdt"
 #define PFX OUR_NAME ": "
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 7c0fdfc..3a76e19 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -21,7 +21,6 @@
 #include <linux/uaccess.h>
 
 #include <asm/reg_booke.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/div64.h>
 
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 3946c51..f507fe7 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -59,7 +59,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 static unsigned long eurwdt_is_open;
 static int eurwdt_timeout;
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 0149d8d..9402c0b 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -44,7 +44,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 static struct platform_device *ibwdt_platform_device;
 static unsigned long ibwdt_is_open;
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index a2d9a12..d761c41 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -43,7 +43,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_VERSION	"1.14"
 #define WATCHDOG_NAME		"IT87 WDT"
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 1332b83..b536111 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -43,7 +43,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 /* ports */
 #define ZF_IOBASE	0x218
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index e78d899..669e562 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -33,7 +33,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 /* #define DEBUG 1 */
 
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index 626d0e8..4b53756 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -63,7 +63,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define OUR_NAME "sbc60xxwdt"
 #define PFX OUR_NAME ": "
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
index 93ac589..80f39a3 100644
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -30,7 +30,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 #define SBC7240_PREFIX "sbc7240_wdt: "
 
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index 514ec23..7c242bc 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -51,7 +51,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 static unsigned long sbc8360_is_open;
 static char expect_close;
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index d5d3994..07d59b3 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -25,7 +25,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int margin = 60;	/* (secs) Default is 1 minute */
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index b284040..c794803 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -67,7 +67,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define OUR_NAME "sc520_wdt"
 #define PFX OUR_NAME ": "
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 97b8184..16365d0 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -58,7 +58,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 /* enable support for minutes as units? */
 /* (does not always work correctly, so disabled by default!) */
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 576a388..1283d06 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -40,7 +40,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
 #define PFX WATCHDOG_NAME ": "
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index af08972..e5cb768 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -39,7 +39,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697hf/hg WDT"
 #define PFX WATCHDOG_NAME ": "
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index be9c4d8..24a46ff 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -44,7 +44,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697ug/uf WDT"
 #define PFX WATCHDOG_NAME ": "
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index 24587d2..5f3b945 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -56,7 +56,6 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #define OUR_NAME "w83877f_wdt"
 #define PFX OUR_NAME ": "
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 6e6743d..7f4330e 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -29,7 +29,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_VERSION  "1.00"
 #define WATCHDOG_NAME     "W83977F WDT"
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index d2ef002..f3026cd 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -46,7 +46,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include "wd501p.h"
 
 static unsigned long wdt_is_open;
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index a2f01c9..855bb0f 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -37,7 +37,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 #define WATCHDOG_VERSION  "0.04"
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index e0fc3baa..fae2567 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -53,7 +53,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define WDT_IS_PCI
 #include "wd501p.h"
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 1ff9405..c86ef9e 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -26,7 +26,6 @@
 #include <linux/coredump.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/a.out-core.h>
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 1bffbe0..517ef66 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -37,7 +37,6 @@
 #include <linux/syscalls.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 #include <asm/cacheflush.h>
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 5e2e1b3..2313183 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -21,7 +21,6 @@
 #include <linux/vfs.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include <linux/fs.h>
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 8f616e0..761d5b3 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -38,7 +38,6 @@
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/poll.h>
 #include <asm/uaccess.h>
 
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 9727e0c..0c68fd3 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -14,7 +14,6 @@
  * improvements to the Coda project. Contact Peter Braam <coda@cs.cmu.edu>.
  */
 
-#include <asm/system.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/types.h>
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ea54cde..80fb4b2 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -34,7 +34,6 @@
 #include <linux/mutex.h>
 #include <linux/anon_inodes.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/mman.h>
 #include <linux/atomic.h>
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 5069b84..9023572 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -28,7 +28,6 @@
 #include <linux/blkdev.h>
 #include <linux/bitops.h>
 #include <trace/events/jbd2.h>
-#include <asm/system.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c0a5f9f..f9709ef 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -50,7 +50,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
 EXPORT_SYMBOL(jbd2_journal_extend);
 EXPORT_SYMBOL(jbd2_journal_stop);
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 64a3264..3ff5fcc 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -7,7 +7,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/time.h>
 #include <linux/kernel.h>
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 3d1e34f..dd9a29f 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 
diff --git a/fs/ncpfs/mmap.c b/fs/ncpfs/mmap.c
index e5d71b2..be20a7e 100644
--- a/fs/ncpfs/mmap.c
+++ b/fs/ncpfs/mmap.c
@@ -19,7 +19,6 @@
 #include <linux/memcontrol.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include "ncp_fs.h"
 
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 31778f7..913aac9 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -40,7 +40,6 @@
 #include <linux/nfs_xdr.h>
 #include <linux/sunrpc/bc_xprt.h>
 
-#include <asm/system.h>
 
 #include "nfs4_fs.h"
 #include "callback.h"
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 1940f1a..ea5be12 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -51,7 +51,6 @@
 #include <linux/nfs_page.h>
 #include <linux/sunrpc/clnt.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/atomic.h>
 
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index c43a452..a77a1f2 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -30,7 +30,6 @@
 #include <linux/swap.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include "delegation.h"
 #include "internal.h"
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index dcb6154..56eeeef 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -32,7 +32,6 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "nfs4_fs.h"
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index f649fba..c2ce819 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -40,7 +40,6 @@
 #include <linux/compat.h>
 #include <linux/freezer.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "nfs4_fs.h"
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index cfa175c..b83e89b 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -20,7 +20,6 @@
 #include <linux/nfs_page.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include "pnfs.h"
 
 #include "nfs4_fs.h"
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 3dfa4f1..e3f6b23 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -53,7 +53,6 @@
 #include <linux/magic.h>
 #include <linux/parser.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "nfs4_fs.h"
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 84fd323..d533f59 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 #include <linux/mount.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index c3cf54f..6f1a194 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -51,7 +51,6 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 
 /* gets a struct reiserfs_journal_list * from a list head */
 #define JOURNAL_LIST_ENTRY(h) (list_entry((h), struct reiserfs_journal_list, \
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 9094e1d..7cdd395 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -26,7 +26,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/errno.h>
 #include <linux/fs.h>
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 5246ee3..a44c423 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -73,7 +73,6 @@
 #include <stdarg.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/errno.h>
 #include <linux/fs.h>
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index df7ffb0..5bf3be4 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -21,7 +21,6 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index f4b2eff..6fbc4ca 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -57,7 +57,6 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/div64.h>
 #include <asm/acpi.h>
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 8b8cf94..1ced641 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -54,7 +54,6 @@
 #define atomic_set(v, i) (((v)->counter) = (i))
 
 #include <linux/irqflags.h>
-#include <asm/system.h>
 
 /**
  * atomic_add_return - add integer to atomic variable
diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
index e3d8bf2..aa629bc 100644
--- a/include/linux/cnt32_to_63.h
+++ b/include/linux/cnt32_to_63.h
@@ -16,7 +16,6 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 /* this is used only to give gcc a clue about good code generation */
 union cnt32_to_63 {
diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 5033fb8..75cae8b 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -3,7 +3,6 @@
 
 #include <linux/kernel.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 struct task_struct;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 37c3007..b6d057e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -22,7 +22,6 @@
 #include <linux/pstore.h>
 
 #include <asm/page.h>
-#include <asm/system.h>
 
 #define EFI_SUCCESS		0
 #define EFI_LOAD_ERROR          ( 1 | (1UL << (BITS_PER_LONG-1)))
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 501370b..9e355d0 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -23,7 +23,6 @@
 #include <acpi/acpi.h>
 #endif
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 /* for request_sense */
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a64b00e..54ceeca 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -19,7 +19,6 @@
 
 #include <linux/atomic.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <trace/events/irq.h>
 
 /*
diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 88e78de..eab507f 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -21,7 +21,6 @@
 #include <linux/path.h>
 #include <linux/key.h>
 #include <linux/skbuff.h>
-#include <asm/system.h>
 
 
 /* Auxiliary data to use in generating the audit record. */
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index c409e1b..b84428e 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -29,7 +29,6 @@
 #include <linux/kernel.h>
 
 #include <asm/unaligned.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/barrier.h>
 
diff --git a/include/linux/parport.h b/include/linux/parport.h
index 38a423e..106c2ca 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -100,7 +100,6 @@ typedef enum {
 #include <linux/wait.h>
 #include <linux/irqreturn.h>
 #include <linux/semaphore.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 
 /* Define this later. */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 63d4065..54bd7cd 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -14,7 +14,6 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 
 struct rw_semaphore;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0657368..aca0aed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -63,7 +63,6 @@ struct sched_param {
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <asm/cputime.h>
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ae86ade..8fcc6f7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -490,7 +490,6 @@ struct sk_buff {
  */
 #include <linux/slab.h>
 
-#include <asm/system.h>
 
 /*
  * skb might have a dst pointer attached, refcounted or not.
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index fa0f93e..8a98ddf 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -57,7 +57,6 @@
 #include <linux/bottom_half.h>
 #include <asm/barrier.h>
 
-#include <asm/system.h>
 
 /*
  * Must define these before including other files, inline functions need them
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index c170edc..3b5e910 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -5,7 +5,6 @@
 #include <linux/cpumask.h>
 #include <linux/smp.h>
 #include <linux/list.h>
-#include <asm/system.h>
 
 /*
  * stop_cpu[s]() is simplistic per-cpu maximum priority cpu
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5dbb3cb..debdaca 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -44,7 +44,6 @@
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
 
-#include <asm/system.h>
 
 
 /*
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a9ce45e..e5824e2 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -22,7 +22,6 @@
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <asm/current.h>
 
 typedef struct __wait_queue wait_queue_t;
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0d7c087..de50f7d 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -52,7 +52,6 @@
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 #include "debug_core.h"
 
diff --git a/kernel/debug/kdb/kdb_bt.c b/kernel/debug/kdb/kdb_bt.c
index 7179eac..07c9bbb 100644
--- a/kernel/debug/kdb/kdb_bt.c
+++ b/kernel/debug/kdb/kdb_bt.c
@@ -15,7 +15,6 @@
 #include <linux/sched.h>
 #include <linux/kdb.h>
 #include <linux/nmi.h>
-#include <asm/system.h>
 #include "kdb_private.h"
 
 
diff --git a/kernel/dma.c b/kernel/dma.c
index 68a2306..6c6262f 100644
--- a/kernel/dma.c
+++ b/kernel/dma.c
@@ -18,7 +18,6 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 
 
 
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 7b08867..5d69b0c 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -37,7 +37,6 @@
 #include <asm/page.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 
 /* Per cpu memory for storing cpu states in case of system crash. */
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index b152f74..6850f53 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -10,7 +10,6 @@
 #include <linux/export.h>
 #include <linux/rwsem.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0063bc4..e739679 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -144,7 +144,6 @@ static const int cap_last_cap = CAP_LAST_CAP;
 #include <linux/inotify.h>
 #endif
 #ifdef CONFIG_SPARC
-#include <asm/system.h>
 #endif
 
 #ifdef CONFIG_SPARC64
diff --git a/lib/llist.c b/lib/llist.c
index 700cff7..e429d27 100644
--- a/lib/llist.c
+++ b/lib/llist.c
@@ -27,7 +27,6 @@
 #include <linux/interrupt.h>
 #include <linux/llist.h>
 
-#include <asm/system.h>
 
 /**
  * llist_add_batch - add several linked entries in batch
diff --git a/lib/raid6/altivec.uc b/lib/raid6/altivec.uc
index 2654d5c..7c86119 100644
--- a/lib/raid6/altivec.uc
+++ b/lib/raid6/altivec.uc
@@ -28,7 +28,6 @@
 
 #include <altivec.h>
 #ifdef __KERNEL__
-# include <asm/system.h>
 # include <asm/cputable.h>
 #endif
 
diff --git a/net/802/fc.c b/net/802/fc.c
index bd345f3..b324e31 100644
--- a/net/802/fc.c
+++ b/net/802/fc.c
@@ -11,7 +11,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/net/802/fddi.c b/net/802/fddi.c
index 94b3ad0..5ab25cd 100644
--- a/net/802/fddi.c
+++ b/net/802/fddi.c
@@ -27,7 +27,6 @@
  */
 
 #include <linux/module.h>
-#include <asm/system.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/net/802/hippi.c b/net/802/hippi.c
index 91aca87..056794e 100644
--- a/net/802/hippi.c
+++ b/net/802/hippi.c
@@ -35,7 +35,6 @@
 #include <net/arp.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 /*
  * Create the HIPPI MAC header for an arbitrary protocol layer
diff --git a/net/802/tr.c b/net/802/tr.c
index 5e20cf8..b9a3a14 100644
--- a/net/802/tr.c
+++ b/net/802/tr.c
@@ -16,7 +16,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/atm/clip.c b/net/atm/clip.c
index 127fe70..e059df4 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -37,7 +37,6 @@
 #include <linux/param.h> /* for HZ */
 #include <linux/uaccess.h>
 #include <asm/byteorder.h> /* for htons etc. */
-#include <asm/system.h> /* save/restore_flags */
 #include <linux/atomic.h>
 
 #include "common.h"
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 3cd0a0d..0906c19 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -33,7 +33,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/mm.h>
diff --git a/net/ax25/ax25_addr.c b/net/ax25/ax25_addr.c
index 7e7964d..9162409 100644
--- a/net/ax25/ax25_addr.c
+++ b/net/ax25/ax25_addr.c
@@ -22,7 +22,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index c1cb982..d0de30e 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -24,7 +24,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_ds_in.c b/net/ax25/ax25_ds_in.c
index 8273b12..9bd31e8 100644
--- a/net/ax25/ax25_ds_in.c
+++ b/net/ax25/ax25_ds_in.c
@@ -23,7 +23,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_ds_subr.c b/net/ax25/ax25_ds_subr.c
index 85816e6..5ea7fd3 100644
--- a/net/ax25/ax25_ds_subr.c
+++ b/net/ax25/ax25_ds_subr.c
@@ -24,7 +24,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_ds_timer.c b/net/ax25/ax25_ds_timer.c
index c7d8143..993c439 100644
--- a/net/ax25/ax25_ds_timer.c
+++ b/net/ax25/ax25_ds_timer.c
@@ -25,7 +25,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_iface.c b/net/ax25/ax25_iface.c
index 60b545e..7d5f24b 100644
--- a/net/ax25/ax25_iface.c
+++ b/net/ax25/ax25_iface.c
@@ -24,7 +24,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index 9bb7765..96f4cab3 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -27,7 +27,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_ip.c b/net/ax25/ax25_ip.c
index cf0c47a..846ae4e 100644
--- a/net/ax25/ax25_ip.c
+++ b/net/ax25/ax25_ip.c
@@ -24,7 +24,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/mm.h>
diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index 37507d8..be8a25e 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -27,7 +27,6 @@
 #include <linux/netfilter.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 87fddab..a655880 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -32,7 +32,6 @@
 #include <linux/spinlock.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_std_in.c b/net/ax25/ax25_std_in.c
index a8eef88..3fbf8f7 100644
--- a/net/ax25/ax25_std_in.c
+++ b/net/ax25/ax25_std_in.c
@@ -30,7 +30,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_std_subr.c b/net/ax25/ax25_std_subr.c
index 277f81b..8b66a41 100644
--- a/net/ax25/ax25_std_subr.c
+++ b/net/ax25/ax25_std_subr.c
@@ -21,7 +21,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_std_timer.c b/net/ax25/ax25_std_timer.c
index 96e4b92..004467c 100644
--- a/net/ax25/ax25_std_timer.c
+++ b/net/ax25/ax25_std_timer.c
@@ -25,7 +25,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index c6715ee..1997538 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -26,7 +26,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
index db29ea7..c3cffa7 100644
--- a/net/ax25/ax25_timer.c
+++ b/net/ax25/ax25_timer.c
@@ -29,7 +29,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_uid.c b/net/ax25/ax25_uid.c
index 4c83137..e3c579b 100644
--- a/net/ax25/ax25_uid.c
+++ b/net/ax25/ax25_uid.c
@@ -26,7 +26,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index 17800b1..cfea109 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -42,7 +42,6 @@
 #include <linux/uaccess.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 
 #include "bnep.h"
 
diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
index 3f2dd5c..0ee6893 100644
--- a/net/bluetooth/cmtp/sock.c
+++ b/net/bluetooth/cmtp/sock.c
@@ -39,7 +39,6 @@
 
 #include <linux/isdn/capilli.h>
 
-#include <asm/system.h>
 
 #include "cmtp.h"
 
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 07bc69e..447313c 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -38,7 +38,6 @@
 #include <linux/notifier.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5aeb624..0bab988 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -46,7 +46,6 @@
 #include <linux/crypto.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 001307f..285ae8b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -38,7 +38,6 @@
 #include <linux/notifier.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 0dcc962..b4c1c41 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -42,7 +42,6 @@
 #include <linux/ioctl.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 32d338c..d3c207a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -49,7 +49,6 @@
 #include <linux/crc16.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 22169c3..a55a43e 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -45,7 +45,6 @@
 #include <linux/security.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 
 #include <net/bluetooth/bluetooth.h>
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 8bf26d1..f6ab129 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -44,7 +44,6 @@
 #include <linux/security.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 
 #include <net/bluetooth/bluetooth.h>
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 68bbf9f..c72caac 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -37,7 +37,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
diff --git a/net/core/dev.c b/net/core/dev.c
index 6ca32f6..961fd68 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -73,7 +73,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/capability.h>
 #include <linux/cpu.h>
diff --git a/net/core/filter.c b/net/core/filter.c
index 5dea452..cf4989a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -33,7 +33,6 @@
 #include <net/sock.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 #include <linux/filter.h>
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 43b03dd..d9d198a 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -14,7 +14,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f965dce..f1e0d78 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -38,7 +38,6 @@
 #include <linux/pci.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/inet.h>
 #include <linux/netdevice.h>
diff --git a/net/core/scm.c b/net/core/scm.c
index ff52ad0..611c5ef 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -28,7 +28,6 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include <net/protocol.h>
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index da0c97f..8dc3594 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -66,7 +66,6 @@
 #include <net/xfrm.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <trace/events/skb.h>
 
 #include "kmap_skb.h"
diff --git a/net/core/sock.c b/net/core/sock.c
index 02f8dfe..9b082a1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -115,7 +115,6 @@
 #include <linux/memcontrol.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/netdevice.h>
 #include <net/protocol.h>
diff --git a/net/core/utils.c b/net/core/utils.c
index 386e263f..dc3c3fa 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -30,7 +30,6 @@
 #include <net/net_ratelimit.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 int net_msg_warn __read_mostly = 1;
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 19acd00..4136987 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -119,7 +119,6 @@ Version 0.0.6    2.1.110   07-aug-98   Eduardo Marcelo Serrat
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/flow.h>
-#include <asm/system.h>
 #include <asm/ioctls.h>
 #include <linux/capability.h>
 #include <linux/mm.h>
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 74d321a..c00e307 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -42,7 +42,6 @@
 #include <linux/notifier.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <net/net_namespace.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
diff --git a/net/decnet/dn_nsp_in.c b/net/decnet/dn_nsp_in.c
index 73fa268..f6544b2 100644
--- a/net/decnet/dn_nsp_in.c
+++ b/net/decnet/dn_nsp_in.c
@@ -60,7 +60,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/termios.h>
diff --git a/net/decnet/dn_nsp_out.c b/net/decnet/dn_nsp_out.c
index bd78836..e446e85 100644
--- a/net/decnet/dn_nsp_out.c
+++ b/net/decnet/dn_nsp_out.c
@@ -52,7 +52,6 @@
 #include <linux/route.h>
 #include <linux/slab.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/termios.h>
diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 7e717cb..71b5edc 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -47,7 +47,6 @@
 #include <linux/mutex.h>
 
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 static const struct proto_ops econet_ops;
 static struct hlist_head econet_sklist;
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index a246836..e1bea79 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -59,7 +59,6 @@
 #include <net/ip.h>
 #include <net/dsa.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 __setup("ether=", netdev_boot_setup);
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index f7b5670..a9a280e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -89,7 +89,6 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/inet.h>
 #include <linux/igmp.h>
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 63e4989..8c24cd5 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -113,7 +113,6 @@
 #include <net/ax25.h>
 #include <net/netrom.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 
 #include <linux/netfilter_arp.h>
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index e41c40f..39e0c16 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -27,7 +27,6 @@
 
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/capability.h>
 #include <linux/module.h>
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 92fc5f6..c7d21dd 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -15,7 +15,6 @@
 
 #include <linux/module.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/capability.h>
 #include <linux/types.h>
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 80106d8..3e32e4e 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -14,7 +14,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 2b555a5..c97c306 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -51,7 +51,6 @@
 #define VERSION "0.409"
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index ab188ae..eb88120 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -89,7 +89,6 @@
 #include <linux/errno.h>
 #include <linux/timer.h>
 #include <linux/init.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <net/checksum.h>
 #include <net/xfrm.h>
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 450e5d2..5dfecfd 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -73,7 +73,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 073a9b0..d035652 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -113,7 +113,6 @@
  *		2 of the License, or (at your option) any later version.
  */
 
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index ff302bd..4910176 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -43,7 +43,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 7bc2db6..46c8952 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -26,7 +26,6 @@
  *
  */
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
 #include <linux/capability.h>
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index b072386..4c87219 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -20,7 +20,6 @@
  *
  */
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 0197747..b2ecc67 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -64,7 +64,6 @@
 
 #include <linux/module.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 5d075b5..c8ace40 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -77,7 +77,6 @@
  *		2 of the License, or (at your option) any later version.
  */
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
 #include <linux/bootmem.h>
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 273f48d..faf2a6a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -60,7 +60,6 @@
 #endif
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/mroute6.h>
 
 MODULE_AUTHOR("Cast of dozens");
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 01d46bf..e20807d 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -66,7 +66,6 @@
 #include <net/inet_common.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 /*
  *	The ICMP socket(s). This is the most convenient way to flow control
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 5aa3981..8110362 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -16,7 +16,6 @@
  *
  */
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
 #include <linux/sched.h>
diff --git a/net/irda/irlan/irlan_client.c b/net/irda/irlan/irlan_client.c
index ba1a3fc..42cf139 100644
--- a/net/irda/irlan/irlan_client.c
+++ b/net/irda/irlan/irlan_client.c
@@ -37,7 +37,6 @@
 #include <linux/bitops.h>
 #include <net/arp.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include <net/irda/irda.h>
diff --git a/net/irda/irlan/irlan_common.c b/net/irda/irlan/irlan_common.c
index 579617c..7ac4d1b 100644
--- a/net/irda/irlan/irlan_common.c
+++ b/net/irda/irlan/irlan_common.c
@@ -40,7 +40,6 @@
 #include <linux/moduleparam.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include <net/irda/irda.h>
diff --git a/net/irda/irlan/irlan_provider.c b/net/irda/irlan/irlan_provider.c
index 8b61cf0..32dcaac 100644
--- a/net/irda/irlan/irlan_provider.c
+++ b/net/irda/irlan/irlan_provider.c
@@ -36,7 +36,6 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include <net/irda/irda.h>
diff --git a/net/irda/timer.c b/net/irda/timer.c
index f418cb2..1d552b3 100644
--- a/net/irda/timer.c
+++ b/net/irda/timer.c
@@ -24,7 +24,6 @@
  *
  ********************************************************************/
 
-#include <asm/system.h>
 #include <linux/delay.h>
 
 #include <net/irda/timer.h>
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 8d0324b..ab3d35f 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/lapb/lapb_in.c b/net/lapb/lapb_in.c
index 2ec1af5..f4e3c1a 100644
--- a/net/lapb/lapb_in.c
+++ b/net/lapb/lapb_in.c
@@ -30,7 +30,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/lapb/lapb_out.c b/net/lapb/lapb_out.c
index c75a795..baab276 100644
--- a/net/lapb/lapb_out.c
+++ b/net/lapb/lapb_out.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/lapb/lapb_subr.c b/net/lapb/lapb_subr.c
index 43a2a7f..066225b 100644
--- a/net/lapb/lapb_subr.c
+++ b/net/lapb/lapb_subr.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/lapb/lapb_timer.c b/net/lapb/lapb_timer.c
index af6d14b..f8cd641 100644
--- a/net/lapb/lapb_timer.c
+++ b/net/lapb/lapb_timer.c
@@ -28,7 +28,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index fe6cb43..5285617 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -31,7 +31,6 @@
 #include <net/net_namespace.h>
 #include <net/protocol.h>
 #include <net/tcp.h>
-#include <asm/system.h>
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff --git a/net/netfilter/ipvs/ip_vs_proto.c b/net/netfilter/ipvs/ip_vs_proto.c
index 8531293..f843a88 100644
--- a/net/netfilter/ipvs/ip_vs_proto.c
+++ b/net/netfilter/ipvs/ip_vs_proto.c
@@ -25,7 +25,6 @@
 #include <net/protocol.h>
 #include <net/tcp.h>
 #include <net/udp.h>
-#include <asm/system.h>
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4d70785..e6ddde1 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -23,7 +23,6 @@
 #include <linux/net.h>
 #include <linux/skbuff.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <net/sock.h>
 #include <net/netlink.h>
 #include <linux/init.h>
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 7dab229..06592d8 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -31,7 +31,6 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/mm.h>
diff --git a/net/netrom/nr_dev.c b/net/netrom/nr_dev.c
index 64e6dde..1c51d7a 100644
--- a/net/netrom/nr_dev.c
+++ b/net/netrom/nr_dev.c
@@ -21,7 +21,6 @@
 #include <linux/if_ether.h>	/* For the statistics structure. */
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
diff --git a/net/netrom/nr_in.c b/net/netrom/nr_in.c
index 6d4ef6d..c3073a2 100644
--- a/net/netrom/nr_in.c
+++ b/net/netrom/nr_in.c
@@ -24,7 +24,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/netrom/nr_out.c b/net/netrom/nr_out.c
index 607fddb..0b4bcb2 100644
--- a/net/netrom/nr_out.c
+++ b/net/netrom/nr_out.c
@@ -23,7 +23,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 2cf3301..70ffff7 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -26,7 +26,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/mm.h>
diff --git a/net/netrom/nr_subr.c b/net/netrom/nr_subr.c
index 6a947ae..ca40e22 100644
--- a/net/netrom/nr_subr.c
+++ b/net/netrom/nr_subr.c
@@ -23,7 +23,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/netrom/nr_timer.c b/net/netrom/nr_timer.c
index 1cb98e8..ff2c1b1 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -24,7 +24,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 2c03050..e44e631 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -38,7 +38,6 @@
 #include <linux/udp.h>
 #include <linux/ethtool.h>
 #include <linux/wait.h>
-#include <asm/system.h>
 #include <asm/div64.h>
 #include <linux/highmem.h>
 #include <linux/netfilter_bridge.h>
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2dbb32b..b188cc9 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -73,7 +73,6 @@
 #include <net/sock.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
 #include <asm/page.h>
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index f9ea925..c4719ce 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -34,7 +34,6 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>
diff --git a/net/rose/rose_dev.c b/net/rose/rose_dev.c
index 178ff4f..1ab8689 100644
--- a/net/rose/rose_dev.c
+++ b/net/rose/rose_dev.c
@@ -21,7 +21,6 @@
 #include <linux/if_ether.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <linux/inet.h>
diff --git a/net/rose/rose_in.c b/net/rose/rose_in.c
index 7f7fcb4..79c4abc 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -26,7 +26,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 7a02bd1..bc55142 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -22,7 +22,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/rose/rose_out.c b/net/rose/rose_out.c
index 4ebf33af..9ad98b5 100644
--- a/net/rose/rose_out.c
+++ b/net/rose/rose_out.c
@@ -21,7 +21,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index cd9b7ee..4014893 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -25,7 +25,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
diff --git a/net/rose/rose_subr.c b/net/rose/rose_subr.c
index f6c71ca..47f1fdb 100644
--- a/net/rose/rose_subr.c
+++ b/net/rose/rose_subr.c
@@ -22,7 +22,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index b6c8f38..bc5469d 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -23,7 +23,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f0268ea..d3daab6 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -17,7 +17,6 @@
  *  Copyright (C) 1995,1996 Olaf Kirch <okir@monad.swb.de>
  */
 
-#include <asm/system.h>
 
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index 47fda96..005a91b 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -15,7 +15,6 @@
 #include <linux/audit.h>
 #include <linux/lsm_audit.h>
 #include <linux/in6.h>
-#include <asm/system.h>
 #include "flask.h"
 #include "av_permissions.h"
 #include "security.h"
diff --git a/sound/oss/os.h b/sound/oss/os.h
index a1a962d..75ad0cd 100644
--- a/sound/oss/os.h
+++ b/sound/oss/os.h
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 #include <linux/poll.h>
diff --git a/sound/oss/vidc.c b/sound/oss/vidc.c
index 12ba28e..92ca5be 100644
--- a/sound/oss/vidc.c
+++ b/sound/oss/vidc.c
@@ -28,7 +28,6 @@
 #include <asm/io.h>
 #include <asm/hardware/iomd.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "sound_config.h"
 #include "vidc.h"
diff --git a/sound/oss/waveartist.c b/sound/oss/waveartist.c
index 5246874..24c430f 100644
--- a/sound/oss/waveartist.c
+++ b/sound/oss/waveartist.c
@@ -42,7 +42,6 @@
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 
 #include "sound_config.h"
 #include "waveartist.h"
diff --git a/sound/pci/asihpi/hpios.h b/sound/pci/asihpi/hpios.h
index c5cef11..d3fbd0d 100644
--- a/sound/pci/asihpi/hpios.h
+++ b/sound/pci/asihpi/hpios.h
@@ -30,7 +30,6 @@ HPI Operating System Specific macros for Linux Kernel driver
 #define HPI_BUILD_KERNEL_MODE
 
 #include <linux/io.h>
-#include <asm/system.h>
 #include <linux/ioctl.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/sound/pci/aw2/aw2-saa7146.c b/sound/pci/aw2/aw2-saa7146.c
index 8afd8b5..4439636 100644
--- a/sound/pci/aw2/aw2-saa7146.c
+++ b/sound/pci/aw2/aw2-saa7146.c
@@ -27,7 +27,6 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <sound/core.h>
 #include <sound/initval.h>

