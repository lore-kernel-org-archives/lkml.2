Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab2BJS6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:58:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63687 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862Ab2BJS6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:58:02 -0500
Message-ID: <1328900405.22240.96.camel@sauron.fi.intel.com>
Subject: Re: [Cocci] Re: [PATCH] scripts/coccinelle/misc/boolinit.cocci:
 semantic patch for bool issues
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        Gilles Muller <Gilles.Muller@lip6.fr>, bruce.w.allan@intel.com,
        rusty@rustcorp.com.au, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Julia Lawall <julia@diku.dk>
Date: Fri, 10 Feb 2012 21:00:05 +0200
In-Reply-To: <1328895943.14197.1.camel@joe2Laptop>
References: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1328895943.14197.1.camel@joe2Laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Amhou7dANKJl/piYECUK"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Amhou7dANKJl/piYECUK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-10 at 09:45 -0800, Joe Perches wrote:
> On Fri, 2012-02-10 at 18:11 +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Thanks Julia.  It seems to work well.
>=20
> Someone could run this with:
>=20
> $ make coccicheck COCCI=3Dscripts/coccinelle/misc/boolinit.cocci

Just FYI, here is what I got (I do not plan to submit this upstream):

 arch/arm/mach-cns3xxx/pcie.c                       |    2 +-
 arch/arm/mach-omap2/cm2xxx_3xxx.c                  |    2 +-
 arch/arm/plat-spear/padmux.c                       |    2 +-
 arch/powerpc/kvm/booke.c                           |    4 +-
 arch/um/kernel/process.c                           |    4 +-
 arch/x86/kernel/apm_32.c                           |    4 +-
 arch/x86/kernel/cpu/common.c                       |    2 +-
 arch/x86/kernel/cpu/topology.c                     |    2 +-
 arch/x86/kvm/mmu.c                                 |    2 +-
 arch/x86/kvm/vmx.c                                 |   42 ++++----
 arch/x86/kvm/x86.c                                 |    4 +-
 arch/x86/platform/geode/alix.c                     |    2 +-
 arch/x86/platform/iris/iris.c                      |    2 +-
 arch/x86/platform/olpc/olpc-xo1-sci.c              |    2 +-
 crypto/algif_hash.c                                |    8 +-
 crypto/algif_skcipher.c                            |   16 ++--
 drivers/acpi/apei/hest.c                           |    4 +-
 drivers/acpi/dock.c                                |    2 +-
 drivers/acpi/processor_core.c                      |    2 +-
 drivers/acpi/video.c                               |    4 +-
 drivers/acpi/video_detect.c                        |    2 +-
 drivers/ata/sata_nv.c                              |    2 +-
 drivers/atm/he.c                                   |    6 +-
 drivers/block/cciss.c                              |    2 +-
 drivers/block/paride/pd.c                          |    2 +-
 drivers/block/paride/pf.c                          |    2 +-
 drivers/block/paride/pg.c                          |    2 +-
 drivers/block/paride/pt.c                          |    2 +-
 drivers/block/xd.c                                 |    2 +-
 drivers/bluetooth/btusb.c                          |    2 +-
 drivers/bluetooth/hci_bcsp.c                       |    4 +-
 drivers/bluetooth/hci_ldisc.c                      |    2 +-
 drivers/cdrom/cdrom.c                              |   18 ++--
 drivers/char/agp/amd64-agp.c                       |    2 +-
 drivers/char/agp/sis-agp.c                         |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |    2 +-
 drivers/char/lp.c                                  |    2 +-
 drivers/char/pcmcia/synclink_cs.c                  |    2 +-
 drivers/char/tpm/tpm_tis.c                         |   10 +-
 drivers/char/xilinx_hwicap/buffer_icap.c           |    6 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |   12 +-
 drivers/crypto/caam/caamalg.c                      |    8 +-
 drivers/dma/dw_dmac.c                              |    2 +-
 drivers/dma/shdma.c                                |    2 +-
 drivers/dma/sirf-dma.c                             |    4 +-
 drivers/firewire/sbp2.c                            |    2 +-
 drivers/gpu/drm/drm_edid.c                         |    2 +-
 drivers/gpu/drm/drm_fb_helper.c                    |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |    2 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |    2 +-
 drivers/gpu/drm/gma500/power.c                     |    4 +-
 drivers/gpu/drm/gma500/psb_intel_sdvo.c            |    3 +-
 drivers/gpu/drm/i915/i915_drv.c                    |    4 +-
 drivers/gpu/drm/i915/intel_bios.c                  |    4 +-
 drivers/gpu/drm/i915/intel_crt.c                   |    8 +-
 drivers/gpu/drm/i915/intel_display.c               |    4 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |    6 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |    3 +-
 drivers/gpu/drm/i915/intel_tv.c                    |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |    4 +-
 drivers/gpu/drm/nouveau/nouveau_state.c            |    2 +-
 drivers/gpu/drm/radeon/r100.c                      |   12 +-
 drivers/gpu/drm/radeon/r300.c                      |    2 +-
 drivers/gpu/drm/radeon/r600.c                      |    2 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c       |    2 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |    8 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |    4 +-
 drivers/gpu/drm/radeon/radeon_display.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |    4 +-
 drivers/gpu/drm/radeon/radeon_object.c             |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |    2 +-
 drivers/gpu/drm/radeon/rs600.c                     |    2 +-
 drivers/gpu/vga/vga_switcheroo.c                   |   16 ++--
 drivers/hid/hid-lg4ff.c                            |    6 +-
 drivers/hid/hid-ntrig.c                            |   12 +-
 drivers/hwmon/abituguru3.c                         |    2 +-
 drivers/hwmon/ads7828.c                            |    4 +-
 drivers/hwmon/coretemp.c                           |    4 +-
 drivers/hwmon/lineage-pem.c                        |    2 +-
 drivers/hwmon/lm75.c                               |    4 +-
 drivers/hwmon/lm95245.c                            |   10 +-
 drivers/hwmon/ltc4151.c                            |    2 +-
 drivers/hwmon/ltc4215.c                            |    2 +-
 drivers/hwmon/ltc4245.c                            |    2 +-
 drivers/hwmon/ltc4261.c                            |    4 +-
 drivers/hwmon/max16065.c                           |    2 +-
 drivers/hwmon/max6642.c                            |    2 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |    2 +-
 drivers/hwmon/smm665.c                             |    2 +-
 drivers/hwmon/w83627hf.c                           |    2 +-
 drivers/hwmon/w83781d.c                            |    2 +-
 drivers/i2c/busses/i2c-tegra.c                     |    4 +-
 drivers/i2c/busses/i2c-viapro.c                    |    2 +-
 drivers/ide/ali14xx.c                              |    2 +-
 drivers/ide/cmd640.c                               |    2 +-
 drivers/ide/dtc2278.c                              |    2 +-
 drivers/ide/ht6560b.c                              |    2 +-
 drivers/ide/ide-4drives.c                          |    2 +-
 drivers/ide/ide-acpi.c                             |    4 +-
 drivers/ide/ide-pci-generic.c                      |    2 +-
 drivers/ide/qd65xx.c                               |    2 +-
 drivers/ide/umc8672.c                              |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |   18 ++--
 drivers/input/misc/wistron_btns.c                  |    2 +-
 drivers/input/mouse/appletouch.c                   |    6 +-
 drivers/input/mouse/elantech.c                     |    2 +-
 drivers/input/mouse/hgpk.c                         |    2 +-
 drivers/input/mouse/psmouse-base.c                 |    2 +-
 drivers/input/mouse/synaptics_i2c.c                |    2 +-
 drivers/input/tablet/wacom_wac.c                   |    2 +-
 drivers/input/touchscreen/auo-pixcir-ts.c          |    2 +-
 drivers/isdn/hardware/avm/b1dma.c                  |    2 +-
 drivers/isdn/sc/init.c                             |    2 +-
 drivers/macintosh/ams/ams-input.c                  |    4 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |    2 +-
 drivers/media/dvb/frontends/af9013.c               |   24 ++--
 drivers/media/dvb/frontends/drxk_hard.c            |   26 +++---
 drivers/media/radio/radio-gemtek.c                 |    8 +-
 drivers/media/radio/radio-sf16fmi.c                |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    4 +-
 drivers/media/rc/ene_ir.c                          |    2 +-
 drivers/media/rc/mceusb.c                          |    2 +-
 drivers/media/rc/streamzap.c                       |    2 +-
 drivers/media/video/cx18/cx18-driver.c             |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    2 +-
 drivers/media/video/marvell-ccic/mcam-core.c       |    2 +-
 drivers/media/video/omap/omap_vout.c               |    8 +-
 drivers/media/video/omap/omap_vout_vrfb.c          |   10 +-
 drivers/media/video/ov9740.c                       |    4 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |    4 +-
 drivers/media/video/stk-webcam.c                   |    4 +-
 drivers/media/video/tuner-core.c                   |    2 +-
 drivers/media/video/via-camera.c                   |    2 +-
 drivers/media/video/zoran/zoran_device.c           |    2 +-
 drivers/memstick/host/r592.c                       |    2 +-
 drivers/misc/apds990x.c                            |    4 +-
 drivers/misc/iwmc3200top/main.c                    |    8 +-
 drivers/mmc/core/core.c                            |    4 +-
 drivers/mmc/host/atmel-mci.c                       |   28 +++---
 drivers/mmc/host/davinci_mmc.c                     |    8 +-
 drivers/mmc/host/pxamci.c                          |    4 +-
 drivers/mmc/host/tifm_sd.c                         |    4 +-
 drivers/mmc/host/vub300.c                          |   42 ++++----
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c                     |    4 +-
 drivers/mtd/nand/r852.c                            |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c    |    6 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c         |    6 +-
 drivers/net/ethernet/intel/ixgb/ixgb_ee.c          |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c     |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c      |    2 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   18 ++--
 drivers/net/phy/broadcom.c                         |    4 +-
 drivers/net/wireless/ath/ath5k/ani.c               |    8 +-
 drivers/net/wireless/ath/ath9k/ani.c               |   12 +--
 drivers/net/wireless/ath/ath9k/hw-ops.h            |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    5 +-
 drivers/net/wireless/b43/dma.c                     |    4 +-
 drivers/net/wireless/b43/main.c                    |    6 +-
 drivers/net/wireless/b43/phy_n.c                   |    2 +-
 drivers/net/wireless/b43/pio.c                     |    2 +-
 drivers/net/wireless/b43legacy/dma.c               |    4 +-
 drivers/net/wireless/b43legacy/main.c              |    6 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   15 ++--
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    4 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   12 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c   |    4 +-
 drivers/net/wireless/iwmc3200wifi/commands.c       |    2 +-
 drivers/net/wireless/mwl8k.c                       |    4 +-
 drivers/net/wireless/rtlwifi/base.c                |    4 +-
 drivers/net/wireless/rtlwifi/core.c                |    2 +-
 drivers/net/wireless/rtlwifi/efuse.c               |    2 +-
 drivers/net/wireless/rtlwifi/ps.c                  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |   16 ++--
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |   16 ++--
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c        |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |   14 ++--
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |   12 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c        |    2 +-
 drivers/pci/hotplug/cpqphp_core.c                  |    2 +-
 drivers/pci/pci.c                                  |    4 +-
 drivers/pcmcia/yenta_socket.c                      |    2 +-
 drivers/platform/x86/asus-wmi.c                    |    2 +-
 drivers/platform/x86/eeepc-wmi.c                   |    4 +-
 drivers/platform/x86/intel_rar_register.c          |   10 +-
 drivers/platform/x86/msi-laptop.c                  |    4 +-
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/platform/x86/toshiba_acpi.c                |    2 +-
 drivers/power/da9030_battery.c                     |    4 +-
 drivers/regulator/core.c                           |    2 +-
 drivers/regulator/db8500-prcmu.c                   |    2 +-
 drivers/regulator/max8952.c                        |    6 +-
 drivers/regulator/max8997.c                        |    4 +-
 drivers/rtc/rtc-isl12022.c                         |    2 +-
 drivers/rtc/rtc-pm8xxx.c                           |    2 +-
 drivers/s390/char/raw3270.c                        |    2 +-
 drivers/s390/scsi/zfcp_scsi.c                      |    2 +-
 drivers/scsi/aha1542.c                             |    2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |    4 +-
 drivers/scsi/dc395x.c                              |    2 +-
 drivers/scsi/hpsa.c                                |    2 +-
 drivers/scsi/isci/host.c                           |    2 +-
 drivers/scsi/isci/isci.h                           |    6 +-
 drivers/scsi/isci/port.c                           |    4 +-
 drivers/scsi/isci/port_config.c                    |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |    6 +-
 drivers/scsi/nsp32.c                               |    8 +-
 drivers/scsi/pcmcia/nsp_cs.c                       |    2 +-
 drivers/scsi/vmw_pvscsi.c                          |   10 +-
 drivers/sh/maple/maple.c                           |    6 +-
 drivers/spi/spi-fsl-spi.c                          |   12 +-
 drivers/spi/spi-ti-ssp.c                           |    4 +-
 drivers/ssb/main.c                                 |    6 +-
 drivers/ssb/pcmcia.c                               |    6 +-
 drivers/staging/comedi/comedi_fops.c               |    4 +-
 drivers/staging/cptm1217/clearpad_tm1217.c         |    8 +-
 drivers/staging/crystalhd/crystalhd_hw.c           |    8 +-
 drivers/staging/et131x/et131x.c                    |    4 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   22 ++--
 drivers/staging/hv/storvsc_drv.c                   |    2 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    2 +-
 drivers/staging/iio/accel/sca3000_ring.c           |    4 +-
 drivers/staging/iio/dac/ad5686.c                   |    2 +-
 drivers/staging/iio/iio_dummy_evgen.c              |    2 +-
 drivers/staging/iio/magnetometer/ak8975.c          |    2 +-
 drivers/staging/media/easycap/easycap_ioctl.c      |    2 +-
 drivers/staging/media/lirc/lirc_igorplugusb.c      |    2 +-
 drivers/staging/media/lirc/lirc_serial.c           |   14 ++--
 drivers/staging/mei/interrupt.c                    |    2 +-
 drivers/staging/olpc_dcon/olpc_dcon.c              |    2 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |   12 +-
 drivers/staging/rtl8187se/r8180_core.c             |    6 +-
 drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c |    6 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c     |   10 +-
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.c    |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c     |    8 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   22 ++--
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c         |   16 ++--
 drivers/staging/rtl8192e/rtl819x_TSProc.c          |    4 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |    6 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |   18 ++--
 drivers/staging/rtl8192e/rtllib_tx.c               |    2 +-
 drivers/staging/rtl8192e/rtllib_wx.c               |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |   10 +-
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |    4 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    4 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |    6 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |    2 +-
 drivers/staging/rtl8192u/r819xU_phy.c              |    2 +-
 drivers/staging/sep/sep_driver.c                   |   14 ++--
 drivers/staging/tidspbridge/dynload/cload.c        |    4 +-
 drivers/staging/tidspbridge/dynload/reloc.c        |    6 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 +-
 drivers/staging/tidspbridge/rmgr/mgr.c             |    4 +-
 drivers/staging/vt6655/baseband.c                  |    4 +-
 drivers/staging/vt6655/bssdb.c                     |   40 ++++----
 drivers/staging/vt6655/card.c                      |    8 +-
 drivers/staging/vt6655/channel.c                   |   16 ++--
 drivers/staging/vt6655/datarate.c                  |    6 +-
 drivers/staging/vt6655/device_main.c               |   60 +++++-----
 drivers/staging/vt6655/dpc.c                       |   34 +++----
 drivers/staging/vt6655/hostap.c                    |   27 +----
 drivers/staging/vt6655/key.c                       |   42 ++++----
 drivers/staging/vt6655/mac.c                       |    4 +-
 drivers/staging/vt6655/power.c                     |    8 +-
 drivers/staging/vt6655/rf.c                        |    2 +-
 drivers/staging/vt6655/rxtx.c                      |   64 ++++++------
 drivers/staging/vt6655/vntwifi.c                   |    6 +-
 drivers/staging/vt6655/wcmd.c                      |   22 ++--
 drivers/staging/vt6655/wctl.c                      |    6 +-
 drivers/staging/vt6655/wmgr.c                      |  113 +++++++++-------=
----
 drivers/staging/vt6655/wpa.c                       |    2 +-
 drivers/staging/vt6655/wpa2.c                      |    4 +-
 drivers/staging/vt6655/wpactl.c                    |   30 +-----
 drivers/staging/zcache/zcache-main.c               |    6 +-
 drivers/target/iscsi/iscsi_target.c                |    4 +-
 drivers/target/target_core_transport.c             |    2 +-
 drivers/tty/synclink_gt.c                          |    2 +-
 drivers/tty/synclinkmp.c                           |    2 +-
 drivers/usb/class/usbtmc.c                         |    6 +-
 drivers/usb/core/hub.c                             |    6 +-
 drivers/usb/gadget/amd5536udc.c                    |    6 +-
 drivers/usb/gadget/ether.c                         |    2 +-
 drivers/usb/gadget/f_eem.c                         |    2 +-
 drivers/usb/gadget/f_hid.c                         |    6 +-
 drivers/usb/gadget/file_storage.c                  |    2 +-
 drivers/usb/gadget/mv_udc_core.c                   |    4 +-
 drivers/usb/gadget/net2272.c                       |    2 +-
 drivers/usb/gadget/net2280.c                       |    8 +-
 drivers/usb/gadget/omap_udc.c                      |    4 +-
 drivers/usb/gadget/zero.c                          |    2 +-
 drivers/usb/host/ehci-hcd.c                        |    2 +-
 drivers/usb/host/ohci-hcd.c                        |    4 +-
 drivers/usb/host/u132-hcd.c                        |    2 +-
 drivers/usb/host/whci/qset.c                       |    2 +-
 drivers/usb/host/xhci.c                            |    2 +-
 drivers/usb/misc/ftdi-elan.c                       |    2 +-
 drivers/usb/misc/iowarrior.c                       |    2 +-
 drivers/usb/musb/cppi_dma.c                        |    2 +-
 drivers/usb/musb/musb_core.c                       |    2 +-
 drivers/usb/serial/iuu_phoenix.c                   |    8 +-
 drivers/usb/serial/mos7840.c                       |    4 +-
 drivers/usb/serial/safe_serial.c                   |    4 +-
 drivers/usb/usb-skeleton.c                         |   10 +-
 drivers/video/aty/aty128fb.c                       |    2 +-
 drivers/video/aty/atyfb_base.c                     |    4 +-
 drivers/video/aty/radeon_base.c                    |   36 +++---
 drivers/video/cirrusfb.c                           |    2 +-
 drivers/video/hgafb.c                              |    2 +-
 drivers/video/i810/i810_main.c                     |   10 +-
 drivers/video/intelfb/intelfbdrv.c                 |   16 ++--
 drivers/video/neofb.c                              |   10 +-
 drivers/video/omap/omapfb_main.c                   |    4 +-
 drivers/video/omap2/displays/panel-taal.c          |    4 +-
 drivers/video/omap2/dss/dispc.c                    |    6 +-
 drivers/video/omap2/dss/dsi.c                      |    2 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |    6 +-
 drivers/video/omap2/vram.c                         |    2 +-
 drivers/video/pm2fb.c                              |    8 +-
 drivers/video/pm3fb.c                              |    4 +-
 drivers/video/riva/fbdev.c                         |   12 +-
 drivers/video/sstfb.c                              |   14 ++--
 drivers/video/tdfxfb.c                             |    2 +-
 drivers/video/udlfb.c                              |    6 +-
 drivers/video/uvesafb.c                            |   12 +-
 drivers/video/vfb.c                                |    8 +-
 drivers/watchdog/mpc8xxx_wdt.c                     |    2 +-
 fs/binfmt_elf.c                                    |    4 +-
 fs/btrfs/delayed-inode.c                           |   12 +-
 fs/cifs/cifssmb.c                                  |    4 +-
 fs/cifs/connect.c                                  |  106 +++++++++-------=
--
 fs/cifs/file.c                                     |    2 +-
 fs/cifs/sess.c                                     |    2 +-
 fs/exofs/super.c                                   |    2 +-
 fs/ioctl.c                                         |    2 +-
 fs/nfs/callback_proc.c                             |    2 +-
 fs/nfs/client.c                                    |    4 +-
 fs/nfs/nfs4proc.c                                  |    2 +-
 fs/nfs/objlayout/objio_osd.c                       |    2 +-
 fs/nfsd/nfs4proc.c                                 |    4 +-
 fs/nfsd/nfs4xdr.c                                  |    2 +-
 fs/nfsd/vfs.c                                      |    2 +-
 include/linux/ata.h                                |    6 +-
 kernel/irq/spurious.c                              |    2 +-
 kernel/printk.c                                    |   10 +-
 kernel/sched/core.c                                |    2 +-
 kernel/sysctl.c                                    |    6 +-
 kernel/trace/trace.c                               |    2 +-
 lib/vsprintf.c                                     |    4 +-
 net/unix/garbage.c                                 |    2 +-
 security/apparmor/lsm.c                            |    8 +-
 security/integrity/ima/ima_policy.c                |    2 +-
 security/selinux/ss/mls.c                          |    2 +-
 security/selinux/ss/services.c                     |    2 +-
 security/tomoyo/common.c                           |    2 +-
 sound/core/oss/pcm_oss.c                           |    2 +-
 sound/drivers/dummy.c                              |    4 +-
 sound/drivers/opl3/opl3_seq.c                      |    2 +-
 sound/drivers/pcsp/pcsp.c                          |    2 +-
 sound/isa/opti9xx/miro.c                           |    2 +-
 sound/oss/ad1848.c                                 |    2 +-
 sound/oss/pas2_card.c                              |    6 +-
 sound/oss/pss.c                                    |    6 +-
 sound/oss/trix.c                                   |    2 +-
 sound/pci/asihpi/asihpi.c                          |    2 +-
 sound/pci/atiixp.c                                 |    2 +-
 sound/pci/azt3328.c                                |   18 ++--
 sound/pci/hda/hda_intel.c                          |    4 +-
 sound/pci/hda/patch_via.c                          |    2 +-
 sound/pci/nm256/nm256.c                            |    4 +-
 sound/pci/oxygen/xonar_pcm179x.c                   |    2 +-
 sound/pci/sis7019.c                                |    2 +-
 sound/ppc/powermac.c                               |    2 +-
 sound/sh/aica.c                                    |    2 +-
 sound/soc/codecs/cs4271.c                          |    4 +-
 sound/soc/codecs/sgtl5000.c                        |    4 +-
 sound/soc/davinci/davinci-i2s.c                    |    2 +-
 sound/soc/fsl/fsl_dma.c                            |    4 +-
 sound/soc/omap/ams-delta.c                         |    6 +-
 sound/soc/omap/omap-dmic.c                         |    4 +-
 sound/soc/omap/omap-mcbsp.c                        |    2 +-
 sound/soc/soc-core.c                               |    4 +-
 sound/usb/card.c                                   |    2 +-
 tools/perf/builtin-record.c                        |    2 +-
 tools/perf/builtin-report.c                        |    2 +-
 tools/perf/util/probe-event.c                      |    2 +-
--

 410 files changed, 1201 insertions(+), 1267 deletions(-)
diff --git a/arch/arm/mach-cns3xxx/pcie.c b/arch/arm/mach-cns3xxx/pcie.c
index e159d69..925cacd 100644
--- a/arch/arm/mach-cns3xxx/pcie.c
+++ b/arch/arm/mach-cns3xxx/pcie.c
@@ -295,7 +295,7 @@ static void __init cns3xxx_pcie_check_link(struct cns3x=
xx_pcie *cnspci)
 		reg =3D __raw_readl(MISC_PCIE_PM_DEBUG(port));
 		if (reg & 0x1) {
 			pr_info("Link up.\n");
-			cnspci->linked =3D 1;
+			cnspci->linked =3D true;
 			break;
 		} else if (time_after(jiffies, time + 50)) {
 			pr_info("Device not found.\n");
diff --git a/arch/arm/mach-omap2/cm2xxx_3xxx.c b/arch/arm/mach-omap2/cm2xxx=
_3xxx.c
index 04d39cd..3f1fdec 100644
--- a/arch/arm/mach-omap2/cm2xxx_3xxx.c
+++ b/arch/arm/mach-omap2/cm2xxx_3xxx.c
@@ -87,7 +87,7 @@ static void _write_clktrctrl(u8 c, s16 module, u32 mask)
 bool omap2_cm_is_clkdm_in_hwsup(s16 module, u32 mask)
 {
 	u32 v;
-	bool ret =3D 0;
+	bool ret =3D false;
=20
 	BUG_ON(!cpu_is_omap24xx() && !cpu_is_omap34xx());
=20
diff --git a/arch/arm/plat-spear/padmux.c b/arch/arm/plat-spear/padmux.c
index 555eec6..c1cd947 100644
--- a/arch/arm/plat-spear/padmux.c
+++ b/arch/arm/plat-spear/padmux.c
@@ -94,7 +94,7 @@ static int pmx_devs_enable(struct pmx_dev **devs, u8 coun=
t)
 					break;
 				}
 			}
-			if (found =3D=3D false) {
+			if (!found) {
 				printk(KERN_ERR "%s device not available in %s"\
 						"mode\n", devs[i]->name,
 						pmx->active_mode->name);
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index bb6c988..495d1e1 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -275,9 +275,9 @@ static int kvmppc_booke_irqprio_deliver(struct kvm_vcpu=
 *vcpu,
 		vcpu->arch.shared->srr0 =3D vcpu->arch.pc;
 		vcpu->arch.shared->srr1 =3D vcpu->arch.shared->msr;
 		vcpu->arch.pc =3D vcpu->arch.ivpr | vcpu->arch.ivor[priority];
-		if (update_esr =3D=3D true)
+		if (update_esr)
 			vcpu->arch.esr =3D vcpu->arch.queued_esr;
-		if (update_dear =3D=3D true)
+		if (update_dear)
 			vcpu->arch.shared->dar =3D vcpu->arch.queued_dear;
 		kvmppc_set_msr(vcpu, vcpu->arch.shared->msr & msr_mask);
=20
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 69f2490..9eba7bf 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -427,7 +427,7 @@ unsigned long arch_align_stack(unsigned long sp)
 unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long stack_page, sp, ip;
-	bool seen_sched =3D 0;
+	bool seen_sched =3D false;
=20
 	if ((p =3D=3D NULL) || (p =3D=3D current) || (p->state =3D=3D TASK_RUNNIN=
G))
 		return 0;
@@ -449,7 +449,7 @@ unsigned long get_wchan(struct task_struct *p)
 		ip =3D *((unsigned long *) sp);
 		if (in_sched_functions(ip))
 			/* Ignore everything until we're above the scheduler */
-			seen_sched =3D 1;
+			seen_sched =3D true;
 		else if (kernel_text_address(ip) && seen_sched)
 			return ip;
=20
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index f76623c..e39b0d1 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -389,11 +389,11 @@ static int apm_disabled =3D -1;
 #ifdef CONFIG_SMP
 static bool power_off;
 #else
-static bool power_off =3D 1;
+static bool power_off =3D true;
 #endif
 static bool realmode_power_off;
 #ifdef CONFIG_APM_ALLOW_INTS
-static bool allow_ints =3D 1;
+static bool allow_ints =3D true;
 #else
 static bool allow_ints;
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d43cad7..d0927aa 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -496,7 +496,7 @@ out:
 		       c->phys_proc_id);
 		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
 		       c->cpu_core_id);
-		printed =3D 1;
+		printed =3D true;
 	}
 #endif
 }
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.=
c
index 4397e98..91bee70 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -92,7 +92,7 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x8=
6 *c)
 		if (c->x86_max_cores > 1)
 			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
 			       c->cpu_core_id);
-		printed =3D 1;
+		printed =3D true;
 	}
 	return;
 #endif
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 224b02c..e2009b6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -74,7 +74,7 @@ enum {
 #endif
=20
 #ifdef MMU_DEBUG
-static bool dbg =3D 0;
+static bool dbg =3D false;
 module_param(dbg, bool, 0644);
 #endif
=20
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d29216c..afb8b76 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -51,29 +51,29 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
=20
-static bool __read_mostly enable_vpid =3D 1;
+static bool __read_mostly enable_vpid =3D true;
 module_param_named(vpid, enable_vpid, bool, 0444);
=20
-static bool __read_mostly flexpriority_enabled =3D 1;
+static bool __read_mostly flexpriority_enabled =3D true;
 module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
=20
-static bool __read_mostly enable_ept =3D 1;
+static bool __read_mostly enable_ept =3D true;
 module_param_named(ept, enable_ept, bool, S_IRUGO);
=20
-static bool __read_mostly enable_unrestricted_guest =3D 1;
+static bool __read_mostly enable_unrestricted_guest =3D true;
 module_param_named(unrestricted_guest,
 			enable_unrestricted_guest, bool, S_IRUGO);
=20
-static bool __read_mostly emulate_invalid_guest_state =3D 0;
+static bool __read_mostly emulate_invalid_guest_state =3D false;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
=20
-static bool __read_mostly vmm_exclusive =3D 1;
+static bool __read_mostly vmm_exclusive =3D true;
 module_param(vmm_exclusive, bool, S_IRUGO);
=20
-static bool __read_mostly yield_on_hlt =3D 1;
+static bool __read_mostly yield_on_hlt =3D true;
 module_param(yield_on_hlt, bool, S_IRUGO);
=20
-static bool __read_mostly fasteoi =3D 1;
+static bool __read_mostly fasteoi =3D true;
 module_param(fasteoi, bool, S_IRUGO);
=20
 /*
@@ -81,7 +81,7 @@ module_param(fasteoi, bool, S_IRUGO);
  * VMX and be a hypervisor for its own guests. If nested=3D0, guests may n=
ot
  * use VMX instructions.
  */
-static bool __read_mostly nested =3D 0;
+static bool __read_mostly nested =3D false;
 module_param(nested, bool, S_IRUGO);
=20
 #define KVM_GUEST_CR0_MASK_UNRESTRICTED_GUEST				\
@@ -2617,19 +2617,19 @@ static __init int hardware_setup(void)
 		kvm_enable_efer_bits(EFER_NX);
=20
 	if (!cpu_has_vmx_vpid())
-		enable_vpid =3D 0;
+		enable_vpid =3D false;
=20
 	if (!cpu_has_vmx_ept() ||
 	    !cpu_has_vmx_ept_4levels()) {
-		enable_ept =3D 0;
-		enable_unrestricted_guest =3D 0;
+		enable_ept =3D false;
+		enable_unrestricted_guest =3D false;
 	}
=20
 	if (!cpu_has_vmx_unrestricted_guest())
-		enable_unrestricted_guest =3D 0;
+		enable_unrestricted_guest =3D false;
=20
 	if (!cpu_has_vmx_flexpriority())
-		flexpriority_enabled =3D 0;
+		flexpriority_enabled =3D false;
=20
 	if (!cpu_has_vmx_tpr_shadow())
 		kvm_x86_ops->update_cr8_intercept =3D NULL;
@@ -2672,7 +2672,7 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
=20
-	vmx->emulation_required =3D 1;
+	vmx->emulation_required =3D true;
 	vmx->rmode.vm86_active =3D 0;
=20
 	vmx_segment_cache_clear(vmx);
@@ -2752,7 +2752,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	if (enable_unrestricted_guest)
 		return;
=20
-	vmx->emulation_required =3D 1;
+	vmx->emulation_required =3D true;
 	vmx->rmode.vm86_active =3D 1;
=20
 	/*
@@ -3698,7 +3698,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx=
 *vmx)
 		exec_control &=3D ~SECONDARY_EXEC_ENABLE_VPID;
 	if (!enable_ept) {
 		exec_control &=3D ~SECONDARY_EXEC_ENABLE_EPT;
-		enable_unrestricted_guest =3D 0;
+		enable_unrestricted_guest =3D false;
 	}
 	if (!enable_unrestricted_guest)
 		exec_control &=3D ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
@@ -3926,7 +3926,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	ret =3D 0;
=20
 	/* HACK: Don't enable emulation on guest boot/reset */
-	vmx->emulation_required =3D 0;
+	vmx->emulation_required =3D false;
=20
 out:
 	return ret;
@@ -4899,7 +4899,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu=
 *vcpu)
 			schedule();
 	}
=20
-	vmx->emulation_required =3D 0;
+	vmx->emulation_required =3D false;
 out:
 	return ret;
 }
@@ -5855,9 +5855,9 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
=20
 	if (!is_guest_mode(vcpu) && (exit_reason =3D=3D EXIT_REASON_VMLAUNCH ||
 	    exit_reason =3D=3D EXIT_REASON_VMRESUME))
-		vmx->nested.nested_run_pending =3D 1;
+		vmx->nested.nested_run_pending =3D true;
 	else
-		vmx->nested.nested_run_pending =3D 0;
+		vmx->nested.nested_run_pending =3D false;
=20
 	if (is_guest_mode(vcpu) && nested_vmx_exit_handled(vcpu)) {
 		nested_vmx_vmexit(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cbfc06..c9c4092 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -88,7 +88,7 @@ static void process_nmi(struct kvm_vcpu *vcpu);
 struct kvm_x86_ops *kvm_x86_ops;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
=20
-static bool ignore_msrs =3D 0;
+static bool ignore_msrs =3D false;
 module_param(ignore_msrs, bool, S_IRUGO | S_IWUSR);
=20
 bool kvm_has_tsc_control;
@@ -5135,7 +5135,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	int r;
 	bool req_int_win =3D !irqchip_in_kernel(vcpu->kvm) &&
 		vcpu->run->request_interrupt_window;
-	bool req_immediate_exit =3D 0;
+	bool req_immediate_exit =3D false;
=20
 	if (vcpu->requests) {
 		if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
diff --git a/arch/x86/platform/geode/alix.c b/arch/x86/platform/geode/alix.=
c
index dc5f1d3..361e638 100644
--- a/arch/x86/platform/geode/alix.c
+++ b/arch/x86/platform/geode/alix.c
@@ -27,7 +27,7 @@
=20
 #include <asm/geode.h>
=20
-static bool force =3D 0;
+static bool force =3D false;
 module_param(force, bool, 0444);
 /* FIXME: Award bios is not automatically detected as Alix platform */
 MODULE_PARM_DESC(force, "Force detection as ALIX.2/ALIX.3 platform");
diff --git a/arch/x86/platform/iris/iris.c b/arch/x86/platform/iris/iris.c
index 5917eb5..480e1af 100644
--- a/arch/x86/platform/iris/iris.c
+++ b/arch/x86/platform/iris/iris.c
@@ -65,7 +65,7 @@ static void iris_power_off(void)
 static int iris_init(void)
 {
 	unsigned char status;
-	if (force !=3D 1) {
+	if (!force) {
 		printk(KERN_ERR "The force parameter has not been set to 1 so the Iris p=
oweroff handler will not be installed.\n");
 		return -ENODEV;
 	}
diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc=
/olpc-xo1-sci.c
index 1d4c783..122399b 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -376,7 +376,7 @@ static int __devinit setup_lid_events(void)
 	gpio_direction_input(OLPC_GPIO_LID);
=20
 	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_INPUT_INVERT);
-	lid_inverted =3D 0;
+	lid_inverted =3D false;
=20
 	/* Clear edge detection and event enable for now */
 	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index ef5356c..056d9ff 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -56,7 +56,7 @@ static int hash_sendmsg(struct kiocb *unused, struct sock=
et *sock,
 			goto unlock;
 	}
=20
-	ctx->more =3D 0;
+	ctx->more =3D false;
=20
 	for (iov =3D msg->msg_iov, iovlen =3D msg->msg_iovlen; iovlen > 0;
 	     iovlen--, iov++) {
@@ -163,7 +163,7 @@ static int hash_recvmsg(struct kiocb *unused, struct so=
cket *sock,
=20
 	lock_sock(sk);
 	if (ctx->more) {
-		ctx->more =3D 0;
+		ctx->more =3D false;
 		ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);
 		err =3D af_alg_wait_for_completion(crypto_ahash_final(&ctx->req),
 						 &ctx->completion);
@@ -202,7 +202,7 @@ static int hash_accept(struct socket *sock, struct sock=
et *newsock, int flags)
 	sk2 =3D newsock->sk;
 	ask2 =3D alg_sk(sk2);
 	ctx2 =3D ask2->private;
-	ctx2->more =3D 1;
+	ctx2->more =3D true;
=20
 	err =3D crypto_ahash_import(&ctx2->req, state);
 	if (err) {
@@ -281,7 +281,7 @@ static int hash_accept_parent(void *private, struct soc=
k *sk)
 	memset(ctx->result, 0, ds);
=20
 	ctx->len =3D len;
-	ctx->more =3D 0;
+	ctx->more =3D false;
 	af_alg_init_completion(&ctx->completion);
=20
 	ask->private =3D ctx;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a6dfc0..aa8b80f 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -135,7 +135,7 @@ static void skcipher_pull_sgl(struct sock *sk, int used=
)
 	}
=20
 	if (!ctx->used)
-		ctx->merge =3D 0;
+		ctx->merge =3D false;
 }
=20
 static void skcipher_free_sgl(struct sock *sk)
@@ -250,7 +250,7 @@ static int skcipher_sendmsg(struct kiocb *unused, struc=
t socket *sock,
 	struct skcipher_sg_list *sgl;
 	struct af_alg_control con =3D {};
 	long copied =3D 0;
-	bool enc =3D 0;
+	bool enc =3D false;
 	int err;
 	int i;
=20
@@ -261,10 +261,10 @@ static int skcipher_sendmsg(struct kiocb *unused, str=
uct socket *sock,
=20
 		switch (con.op) {
 		case ALG_OP_ENCRYPT:
-			enc =3D 1;
+			enc =3D true;
 			break;
 		case ALG_OP_DECRYPT:
-			enc =3D 0;
+			enc =3D false;
 			break;
 		default:
 			return -EINVAL;
@@ -395,7 +395,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, s=
truct page *page,
 	if (err)
 		goto unlock;
=20
-	ctx->merge =3D 0;
+	ctx->merge =3D false;
 	sgl =3D list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
=20
 	get_page(page);
@@ -590,9 +590,9 @@ static int skcipher_accept_parent(void *private, struct=
 sock *sk)
 	INIT_LIST_HEAD(&ctx->tsgl);
 	ctx->len =3D len;
 	ctx->used =3D 0;
-	ctx->more =3D 0;
-	ctx->merge =3D 0;
-	ctx->enc =3D 0;
+	ctx->more =3D false;
+	ctx->merge =3D false;
+	ctx->enc =3D false;
 	af_alg_init_completion(&ctx->completion);
=20
 	ask->private =3D ctx;
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 7f00cf3..a76d990 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -199,7 +199,7 @@ err:
=20
 static int __init setup_hest_disable(char *str)
 {
-	hest_disable =3D 1;
+	hest_disable =3D true;
 	return 0;
 }
=20
@@ -242,5 +242,5 @@ void __init acpi_hest_init(void)
 	pr_info(HEST_PFX "Table parsing has been initialized.\n");
 	return;
 err:
-	hest_disable =3D 1;
+	hest_disable =3D true;
 }
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 88eb143..61b1387 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -43,7 +43,7 @@ MODULE_AUTHOR("Kristen Carlson Accardi");
 MODULE_DESCRIPTION(ACPI_DOCK_DRIVER_DESCRIPTION);
 MODULE_LICENSE("GPL");
=20
-static bool immediate_undock =3D 1;
+static bool immediate_undock =3D true;
 module_param(immediate_undock, bool, 0644);
 MODULE_PARM_DESC(immediate_undock, "1 (default) will cause the driver to "
 	"undock immediately when the undock button is pressed, 0 will cause"
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index c850de4..7aaa0b1 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -356,7 +356,7 @@ void __cpuinit acpi_processor_set_pdc(acpi_handle handl=
e)
 static acpi_status __init
 early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
-	if (processor_physically_present(handle) =3D=3D false)
+	if (!processor_physically_present(handle))
 		return AE_OK;
=20
 	acpi_processor_set_pdc(handle);
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index eaef02a..7b88c7a 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -69,7 +69,7 @@ MODULE_AUTHOR("Bruno Ducrot");
 MODULE_DESCRIPTION("ACPI Video Driver");
 MODULE_LICENSE("GPL");
=20
-static bool brightness_switch_enabled =3D 1;
+static bool brightness_switch_enabled =3D true;
 module_param(brightness_switch_enabled, bool, 0644);
=20
 /*
@@ -83,7 +83,7 @@ module_param(allow_duplicates, bool, 0644);
  * Some BIOSes claim they use minimum backlight at boot,
  * and this may bring dimming screen after boot
  */
-static bool use_bios_initial_backlight =3D 1;
+static bool use_bios_initial_backlight =3D true;
 module_param(use_bios_initial_backlight, bool, 0644);
=20
 static int register_count =3D 0;
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index f3f0fe7..57f69b6 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -155,7 +155,7 @@ long acpi_video_get_capabilities(acpi_handle graphics_h=
andle)
 				    &caps, NULL);
 		/* There might be boot param flags set already... */
 		acpi_video_support |=3D caps;
-		acpi_video_caps_checked =3D 1;
+		acpi_video_caps_checked =3D true;
 		/* Add blacklists here. Be careful to use the right *DMI* bits
 		 * to still be able to override logic via boot params, e.g.:
 		 *
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 55d6179..9a184fc 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -600,7 +600,7 @@ MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
=20
 static bool adma_enabled;
-static bool swncq_enabled =3D 1;
+static bool swncq_enabled =3D true;
 static bool msi_enabled;
=20
 static void nv_adma_register_mode(struct ata_port *ap)
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index b182c2f..4ac8f61 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -116,8 +116,8 @@ static bool disable64;
 static short nvpibits =3D -1;
 static short nvcibits =3D -1;
 static short rx_skb_reserve =3D 16;
-static bool irq_coalesce =3D 1;
-static bool sdh =3D 0;
+static bool irq_coalesce =3D true;
+static bool sdh =3D false;
=20
 /* Read from EEPROM =3D 0000 0011b */
 static unsigned int readtab[] =3D {
@@ -1080,7 +1080,7 @@ he_start(struct atm_dev *dev)
 	else
 		gen_cntl_0 &=3D ~ENBL_64;
=20
-	if (disable64 =3D=3D 1) {
+	if (disable64) {
 		hprintk("disabling 64-bit pci bus transfers\n");
 		gen_cntl_0 &=3D ~ENBL_64;
 	}
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b0f553b..172a0fd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3453,7 +3453,7 @@ static inline int interrupt_pending(ctlr_info_t *h)
=20
 static inline long interrupt_not_for_us(ctlr_info_t *h)
 {
-	return ((h->access.intr_pending(h) =3D=3D 0) ||
+	return ((!h->access.intr_pending(h)) ||
 		(h->interrupts_enabled =3D=3D 0));
 }
=20
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 831e3ac..3e620ca 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -126,7 +126,7 @@
 */
 #include <linux/types.h>
=20
-static bool verbose =3D 0;
+static bool verbose =3D false;
 static int major =3D PD_MAJOR;
 static char *name =3D PD_NAME;
 static int cluster =3D 64;
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index ec8f9ed..5c230e7 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -126,7 +126,7 @@
=20
 */
=20
-static bool verbose =3D 0;
+static bool verbose =3D false;
 static int major =3D PF_MAJOR;
 static char *name =3D PF_NAME;
 static int cluster =3D 64;
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 4a27b1d..c17f959 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -137,7 +137,7 @@
=20
 */
=20
-static bool verbose =3D 0;
+static bool verbose =3D false;
 static int major =3D PG_MAJOR;
 static char *name =3D PG_NAME;
 static int disable =3D 0;
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 2596042..c939456 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -117,7 +117,7 @@
=20
 */
=20
-static bool verbose =3D 0;
+static bool verbose =3D false;
 static int major =3D PT_MAJOR;
 static char *name =3D PT_NAME;
 static int disable =3D 0;
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 51a9727..fa4664b 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -1026,7 +1026,7 @@ static void __init do_xd_setup (int *integers)
 {
 	switch (integers[0]) {
 		case 4: if (integers[4] < 0)
-				nodma =3D 1;
+				nodma =3D true;
 			else if (integers[4] < 8)
 				xd_dma =3D integers[4];
 		case 3: if ((integers[3] > 0) && (integers[3] <=3D 0x3FC))
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f00f596..ffe2331 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -43,7 +43,7 @@ static bool ignore_sniffer;
 static bool disable_scofix;
 static bool force_scofix;
=20
-static bool reset =3D 1;
+static bool reset =3D true;
=20
 static struct usb_driver btusb_driver;
=20
diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index a767d4de..8eb7c03 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -49,8 +49,8 @@
=20
 #define VERSION "0.3"
=20
-static bool txcrc =3D 1;
-static bool hciextn =3D 1;
+static bool txcrc =3D true;
+static bool hciextn =3D true;
=20
 #define BCSP_TXWINSIZE	4
=20
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 0711448..af2964f 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -48,7 +48,7 @@
=20
 #define VERSION "2.2"
=20
-static bool reset =3D 0;
+static bool reset =3D false;
=20
 static struct hci_uart_proto *hup[HCI_UART_MAX_PROTO];
=20
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 55eaf47..0736ab6 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -289,13 +289,13 @@ static bool debug;
 /* used to keep tray locked at all times */
 static int keeplocked;
 /* default compatibility mode */
-static bool autoclose=3D1;
+static bool autoclose=3Dtrue;
 static bool autoeject;
-static bool lockdoor =3D 1;
+static bool lockdoor =3D true;
 /* will we ever get to use this... sigh. */
 static bool check_media_type;
 /* automatically restart mrw format */
-static bool mrw_format_restart =3D 1;
+static bool mrw_format_restart =3D true;
 module_param(debug, bool, 0);
 module_param(autoclose, bool, 0);
 module_param(autoeject, bool, 0);
@@ -317,13 +317,13 @@ static const char *mrw_address_space[] =3D { "DMA", "=
GAA" };
 #if (ERRLOGMASK!=3DCD_NOTHING)
 #define cdinfo(type, fmt, args...)			\
 do {							\
-	if ((ERRLOGMASK & type) || debug =3D=3D 1)		\
+	if ((ERRLOGMASK & type) || debug)		\
 		pr_info(fmt, ##args);			\
 } while (0)
 #else
 #define cdinfo(type, fmt, args...)			\
 do {							\
-	if (0 && (ERRLOGMASK & type) || debug =3D=3D 1)	\
+	if (0 && (ERRLOGMASK & type) || debug)	\
 		pr_info(fmt, ##args);			\
 } while (0)
 #endif
@@ -421,13 +421,13 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	cdo->n_minors =3D 0;
         cdi->options =3D CDO_USE_FFLAGS;
 =09
-	if (autoclose=3D=3D1 && CDROM_CAN(CDC_CLOSE_TRAY))
+	if (autoclose && CDROM_CAN(CDC_CLOSE_TRAY))
 		cdi->options |=3D (int) CDO_AUTO_CLOSE;
-	if (autoeject=3D=3D1 && CDROM_CAN(CDC_OPEN_TRAY))
+	if (autoeject && CDROM_CAN(CDC_OPEN_TRAY))
 		cdi->options |=3D (int) CDO_AUTO_EJECT;
-	if (lockdoor=3D=3D1)
+	if (lockdoor)
 		cdi->options |=3D (int) CDO_LOCK;
-	if (check_media_type=3D=3D1)
+	if (check_media_type)
 		cdi->options |=3D (int) CDO_CHECK_TYPE;
=20
 	if (CDROM_CAN(CDC_MRW_W))
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 444f8b6..cec2aea 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -33,7 +33,7 @@
 #define ULI_X86_64_ENU_SCR_REG		0x54
=20
 static struct resource *aperture_resource;
-static bool __initdata agp_try_unsupported =3D 1;
+static bool __initdata agp_try_unsupported =3D true;
 static int agp_bridges_found;
=20
 static void amd64_tlbflush(struct agp_memory *temp)
diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index 08704ae..22272eb 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -17,7 +17,7 @@
 #define PCI_DEVICE_ID_SI_662	0x0662
 #define PCI_DEVICE_ID_SI_671	0x0671
=20
-static bool __devinitdata agp_sis_force_delay =3D 0;
+static bool __devinitdata agp_sis_force_delay =3D false;
 static int __devinitdata agp_sis_agp_spec =3D -1;
=20
 static int sis_fetch_size(void)
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_i=
ntf.c
index 50fcf9c..d31847e 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1227,7 +1227,7 @@ static int smi_num; /* Used to sequence the SMIs */
 #define DEFAULT_REGSPACING	1
 #define DEFAULT_REGSIZE		1
=20
-static bool          si_trydefaults =3D 1;
+static bool          si_trydefaults =3D true;
 static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
 static char          si_type_str[MAX_SI_TYPE_STR];
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index f434856..f85749c 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -860,7 +860,7 @@ static int __init lp_setup (char *str)
 	} else if (!strcmp(str, "none")) {
 		parport_nr[parport_ptr++] =3D LP_PARPORT_NONE;
 	} else if (!strcmp(str, "reset")) {
-		reset =3D 1;
+		reset =3D true;
 	}
 	return 1;
 }
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/syncli=
nk_cs.c
index 07f6a5a..fad19cb 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -439,7 +439,7 @@ static int mgslpc_device_count =3D 0;
  * .text section address and breakpoint on module load.
  * This is useful for use with gdb and add-symbol-file command.
  */
-static bool break_on_load=3D0;
+static bool break_on_load=3Dfalse;
=20
 /*
  * Driver major number, defaults to zero to get auto
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a174862..2edff1a 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -369,7 +369,7 @@ static int probe_itpm(struct tpm_chip *chip)
 	size_t len =3D sizeof(cmd_getticks);
 	int rem_itpm =3D itpm;
=20
-	itpm =3D 0;
+	itpm =3D false;
=20
 	rc =3D tpm_tis_send_data(chip, cmd_getticks, len);
 	if (rc =3D=3D 0)
@@ -378,7 +378,7 @@ static int probe_itpm(struct tpm_chip *chip)
 	tpm_tis_ready(chip);
 	release_locality(chip, chip->vendor.locality, 0);
=20
-	itpm =3D 1;
+	itpm =3D true;
=20
 	rc =3D tpm_tis_send_data(chip, cmd_getticks, len);
 	if (rc =3D=3D 0) {
@@ -500,7 +500,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev=
_id)
 	return IRQ_HANDLED;
 }
=20
-static bool interrupts =3D 1;
+static bool interrupts =3D true;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
=20
@@ -737,10 +737,10 @@ static int __devinit tpm_tis_pnp_init(struct pnp_dev =
*pnp_dev,
 	if (pnp_irq_valid(pnp_dev, 0))
 		irq =3D pnp_irq(pnp_dev, 0);
 	else
-		interrupts =3D 0;
+		interrupts =3D false;
=20
 	if (is_itpm(pnp_dev))
-		itpm =3D 1;
+		itpm =3D true;
=20
 	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
diff --git a/drivers/char/xilinx_hwicap/buffer_icap.c b/drivers/char/xilinx=
_hwicap/buffer_icap.c
index 05d8977..53c3882 100644
--- a/drivers/char/xilinx_hwicap/buffer_icap.c
+++ b/drivers/char/xilinx_hwicap/buffer_icap.c
@@ -270,7 +270,7 @@ int buffer_icap_set_configuration(struct hwicap_drvdata=
 *drvdata, u32 *data,
 	int status;
 	s32 buffer_count =3D 0;
 	s32 num_writes =3D 0;
-	bool dirty =3D 0;
+	bool dirty =3D false;
 	u32 i;
 	void __iomem *base_address =3D drvdata->base_address;
=20
@@ -279,7 +279,7 @@ int buffer_icap_set_configuration(struct hwicap_drvdata=
 *drvdata, u32 *data,
=20
 		/* Copy data to bram */
 		buffer_icap_set_bram(base_address, buffer_count, data[i]);
-		dirty =3D 1;
+		dirty =3D true;
=20
 		if (buffer_count < XHI_MAX_BUFFER_INTS - 1) {
 			buffer_count++;
@@ -299,7 +299,7 @@ int buffer_icap_set_configuration(struct hwicap_drvdata=
 *drvdata, u32 *data,
=20
 		buffer_count =3D 0;
 		num_writes++;
-		dirty =3D 0;
+		dirty =3D false;
 	}
=20
 	/* Write unwritten data to ICAP */
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xili=
nx_hwicap/xilinx_hwicap.c
index e90e1c7..d14cca3 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -523,7 +523,7 @@ static int hwicap_open(struct inode *inode, struct file=
 *file)
 	file->private_data =3D drvdata;
 	drvdata->write_buffer_in_use =3D 0;
 	drvdata->read_buffer_in_use =3D 0;
-	drvdata->is_open =3D 1;
+	drvdata->is_open =3D true;
=20
  error:
 	mutex_unlock(&drvdata->sem);
@@ -556,7 +556,7 @@ static int hwicap_release(struct inode *inode, struct f=
ile *file)
 		goto error;
=20
  error:
-	drvdata->is_open =3D 0;
+	drvdata->is_open =3D false;
 	mutex_unlock(&drvdata->sem);
 	return status;
 }
@@ -600,7 +600,7 @@ static int __devinit hwicap_setup(struct device *dev, i=
nt id,
 		return -EBUSY;
 	}
=20
-	probed_devices[id] =3D 1;
+	probed_devices[id] =3D true;
 	mutex_unlock(&icap_sem);
=20
 	devt =3D MKDEV(XHWICAP_MAJOR, XHWICAP_MINOR + id);
@@ -643,7 +643,7 @@ static int __devinit hwicap_setup(struct device *dev, i=
nt id,
 	drvdata->config_regs =3D config_regs;
=20
 	mutex_init(&drvdata->sem);
-	drvdata->is_open =3D 0;
+	drvdata->is_open =3D false;
=20
 	dev_info(dev, "ioremap %llx to %p with size %llx\n",
 		 (unsigned long long) drvdata->mem_start,
@@ -672,7 +672,7 @@ static int __devinit hwicap_setup(struct device *dev, i=
nt id,
=20
  failed0:
 	mutex_lock(&icap_sem);
-	probed_devices[id] =3D 0;
+	probed_devices[id] =3D false;
 	mutex_unlock(&icap_sem);
=20
 	return retval;
@@ -709,7 +709,7 @@ static int __devexit hwicap_remove(struct device *dev)
 	dev_set_drvdata(dev, NULL);
=20
 	mutex_lock(&icap_sem);
-	probed_devices[MINOR(dev->devt)-XHWICAP_MINOR] =3D 0;
+	probed_devices[MINOR(dev->devt)-XHWICAP_MINOR] =3D false;
 	mutex_unlock(&icap_sem);
 	return 0;		/* success */
 }
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e73cf2e..6d44efc 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -221,7 +221,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	struct aead_tfm *tfm =3D &aead->base.crt_aead;
 	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);
 	struct device *jrdev =3D ctx->jrdev;
-	bool keys_fit_inline =3D 0;
+	bool keys_fit_inline =3D false;
 	u32 *key_jump_cmd, *jump_cmd;
 	u32 geniv, moveiv;
 	u32 *desc;
@@ -236,7 +236,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (DESC_AEAD_ENC_LEN + DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen <=3D
 	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline =3D 1;
+		keys_fit_inline =3D true;
=20
 	/* aead_encrypt shared descriptor */
 	desc =3D ctx->sh_desc_enc;
@@ -294,7 +294,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (DESC_AEAD_DEC_LEN + DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen <=3D
 	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline =3D 1;
+		keys_fit_inline =3D true;
=20
 	desc =3D ctx->sh_desc_dec;
=20
@@ -362,7 +362,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (DESC_AEAD_GIVENC_LEN + DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen <=3D
 	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline =3D 1;
+		keys_fit_inline =3D true;
=20
 	/* aead_givencrypt shared descriptor */
 	desc =3D ctx->sh_desc_givenc;
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9b592b0..f2ccbee 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -173,7 +173,7 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 	u32 cfghi =3D DWC_CFGH_FIFO_MODE;
 	u32 cfglo =3D DWC_CFGL_CH_PRIOR(dwc->priority);
=20
-	if (dwc->initialized =3D=3D true)
+	if (dwc->initialized)
 		return;
=20
 	if (dws) {
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 812fd76..5f4c390 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -1067,7 +1067,7 @@ static int sh_dmae_nmi_handler(struct notifier_block =
*self,
 		 * handling or NMI events that don't concern the DMACs.
 		 */
 		triggered =3D sh_dmae_nmi_notify(shdev);
-		if (triggered =3D=3D true)
+		if (triggered)
 			ret =3D NOTIFY_OK;
 	}
 	rcu_read_unlock();
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 2333810..75fb865 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -465,7 +465,7 @@ static struct dma_async_tx_descriptor *sirfsoc_dma_prep=
_interleaved(
 	 * and ylen (number of frame - 1) must be at least 0
 	 */
 	if ((xt->frame_size =3D=3D 1) && (xt->numf > 0)) {
-		sdesc->cyclic =3D 0;
+		sdesc->cyclic =3D false;
 		sdesc->xlen =3D xt->sgl[0].size / SIRFSOC_DMA_WORD_LEN;
 		sdesc->width =3D (xt->sgl[0].size + xt->sgl[0].icg) /
 				SIRFSOC_DMA_WORD_LEN;
@@ -532,7 +532,7 @@ sirfsoc_dma_prep_cyclic(struct dma_chan *chan, dma_addr=
_t addr,
 	/* Place descriptor in prepared list */
 	spin_lock_irqsave(&schan->lock, iflags);
 	sdesc->addr =3D addr;
-	sdesc->cyclic =3D 1;
+	sdesc->cyclic =3D true;
 	sdesc->xlen =3D 0;
 	sdesc->ylen =3D buf_len / SIRFSOC_DMA_WORD_LEN - 1;
 	sdesc->width =3D 1;
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 80e95aa..7909837 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -66,7 +66,7 @@
  *
  * Concurrent logins are useful together with cluster filesystems.
  */
-static bool sbp2_param_exclusive_login =3D 1;
+static bool sbp2_param_exclusive_login =3D true;
 module_param_named(exclusive_login, sbp2_param_exclusive_login, bool, 0644=
);
 MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
 		 "(default =3D Y, use N for concurrent initiators)");
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index ece03fc..66e56a3 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1271,7 +1271,7 @@ do_detailed_mode(struct detailed_timing *timing, void=
 *c)
=20
 		drm_mode_probed_add(closure->connector, newmode);
 		closure->modes++;
-		closure->preferred =3D 0;
+		closure->preferred =3D false;
 	}
 }
=20
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helpe=
r.c
index aada26f..ea75b12 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -280,7 +280,7 @@ void drm_fb_helper_restore(void)
 {
 	bool ret;
 	ret =3D drm_fb_helper_force_kernel_mode();
-	if (ret =3D=3D true)
+	if (ret)
 		DRM_ERROR("Failed to restore crtc configuration\n");
 }
 EXPORT_SYMBOL(drm_fb_helper_restore);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exy=
nos/exynos_drm_fimd.c
index b6a737d..8cbd5a2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -742,7 +742,7 @@ static int fimd_power_on(struct fimd_context *ctx, bool=
 enable)
=20
 	DRM_DEBUG_KMS("%s\n", __FILE__);
=20
-	if (enable !=3D false && enable !=3D true)
+	if (enable && !enable)
 		return -EINVAL;
=20
 	if (enable) {
diff --git a/drivers/gpu/drm/gma500/oaktrail_lvds.c b/drivers/gpu/drm/gma50=
0/oaktrail_lvds.c
index 238bbe1..5a3c41b 100644
--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -376,7 +376,7 @@ void oaktrail_lvds_init(struct drm_device *dev,
 		mode_dev->panel_wants_dither =3D (dev_priv->gct_data.
 			Panel_Port_Control & MRST_PANEL_8TO6_DITHER_ENABLE);
         if (dev_priv->lvds_dither)
-                mode_dev->panel_wants_dither =3D 1;
+                mode_dev->panel_wants_dither =3D true;
=20
 	/*
 	 * LVDS discovery:
diff --git a/drivers/gpu/drm/gma500/power.c b/drivers/gpu/drm/gma500/power.=
c
index 9402569..f5ec2f9 100644
--- a/drivers/gpu/drm/gma500/power.c
+++ b/drivers/gpu/drm/gma500/power.c
@@ -101,7 +101,7 @@ static void gma_resume_display(struct pci_dev *pdev)
 	struct drm_device *dev =3D pci_get_drvdata(pdev);
 	struct drm_psb_private *dev_priv =3D dev->dev_private;
=20
-	if (dev_priv->suspended =3D=3D false)
+	if (!dev_priv->suspended)
 		return;
=20
 	/* turn on the display power island */
@@ -259,7 +259,7 @@ bool gma_power_begin(struct drm_device *dev, bool force=
_on)
 		spin_unlock_irqrestore(&power_ctrl_lock, flags);
 		return true;
 	}
-	if (force_on =3D=3D false)
+	if (!force_on)
 		goto out_false;
=20
 	/* Ok power up needed */
diff --git a/drivers/gpu/drm/gma500/psb_intel_sdvo.c b/drivers/gpu/drm/gma5=
00/psb_intel_sdvo.c
index 88b4297..962ecd9 100644
--- a/drivers/gpu/drm/gma500/psb_intel_sdvo.c
+++ b/drivers/gpu/drm/gma500/psb_intel_sdvo.c
@@ -2578,8 +2578,7 @@ bool psb_intel_sdvo_init(struct drm_device *dev, int =
sdvo_reg)
 	if (!psb_intel_sdvo_get_capabilities(psb_intel_sdvo, &psb_intel_sdvo->cap=
s))
 		goto err;
=20
-	if (psb_intel_sdvo_output_setup(psb_intel_sdvo,
-				    psb_intel_sdvo->caps.output_flags) !=3D true) {
+	if (!psb_intel_sdvo_output_setup(psb_intel_sdvo, psb_intel_sdvo->caps.out=
put_flags)) {
 		DRM_DEBUG_KMS("SDVO output failed to setup on SDVO%c\n",
 			      IS_SDVOB(sdvo_reg) ? 'B' : 'C');
 		goto err;
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_dr=
v.c
index 308f819..acd0c0e 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -440,7 +440,7 @@ static int i915_drm_freeze(struct drm_device *dev)
 	intel_opregion_fini(dev);
=20
 	/* Modeset on resume, not lid events */
-	dev_priv->modeset_on_lid =3D 0;
+	dev_priv->modeset_on_lid =3D false;
=20
 	return 0;
 }
@@ -512,7 +512,7 @@ static int i915_drm_thaw(struct drm_device *dev)
=20
 	intel_opregion_init(dev);
=20
-	dev_priv->modeset_on_lid =3D 0;
+	dev_priv->modeset_on_lid =3D false;
=20
 	return error;
 }
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel=
_bios.c
index 63880e2..675adbd 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -237,7 +237,7 @@ parse_lfp_panel_data(struct drm_i915_private *dev_priv,
 	}
=20
 	if (downclock < panel_dvo_timing->clock && i915_lvds_downclock) {
-		dev_priv->lvds_downclock_avail =3D 1;
+		dev_priv->lvds_downclock_avail =3D true;
 		dev_priv->lvds_downclock =3D downclock * 10;
 		DRM_DEBUG_KMS("LVDS downclock is found in VBT. "
 			      "Normal Clock %dKHz, downclock %dKHz\n",
@@ -443,7 +443,7 @@ parse_driver_features(struct drm_i915_private *dev_priv=
,
=20
 	if (SUPPORTS_EDP(dev) &&
 	    driver->lvds_config =3D=3D BDB_DRIVER_FEATURE_EDP)
-		dev_priv->edp.support =3D 1;
+		dev_priv->edp.support =3D true;
=20
 	if (driver->dual_frequency)
 		dev_priv->render_reclock_avail =3D true;
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_=
crt.c
index dd729d4..7b1fffb 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -180,7 +180,7 @@ static bool intel_ironlake_crt_detect_hotplug(struct dr=
m_connector *connector)
 		bool turn_off_dac =3D HAS_PCH_SPLIT(dev);
 		u32 save_adpa;
=20
-		crt->force_hotplug_required =3D 0;
+		crt->force_hotplug_required =3D false;
=20
 		save_adpa =3D adpa =3D I915_READ(PCH_ADPA);
 		DRM_DEBUG_KMS("trigger hotplug detect cycle: adpa=3D0x%x\n", adpa);
@@ -507,7 +507,7 @@ static void intel_crt_reset(struct drm_connector *conne=
ctor)
 	struct intel_crt *crt =3D intel_attached_crt(connector);
=20
 	if (HAS_PCH_SPLIT(dev))
-		crt->force_hotplug_required =3D 1;
+		crt->force_hotplug_required =3D true;
 }
=20
 /*
@@ -610,7 +610,7 @@ void intel_crt_init(struct drm_device *dev)
 	/*
 	 * Configure the automatic hotplug detection stuff
 	 */
-	crt->force_hotplug_required =3D 0;
+	crt->force_hotplug_required =3D false;
 	if (HAS_PCH_SPLIT(dev)) {
 		u32 adpa;
=20
@@ -621,7 +621,7 @@ void intel_crt_init(struct drm_device *dev)
 		POSTING_READ(PCH_ADPA);
=20
 		DRM_DEBUG_KMS("pch crt adpa set to 0x%x\n", adpa);
-		crt->force_hotplug_required =3D 1;
+		crt->force_hotplug_required =3D true;
 	}
=20
 	dev_priv->hotplug_supported_mask |=3D CRT_HOTPLUG_INT_STATUS;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 00fbff5..64a4073 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5061,7 +5061,7 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
 			 */
 			DRM_DEBUG_KMS("Different P is found for "
 				      "LVDS clock/downclock\n");
-			has_reduced_clock =3D 0;
+			has_reduced_clock =3D false;
 		}
 	}
 	/* SDVO TV has fixed PLL values depend on its clock range,
@@ -5607,7 +5607,7 @@ static int ironlake_crtc_mode_set(struct drm_crtc *cr=
tc,
 			 */
 			DRM_DEBUG_KMS("Different P is found for "
 				      "LVDS clock/downclock\n");
-			has_reduced_clock =3D 0;
+			has_reduced_clock =3D false;
 		}
 	}
 	/* SDVO TV has fixed PLL values depend on its clock range,
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel=
_lvds.c
index aa84832..75103c0 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -524,14 +524,14 @@ static int intel_lid_notify(struct notifier_block *nb=
, unsigned long val,
 	if (dmi_check_system(intel_no_modeset_on_lid))
 		return NOTIFY_OK;
 	if (!acpi_lid_open()) {
-		dev_priv->modeset_on_lid =3D 1;
+		dev_priv->modeset_on_lid =3D true;
 		return NOTIFY_OK;
 	}
=20
 	if (!dev_priv->modeset_on_lid)
 		return NOTIFY_OK;
=20
-	dev_priv->modeset_on_lid =3D 0;
+	dev_priv->modeset_on_lid =3D false;
=20
 	mutex_lock(&dev->mode_config.mutex);
 	drm_helper_resume_force_mode(dev);
@@ -786,7 +786,7 @@ static void intel_find_lvds_downclock(struct drm_device=
 *dev,
 	}
 	if (temp_downclock < fixed_mode->clock && i915_lvds_downclock) {
 		/* We found the downclock for LVDS. */
-		dev_priv->lvds_downclock_avail =3D 1;
+		dev_priv->lvds_downclock_avail =3D true;
 		dev_priv->lvds_downclock =3D temp_downclock;
 		DRM_DEBUG_KMS("LVDS downclock is found in EDID. "
 			      "Normal clock %dKhz, downclock %dKhz\n",
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel=
_sdvo.c
index e334ec3..9f2c803 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2551,8 +2551,7 @@ bool intel_sdvo_init(struct drm_device *dev, int sdvo=
_reg)
 			     &intel_sdvo->hotplug_active, 2);
 	intel_sdvo->hotplug_active[0] &=3D ~0x3;
=20
-	if (intel_sdvo_output_setup(intel_sdvo,
-				    intel_sdvo->caps.output_flags) !=3D true) {
+	if (!intel_sdvo_output_setup(intel_sdvo, intel_sdvo->caps.output_flags)) =
{
 		DRM_DEBUG_KMS("SDVO output failed to setup on SDVO%c\n",
 			      IS_SDVOB(sdvo_reg) ? 'B' : 'C');
 		goto err;
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_t=
v.c
index 1571be3..035483a 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1293,7 +1293,7 @@ intel_tv_chose_preferred_modes(struct drm_connector *=
connector,
 	if (tv_mode->nbr_end < 480 && mode_ptr->vdisplay =3D=3D 480)
 		mode_ptr->type |=3D DRM_MODE_TYPE_PREFERRED;
 	else if (tv_mode->nbr_end > 480) {
-		if (tv_mode->progressive =3D=3D true && tv_mode->nbr_end < 720) {
+		if (tv_mode->progressive && tv_mode->nbr_end < 720) {
 			if (mode_ptr->vdisplay =3D=3D 720)
 				mode_ptr->type |=3D DRM_MODE_TYPE_PREFERRED;
 		} else if (mode_ptr->vdisplay =3D=3D 1080)
diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouve=
au/nouveau_bios.c
index e5cbead..577fea7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -1981,7 +1981,7 @@ init_i2c_if(struct nvbios *bios, uint16_t offset, str=
uct init_exec *iexec)
 		BIOSLOG(bios, "0x%04X: I2CReg: 0x%02X, Value: [no device], "
 			      "Mask: 0x%02X, Data: 0x%02X\n",
 			offset, reg, mask, data);
-		iexec->execute =3D 0;
+		iexec->execute =3D false;
 		return 6;
 	}
=20
@@ -3501,7 +3501,7 @@ init_i2c_long_if(struct nvbios *bios, uint16_t offset=
, struct init_exec *iexec)
 		BIOSLOG(bios, "0x%04X: I2CReg: 0x%02X:0x%02X, Value: [no device], "
 			      "Mask: 0x%02X, Data: 0x%02X\n",
 			offset, reghi, reglo, mask, data);
-		iexec->execute =3D 0;
+		iexec->execute =3D false;
 		return 7;
 	}
=20
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouv=
eau/nouveau_state.c
index f80c5e0..a09d745 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -1308,7 +1308,7 @@ nouveau_wait_cb(struct drm_device *dev, u64 timeout,
 	u64 start =3D ptimer->read(dev);
=20
 	do {
-		if (cond(data) =3D=3D true)
+		if (cond(data))
 			return true;
 	} while (ptimer->read(dev) - start < timeout);
=20
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index bfd36ab..2b49c0a 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1744,9 +1744,9 @@ static int r100_packet0_check(struct radeon_cs_parser=
 *p,
 	case RADEON_PP_TXFORMAT_2:
 		i =3D (reg - RADEON_PP_TXFORMAT_0) / 24;
 		if (idx_value & RADEON_TXFORMAT_NON_POWER2) {
-			track->textures[i].use_pitch =3D 1;
+			track->textures[i].use_pitch =3D true;
 		} else {
-			track->textures[i].use_pitch =3D 0;
+			track->textures[i].use_pitch =3D false;
 			track->textures[i].width =3D 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_=
SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
 			track->textures[i].height =3D 1 << ((idx_value >> RADEON_TXFORMAT_HEIGH=
T_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
 		}
@@ -2463,7 +2463,7 @@ void r100_vga_set_state(struct radeon_device *rdev, b=
ool state)
 	uint32_t temp;
=20
 	temp =3D RREG32(RADEON_CONFIG_CNTL);
-	if (state =3D=3D false) {
+	if (!state) {
 		temp &=3D ~RADEON_CFG_VGA_RAM_EN;
 		temp |=3D RADEON_CFG_VGA_IO_DIS;
 	} else {
@@ -3583,12 +3583,12 @@ void r100_cs_track_clear(struct radeon_device *rdev=
, struct r100_cs_track *track
 		else
 			track->num_texture =3D 6;
 		track->maxy =3D 2048;
-		track->separate_cube =3D 1;
+		track->separate_cube =3D true;
 	} else {
 		track->num_cb =3D 4;
 		track->num_texture =3D 16;
 		track->maxy =3D 4096;
-		track->separate_cube =3D 0;
+		track->separate_cube =3D false;
 		track->aaresolve =3D false;
 		track->aa.robj =3D NULL;
 	}
@@ -4041,7 +4041,7 @@ int r100_init(struct radeon_device *rdev)
 			RREG32(R_0007C0_CP_STAT));
 	}
 	/* check if cards are posted or not */
-	if (radeon_boot_test_post_card(rdev) =3D=3D false)
+	if (!radeon_boot_test_post_card(rdev))
 		return -EINVAL;
 	/* Set asic errata */
 	r100_errata(rdev);
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 3fc0d29..24277c0 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1521,7 +1521,7 @@ int r300_init(struct radeon_device *rdev)
 			RREG32(R_0007C0_CP_STAT));
 	}
 	/* check if cards are posted or not */
-	if (radeon_boot_test_post_card(rdev) =3D=3D false)
+	if (!radeon_boot_test_post_card(rdev))
 		return -EINVAL;
 	/* Set asic errata */
 	r300_errata(rdev);
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 4f08e5e..69cdc29 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2505,7 +2505,7 @@ void r600_vga_set_state(struct radeon_device *rdev, b=
ool state)
 	uint32_t temp;
=20
 	temp =3D RREG32(CONFIG_CNTL);
-	if (state =3D=3D false) {
+	if (!state) {
 		temp &=3D ~(1<<0);
 		temp |=3D (1<<1);
 	} else {
diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm=
/radeon/radeon_atpx_handler.c
index 98724fc..0a0b83c 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -253,7 +253,7 @@ static bool radeon_atpx_detect(void)
 	while ((pdev =3D pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev)) !=3D NU=
LL) {
 		vga_count++;
=20
-		has_atpx |=3D (radeon_atpx_pci_probe_handle(pdev) =3D=3D true);
+		has_atpx |=3D (radeon_atpx_pci_probe_handle(pdev));
 	}
=20
 	if (has_atpx && vga_count =3D=3D 2) {
diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/=
radeon_bios.c
index 501f488..63c1965 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -483,14 +483,14 @@ bool radeon_get_bios(struct radeon_device *rdev)
 	uint16_t tmp;
=20
 	r =3D radeon_atrm_get_bios(rdev);
-	if (r =3D=3D false)
+	if (!r)
 		r =3D igp_read_bios_from_vram(rdev);
-	if (r =3D=3D false)
+	if (!r)
 		r =3D radeon_read_bios(rdev);
-	if (r =3D=3D false) {
+	if (!r) {
 		r =3D radeon_read_disabled_bios(rdev);
 	}
-	if (r =3D=3D false || rdev->bios =3D=3D NULL) {
+	if (!r || rdev->bios =3D=3D NULL) {
 		DRM_ERROR("Unable to locate a BIOS ROM\n");
 		rdev->bios =3D NULL;
 		return false;
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/r=
adeon/radeon_connectors.c
index e7cb3ab..5950e54 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -195,7 +195,7 @@ radeon_connector_analog_encoder_conflict_solve(struct d=
rm_connector *connector,
 				if (radeon_conflict->use_digital)
 					continue;
=20
-				if (priority =3D=3D true) {
+				if (priority) {
 					DRM_DEBUG_KMS("1: conflicting encoders switching off %s\n", drm_get_c=
onnector_name(conflict));
 					DRM_DEBUG_KMS("in favor of %s\n", drm_get_connector_name(connector));
 					conflict->status =3D connector_status_disconnected;
@@ -421,7 +421,7 @@ int radeon_connector_set_property(struct drm_connector =
*connector, struct drm_pr
 			else
 				ret =3D radeon_legacy_get_tmds_info_from_combios(radeon_encoder, tmds)=
;
 		}
-		if (val =3D=3D 1 || ret =3D=3D false) {
+		if (val =3D=3D 1 || !ret) {
 			radeon_legacy_get_tmds_info_from_table(radeon_encoder, tmds);
 		}
 		radeon_property_change_mode(&radeon_encoder->base);
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/rade=
on/radeon_display.c
index 8c49fef..8f0be13 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -672,11 +672,11 @@ static bool radeon_setup_enc_conn(struct drm_device *=
dev)
 	if (rdev->bios) {
 		if (rdev->is_atom_bios) {
 			ret =3D radeon_get_atom_connector_info_from_supported_devices_table(dev=
);
-			if (ret =3D=3D false)
+			if (!ret)
 				ret =3D radeon_get_atom_connector_info_from_object_table(dev);
 		} else {
 			ret =3D radeon_get_legacy_connector_info_from_bios(dev);
-			if (ret =3D=3D false)
+			if (!ret)
 				ret =3D radeon_get_legacy_connector_info_from_table(dev);
 		}
 	} else {
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/=
drm/radeon/radeon_legacy_encoders.c
index 2f46e0c..4b25a7e 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -1560,7 +1560,7 @@ static struct radeon_encoder_int_tmds *radeon_legacy_=
get_tmds_info(struct radeon
 	else
 		ret =3D radeon_legacy_get_tmds_info_from_combios(encoder, tmds);
=20
-	if (ret =3D=3D false)
+	if (!ret)
 		radeon_legacy_get_tmds_info_from_table(encoder, tmds);
=20
 	return tmds;
@@ -1583,7 +1583,7 @@ static struct radeon_encoder_ext_tmds *radeon_legacy_=
get_ext_tmds_info(struct ra
=20
 	ret =3D radeon_legacy_get_ext_tmds_info_from_combios(encoder, tmds);
=20
-	if (ret =3D=3D false)
+	if (!ret)
 		radeon_legacy_get_ext_tmds_info_from_table(encoder, tmds);
=20
 	return tmds;
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeo=
n/radeon_object.c
index d45df17..5f3a1e9 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -275,7 +275,7 @@ int radeon_bo_evict_vram(struct radeon_device *rdev)
 {
 	/* late 2.6.33 fix IGP hibernate - we need pm ops to do this correct */
 	if (0 && (rdev->flags & RADEON_IS_IGP)) {
-		if (rdev->mc.igp_sideport_enabled =3D=3D false)
+		if (!rdev->mc.igp_sideport_enabled)
 			/* Useless to evict on IGP chips */
 			return 0;
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/ra=
deon_pm.c
index 095148e..c44dadf 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -786,7 +786,7 @@ static bool radeon_pm_debug_check_in_vbl(struct radeon_=
device *rdev, bool finish
 	u32 stat_crtc =3D 0;
 	bool in_vbl =3D radeon_pm_in_vbl(rdev);
=20
-	if (in_vbl =3D=3D false)
+	if (!in_vbl)
 		DRM_DEBUG_DRIVER("not in vbl for pm change %08x at %s\n", stat_crtc,
 			 finish ? "exit" : "entry");
 	return in_vbl;
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/r=
adeon_ttm.c
index c421e77..c616f15 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -188,7 +188,7 @@ static void radeon_evict_flags(struct ttm_buffer_object=
 *bo,
 	rbo =3D container_of(bo, struct radeon_bo, tbo);
 	switch (bo->mem.mem_type) {
 	case TTM_PL_VRAM:
-		if (rbo->rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ready =3D=3D false)
+		if (!rbo->rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ready)
 			radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_CPU);
 		else
 			radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_GTT);
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.=
c
index ec46eb4..d1fcad9a 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -959,7 +959,7 @@ int rs600_init(struct radeon_device *rdev)
 			RREG32(R_0007C0_CP_STAT));
 	}
 	/* check if cards are posted or not */
-	if (radeon_boot_test_post_card(rdev) =3D=3D false)
+	if (!radeon_boot_test_post_card(rdev))
 		return -EINVAL;
=20
 	/* Initialize clocks */
diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switche=
roo.c
index 58434e8..8e32741 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -219,7 +219,7 @@ static int vga_switchto_stage1(struct vga_switcheroo_cl=
ient *new_client)
 	struct vga_switcheroo_client *active =3D NULL;
=20
 	for (i =3D 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
-		if (vgasr_priv.clients[i].active =3D=3D true) {
+		if (vgasr_priv.clients[i].active) {
 			active =3D &vgasr_priv.clients[i];
 			break;
 		}
@@ -244,7 +244,7 @@ static int vga_switchto_stage2(struct vga_switcheroo_cl=
ient *new_client)
 	struct vga_switcheroo_client *active =3D NULL;
=20
 	for (i =3D 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
-		if (vgasr_priv.clients[i].active =3D=3D true) {
+		if (vgasr_priv.clients[i].active) {
 			active =3D &vgasr_priv.clients[i];
 			break;
 		}
@@ -363,23 +363,23 @@ vga_switcheroo_debugfs_write(struct file *filp, const=
 char __user *ubuf,
 		goto out;
 	}
=20
-	if (client->active =3D=3D true)
+	if (client->active)
 		goto out;
=20
 	/* okay we want a switch - test if devices are willing to switch */
 	can_switch =3D true;
 	for (i =3D 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
 		can_switch =3D vgasr_priv.clients[i].can_switch(vgasr_priv.clients[i].pd=
ev);
-		if (can_switch =3D=3D false) {
+		if (!can_switch) {
 			printk(KERN_ERR "vga_switcheroo: client %d refused switch\n", i);
 			break;
 		}
 	}
=20
-	if (can_switch =3D=3D false && delay =3D=3D false)
+	if (!can_switch && !delay)
 		goto out;
=20
-	if (can_switch =3D=3D true) {
+	if (can_switch) {
 		pdev_name =3D pci_name(client->pdev);
 		ret =3D vga_switchto_stage1(client);
 		if (ret)
@@ -468,13 +468,13 @@ int vga_switcheroo_process_delayed_switch(void)
 		if (vgasr_priv.clients[i].id =3D=3D vgasr_priv.delayed_client_id)
 			client =3D &vgasr_priv.clients[i];
 		can_switch =3D vgasr_priv.clients[i].can_switch(vgasr_priv.clients[i].pd=
ev);
-		if (can_switch =3D=3D false) {
+		if (!can_switch) {
 			printk(KERN_ERR "vga_switcheroo: client %d refused switch\n", i);
 			break;
 		}
 	}
=20
-	if (can_switch =3D=3D false || client =3D=3D NULL)
+	if (!can_switch || client =3D=3D NULL)
 		goto err;
=20
 	pdev_name =3D pci_name(client->pdev);
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 6ecc9e2..1994db2 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -426,7 +426,7 @@ int lg4ff_init(struct hid_device *hid)
 		/* Initialize device_list if this is the first device to handle by lg4ff=
 */
 	if (!list_inited) {
 		INIT_LIST_HEAD(&device_list.list);
-		list_inited =3D 1;
+		list_inited =3D true;
 	}
=20
 	/* Add the device to device_list */
@@ -463,7 +463,7 @@ int lg4ff_init(struct hid_device *hid)
=20
 int lg4ff_deinit(struct hid_device *hid)
 {
-	bool found =3D 0;
+	bool found =3D false;
 	struct lg4ff_device_entry *entry;
 	struct list_head *h, *g;
 	list_for_each_safe(h, g, &device_list.list) {
@@ -472,7 +472,7 @@ int lg4ff_deinit(struct hid_device *hid)
 			list_del(h);
 			kfree(entry->device_id);
 			kfree(entry);
-			found =3D 1;
+			found =3D true;
 			break;
 		}
 	}
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 9fae2eb..b6c767a 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -590,8 +590,8 @@ static int ntrig_event (struct hid_device *hid, struct =
hid_field *field,
 	switch (usage->hid) {
 	case 0xff000001:
 		/* Tag indicating the start of a multitouch group */
-		nd->reading_mt =3D 1;
-		nd->first_contact_touch =3D 0;
+		nd->reading_mt =3D true;
+		nd->first_contact_touch =3D false;
 		break;
 	case HID_DG_TIPSWITCH:
 		nd->tipswitch =3D value;
@@ -662,7 +662,7 @@ static int ntrig_event (struct hid_device *hid, struct =
hid_field *field,
 			 * even if deactivation slack is turned off.
 			 */
 			nd->act_state =3D deactivate_slack - 1;
-			nd->confidence =3D 0;
+			nd->confidence =3D false;
 			break;
 		}
=20
@@ -678,7 +678,7 @@ static int ntrig_event (struct hid_device *hid, struct =
hid_field *field,
 			 */
 			if (nd->w < nd->min_width ||
 			    nd->h < nd->min_height)
-				nd->confidence =3D 0;
+				nd->confidence =3D false;
 		} else
 			break;
=20
@@ -757,7 +757,7 @@ static int ntrig_event (struct hid_device *hid, struct =
hid_field *field,
 		if (!nd->reading_mt) /* Just to be sure */
 			break;
=20
-		nd->reading_mt =3D 0;
+		nd->reading_mt =3D false;
=20
=20
 		/*
@@ -876,7 +876,7 @@ static int ntrig_probe(struct hid_device *hdev, const s=
truct hid_device_id *id)
 		return -ENOMEM;
 	}
=20
-	nd->reading_mt =3D 0;
+	nd->reading_mt =3D false;
 	nd->min_width =3D 0;
 	nd->min_height =3D 0;
 	nd->activate_slack =3D activate_slack;
diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
index 34a14a7..5d49114 100644
--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -607,7 +607,7 @@ static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Set to one to force detection.");
 /* Default verbose is 1, since this driver is still in the testing phase *=
/
-static bool verbose =3D 1;
+static bool verbose =3D true;
 module_param(verbose, bool, 0644);
 MODULE_PARM_DESC(verbose, "Enable/disable verbose error reporting");
=20
diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index ed60242..1db9a20 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -48,8 +48,8 @@ static const unsigned short normal_i2c[] =3D { 0x48, 0x49=
, 0x4a, 0x4b,
 	I2C_CLIENT_END };
=20
 /* Module parameters */
-static bool se_input =3D 1; /* Default is SE, 0 =3D=3D diff */
-static bool int_vref =3D 1; /* Default is internal ref ON */
+static bool se_input =3D true; /* Default is SE, 0 =3D=3D diff */
+static bool int_vref =3D true; /* Default is internal ref ON */
 static int vref_mv =3D ADS7828_INT_VREF_MV; /* set if vref !=3D 2.5V */
 module_param(se_input, bool, S_IRUGO);
 module_param(int_vref, bool, S_IRUGO);
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index a6c6ec3..e9d7d3e 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -176,12 +176,12 @@ static ssize_t show_temp(struct device *dev,
 	/* Check whether the time interval has elapsed */
 	if (!tdata->valid || time_after(jiffies, tdata->last_updated + HZ)) {
 		rdmsr_on_cpu(tdata->cpu, tdata->status_reg, &eax, &edx);
-		tdata->valid =3D 0;
+		tdata->valid =3D false;
 		/* Check whether the data is valid */
 		if (eax & 0x80000000) {
 			tdata->temp =3D tdata->tjmax -
 					((eax >> 16) & 0x7f) * 1000;
-			tdata->valid =3D 1;
+			tdata->valid =3D true;
 		}
 		tdata->last_updated =3D jiffies;
 	}
diff --git a/drivers/hwmon/lineage-pem.c b/drivers/hwmon/lineage-pem.c
index 58eded2..e139929 100644
--- a/drivers/hwmon/lineage-pem.c
+++ b/drivers/hwmon/lineage-pem.c
@@ -202,7 +202,7 @@ static struct pem_data *pem_update_device(struct device=
 *dev)
 		i2c_smbus_write_byte(client, PEM_CLEAR_INFO_FLAGS);
=20
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
 abort:
 	mutex_unlock(&data->update_lock);
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index b3311b1..e6058ed 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -247,7 +247,7 @@ static int lm75_detect(struct i2c_client *new_client,
 	struct i2c_adapter *adapter =3D new_client->adapter;
 	int i;
 	int conf, hyst, os;
-	bool is_lm75a =3D 0;
+	bool is_lm75a =3D false;
=20
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
 				     I2C_FUNC_SMBUS_WORD_DATA))
@@ -291,7 +291,7 @@ static int lm75_detect(struct i2c_client *new_client,
 		 || i2c_smbus_read_byte_data(new_client, 5) !=3D 0xff
 		 || i2c_smbus_read_byte_data(new_client, 6) !=3D 0xff)
 			return -ENODEV;
-		is_lm75a =3D 1;
+		is_lm75a =3D true;
 		hyst =3D i2c_smbus_read_byte_data(new_client, 2);
 		os =3D i2c_smbus_read_byte_data(new_client, 3);
 	} else { /* Traditional style LM75 detection */
diff --git a/drivers/hwmon/lm95245.c b/drivers/hwmon/lm95245.c
index 5e5fc1b..7e77145 100644
--- a/drivers/hwmon/lm95245.c
+++ b/drivers/hwmon/lm95245.c
@@ -155,7 +155,7 @@ static struct lm95245_data *lm95245_update_device(struc=
t device *dev)
 			  =3D i2c_smbus_read_byte_data(client,
 						     lm95245_reg_address[i]);
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
=20
 	mutex_unlock(&data->update_lock);
@@ -263,7 +263,7 @@ static ssize_t set_limit(struct device *dev, struct dev=
ice_attribute *attr,
=20
 	mutex_lock(&data->update_lock);
=20
-	data->valid =3D 0;
+	data->valid =3D false;
=20
 	i2c_smbus_write_byte_data(client, lm95245_reg_address[index], val);
=20
@@ -288,7 +288,7 @@ static ssize_t set_crit_hyst(struct device *dev, struct=
 device_attribute *attr,
=20
 	mutex_lock(&data->update_lock);
=20
-	data->valid =3D 0;
+	data->valid =3D false;
=20
 	/* shared crit hysteresis */
 	i2c_smbus_write_byte_data(client, LM95245_REG_RW_COMMON_HYSTERESIS,
@@ -328,7 +328,7 @@ static ssize_t set_type(struct device *dev, struct devi=
ce_attribute *attr,
 	else
 		data->config2 &=3D ~CFG2_REMOTE_TT;
=20
-	data->valid =3D 0;
+	data->valid =3D false;
=20
 	i2c_smbus_write_byte_data(client, LM95245_REG_RW_CONFIG2,
 				  data->config2);
@@ -440,7 +440,7 @@ static void lm95245_init_client(struct i2c_client *clie=
nt)
 {
 	struct lm95245_data *data =3D i2c_get_clientdata(client);
=20
-	data->valid =3D 0;
+	data->valid =3D false;
 	data->interval =3D lm95245_read_conversion_rate(client);
=20
 	data->config1 =3D i2c_smbus_read_byte_data(client,
diff --git a/drivers/hwmon/ltc4151.c b/drivers/hwmon/ltc4151.c
index 4ac06b7..e6f1914 100644
--- a/drivers/hwmon/ltc4151.c
+++ b/drivers/hwmon/ltc4151.c
@@ -88,7 +88,7 @@ static struct ltc4151_data *ltc4151_update_device(struct =
device *dev)
 			data->regs[i] =3D val;
 		}
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
 abort:
 	mutex_unlock(&data->update_lock);
diff --git a/drivers/hwmon/ltc4215.c b/drivers/hwmon/ltc4215.c
index c7e6d8e..505e33f 100644
--- a/drivers/hwmon/ltc4215.c
+++ b/drivers/hwmon/ltc4215.c
@@ -66,7 +66,7 @@ static struct ltc4215_data *ltc4215_update_device(struct =
device *dev)
 		}
=20
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
=20
 	mutex_unlock(&data->update_lock);
diff --git a/drivers/hwmon/ltc4245.c b/drivers/hwmon/ltc4245.c
index 6593083..834007d 100644
--- a/drivers/hwmon/ltc4245.c
+++ b/drivers/hwmon/ltc4245.c
@@ -162,7 +162,7 @@ static struct ltc4245_data *ltc4245_update_device(struc=
t device *dev)
 		ltc4245_update_gpios(dev);
=20
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
=20
 	mutex_unlock(&data->update_lock);
diff --git a/drivers/hwmon/ltc4261.c b/drivers/hwmon/ltc4261.c
index ce52355..62e3d59 100644
--- a/drivers/hwmon/ltc4261.c
+++ b/drivers/hwmon/ltc4261.c
@@ -85,13 +85,13 @@ static struct ltc4261_data *ltc4261_update_device(struc=
t device *dev)
 					"Failed to read ADC value: error %d\n",
 					val);
 				ret =3D ERR_PTR(val);
-				data->valid =3D 0;
+				data->valid =3D false;
 				goto abort;
 			}
 			data->regs[i] =3D val;
 		}
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
 abort:
 	mutex_unlock(&data->update_lock);
diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index f8e323a..3263eac 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -169,7 +169,7 @@ static struct max16065_data *max16065_update_device(str=
uct device *dev)
 			  =3D i2c_smbus_read_byte_data(client, MAX16065_FAULT(i));
=20
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
 	mutex_unlock(&data->update_lock);
 	return data;
diff --git a/drivers/hwmon/max6642.c b/drivers/hwmon/max6642.c
index 209e8a5..f1d4597 100644
--- a/drivers/hwmon/max6642.c
+++ b/drivers/hwmon/max6642.c
@@ -194,7 +194,7 @@ static struct max6642_data *max6642_update_device(struc=
t device *dev)
 					MAX6642_REG_R_STATUS);
=20
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
=20
 	mutex_unlock(&data->update_lock);
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_c=
ore.c
index 00460d8..ff14f01 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -424,7 +424,7 @@ static struct pmbus_data *pmbus_update_device(struct de=
vice *dev)
 		}
 		pmbus_clear_faults(client);
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
 	mutex_unlock(&data->update_lock);
 	return data;
diff --git a/drivers/hwmon/smm665.c b/drivers/hwmon/smm665.c
index 4116381..be86a74 100644
--- a/drivers/hwmon/smm665.c
+++ b/drivers/hwmon/smm665.c
@@ -267,7 +267,7 @@ static struct smm665_data *smm665_update_device(struct =
device *dev)
 			data->adc[i] =3D val;
 		}
 		data->last_updated =3D jiffies;
-		data->valid =3D 1;
+		data->valid =3D true;
 	}
 abort:
 	mutex_unlock(&data->update_lock);
diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index 374118f..70ee666 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -71,7 +71,7 @@ module_param(force_i2c, byte, 0);
 MODULE_PARM_DESC(force_i2c,
 		 "Initialize the i2c address of the sensors");
=20
-static bool init =3D 1;
+static bool init =3D true;
 module_param(init, bool, 0);
 MODULE_PARM_DESC(init, "Set to zero to bypass chip initialization");
=20
diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
index 17a8fa2..c5f5f78 100644
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -71,7 +71,7 @@ static bool reset;
 module_param(reset, bool, 0);
 MODULE_PARM_DESC(reset, "Set to one to reset chip on load");
=20
-static bool init =3D 1;
+static bool init =3D true;
 module_param(init, bool, 0);
 MODULE_PARM_DESC(init, "Set to zero to bypass chip initialization");
=20
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.=
c
index 6381604..15ee223 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -375,7 +375,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev=
)
 	clk_disable(i2c_dev->clk);
=20
 	if (i2c_dev->irq_disabled) {
-		i2c_dev->irq_disabled =3D 0;
+		i2c_dev->irq_disabled =3D false;
 		enable_irq(i2c_dev->irq);
 	}
=20
@@ -399,7 +399,7 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
=20
 		if (!i2c_dev->irq_disabled) {
 			disable_irq_nosync(i2c_dev->irq);
-			i2c_dev->irq_disabled =3D 1;
+			i2c_dev->irq_disabled =3D true;
 		}
=20
 		complete(&i2c_dev->msg_complete);
diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapr=
o.c
index 333011c..16f1788 100644
--- a/drivers/i2c/busses/i2c-viapro.c
+++ b/drivers/i2c/busses/i2c-viapro.c
@@ -329,7 +329,7 @@ static int __devinit vt596_probe(struct pci_dev *pdev,
 	/* Determine the address of the SMBus areas */
 	if (force_addr) {
 		vt596_smba =3D force_addr & 0xfff0;
-		force =3D 0;
+		force =3D false;
 		goto found;
 	}
=20
diff --git a/drivers/ide/ali14xx.c b/drivers/ide/ali14xx.c
index d3be99f..47778f2 100644
--- a/drivers/ide/ali14xx.c
+++ b/drivers/ide/ali14xx.c
@@ -228,7 +228,7 @@ MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets")=
;
=20
 static int __init ali14xx_init(void)
 {
-	if (probe_ali14xx =3D=3D 0)
+	if (!probe_ali14xx)
 		goto out;
=20
 	/* auto-detect IDE controller port */
diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index 1471730..f587c7f 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -726,7 +726,7 @@ static int __init cmd640x_init(void)
 	if (cmd640_vlb && probe_for_cmd640_vlb()) {
 		bus_type =3D "VLB";
 	} else {
-		cmd640_vlb =3D 0;
+		cmd640_vlb =3D false;
 		/* Find out what kind of PCI probing is supported otherwise
 		   Justin Gibbs will sulk.. */
 		if (pci_conf1() && probe_for_cmd640_pci1())
diff --git a/drivers/ide/dtc2278.c b/drivers/ide/dtc2278.c
index 46af474..7c96476 100644
--- a/drivers/ide/dtc2278.c
+++ b/drivers/ide/dtc2278.c
@@ -137,7 +137,7 @@ MODULE_PARM_DESC(probe, "probe for DTC2278xx chipsets")=
;
=20
 static int __init dtc2278_init(void)
 {
-	if (probe_dtc2278 =3D=3D 0)
+	if (!probe_dtc2278)
 		return -ENODEV;
=20
 	if (dtc2278_probe()) {
diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
index 986f251..91a943a 100644
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -354,7 +354,7 @@ static const struct ide_port_info ht6560b_port_info __i=
nitdata =3D {
=20
 static int __init ht6560b_init(void)
 {
-	if (probe_ht6560b =3D=3D 0)
+	if (!probe_ht6560b)
 		return -ENODEV;
=20
 	if (!request_region(HT_CONFIG_PORT, 1, DRV_NAME)) {
diff --git a/drivers/ide/ide-4drives.c b/drivers/ide/ide-4drives.c
index 547d7cf..4e47780 100644
--- a/drivers/ide/ide-4drives.c
+++ b/drivers/ide/ide-4drives.c
@@ -33,7 +33,7 @@ static int __init ide_4drives_init(void)
 	unsigned long base =3D 0x1f0, ctl =3D 0x3f6;
 	struct ide_hw hw, *hws[] =3D { &hw, &hw };
=20
-	if (probe_4drives =3D=3D 0)
+	if (!probe_4drives)
 		return -ENODEV;
=20
 	if (!request_region(base, 8, DRV_NAME)) {
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index f1a6796b..659e33d 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -96,7 +96,7 @@ int ide_acpi_init(void)
=20
 bool ide_port_acpi(ide_hwif_t *hwif)
 {
-	return ide_noacpi =3D=3D 0 && hwif->acpidata;
+	return !ide_noacpi && hwif->acpidata;
 }
=20
 /**
@@ -592,7 +592,7 @@ void ide_acpi_port_init_devices(ide_hwif_t *hwif)
 				 drive->name, err);
 	}
=20
-	if (ide_noacpi || ide_acpionboot =3D=3D 0) {
+	if (ide_noacpi || !ide_acpionboot) {
 		DEBPRINT("ACPI methods disabled on boot\n");
 		return;
 	}
diff --git a/drivers/ide/ide-pci-generic.c b/drivers/ide/ide-pci-generic.c
index 7f56b73..0c95d0a 100644
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -109,7 +109,7 @@ static int __devinit generic_init_one(struct pci_dev *d=
ev, const struct pci_devi
 	int ret =3D -ENODEV;
=20
 	/* Don't use the generic entry unless instructed to do so */
-	if (id->driver_data =3D=3D 0 && ide_generic_all =3D=3D 0)
+	if (id->driver_data =3D=3D 0 && !ide_generic_all)
 			goto out;
=20
 	switch (dev->vendor) {
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 8bbfe55..d31fb41 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -426,7 +426,7 @@ static int __init qd65xx_init(void)
 {
 	int rc1, rc2 =3D -ENODEV;
=20
-	if (probe_qd65xx =3D=3D 0)
+	if (!probe_qd65xx)
 		return -ENODEV;
=20
 	rc1 =3D qd_probe(0x30);
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index 5cfb781..a220437 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -167,7 +167,7 @@ MODULE_PARM_DESC(probe, "probe for UMC8672 chipset");
=20
 static int __init umc8672_init(void)
 {
-	if (probe_umc8672 =3D=3D 0)
+	if (!probe_umc8672)
 		goto out;
=20
 	if (umc8672_probe() =3D=3D 0)
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw=
/ehca/ehca_main.c
index 832e7a7..65a674e 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -59,16 +59,16 @@ MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
 MODULE_DESCRIPTION("IBM eServer HCA InfiniBand Device Driver");
 MODULE_VERSION(HCAD_VERSION);
=20
-static bool ehca_open_aqp1    =3D 0;
+static bool ehca_open_aqp1    =3D false;
 static int ehca_hw_level      =3D 0;
-static bool ehca_poll_all_eqs =3D 1;
+static bool ehca_poll_all_eqs =3D true;
=20
 int ehca_debug_level   =3D 0;
 int ehca_nr_ports      =3D -1;
-bool ehca_use_hp_mr    =3D 0;
+bool ehca_use_hp_mr    =3D false;
 int ehca_port_act_time =3D 30;
 int ehca_static_rate   =3D -1;
-bool ehca_scaling_code =3D 0;
+bool ehca_scaling_code =3D false;
 int ehca_lock_hcalls   =3D -1;
 int ehca_max_cq        =3D -1;
 int ehca_max_qp        =3D -1;
@@ -808,7 +808,7 @@ static int __devinit ehca_probe(struct platform_device =
*dev,
 	}
=20
 	/* create AQP1 for port 1 */
-	if (ehca_open_aqp1 =3D=3D 1) {
+	if (ehca_open_aqp1) {
 		shca->sport[0].port_state =3D IB_PORT_DOWN;
 		ret =3D ehca_create_aqp1(shca, 1);
 		if (ret) {
@@ -819,7 +819,7 @@ static int __devinit ehca_probe(struct platform_device =
*dev,
 	}
=20
 	/* create AQP1 for port 2 */
-	if ((ehca_open_aqp1 =3D=3D 1) && (shca->num_ports =3D=3D 2)) {
+	if ((ehca_open_aqp1) && (shca->num_ports =3D=3D 2)) {
 		shca->sport[1].port_state =3D IB_PORT_DOWN;
 		ret =3D ehca_create_aqp1(shca, 2);
 		if (ret) {
@@ -887,7 +887,7 @@ static int __devexit ehca_remove(struct platform_device=
 *dev)
=20
 	sysfs_remove_group(&dev->dev.kobj, &ehca_dev_attr_grp);
=20
-	if (ehca_open_aqp1 =3D=3D 1) {
+	if (ehca_open_aqp1) {
 		int i;
 		for (i =3D 0; i < shca->num_ports; i++) {
 			ret =3D ehca_destroy_aqp1(&shca->sport[i]);
@@ -1051,7 +1051,7 @@ static int __init ehca_module_init(void)
 		goto module_init4;
 	}
=20
-	if (ehca_poll_all_eqs !=3D 1) {
+	if (!ehca_poll_all_eqs) {
 		ehca_gen_err("WARNING!!!");
 		ehca_gen_err("It is possible to lose interrupts.");
 	} else {
@@ -1079,7 +1079,7 @@ module_init1:
=20
 static void __exit ehca_module_exit(void)
 {
-	if (ehca_poll_all_eqs =3D=3D 1)
+	if (ehca_poll_all_eqs)
 		del_timer_sync(&poll_eqs_timer);
=20
 	ibmebus_unregister_driver(&ehca_driver);
diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron=
_btns.c
index e2bdfd4..907e270 100644
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -1249,7 +1249,7 @@ static int __devinit wistron_probe(struct platform_de=
vice *dev)
 		if (wifi & 1)
 			wifi_enabled =3D wifi & 2;
 		else
-			have_wifi =3D 0;
+			have_wifi =3D false;
=20
 		if (have_wifi)
 			bios_set_state(WIFI, wifi_enabled);
diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appleto=
uch.c
index 0acbc7d..9ec4531 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -524,7 +524,7 @@ static void atp_complete_geyser_1_2(struct urb *urb)
 		/* Perform size detection, if not done already */
 		if (unlikely(!dev->size_detect_done)) {
 			atp_detect_size(dev);
-			dev->size_detect_done =3D 1;
+			dev->size_detect_done =3D true;
 			goto exit;
 		}
 	}
@@ -733,7 +733,7 @@ static int atp_open(struct input_dev *input)
 	if (usb_submit_urb(dev->urb, GFP_ATOMIC))
 		return -EIO;
=20
-	dev->open =3D 1;
+	dev->open =3D true;
 	return 0;
 }
=20
@@ -743,7 +743,7 @@ static void atp_close(struct input_dev *input)
=20
 	usb_kill_urb(dev->urb);
 	cancel_work_sync(&dev->work);
-	dev->open =3D 0;
+	dev->open =3D false;
 }
=20
 static int atp_handle_geyser(struct atp *dev)
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.=
c
index d2c0db1..615366f 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1290,7 +1290,7 @@ static int elantech_set_properties(struct elantech_da=
ta *etd)
 					       synaptics_send_cmd;
=20
 	/* Turn on packet checking by default */
-	etd->paritycheck =3D 1;
+	etd->paritycheck =3D true;
=20
 	/*
 	 * This firmware suffers from misreporting coordinates when
diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index 1c5d521..d162cdc 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -774,7 +774,7 @@ static int hgpk_reconnect(struct psmouse *psmouse)
 				PM_EVENT_ON)
 			return 0;
=20
-	priv->powered =3D 1;
+	priv->powered =3D true;
 	return hgpk_reset_device(psmouse, false);
 }
=20
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmou=
se-base.c
index e6c9931..66890b9 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -60,7 +60,7 @@ static unsigned int psmouse_rate =3D 100;
 module_param_named(rate, psmouse_rate, uint, 0644);
 MODULE_PARM_DESC(rate, "Report rate, in reports per second.");
=20
-static bool psmouse_smartscroll =3D 1;
+static bool psmouse_smartscroll =3D true;
 module_param_named(smartscroll, psmouse_smartscroll, bool, 0644);
 MODULE_PARM_DESC(smartscroll, "Logitech Smartscroll autorepeat, 1 =3D enab=
led (default), 0 =3D disabled.");
=20
diff --git a/drivers/input/mouse/synaptics_i2c.c b/drivers/input/mouse/syna=
ptics_i2c.c
index 1c58aaf..6789435 100644
--- a/drivers/input/mouse/synaptics_i2c.c
+++ b/drivers/input/mouse/synaptics_i2c.c
@@ -185,7 +185,7 @@
 #define NO_DATA_SLEEP_MSECS	(MSEC_PER_SEC / 4)
=20
 /* Control touchpad's No Deceleration option */
-static bool no_decel =3D 1;
+static bool no_decel =3D true;
 module_param(no_decel, bool, 0644);
 MODULE_PARM_DESC(no_decel, "No Deceleration. Default =3D 1 (on)");
=20
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_=
wac.c
index 88672ec..6e0c296 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -779,7 +779,7 @@ static int wacom_tpc_single_touch(struct wacom_wac *wac=
om, size_t len)
 		}
 	} else
 		/* force touch out when pen is in prox */
-		prox =3D 0;
+		prox =3D false;
=20
 	if (prox) {
 		input_report_abs(input, ABS_X, x);
diff --git a/drivers/input/touchscreen/auo-pixcir-ts.c b/drivers/input/touc=
hscreen/auo-pixcir-ts.c
index 94fb9fb..348f817 100644
--- a/drivers/input/touchscreen/auo-pixcir-ts.c
+++ b/drivers/input/touchscreen/auo-pixcir-ts.c
@@ -508,7 +508,7 @@ static int __devinit auo_pixcir_probe(struct i2c_client=
 *client,
 		pdata->init_hw(client);
=20
 	ts->client =3D client;
-	ts->touch_ind_mode =3D 0;
+	ts->touch_ind_mode =3D false;
 	init_waitqueue_head(&ts->wait);
=20
 	snprintf(ts->phys, sizeof(ts->phys),
diff --git a/drivers/isdn/hardware/avm/b1dma.c b/drivers/isdn/hardware/avm/=
b1dma.c
index a0ed668..e2eb250 100644
--- a/drivers/isdn/hardware/avm/b1dma.c
+++ b/drivers/isdn/hardware/avm/b1dma.c
@@ -40,7 +40,7 @@ MODULE_DESCRIPTION("CAPI4Linux: DMA support for active AV=
M cards");
 MODULE_AUTHOR("Carsten Paeth");
 MODULE_LICENSE("GPL");
=20
-static bool suppress_pollack =3D 0;
+static bool suppress_pollack =3D false;
 module_param(suppress_pollack, bool, 0);
=20
 /* ------------------------------------------------------------- */
diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index 023de78..4d9b072 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -30,7 +30,7 @@ static const char *boardname[] =3D { "DataCommute/BRI", "=
DataCommute/PRI", "TeleCo
 static unsigned int io[] =3D {0,0,0,0};
 static unsigned char irq[] =3D {0,0,0,0};
 static unsigned long ram[] =3D {0,0,0,0};
-static bool do_reset =3D 0;
+static bool do_reset =3D false;
=20
 module_param_array(io, int, NULL, 0);
 module_param_array(irq, int, NULL, 0);
diff --git a/drivers/macintosh/ams/ams-input.c b/drivers/macintosh/ams/ams-=
input.c
index b27e530..a3b8916 100644
--- a/drivers/macintosh/ams/ams-input.c
+++ b/drivers/macintosh/ams/ams-input.c
@@ -91,7 +91,7 @@ static int ams_input_enable(void)
 		return error;
 	}
=20
-	joystick =3D 1;
+	joystick =3D true;
=20
 	return 0;
 }
@@ -104,7 +104,7 @@ static void ams_input_disable(void)
 		ams_info.idev =3D NULL;
 	}
=20
-	joystick =3D 0;
+	joystick =3D false;
 }
=20
 static ssize_t ams_input_show_joystick(struct device *dev,
diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb=
/af9005.c
index af176b6..3f4361e 100644
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -30,7 +30,7 @@ MODULE_PARM_DESC(debug,
 		 "set debugging level (1=3Dinfo,xfer=3D2,rc=3D4,reg=3D8,i2c=3D16,fw=3D32=
 (or-able))."
 		 DVB_USB_DEBUG_STATUS);
 /* enable obnoxious led */
-bool dvb_usb_af9005_led =3D 1;
+bool dvb_usb_af9005_led =3D true;
 module_param_named(led, dvb_usb_af9005_led, bool, 0644);
 MODULE_PARM_DESC(led, "enable led (default: 1).");
=20
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/front=
ends/af9013.c
index 6bcbcf5..8add4bd 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -671,7 +671,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
=20
 	switch (c->transmission_mode) {
 	case TRANSMISSION_MODE_AUTO:
-		auto_mode =3D 1;
+		auto_mode =3D true;
 		break;
 	case TRANSMISSION_MODE_2K:
 		break;
@@ -680,12 +680,12 @@ static int af9013_set_frontend(struct dvb_frontend *f=
e)
 		break;
 	default:
 		dbg("%s: invalid transmission_mode", __func__);
-		auto_mode =3D 1;
+		auto_mode =3D true;
 	}
=20
 	switch (c->guard_interval) {
 	case GUARD_INTERVAL_AUTO:
-		auto_mode =3D 1;
+		auto_mode =3D true;
 		break;
 	case GUARD_INTERVAL_1_32:
 		break;
@@ -700,12 +700,12 @@ static int af9013_set_frontend(struct dvb_frontend *f=
e)
 		break;
 	default:
 		dbg("%s: invalid guard_interval", __func__);
-		auto_mode =3D 1;
+		auto_mode =3D true;
 	}
=20
 	switch (c->hierarchy) {
 	case HIERARCHY_AUTO:
-		auto_mode =3D 1;
+		auto_mode =3D true;
 		break;
 	case HIERARCHY_NONE:
 		break;
@@ -720,12 +720,12 @@ static int af9013_set_frontend(struct dvb_frontend *f=
e)
 		break;
 	default:
 		dbg("%s: invalid hierarchy", __func__);
-		auto_mode =3D 1;
+		auto_mode =3D true;
 	};
=20
 	switch (c->modulation) {
 	case QAM_AUTO:
-		auto_mode =3D 1;
+		auto_mode =3D true;
 		break;
 	case QPSK:
 		break;
@@ -737,7 +737,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		break;
 	default:
 		dbg("%s: invalid modulation", __func__);
-		auto_mode =3D 1;
+		auto_mode =3D true;
 	}
=20
 	/* Use HP. How and which case we can switch to LP? */
@@ -745,7 +745,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
=20
 	switch (c->code_rate_HP) {
 	case FEC_AUTO:
-		auto_mode =3D 1;
+		auto_mode =3D true;
 		break;
 	case FEC_1_2:
 		break;
@@ -763,12 +763,12 @@ static int af9013_set_frontend(struct dvb_frontend *f=
e)
 		break;
 	default:
 		dbg("%s: invalid code_rate_HP", __func__);
-		auto_mode =3D 1;
+		auto_mode =3D true;
 	}
=20
 	switch (c->code_rate_LP) {
 	case FEC_AUTO:
-		auto_mode =3D 1;
+		auto_mode =3D true;
 		break;
 	case FEC_1_2:
 		break;
@@ -788,7 +788,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		break;
 	default:
 		dbg("%s: invalid code_rate_LP", __func__);
-		auto_mode =3D 1;
+		auto_mode =3D true;
 	}
=20
 	switch (c->bandwidth_hz) {
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/fr=
ontends/drxk_hard.c
index 6980ed7..9e00b8f 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1111,7 +1111,7 @@ static int HI_Command(struct drxk_state *state, u16 c=
md, u16 *pResult)
 		    ((state->m_HICfgCtrl) &
 		     SIO_HI_RA_RAM_PAR_5_CFG_SLEEP__M) =3D=3D
 		    SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ);
-	if (powerdown_cmd =3D=3D false) {
+	if (!powerdown_cmd) {
 		/* Wait until command rdy */
 		u32 retryCount =3D 0;
 		u16 waitCmd;
@@ -1204,7 +1204,7 @@ static int MPEGTSConfigurePins(struct drxk_state *sta=
te, bool mpegEnable)
 	if (status < 0)
 		goto error;
=20
-	if (mpegEnable =3D=3D false) {
+	if (!mpegEnable) {
 		/*  Set MPEG TS pads to inputmode */
 		status =3D write16(state, SIO_PDR_MSTRT_CFG__A, 0x0000);
 		if (status < 0)
@@ -1260,7 +1260,7 @@ static int MPEGTSConfigurePins(struct drxk_state *sta=
te, bool mpegEnable)
 		status =3D write16(state, SIO_PDR_MVAL_CFG__A, 0x0000);	/* Disable */
 		if (status < 0)
 			goto error;
-		if (state->m_enableParallel =3D=3D true) {
+		if (state->m_enableParallel) {
 			/* paralel -> enable MD1 to MD7 */
 			status =3D write16(state, SIO_PDR_MD1_CFG__A, sioPdrMdxCfg);
 			if (status < 0)
@@ -1449,7 +1449,7 @@ static int DVBTEnableOFDMTokenRing(struct drxk_state =
*state, bool enable)
=20
 	dprintk(1, "\n");
=20
-	if (enable =3D=3D false) {
+	if (!enable) {
 		desiredCtrl =3D SIO_OFDM_SH_OFDM_RING_ENABLE_OFF;
 		desiredStatus =3D SIO_OFDM_SH_OFDM_RING_STATUS_DOWN;
 	}
@@ -2059,7 +2059,7 @@ static int MPEGTSDtoSetup(struct drxk_state *state,
 		goto error;
 	fecOcRegMode &=3D (~FEC_OC_MODE_PARITY__M);
 	fecOcRegIprMode &=3D (~FEC_OC_IPR_MODE_MVAL_DIS_PAR__M);
-	if (state->m_insertRSByte =3D=3D true) {
+	if (state->m_insertRSByte) {
 		/* enable parity symbol forward */
 		fecOcRegMode |=3D FEC_OC_MODE_PARITY__M;
 		/* MVAL disable during parity bytes */
@@ -2070,7 +2070,7 @@ static int MPEGTSDtoSetup(struct drxk_state *state,
=20
 	/* Check serial or parrallel output */
 	fecOcRegIprMode &=3D (~(FEC_OC_IPR_MODE_SERIAL__M));
-	if (state->m_enableParallel =3D=3D false) {
+	if (!state->m_enableParallel) {
 		/* MPEG data output is serial -> set ipr_mode[0] */
 		fecOcRegIprMode |=3D FEC_OC_IPR_MODE_SERIAL__M;
 	}
@@ -2182,19 +2182,19 @@ static int MPEGTSConfigurePolarity(struct drxk_stat=
e *state)
=20
 	/* Control selective inversion of output bits */
 	fecOcRegIprInvert &=3D (~(InvertDataMask));
-	if (state->m_invertDATA =3D=3D true)
+	if (state->m_invertDATA)
 		fecOcRegIprInvert |=3D InvertDataMask;
 	fecOcRegIprInvert &=3D (~(FEC_OC_IPR_INVERT_MERR__M));
-	if (state->m_invertERR =3D=3D true)
+	if (state->m_invertERR)
 		fecOcRegIprInvert |=3D FEC_OC_IPR_INVERT_MERR__M;
 	fecOcRegIprInvert &=3D (~(FEC_OC_IPR_INVERT_MSTRT__M));
-	if (state->m_invertSTR =3D=3D true)
+	if (state->m_invertSTR)
 		fecOcRegIprInvert |=3D FEC_OC_IPR_INVERT_MSTRT__M;
 	fecOcRegIprInvert &=3D (~(FEC_OC_IPR_INVERT_MVAL__M));
-	if (state->m_invertVAL =3D=3D true)
+	if (state->m_invertVAL)
 		fecOcRegIprInvert |=3D FEC_OC_IPR_INVERT_MVAL__M;
 	fecOcRegIprInvert &=3D (~(FEC_OC_IPR_INVERT_MCLK__M));
-	if (state->m_invertCLK =3D=3D true)
+	if (state->m_invertCLK)
 		fecOcRegIprInvert |=3D FEC_OC_IPR_INVERT_MCLK__M;
=20
 	return write16(state, FEC_OC_IPR_INVERT__A, fecOcRegIprInvert);
@@ -3405,7 +3405,7 @@ static int DVBTCtrlSetIncEnable(struct drxk_state *st=
ate, bool *enabled)
 	int status;
=20
 	dprintk(1, "\n");
-	if (*enabled =3D=3D true)
+	if (*enabled)
 		status =3D write16(state, IQM_CF_BYPASSDET__A, 0);
 	else
 		status =3D write16(state, IQM_CF_BYPASSDET__A, 1);
@@ -3421,7 +3421,7 @@ static int DVBTCtrlSetFrEnable(struct drxk_state *sta=
te, bool *enabled)
 	int status;
=20
 	dprintk(1, "\n");
-	if (*enabled =3D=3D true) {
+	if (*enabled) {
 		/* write mask to 1 */
 		status =3D write16(state, OFDM_SC_RA_RAM_FR_THRES_8K__A,
 				   DEFAULT_FR_THRES_8K);
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio=
-gemtek.c
index 36ce061..d31d47e 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -49,9 +49,9 @@ MODULE_VERSION("0.0.4");
 static int io		=3D CONFIG_RADIO_GEMTEK_PORT;
 static bool probe	=3D CONFIG_RADIO_GEMTEK_PROBE;
 static bool hardmute;
-static bool shutdown	=3D 1;
-static bool keepmuted	=3D 1;
-static bool initmute	=3D 1;
+static bool shutdown	=3D true;
+static bool keepmuted	=3D true;
+static bool initmute	=3D true;
 static int radio_nr	=3D -1;
=20
 module_param(io, int, 0444);
@@ -599,7 +599,7 @@ static void __exit gemtek_exit(void)
 	struct v4l2_device *v4l2_dev =3D &gt->v4l2_dev;
=20
 	if (shutdown) {
-		hardmute =3D 1;	/* Turn off PLL */
+		hardmute =3D true;	/* Turn off PLL */
 		gemtek_mute(gt);
 	} else {
 		v4l2_info(v4l2_dev, "Module unloaded but card not muted!\n");
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radi=
o-sf16fmi.c
index 22c5743..af242a9 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -328,7 +328,7 @@ static int __init fmi_init(void)
 				io =3D isapnp_fmi_probe();
 				if (io < 0)
 					continue;
-				pnp_attached =3D 1;
+				pnp_attached =3D true;
 			}
 			if (!request_region(io, 2, "radio-sf16fmi")) {
 				if (pnp_attached)
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/med=
ia/radio/si470x/radio-si470x-common.c
index 0e740c9..f22b146 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -165,7 +165,7 @@ static int si470x_set_chan(struct si470x_device *radio,=
 unsigned short chan)
 {
 	int retval;
 	unsigned long timeout;
-	bool timed_out =3D 0;
+	bool timed_out =3D false;
=20
 	/* start tuning */
 	radio->registers[CHANNEL] &=3D ~CHANNEL_CHAN;
@@ -306,7 +306,7 @@ static int si470x_set_seek(struct si470x_device *radio,
 {
 	int retval =3D 0;
 	unsigned long timeout;
-	bool timed_out =3D 0;
+	bool timed_out =3D false;
=20
 	/* start seeking */
 	radio->registers[POWERCFG] |=3D POWERCFG_SEEK;
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 860c112..91659fa 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -965,7 +965,7 @@ static int ene_transmit(struct rc_dev *rdev, unsigned *=
buf, unsigned n)
 	dev->tx_reg =3D 0;
 	dev->tx_done =3D 0;
 	dev->tx_sample =3D 0;
-	dev->tx_sample_pulse =3D 0;
+	dev->tx_sample_pulse =3D false;
=20
 	dbg("TX: %d samples", dev->tx_len);
=20
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 21105bf..2f50382 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -156,7 +156,7 @@
=20
 /* module parameters */
 #ifdef CONFIG_USB_DEBUG
-static bool debug =3D 1;
+static bool debug =3D true;
 #else
 static bool debug;
 #endif
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index d6f4bfe..9bb8d9d 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -43,7 +43,7 @@
 #define DRIVER_DESC	"Streamzap Remote Control driver"
=20
 #ifdef CONFIG_USB_DEBUG
-static bool debug =3D 1;
+static bool debug =3D true;
 #else
 static bool debug;
 #endif
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/c=
x18/cx18-driver.c
index 349bd9c..b8f3454 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -75,7 +75,7 @@ static int radio[CX18_MAX_CARDS] =3D { -1, -1, -1, -1, -1=
, -1, -1, -1,
 				     -1, -1, -1, -1, -1, -1, -1, -1 };
 static unsigned cardtype_c =3D 1;
 static unsigned tuner_c =3D 1;
-static bool radio_c =3D 1;
+static bool radio_c =3D true;
 static char pal[] =3D "--";
 static char secam[] =3D "--";
 static char ntsc[] =3D "-";
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/i=
vtv/ivtv-driver.c
index 3949b7d..533b224 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -99,7 +99,7 @@ static int i2c_clock_period[IVTV_MAX_CARDS] =3D { -1, -1,=
 -1, -1, -1, -1, -1, -1,
=20
 static unsigned int cardtype_c =3D 1;
 static unsigned int tuner_c =3D 1;
-static bool radio_c =3D 1;
+static bool radio_c =3D true;
 static unsigned int i2c_clock_period_c =3D 1;
 static char pal[] =3D "---";
 static char secam[] =3D "--";
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/v=
ideo/marvell-ccic/mcam-core.c
index 37d20e7..7c3f186 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -73,7 +73,7 @@ MODULE_PARM_DESC(dma_buf_size,
 		"parameters require larger buffers, an attempt to reallocate "
 		"will be made.");
 #else /* MCAM_MODE_VMALLOC */
-static const bool alloc_bufs_at_read =3D 0;
+static const bool alloc_bufs_at_read =3D false;
 static const int n_dma_bufs =3D 3;  /* Used by S/G_PARM */
 #endif /* MCAM_MODE_VMALLOC */
=20
diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/oma=
p/omap_vout.c
index 1fb7d5b..a9eb2f5 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -977,7 +977,7 @@ static int omap_vout_release(struct file *file)
 		mask =3D DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
 			DISPC_IRQ_EVSYNC_ODD | DISPC_IRQ_VSYNC2;
 		omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
-		vout->streaming =3D 0;
+		vout->streaming =3D false;
=20
 		videobuf_streamoff(q);
 		videobuf_queue_cancel(q);
@@ -1648,7 +1648,7 @@ static int vidioc_streamon(struct file *file, void *f=
h, enum v4l2_buf_type i)
 	vout->field_id =3D 0;
=20
 	/* set flag here. Next QBUF will start DMA */
-	vout->streaming =3D 1;
+	vout->streaming =3D true;
=20
 	vout->first_int =3D 1;
=20
@@ -1718,7 +1718,7 @@ static int vidioc_streamoff(struct file *file, void *=
fh, enum v4l2_buf_type i)
 	if (!vout->streaming)
 		return -EINVAL;
=20
-	vout->streaming =3D 0;
+	vout->streaming =3D false;
 	mask =3D DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD
 		| DISPC_IRQ_VSYNC2;
=20
@@ -1927,7 +1927,7 @@ static int __init omap_vout_setup_video_data(struct o=
map_vout_device *vout)
 	control[0].id =3D V4L2_CID_ROTATE;
 	control[0].value =3D 0;
 	vout->rotation =3D 0;
-	vout->mirror =3D 0;
+	vout->mirror =3D false;
 	vout->control[2].id =3D V4L2_CID_HFLIP;
 	vout->control[2].value =3D 0;
 	if (vout->vid_info.rotation_type =3D=3D VOUT_ROT_VRFB)
diff --git a/drivers/media/video/omap/omap_vout_vrfb.c b/drivers/media/vide=
o/omap/omap_vout_vrfb.c
index 4be26ab..516405d 100644
--- a/drivers/media/video/omap/omap_vout_vrfb.c
+++ b/drivers/media/video/omap/omap_vout_vrfb.c
@@ -146,7 +146,7 @@ int omap_vout_setup_vrfb_bufs(struct platform_device *p=
dev, int vid_num,
 			ret =3D  -ENOMEM;
 			goto release_vrfb_ctx;
 		}
-		vout->vrfb_static_allocation =3D 1;
+		vout->vrfb_static_allocation =3D true;
 	}
 	return 0;
=20
@@ -333,7 +333,7 @@ void omap_vout_calculate_vrfb_offset(struct omap_vout_d=
evice *vout)
 		offset =3D vout->vrfb_context[0].yoffset *
 			vout->vrfb_context[0].bytespp;
 		temp_ps =3D ps / vr_ps;
-		if (mirroring =3D=3D 0) {
+		if (!mirroring) {
 			*cropped_offset =3D offset + line_length *
 				temp_ps * cleft + crop->top * temp_ps;
 		} else {
@@ -347,7 +347,7 @@ void omap_vout_calculate_vrfb_offset(struct omap_vout_d=
evice *vout)
 			vout->vrfb_context[0].bytespp) +
 			(vout->vrfb_context[0].xoffset *
 			vout->vrfb_context[0].bytespp));
-		if (mirroring =3D=3D 0) {
+		if (!mirroring) {
 			*cropped_offset =3D offset + (line_length * ps * ctop) +
 				(cleft / vr_ps) * ps;
=20
@@ -361,7 +361,7 @@ void omap_vout_calculate_vrfb_offset(struct omap_vout_d=
evice *vout)
 		offset =3D MAX_PIXELS_PER_LINE * vout->vrfb_context[0].xoffset *
 			vout->vrfb_context[0].bytespp;
 		temp_ps =3D ps / vr_ps;
-		if (mirroring =3D=3D 0) {
+		if (!mirroring) {
 			*cropped_offset =3D offset + line_length *
 			    temp_ps * crop->left + ctop * ps;
 		} else {
@@ -372,7 +372,7 @@ void omap_vout_calculate_vrfb_offset(struct omap_vout_d=
evice *vout)
 		}
 		break;
 	case dss_rotation_0_degree:
-		if (mirroring =3D=3D 0) {
+		if (!mirroring) {
 			*cropped_offset =3D (line_length * ps) *
 				crop->top + (crop->left / vr_ps) * ps;
 		} else {
diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index d9a9f71..2a18b1c 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -564,13 +564,13 @@ static int ov9740_set_res(struct i2c_client *client, =
u32 width, u32 height)
 	u32 y_start;
 	u32 x_end;
 	u32 y_end;
-	bool scaling =3D 0;
+	bool scaling =3D false;
 	u32 scale_input_x;
 	u32 scale_input_y;
 	int ret;
=20
 	if ((width !=3D OV9740_MAX_WIDTH) || (height !=3D OV9740_MAX_HEIGHT))
-		scaling =3D 1;
+		scaling =3D true;
=20
 	/*
 	 * Try to use as much of the sensor area as possible when supporting
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/vi=
deo/s5p-fimc/fimc-mdevice.c
index 8ea4ee1..d044d1e 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -623,7 +623,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 			camclk->frequency =3D pdata->clk_frequency;
 			ret =3D clk_enable(camclk->clock);
 		}
-		s_info->clk_on =3D 1;
+		s_info->clk_on =3D true;
 		dbg("Enabled camclk %d: f: %lu", pdata->clk_id,
 		    clk_get_rate(camclk->clock));
=20
@@ -635,7 +635,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
=20
 	if (--camclk->use_count =3D=3D 0) {
 		clk_disable(camclk->clock);
-		s_info->clk_on =3D 0;
+		s_info->clk_on =3D false;
 		dbg("Disabled camclk %d", pdata->clk_id);
 	}
 	return ret;
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-web=
cam.c
index d427f84..8cc5c43 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -38,11 +38,11 @@
 #include "stk-webcam.h"
=20
=20
-static bool hflip =3D 1;
+static bool hflip =3D true;
 module_param(hflip, bool, 0444);
 MODULE_PARM_DESC(hflip, "Horizontal image flip (mirror). Defaults to 1");
=20
-static bool vflip =3D 1;
+static bool vflip =3D true;
 module_param(vflip, bool, 0444);
 MODULE_PARM_DESC(vflip, "Vertical image flip. Defaults to 1");
=20
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-c=
ore.c
index 4059ea1..024913d 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -598,7 +598,7 @@ static int tuner_probe(struct i2c_client *client,
 	t->name =3D "(tuner unset)";
 	t->type =3D UNSET;
 	t->audmode =3D V4L2_TUNER_MODE_STEREO;
-	t->standby =3D 1;
+	t->standby =3D true;
 	t->radio_freq =3D 87.5 * 16000;	/* Initial freq range */
 	t->tv_freq =3D 400 * 16; /* Sets freq to VHF High - needed for some PLL's=
 to properly start */
=20
diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-cam=
era.c
index 20f7237..1c26755 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -1334,7 +1334,7 @@ static __devinit bool viacam_serial_is_enabled(void)
 			VIACAM_SERIAL_CREG, &cbyte);
 	if ((cbyte & VIACAM_SERIAL_BIT) =3D=3D 0)
 		return false; /* Not enabled */
-	if (override_serial =3D=3D 0) {
+	if (!override_serial) {
 		printk(KERN_NOTICE "Via camera: serial port is enabled, " \
 				"refusing to load.\n");
 		printk(KERN_NOTICE "Specify override_serial=3D1 to force " \
diff --git a/drivers/media/video/zoran/zoran_device.c b/drivers/media/video=
/zoran/zoran_device.c
index e86173b..9f63376 100644
--- a/drivers/media/video/zoran/zoran_device.c
+++ b/drivers/media/video/zoran/zoran_device.c
@@ -684,7 +684,7 @@ set_videobus_dir (struct zoran *zr,
 	switch (zr->card.type) {
 	case LML33:
 	case LML33R10:
-		if (lml33dpath =3D=3D 0)
+		if (!lml33dpath)
 			GPIO(zr, 5, val);
 		else
 			GPIO(zr, 5, 1);
diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 29b2172..2366620 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -23,7 +23,7 @@
 #include <linux/swab.h>
 #include "r592.h"
=20
-static bool r592_enable_dma =3D 1;
+static bool r592_enable_dma =3D true;
 static int debug;
=20
 static const char *tpc_names[] =3D {
diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index e2a52e5..f01dede 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -856,9 +856,9 @@ static ssize_t apds990x_prox_reporting_mode_store(struc=
t device *dev,
 	struct apds990x_chip *chip =3D  dev_get_drvdata(dev);
=20
 	if (sysfs_streq(buf, reporting_modes[0]))
-		chip->prox_continuous_mode =3D 0;
+		chip->prox_continuous_mode =3D false;
 	else if (sysfs_streq(buf, reporting_modes[1]))
-		chip->prox_continuous_mode =3D 1;
+		chip->prox_continuous_mode =3D true;
 	else
 		return -EINVAL;
 	return len;
diff --git a/drivers/misc/iwmc3200top/main.c b/drivers/misc/iwmc3200top/mai=
n.c
index 701eb60..33f43c9 100644
--- a/drivers/misc/iwmc3200top/main.c
+++ b/drivers/misc/iwmc3200top/main.c
@@ -380,16 +380,16 @@ static bool dump;
 module_param(dump, bool, 0604);
 MODULE_PARM_DESC(dump, "dump_hex_content");
=20
-static bool jump =3D 1;
+static bool jump =3D true;
 module_param(jump, bool, 0604);
=20
-static bool direct =3D 1;
+static bool direct =3D true;
 module_param(direct, bool, 0604);
=20
-static bool checksum =3D 1;
+static bool checksum =3D true;
 module_param(checksum, bool, 0604);
=20
-static bool fw_download =3D 1;
+static bool fw_download =3D true;
 module_param(fw_download, bool, 0604);
=20
 static int block_size =3D IWMC_SDIO_BLK_SIZE;
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index f545a3e..760892c 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -48,7 +48,7 @@ static struct workqueue_struct *workqueue;
  * performance cost, and for other reasons may not always be desired.
  * So we allow it it to be disabled.
  */
-bool use_spi_crc =3D 1;
+bool use_spi_crc =3D true;
 module_param(use_spi_crc, bool, 0);
=20
 /*
@@ -60,7 +60,7 @@ module_param(use_spi_crc, bool, 0);
 #ifdef CONFIG_MMC_UNSAFE_RESUME
 bool mmc_assume_removable;
 #else
-bool mmc_assume_removable =3D 1;
+bool mmc_assume_removable =3D true;
 #endif
 EXPORT_SYMBOL(mmc_assume_removable);
 module_param_named(removable, mmc_assume_removable, bool, 0644);
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index fcfe1eb..0e62f71 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1993,34 +1993,34 @@ static void __init atmci_get_cap(struct atmel_mci *=
host)
 	dev_info(&host->pdev->dev,
 			"version: 0x%x\n", version);
=20
-	host->caps.has_dma =3D 0;
-	host->caps.has_pdc =3D 0;
-	host->caps.has_cfg_reg =3D 0;
-	host->caps.has_cstor_reg =3D 0;
-	host->caps.has_highspeed =3D 0;
-	host->caps.has_rwproof =3D 0;
+	host->caps.has_dma =3D false;
+	host->caps.has_pdc =3D false;
+	host->caps.has_cfg_reg =3D false;
+	host->caps.has_cstor_reg =3D false;
+	host->caps.has_highspeed =3D false;
+	host->caps.has_rwproof =3D false;
=20
 	/* keep only major version number */
 	switch (version & 0xf00) {
 	case 0x100:
 	case 0x200:
-		host->caps.has_pdc =3D 1;
-		host->caps.has_rwproof =3D 1;
+		host->caps.has_pdc =3D true;
+		host->caps.has_rwproof =3D true;
 		break;
 	case 0x300:
 	case 0x400:
 	case 0x500:
 #ifdef CONFIG_AT_HDMAC
-		host->caps.has_dma =3D 1;
+		host->caps.has_dma =3D true;
 #else
-		host->caps.has_dma =3D 0;
+		host->caps.has_dma =3D false;
 		dev_info(&host->pdev->dev,
 			"has dma capability but dma engine is not selected, then use pio\n");
 #endif
-		host->caps.has_cfg_reg =3D 1;
-		host->caps.has_cstor_reg =3D 1;
-		host->caps.has_highspeed =3D 1;
-		host->caps.has_rwproof =3D 1;
+		host->caps.has_cfg_reg =3D true;
+		host->caps.has_cstor_reg =3D true;
+		host->caps.has_highspeed =3D true;
+		host->caps.has_rwproof =3D true;
 		break;
 	default:
 		dev_warn(&host->pdev->dev,
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.=
c
index 64a8325..3cf3fcd 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -557,7 +557,7 @@ static int mmc_davinci_start_dma_transfer(struct mmc_da=
vinci_host *host,
 		}
 	}
=20
-	host->do_dma =3D 1;
+	host->do_dma =3D true;
 	mmc_davinci_send_dma_request(host, data);
=20
 	return 0;
@@ -725,7 +725,7 @@ static void mmc_davinci_request(struct mmc_host *mmc, s=
truct mmc_request *req)
 		return;
 	}
=20
-	host->do_dma =3D 0;
+	host->do_dma =3D false;
 	mmc_davinci_prepare_data(host, req);
 	mmc_davinci_start_command(host, req->cmd);
 }
@@ -1020,7 +1020,7 @@ static irqreturn_t mmc_davinci_irq(int irq, void *dev=
_id)
 	if (qstatus & MMCST0_DATDNE) {
 		/* All blocks sent/received, and CRC checks passed */
 		if (data !=3D NULL) {
-			if ((host->do_dma =3D=3D 0) && (host->bytes_left > 0)) {
+			if ((!host->do_dma) && (host->bytes_left > 0)) {
 				/* if datasize < rw_threshold
 				 * no RX ints are generated
 				 */
@@ -1284,7 +1284,7 @@ static int __init davinci_mmcsd_probe(struct platform=
_device *pdev)
 	host->sdio_irq =3D platform_get_irq(pdev, 1);
=20
 	if (host->use_dma && davinci_acquire_dma_channels(host) !=3D 0)
-		host->use_dma =3D 0;
+		host->use_dma =3D false;
=20
 	/* REVISIT:  someday, support IRQ-driven card detection.  */
 	mmc->caps |=3D MMC_CAP_NEEDS_POLL;
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index cb2dc0e..4cd55f2 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -175,7 +175,7 @@ static void pxamci_setup_data(struct pxamci_host *host,=
 struct mmc_data *data)
 	unsigned int nob =3D data->blocks;
 	unsigned long long clks;
 	unsigned int timeout;
-	bool dalgn =3D 0;
+	bool dalgn =3D false;
 	u32 dcmd;
 	int i;
=20
@@ -216,7 +216,7 @@ static void pxamci_setup_data(struct pxamci_host *host,=
 struct mmc_data *data)
 			host->sg_cpu[i].dcmd |=3D DCMD_ENDIRQEN;
 		/* Not aligned to 8-byte boundary? */
 		if (sg_dma_address(&data->sg[i]) & 0x7)
-			dalgn =3D 1;
+			dalgn =3D true;
 		if (data->flags & MMC_DATA_READ) {
 			host->sg_cpu[i].dsadr =3D host->res->start + MMC_RXFIFO;
 			host->sg_cpu[i].dtadr =3D sg_dma_address(&data->sg[i]);
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 43d9628..a82c910 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -22,8 +22,8 @@
 #define DRIVER_NAME "tifm_sd"
 #define DRIVER_VERSION "0.8"
=20
-static bool no_dma =3D 0;
-static bool fixed_timeout =3D 0;
+static bool no_dma =3D false;
+static bool fixed_timeout =3D false;
 module_param(no_dma, bool, 0644);
 module_param(fixed_timeout, bool, 0644);
=20
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 3135a1a..4d25868 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -512,7 +512,7 @@ static void new_system_port_status(struct vub300_mmc_ho=
st *vub300)
 		(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	if (new_card_present && !old_card_present) {
 		dev_info(&vub300->udev->dev, "card just inserted\n");
-		vub300->card_present =3D 1;
+		vub300->card_present =3D true;
 		vub300->bus_width =3D 0;
 		if (disable_offload_processing)
 			strncpy(vub300->vub_name, "EMPTY Processing Disabled",
@@ -522,7 +522,7 @@ static void new_system_port_status(struct vub300_mmc_ho=
st *vub300)
 		mmc_detect_change(vub300->mmc, 1);
 	} else if (!new_card_present && old_card_present) {
 		dev_info(&vub300->udev->dev, "card just ejected\n");
-		vub300->card_present =3D 0;
+		vub300->card_present =3D false;
 		mmc_detect_change(vub300->mmc, 0);
 	} else {
 		/* no change */
@@ -597,7 +597,7 @@ static void __vub300_irqpoll_response(struct vub300_mmc=
_host *vub300)
 			mmc_signal_sdio_irq(vub300->mmc);
 		else
 			vub300->irqs_queued +=3D 1;
-		vub300->irq_disabled =3D 1;
+		vub300->irq_disabled =3D true;
 		mutex_unlock(&vub300->irq_mutex);
 		break;
 	case RESPONSE_ERROR:
@@ -624,7 +624,7 @@ static void __vub300_irqpoll_response(struct vub300_mmc=
_host *vub300)
 			mmc_signal_sdio_irq(vub300->mmc);
 		else
 			vub300->irqs_queued +=3D 1;
-		vub300->irq_disabled =3D 1;
+		vub300->irq_disabled =3D true;
 		mutex_unlock(&vub300->irq_mutex);
 		break;
 	}
@@ -644,7 +644,7 @@ static void __vub300_irqpoll_response(struct vub300_mmc=
_host *vub300)
 			vub300->irqs_queued +=3D 1;
 		else
 			vub300->irqs_queued +=3D 1;
-		vub300->irq_disabled =3D 0;
+		vub300->irq_disabled =3D false;
 		mutex_unlock(&vub300->irq_mutex);
 		break;
 	}
@@ -949,7 +949,7 @@ static void send_command(struct vub300_mmc_host *vub300=
)
 			complete(&vub300->command_complete);
 			return;
 		}
-		vub300->app_spec =3D 0;
+		vub300->app_spec =3D false;
 	} else {
 		switch (cmd->opcode) {
 		case 0:
@@ -1053,7 +1053,7 @@ static void send_command(struct vub300_mmc_host *vub3=
00)
 		case 55:
 			response_type =3D SDRT_1;
 			vub300->resp_len =3D 6;
-			vub300->app_spec =3D 1;
+			vub300->app_spec =3D true;
 			break;
 		case 56:
 			response_type =3D SDRT_1;
@@ -1679,7 +1679,7 @@ static void __vub300_command_response(struct vub300_m=
mc_host *vub300,
 		} else {
 			vub300->irqs_queued +=3D 1;
 		}
-		vub300->irq_disabled =3D 1;
+		vub300->irq_disabled =3D true;
 		mutex_unlock(&vub300->irq_mutex);
 		vub300->resp.common.header_size =3D
 			sizeof(struct sd_register_header);
@@ -1704,7 +1704,7 @@ static void __vub300_command_response(struct vub300_m=
mc_host *vub300,
 		} else {
 			vub300->irqs_queued +=3D 1;
 		}
-		vub300->irq_disabled =3D 0;
+		vub300->irq_disabled =3D false;
 		mutex_unlock(&vub300->irq_mutex);
 		vub300->resp.common.header_size =3D
 			sizeof(struct sd_register_header);
@@ -2018,7 +2018,7 @@ static void vub300_mmc_set_ios(struct mmc_host *mmc, =
struct mmc_ios *ios)
 	kref_get(&vub300->kref);
 	mutex_lock(&vub300->cmd_mutex);
 	if ((ios->power_mode =3D=3D MMC_POWER_OFF) && vub300->card_powered) {
-		vub300->card_powered =3D 0;
+		vub300->card_powered =3D false;
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_SD_POWER,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
@@ -2031,7 +2031,7 @@ static void vub300_mmc_set_ios(struct mmc_host *mmc, =
struct mmc_ios *ios)
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x0001, 0x0000, NULL, 0, HZ);
 		msleep(600);
-		vub300->card_powered =3D 1;
+		vub300->card_powered =3D true;
 	} else if (ios->power_mode =3D=3D MMC_POWER_ON) {
 		u8 *buf =3D kmalloc(8, GFP_KERNEL);
 		if (buf) {
@@ -2063,18 +2063,18 @@ static void vub300_enable_sdio_irq(struct mmc_host =
*mmc, int enable)
 			vub300->irqs_queued -=3D 1;
 			mmc_signal_sdio_irq(vub300->mmc);
 		} else if (vub300->irq_disabled) {
-			vub300->irq_disabled =3D 0;
-			vub300->irq_enabled =3D 1;
+			vub300->irq_disabled =3D false;
+			vub300->irq_enabled =3D true;
 			vub300_queue_poll_work(vub300, 0);
 		} else if (vub300->irq_enabled) {
 			/* this should not happen, so we will just ignore it */
 		} else {
-			vub300->irq_enabled =3D 1;
+			vub300->irq_enabled =3D true;
 			vub300_queue_poll_work(vub300, 0);
 		}
 		mutex_unlock(&vub300->irq_mutex);
 	} else {
-		vub300->irq_enabled =3D 0;
+		vub300->irq_enabled =3D false;
 	}
 	kref_put(&vub300->kref, vub300_delete);
 }
@@ -2186,11 +2186,11 @@ static int vub300_probe(struct usb_interface *inter=
face,
 	mmc->ops =3D &vub300_mmc_ops;
 	vub300 =3D mmc_priv(mmc);
 	vub300->mmc =3D mmc;
-	vub300->card_powered =3D 0;
+	vub300->card_powered =3D false;
 	vub300->bus_width =3D 0;
 	vub300->cmnd.head.block_size[0] =3D 0x00;
 	vub300->cmnd.head.block_size[1] =3D 0x00;
-	vub300->app_spec =3D 0;
+	vub300->app_spec =3D false;
 	mutex_init(&vub300->cmd_mutex);
 	mutex_init(&vub300->irq_mutex);
 	vub300->command_out_urb =3D command_out_urb;
@@ -2204,8 +2204,8 @@ static int vub300_probe(struct usb_interface *interfa=
ce,
 	}
=20
 	vub300->total_offload_count =3D 0;
-	vub300->irq_enabled =3D 0;
-	vub300->irq_disabled =3D 0;
+	vub300->irq_enabled =3D false;
+	vub300->irq_disabled =3D false;
 	vub300->irqs_queued =3D 0;
=20
 	for (i =3D 0; i < ARRAY_SIZE(vub300->sdio_register); i++)
@@ -2230,7 +2230,7 @@ static int vub300_probe(struct usb_interface *interfa=
ce,
 	 * use the second pair of bulk-in and bulk-out
 	 *     endpoints for Data In/Out
 	 */
-	vub300->large_usb_packets =3D 0;
+	vub300->large_usb_packets =3D false;
 	iface_desc =3D interface->cur_altsetting;
 	for (i =3D 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		struct usb_endpoint_descriptor *endpoint =3D
@@ -2241,7 +2241,7 @@ static int vub300_probe(struct usb_interface *interfa=
ce,
 			 usb_endpoint_is_bulk_out(endpoint) ? "BULK OUT" :
 			 "UNKNOWN", i, endpoint->bEndpointAddress);
 		if (endpoint->wMaxPacketSize > 64)
-			vub300->large_usb_packets =3D 1;
+			vub300->large_usb_packets =3D true;
 		if (usb_endpoint_is_bulk_in(endpoint)) {
 			if (!vub300->cmnd_res_ep) {
 				vub300->cmnd_res_ep =3D
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi=
-nand/gpmi-nand.c
index 493ec2f..2e98d65 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -236,7 +236,7 @@ static void dma_irq_callback(void *param)
=20
 	case DMA_FOR_READ_DATA:
 		dma_unmap_sg(this->dev, &this->data_sgl, 1, DMA_FROM_DEVICE);
-		if (this->direct_dma_map_ok =3D=3D false)
+		if (!this->direct_dma_map_ok)
 			memcpy(this->upper_buf, this->data_buffer_dma,
 				this->upper_len);
 		break;
diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.=
c
index 5c3d719..310728e 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -185,7 +185,7 @@ struct pxa3xx_nand_info {
 	uint32_t		ndcb2;
 };
=20
-static bool use_dma =3D 1;
+static bool use_dma =3D true;
 module_param(use_dma, bool, 0444);
 MODULE_PARM_DESC(use_dma, "enable DMA for data transferring to/from NAND H=
W");
=20
@@ -884,7 +884,7 @@ static int pxa3xx_nand_init_buff(struct pxa3xx_nand_inf=
o *info)
 	struct platform_device *pdev =3D info->pdev;
 	int data_desc_offset =3D MAX_BUFF_SIZE - sizeof(struct pxa_dma_desc);
=20
-	if (use_dma =3D=3D 0) {
+	if (!use_dma) {
 		info->data_buff =3D kmalloc(MAX_BUFF_SIZE, GFP_KERNEL);
 		if (info->data_buff =3D=3D NULL)
 			return -ENOMEM;
diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index 769a4e0..1c05b34 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -22,7 +22,7 @@
 #include "r852.h"
=20
=20
-static bool r852_enable_dma =3D 1;
+static bool r852_enable_dma =3D true;
 module_param(r852_enable_dma, bool, S_IRUGO);
 MODULE_PARM_DESC(r852_enable_dma, "Enable usage of the DMA (default)");
=20
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/=
ethernet/broadcom/bnx2x/bnx2x_cmn.h
index bf27c54..489add5 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -615,7 +615,7 @@ static inline void bnx2x_igu_clear_sb_gen(struct bnx2x =
*bp, u8 func,
 	u32 igu_addr_ack =3D IGU_REG_CSTORM_TYPE_0_SB_CLEANUP + (idu_sb_id/32)*4;
 	u32 sb_bit =3D  1 << (idu_sb_id%32);
 	u32 func_encode =3D func |
-			((is_Pf =3D=3D true ? 1 : 0) << IGU_FID_ENCODE_IS_PF_SHIFT);
+			((is_Pf ? 1 : 0) << IGU_FID_ENCODE_IS_PF_SHIFT);
 	u32 addr_encode =3D IGU_CMD_E2_PROD_UPD_BASE + idu_sb_id;
=20
 	/* Not supported in BC mode */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c b/drivers/net/=
ethernet/broadcom/bnx2x/bnx2x_dcb.c
index 5051cf3..7ca7c58 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
@@ -1109,7 +1109,7 @@ static void bnx2x_dcbx_get_num_pg_traf_type(struct bn=
x2x *bp,
 					break;
 				}
 			}
-			if (false =3D=3D pg_found) {
+			if (!pg_found) {
 				data[help_data->num_of_pg].pg =3D add_pg;
 				data[help_data->num_of_pg].pg_priority =3D
 						(1 << ttp[add_traf_type]);
@@ -1119,7 +1119,7 @@ static void bnx2x_dcbx_get_num_pg_traf_type(struct bn=
x2x *bp,
 		}
 		DP(NETIF_MSG_LINK,
 		   "add_traf_type %d pg_found %s num_of_pg %d\n",
-		   add_traf_type, (false =3D=3D pg_found) ? "NO" : "YES",
+		   add_traf_type, (!pg_found) ? "NO" : "YES",
 		   help_data->num_of_pg);
 	}
 }
@@ -1510,7 +1510,7 @@ static void bnx2x_dcbx_2cos_limit_cee_three_pg_to_cos=
_params(
 				entry =3D 0;
=20
 				if (i =3D=3D (num_of_pri-1) &&
-				    false =3D=3D b_found_strict)
+				    !b_found_strict)
 					/* last entry will be handled separately
 					 * If no priority is strict than last
 					 * enty goes to last queue.*/
diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ether=
net/brocade/bna/bfa_ioc.c
index abfad27..4ca3fa5 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
@@ -692,7 +692,7 @@ static void
 bfa_iocpf_sm_mismatch_entry(struct bfa_iocpf *iocpf)
 {
 	/* Call only the first time sm enters fwmismatch state. */
-	if (iocpf->fw_mismatch_notified =3D=3D false)
+	if (!iocpf->fw_mismatch_notified)
 		bfa_ioc_pf_fwmismatch(iocpf->ioc);
=20
 	iocpf->fw_mismatch_notified =3D true;
@@ -1766,7 +1766,7 @@ bfa_nw_ioc_smem_read(struct bfa_ioc *ioc, void *tbuf,=
 u32 soff, u32 sz)
 	/*
 	 *  Hold semaphore to serialize pll init and fwtrc.
 	*/
-	if (bfa_nw_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg) =3D=3D 0)
+	if (!bfa_nw_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg))
 		return 1;
=20
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
@@ -1825,7 +1825,7 @@ bfa_nw_ioc_debug_save_ftrc(struct bfa_ioc *ioc)
 	int tlen;
=20
 	if (ioc->dbg_fwsave_once) {
-		ioc->dbg_fwsave_once =3D 0;
+		ioc->dbg_fwsave_once =3D false;
 		if (ioc->dbg_fwsave_len) {
 			tlen =3D ioc->dbg_fwsave_len;
 			bfa_nw_ioc_debug_fwtrc(ioc, ioc->dbg_fwsave, &tlen);
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_ee.c b/drivers/net/ethern=
et/intel/ixgb/ixgb_ee.c
index 2ed925f..cf95915 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_ee.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_ee.c
@@ -534,7 +534,7 @@ ixgb_get_eeprom_word(struct ixgb_hw *hw, u16 index)
 {
=20
 	if ((index < IXGB_EEPROM_SIZE) &&
-		(ixgb_check_and_get_eeprom_data(hw) =3D=3D true)) {
+		(ixgb_check_and_get_eeprom_data(hw))) {
 	   return hw->eeprom[index];
 	}
=20
@@ -558,7 +558,7 @@ ixgb_get_ee_mac_addr(struct ixgb_hw *hw,
=20
 	ENTER();
=20
-	if (ixgb_check_and_get_eeprom_data(hw) =3D=3D true) {
+	if (ixgb_check_and_get_eeprom_data(hw)) {
 		for (i =3D 0; i < ETH_ALEN; i++) {
 			mac_addr[i] =3D ee_map->mac_addr[i];
 		}
@@ -578,7 +578,7 @@ ixgb_get_ee_mac_addr(struct ixgb_hw *hw,
 u32
 ixgb_get_ee_pba_number(struct ixgb_hw *hw)
 {
-	if (ixgb_check_and_get_eeprom_data(hw) =3D=3D true)
+	if (ixgb_check_and_get_eeprom_data(hw))
 		return le16_to_cpu(hw->eeprom[EEPROM_PBA_1_2_REG])
 			| (le16_to_cpu(hw->eeprom[EEPROM_PBA_3_4_REG])<<16);
=20
@@ -599,7 +599,7 @@ ixgb_get_ee_device_id(struct ixgb_hw *hw)
 {
 	struct ixgb_ee_map_type *ee_map =3D (struct ixgb_ee_map_type *)hw->eeprom=
;
=20
-	if (ixgb_check_and_get_eeprom_data(hw) =3D=3D true)
+	if (ixgb_check_and_get_eeprom_data(hw))
 		return le16_to_cpu(ee_map->device_id);
=20
 	return 0;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_82598.c
index ef2afef..5c1d738 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
@@ -617,7 +617,7 @@ static s32 ixgbe_check_mac_link_82598(struct ixgbe_hw *=
hw,
 				*link_up =3D false;
 		}
=20
-		if (*link_up =3D=3D false)
+		if (!*link_up)
 			goto out;
 	}
=20
@@ -645,7 +645,7 @@ static s32 ixgbe_check_mac_link_82598(struct ixgbe_hw *=
hw,
 	else
 		*speed =3D IXGBE_LINK_SPEED_1GB_FULL;
=20
-	if ((hw->device_id =3D=3D IXGBE_DEV_ID_82598AT2) && (*link_up =3D=3D true=
) &&
+	if ((hw->device_id =3D=3D IXGBE_DEV_ID_82598AT2) && (*link_up) &&
 	    (ixgbe_validate_link_ready(hw) !=3D 0))
 		*link_up =3D false;
=20
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/eth=
ernet/intel/ixgbe/ixgbe_phy.c
index 7cf1e1f..2e60ba5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -1489,11 +1489,11 @@ static s32 ixgbe_get_i2c_ack(struct ixgbe_hw *hw)
 		ack =3D ixgbe_get_i2c_data(&i2cctl);
=20
 		udelay(1);
-		if (ack =3D=3D 0)
+		if (!ack)
 			break;
 	}
=20
-	if (ack =3D=3D 1) {
+	if (ack) {
 		hw_dbg(hw, "I2C ack was not received.\n");
 		status =3D IXGBE_ERR_I2C;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_sriov.c
index cf6812d..8c23422 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -257,7 +257,7 @@ static void ixgbe_restore_vf_macvlans(struct ixgbe_adap=
ter *adapter)
=20
 	list_for_each(pos, &adapter->vf_mvs.l) {
 		entry =3D list_entry(pos, struct vf_macvlans, l);
-		if (entry->free =3D=3D false)
+		if (!entry->free)
 			hw->mac.ops.set_rar(hw, entry->rar_entry,
 					    entry->vf_macvlan,
 					    entry->vf, IXGBE_RAH_AV);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_x540.c
index 8cc5ecc..ab4518c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c
@@ -760,7 +760,7 @@ static s32 ixgbe_blink_led_start_X540(struct ixgbe_hw *=
hw, u32 index)
 	 * This will be reversed when we stop the blinking.
 	 */
 	hw->mac.ops.check_link(hw, &speed, &link_up, false);
-	if (link_up =3D=3D false) {
+	if (!link_up) {
 		macc_reg =3D IXGBE_READ_REG(hw, IXGBE_MACC);
 		macc_reg |=3D IXGBE_MACC_FLU | IXGBE_MACC_FSV_10G | IXGBE_MACC_FS;
 		IXGBE_WRITE_REG(hw, IXGBE_MACC, macc_reg);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers=
/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 3ead111..b32552f 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1224,7 +1224,7 @@ static irqreturn_t pch_gbe_intr(int irq, void *data)
=20
 	/* When request status is Receive interruption */
 	if ((int_st & (PCH_GBE_INT_RX_DMA_CMPLT | PCH_GBE_INT_TX_CMPLT)) ||
-	    (adapter->rx_stop_flag =3D=3D true)) {
+	    (adapter->rx_stop_flag)) {
 		if (likely(napi_schedule_prep(&adapter->napi))) {
 			/* Enable only Rx Descriptor empty */
 			atomic_inc(&adapter->irq_sem);
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/et=
hernet/xilinx/xilinx_emaclite.c
index 79013e5..b4a56f7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -165,7 +165,7 @@ static void xemaclite_enable_interrupts(struct net_loca=
l *drvdata)
=20
 	/* Enable the Tx interrupts for the second Buffer if
 	 * configured in HW */
-	if (drvdata->tx_ping_pong !=3D 0) {
+	if (drvdata->tx_ping_pong) {
 		reg_data =3D in_be32(drvdata->base_addr +
 				   XEL_BUFFER_OFFSET + XEL_TSR_OFFSET);
 		out_be32(drvdata->base_addr + XEL_BUFFER_OFFSET +
@@ -179,7 +179,7 @@ static void xemaclite_enable_interrupts(struct net_loca=
l *drvdata)
=20
 	/* Enable the Rx interrupts for the second Buffer if
 	 * configured in HW */
-	if (drvdata->rx_ping_pong !=3D 0) {
+	if (drvdata->rx_ping_pong) {
 		out_be32(drvdata->base_addr + XEL_BUFFER_OFFSET +
 			 XEL_RSR_OFFSET,
 			 XEL_RSR_RECV_IE_MASK);
@@ -210,7 +210,7 @@ static void xemaclite_disable_interrupts(struct net_loc=
al *drvdata)
=20
 	/* Disable the Tx interrupts for the second Buffer
 	 * if configured in HW */
-	if (drvdata->tx_ping_pong !=3D 0) {
+	if (drvdata->tx_ping_pong) {
 		reg_data =3D in_be32(drvdata->base_addr + XEL_BUFFER_OFFSET +
 				   XEL_TSR_OFFSET);
 		out_be32(drvdata->base_addr + XEL_BUFFER_OFFSET +
@@ -225,7 +225,7 @@ static void xemaclite_disable_interrupts(struct net_loc=
al *drvdata)
=20
 	/* Disable the Rx interrupts for the second buffer
 	 * if configured in HW */
-	if (drvdata->rx_ping_pong !=3D 0) {
+	if (drvdata->rx_ping_pong) {
=20
 		reg_data =3D in_be32(drvdata->base_addr + XEL_BUFFER_OFFSET +
 				   XEL_RSR_OFFSET);
@@ -356,9 +356,9 @@ static int xemaclite_send_data(struct net_local *drvdat=
a, u8 *data,
 	     XEL_TSR_XMIT_ACTIVE_MASK)) =3D=3D 0) {
=20
 		/* Switch to next buffer if configured */
-		if (drvdata->tx_ping_pong !=3D 0)
+		if (drvdata->tx_ping_pong)
 			drvdata->next_tx_buf_to_use ^=3D XEL_BUFFER_OFFSET;
-	} else if (drvdata->tx_ping_pong !=3D 0) {
+	} else if (drvdata->tx_ping_pong) {
 		/* If the expected buffer is full, try the other buffer,
 		 * if it is configured in HW */
=20
@@ -411,14 +411,14 @@ static u16 xemaclite_recv_data(struct net_local *drvd=
ata, u8 *data)
 	reg_data =3D in_be32(addr + XEL_RSR_OFFSET);
=20
 	if ((reg_data & XEL_RSR_RECV_DONE_MASK) =3D=3D XEL_RSR_RECV_DONE_MASK) {
-		if (drvdata->rx_ping_pong !=3D 0)
+		if (drvdata->rx_ping_pong)
 			drvdata->next_rx_buf_to_use ^=3D XEL_BUFFER_OFFSET;
 	} else {
 		/* The instance is out of sync, try other buffer if other
 		 * buffer is configured, return 0 otherwise. If the instance is
 		 * out of sync, do not update the 'next_rx_buf_to_use' since it
 		 * will correct on subsequent calls */
-		if (drvdata->rx_ping_pong !=3D 0)
+		if (drvdata->rx_ping_pong)
 			addr =3D (void __iomem __force *)((u32 __force)addr ^
 							 XEL_BUFFER_OFFSET);
 		else
@@ -699,7 +699,7 @@ static irqreturn_t xemaclite_interrupt(int irq, void *d=
ev_id)
 	}
=20
 	/* If there was a Tx interrupt, call the Tx Handler */
-	if (tx_complete !=3D 0)
+	if (tx_complete)
 		xemaclite_tx_handler(dev);
=20
 	return IRQ_HANDLED;
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index e8be47d..2a21ab1 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -355,7 +355,7 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *=
phydev)
 		}
 	}
=20
-	if (clk125en =3D=3D false ||
+	if (!clk125en ||
 	    (phydev->dev_flags & PHY_BRCM_AUTO_PWRDWN_ENABLE))
 		val &=3D ~BCM54XX_SHD_SCR3_DLLAPD_DIS;
 	else
@@ -373,7 +373,7 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *=
phydev)
=20
 	orig =3D val;
=20
-	if (clk125en =3D=3D false ||
+	if (!clk125en ||
 	    (phydev->dev_flags & PHY_BRCM_AUTO_PWRDWN_ENABLE))
 		val |=3D BCM54XX_SHD_APD_EN;
 	else
diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/at=
h/ath5k/ani.c
index bf67416..35e9370 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -257,7 +257,7 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct at=
h5k_ani_state *as,
 				  "beacon RSSI high");
 		/* only OFDM: beacon RSSI is high, we can disable ODFM weak
 		 * signal detection */
-		if (ofdm_trigger && as->ofdm_weak_sig =3D=3D true) {
+		if (ofdm_trigger && as->ofdm_weak_sig) {
 			ath5k_ani_set_ofdm_weak_signal_detection(ah, false);
 			ath5k_ani_set_spur_immunity_level(ah, 0);
 			return;
@@ -272,7 +272,7 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct at=
h5k_ani_state *as,
 		 * but can raise firstep level */
 		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 				  "beacon RSSI mid");
-		if (ofdm_trigger && as->ofdm_weak_sig =3D=3D false)
+		if (ofdm_trigger && !as->ofdm_weak_sig)
 			ath5k_ani_set_ofdm_weak_signal_detection(ah, true);
 		if (as->firstep_level < ATH5K_ANI_MAX_FIRSTEP_LVL)
 			ath5k_ani_set_firstep_level(ah, as->firstep_level + 1);
@@ -282,7 +282,7 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct at=
h5k_ani_state *as,
 		 * detect and zero firstep level to maximize CCK sensitivity */
 		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 				  "beacon RSSI low, 2GHz");
-		if (ofdm_trigger && as->ofdm_weak_sig =3D=3D true)
+		if (ofdm_trigger && as->ofdm_weak_sig)
 			ath5k_ani_set_ofdm_weak_signal_detection(ah, false);
 		if (as->firstep_level > 0)
 			ath5k_ani_set_firstep_level(ah, 0);
@@ -326,7 +326,7 @@ ath5k_ani_lower_immunity(struct ath5k_hw *ah, struct at=
h5k_ani_state *as)
 		} else if (rssi > ATH5K_ANI_RSSI_THR_LOW) {
 			/* beacon RSSI is mid-range: turn on ODFM weak signal
 			 * detection and next, lower firstep level */
-			if (as->ofdm_weak_sig =3D=3D false) {
+			if (!as->ofdm_weak_sig) {
 				ath5k_ani_set_ofdm_weak_signal_detection(ah,
 									 true);
 				return;
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/at=
h/ath9k/ani.c
index bc56f57..4c2c33d 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -405,22 +405,16 @@ static void ath9k_hw_ani_lower_immunity_old(struct at=
h_hw *ah)
 			/* XXX: Handle me */
 		} else if (rssi > aniState->rssiThrLow) {
 			if (aniState->ofdmWeakSigDetectOff) {
-				if (ath9k_hw_ani_control(ah,
-					 ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-					 true) =3D=3D true)
+				if (ath9k_hw_ani_control(ah, ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION, tru=
e))
 					return;
 			}
 			if (aniState->firstepLevel > 0) {
-				if (ath9k_hw_ani_control(ah,
-					 ATH9K_ANI_FIRSTEP_LEVEL,
-					 aniState->firstepLevel - 1) =3D=3D true)
+				if (ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL, aniState->firste=
pLevel - 1))
 					return;
 			}
 		} else {
 			if (aniState->firstepLevel > 0) {
-				if (ath9k_hw_ani_control(ah,
-					 ATH9K_ANI_FIRSTEP_LEVEL,
-					 aniState->firstepLevel - 1) =3D=3D true)
+				if (ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL, aniState->firste=
pLevel - 1))
 					return;
 			}
 		}
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless=
/ath/ath9k/hw-ops.h
index c4ad0b0..265bf77 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -24,7 +24,7 @@
 static inline void ath9k_hw_configpcipowersave(struct ath_hw *ah,
 					       bool power_off)
 {
-	if (ah->aspm_enabled !=3D true)
+	if (!ah->aspm_enabled)
 		return;
=20
 	ath9k_hw_ops(ah)->config_pci_powersave(ah, power_off);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath=
/ath9k/hw.c
index ee77595..3cc1cbc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1597,7 +1597,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_ch=
annel *chan,
 		allow_fbs =3D true;
=20
 	if (bChannelChange &&
-	    (ah->chip_fullsleep !=3D true) &&
+	    (!ah->chip_fullsleep) &&
 	    (ah->curchan !=3D NULL) &&
 	    (chan->channel !=3D ah->curchan->channel) &&
 	    (allow_fbs ||
@@ -2035,8 +2035,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *a=
h, int setChip)
 	if (setChip) {
 		if ((REG_READ(ah, AR_RTC_STATUS) &
 		     AR_RTC_STATUS_M) =3D=3D AR_RTC_STATUS_SHUTDOWN) {
-			if (ath9k_hw_set_reset_reg(ah,
-					   ATH9K_RESET_POWER_ON) !=3D true) {
+			if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 				return false;
 			}
 			if (!AR_SREV_9300_20_OR_LATER(ah))
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.=
c
index b5f1b91..dc9a096 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1467,7 +1467,7 @@ int b43_dma_tx(struct b43_wldev *dev, struct sk_buff =
*skb)
 		/* This TX ring is full. */
 		unsigned int skb_mapping =3D skb_get_queue_mapping(skb);
 		ieee80211_stop_queue(dev->wl->hw, skb_mapping);
-		dev->wl->tx_queue_stopped[skb_mapping] =3D 1;
+		dev->wl->tx_queue_stopped[skb_mapping] =3D true;
 		ring->stopped =3D true;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
@@ -1590,7 +1590,7 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 	}
=20
 	if (dev->wl->tx_queue_stopped[ring->queue_prio]) {
-		dev->wl->tx_queue_stopped[ring->queue_prio] =3D 0;
+		dev->wl->tx_queue_stopped[ring->queue_prio] =3D false;
 	} else {
 		/* If the driver queue is running wake the corresponding
 		 * mac80211 queue. */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/mai=
n.c
index 23ffb1b..142d088 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3398,7 +3398,7 @@ static void b43_tx_work(struct work_struct *work)
 			else
 				err =3D b43_dma_tx(dev, skb);
 			if (err =3D=3D -ENOSPC) {
-				wl->tx_queue_stopped[queue_num] =3D 1;
+				wl->tx_queue_stopped[queue_num] =3D true;
 				ieee80211_stop_queue(wl->hw, queue_num);
 				skb_queue_head(&wl->tx_queue[queue_num], skb);
 				break;
@@ -3409,7 +3409,7 @@ static void b43_tx_work(struct work_struct *work)
 		}
=20
 		if (!err)
-			wl->tx_queue_stopped[queue_num] =3D 0;
+			wl->tx_queue_stopped[queue_num] =3D false;
 	}
=20
 #if B43_DEBUG
@@ -5310,7 +5310,7 @@ static struct b43_wl *b43_wireless_init(struct b43_bu=
s_dev *dev)
 	/* Initialize queues and flags. */
 	for (queue_num =3D 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
 		skb_queue_head_init(&wl->tx_queue[queue_num]);
-		wl->tx_queue_stopped[queue_num] =3D 0;
+		wl->tx_queue_stopped[queue_num] =3D false;
 	}
=20
 	snprintf(chip_name, ARRAY_SIZE(chip_name),
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/ph=
y_n.c
index bf5a438..8b22446 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3524,7 +3524,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *de=
v,
 			core =3D (cmd & 0x3000) >> 12;
 			type =3D (cmd & 0x0F00) >> 8;
=20
-			if (phy6or5x && updated[core] =3D=3D 0) {
+			if (phy6or5x && !updated[core]) {
 				b43_nphy_update_tx_cal_ladder(dev, core);
 				updated[core] =3D true;
 			}
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.=
c
index 3533ab8..5fedb8a 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -778,7 +778,7 @@ void b43_pio_rx(struct b43_pio_rxqueue *q)
 	bool stop;
=20
 	while (1) {
-		stop =3D (pio_rx_frame(q) =3D=3D 0);
+		stop =3D (!pio_rx_frame(q));
 		if (stop)
 			break;
 		cond_resched();
diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b4=
3legacy/dma.c
index f1f8bd0..8b7be5c 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -1182,7 +1182,7 @@ int b43legacy_dma_tx(struct b43legacy_wldev *dev,
 		/* This TX ring is full. */
 		unsigned int skb_mapping =3D skb_get_queue_mapping(skb);
 		ieee80211_stop_queue(dev->wl->hw, skb_mapping);
-		dev->wl->tx_queue_stopped[skb_mapping] =3D 1;
+		dev->wl->tx_queue_stopped[skb_mapping] =3D true;
 		ring->stopped =3D true;
 		if (b43legacy_debug(dev, B43legacy_DBG_DMAVERBOSE))
 			b43legacydbg(dev->wl, "Stopped TX ring %d\n",
@@ -1297,7 +1297,7 @@ void b43legacy_dma_handle_txstatus(struct b43legacy_w=
ldev *dev,
 	}
=20
 	if (dev->wl->tx_queue_stopped[ring->queue_prio]) {
-		dev->wl->tx_queue_stopped[ring->queue_prio] =3D 0;
+		dev->wl->tx_queue_stopped[ring->queue_prio] =3D false;
 	} else {
 		/* If the driver queue is running wake the corresponding
 		 * mac80211 queue. */
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b=
43legacy/main.c
index 75e70bc..4c14c72 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2464,7 +2464,7 @@ static void b43legacy_tx_work(struct work_struct *wor=
k)
 			else
 				err =3D b43legacy_dma_tx(dev, skb);
 			if (err =3D=3D -ENOSPC) {
-				wl->tx_queue_stopped[queue_num] =3D 1;
+				wl->tx_queue_stopped[queue_num] =3D true;
 				ieee80211_stop_queue(wl->hw, queue_num);
 				skb_queue_head(&wl->tx_queue[queue_num], skb);
 				break;
@@ -2475,7 +2475,7 @@ static void b43legacy_tx_work(struct work_struct *wor=
k)
 		}
=20
 		if (!err)
-			wl->tx_queue_stopped[queue_num] =3D 0;
+			wl->tx_queue_stopped[queue_num] =3D false;
 	}
=20
 	mutex_unlock(&wl->mutex);
@@ -3828,7 +3828,7 @@ static int b43legacy_wireless_init(struct ssb_device =
*dev)
 	/* Initialize queues and flags. */
 	for (queue_num =3D 0; queue_num < B43legacy_QOS_QUEUE_NUM; queue_num++) {
 		skb_queue_head_init(&wl->tx_queue[queue_num]);
-		wl->tx_queue_stopped[queue_num] =3D 0;
+		wl->tx_queue_stopped[queue_num] =3D false;
 	}
=20
 	ssb_set_devtypedata(dev, wl);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/=
net/wireless/brcm80211/brcmfmac/dhd_linux.c
index eb9eb76..7fa3ceb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -780,7 +780,7 @@ static int brcmf_netdev_stop(struct net_device *ndev)
=20
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_cfg80211_down(drvr->config);
-	if (drvr->bus_if->drvr_up =3D=3D 0)
+	if (!drvr->bus_if->drvr_up)
 		return 0;
=20
 	/* Set state and stop OS transmissions */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/n=
et/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f7eeee1..f943146 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -765,7 +765,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, b=
ool on, bool pendok)
 		brcmf_dbg(INFO, "CLKCTL: turned ON\n");
=20
 #if defined(BCMDBG)
-		if (bus->alp_only !=3D true) {
+		if (!bus->alp_only) {
 			if (SBSDIO_ALPONLY(clkctl))
 				brcmf_dbg(ERROR, "HT Clock should be on\n");
 		}
@@ -2099,7 +2099,7 @@ brcmf_sdbrcm_wait_for_event(struct brcmf_sdio *bus, b=
ool *lockvar)
 {
 	up(&bus->sdsem);
 	wait_event_interruptible_timeout(bus->ctrl_wait,
-					 (*lockvar =3D=3D false), HZ * 2);
+					 (!*lockvar), HZ * 2);
 	down(&bus->sdsem);
 	return;
 }
@@ -2684,8 +2684,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev=
, struct sk_buff *pkt)
=20
 	/* Priority based enq */
 	spin_lock_bh(&bus->txqlock);
-	if (brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec) =3D=3D
-	    false) {
+	if (!brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec)) {
 		skb_pull(pkt, SDPCM_HDRLEN);
 		brcmf_txcomplete(bus->sdiodev->dev, pkt, false);
 		brcmu_pkt_buf_free_skb(pkt);
@@ -2972,7 +2971,7 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned c=
har *msg, uint msglen)
=20
 		brcmf_sdbrcm_wait_for_event(bus, &bus->ctrl_frame_stat);
=20
-		if (bus->ctrl_frame_stat =3D=3D false) {
+		if (!bus->ctrl_frame_stat) {
 			brcmf_dbg(INFO, "ctrl_frame_stat =3D=3D false\n");
 			ret =3D 0;
 		} else {
@@ -3040,7 +3039,7 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned c=
har *msg, uint msglen)
 			  rxlen, msglen);
 	} else if (timeleft =3D=3D 0) {
 		brcmf_dbg(ERROR, "resumed on timeout\n");
-	} else if (pending =3D=3D true) {
+	} else if (pending) {
 		brcmf_dbg(CTL, "cancelled\n");
 		return -ERESTARTSYS;
 	} else {
@@ -4031,7 +4030,7 @@ void
 brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 {
 	/* Totally stop the timer */
-	if (!wdtick && bus->wd_timer_valid =3D=3D true) {
+	if (!wdtick && bus->wd_timer_valid) {
 		del_timer_sync(&bus->timer);
 		bus->wd_timer_valid =3D false;
 		bus->save_ms =3D wdtick;
@@ -4044,7 +4043,7 @@ brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wd=
tick)
=20
 	if (wdtick) {
 		if (bus->save_ms !=3D BRCMF_WD_POLL_MS) {
-			if (bus->wd_timer_valid =3D=3D true)
+			if (bus->wd_timer_valid)
 				/* Stop timer and restart at new value */
 				del_timer_sync(&bus->timer);
=20
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/ne=
t/wireless/brcm80211/brcmsmac/channel.c
index 55e9f45..b946713 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -1149,7 +1149,7 @@ brcms_c_channel_set_chanspec(struct brcms_cm_info *wl=
c_cm, u16 chanspec,
 	);
=20
 	brcms_b_set_chanspec(wlc->hw, chanspec,
-			      (brcms_c_quiet_chanspec(wlc_cm, chanspec) !=3D 0),
+			      (brcms_c_quiet_chanspec(wlc_cm, chanspec)),
 			      &txpwr);
 }
=20
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/w=
ireless/brcm80211/brcmsmac/main.c
index f6affc6..d687ef6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3246,7 +3246,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc=
)
 	}
=20
 	/* For old ucode, txfifo sizes needs to be modified(increased) */
-	if (fifosz_fixup =3D=3D true)
+	if (fifosz_fixup)
 		brcms_b_corerev_fifofixup(wlc_hw);
=20
 	/* check txfifo allocations match between ucode and driver */
@@ -5425,7 +5425,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gm=
ode, bool config)
 		return -EINVAL;
=20
 	/* update configuration value */
-	if (config =3D=3D true)
+	if (config)
 		brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER, gmode);
=20
 	/* Clear rateset override */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/driver=
s/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index ce8562a..d56e897 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -3968,7 +3968,7 @@ s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bo=
ol mode)
 	s16 avg =3D 0;
 	bool suspend =3D false;
=20
-	if (mode =3D=3D 1) {
+	if (mode) {
 		suspend =3D (0 =3D=3D (bcma_read32(pi->d11core,
 					     D11REGOFFS(maccontrol)) &
 				 MCTL_EN_MAC));
@@ -3991,7 +3991,7 @@ s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bo=
ol mode)
=20
 	avg /=3D 2;
=20
-	if (mode =3D=3D 1) {
+	if (mode) {
=20
 		mod_phy_reg(pi, 0x448, (0x1 << 14), (1) << 14);
=20
@@ -4012,7 +4012,7 @@ u16 wlc_lcnphy_tempsense(struct brcms_phy *pi, bool m=
ode)
 	u16 SAVE_txpwrctrl =3D wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	struct brcms_phy_lcnphy *pi_lcn =3D pi->u.pi_lcnphy;
=20
-	if (mode =3D=3D 1) {
+	if (mode) {
 		suspend =3D (0 =3D=3D (bcma_read32(pi->d11core,
 					     D11REGOFFS(maccontrol)) &
 				 MCTL_EN_MAC));
@@ -4049,7 +4049,7 @@ u16 wlc_lcnphy_tempsense(struct brcms_phy *pi, bool m=
ode)
 	if (mode)
 		wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_txpwrctrl);
=20
-	if (mode =3D=3D 1) {
+	if (mode) {
=20
 		mod_phy_reg(pi, 0x448, (0x1 << 14), (1) << 14);
=20
@@ -4078,7 +4078,7 @@ s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mo=
de)
 	s32 avg =3D 0;
 	bool suspend =3D false;
=20
-	if (mode =3D=3D 1) {
+	if (mode) {
 		suspend =3D (0 =3D=3D (bcma_read32(pi->d11core,
 					     D11REGOFFS(maccontrol)) &
 				 MCTL_EN_MAC));
@@ -4097,7 +4097,7 @@ s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mo=
de)
 	avg =3D	(avg * LCN_VBAT_SCALE_NOM +
 		 (LCN_VBAT_SCALE_DEN >> 1)) / LCN_VBAT_SCALE_DEN;
=20
-	if (mode =3D=3D 1) {
+	if (mode) {
 		if (!suspend)
 			wlapi_enable_mac(pi->sh->physhim);
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/=
net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index a16f1ab..e3f3151 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -21462,7 +21462,7 @@ void wlc_phy_antsel_init(struct brcms_phy_pub *ppi,=
 bool lut_init)
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 		u16 v0 =3D 0x211, v1 =3D 0x222, v2 =3D 0x144, v3 =3D 0x188;
=20
-		if (lut_init =3D=3D false)
+		if (!lut_init)
 			return;
=20
 		if (pi->srom_fem2g.antswctrllut =3D=3D 0) {
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireles=
s/iwlegacy/4965-mac.c
index 1667232..e21e2db 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5179,7 +5179,7 @@ il4965_set_hw_ready(struct il_priv *il)
 	else
 		il->hw_ready =3D false;
=20
-	D_INFO("hardware %s\n", (il->hw_ready =3D=3D 1) ? "ready" : "not ready");
+	D_INFO("hardware %s\n", (il->hw_ready) ? "ready" : "not ready");
 	return ret;
 }
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net=
/wireless/iwlwifi/iwl-trans-pcie-tx.c
index bd29568..c837463 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -478,7 +478,7 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *tran=
s,
 	}
=20
 	txq_id =3D trans_pcie->agg_txq[sta_id][tid];
-	if (WARN_ON_ONCE(is_agg_txqid_valid(trans, txq_id) =3D=3D false)) {
+	if (WARN_ON_ONCE(!is_agg_txqid_valid(trans, txq_id))) {
 		IWL_ERR(trans,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
@@ -573,7 +573,7 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *tra=
ns, int sta_id, int tid)
 	struct iwl_trans_pcie *trans_pcie =3D IWL_TRANS_GET_PCIE_TRANS(trans);
 	u8 txq_id =3D trans_pcie->agg_txq[sta_id][tid];
=20
-	if (WARN_ON_ONCE(is_agg_txqid_valid(trans, txq_id) =3D=3D false)) {
+	if (WARN_ON_ONCE(!is_agg_txqid_valid(trans, txq_id))) {
 		IWL_ERR(trans,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wir=
eless/iwmc3200wifi/commands.c
index bd75078..cc7022e 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -806,7 +806,7 @@ int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
 		return ret;
=20
 	ret =3D wait_event_interruptible_timeout(iwm->mlme_queue,
-				(iwm->umac_profile_active =3D=3D 0), 5 * HZ);
+				(!iwm->umac_profile_active), 5 * HZ);
=20
 	return ret ? 0 : -EBUSY;
 }
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index dd5aeaf..8488c35 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1330,7 +1330,7 @@ static int rxq_process(struct ieee80211_hw *hw, int i=
ndex, int limit)
 								wh->addr1);
=20
 			if (mwl8k_vif !=3D NULL &&
-			    mwl8k_vif->is_hw_crypto_enabled =3D=3D true) {
+			    mwl8k_vif->is_hw_crypto_enabled) {
 				/*
 				 * When MMIC ERROR is encountered
 				 * by the firmware, payload is
@@ -1993,7 +1993,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, st=
ruct sk_buff *skb)
 	 */
=20
 	if (txq->len >=3D MWL8K_TX_DESCS - 2) {
-		if (mgmtframe =3D=3D false ||
+		if (!mgmtframe ||
 			txq->len =3D=3D MWL8K_TX_DESCS) {
 			if (start_ba_session) {
 				spin_lock(&priv->stream_lock);
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtl=
wifi/base.c
index 8d6eb0f..0aeca09 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -407,7 +407,7 @@ void rtl_init_rfkill(struct ieee80211_hw *hw)
=20
 		rtlpriv->rfkill.rfkill_state =3D radio_state;
=20
-		blocked =3D (rtlpriv->rfkill.rfkill_state =3D=3D 1) ? 0 : 1;
+		blocked =3D (rtlpriv->rfkill.rfkill_state) ? 0 : 1;
 		wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
 	}
=20
@@ -693,7 +693,7 @@ int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 {
 	int rate_idx;
=20
-	if (false =3D=3D isht) {
+	if (!isht) {
 		if (IEEE80211_BAND_2GHZ =3D=3D hw->conf.channel->band) {
 			switch (desc_rate) {
 			case DESC92_RATE1M:
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtl=
wifi/core.c
index 3f0f056..57c4e36 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1109,7 +1109,7 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *h=
w)
 				 (KERN_INFO "wireless radio switch turned %s\n",
 				  radio_state ? "on" : "off"));
=20
-			blocked =3D (rtlpriv->rfkill.rfkill_state =3D=3D 1) ? 0 : 1;
+			blocked =3D (rtlpriv->rfkill.rfkill_state) ? 0 : 1;
 			wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
 		}
 	}
diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rt=
lwifi/efuse.c
index ed1058b..7ac8564 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -778,7 +778,7 @@ static void efuse_write_data_case1(struct ieee80211_hw =
*hw, u16 *efuse_addr,
 				dataempty =3D false;
 		}
=20
-		if (dataempty =3D=3D false) {
+		if (!dataempty) {
 			*efuse_addr =3D *efuse_addr + (tmp_word_cnts * 2) + 1;
 			*write_state =3D PG_STATE_HEADER;
 		} else {
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwi=
fi/ps.c
index 130fdd9..369aab6 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -105,7 +105,7 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 	case ERFOFF:
=20
 		if ((changesource =3D=3D RF_CHANGE_BY_HW)
-		    && (ppsc->hwradiooff =3D=3D false)) {
+		    && (!ppsc->hwradiooff)) {
 			ppsc->hwradiooff =3D true;
 		}
=20
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/ne=
t/wireless/rtlwifi/rtl8192c/dm_common.c
index 72a98ca..b93c69e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -330,7 +330,7 @@ static void rtl92c_dm_initial_gain_multi_sta(struct iee=
e80211_hw *hw)
 	if (mac->opmode =3D=3D NL80211_IFTYPE_ADHOC)
 		multi_sta =3D true;
=20
-	if ((multi_sta =3D=3D false) || (dm_digtable.cursta_connectctate !=3D
+	if ((!multi_sta) || (dm_digtable.cursta_connectctate !=3D
 				     DIG_STA_DISCONNECT)) {
 		initialized =3D false;
 		dm_digtable.dig_ext_port_stage =3D DIG_EXT_PORT_STAGE_MAX;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/ne=
t/wireless/rtlwifi/rtl8192c/fw_common.c
index 931d979..454b53b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -521,7 +521,7 @@ void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
 	struct rtl_hal *rtlhal =3D rtl_hal(rtl_priv(hw));
 	u32 tmp_cmdbuf[2];
=20
-	if (rtlhal->fw_ready =3D=3D false) {
+	if (!rtlhal->fw_ready) {
 		RT_ASSERT(false, ("return H2C cmd because of Fw "
 				  "download fail!!!\n"));
 		return;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c b/drivers/n=
et/wireless/rtlwifi/rtl8192c/phy_common.c
index 1f07558..467b408 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -219,7 +219,7 @@ bool _rtl92c_phy_bb8192c_config_parafile(struct ieee802=
11_hw *hw)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, ("=3D=3D>\n"));
 	rtstatus =3D rtlpriv->cfg->ops->config_bb_with_headerfile(hw,
 						 BASEBAND_CONFIG_PHY_REG);
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("Write BB Reg Fail!!"));
 		return false;
 	}
@@ -232,13 +232,13 @@ bool _rtl92c_phy_bb8192c_config_parafile(struct ieee8=
0211_hw *hw)
 		rtstatus =3D rtlpriv->cfg->ops->config_bb_with_pgheaderfile(hw,
 						   BASEBAND_CONFIG_PHY_REG);
 	}
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("BB_PG Reg Fail!!"));
 		return false;
 	}
 	rtstatus =3D rtlpriv->cfg->ops->config_bb_with_headerfile(hw,
 						 BASEBAND_CONFIG_AGC_TAB);
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("AGC Table Fail\n"));
 		return false;
 	}
@@ -584,7 +584,7 @@ void rtl92c_phy_set_txpower_level(struct ieee80211_hw *=
hw, u8 channel)
 	struct rtl_efuse *rtlefuse =3D rtl_efuse(rtlpriv);
 	u8 cckpowerlevel[2], ofdmpowerlevel[2];
=20
-	if (rtlefuse->txpwr_fromeprom =3D=3D false)
+	if (!rtlefuse->txpwr_fromeprom)
 		return;
 	_rtl92c_get_txpower_index(hw, channel,
 				  &cckpowerlevel[0], &ofdmpowerlevel[0]);
@@ -1133,7 +1133,7 @@ static void _rtl92c_phy_path_adda_on(struct ieee80211=
_hw *hw,
 	u32 i;
=20
 	pathOn =3D is_patha_on ? 0x04db25a4 : 0x0b1b25a4;
-	if (false =3D=3D is2t) {
+	if (!is2t) {
 		pathOn =3D 0x0bdb25a0;
 		rtl_set_bbreg(hw, addareg[0], MASKDWORD, 0x0b1b25a0);
 	} else {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wire=
less/rtlwifi/rtl8192ce/hw.c
index a3deaef..88a5af9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -592,22 +592,22 @@ static bool _rtl92ce_llt_table_init(struct ieee80211_=
hw *hw)
=20
 	for (i =3D 0; i < (txpktbuf_bndy - 1); i++) {
 		status =3D _rtl92ce_llt_write(hw, i, i + 1);
-		if (true !=3D status)
+		if (!status)
 			return status;
 	}
=20
 	status =3D _rtl92ce_llt_write(hw, (txpktbuf_bndy - 1), 0xFF);
-	if (true !=3D status)
+	if (!status)
 		return status;
=20
 	for (i =3D txpktbuf_bndy; i < maxPage; i++) {
 		status =3D _rtl92ce_llt_write(hw, i, (i + 1));
-		if (true !=3D status)
+		if (!status)
 			return status;
 	}
=20
 	status =3D _rtl92ce_llt_write(hw, maxPage, txpktbuf_bndy);
-	if (true !=3D status)
+	if (!status)
 		return status;
=20
 	return true;
@@ -696,7 +696,7 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
=20
 	rtl_write_word(rtlpriv, REG_CR, 0x2ff);
=20
-	if (_rtl92ce_llt_table_init(hw) =3D=3D false)
+	if (!_rtl92ce_llt_table_init(hw))
 		return false;
=20
 	rtl_write_dword(rtlpriv, REG_HISR, 0xffffffff);
@@ -909,7 +909,7 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 	rtlpci->being_init_adapter =3D true;
 	rtlpriv->intf_ops->disable_aspm(hw);
 	rtstatus =3D _rtl92ce_init_mac(hw);
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("Init MAC failed\n"));
 		err =3D 1;
 		return err;
@@ -1126,7 +1126,7 @@ void rtl92ce_set_check_bssid(struct ieee80211_hw *hw,=
 bool check_bssid)
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
 					      (u8 *) (&reg_rcr));
 		_rtl92ce_set_bcn_ctrl_reg(hw, 0, BIT(4));
-	} else if (check_bssid =3D=3D false) {
+	} else if (!check_bssid) {
 		reg_rcr &=3D (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
 		_rtl92ce_set_bcn_ctrl_reg(hw, BIT(4), 0);
 		rtlpriv->cfg->ops->set_hw_reg(hw,
@@ -1999,7 +1999,7 @@ bool rtl92ce_gpio_radio_on_off_checking(struct ieee80=
211_hw *hw, u8 *valid)
 		e_rfpowerstate_toset =3D ERFON;
 		ppsc->hwradiooff =3D false;
 		actuallyset =3D true;
-	} else if ((ppsc->hwradiooff =3D=3D false)
+	} else if ((!ppsc->hwradiooff)
 		   && (e_rfpowerstate_toset =3D=3D ERFOFF)) {
 		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 			 ("GPIOChangeRF  - HW Radio OFF, RF OFF\n"));
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wir=
eless/rtlwifi/rtl8192ce/phy.c
index 3b585aa..648d2c8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -528,7 +528,7 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee=
80211_hw *hw,
 					RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 						 ("IPS Set eRf nic enable\n"));
 					rtstatus =3D rtl_ps_enable_nic(hw);
-				} while ((rtstatus !=3D true)
+				} while ((!rtstatus)
 					 && (InitializeCount < 10));
 				RT_CLEAR_PS_LEVEL(ppsc,
 						  RT_RF_OFF_LEVL_HALT_NIC);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c b/drivers/net/wire=
less/rtlwifi/rtl8192ce/rf.c
index d3b01e6..863f2f5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
@@ -510,7 +510,7 @@ static bool _rtl92ce_phy_rf6052_config_parafile(struct =
ieee80211_hw *hw)
 			break;
 		}
=20
-		if (rtstatus !=3D true) {
+		if (!rtstatus) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 				 ("Radio[%d] Fail!!", rfpath));
 			return false;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wire=
less/rtlwifi/rtl8192cu/hw.c
index 124cf63..acb8c7d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1008,7 +1008,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 					? WMM_CHIP_B_TX_PAGE_BOUNDARY
 					: WMM_CHIP_A_TX_PAGE_BOUNDARY;
 	}
-	if (false =3D=3D rtl92c_init_llt_table(hw, boundary)) {
+	if (!rtl92c_init_llt_table(hw, boundary)) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			("Failed to init LLT Table!\n"));
 		return -EINVAL;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wir=
eless/rtlwifi/rtl8192cu/mac.c
index 9e0c8fc..ab4632c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -216,14 +216,14 @@ bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u=
32 boundary)
=20
 	for (i =3D 0; i < (boundary - 1); i++) {
 		rst =3D rtl92c_llt_write(hw, i , i + 1);
-		if (true !=3D rst) {
+		if (!rst) {
 			pr_err("=3D=3D=3D> %s #1 fail\n", __func__);
 			return rst;
 		}
 	}
 	/* end of list */
 	rst =3D rtl92c_llt_write(hw, (boundary - 1), 0xFF);
-	if (true !=3D rst) {
+	if (!rst) {
 		pr_err("=3D=3D=3D> %s #2 fail\n", __func__);
 		return rst;
 	}
@@ -234,14 +234,14 @@ bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u=
32 boundary)
 	 */
 	for (i =3D boundary; i < LLT_LAST_ENTRY_OF_TX_PKT_BUFFER; i++) {
 		rst =3D rtl92c_llt_write(hw, i, (i + 1));
-		if (true !=3D rst) {
+		if (!rst) {
 			pr_err("=3D=3D=3D> %s #3 fail\n", __func__);
 			return rst;
 		}
 	}
 	/* Let last entry point to the start entry of ring buffer */
 	rst =3D rtl92c_llt_write(hw, LLT_LAST_ENTRY_OF_TX_PKT_BUFFER, boundary);
-	if (true !=3D rst) {
+	if (!rst) {
 		pr_err("=3D=3D=3D> %s #4 fail\n", __func__);
 		return rst;
 	}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wir=
eless/rtlwifi/rtl8192cu/phy.c
index e49cf22..0f4c2f2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -482,7 +482,7 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee=
80211_hw *hw,
 				RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 					 ("IPS Set eRf nic enable\n"));
 				rtstatus =3D rtl_ps_enable_nic(hw);
-			} while ((rtstatus !=3D true)
+			} while ((!rtstatus)
 				 && (InitializeCount < 10));
 			RT_CLEAR_PS_LEVEL(ppsc,
 					  RT_RF_OFF_LEVL_HALT_NIC);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wire=
less/rtlwifi/rtl8192cu/rf.c
index 1e851aa..124b2a6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -480,7 +480,7 @@ static bool _rtl92c_phy_rf6052_config_parafile(struct i=
eee80211_hw *hw)
 				      BRFSI_RFENV << 16, u4_regvalue);
 			break;
 		}
-		if (rtstatus !=3D true) {
+		if (!rtstatus) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 				 ("Radio[%d] Fail!!", rfpath));
 			goto phy_rf_cfg_fail;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wire=
less/rtlwifi/rtl8192de/dm.c
index 3cd0736..abff0ee 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -408,7 +408,7 @@ static void rtl92d_dm_dig(struct ieee80211_hw *hw)
 		de_digtable.last_min_undecorated_pwdb_for_dm =3D
 				 de_digtable.min_undecorated_pwdb_for_dm;
 	}
-	if (rtlpriv->dm.dm_initialgain_enable =3D=3D false)
+	if (!rtlpriv->dm.dm_initialgain_enable)
 		return;
=20
 	/* because we will send data pkt when scanning
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c b/drivers/net/wire=
less/rtlwifi/rtl8192de/fw.c
index 82f060b..88fbedf 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
@@ -542,7 +542,7 @@ void rtl92d_fill_h2c_cmd(struct ieee80211_hw *hw,
 	struct rtl_hal *rtlhal =3D rtl_hal(rtl_priv(hw));
 	u32 tmp_cmdbuf[2];
=20
-	if (rtlhal->fw_ready =3D=3D false) {
+	if (!rtlhal->fw_ready) {
 		RT_ASSERT(false, ("return H2C cmd because of Fw "
 				  "download fail!!!\n"));
 		return;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wire=
less/rtlwifi/rtl8192de/hw.c
index 9d89d7c..b1c3c3f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -590,13 +590,13 @@ static bool _rtl92de_llt_table_init(struct ieee80211_=
hw *hw)
 	/* 18.  LLT_table_init(Adapter);  */
 	for (i =3D 0; i < (txpktbuf_bndy - 1); i++) {
 		status =3D _rtl92de_llt_write(hw, i, i + 1);
-		if (true !=3D status)
+		if (!status)
 			return status;
 	}
=20
 	/* end of list */
 	status =3D _rtl92de_llt_write(hw, (txpktbuf_bndy - 1), 0xFF);
-	if (true !=3D status)
+	if (!status)
 		return status;
=20
 	/* Make the other pages as ring buffer */
@@ -605,13 +605,13 @@ static bool _rtl92de_llt_table_init(struct ieee80211_=
hw *hw)
 	/* Otherwise used as local loopback buffer.  */
 	for (i =3D txpktbuf_bndy; i < maxPage; i++) {
 		status =3D _rtl92de_llt_write(hw, i, (i + 1));
-		if (true !=3D status)
+		if (!status)
 			return status;
 	}
=20
 	/* Let last entry point to the start entry of ring buffer */
 	status =3D _rtl92de_llt_write(hw, maxPage, txpktbuf_bndy);
-	if (true !=3D status)
+	if (!status)
 		return status;
=20
 	return true;
@@ -707,7 +707,7 @@ static bool _rtl92de_init_mac(struct ieee80211_hw *hw)
=20
 	/* System init */
 	/* 18.  LLT_table_init(Adapter);  */
-	if (_rtl92de_llt_table_init(hw) =3D=3D false)
+	if (!_rtl92de_llt_table_init(hw))
 		return false;
=20
 	/* Clear interrupt and enable interrupt */
@@ -920,7 +920,7 @@ int rtl92de_hw_init(struct ieee80211_hw *hw)
 	rtl92d_phy_reset_iqk_result(hw);
 	/* rtlpriv->intf_ops->disable_aspm(hw); */
 	rtstatus =3D _rtl92de_init_mac(hw);
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("Init MAC failed\n"));
 		err =3D 1;
 		spin_unlock_irqrestore(&globalmutex_for_power_and_efuse, flags);
@@ -1151,7 +1151,7 @@ void rtl92de_set_check_bssid(struct ieee80211_hw *hw,=
 bool check_bssid)
 		reg_rcr |=3D (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
 		_rtl92de_set_bcn_ctrl_reg(hw, 0, BIT(4));
-	} else if (check_bssid =3D=3D false) {
+	} else if (!check_bssid) {
 		reg_rcr &=3D (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
 		_rtl92de_set_bcn_ctrl_reg(hw, BIT(4), 0);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
@@ -2157,7 +2157,7 @@ bool rtl92de_gpio_radio_on_off_checking(struct ieee80=
211_hw *hw, u8 *valid)
 		e_rfpowerstate_toset =3D ERFON;
 		ppsc->hwradiooff =3D false;
 		actuallyset =3D true;
-	} else if ((ppsc->hwradiooff =3D=3D false)
+	} else if ((!ppsc->hwradiooff)
 		&& (e_rfpowerstate_toset =3D=3D ERFOFF)) {
 		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 			 ("GPIOChangeRF  - HW Radio OFF, RF OFF\n"));
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wir=
eless/rtlwifi/rtl8192de/phy.c
index 0883349..8c42d89 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -864,7 +864,7 @@ static bool _rtl92d_phy_bb_config(struct ieee80211_hw *=
hw)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, ("=3D=3D>\n"));
 	rtstatus =3D _rtl92d_phy_config_bb_with_headerfile(hw,
 		BASEBAND_CONFIG_PHY_REG);
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("Write BB Reg Fail!!"));
 		return false;
 	}
@@ -879,13 +879,13 @@ static bool _rtl92d_phy_bb_config(struct ieee80211_hw=
 *hw)
 		rtstatus =3D _rtl92d_phy_config_bb_with_pgheaderfile(hw,
 			BASEBAND_CONFIG_PHY_REG);
 	}
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("BB_PG Reg Fail!!"));
 		return false;
 	}
 	rtstatus =3D _rtl92d_phy_config_bb_with_headerfile(hw,
 		BASEBAND_CONFIG_AGC_TAB);
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("AGC Table Fail\n"));
 		return false;
 	}
@@ -1137,7 +1137,7 @@ void rtl92d_phy_set_txpower_level(struct ieee80211_hw=
 *hw, u8 channel)
 	struct rtl_priv *rtlpriv =3D rtl_priv(hw);
 	u8 cckpowerlevel[2], ofdmpowerlevel[2];
=20
-	if (rtlefuse->txpwr_fromeprom =3D=3D false)
+	if (!rtlefuse->txpwr_fromeprom)
 		return;
 	channel =3D _rtl92c_phy_get_rightchnlplace(channel);
 	_rtl92d_get_txpower_index(hw, channel, &cckpowerlevel[0],
@@ -3334,7 +3334,7 @@ bool rtl92d_phy_set_rf_power_state(struct ieee80211_h=
w *hw,
 				RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 					 ("IPS Set eRf nic enable\n"));
 				rtstatus =3D rtl_ps_enable_nic(hw);
-			} while ((rtstatus !=3D true) &&
+			} while ((!rtstatus) &&
 				 (InitializeCount < 10));
=20
 			RT_CLEAR_PS_LEVEL(ppsc,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/rf.c b/drivers/net/wire=
less/rtlwifi/rtl8192de/rf.c
index db27ceb..683a39e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
@@ -604,7 +604,7 @@ bool rtl92d_phy_rf6052_config(struct ieee80211_hw *hw)
 				      u4_regvalue);
 			break;
 		}
-		if (rtstatus !=3D true) {
+		if (!rtstatus) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 				("Radio[%d] Fail!!", rfpath));
 			goto phy_rf_cfg_fail;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c b/drivers/net/wire=
less/rtlwifi/rtl8192se/fw.c
index 3fda6b1..18d5ee9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -273,7 +273,7 @@ static bool _rtl92s_firmware_checkready(struct ieee8021=
1_hw *hw,
=20
 		/* Turn On CPU */
 		rtstatus =3D _rtl92s_firmware_enable_cpu(hw);
-		if (rtstatus !=3D true) {
+		if (!rtstatus) {
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 				 ("Enable CPU fail!\n"));
 			goto status_check_fail;
@@ -445,14 +445,14 @@ int rtl92s_download_fw(struct ieee80211_hw *hw)
 		rtstatus =3D _rtl92s_firmware_downloadcode(hw, puc_mappedfile,
 				ul_filelength);
=20
-		if (rtstatus !=3D true) {
+		if (!rtstatus) {
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("fail!\n"));
 			goto fail;
 		}
=20
 		/* <3> Check whether load FW process is ready */
 		rtstatus =3D _rtl92s_firmware_checkready(hw, fwstatus);
-		if (rtstatus !=3D true) {
+		if (!rtstatus) {
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("fail!\n"));
 			goto fail;
 		}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wire=
less/rtlwifi/rtl8192se/hw.c
index c474486..3ed7e20 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -967,7 +967,7 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	rtlhal->fwcmd_ioparam =3D rtl_read_dword(rtlpriv, LBUS_ADDR_MASK);
=20
 	/* 3. Initialize MAC/PHY Config by MACPHY_reg.txt */
-	if (rtl92s_phy_mac_config(hw) !=3D true) {
+	if (!rtl92s_phy_mac_config(hw)) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("MAC Config failed\n"));
 		return rtstatus;
 	}
@@ -977,7 +977,7 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	rtl_write_dword(rtlpriv, CMDR, 0x37FC);
=20
 	/* 4. Initialize BB After MAC Config PHY_reg.txt, AGC_Tab.txt */
-	if (rtl92s_phy_bb_config(hw) !=3D true) {
+	if (!rtl92s_phy_bb_config(hw)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, ("BB Config failed\n"));
 		return rtstatus;
 	}
@@ -1013,7 +1013,7 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	else
 		rtl_write_byte(rtlpriv, RF_CTRL, 0x07);
=20
-	if (rtl92s_phy_rf_config(hw) !=3D true) {
+	if (!rtl92s_phy_rf_config(hw)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, ("RF Config failed\n"));
 		return rtstatus;
 	}
@@ -1110,7 +1110,7 @@ void rtl92se_set_check_bssid(struct ieee80211_hw *hw,=
 bool check_bssid)
 	if (check_bssid) {
 		reg_rcr |=3D (RCR_CBSSID);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
-	} else if (check_bssid =3D=3D false) {
+	} else if (!check_bssid) {
 		reg_rcr &=3D (~RCR_CBSSID);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
 	}
@@ -1351,7 +1351,7 @@ static void _rtl92se_gen_refreshledstate(struct ieee8=
0211_hw *hw)
 	struct rtl_pci_priv *pcipriv =3D rtl_pcipriv(hw);
 	struct rtl_led *pLed0 =3D &(pcipriv->ledctl.sw_led0);
=20
-	if (rtlpci->up_first_time =3D=3D 1)
+	if (rtlpci->up_first_time)
 		return;
=20
 	if (rtlpriv->psc.rfoff_reason =3D=3D RF_CHANGE_BY_IPS)
@@ -2271,7 +2271,7 @@ bool rtl92se_gpio_radio_on_off_checking(struct ieee80=
211_hw *hw, u8 *valid)
 	bool turnonbypowerdomain =3D false;
=20
 	/* just 8191se can check gpio before firstup, 92c/92d have fixed it */
-	if ((rtlpci->up_first_time =3D=3D 1) || (rtlpci->being_init_adapter))
+	if ((rtlpci->up_first_time) || (rtlpci->being_init_adapter))
 		return false;
=20
 	if (ppsc->swrf_processing)
@@ -2306,7 +2306,7 @@ bool rtl92se_gpio_radio_on_off_checking(struct ieee80=
211_hw *hw, u8 *valid)
 		rfpwr_toset =3D ERFON;
 		ppsc->hwradiooff =3D false;
 		actuallyset =3D true;
-	} else if ((ppsc->hwradiooff =3D=3D false) && (rfpwr_toset =3D=3D ERFOFF)=
) {
+	} else if ((!ppsc->hwradiooff) && (rfpwr_toset =3D=3D ERFOFF)) {
 		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 			 ("RFKILL-HW Radio OFF, RF OFF\n"));
=20
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wir=
eless/rtlwifi/rtl8192se/phy.c
index f10ac1a..5672851 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -558,7 +558,7 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw =
*hw,
 					RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 						 ("IPS Set eRf nic enable\n"));
 					rtstatus =3D rtl_ps_enable_nic(hw);
-				} while ((rtstatus !=3D true) &&
+				} while ((!rtstatus) &&
 					 (InitializeCount < 10));
=20
 				RT_CLEAR_PS_LEVEL(ppsc,
@@ -993,7 +993,7 @@ static bool _rtl92s_phy_bb_config_parafile(struct ieee8=
0211_hw *hw)
 		rtstatus =3D false;
 	}
=20
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
 			 ("Write BB Reg Fail!!"));
 		goto phy_BB8190_Config_ParaFile_Fail;
@@ -1007,7 +1007,7 @@ static bool _rtl92s_phy_bb_config_parafile(struct iee=
e80211_hw *hw)
 		rtstatus =3D _rtl92s_phy_config_bb_with_pg(hw,
 						 BASEBAND_CONFIG_PHY_REG);
 	}
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
 			 ("_rtl92s_phy_bb_config_parafile(): "
 			 "BB_PG Reg Fail!!"));
@@ -1017,7 +1017,7 @@ static bool _rtl92s_phy_bb_config_parafile(struct iee=
e80211_hw *hw)
 	/* 3. BB AGC table Initialization */
 	rtstatus =3D _rtl92s_phy_config_bb(hw, BASEBAND_CONFIG_AGC_TAB);
=20
-	if (rtstatus !=3D true) {
+	if (!rtstatus) {
 		pr_err("%s(): AGC Table Fail\n", __func__);
 		goto phy_BB8190_Config_ParaFile_Fail;
 	}
@@ -1274,7 +1274,7 @@ void rtl92s_phy_set_txpower(struct ieee80211_hw *hw, =
u8	channel)
 	/* [0]:RF-A, [1]:RF-B */
 	u8 cckpowerlevel[2], ofdmpowerLevel[2];
=20
-	if (rtlefuse->txpwr_fromeprom =3D=3D false)
+	if (!rtlefuse->txpwr_fromeprom)
 		return;
=20
 	/* Mainly we use RF-A Tx Power to write the Tx Power registers,
@@ -1635,7 +1635,7 @@ bool rtl92s_phy_set_fw_cmd(struct ieee80211_hw *hw, e=
num fwcmd_iotype fw_cmdio)
 			break;
 		case FW_CMD_HIGH_PWR_ENABLE:
 			if (!(rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) &&
-				(rtlpriv->dm.dynamic_txpower_enable !=3D true)) {
+				(!rtlpriv->dm.dynamic_txpower_enable)) {
 				fw_cmdmap |=3D (FW_HIGH_PWR_ENABLE_CTL |
 					      FW_SS_CTL);
 				FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wire=
less/rtlwifi/rtl8192se/rf.c
index 0ad50fe..8c7035c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -508,7 +508,7 @@ bool rtl92s_phy_rf6052_config(struct ieee80211_hw *hw)
 			break;
 		}
=20
-		if (rtstatus !=3D true) {
+		if (!rtstatus) {
 			pr_err("Radio[%d] Fail!!\n", rfpath);
 			goto fail;
 		}
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp=
_core.c
index 187a199..4055d2e 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -741,7 +741,7 @@ static int one_time_init(void)
 	if (initialized)
 		return 0;
=20
-	power_mode =3D 0;
+	power_mode =3D false;
=20
 	retval =3D init_cpqhp_routing_table();
 	if (retval)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index af295bb..6d63452 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3535,7 +3535,7 @@ int pci_set_vga_state(struct pci_dev *dev, bool decod=
e,
=20
 	if (flags & PCI_VGA_STATE_CHANGE_DECODES) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
-		if (decode =3D=3D true)
+		if (decode)
 			cmd |=3D command_bits;
 		else
 			cmd &=3D ~command_bits;
@@ -3551,7 +3551,7 @@ int pci_set_vga_state(struct pci_dev *dev, bool decod=
e,
 		if (bridge) {
 			pci_read_config_word(bridge, PCI_BRIDGE_CONTROL,
 					     &cmd);
-			if (decode =3D=3D true)
+			if (decode)
 				cmd |=3D PCI_BRIDGE_CTL_VGA;
 			else
 				cmd &=3D ~PCI_BRIDGE_CTL_VGA;
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 849c0c1..3d6b263 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -28,7 +28,7 @@ static bool disable_clkrun;
 module_param(disable_clkrun, bool, 0444);
 MODULE_PARM_DESC(disable_clkrun, "If PC card doesn't function properly, pl=
ease try this option");
=20
-static bool isa_probe =3D 1;
+static bool isa_probe =3D true;
 module_param(isa_probe, bool, 0444);
 MODULE_PARM_DESC(isa_probe, "If set ISA interrupts are probed (default). S=
et to N to disable probing");
=20
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wm=
i.c
index 72d731c..29b45ba 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1220,7 +1220,7 @@ static void asus_wmi_notify(u32 value, void *context)
 	int code;
 	int orig_code;
 	unsigned int key_value =3D 1;
-	bool autorelease =3D 1;
+	bool autorelease =3D true;
=20
 	status =3D wmi_get_event_data(value, &response);
 	if (status !=3D AE_OK) {
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-=
wmi.c
index 9f6e643..b78ce3f 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -93,7 +93,7 @@ static void eeepc_wmi_key_filter(struct asus_wmi_driver *=
asus_wmi, int *code,
 	switch (*code) {
 	case HOME_PRESS:
 		*value =3D 1;
-		*autorelease =3D 0;
+		*autorelease =3D false;
 		break;
 	case HOME_HOLD:
 		*code =3D ASUS_WMI_KEY_IGNORE;
@@ -101,7 +101,7 @@ static void eeepc_wmi_key_filter(struct asus_wmi_driver=
 *asus_wmi, int *code,
 	case HOME_RELEASE:
 		*code =3D HOME_PRESS;
 		*value =3D 0;
-		*autorelease =3D 0;
+		*autorelease =3D false;
 		break;
 	}
 }
diff --git a/drivers/platform/x86/intel_rar_register.c b/drivers/platform/x=
86/intel_rar_register.c
index c8a6aed..d5dac24 100644
--- a/drivers/platform/x86/intel_rar_register.c
+++ b/drivers/platform/x86/intel_rar_register.c
@@ -119,7 +119,7 @@ static struct rar_device *alloc_rar_device(void)
 {
 	if (my_rar_device.allocated)
 		return NULL;
-	my_rar_device.allocated =3D 1;
+	my_rar_device.allocated =3D true;
 	return &my_rar_device;
 }
=20
@@ -132,7 +132,7 @@ static struct rar_device *alloc_rar_device(void)
 static void free_rar_device(struct rar_device *rar)
 {
 	pci_dev_put(rar->rar_dev);
-	rar->allocated =3D 0;
+	rar->allocated =3D false;
 }
=20
 /**
@@ -516,7 +516,7 @@ int register_rar(int num, int (*callback)(unsigned long=
 data),
 		retval =3D -EBUSY;
 		goto done;
 	}
-	c->busy =3D 1;
+	c->busy =3D true;
=20
 	/* See if we have a handler for this RAR yet, if we do then fire it */
 	rar =3D rar_to_device(num, &idx);
@@ -557,7 +557,7 @@ void unregister_rar(int num)
 	if (c =3D=3D NULL || !c->busy)
 		WARN_ON(1);
 	else
-		c->busy =3D 0;
+		c->busy =3D false;
 	mutex_unlock(&rar_mutex);
 }
 EXPORT_SYMBOL(unregister_rar);
@@ -576,7 +576,7 @@ static void rar_callback(struct rar_device *rar)
=20
 	mutex_lock(&rar_mutex);
=20
-	rar->registered =3D 1;	/* Ensure no more callbacks queue */
+	rar->registered =3D true;	/* Ensure no more callbacks queue */
=20
 	for (i =3D 0; i < MRST_NUM_RAR; i++) {
 		if (c->callback && c->busy) {
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-l=
aptop.c
index bb51321..d7684fc 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -870,13 +870,13 @@ static int __init msi_init(void)
 		return -ENODEV;
=20
 	if (force || dmi_check_system(msi_dmi_table))
-		old_ec_model =3D 1;
+		old_ec_model =3D true;
=20
 	if (!old_ec_model)
 		get_threeg_exists();
=20
 	if (!old_ec_model && dmi_check_system(msi_load_scm_models_dmi_table))
-		load_scm_model =3D 1;
+		load_scm_model =3D true;
=20
 	if (auto_brightness < 0 || auto_brightness > 2)
 		return -EINVAL;
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/th=
inkpad_acpi.c
index ea0c607..a5e0973 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3727,7 +3727,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32=
 event)
 			if (tp_features.hotkey_wlsw &&
 					hkey =3D=3D TP_HKEY_EV_RFKILL_CHANGED) {
 				tpacpi_send_radiosw_update();
-				send_acpi_ev =3D 0;
+				send_acpi_ev =3D false;
 				known_ev =3D true;
 				break;
 			}
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/tos=
hiba_acpi.c
index dcdc1f4..bdb4154 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -407,7 +407,7 @@ static int bt_rfkill_set_block(void *data, bool blocked=
)
 	int err;
 	bool radio_state;
=20
-	value =3D (blocked =3D=3D false);
+	value =3D (!blocked);
=20
 	mutex_lock(&dev->mutex);
 	if (hci_get_radio_state(dev, &radio_state) !=3D HCI_SUCCESS) {
diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.=
c
index 3fd3e95..11da3b2 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -236,10 +236,10 @@ static void da9030_set_charge(struct da9030_charger *=
charger, int on)
 		val =3D DA9030_CHRG_CHARGER_ENABLE;
 		val |=3D (charger->charge_milliamp / 100) << 3;
 		val |=3D (charger->charge_millivolt - 4000) / 50;
-		charger->is_on =3D 1;
+		charger->is_on =3D true;
 	} else {
 		val =3D 0;
-		charger->is_on =3D 0;
+		charger->is_on =3D false;
 	}
=20
 	da903x_write(charger->master, DA9030_CHARGE_CONTROL, val);
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e9a83f8..76ff9dd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3005,7 +3005,7 @@ EXPORT_SYMBOL_GPL(regulator_suspend_finish);
  */
 void regulator_has_full_constraints(void)
 {
-	has_full_constraints =3D 1;
+	has_full_constraints =3D true;
 }
 EXPORT_SYMBOL_GPL(regulator_has_full_constraints);
=20
diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-pr=
cmu.c
index 515443f..bb3e0cf 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -238,7 +238,7 @@ static int db8500_regulator_switch_disable(struct regul=
ator_dev *rdev)
 		goto out;
 	}
=20
-	info->is_enabled =3D 0;
+	info->is_enabled =3D false;
 out:
 	return ret;
 }
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 75d8940..67144ae 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -231,7 +231,7 @@ static int __devinit max8952_pmic_probe(struct i2c_clie=
nt *client,
 	if (err) {
 		dev_info(max8952->dev, "EN gpio invalid: assume that EN"
 				"is always High\n");
-		max8952->en =3D 1;
+		max8952->en =3D true;
 		pdata->gpio_en =3D -1; /* Mark invalid */
 	}
=20
@@ -260,8 +260,8 @@ static int __devinit max8952_pmic_probe(struct i2c_clie=
nt *client,
 	if (err) {
 		dev_warn(max8952->dev, "VID0/1 gpio invalid: "
 				"DVS not available.\n");
-		max8952->vid0 =3D 0;
-		max8952->vid1 =3D 0;
+		max8952->vid0 =3D false;
+		max8952->vid1 =3D false;
 		/* Mark invalid */
 		pdata->gpio_vid0 =3D -1;
 		pdata->gpio_vid1 =3D -1;
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index d26e864..27d4e90 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -608,7 +608,7 @@ static int max8997_assess_side_effect(struct regulator_=
dev *rdev,
=20
 			if (others =3D=3D rid)
 				continue;
-			if (buckx_gpiodvs[others] =3D=3D false)
+			if (!buckx_gpiodvs[others])
 				continue; /* Not affected */
 			diff =3D (buckx_val[others])[i] -
 				(buckx_val[others])[max8997->buck125_gpioindex];
@@ -694,7 +694,7 @@ static int max8997_set_voltage_buck(struct regulator_de=
v *rdev,
 	new_idx =3D tmp_idx;
 	new_val =3D tmp_val;
=20
-	if (max8997->ignore_gpiodvs_side_effect =3D=3D false)
+	if (!max8997->ignore_gpiodvs_side_effect)
 		return -EINVAL;
=20
 	dev_warn(&rdev->dev, "MAX8997 GPIO-DVS Side Effect Warning: GPIO SET:"
diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index 6186833..9221383 100644
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -203,7 +203,7 @@ static int isl12022_set_datetime(struct i2c_client *cli=
ent, struct rtc_time *tm)
 				return ret;
 		}
=20
-		isl12022->write_enabled =3D 1;
+		isl12022->write_enabled =3D true;
 	}
=20
 	/* hours, minutes and seconds */
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 9f1d6bc..3143a72 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -447,7 +447,7 @@ static int __devinit pm8xxx_rtc_probe(struct platform_d=
evice *pdev)
 	}
=20
 	rtc_dd->ctrl_reg =3D ctrl_reg;
-	if (rtc_write_enable =3D=3D true)
+	if (rtc_write_enable)
 		pm8xxx_rtc_ops.set_time =3D pm8xxx_rtc_set_time;
=20
 	platform_set_drvdata(pdev, rtc_dd);
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index f3b8bb8..935cdbc 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -75,7 +75,7 @@ static LIST_HEAD(raw3270_devices);
 static int raw3270_registered;
=20
 /* Module parameters */
-static bool tubxcorrect =3D 0;
+static bool tubxcorrect =3D false;
 module_param(tubxcorrect, bool, 0);
=20
 /*
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index b79576b..11f5d82 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -28,7 +28,7 @@ static bool enable_dif;
 module_param_named(dif, enable_dif, bool, 0400);
 MODULE_PARM_DESC(dif, "Enable DIF/DIX data integrity support");
=20
-static bool allow_lun_scan =3D 1;
+static bool allow_lun_scan =3D true;
 module_param(allow_lun_scan, bool, 0600);
 MODULE_PARM_DESC(allow_lun_scan, "For NPIV, scan and attach all storage LU=
Ns");
=20
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ed119ce..5d0503a 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -102,7 +102,7 @@ static int setup_dmaspeed[MAXBOARDS] __initdata =3D { -=
1, -1, -1, -1 };
  */
=20
 #if defined(MODULE)
-static bool isapnp =3D 0;
+static bool isapnp =3D false;
 static int aha1542[] =3D {0x330, 11, 4, -1};
 module_param_array(aha1542, int, NULL, 0);
 module_param(isapnp, bool, 0);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index d3ff9cd..f1ba0d2 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1599,7 +1599,7 @@ static int skb_read_pdu_data(struct iscsi_conn *conn,=
 struct sk_buff *lskb,
 			     struct sk_buff *skb, unsigned int offset)
 {
 	struct iscsi_tcp_conn *tcp_conn =3D conn->dd_data;
-	bool offloaded =3D 0;
+	bool offloaded =3D false;
 	int opcode =3D tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK;
=20
 	log_debug(1 << CXGBI_DBG_PDU_RX,
@@ -1622,7 +1622,7 @@ static int skb_read_pdu_data(struct iscsi_conn *conn,=
 struct sk_buff *lskb,
 		offset +=3D ISCSI_DIGEST_SIZE;
=20
 	if (cxgbi_skcb_test_flag(lskb, SKCBF_RX_DATA_DDPD))
-		offloaded =3D 1;
+		offloaded =3D true;
=20
 	if (opcode =3D=3D ISCSI_OP_SCSI_DATA_IN)
 		log_debug(1 << CXGBI_DBG_PDU_RX,
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 13aeca3..948875e 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -546,7 +546,7 @@ static struct ParameterData __devinitdata cfg_data[] =
=3D {
  * command line overrides will be used. If set to 1 then safe and
  * slow settings will be used.
  */
-static bool use_safe_settings =3D 0;
+static bool use_safe_settings =3D false;
 module_param_named(safe, use_safe_settings, bool, 0);
 MODULE_PARM_DESC(safe, "Use safe and slow settings only. Default: false");
=20
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b96962c..6e44897 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3020,7 +3020,7 @@ static inline bool interrupt_pending(struct ctlr_info=
 *h)
=20
 static inline long interrupt_not_for_us(struct ctlr_info *h)
 {
-	return (h->access.intr_pending(h) =3D=3D 0) ||
+	return (!h->access.intr_pending(h)) ||
 		(h->interrupts_enabled =3D=3D 0);
 }
=20
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 1a65d65..f9c97e8 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -909,7 +909,7 @@ static enum sci_status sci_controller_start_next_phy(st=
ruct isci_host *ihost)
 		/*
 		 * The controller has successfully finished the start process.
 		 * Inform the SCI Core user and transition to the READY state. */
-		if (is_controller_start_complete =3D=3D true) {
+		if (is_controller_start_complete) {
 			sci_controller_transition_to_ready(ihost, SCI_SUCCESS);
 			sci_del_timer(&ihost->phy_timer);
 			ihost->phy_startup_timer_pending =3D false;
diff --git a/drivers/scsi/isci/isci.h b/drivers/scsi/isci/isci.h
index 234ab46..584f24b 100644
--- a/drivers/scsi/isci/isci.h
+++ b/drivers/scsi/isci/isci.h
@@ -502,19 +502,19 @@ void sci_init_timer(struct sci_timer *tmr, void (*fn)=
(unsigned long))
 {
 	tmr->timer.function =3D fn;
 	tmr->timer.data =3D (unsigned long) tmr;
-	tmr->cancel =3D 0;
+	tmr->cancel =3D false;
 	init_timer(&tmr->timer);
 }
=20
 static inline void sci_mod_timer(struct sci_timer *tmr, unsigned long msec=
)
 {
-	tmr->cancel =3D 0;
+	tmr->cancel =3D false;
 	mod_timer(&tmr->timer, jiffies + msecs_to_jiffies(msec));
 }
=20
 static inline void sci_del_timer(struct sci_timer *tmr)
 {
-	tmr->cancel =3D 1;
+	tmr->cancel =3D true;
 	del_timer(&tmr->timer);
 }
=20
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 7c6ac58..a509d4b 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -690,7 +690,7 @@ void sci_port_deactivate_phy(struct isci_port *iport, s=
truct isci_phy *iphy,
 		writel(iphy->phy_index,
 			&iport->port_pe_configuration_register[iphy->phy_index]);
=20
-	if (do_notify_user =3D=3D true)
+	if (do_notify_user)
 		isci_port_link_down(ihost, iphy, iport);
 }
=20
@@ -1141,7 +1141,7 @@ enum sci_status sci_port_start(struct isci_port *ipor=
t)
 		 * the port's phy mask is in fact legal and supported by the
 		 * silicon.
 		 */
-		if (sci_port_is_phy_mask_valid(iport, phy_mask) =3D=3D true) {
+		if (sci_port_is_phy_mask_valid(iport, phy_mask)) {
 			port_state_machine_change(iport,
 						  SCI_PORT_READY);
=20
diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_confi=
g.c
index 6d1e954..9559837 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -566,7 +566,7 @@ static void sci_apc_agent_configure_ports(struct isci_h=
ost *ihost,
 	 * Since we have gone through a timeout we are going to restrict the
 	 * choice to the smallest possible port. */
 	if (
-		(start_timer =3D=3D false)
+		(!start_timer)
 		&& (apc_activity =3D=3D SCIC_SDS_APC_START_TIMER)
 		) {
 		apc_activity =3D SCIC_SDS_APC_ADD_PHY;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 23a2759..2560faf 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11347,7 +11347,7 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba,=
 struct lpfc_queue *cq,
 		}
 	}
 	/* Report warning log message if no match found */
-	if (wqid_matched !=3D true)
+	if (!wqid_matched)
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"2580 Fast-path wqe consume event carries "
 				"miss-matched qid: wcqe-qid=3Dx%x\n", fcp_wqid);
@@ -11697,7 +11697,7 @@ lpfc_sli4_intr_handler(int irq, void *dev_id)
 			fp_handled |=3D true;
 	}
=20
-	return (fp_handled =3D=3D true) ? IRQ_HANDLED : sp_irq_rc;
+	return (fp_handled) ? IRQ_HANDLED : sp_irq_rc;
 } /* lpfc_sli4_intr_handler */
=20
 /**
@@ -14217,7 +14217,7 @@ lpfc_sli4_handle_unsol_abort(struct lpfc_vport *vpo=
rt,
 		abts_par =3D lpfc_sli4_abort_partial_seq(vport, dmabuf);
=20
 		/* Send abort to ULP if partially seq abort failed */
-		if (abts_par =3D=3D false)
+		if (!abts_par)
 			lpfc_sli4_send_seq_to_ulp(vport, dmabuf);
 		else
 			lpfc_in_buf_free(phba, &dmabuf->dbuf);
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 0029249..8fb9387 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -59,11 +59,11 @@ MODULE_PARM_DESC(trans_mode, "transfer mode (0: BIOS(de=
fault) 1: Async 2: Ultra2
 #define ASYNC_MODE    1
 #define ULTRA20M_MODE 2
=20
-static bool      auto_param =3D 0;	/* default: ON */
+static bool      auto_param =3D false;	/* default: ON */
 module_param     (auto_param, bool, 0);
 MODULE_PARM_DESC(auto_param, "AutoParameter mode (0: ON(default) 1: OFF)")=
;
=20
-static bool      disc_priv  =3D 1;	/* default: OFF */
+static bool      disc_priv  =3D true;	/* default: OFF */
 module_param     (disc_priv, bool, 0);
 MODULE_PARM_DESC(disc_priv,  "disconnection privilege mode (0: ON 1: OFF(d=
efault))");
=20
@@ -373,7 +373,7 @@ static void nsp32_build_identify(struct scsi_cmnd *SCpn=
t)
 	int mode            =3D FALSE;
=20
 	/* XXX: Auto DiscPriv detection is progressing... */
-	if (disc_priv =3D=3D 0) {
+	if (!disc_priv) {
 		/* mode =3D TRUE; */
 	}
=20
@@ -1035,7 +1035,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *S=
Cpnt, void (*done)(struct s
 		  target->ackwidth);
=20
 	/* Selection */
-	if (auto_param =3D=3D 0) {
+	if (!auto_param) {
 		ret =3D nsp32_selection_autopara(SCpnt);
 	} else {
 		ret =3D nsp32_selection_autoscsi(SCpnt);
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index b61a753..5f42b10 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -70,7 +70,7 @@ module_param(nsp_burst_mode, int, 0);
 MODULE_PARM_DESC(nsp_burst_mode, "Burst transfer mode (0=3Dio8, 1=3Dio32, =
2=3Dmem32(default))");
=20
 /* Release IO ports after configuration? */
-static bool       free_ports =3D 0;
+static bool       free_ports =3D false;
 module_param(free_ports, bool, 0);
 MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (defau=
lt: 0 (=3Dno))");
=20
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 7264116..0c47a67 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -795,7 +795,7 @@ static int pvscsi_host_reset(struct scsi_cmnd *cmd)
 	use_msg =3D adapter->use_msg;
=20
 	if (use_msg) {
-		adapter->use_msg =3D 0;
+		adapter->use_msg =3D false;
 		spin_unlock_irqrestore(&adapter->hw_lock, flags);
=20
 		/*
@@ -1095,10 +1095,10 @@ static void pvscsi_shutdown_intr(struct pvscsi_adap=
ter *adapter)
 	}
 	if (adapter->use_msi) {
 		pci_disable_msi(adapter->dev);
-		adapter->use_msi =3D 0;
+		adapter->use_msi =3D false;
 	} else if (adapter->use_msix) {
 		pci_disable_msix(adapter->dev);
-		adapter->use_msix =3D 0;
+		adapter->use_msix =3D false;
 	}
 }
=20
@@ -1300,10 +1300,10 @@ static int __devinit pvscsi_probe(struct pci_dev *p=
dev,
 	if (!pvscsi_disable_msix &&
 	    pvscsi_setup_msix(adapter, &adapter->irq) =3D=3D 0) {
 		printk(KERN_INFO "vmw_pvscsi: using MSI-X\n");
-		adapter->use_msix =3D 1;
+		adapter->use_msix =3D true;
 	} else if (!pvscsi_disable_msi && pci_enable_msi(pdev) =3D=3D 0) {
 		printk(KERN_INFO "vmw_pvscsi: using MSI\n");
-		adapter->use_msi =3D 1;
+		adapter->use_msi =3D true;
 		adapter->irq =3D pdev->irq;
 	} else {
 		printk(KERN_INFO "vmw_pvscsi: using INTx\n");
diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index bec81c2..113486a 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -560,7 +560,7 @@ static void maple_response_none(struct maple_device *md=
ev)
 		return;
 	} else {
 		if (!started || !fullscan) {
-			if (checked[mdev->port] =3D=3D false) {
+			if (!checked[mdev->port]) {
 				checked[mdev->port] =3D true;
 				empty[mdev->port] =3D true;
 				dev_info(&mdev->dev, "no devices"
@@ -579,7 +579,7 @@ static void maple_response_devinfo(struct maple_device =
*mdev,
 {
 	char submask;
 	if (!started || (scanning =3D=3D 2) || !fullscan) {
-		if ((mdev->unit =3D=3D 0) && (checked[mdev->port] =3D=3D false)) {
+		if ((mdev->unit =3D=3D 0) && (!checked[mdev->port])) {
 			checked[mdev->port] =3D true;
 			maple_attach_driver(mdev);
 		} else {
@@ -618,7 +618,7 @@ static void maple_port_rescan(void)
=20
 	fullscan =3D 1;
 	for (i =3D 0; i < MAPLE_PORTS; i++) {
-		if (checked[i] =3D=3D false) {
+		if (!checked[i]) {
 			fullscan =3D 0;
 			mdev =3D baseunits[i];
 			maple_add_packet(mdev, 0, MAPLE_COMMAND_DEVINFO,
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 24cacff..70cc14b 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -329,21 +329,21 @@ static int fsl_spi_cpm_bufs(struct mpc8xxx_spi *mspi,
 	struct fsl_spi_reg *reg_base =3D mspi->reg_base;
=20
 	if (is_dma_mapped) {
-		mspi->map_tx_dma =3D 0;
-		mspi->map_rx_dma =3D 0;
+		mspi->map_tx_dma =3D false;
+		mspi->map_rx_dma =3D false;
 	} else {
-		mspi->map_tx_dma =3D 1;
-		mspi->map_rx_dma =3D 1;
+		mspi->map_tx_dma =3D true;
+		mspi->map_rx_dma =3D true;
 	}
=20
 	if (!t->tx_buf) {
 		mspi->tx_dma =3D mspi->dma_dummy_tx;
-		mspi->map_tx_dma =3D 0;
+		mspi->map_tx_dma =3D false;
 	}
=20
 	if (!t->rx_buf) {
 		mspi->rx_dma =3D mspi->dma_dummy_rx;
-		mspi->map_rx_dma =3D 0;
+		mspi->map_rx_dma =3D false;
 	}
=20
 	if (mspi->map_tx_dma) {
diff --git a/drivers/spi/spi-ti-ssp.c b/drivers/spi/spi-ti-ssp.c
index 3f6f6e8..02a2ffe 100644
--- a/drivers/spi/spi-ti-ssp.c
+++ b/drivers/spi/spi-ti-ssp.c
@@ -362,11 +362,11 @@ static int __devexit ti_ssp_spi_remove(struct platfor=
m_device *pdev)
 	struct ti_ssp_spi *hw =3D platform_get_drvdata(pdev);
 	int error;
=20
-	hw->shutdown =3D 1;
+	hw->shutdown =3D true;
 	while (!list_empty(&hw->msg_queue)) {
 		error =3D wait_for_completion_interruptible(&hw->complete);
 		if (error < 0) {
-			hw->shutdown =3D 0;
+			hw->shutdown =3D false;
 			return error;
 		}
 	}
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index bb6317f..8b467ad 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -45,7 +45,7 @@ static DEFINE_MUTEX(buses_mutex);
  * these initializations to after early boot has finished.
  * It's also used to avoid mutex locking, as that's not
  * available and needed early. */
-static bool ssb_is_early_boot =3D 1;
+static bool ssb_is_early_boot =3D true;
=20
 static void ssb_buses_lock(void);
 static void ssb_buses_unlock(void);
@@ -256,7 +256,7 @@ int ssb_devices_freeze(struct ssb_bus *bus, struct ssb_=
freeze_context *ctx)
 			continue;
 		}
 		sdrv->remove(sdev);
-		ctx->device_frozen[i] =3D 1;
+		ctx->device_frozen[i] =3D true;
 	}
=20
 	return 0;
@@ -1437,7 +1437,7 @@ static int __init ssb_modinit(void)
 	int err;
=20
 	/* See the comment at the ssb_is_early_boot definition */
-	ssb_is_early_boot =3D 0;
+	ssb_is_early_boot =3D false;
 	err =3D bus_register(&ssb_bustype);
 	if (err)
 		return err;
diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index c821c6b..96db3ce 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -546,7 +546,7 @@ static int ssb_pcmcia_sprom_read_all(struct ssb_bus *bu=
s, u16 *sprom)
 static int ssb_pcmcia_sprom_write_all(struct ssb_bus *bus, const u16 *spro=
m)
 {
 	int i, err;
-	bool failed =3D 0;
+	bool failed =3D false;
 	size_t size =3D SSB_PCMCIA_SPROM_SIZE;
=20
 	ssb_printk(KERN_NOTICE PFX
@@ -573,7 +573,7 @@ static int ssb_pcmcia_sprom_write_all(struct ssb_bus *b=
us, const u16 *sprom)
 		if (err) {
 			ssb_printk(KERN_NOTICE PFX
 				   "Failed to write to SPROM.\n");
-			failed =3D 1;
+			failed =3D true;
 			break;
 		}
 	}
@@ -581,7 +581,7 @@ static int ssb_pcmcia_sprom_write_all(struct ssb_bus *b=
us, const u16 *sprom)
 	if (err) {
 		ssb_printk(KERN_NOTICE PFX
 			   "Could not disable SPROM write access.\n");
-		failed =3D 1;
+		failed =3D true;
 	}
 	msleep(500);
 	if (!failed) {
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/=
comedi_fops.c
index 9bcf87a..209cd0b 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -61,7 +61,7 @@ EXPORT_SYMBOL(comedi_debug);
 module_param(comedi_debug, int, 0644);
 #endif
=20
-bool comedi_autoconfig =3D 1;
+bool comedi_autoconfig =3D true;
 module_param(comedi_autoconfig, bool, 0444);
=20
 static int comedi_num_legacy_minors;
@@ -2027,7 +2027,7 @@ static int __init comedi_init(void)
 	 * comedi_num_legacy_minors are zero, so we might as well adjust the
 	 * defaults in that case
 	 */
-	if (comedi_autoconfig =3D=3D 0 && comedi_num_legacy_minors =3D=3D 0)
+	if (!comedi_autoconfig && comedi_num_legacy_minors =3D=3D 0)
 		comedi_num_legacy_minors =3D 16;
=20
 	memset(comedi_file_info_table, 0,
diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/c=
ptm1217/clearpad_tm1217.c
index 5456f82..02d2d33 100644
--- a/drivers/staging/cptm1217/clearpad_tm1217.c
+++ b/drivers/staging/cptm1217/clearpad_tm1217.c
@@ -253,22 +253,22 @@ static void cp_tm1217_get_data(struct cp_tm1217_devic=
e *ts)
 		for (i =3D 0; i < TOUCH_SUPPORTED; i++) {
 			if (req[1] & 0x3) {
 				finger_touched++;
-				if (ts->cp_input_info[i].touch.button =3D=3D 0) {
+				if (!ts->cp_input_info[i].touch.button) {
 					/* send the button touch event */
 					input_report_key(
 						ts->cp_input_info[i].input,
 						BTN_TOUCH, 1);
-					ts->cp_input_info[i].touch.button =3D 1;
+					ts->cp_input_info[i].touch.button =3D true;
 				}
 				process_touch(ts, i);
 			} else {
-				if (ts->cp_input_info[i].touch.button =3D=3D 1) {
+				if (ts->cp_input_info[i].touch.button) {
 					/* send the button release event */
 					input_report_key(
 						ts->cp_input_info[i].input,
 						BTN_TOUCH, 0);
 					input_sync(ts->cp_input_info[i].input);
-					ts->cp_input_info[i].touch.button =3D 0;
+					ts->cp_input_info[i].touch.button =3D false;
 				}
 			}
 			req[1] =3D req[1] >> 2;
diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/cry=
stalhd/crystalhd_hw.c
index 5acf39e..75c6be6 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -1469,7 +1469,7 @@ static void crystalhd_rx_isr(struct crystalhd_hw *hw,=
 uint32_t intr_sts)
 	uint32_t i, list_avail =3D 0;
 	enum BC_STATUS comp_sts =3D BC_STS_NO_DATA;
 	uint32_t y_err_sts, uv_err_sts, y_dn_sz =3D 0, uv_dn_sz =3D 0;
-	bool ret =3D 0;
+	bool ret =3D false;
=20
 	if (!hw) {
 		BCMLOG_ERR("Invalid Arguments\n");
@@ -1800,7 +1800,7 @@ bool crystalhd_hw_interrupt(struct crystalhd_adp *adp=
, struct crystalhd_hw *hw)
 {
 	uint32_t intr_sts =3D 0;
 	uint32_t deco_intr =3D 0;
-	bool rc =3D 0;
+	bool rc =3D false;
=20
 	if (!adp || !hw->dev_started)
 		return rc;
@@ -1813,7 +1813,7 @@ bool crystalhd_hw_interrupt(struct crystalhd_adp *adp=
, struct crystalhd_hw *hw)
=20
 	if (intr_sts) {
 		/* let system know we processed interrupt..*/
-		rc =3D 1;
+		rc =3D true;
 		hw->stats.dev_interrupts++;
 	}
=20
@@ -1833,7 +1833,7 @@ bool crystalhd_hw_interrupt(struct crystalhd_adp *adp=
, struct crystalhd_hw *hw)
 		bc_dec_reg_wr(adp, Stream2Host_Intr_Sts, deco_intr);
 		/* FIXME: jarod: No udelay? might this be the real reason mini pci-e car=
ds were stalling out? */
 		bc_dec_reg_wr(adp, Stream2Host_Intr_Sts, 0);
-		rc =3D 1;
+		rc =3D true;
 	}
=20
 	/* Rx interrupts */
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131=
x.c
index 2c4069f..79dbcd5 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -838,11 +838,11 @@ static int et131x_init_eeprom(struct et131x_adapter *=
adapter)
 			 * gather additional information that normally would
 			 * come from the eeprom, like MAC Address
 			 */
-			adapter->has_eeprom =3D 0;
+			adapter->has_eeprom =3D false;
 			return -EIO;
 		}
 	}
-	adapter->has_eeprom =3D 1;
+	adapter->has_eeprom =3D true;
=20
 	/* Read the EEPROM for information regarding LED behavior. Refer to
 	 * ET1310_phy.c, et131x_xcvr_init(), for its use.
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/s=
taging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index f8b8e71..9e0929c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -304,7 +304,7 @@ int card_download(struct net_device *dev, const u8 *pFi=
leStart,
 	struct dsp_file_hdr *pFileHdr5;
 	struct dsp_image_info *pDspImageInfoV6 =3D NULL;
 	long requested_version;
-	bool bGoodVersion =3D 0;
+	bool bGoodVersion =3D false;
 	struct drv_msg *pMailBoxData;
 	u16 *pUsData =3D NULL;
 	u16 *pUsFile =3D NULL;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/stagin=
g/ft1000/ft1000-usb/ft1000_hw.c
index 43b1d36..d24f4ea 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -633,9 +633,9 @@ static int ft1000_reset_card(struct net_device *dev)
=20
 	DEBUG("ft1000_hw:ft1000_reset_card called.....\n");
=20
-	info->fCondResetPend =3D 1;
+	info->fCondResetPend =3D true;
 	info->CardReady =3D 0;
-	info->fProvComplete =3D 0;
+	info->fProvComplete =3D false;
=20
 	/* Make sure we free any memory reserve for provisioning */
 	while (list_empty(&info->prov_list) =3D=3D 0) {
@@ -666,7 +666,7 @@ static int ft1000_reset_card(struct net_device *dev)
=20
 	info->CardReady =3D 1;
=20
-	info->fCondResetPend =3D 0;
+	info->fCondResetPend =3D false;
=20
 	return TRUE;
 }
@@ -752,8 +752,8 @@ int init_ft1000_netdev(struct ft1000_device *ft1000dev)
 	pInfo->DSP_TIME[1] =3D 0;
 	pInfo->DSP_TIME[2] =3D 0;
 	pInfo->DSP_TIME[3] =3D 0;
-	pInfo->fAppMsgPend =3D 0;
-	pInfo->fCondResetPend =3D 0;
+	pInfo->fAppMsgPend =3D false;
+	pInfo->fCondResetPend =3D false;
 	pInfo->usbboot =3D 0;
 	pInfo->dspalive =3D 0;
 	memset(&pInfo->tempbuf[0], 0, sizeof(pInfo->tempbuf));
@@ -1444,7 +1444,7 @@ static int ft1000_dsp_prov(void *arg)
=20
 	msleep(100);
=20
-	info->fProvComplete =3D 1;
+	info->fProvComplete =3D true;
 	info->CardReady =3D 1;
=20
 	return STATUS_SUCCESS;
@@ -1570,12 +1570,12 @@ static int ft1000_proc_drvmsg(struct ft1000_device =
*dev, u16 size)
 			 * Send provisioning data to DSP
 			 */
 			if (list_empty(&info->prov_list) =3D=3D 0) {
-				info->fProvComplete =3D 0;
+				info->fProvComplete =3D false;
 				status =3D ft1000_dsp_prov(dev);
 				if (status !=3D STATUS_SUCCESS)
 					goto out;
 			} else {
-				info->fProvComplete =3D 1;
+				info->fProvComplete =3D true;
 				status =3D
 				    ft1000_write_register(dev, FT1000_DB_HB,
 							  FT1000_REG_DOORBELL);
@@ -1924,7 +1924,7 @@ int ft1000_poll(void* dev_id) {
         else if (tempword & FT1000_DB_COND_RESET) {
             DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_=
DB_COND_RESET\n");
=20
-	    if (info->fAppMsgPend =3D=3D 0) {
+	    if (!info->fAppMsgPend) {
                // Reset ASIC and DSP
=20
                 status    =3D ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIME=
R0, (u8 *)&(info->DSP_TIME[0]), FT1000_MAG_DSP_TIMER0_INDX);
@@ -1937,8 +1937,8 @@ int ft1000_poll(void* dev_id) {
                 info->ft1000_reset(dev->net);
             }
             else {
-                info->fProvComplete =3D 0;
-                info->fCondResetPend =3D 1;
+                info->fProvComplete =3D false;
+                info->fCondResetPend =3D true;
             }
=20
             ft1000_write_register(dev, FT1000_DB_COND_RESET, FT1000_REG_DO=
ORBELL);
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_=
drv.c
index eb853f7..ad4df99 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1279,7 +1279,7 @@ static int storvsc_queuecommand(struct Scsi_Host *hos=
t, struct scsi_cmnd *scmnd)
 	struct vmscsi_request *vm_srb;
 	struct stor_mem_pools *memp =3D scmnd->device->hostdata;
=20
-	if (storvsc_check_scsi_cmd(scmnd) =3D=3D false) {
+	if (!storvsc_check_scsi_cmd(scmnd)) {
 		scmnd->scsi_done(scmnd);
 		return 0;
 	}
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/i=
io/accel/lis3l02dq_ring.c
index 98c5c92..f7d5e9a 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -237,7 +237,7 @@ static int lis3l02dq_data_rdy_trigger_set_state(struct =
iio_trigger *trig,
 	u8 t;
=20
 	__lis3l02dq_write_data_ready_config(&indio_dev->dev, state);
-	if (state =3D=3D false) {
+	if (!state) {
 		/*
 		 * A possible quirk with teh handler is currently worked around
 		 *  by ensuring outstanding read events are cleared.
diff --git a/drivers/staging/iio/accel/sca3000_ring.c b/drivers/staging/iio=
/accel/sca3000_ring.c
index 6b824a1..16779f1 100644
--- a/drivers/staging/iio/accel/sca3000_ring.c
+++ b/drivers/staging/iio/accel/sca3000_ring.c
@@ -126,7 +126,7 @@ static int sca3000_read_first_n_hw_rb(struct iio_buffer=
 *r,
 	if (copy_to_user(buf, rx, num_read))
 		ret =3D -EFAULT;
 	kfree(rx);
-	r->stufftoread =3D 0;
+	r->stufftoread =3D false;
 error_ret:
 	mutex_unlock(&st->lock);
=20
@@ -262,7 +262,7 @@ static struct iio_buffer *sca3000_rb_allocate(struct ii=
o_dev *indio_dev)
=20
 	ring->private =3D indio_dev;
 	buf =3D &ring->buf;
-	buf->stufftoread =3D 0;
+	buf->stufftoread =3D false;
 	buf->attrs =3D &sca3000_ring_attr;
 	iio_buffer_init(buf);
=20
diff --git a/drivers/staging/iio/dac/ad5686.c b/drivers/staging/iio/dac/ad5=
686.c
index ce2d619..e26b8a3 100644
--- a/drivers/staging/iio/dac/ad5686.c
+++ b/drivers/staging/iio/dac/ad5686.c
@@ -233,7 +233,7 @@ static ssize_t ad5686_write_dac_powerdown(struct device=
 *dev,
 	if (ret)
 		return ret;
=20
-	if (readin =3D=3D true)
+	if (readin)
 		st->pwr_down_mask |=3D (0x3 << (this_attr->address * 2));
 	else
 		st->pwr_down_mask &=3D ~(0x3 << (this_attr->address * 2));
diff --git a/drivers/staging/iio/iio_dummy_evgen.c b/drivers/staging/iio/ii=
o_dummy_evgen.c
index cdbf289..756c8ab 100644
--- a/drivers/staging/iio/iio_dummy_evgen.c
+++ b/drivers/staging/iio/iio_dummy_evgen.c
@@ -108,7 +108,7 @@ int iio_dummy_evgen_get_irq(void)
=20
 	mutex_lock(&iio_evgen->lock);
 	for (i =3D 0; i < IIO_EVENTGEN_NO; i++)
-		if (iio_evgen->inuse[i] =3D=3D false) {
+		if (!iio_evgen->inuse[i]) {
 			ret =3D iio_evgen->base + i;
 			iio_evgen->inuse[i] =3D true;
 			break;
diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/ii=
o/magnetometer/ak8975.c
index 3158f12..0147b59 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -355,7 +355,7 @@ static int ak8975_read_axis(struct iio_dev *indio_dev, =
int index, int *val)
=20
 	mutex_lock(&data->lock);
=20
-	if (data->mode =3D=3D 0) {
+	if (!data->mode) {
 		dev_err(&client->dev, "Operating mode is in power down mode\n");
 		ret =3D -EBUSY;
 		goto exit;
diff --git a/drivers/staging/media/easycap/easycap_ioctl.c b/drivers/stagin=
g/media/easycap/easycap_ioctl.c
index 9413b37..960d089 100644
--- a/drivers/staging/media/easycap/easycap_ioctl.c
+++ b/drivers/staging/media/easycap/easycap_ioctl.c
@@ -501,7 +501,7 @@ int adjust_format(struct easycap *peasycap,
 		return peasycap_best_format - easycap_format;
 /*........................................................................=
...*/
=20
-	if (false !=3D try) {
+	if (try) {
 		SAM("MISTAKE: true=3D=3Dtry where is should be false\n");
 		return -EINVAL;
 	}
diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/stagin=
g/media/lirc/lirc_igorplugusb.c
index 7a25017..19e0402 100644
--- a/drivers/staging/media/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
@@ -62,7 +62,7 @@
=20
 /* debugging support */
 #ifdef CONFIG_USB_DEBUG
-static bool debug =3D 1;
+static bool debug =3D true;
 #else
 static bool debug;
 #endif
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/med=
ia/lirc/lirc_serial.c
index 8dd8897..50e2571 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -109,7 +109,7 @@ static int io;
 static int irq;
 static bool iommap;
 static int ioshift;
-static bool softcarrier =3D 1;
+static bool softcarrier =3D true;
 static bool share_irq;
 static bool debug;
 static int sense =3D -1;	/* -1 =3D auto, 0 =3D active high, 1 =3D active l=
ow */
@@ -289,7 +289,7 @@ static unsigned long space_width;
 /* fetch serial input packet (1 byte) from register offset */
 static u8 sinp(int offset)
 {
-	if (iommap !=3D 0)
+	if (iommap)
 		/* the register is memory-mapped */
 		offset <<=3D ioshift;
=20
@@ -299,7 +299,7 @@ static u8 sinp(int offset)
 /* write serial output packet (1 byte) of value to register offset */
 static void soutp(int offset, u8 value)
 {
-	if (iommap !=3D 0)
+	if (iommap)
 		/* the register is memory-mapped */
 		offset <<=3D ioshift;
=20
@@ -859,10 +859,10 @@ static int __devinit lirc_serial_probe(struct platfor=
m_device *dev)
 	 * For memory mapped I/O you *might* need to use ioremap() first,
 	 * for the NSLU2 it's done in boot code.
 	 */
-	if (((iommap !=3D 0)
+	if (((iommap)
 	     && (request_mem_region(iommap, 8 << ioshift,
 				    LIRC_DRIVER_NAME) =3D=3D NULL))
-	   || ((iommap =3D=3D 0)
+	   || ((!iommap)
 	       && (request_region(io, 8, LIRC_DRIVER_NAME) =3D=3D NULL))) {
 		printk(KERN_ERR  LIRC_DRIVER_NAME
 		       ": port %04x already in use\n", io);
@@ -912,7 +912,7 @@ static int __devinit lirc_serial_probe(struct platform_=
device *dev)
 	return 0;
=20
 exit_release_region:
-	if (iommap !=3D 0)
+	if (iommap)
 		release_mem_region(iommap, 8 << ioshift);
 	else
 		release_region(io, 8);
@@ -926,7 +926,7 @@ static int __devexit lirc_serial_remove(struct platform=
_device *dev)
 {
 	free_irq(irq, (void *)&hardware);
=20
-	if (iommap !=3D 0)
+	if (iommap)
 		release_mem_region(iommap, 8 << ioshift);
 	else
 		release_region(io, 8);
diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrup=
t.c
index 3544fee..2da23e1 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -81,7 +81,7 @@ static void _mei_cmpl(struct mei_cl *cl, struct mei_cl_cb=
 *cb_pos)
  */
 static void _mei_cmpl_iamthif(struct mei_device *dev, struct mei_cl_cb *cb=
_pos)
 {
-	if (dev->iamthif_canceled !=3D 1) {
+	if (!dev->iamthif_canceled) {
 		dev->iamthif_state =3D MEI_IAMTHIF_READ_COMPLETE;
 		dev->iamthif_stall_timer =3D 0;
 		memcpy(cb_pos->response_buffer.data,
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_d=
con/olpc_dcon.c
index 3d91993..3a8a8e2 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -313,7 +313,7 @@ static void dcon_source_switch(struct work_struct *work=
)
 		else {
 			/* Wait up to one second for the scanline interrupt */
 			wait_event_timeout(dcon_wait_queue,
-					   dcon->switched =3D=3D true, HZ);
+					   dcon->switched, HZ);
 		}
=20
 		if (!dcon->switched)
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/=
quatech_usb2/quatech_usb2.c
index 897a3a9..2dfde59 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -807,7 +807,7 @@ static int qt2_write_room(struct tty_struct *tty)
 	int room =3D 0;
 	port_extra =3D qt2_get_port_private(port);
=20
-	if (port_extra->close_pending =3D=3D true) {
+	if (port_extra->close_pending) {
 		dbg("%s(): port_extra->close_pending =3D=3D true", __func__);
 		return -ENODEV;
 	}
@@ -1274,7 +1274,7 @@ static void qt2_unthrottle(struct tty_struct *tty)
 		/* Send command to box to start receiving stuff */
 		if (serial->dev->descriptor.idProduct !=3D QUATECH_SSU2_100) {
 			qt2_boxstoprx(serial,  port->number, 0);
-		} else if (dev_extra->ReadBulkStopped =3D=3D true) {
+		} else if (dev_extra->ReadBulkStopped) {
 			usb_fill_bulk_urb(port0->read_urb, serial->dev,
 				usb_rcvbulkpipe(serial->dev,
 				port0->bulk_in_endpointAddress),
@@ -1489,7 +1489,7 @@ __func__);
  * would it know to do so?).
  */
=20
-	if (active_extra->close_pending =3D=3D true) {
+	if (active_extra->close_pending) {
 		/* We are closing , stop reading */
 		dbg("%s - (active->close_pending =3D=3D true", __func__);
 		if (dev_extra->open_ports <=3D 0) {
@@ -1640,7 +1640,7 @@ __func__);
 					i +=3D 1;
 					break;
 				} /*end switch*/
-				if (escapeflag =3D=3D true)
+				if (escapeflag)
 					continue;
 				/* if we did an escape char, we don't need
 				 * to mess around pushing data through the
@@ -1866,7 +1866,7 @@ static int qt2_boxsethw_flowctl(struct usb_serial *se=
rial,
 	__u8 MSR_Value =3D 0;
 	__u16 MOUT_Value =3D 0;
=20
-	if (bSet =3D=3D true) {
+	if (bSet) {
 		MCR_Value =3D  QT2_SERIAL_MCR_RTS;
 		/* flow control, box will clear RTS line to prevent remote
 		 * device from transmitting more chars */
@@ -1876,7 +1876,7 @@ static int qt2_boxsethw_flowctl(struct usb_serial *se=
rial,
 	}
 	MOUT_Value =3D MCR_Value << 8;
=20
-	if (bSet =3D=3D true) {
+	if (bSet) {
 		MSR_Value =3D QT2_SERIAL_MSR_CTS;
 		/* flow control on, box will inhibit tx data if CTS line is
 		 * asserted */
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl81=
87se/r8180_core.c
index 04c2391..b285c42 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2462,7 +2462,7 @@ void watch_dog_adaptive(unsigned long data)
 		TxPwrTracking87SE((struct net_device *)data);
=20
 	/* Perform DIG immediately. */
-	if (CheckDig((struct net_device *)data) =3D=3D true)
+	if (CheckDig((struct net_device *)data))
 		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->hw_dig_wq);
 	rtl8180_watch_dog((struct net_device *)data);
=20
@@ -2520,7 +2520,7 @@ static void rtl8180_set_channel_map(u8 channel_plan, =
struct ieee80211_device *ie
 		}
 	case COUNTRY_CODE_GLOBAL_DOMAIN:
 		{
-			GET_DOT11D_INFO(ieee)->bEnabled =3D 0;
+			GET_DOT11D_INFO(ieee)->bEnabled =3D false;
 			Dot11d_Reset(ieee);
 			ieee->bGlobalDomain =3D true;
 			break;
@@ -2682,7 +2682,7 @@ short rtl8180_init(struct net_device *dev)
 	init_timer(&priv->SwAntennaDiversityTimer);
 	priv->SwAntennaDiversityTimer.data =3D (unsigned long)dev;
 	priv->SwAntennaDiversityTimer.function =3D (void *)SwAntennaDiversityTime=
rCallback;
-	priv->bDigMechanism =3D 1;
+	priv->bDigMechanism =3D true;
 	priv->InitialGain =3D 6;
 	priv->bXtalCalibration =3D false;
 	priv->XtalCal_Xin =3D 0;
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c b/drivers/s=
taging/rtl8192e/rtl8192e/r8190P_rtl8256.c
index 0da56c8..5af1c19 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c
@@ -140,7 +140,7 @@ bool phy_RF8256_Config_ParaFile(struct net_device *dev)
=20
 		rtStatus =3D rtl8192_phy_checkBBAndRF(dev, HW90_BLOCK_RF,
 						(enum rf90_radio_path)eRFPath);
-		if (rtStatus !=3D true) {
+		if (!rtStatus) {
 			RT_TRACE(COMP_ERR, "PHY_RF8256_Config():Check "
 				 "Radio[%d] Fail!!\n", eRFPath);
 			goto phy_RF8256_Config_ParaFile_Fail;
@@ -245,7 +245,7 @@ void PHY_SetRF8256CCKTxPower(struct net_device *dev, u8=
	powerlevel)
 	struct r8192_priv *priv =3D rtllib_priv(dev);
=20
 	TxAGC =3D powerlevel;
-	if (priv->bDynamicTxLowPower =3D=3D true) {
+	if (priv->bDynamicTxLowPower) {
 		if (priv->CustomerID =3D=3D RT_CID_819x_Netcore)
 			TxAGC =3D 0x22;
 		else
@@ -294,7 +294,7 @@ void PHY_SetRF8256OFDMTxPower(struct net_device *dev, u=
8 powerlevel)
 			priv->Pwr_Track =3D writeVal_tmp;
 		}
=20
-		if (priv->bDynamicTxHighPower =3D=3D true)
+		if (priv->bDynamicTxHighPower)
 			writeVal =3D 0x03030303;
 		else
 			writeVal =3D (byte3 << 24) | (byte2 << 16) |
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/stagi=
ng/rtl8192e/rtl8192e/r8192E_dev.c
index 808aab6..5cb1498 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -720,7 +720,7 @@ start:
 	}
 	priv->pFirmware->firmware_status =3D FW_STATUS_0_INIT;
=20
-	if (priv->RegRfOff =3D=3D true)
+	if (priv->RegRfOff)
 		priv->rtllib->eRFPowerState =3D eRfOff;
=20
 	ulRegRead =3D read_nic_dword(dev, CPU_GEN);
@@ -745,7 +745,7 @@ start:
 	}
 	RT_TRACE(COMP_INIT, "BB Config Start!\n");
 	rtStatus =3D rtl8192_BBConfig(dev);
-	if (rtStatus !=3D true) {
+	if (!rtStatus) {
 		RT_TRACE(COMP_ERR, "BB Config failed\n");
 		return rtStatus;
 	}
@@ -856,7 +856,7 @@ start:
 	if (priv->ResetProgress =3D=3D RESET_TYPE_NORESET) {
 		RT_TRACE(COMP_INIT, "RF Config Started!\n");
 		rtStatus =3D rtl8192_phy_RFConfig(dev);
-		if (rtStatus !=3D true) {
+		if (!rtStatus) {
 			RT_TRACE(COMP_ERR, "RF Config failed\n");
 			return rtStatus;
 		}
@@ -869,7 +869,7 @@ start:
=20
 	write_nic_byte(dev, 0x87, 0x0);
=20
-	if (priv->RegRfOff =3D=3D true) {
+	if (priv->RegRfOff) {
 		RT_TRACE((COMP_INIT | COMP_RF | COMP_POWER),
 			  "%s(): Turn off RF for RegRfOff ----------\n",
 			  __func__);
@@ -2208,7 +2208,7 @@ rtl8192_InitializeVariables(struct net_device  *dev)
 	priv->MidHighPwrTHR_L2 =3D 0x40;
 	priv->PwrDomainProtect =3D false;
=20
-	priv->bfirst_after_down =3D 0;
+	priv->bfirst_after_down =3D false;
 }
=20
 void rtl8192_EnableInterrupt(struct net_device *dev)
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/=
staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 3771985..fd2ac83 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -328,7 +328,7 @@ bool init_firmware(struct net_device *dev)
 		}
=20
 		rt_status =3D fw_download_code(dev, mapped_file, file_length);
-		if (rt_status !=3D true) {
+		if (!rt_status) {
 			goto download_firmware_fail;
 		}
=20
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c b/drivers/stagi=
ng/rtl8192e/rtl8192e/r8192E_phy.c
index 3e705ef..7cded98 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
@@ -567,7 +567,7 @@ static bool rtl8192_BB_Config_ParaFile(struct net_devic=
e *dev)
 		rtStatus  =3D rtl8192_phy_checkBBAndRF(dev,
 					 (enum hw90_block)eCheckItem,
 					 (enum rf90_radio_path)0);
-		if (rtStatus !=3D true) {
+		if (!rtStatus) {
 			RT_TRACE((COMP_ERR | COMP_PHY), "PHY_RF8256_Config():"
 				 "Check PHY%d Fail!!\n", eCheckItem-1);
 			return rtStatus;
@@ -1425,7 +1425,7 @@ static bool SetRFPowerState8190(struct net_device *de=
v,
 	u8	i =3D 0, QueueID =3D 0;
 	struct rtl8192_tx_ring  *ring =3D NULL;
=20
-	if (priv->SetRFPowerStateInProgress =3D=3D true)
+	if (priv->SetRFPowerStateInProgress)
 		return false;
 	RT_TRACE(COMP_PS, "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> SetRFPowerState8190=
()!\n");
 	priv->SetRFPowerStateInProgress =3D true;
@@ -1443,10 +1443,10 @@ static bool SetRFPowerState8190(struct net_device *=
dev,
 					InitilizeCount--;
 					priv->RegRfOff =3D false;
 					rtstatus =3D NicIFEnableNIC(dev);
-				} while ((rtstatus !=3D true) &&
+				} while ((!rtstatus) &&
 					 (InitilizeCount > 0));
=20
-				if (rtstatus !=3D true) {
+				if (!rtstatus) {
 					RT_TRACE(COMP_ERR, "%s():Initialize Ada"
 						 "pter fail,return\n",
 						 __func__);
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging=
/rtl8192e/rtl8192e/rtl_core.c
index 71adb6b..cd1822d 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -370,7 +370,7 @@ bool MgntActSet_RF_State(struct net_device *dev,
 		priv->rtllib->RfOffReason &=3D (~ChangeSource);
=20
 		if ((ChangeSource =3D=3D RF_CHANGE_BY_HW) &&
-		    (priv->bHwRadioOff =3D=3D true))
+		    (priv->bHwRadioOff))
 			priv->bHwRadioOff =3D false;
=20
 		if (!priv->rtllib->RfOffReason) {
@@ -405,7 +405,7 @@ bool MgntActSet_RF_State(struct net_device *dev,
 			}
 		}
 		if ((ChangeSource =3D=3D RF_CHANGE_BY_HW) &&
-		     (priv->bHwRadioOff =3D=3D false))
+		     (!priv->bHwRadioOff))
 			priv->bHwRadioOff =3D true;
 		priv->rtllib->RfOffReason |=3D ChangeSource;
 		bActionAllowed =3D true;
@@ -427,7 +427,7 @@ bool MgntActSet_RF_State(struct net_device *dev,
 		PHY_SetRFPowerState(dev, StateToSet);
 		if (StateToSet =3D=3D eRfOn) {
=20
-			if (bConnectBySSID && (priv->blinked_ingpio =3D=3D true)) {
+			if (bConnectBySSID && (priv->blinked_ingpio)) {
 				queue_delayed_work_rsl(ieee->wq,
 					 &ieee->associate_procedure_wq, 0);
 				priv->blinked_ingpio =3D false;
@@ -955,7 +955,7 @@ static int _rtl8192_sta_up(struct net_device *dev, bool=
 is_silent_reset)
 	RT_TRACE(COMP_INIT, "Bringing up iface");
 	priv->bfirst_init =3D true;
 	init_status =3D priv->ops->initialize_adapter(dev);
-	if (init_status !=3D true) {
+	if (!init_status) {
 		RT_TRACE(COMP_ERR, "ERR!!! %s(): initialization is failed!\n",
 			 __func__);
 		priv->bfirst_init =3D false;
@@ -1000,7 +1000,7 @@ static int rtl8192_sta_down(struct net_device *dev, b=
ool shutdownrf)
 	priv->bDriverIsGoingToUnload =3D true;
 	priv->up =3D 0;
 	priv->rtllib->ieee_up =3D 0;
-	priv->bfirst_after_down =3D 1;
+	priv->bfirst_after_down =3D true;
 	RT_TRACE(COMP_DOWN, "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>%s()\n", __func__);
 	if (!netif_queue_stopped(dev))
 		netif_stop_queue(dev);
@@ -1119,8 +1119,8 @@ static void rtl8192_init_priv_variable(struct net_dev=
ice *dev)
 	priv->rtllib->hwscan_sem_up =3D 1;
 	priv->rtllib->status =3D 0;
 	priv->H2CTxCmdSeq =3D 0;
-	priv->bDisableFrameBursting =3D 0;
-	priv->bDMInitialGainEnable =3D 1;
+	priv->bDisableFrameBursting =3D false;
+	priv->bDMInitialGainEnable =3D true;
 	priv->polling_timer_on =3D 0;
 	priv->up_first_time =3D 1;
 	priv->blinked_ingpio =3D false;
@@ -1162,7 +1162,7 @@ static void rtl8192_init_priv_variable(struct net_dev=
ice *dev)
 	priv->CckPwEnl =3D 6;
 	priv->ScanDelay =3D 50;
 	priv->ResetProgress =3D RESET_TYPE_NORESET;
-	priv->bForcedSilentReset =3D 0;
+	priv->bForcedSilentReset =3D false;
 	priv->bDisableNormalResetCheck =3D false;
 	priv->force_reset =3D false;
 	memset(priv->rtllib->swcamtable, 0, sizeof(struct sw_cam_table) * 32);
@@ -1171,7 +1171,7 @@ static void rtl8192_init_priv_variable(struct net_dev=
ice *dev)
 	priv->RxCounter =3D 0;
 	priv->rtllib->wx_set_enc =3D 0;
 	priv->bHwRadioOff =3D false;
-	priv->RegRfOff =3D 0;
+	priv->RegRfOff =3D false;
 	priv->isRFOff =3D false;
 	priv->bInPowerSaveMode =3D false;
 	priv->rtllib->RfOffReason =3D 0;
@@ -1647,7 +1647,7 @@ void	rtl819x_watchdog_wqcallback(void *data)
 	bool	bHigherBusyRxTraffic =3D false;
 	bool bEnterPS =3D false;
=20
-	if (IS_NIC_DOWN(priv) || (priv->bHwRadioOff =3D=3D true))
+	if (IS_NIC_DOWN(priv) || (priv->bHwRadioOff))
 		return;
=20
 	if (priv->rtllib->state >=3D RTLLIB_LINKED) {
@@ -3048,7 +3048,7 @@ bool NicIFEnableNIC(struct net_device *dev)
 	RT_TRACE(COMP_PS, "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>%s()\n", __func__);
 	priv->bfirst_init =3D true;
 	init_status =3D priv->ops->initialize_adapter(dev);
-	if (init_status !=3D true) {
+	if (!init_status) {
 		RT_TRACE(COMP_ERR, "ERR!!! %s(): initialization is failed!\n",
 			 __func__);
 		priv->bdisable_nic =3D false;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/r=
tl8192e/rtl8192e/rtl_dm.c
index a7fa9aa..0b57357 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -535,7 +535,7 @@ static void dm_TXPowerTrackingCallback_TSSI(struct net_=
device *dev)
 				}
 			}
=20
-			if (viviflag =3D=3D true) {
+			if (viviflag) {
 				write_nic_byte(dev, Pw_Track_Flag, 0);
 				viviflag =3D false;
 				RT_TRACE(COMP_POWER_TRACKING, "we filted this data\n");
@@ -2265,7 +2265,7 @@ void dm_CheckRfCtrlGPIO(void *data)
 		return;
=20
 	if (priv->bfirst_after_down) {
-		priv->bfirst_after_down =3D 1;
+		priv->bfirst_after_down =3D true;
 		return;
 	}
=20
@@ -2273,12 +2273,12 @@ void dm_CheckRfCtrlGPIO(void *data)
=20
 	eRfPowerStateToSet =3D (tmp1byte&BIT1) ?  eRfOn : eRfOff;
=20
-	if ((priv->bHwRadioOff =3D=3D true) && (eRfPowerStateToSet =3D=3D eRfOn))=
 {
+	if ((priv->bHwRadioOff) && (eRfPowerStateToSet =3D=3D eRfOn)) {
 		RT_TRACE(COMP_RF, "gpiochangeRF  - HW Radio ON\n");
 		printk(KERN_INFO "gpiochangeRF  - HW Radio ON\n");
 		priv->bHwRadioOff =3D false;
 		bActuallySet =3D true;
-	} else if ((priv->bHwRadioOff =3D=3D false) && (eRfPowerStateToSet =3D=3D=
 eRfOff)) {
+	} else if ((!priv->bHwRadioOff) && (eRfPowerStateToSet =3D=3D eRfOff)) {
 		RT_TRACE(COMP_RF, "gpiochangeRF  - HW Radio OFF\n");
 		printk(KERN_INFO "gpiochangeRF  - HW Radio OFF\n");
 		priv->bHwRadioOff =3D true;
@@ -2289,7 +2289,7 @@ void dm_CheckRfCtrlGPIO(void *data)
 		mdelay(1000);
 		priv->bHwRfOffAction =3D 1;
 		MgntActSet_RF_State(dev, eRfPowerStateToSet, RF_CHANGE_BY_HW, true);
-		if (priv->bHwRadioOff =3D=3D true)
+		if (priv->bHwRadioOff)
 			argv[1] =3D "RFOFF";
 		else
 			argv[1] =3D "RFON";
@@ -2312,9 +2312,9 @@ void	dm_rf_pathcheck_workitemcallback(void *data)
=20
 	for (i =3D 0; i < RF90_PATH_MAX; i++) {
 		if (rfpath & (0x01<<i))
-			priv->brfpath_rxenable[i] =3D 1;
+			priv->brfpath_rxenable[i] =3D true;
 		else
-			priv->brfpath_rxenable[i] =3D 0;
+			priv->brfpath_rxenable[i] =3D false;
 	}
 	if (!DM_RxPathSelTable.Enable)
 		return;
@@ -2947,7 +2947,7 @@ static void dm_dynamic_txpower(struct net_device *dev=
)
 		} else {
 			if (priv->undecorated_smoothed_pwdb <
 			    txlowpower_threshold &&
-			    priv->bDynamicTxHighPower =3D=3D true)
+			    priv->bDynamicTxHighPower)
 				priv->bDynamicTxHighPower =3D false;
 			if (priv->undecorated_smoothed_pwdb < 35)
 				priv->bDynamicTxLowPower =3D true;
diff --git a/drivers/staging/rtl8192e/rtl819x_TSProc.c b/drivers/staging/rt=
l8192e/rtl819x_TSProc.c
index 711a096..54045c9 100644
--- a/drivers/staging/rtl8192e/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_TSProc.c
@@ -264,7 +264,7 @@ static struct ts_common_info *SearchAdmitTRStream(struc=
t rtllib_device *ieee,
 		psearch_list =3D &ieee->Rx_TS_Admit_List;
=20
 	for (dir =3D 0; dir <=3D DIR_BI_DIR; dir++) {
-		if (search_dir[dir] =3D=3D false)
+		if (!search_dir[dir])
 			continue;
 		list_for_each_entry(pRet, psearch_list, List) {
 			if (memcmp(pRet->Addr, Addr, 6) =3D=3D 0)
@@ -348,7 +348,7 @@ bool GetTs(struct rtllib_device *ieee, struct ts_common=
_info **ppTS,
 	if (*ppTS !=3D NULL) {
 		return true;
 	} else {
-		if (bAddNewTs =3D=3D false) {
+		if (!bAddNewTs) {
 			RTLLIB_DEBUG(RTLLIB_DL_TS, "add new TS failed"
 				     "(tid:%d)\n", UP);
 			return false;
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192=
e/rtllib_rx.c
index 6c5061f..67ea1fe 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -869,11 +869,11 @@ static size_t rtllib_rx_get_hdrlen(struct rtllib_devi=
ce *ieee,
 		if (net_ratelimit())
 			printk(KERN_INFO "%s: find HTCControl!\n", __func__);
 		hdrlen +=3D 4;
-		rx_stats->bContainHTC =3D 1;
+		rx_stats->bContainHTC =3D true;
 	}
=20
 	 if (RTLLIB_QOS_HAS_SEQ(fc))
-		rx_stats->bIsQosData =3D 1;
+		rx_stats->bIsQosData =3D true;
=20
 	return hdrlen;
 }
@@ -1726,7 +1726,7 @@ static inline void rtllib_extract_country_ie(
 			network->CountryIeLen =3D info_element->len;
=20
 			if (!IS_COUNTRY_IE_VALID(ieee)) {
-				if ((rtllib_act_scanning(ieee, false) =3D=3D true) && (ieee->FirstIe_I=
nScan =3D=3D 1))
+				if ((rtllib_act_scanning(ieee, false)) && (ieee->FirstIe_InScan))
 					printk(KERN_INFO "Received beacon ContryIE, SSID: <%s>\n", network->s=
sid);
 				Dot11d_UpdateCountryIe(ieee, addr2, info_element->len, info_element->d=
ata);
 			}
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rt=
l8192e/rtllib_softmac.c
index 1637f11..3eac68d 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -603,7 +603,7 @@ static void rtllib_softmac_scan_wq(void *data)
=20
 	if (!ieee->ieee_up)
 		return;
-	if (rtllib_act_scanning(ieee, true) =3D=3D true)
+	if (rtllib_act_scanning(ieee, true))
 		return;
=20
 	down(&ieee->scan_sem);
@@ -704,7 +704,7 @@ static void rtllib_softmac_stop_scan(struct rtllib_devi=
ce *ieee)
 	ieee->scan_watch_dog =3D 0;
 	if (ieee->scanning_continue =3D=3D 1) {
 		ieee->scanning_continue =3D 0;
-		ieee->actscanning =3D 0;
+		ieee->actscanning =3D false;
=20
 		cancel_delayed_work(&ieee->softmac_scan_wq);
 	}
@@ -1201,7 +1201,7 @@ inline struct sk_buff *rtllib_association_req(struct =
rtllib_network *beacon,
=20
 	if ((ieee->rtllib_ap_sec_type &&
 	    (ieee->rtllib_ap_sec_type(ieee) & SEC_ALG_TKIP)) ||
-	    (ieee->bForcedBgMode =3D=3D true)) {
+	    (ieee->bForcedBgMode)) {
 		ieee->pHTInfo->bEnableHT =3D 0;
 		ieee->mode =3D WIRELESS_MODE_G;
 	}
@@ -1534,7 +1534,7 @@ static void rtllib_associate_complete_wq(void *data)
 	struct rt_pwr_save_ctrl *pPSC =3D (struct rt_pwr_save_ctrl *)
 					(&(ieee->PowerSaveControl));
 	printk(KERN_INFO "Associated successfully\n");
-	if (ieee->is_silent_reset =3D=3D 0) {
+	if (!ieee->is_silent_reset) {
 		printk(KERN_INFO "normal associate\n");
 		notify_wx_assoc_event(ieee);
 	}
@@ -1571,9 +1571,9 @@ static void rtllib_associate_complete_wq(void *data)
 	pPSC->LpsIdleCount =3D 0;
 	ieee->link_change(ieee->dev);
=20
-	if (ieee->is_silent_reset =3D=3D 1) {
+	if (ieee->is_silent_reset) {
 		printk(KERN_INFO "silent reset associate\n");
-		ieee->is_silent_reset =3D 0;
+		ieee->is_silent_reset =3D false;
 	}
=20
 	if (ieee->data_hard_resume)
@@ -2003,7 +2003,7 @@ static short rtllib_sta_ps_sleep(struct rtllib_device=
 *ieee, u64 *time)
 		return 0;
=20
 	if (time) {
-		if (ieee->bAwakePktSent =3D=3D true) {
+		if (ieee->bAwakePktSent) {
 			pPSC->LPSAwakeIntvl =3D 1;
 		} else {
 			u8		MaxPeriod =3D 1;
@@ -2338,7 +2338,7 @@ inline int rtllib_rx_auth(struct rtllib_device *ieee,=
 struct sk_buff *skb,
=20
 					if (ieee->current_network.mode =3D=3D
 					    IEEE_N_24G &&
-					    bHalfSupportNmode =3D=3D true) {
+					    bHalfSupportNmode) {
 						printk(KERN_INFO "=3D=3D=3D=3D=3D=3D>enter "
 						       "half N mode\n");
 						ieee->bHalfWirelessN24GMode =3D
@@ -3103,7 +3103,7 @@ void rtllib_softmac_init(struct rtllib_device *ieee)
 	ieee->sta_edca_param[2] =3D 0x005E4342;
 	ieee->sta_edca_param[3] =3D 0x002F3262;
 	ieee->aggregation =3D true;
-	ieee->enable_rx_imm_BA =3D 1;
+	ieee->enable_rx_imm_BA =3D true;
 	ieee->tx_pending.txb =3D NULL;
=20
 	_setup_timer(&ieee->associate_timer,
diff --git a/drivers/staging/rtl8192e/rtllib_tx.c b/drivers/staging/rtl8192=
e/rtllib_tx.c
index f451bfc..9063f06 100644
--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -910,7 +910,7 @@ int rtllib_xmit_inter(struct sk_buff *skb, struct net_d=
evice *dev)
 				tcb_desc->data_rate =3D CURRENT_RATE(ieee->mode,
 					ieee->rate, ieee->HTCurrentOperaRate);
=20
-			if (bdhcp =3D=3D true) {
+			if (bdhcp) {
 				if (ieee->pHTInfo->IOTAction &
 				    HT_IOT_ACT_WA_IOT_Broadcom) {
 					tcb_desc->data_rate =3D
diff --git a/drivers/staging/rtl8192e/rtllib_wx.c b/drivers/staging/rtl8192=
e/rtllib_wx.c
index c27ff7e..df617ed 100644
--- a/drivers/staging/rtl8192e/rtllib_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_wx.c
@@ -753,7 +753,7 @@ int rtllib_wx_set_mlme(struct rtllib_device *ieee,
 		/* leave break out intentionly */
=20
 	case IW_MLME_DISASSOC:
-		if (deauth =3D=3D true)
+		if (deauth)
 			printk(KERN_INFO "disauth packet !\n");
 		else
 			printk(KERN_INFO "dis associate packet!\n");
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/st=
aging/rtl8192u/ieee80211/ieee80211_rx.c
index c9bdc7f..01cad0e 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -950,7 +950,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct =
sk_buff *skb,
 		if(net_ratelimit())
 		printk("find HTCControl\n");
 		hdrlen +=3D 4;
-		rx_stats->bContainHTC =3D 1;
+		rx_stats->bContainHTC =3D true;
 	}
=20
 	//IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, skb->data, skb->len);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drive=
rs/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index c2ab5fa..f82544b 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -1361,14 +1361,14 @@ void ieee80211_associate_complete_wq(struct work_st=
ruct *work)
 		ieee->LinkDetectInfo.NumRecvDataInPeriod=3D 1;
 	}
 	ieee->link_change(ieee->dev);
-	if(ieee->is_silent_reset =3D=3D 0){
+	if(!ieee->is_silent_reset){
 		printk("=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>normal associate\n");
 	notify_wx_assoc_event(ieee);
 	}
-	else if(ieee->is_silent_reset =3D=3D 1)
+	else if(ieee->is_silent_reset)
 	{
 		printk("=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>silent re=
set associate\n");
-		ieee->is_silent_reset =3D 0;
+		ieee->is_silent_reset =3D false;
 	}
=20
 	if (ieee->data_hard_resume)
@@ -2048,7 +2048,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *i=
eee, struct sk_buff *skb,
 									ieee->SetWirelessMode(ieee->dev, IEEE_G);
 								}
=20
-								if (ieee->current_network.mode =3D=3D IEEE_N_24G && bHalfSupportNm=
ode =3D=3D true)
+								if (ieee->current_network.mode =3D=3D IEEE_N_24G && bHalfSupportNm=
ode)
 								{
 									printk("=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>entern half=
 N mode\n");
 									ieee->bHalfWirelessN24GMode =3D true;
@@ -2714,7 +2714,7 @@ void ieee80211_softmac_init(struct ieee80211_device *=
ieee)
 	ieee->sta_edca_param[2] =3D 0x005E4342;
 	ieee->sta_edca_param[3] =3D 0x002F3262;
 	ieee->aggregation =3D true;
-	ieee->enable_rx_imm_BA =3D 1;
+	ieee->enable_rx_imm_BA =3D true;
 	ieee->tx_pending.txb =3D NULL;
=20
 	init_timer(&ieee->associate_timer);
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/=
staging/rtl8192u/ieee80211/rtl819x_TSProc.c
index 957ce4e..e7c8e7f 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
@@ -285,7 +285,7 @@ PTS_COMMON_INFO SearchAdmitTRStream(struct ieee80211_de=
vice *ieee, u8*	Addr, u8
 	//for(dir =3D DIR_UP; dir <=3D DIR_BI_DIR; dir++)
 	for(dir =3D 0; dir <=3D DIR_BI_DIR; dir++)
 	{
-		if(search_dir[dir] =3D=3Dfalse )
+		if(!search_dir[dir])
 			continue;
 		list_for_each_entry(pRet, psearch_list, List){
 	//		IEEE80211_DEBUG(IEEE80211_DL_TS, "ADD:%pM, TID:%d, dir:%d\n", pRet->A=
ddr, pRet->TSpec.f.TSInfo.field.ucTSID, pRet->TSpec.f.TSInfo.field.ucDirect=
ion);
@@ -402,7 +402,7 @@ bool GetTs(
 	}
 	else
 	{
-		if(bAddNewTs =3D=3D false)
+		if(!bAddNewTs)
 		{
 			IEEE80211_DEBUG(IEEE80211_DL_TS, "add new TS failed(tid:%d)\n", UP);
 			return false;
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl81=
92u/r8192U_core.c
index c09be0a..fa4f53e 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -229,7 +229,7 @@ static void rtl819x_set_channel_map(u8 channel_plan, st=
ruct r8192_priv* priv)
 		}
 		case COUNTRY_CODE_GLOBAL_DOMAIN:
 		{
-			GET_DOT11D_INFO(ieee)->bEnabled =3D 0;//this flag enabled to follow 11d=
 country IE setting, otherwise, it shall follow global domain settings.
+			GET_DOT11D_INFO(ieee)->bEnabled =3D false;//this flag enabled to follow=
 11d country IE setting, otherwise, it shall follow global domain settings.
 			Dot11d_Reset(ieee);
 			ieee->bGlobalDomain =3D true;
 			break;
@@ -2723,7 +2723,7 @@ static void rtl8192_init_priv_variable(struct net_dev=
ice* dev)
 	//for silent reset
 	priv->IrpPendingCount =3D 1;
 	priv->ResetProgress =3D RESET_TYPE_NORESET;
-	priv->bForcedSilentReset =3D 0;
+	priv->bForcedSilentReset =3D false;
 	priv->bDisableNormalResetCheck =3D false;
 	priv->force_reset =3D false;
=20
diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192=
u/r8192U_dm.c
index 2dde9fa..6513e07 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -3002,9 +3002,9 @@ extern	void	dm_rf_pathcheck_workitemcallback(struct w=
ork_struct *work)
 	for (i =3D 0; i < RF90_PATH_MAX; i++)
 	{
 		if (rfpath & (0x01<<i))
-			priv->brfpath_rxenable[i] =3D 1;
+			priv->brfpath_rxenable[i] =3D true;
 		else
-			priv->brfpath_rxenable[i] =3D 0;
+			priv->brfpath_rxenable[i] =3D false;
 	}
 	if(!DM_RxPathSelTable.Enable)
 		return;
@@ -3810,7 +3810,7 @@ static void dm_dynamic_txpower(struct net_device *dev=
)
 		else
 		{
 			// high power state check
-			if(priv->undecorated_smoothed_pwdb < txlowpower_threshold && priv->bDyn=
amicTxHighPower =3D=3D true)
+			if(priv->undecorated_smoothed_pwdb < txlowpower_threshold && priv->bDyn=
amicTxHighPower)
 			{
 				priv->bDynamicTxHighPower =3D false;
 			}
diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/r=
tl8192u/r819xU_firmware.c
index 4bb5fff..77e490b 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -343,7 +343,7 @@ bool init_firmware(struct net_device *dev)
 #ifdef RTL8190P
 				// To initialize IMEM, CPU move code  from 0x80000080, hence, we send =
0x80 byte packet
 				rt_status =3D fwSendNullPacket(dev, RTL8190_CPU_START_OFFSET);
-				if(rt_status !=3D true)
+				if(!rt_status)
 				{
 					RT_TRACE(COMP_INIT, "fwSendNullPacket() fail ! \n");
 					goto  download_firmware_fail;
diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl819=
2u/r819xU_phy.c
index c4586b0..34f5eb2 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -1066,7 +1066,7 @@ bool rtl8192_SetRFPowerState(struct net_device *dev, =
RT_RF_POWER_STATE eRFPowerS
 	if(eRFPowerState =3D=3D priv->ieee80211->eRFPowerState)
 		return false;
=20
-	if(priv->SetRFPowerStateInProgress =3D=3D true)
+	if(priv->SetRFPowerStateInProgress)
 		return false;
=20
 	priv->SetRFPowerStateInProgress =3D true;
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_dri=
ver.c
index 6b3d156..07e7e74 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -1523,7 +1523,7 @@ static int sep_prepare_input_dma_table(struct sep_dev=
ice *sep,
 	}
=20
 	/* Check if the pages are in Kernel Virtual Address layout */
-	if (is_kva =3D=3D true)
+	if (is_kva)
 		/* Lock the pages in the kernel */
 		error =3D sep_lock_kernel_pages(sep, app_virt_addr,
 			data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG);
@@ -1928,7 +1928,7 @@ static int sep_prepare_input_output_dma_table(struct =
sep_device *sep,
 	sep->dma_res_arr[sep->nr_dcb_creat].out_page_array =3D NULL;
=20
 	/* Lock the pages of the buffer and translate them to pages */
-	if (is_kva =3D=3D true) {
+	if (is_kva) {
 		error =3D sep_lock_kernel_pages(sep, app_virt_in_addr,
 			data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
=20
@@ -2077,11 +2077,11 @@ static int sep_prepare_input_output_dma_table_in_dc=
b(struct sep_device *sep,
 	dcb_table_ptr->tail_data_size =3D 0;
 	dcb_table_ptr->out_vr_tail_pt =3D 0;
=20
-	if (isapplet =3D=3D true) {
+	if (isapplet) {
=20
 		/* Check if there is enough data for DMA operation */
 		if (data_in_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE) {
-			if (is_kva =3D=3D true) {
+			if (is_kva) {
 				memcpy(dcb_table_ptr->tail_data,
 					(void *)app_in_address, data_in_size);
 			} else {
@@ -2122,7 +2122,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(=
struct sep_device *sep,
 		if (tail_size) {
 			if (tail_size > sizeof(dcb_table_ptr->tail_data))
 				return -EINVAL;
-			if (is_kva =3D=3D true) {
+			if (is_kva) {
 				memcpy(dcb_table_ptr->tail_data,
 					(void *)(app_in_address + data_in_size -
 					tail_size), tail_size);
@@ -2215,7 +2215,7 @@ static int sep_free_dma_tables_and_dcb(struct sep_dev=
ice *sep, bool isapplet,
 	unsigned long pt_hold;
 	void *tail_pt;
=20
-	if (isapplet =3D=3D true) {
+	if (isapplet) {
 		/* Set pointer to first DCB table */
 		dcb_table_ptr =3D (struct sep_dcblock *)
 			(sep->shared_addr +
@@ -2226,7 +2226,7 @@ static int sep_free_dma_tables_and_dcb(struct sep_dev=
ice *sep, bool isapplet,
 			if (dcb_table_ptr->out_vr_tail_pt) {
 				pt_hold =3D (unsigned long)dcb_table_ptr->out_vr_tail_pt;
 				tail_pt =3D (void *)pt_hold;
-				if (is_kva =3D=3D true) {
+				if (is_kva) {
 					memcpy(tail_pt,
 						dcb_table_ptr->tail_data,
 						dcb_table_ptr->tail_data_size);
diff --git a/drivers/staging/tidspbridge/dynload/cload.c b/drivers/staging/=
tidspbridge/dynload/cload.c
index fe1ef0a..e695658 100644
--- a/drivers/staging/tidspbridge/dynload/cload.c
+++ b/drivers/staging/tidspbridge/dynload/cload.c
@@ -1101,7 +1101,7 @@ static int relocate_packet(struct dload_state *dlthis=
,
 	/* If trampoline(s) were generated, we need to do an update of the
 	 * trampoline copy of the packet since a 2nd phase relo will be done
 	 * later. */
-	if (*tramps_generated =3D=3D true) {
+	if (*tramps_generated) {
 		dload_tramp_pkt_udpate(dlthis,
 				       (dlthis->image_secn -
 					dlthis->ldr_sections),
@@ -1242,7 +1242,7 @@ static void dload_data(struct dload_state *dlthis)
 				 * trampoline was generated.  Otherwise it
 				 *will be done during trampoline finalize. */
=20
-				if (tramp_generated =3D=3D false) {
+				if (!tramp_generated) {
=20
 					/* stuff the result into target
 					 * memory */
diff --git a/drivers/staging/tidspbridge/dynload/reloc.c b/drivers/staging/=
tidspbridge/dynload/reloc.c
index 7b28c07..769c318 100644
--- a/drivers/staging/tidspbridge/dynload/reloc.c
+++ b/drivers/staging/tidspbridge/dynload/reloc.c
@@ -184,7 +184,7 @@ void dload_relocate(struct dload_state *dlthis, tgt_au_=
t * data,
 	 * relocation doesn't guarantee that data is coming from an
 	 * image_packet_t structure. See cload.c, dload_data for how img_data is
 	 * set. If that changes this needs to be updated!!! */
-	if (second_pass =3D=3D false)
+	if (!second_pass)
 		img_pkt =3D (struct image_packet_t *)((u8 *) data -
 						    sizeof(struct
 							   image_packet_t));
@@ -226,7 +226,7 @@ void dload_relocate(struct dload_state *dlthis, tgt_au_=
t * data,
 	if (RFV_SYM(reloc_info)) {	/* relocation uses a symbol reference */
 		/* If this is first pass, use the module local symbol table,
 		 * else use the trampoline symbol table. */
-		if (second_pass =3D=3D false) {
+		if (!second_pass) {
 			if ((u32) rp->SYMNDX < dlthis->dfile_hdr.df_no_syms) {
 				/* real symbol reference */
 				svp =3D &dlthis->local_symtab[rp->SYMNDX];
@@ -444,7 +444,7 @@ void dload_relocate(struct dload_state *dlthis, tgt_au_=
t * data,
 			/* Check to see if this relo can be trampolined,
 			 * but only in first phase relocation.  2nd phase
 			 * relocation cannot trampoline. */
-			if ((second_pass =3D=3D false) &&
+			if ((!second_pass) &&
 			    (dload_tramp_avail(dlthis, rp) =3D=3D true)) {
=20
 				/* Before generating the trampoline, restore
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/sta=
ging/tidspbridge/rmgr/drv_interface.c
index 385740b..81afbb8 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -407,7 +407,7 @@ static int __devexit omap34_xx_bridge_remove(struct pla=
tform_device *pdev)
 		/* Put the DSP in reset state */
 		ret =3D dsp_deinit(driver_context);
 		driver_context =3D 0;
-		DBC_ASSERT(ret =3D=3D true);
+		DBC_ASSERT(ret);
 	}
=20
 	kfree(drv_datap);
diff --git a/drivers/staging/tidspbridge/rmgr/mgr.c b/drivers/staging/tidsp=
bridge/rmgr/mgr.c
index d635c01..9245845 100644
--- a/drivers/staging/tidspbridge/rmgr/mgr.c
+++ b/drivers/staging/tidspbridge/rmgr/mgr.c
@@ -255,7 +255,7 @@ int mgr_enum_processor_info(u32 processor_id,
 		proc_index++;
 		/* Get the Object properties to find the Device/Processor
 		 * Type */
-		if (proc_detect !=3D false)
+		if (proc_detect)
 			continue;
=20
 		status2 =3D dcd_get_object_def(pmgr_obj->dcd_mgr,
@@ -294,7 +294,7 @@ int mgr_enum_processor_info(u32 processor_id,
 		}
 	}
 	*pu_num_procs =3D proc_index;
-	if (proc_detect =3D=3D false) {
+	if (!proc_detect) {
 		dev_dbg(bridge, "%s: Failed to get proc info from DCD, so use "
 			"CFG registry\n", __func__);
 		processor_info->processor_type =3D DSPTYPE64;
diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/bas=
eband.c
index 1e1c6e3..73a73b3 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1879,7 +1879,7 @@ BBvCaculateParameter (
         break;
=20
     case RATE_5M :
-        if (bCCK =3D=3D false)
+        if (!bCCK)
             cbBitCount ++;
         cbUsCount =3D (cbBitCount * 10) / 55;
         cbTmp =3D (cbUsCount * 55) / 10;
@@ -1893,7 +1893,7 @@ BBvCaculateParameter (
=20
     case RATE_11M :
=20
-        if (bCCK =3D=3D false)
+        if (!bCCK)
             cbBitCount ++;
         cbUsCount =3D cbBitCount / 11;
         cbTmp =3D cbUsCount * 11;
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.=
c
index 577599e..e80e3fe 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -160,9 +160,9 @@ BSSpSearchBSSList(
         // match BSSID first
         for (ii =3D 0; ii <MAX_BSS_NUM; ii++) {
             pCurrBSS =3D &(pMgmt->sBSSList[ii]);
-if(pDevice->bLinkPass=3D=3Dfalse) pCurrBSS->bSelected =3D false;
+if(!pDevice->bLinkPass) pCurrBSS->bSelected =3D false;
             if ((pCurrBSS->bActive) &&
-                (pCurrBSS->bSelected =3D=3D false)) {
+                (!pCurrBSS->bSelected)) {
                 if (!compare_ether_addr(pCurrBSS->abyBSSID, pbyBSSID)) {
                     if (pSSID !=3D NULL) {
                         // compare ssid
@@ -446,7 +446,7 @@ BSSbInsertToBSSList (
     if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
         pBSSList->eNetworkTypeInUse =3D PHY_TYPE_11A;
     } else {
-        if (pBSSList->sERP.bERPExist =3D=3D true) {
+        if (pBSSList->sERP.bERPExist) {
             pBSSList->eNetworkTypeInUse =3D PHY_TYPE_11G;
         } else {
             pBSSList->eNetworkTypeInUse =3D PHY_TYPE_11B;
@@ -489,7 +489,7 @@ BSSbInsertToBSSList (
         }
     }
=20
-    if ((pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPA2) || (pBSSList->bWPA2Vali=
d =3D=3D true)) {
+    if ((pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPA2) || (pBSSList->bWPA2Vali=
d)) {
=20
         PSKeyItem  pTransmitKey =3D NULL;
         bool bIs802_1x =3D false;
@@ -500,12 +500,12 @@ BSSbInsertToBSSList (
                 break;
             }
         }
-        if ((bIs802_1x =3D=3D true) && (pSSID->len =3D=3D ((PWLAN_IE_SSID)=
pMgmt->abyDesireSSID)->len) &&
+        if ((bIs802_1x) && (pSSID->len =3D=3D ((PWLAN_IE_SSID)pMgmt->abyDe=
sireSSID)->len) &&
             ( !memcmp(pSSID->abySSID, ((PWLAN_IE_SSID)pMgmt->abyDesireSSID=
)->abySSID, pSSID->len))) {
=20
             bAdd_PMKID_Candidate((void *)pDevice, pBSSList->abyBSSID, &pBS=
SList->sRSNCapObj);
=20
-            if ((pDevice->bLinkPass =3D=3D true) && (pMgmt->eCurrState =3D=
=3D WMAC_STATE_ASSOC)) {
+            if ((pDevice->bLinkPass) && (pMgmt->eCurrState =3D=3D WMAC_STA=
TE_ASSOC)) {
                 if ((KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSI=
D, PAIRWISE_KEY, &pTransmitKey) =3D=3D true) ||
                     (KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSI=
D, GROUP_KEY, &pTransmitKey) =3D=3D true)) {
                     pDevice->gsPMKIDCandidate.StatusType =3D Ndis802_11Sta=
tusType_PMKID_CandidateList;
@@ -527,12 +527,12 @@ BSSbInsertToBSSList (
     }
=20
     if ((pIE_Country !=3D NULL) &&
-        (pMgmt->b11hEnable =3D=3D true)) {
+        (pMgmt->b11hEnable)) {
         set_country_info(pMgmt->pAdapter, pBSSList->eNetworkTypeInUse,
                             pIE_Country);
     }
=20
-    if ((bParsingQuiet =3D=3D true) && (pIE_Quiet !=3D NULL)) {
+    if ((bParsingQuiet) && (pIE_Quiet !=3D NULL)) {
         if ((((PWLAN_IE_QUIET)pIE_Quiet)->len =3D=3D 8) &&
             (((PWLAN_IE_QUIET)pIE_Quiet)->byQuietCount !=3D 0)) {
             // valid EID
@@ -558,7 +558,7 @@ BSSbInsertToBSSList (
         }
     }
=20
-    if ((bParsingQuiet =3D=3D true) &&
+    if ((bParsingQuiet) &&
         (pQuiet !=3D NULL)) {
         CARDbStartQuiet(pMgmt->pAdapter);
     }
@@ -646,7 +646,7 @@ BSSbUpdateToBSSList (
     if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
         pBSSList->eNetworkTypeInUse =3D PHY_TYPE_11A;
     } else {
-        if (pBSSList->sERP.bERPExist =3D=3D true) {
+        if (pBSSList->sERP.bERPExist) {
             pBSSList->eNetworkTypeInUse =3D PHY_TYPE_11G;
         } else {
             pBSSList->eNetworkTypeInUse =3D PHY_TYPE_11B;
@@ -703,12 +703,12 @@ BSSbUpdateToBSSList (
     }
=20
     if ((pIE_Country !=3D NULL) &&
-        (pMgmt->b11hEnable =3D=3D true)) {
+        (pMgmt->b11hEnable)) {
         set_country_info(pMgmt->pAdapter, pBSSList->eNetworkTypeInUse,
                             pIE_Country);
     }
=20
-    if ((bParsingQuiet =3D=3D true) && (pIE_Quiet !=3D NULL)) {
+    if ((bParsingQuiet) && (pIE_Quiet !=3D NULL)) {
         if ((((PWLAN_IE_QUIET)pIE_Quiet)->len =3D=3D 8) &&
             (((PWLAN_IE_QUIET)pIE_Quiet)->byQuietCount !=3D 0)) {
             // valid EID
@@ -734,7 +734,7 @@ BSSbUpdateToBSSList (
         }
     }
=20
-    if ((bParsingQuiet =3D=3D true) &&
+    if ((bParsingQuiet) &&
         (pQuiet !=3D NULL)) {
         CARDbStartQuiet(pMgmt->pAdapter);
     }
@@ -1027,12 +1027,12 @@ BSSvSecondCallBack(
  //2008-4-14 <add> by chester for led issue
 #ifdef FOR_LED_ON_NOTEBOOK
 MACvGPIOIn(pDevice->PortOffset, &pDevice->byGPIO);
-if ((( !(pDevice->byGPIO & GPIO0_DATA)&&(pDevice->bHWRadioOff =3D=3D false=
))||((pDevice->byGPIO & GPIO0_DATA)&&(pDevice->bHWRadioOff =3D=3D true)))&&=
(cc=3D=3Dfalse)){
+if ((( !(pDevice->byGPIO & GPIO0_DATA)&&(!pDevice->bHWRadioOff))||((pDevic=
e->byGPIO & GPIO0_DATA)&&(pDevice->bHWRadioOff)))&&(!cc)){
 cc=3Dtrue;
 }
-else if(cc=3D=3Dtrue){
+else if(cc){
=20
-if(pDevice->bHWRadioOff =3D=3D true){
+if(pDevice->bHWRadioOff){
             if ( !(pDevice->byGPIO & GPIO0_DATA))
 //||( !(pDevice->byGPIO & GPIO0_DATA) && (pDevice->byRadioCtl & EEP_RADIOC=
TL_INV)))
 {if(status=3D=3D1) goto start;
@@ -1085,7 +1085,7 @@ start:
=20
 {
        pDevice->byReAssocCount++;
-   if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass !=3D true)) { =
 //10 sec timeout
+   if((pDevice->byReAssocCount > 10) && (!pDevice->bLinkPass)) {  //10 sec=
 timeout
                      printk("Re-association timeout!!!\n");
 		   pDevice->byReAssocCount =3D 0;
                      #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
@@ -1099,7 +1099,7 @@ start:
                        }
                     #endif
      }
-   else if(pDevice->bLinkPass =3D=3D true)
+   else if(pDevice->bLinkPass)
    	pDevice->byReAssocCount =3D 0;
 }
=20
@@ -1307,7 +1307,7 @@ start:
                 pDevice->uAutoReConnectTime++;
 	       #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
                 //network manager support need not do Roaming scan???
-                if(pDevice->bWPASuppWextEnabled =3D=3Dtrue)
+                if(pDevice->bWPASuppWextEnabled)
 		 pDevice->uAutoReConnectTime =3D 0;
 	     #endif
             }
@@ -1686,7 +1686,7 @@ RxCnt =3D pDevice->scStatistic.RxFcsErrCnt +
 TxOkRatio =3D (TxCnt < 6) ? 4000:((pDevice->scStatistic.TxNoRetryOkCount *=
 4000) / TxCnt);
 RxOkRatio =3D (RxCnt < 6) ? 2000:((pDevice->scStatistic.RxOkCnt * 2000) / =
RxCnt);
 //decide link quality
-if(pDevice->bLinkPass !=3Dtrue)
+if(!pDevice->bLinkPass)
 {
  //  printk("s_uCalculateLinkQual-->Link disconnect and Poor quality**\n")=
;
    pDevice->scStatistic.LinkQuality =3D 0;
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 2721e07..93ac4c4 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -1093,7 +1093,7 @@ CARDbAdd_PMKID_Candidate (
     for (ii =3D 0; ii < pDevice->gsPMKIDCandidate.NumCandidates; ii++) {
         pCandidateList =3D &pDevice->gsPMKIDCandidate.CandidateList[ii];
         if ( !memcmp(pCandidateList->BSSID, pbyBSSID, ETH_ALEN)) {
-            if ((bRSNCapExist =3D=3D true) && (wRSNCap & BIT0)) {
+            if ((bRSNCapExist) && (wRSNCap & BIT0)) {
                 pCandidateList->Flags |=3D NDIS_802_11_PMKID_CANDIDATE_PRE=
AUTH_ENABLED;
             } else {
                 pCandidateList->Flags &=3D ~(NDIS_802_11_PMKID_CANDIDATE_P=
REAUTH_ENABLED);
@@ -1104,7 +1104,7 @@ CARDbAdd_PMKID_Candidate (
=20
     // New Candidate
     pCandidateList =3D &pDevice->gsPMKIDCandidate.CandidateList[pDevice->g=
sPMKIDCandidate.NumCandidates];
-    if ((bRSNCapExist =3D=3D true) && (wRSNCap & BIT0)) {
+    if ((bRSNCapExist) && (wRSNCap & BIT0)) {
         pCandidateList->Flags |=3D NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENA=
BLED;
     } else {
         pCandidateList->Flags &=3D ~(NDIS_802_11_PMKID_CANDIDATE_PREAUTH_E=
NABLED);
@@ -1230,7 +1230,7 @@ CARDbStartMeasure (
         }
     } while (pDevice->uNumOfMeasureEIDs !=3D 0);
=20
-    if (bExpired =3D=3D false) {
+    if (!bExpired) {
         MACvSelectPage1(pDevice->PortOffset);
         VNSvOutPortD(pDevice->PortOffset + MAC_REG_MSRSTART, LODWORD(qwSta=
rtTSF));
         VNSvOutPortD(pDevice->PortOffset + MAC_REG_MSRSTART + 4, HIDWORD(q=
wStartTSF));
@@ -1322,7 +1322,7 @@ CARDbSetQuiet (
     PSDevice    pDevice =3D (PSDevice) pDeviceHandler;
     unsigned int ii =3D 0;
=20
-    if (bResetQuiet =3D=3D true) {
+    if (bResetQuiet) {
         MACvRegBitsOff(pDevice->PortOffset, MAC_REG_MSRCTL, (MSRCTL_QUIETT=
XCHK | MSRCTL_QUIETEN));
         for(ii=3D0;ii<MAX_QUIET_COUNT;ii++) {
             pDevice->sQuiet[ii].bEnable =3D false;
diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/chan=
nel.c
index 47c156b..4abedf1 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -444,8 +444,8 @@ void init_channel_table(void *pDeviceHandler)
 			break;
 	}
=20
-	if ((pDevice->dwDiagRefCount !=3D 0) || (pDevice->b11hEnable =3D=3D true)=
) {
-		if (bMultiBand =3D=3D true) {
+	if ((pDevice->dwDiagRefCount !=3D 0) || (pDevice->b11hEnable)) {
+		if (bMultiBand) {
 			for(ii =3D 0 ; ii<CARD_MAX_CHANNEL_TBL ; ii++) {
 				sChannelTbl[ii+1].bValid =3D true;
 				pDevice->abyRegPwr[ii+1] =3D pDevice->abyOFDMDefaultPwr[ii+1];
@@ -466,7 +466,7 @@ void init_channel_table(void *pDeviceHandler)
 			}
 		}
 	} else if (pDevice->byZoneType <=3D CCODE_MAX) {
-		if (bMultiBand =3D=3D true) {
+		if (bMultiBand) {
 			for(ii =3D 0 ; ii<CARD_MAX_CHANNEL_TBL ; ii++) {
 				if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] !=3D 0) {
 					sChannelTbl[ii+1].bValid =3D true;
@@ -535,7 +535,7 @@ bool set_channel (void *pDeviceHandler, unsigned int uC=
onnectionChannel)
 		return bResult;
 	}
=20
-	if (sChannelTbl[uConnectionChannel].bValid =3D=3D false) {
+	if (!sChannelTbl[uConnectionChannel].bValid) {
 		return (false);
 	}
=20
@@ -563,7 +563,7 @@ bool set_channel (void *pDeviceHandler, unsigned int uC=
onnectionChannel)
 	bResult &=3D RFbSelectChannel(pDevice->PortOffset, pDevice->byRFType, (un=
signed char)uConnectionChannel);
=20
 	// Init Synthesizer Table
-	if (pDevice->bEnablePSMode =3D=3D true)
+	if (pDevice->bEnablePSMode)
 		RFvWriteWakeProgSyn(pDevice->PortOffset, pDevice->byRFType, uConnectionC=
hannel);
=20
=20
@@ -784,7 +784,7 @@ unsigned char auto_channel_select(void *pDeviceHandler,=
 CARD_PHY_TYPE ePHYType)
=20
 	if (ePHYType =3D=3D PHY_TYPE_11A) {
 		for(ii =3D CB_MAX_CHANNEL_24G + 1 ; ii <=3D CB_MAX_CHANNEL ; ii++) {
-			if (sChannelTbl[ii].bValid =3D=3D true) {
+			if (sChannelTbl[ii].bValid) {
 				if (byOptionChannel =3D=3D 0) {
 					byOptionChannel =3D (unsigned char) ii;
 				}
@@ -798,7 +798,7 @@ unsigned char auto_channel_select(void *pDeviceHandler,=
 CARD_PHY_TYPE ePHYType)
 	} else {
 		byOptionChannel =3D 0;
 		for(ii =3D 1 ; ii <=3D CB_MAX_CHANNEL_24G ; ii++) {
-			if (sChannelTbl[ii].bValid =3D=3D true) {
+			if (sChannelTbl[ii].bValid) {
 				if (sChannelTbl[ii].byMAP =3D=3D 0) {
 					aiWeight[ii] +=3D 100;
 				} else if (sChannelTbl[ii].byMAP & 0x01) {
@@ -825,7 +825,7 @@ unsigned char auto_channel_select(void *pDeviceHandler,=
 CARD_PHY_TYPE ePHYType)
 			}
 		}
 		for(ii =3D 1 ; ii <=3D CB_MAX_CHANNEL_24G ; ii++) {
-			if ((sChannelTbl[ii].bValid =3D=3D true) &&
+			if ((sChannelTbl[ii].bValid) &&
 					(aiWeight[ii] > aiWeight[byOptionChannel])) {
 				byOptionChannel =3D (unsigned char) ii;
 			}
diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/dat=
arate.c
index efbb8f4..c43955e 100644
--- a/drivers/staging/vt6655/datarate.c
+++ b/drivers/staging/vt6655/datarate.c
@@ -233,7 +233,7 @@ unsigned int uRateLen;
     for (ii =3D 0; ii < uRateLen; ii++) {
     	byRate =3D (unsigned char)(pItemRates->abyRates[ii]);
         if (WLAN_MGMT_IS_BASICRATE(byRate) &&
-            (bUpdateBasicRate =3D=3D true))  {
+            (bUpdateBasicRate))  {
             // Add to basic rate set, update pDevice->byTopCCKBasicRate an=
d pDevice->byTopOFDMBasicRate
             CARDbAddBasicRate((void *)pDevice, wGetRateIdx(byRate));
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ParseMaxRate AddBasicRate: =
%d\n", wGetRateIdx(byRate));
@@ -346,7 +346,7 @@ bool bAutoRate[MAX_RATE]    =3D {true,true,true,true,fa=
lse,false,true,true,true,tr
=20
     for(ii=3D0;ii<MAX_RATE;ii++) {
         if (psNodeDBTable->wSuppRate & (0x0001<<ii)) {
-            if (bAutoRate[ii] =3D=3D true) {
+            if (bAutoRate[ii]) {
                 wIdxUpRate =3D (unsigned short) ii;
             }
         } else {
@@ -372,7 +372,7 @@ bool bAutoRate[MAX_RATE]    =3D {true,true,true,true,fa=
lse,false,true,true,true,tr
     for(ii =3D psNodeDBTable->wTxDataRate; ii > 0;) {
         ii--;
         if ( (dwThroughputTbl[ii] > dwThroughput) &&
-             (bAutoRate[ii]=3D=3Dtrue) ) {
+             (bAutoRate[ii]) ) {
             dwThroughput =3D dwThroughputTbl[ii];
             wIdxDownRate =3D (unsigned short) ii;
         }
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/=
device_main.c
index 3e8283c..74ee6fd 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -597,7 +597,7 @@ static void device_init_registers(PSDevice pDevice, DEV=
ICE_INIT_TYPE InitType)
             pDevice->byTxAntennaMode =3D ANT_B;
             pDevice->dwTxAntennaSel =3D 1;
             pDevice->dwRxAntennaSel =3D 1;
-            if (pDevice->bTxRxAntInv =3D=3D true)
+            if (pDevice->bTxRxAntInv)
                 pDevice->byRxAntennaMode =3D ANT_A;
             else
                 pDevice->byRxAntennaMode =3D ANT_B;
@@ -618,13 +618,13 @@ byValue1 =3D SROMbyReadEmbedded(pDevice->PortOffset, =
EEP_OFS_ANTENNA);
             pDevice->dwRxAntennaSel =3D 0;
             if (byValue & EEP_ANTENNA_AUX) {
                 pDevice->byTxAntennaMode =3D ANT_A;
-                if (pDevice->bTxRxAntInv =3D=3D true)
+                if (pDevice->bTxRxAntInv)
                     pDevice->byRxAntennaMode =3D ANT_B;
                 else
                     pDevice->byRxAntennaMode =3D ANT_A;
             } else {
                 pDevice->byTxAntennaMode =3D ANT_B;
-                if (pDevice->bTxRxAntInv =3D=3D true)
+                if (pDevice->bTxRxAntInv)
                     pDevice->byRxAntennaMode =3D ANT_A;
                 else
                     pDevice->byRxAntennaMode =3D ANT_B;
@@ -682,7 +682,7 @@ else
         pDevice->byRFType &=3D RF_MASK;
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byRFType =3D %x\n", p=
Device->byRFType);
=20
-        if (pDevice->bZoneRegExist =3D=3D false) {
+        if (!pDevice->bZoneRegExist) {
             pDevice->byZoneType =3D pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
         }
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byZoneType =3D %x\n",=
 pDevice->byZoneType);
@@ -796,7 +796,7 @@ if (pDevice->byGPIO & GPIO0_DATA){pDevice->bHWRadioOff =
=3D true;}
 if ( !(pDevice->byGPIO & GPIO0_DATA)){pDevice->bHWRadioOff =3D false;}
=20
             }
-        if ( (pDevice->bRadioControlOff =3D=3D true)) {
+        if ( (pDevice->bRadioControlOff)) {
             CARDbRadioPowerOff(pDevice);
         }
 else  CARDbRadioPowerOn(pDevice);
@@ -806,7 +806,7 @@ else  CARDbRadioPowerOn(pDevice);
                 pDevice->bHWRadioOff =3D true;
             }
         }
-        if ((pDevice->bHWRadioOff =3D=3D true) || (pDevice->bRadioControlO=
ff =3D=3D true)) {
+        if ((pDevice->bHWRadioOff) || (pDevice->bRadioControlOff)) {
             CARDbRadioPowerOff(pDevice);
         }
=20
@@ -870,7 +870,7 @@ static bool device_release_WPADEV(PSDevice pDevice)
   int ii=3D0;
  // wait_queue_head_t	Set_wait;
   //send device close to wpa_supplicnat layer
-    if (pDevice->bWPADEVUp=3D=3Dtrue) {
+    if (pDevice->bWPADEVUp) {
                  wpahdr =3D (viawget_wpa_header *)pDevice->skb->data;
                  wpahdr->type =3D VIAWGET_DEVICECLOSE_MSG;
                  wpahdr->resp_ie_len =3D 0;
@@ -887,7 +887,7 @@ static bool device_release_WPADEV(PSDevice pDevice)
  //wait release WPADEV
               //    init_waitqueue_head(&Set_wait);
               //    wait_event_timeout(Set_wait, ((pDevice->wpadev=3D=3DNU=
LL)&&(pDevice->skb =3D=3D NULL)),5*HZ);    //1s wait
-              while((pDevice->bWPADEVUp=3D=3Dtrue)) {
+              while((pDevice->bWPADEVUp)) {
 	        set_current_state(TASK_UNINTERRUPTIBLE);
                  schedule_timeout (HZ/20);          //wait 50ms
                  ii++;
@@ -959,7 +959,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_dev=
ice_id *ent)
 #ifdef	DEBUG
 	printk("Before get pci_info memaddr is %x\n",pDevice->memaddr);
 #endif
-    if (device_get_pci_info(pDevice,pcid) =3D=3D false) {
+    if (!device_get_pci_info(pDevice, pcid)) {
         printk(KERN_ERR DEVICE_NAME ": Failed to find PCI device.\n");
         device_free_info(pDevice);
         return -ENODEV;
@@ -1781,7 +1781,7 @@ static int device_tx_srv(PSDevice pDevice, unsigned i=
nt uIdx) {
             bFull =3D true;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " AC0DMA is Full =3D %d\n",=
 pDevice->iTDUsed[uIdx]);
         }
-        if (netif_queue_stopped(pDevice->dev) && (bFull=3D=3Dfalse)){
+        if (netif_queue_stopped(pDevice->dev) && (!bFull)){
             netif_wake_queue(pDevice->dev);
         }
     }
@@ -1989,7 +1989,7 @@ DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "call device_init_=
registers\n");
     pDevice->byReAssocCount =3D 0;
    pDevice->bWPADEVUp =3D false;
     // Patch: if WEP key already set by iwconfig but device not yet open
-    if ((pDevice->bEncryptionEnable =3D=3D true) && (pDevice->bTransmitKey=
 =3D=3D true)) {
+    if ((pDevice->bEncryptionEnable) && (pDevice->bTransmitKey)) {
         KeybSetDefaultKey(&(pDevice->sKey),
                             (unsigned long)(pDevice->byKeyIndex | (1 << 31=
)),
                             pDevice->uKeyLength,
@@ -2094,7 +2094,7 @@ static int device_dma0_tx_80211(struct sk_buff *skb, =
struct net_device *dev) {
         return 0;
     }
=20
-    if (pDevice->bStopTx0Pkt =3D=3D true) {
+    if (pDevice->bStopTx0Pkt) {
         dev_kfree_skb_irq(skb);
         spin_unlock_irq(&pDevice->lock);
         return 0;
@@ -2127,7 +2127,7 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buf=
f *skb, unsigned int uNodeI
 //    unsigned char byKeyIndex =3D 0;
=20
=20
-    if (pDevice->bStopTx0Pkt =3D=3D true) {
+    if (pDevice->bStopTx0Pkt) {
         dev_kfree_skb_irq(skb);
         return false;
     }
@@ -2200,14 +2200,14 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_b=
uff *skb, unsigned int uNodeI
     } else if (pDevice->eCurrentPHYType =3D=3D PHY_TYPE_11A) {
         byPktType =3D PK_TYPE_11A;
     } else {
-        if (pDevice->bProtectMode =3D=3D true) {
+        if (pDevice->bProtectMode) {
             byPktType =3D PK_TYPE_11GB;
         } else {
             byPktType =3D PK_TYPE_11GA;
         }
     }
=20
-    if (pDevice->bEncryptionEnable =3D=3D true)
+    if (pDevice->bEncryptionEnable)
         bNeedEncryption =3D true;
=20
     if (pDevice->bEnableHostWEP) {
@@ -2286,7 +2286,7 @@ static int  device_xmit(struct sk_buff *skb, struct n=
et_device *dev) {
=20
=20
     spin_lock_irq(&pDevice->lock);
-    if (pDevice->bLinkPass =3D=3D false) {
+    if (!pDevice->bLinkPass) {
         dev_kfree_skb_irq(skb);
         spin_unlock_irq(&pDevice->lock);
         return 0;
@@ -2341,7 +2341,7 @@ static int  device_xmit(struct sk_buff *skb, struct n=
et_device *dev) {
             }
         }
=20
-        if (bNodeExist =3D=3D false) {
+        if (!bNodeExist) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"Unknown STA not found in n=
ode DB \n");
             dev_kfree_skb_irq(skb);
             spin_unlock_irq(&pDevice->lock);
@@ -2362,7 +2362,7 @@ static int  device_xmit(struct sk_buff *skb, struct n=
et_device *dev) {
     }
=20
=20
-    if (pDevice->bEncryptionEnable =3D=3D true) {
+    if (pDevice->bEncryptionEnable) {
         bNeedEncryption =3D true;
         // get Transmit key
         do {
@@ -2411,7 +2411,7 @@ static int  device_xmit(struct sk_buff *skb, struct n=
et_device *dev) {
=20
     if (pDevice->bEnableHostWEP) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"acdma0: STA index %d\n", uNode=
Index);
-        if (pDevice->bEncryptionEnable =3D=3D true) {
+        if (pDevice->bEncryptionEnable) {
             pTransmitKey =3D &STempKey;
             pTransmitKey->byCipherSuite =3D pMgmt->sNodeDBTable[uNodeIndex=
].byCipherSuite;
             pTransmitKey->dwKeyIndex =3D pMgmt->sNodeDBTable[uNodeIndex].d=
wKeyIndex;
@@ -2519,7 +2519,7 @@ pDevice->byTopCCKBasicRate,pDevice->byTopOFDMBasicRat=
e);
     } else if (pDevice->eCurrentPHYType =3D=3D PHY_TYPE_11A) {
         byPktType =3D PK_TYPE_11A;
     } else {
-        if (pDevice->bProtectMode =3D=3D true) {
+        if (pDevice->bProtectMode) {
             byPktType =3D PK_TYPE_11GB;
         } else {
             byPktType =3D PK_TYPE_11GA;
@@ -2530,7 +2530,7 @@ pDevice->byTopCCKBasicRate,pDevice->byTopOFDMBasicRat=
e);
 //	printk("FIX RATE:CurrentRate is %d");
 //#endif
=20
-    if (bNeedEncryption =3D=3D true) {
+    if (bNeedEncryption) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ntohs Pkt Type=3D%04x\n", ntohs=
(pDevice->sTxEthHeader.wType));
         if ((pDevice->sTxEthHeader.wType) =3D=3D TYPE_PKT_802_1x) {
             bNeedEncryption =3D false;
@@ -2540,7 +2540,7 @@ pDevice->byTopCCKBasicRate,pDevice->byTopOFDMBasicRat=
e);
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Don't Find TX KEY\n=
");
                 }
                 else {
-                    if (bTKIP_UseGTK =3D=3D true) {
+                    if (bTKIP_UseGTK) {
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"error: KEY is G=
TK!!~~\n");
                     }
                     else {
@@ -2745,7 +2745,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_=
instance) {
                 MACvSelectPage0(pDevice->PortOffset);
                //xxxx
                // WCMDbFlushCommandQueue(pDevice->pMgmt, true);
-                if (set_channel(pDevice, pDevice->pCurrMeasureEID->sReq.by=
Channel) =3D=3D true) {
+                if (set_channel(pDevice, pDevice->pCurrMeasureEID->sReq.by=
Channel)) {
                     pDevice->bMeasureInProgress =3D true;
                     MACvSelectPage1(pDevice->PortOffset);
                     MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MSRCTL, MSR=
CTL_READY);
@@ -2796,12 +2796,12 @@ static  irqreturn_t  device_intr(int irq,  void *de=
v_instance) {
             if (pDevice->dwIsr & ISR_QUIETSTART) {
                 do {
                     ;
-                } while (CARDbStartQuiet(pDevice) =3D=3D false);
+                } while (!CARDbStartQuiet(pDevice));
             }
         }
=20
         if (pDevice->dwIsr & ISR_TBTT) {
-            if (pDevice->bEnableFirstQuiet =3D=3D true) {
+            if (pDevice->bEnableFirstQuiet) {
                 pDevice->byQuietStartCount--;
                 if (pDevice->byQuietStartCount =3D=3D 0) {
                     pDevice->bEnableFirstQuiet =3D false;
@@ -2810,7 +2810,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_=
instance) {
                     MACvSelectPage0(pDevice->PortOffset);
                 }
             }
-            if ((pDevice->bChannelSwitch =3D=3D true) &&
+            if ((pDevice->bChannelSwitch) &&
                 (pDevice->eOPMode =3D=3D OP_MODE_INFRASTRUCTURE)) {
                 pDevice->byChannelSwitchCount--;
                 if (pDevice->byChannelSwitchCount =3D=3D 0) {
@@ -2827,7 +2827,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_=
instance) {
             if (pDevice->eOPMode =3D=3D OP_MODE_ADHOC) {
                 //pDevice->bBeaconSent =3D false;
             } else {
-                if ((pDevice->bUpdateBBVGA) && (pDevice->bLinkPass =3D=3D =
true) && (pDevice->uCurrRSSI !=3D 0)) {
+                if ((pDevice->bUpdateBBVGA) && (pDevice->bLinkPass) && (pD=
evice->uCurrRSSI !=3D 0)) {
                     long            ldBm;
=20
                     RFvRSSITodBm(pDevice, (unsigned char) pDevice->uCurrRS=
SI, &ldBm);
@@ -2897,7 +2897,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_=
instance) {
             }
             pDevice->bBeaconSent =3D true;
=20
-            if (pDevice->bChannelSwitch =3D=3D true) {
+            if (pDevice->bChannelSwitch) {
                 pDevice->byChannelSwitchCount--;
                 if (pDevice->byChannelSwitchCount =3D=3D 0) {
                     pDevice->bChannelSwitch =3D false;
@@ -3555,7 +3555,7 @@ static int  device_ioctl(struct net_device *dev, stru=
ct ifreq *rq, int cmd) {
            netif_stop_queue(pDevice->dev);
 	#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	      pMgmt->eScanType =3D WMAC_SCAN_ACTIVE;
-	 if(pDevice->bWPASuppWextEnabled !=3Dtrue)
+	 if(!pDevice->bWPASuppWextEnabled)
 	 #endif
            bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, pMgmt->=
abyDesireSSID);
            bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
@@ -3698,7 +3698,7 @@ viawget_resume(struct pci_dev *pcid)
         spin_lock_irq(&pDevice->lock);
         MACvRestoreContext(pDevice->PortOffset, pDevice->abyMacContext);
         device_init_registers(pDevice, DEVICE_INIT_DXPL);
-        if (pMgmt->sNodeDBTable[0].bActive =3D=3D true) { // Assoc with BS=
S
+        if (pMgmt->sNodeDBTable[0].bActive) { // Assoc with BSS
             pMgmt->sNodeDBTable[0].bActive =3D false;
             pDevice->bLinkPass =3D false;
             if(pMgmt->eCurrMode =3D=3D WMAC_MODE_IBSS_STA) {
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index c0fab4b..d4bf2f3 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -413,7 +413,7 @@ device_receive_frame (
=20
   pMACHeader=3D(PS802_11Header)((unsigned char *) (skb->data)+8);
 //PLICE_DEBUG<-
-	if (pDevice->bMeasureInProgress =3D=3D true) {
+	if (pDevice->bMeasureInProgress) {
         if ((*pbyRsr & RSR_CRCOK) !=3D 0) {
             pDevice->byBasicMap |=3D 0x01;
         }
@@ -470,7 +470,7 @@ device_receive_frame (
     }
=20
     if (pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_AP) {
-        if (s_bAPModeRxCtl(pDevice, pbyFrame, iSANodeIndex) =3D=3D true) {
+        if (s_bAPModeRxCtl(pDevice, pbyFrame, iSANodeIndex)) {
             return false;
         }
     }
@@ -652,7 +652,7 @@ device_receive_frame (
         }
         else {
             // discard DATA packet while not associate || BSSID error
-            if ((pDevice->bLinkPass =3D=3D false) ||
+            if ((!pDevice->bLinkPass) ||
                 !(*pbyRsr & RSR_BSSIDOK)) {
                 if (bDeFragRx) {
                     if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[=
pDevice->uCurrentDFCBIdx])) {
@@ -705,7 +705,7 @@ device_receive_frame (
     // Now it only supports 802.11g Infrastructure Mode, and support rate =
must up to 54 Mbps
     if (pDevice->bDiversityEnable && (FrameSize>50) &&
         (pDevice->eOPMode =3D=3D OP_MODE_INFRASTRUCTURE) &&
-        (pDevice->bLinkPass =3D=3D true)) {
+        (pDevice->bLinkPass)) {
 	//printk("device_receive_frame: RxRate is %d\n",*pbyRxRate);
 		BBvAntennaDiversity(pDevice, s_byGetRateIdx(*pbyRxRate), 0);
     }
@@ -732,7 +732,7 @@ device_receive_frame (
=20
     // -----------------------------------------------
=20
-    if ((pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_AP) && (pDevice->bEnable802=
1x =3D=3D true)){
+    if ((pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_AP) && (pDevice->bEnable802=
1x)){
         unsigned char abyMacHdr[24];
=20
         // Only 802.1x packet incoming allowed
@@ -747,7 +747,7 @@ device_receive_frame (
         if (wEtherType =3D=3D ETH_P_PAE) {
             skb->dev =3D pDevice->apdev;
=20
-            if (bIsWEP =3D=3D true) {
+            if (bIsWEP) {
                 // strip IV header(8)
                 memcpy(&abyMacHdr[0], (skb->data + 4), 24);
                 memcpy((skb->data + 4 + cbIVOffset), &abyMacHdr[0], 24);
@@ -824,7 +824,7 @@ device_receive_frame (
=20
=20
             if ((cpu_to_le32(*pdwMIC_L) !=3D dwLocalMIC_L) || (cpu_to_le32=
(*pdwMIC_R) !=3D dwLocalMIC_R) ||
-                (pDevice->bRxMICFail =3D=3D true)) {
+                (pDevice->bRxMICFail)) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC comparison is fail!=
\n");
                 pDevice->bRxMICFail =3D false;
                 //pDevice->s802_11Counter.TKIPLocalMICFailures.QuadPart++;
@@ -952,13 +952,7 @@ device_receive_frame (
         return false;
=20
     if (pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_AP) {
-        if (s_bAPModeRxData(pDevice,
-                            skb,
-                            FrameSize,
-                            cbHeaderOffset,
-                            iSANodeIndex,
-                            iDANodeIndex
-                            ) =3D=3D false) {
+        if (!s_bAPModeRxData(pDevice, skb, FrameSize, cbHeaderOffset, iSAN=
odeIndex, iDANodeIndex)) {
=20
             if (bDeFragRx) {
                 if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDev=
ice->uCurrentDFCBIdx])) {
@@ -1200,7 +1194,7 @@ static bool s_bHandleRxEncryption (
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey =3D=3D NULL\n");
         if (byDecMode =3D=3D KEY_CTL_WEP) {
 //            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass =3D=3D true) {
+        } else if (pDevice->bLinkPass) {
 //            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
         }
         return false;
@@ -1208,7 +1202,7 @@ static bool s_bHandleRxEncryption (
     if (byDecMode !=3D pKey->byCipherSuite) {
         if (byDecMode =3D=3D KEY_CTL_WEP) {
 //            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass =3D=3D true) {
+        } else if (pDevice->bLinkPass) {
 //            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
         }
         *pKeyOut =3D NULL;
@@ -1315,7 +1309,7 @@ static bool s_bHostWepRxEncryption (
     if (byDecMode !=3D pKey->byCipherSuite) {
         if (byDecMode =3D=3D KEY_CTL_WEP) {
 //            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass =3D=3D true) {
+        } else if (pDevice->bLinkPass) {
 //            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
         }
         return false;
@@ -1326,7 +1320,7 @@ static bool s_bHostWepRxEncryption (
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"byDecMode =3D=3D KEY_CTL_WEP \n=
");
         if ((pDevice->byLocalID <=3D REV_ID_VT3253_A1) ||
             (((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP =3D=3D true) ||
-            (bOnFly =3D=3D false)) {
+            (!bOnFly)) {
             // Software WEP
             // 1. 3253A
             // 2. WEP 256
@@ -1359,7 +1353,7 @@ static bool s_bHostWepRxEncryption (
=20
         if (byDecMode =3D=3D KEY_CTL_TKIP) {
=20
-            if ((pDevice->byLocalID <=3D REV_ID_VT3253_A1) || (bOnFly =3D=
=3D false)) {
+            if ((pDevice->byLocalID <=3D REV_ID_VT3253_A1) || (!bOnFly)) {
                 // Software TKIP
                 // 1. 3253 A
                 // 2. NotOnFly
@@ -1379,7 +1373,7 @@ static bool s_bHostWepRxEncryption (
         }
=20
         if (byDecMode =3D=3D KEY_CTL_CCMP) {
-            if (bOnFly =3D=3D false) {
+            if (!bOnFly) {
                 // Software CCMP
                 // NotOnFly
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"soft KEY_CTL_CCMP\n");
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hosta=
p.c
index 7735027..3f5f55d 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -521,10 +521,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 	if (param->u.crypt.alg =3D=3D WPA_ALG_NONE) {
=20
         if (pMgmt->sNodeDBTable[iNodeIndex].bOnFly =3D=3D true) {
-            if (KeybRemoveKey(&(pDevice->sKey),
-                                param->sta_addr,
-                                pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex=
,
-                                pDevice->PortOffset) =3D=3D false) {
+            if (!KeybRemoveKey(&(pDevice->sKey), param->sta_addr, pMgmt->s=
NodeDBTable[iNodeIndex].dwKeyIndex, pDevice->PortOffset)) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybRemoveKey fail \n"=
);
             }
             pMgmt->sNodeDBTable[iNodeIndex].bOnFly =3D false;
@@ -575,15 +572,7 @@ static int hostap_set_encryption(PSDevice pDevice,
         } else {
             // 8021x enable, individual key
             dwKeyIndex |=3D (1 << 30); // set pairwise key
-            if (KeybSetKey(&(pDevice->sKey),
-                           &param->sta_addr[0],
-                           dwKeyIndex & ~(USE_KEYRSC),
-                           param->u.crypt.key_len,
-                           (PQWORD) &(KeyRSC),
-                           (unsigned char *)abyKey,
-                            KEY_CTL_WEP,
-                            pDevice->PortOffset,
-                            pDevice->byLocalID) =3D=3D true) {
+            if (KeybSetKey(&(pDevice->sKey), &param->sta_addr[0], dwKeyInd=
ex & ~(USE_KEYRSC), param->u.crypt.key_len, (PQWORD) & (KeyRSC), (unsigned =
char *)abyKey, KEY_CTL_WEP, pDevice->PortOffset, pDevice->byLocalID)) {
=20
                 pMgmt->sNodeDBTable[iNodeIndex].bOnFly =3D true;
=20
@@ -644,15 +633,7 @@ static int hostap_set_encryption(PSDevice pDevice,
=20
     } else {
         dwKeyIndex |=3D (1 << 30); // set pairwise key
-        if (KeybSetKey(&(pDevice->sKey),
-                       &param->sta_addr[0],
-                       dwKeyIndex,
-                       param->u.crypt.key_len,
-                       (PQWORD) &(KeyRSC),
-                       (unsigned char *)abyKey,
-                        byKeyDecMode,
-                        pDevice->PortOffset,
-                        pDevice->byLocalID) =3D=3D true) {
+        if (KeybSetKey(&(pDevice->sKey), &param->sta_addr[0], dwKeyIndex, =
param->u.crypt.key_len, (PQWORD) & (KeyRSC), (unsigned char *)abyKey, byKey=
DecMode, pDevice->PortOffset, pDevice->byLocalID)) {
=20
             pMgmt->sNodeDBTable[iNodeIndex].bOnFly =3D true;
=20
@@ -665,7 +646,7 @@ static int hostap_set_encryption(PSDevice pDevice,
=20
     }
=20
-    if (bKeyTableFull =3D=3D true) {
+    if (bKeyTableFull) {
         wKeyCtl &=3D 0x7F00;              // clear all key control filed
         wKeyCtl |=3D (byKeyDecMode << 4);
         wKeyCtl |=3D (byKeyDecMode);
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 0ff8d7b..22c70d5 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -64,12 +64,12 @@ s_vCheckKeyTableValid (PSKeyManagement pTable, unsigned=
 long dwIoBase)
     int i;
=20
     for (i=3D0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse =3D=3D true) &&
-            (pTable->KeyTable[i].PairwiseKey.bKeyValid =3D=3D false) &&
-            (pTable->KeyTable[i].GroupKey[0].bKeyValid =3D=3D false) &&
-            (pTable->KeyTable[i].GroupKey[1].bKeyValid =3D=3D false) &&
-            (pTable->KeyTable[i].GroupKey[2].bKeyValid =3D=3D false) &&
-            (pTable->KeyTable[i].GroupKey[3].bKeyValid =3D=3D false)
+        if ((pTable->KeyTable[i].bInUse) &&
+            (!pTable->KeyTable[i].PairwiseKey.bKeyValid) &&
+            (!pTable->KeyTable[i].GroupKey[0].bKeyValid) &&
+            (!pTable->KeyTable[i].GroupKey[1].bKeyValid) &&
+            (!pTable->KeyTable[i].GroupKey[2].bKeyValid) &&
+            (!pTable->KeyTable[i].GroupKey[3].bKeyValid)
             ) {
=20
             pTable->KeyTable[i].bInUse =3D false;
@@ -144,10 +144,10 @@ bool KeybGetKey (
=20
     *pKey =3D NULL;
     for (i=3D0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse =3D=3D true) &&
+        if ((pTable->KeyTable[i].bInUse) &&
             !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
             if (dwKeyIndex =3D=3D 0xFFFFFFFF) {
-                if (pTable->KeyTable[i].PairwiseKey.bKeyValid =3D=3D true)=
 {
+                if (pTable->KeyTable[i].PairwiseKey.bKeyValid) {
                     *pKey =3D &(pTable->KeyTable[i].PairwiseKey);
                     return (true);
                 }
@@ -155,7 +155,7 @@ bool KeybGetKey (
                     return (false);
                 }
             } else if (dwKeyIndex < MAX_GROUP_KEY) {
-                if (pTable->KeyTable[i].GroupKey[dwKeyIndex].bKeyValid =3D=
=3D true) {
+                if (pTable->KeyTable[i].GroupKey[dwKeyIndex].bKeyValid) {
                     *pKey =3D &(pTable->KeyTable[i].GroupKey[dwKeyIndex]);
                     return (true);
                 }
@@ -210,12 +210,12 @@ bool KeybSetKey (
=20
     j =3D (MAX_KEY_TABLE-1);
     for (i=3D0;i<(MAX_KEY_TABLE-1);i++) {
-        if ((pTable->KeyTable[i].bInUse =3D=3D false) &&
+        if ((!pTable->KeyTable[i].bInUse) &&
             (j =3D=3D (MAX_KEY_TABLE-1))) {
             // found empty table
             j =3D i;
         }
-        if ((pTable->KeyTable[i].bInUse =3D=3D true) &&
+        if ((pTable->KeyTable[i].bInUse) &&
             !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
             // found table already exist
             if ((dwKeyIndex & PAIRWISE_KEY) !=3D 0) {
@@ -397,7 +397,7 @@ bool KeybRemoveKey (
     }
=20
     for (i=3D0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse =3D=3D true) &&
+        if ((pTable->KeyTable[i].bInUse) &&
             !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
             if ((dwKeyIndex & PAIRWISE_KEY) !=3D 0) {
                 pTable->KeyTable[i].PairwiseKey.bKeyValid =3D false;
@@ -444,7 +444,7 @@ bool KeybRemoveAllKey (
     int  i,u;
=20
     for (i=3D0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse =3D=3D true) &&
+        if ((pTable->KeyTable[i].bInUse) &&
             !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
             pTable->KeyTable[i].PairwiseKey.bKeyValid =3D false;
             for(u=3D0;u<MAX_GROUP_KEY;u++) {
@@ -478,7 +478,7 @@ void KeyvRemoveWEPKey (
 {
=20
    if ((dwKeyIndex & 0x000000FF) < MAX_GROUP_KEY) {
-        if (pTable->KeyTable[MAX_KEY_TABLE-1].bInUse =3D=3D true) {
+        if (pTable->KeyTable[MAX_KEY_TABLE - 1].bInUse) {
             if (pTable->KeyTable[MAX_KEY_TABLE-1].GroupKey[dwKeyIndex & 0x=
000000FF].byCipherSuite =3D=3D KEY_CTL_WEP) {
                 pTable->KeyTable[MAX_KEY_TABLE-1].GroupKey[dwKeyIndex & 0x=
000000FF].bKeyValid =3D false;
                 if ((dwKeyIndex & 0x7FFFFFFF) =3D=3D (pTable->KeyTable[MAX=
_KEY_TABLE-1].dwGTKeyIndex & 0x7FFFFFFF)) {
@@ -528,12 +528,12 @@ bool KeybGetTransmitKey (
=20
     *pKey =3D NULL;
     for (i=3D0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse =3D=3D true) &&
+        if ((pTable->KeyTable[i].bInUse) &&
             !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
=20
             if (dwKeyType =3D=3D PAIRWISE_KEY) {
=20
-                if (pTable->KeyTable[i].PairwiseKey.bKeyValid =3D=3D true)=
 {
+                if (pTable->KeyTable[i].PairwiseKey.bKeyValid) {
                     *pKey =3D &(pTable->KeyTable[i].PairwiseKey);
=20
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybGetTransmitKey:=
");
@@ -556,7 +556,7 @@ bool KeybGetTransmitKey (
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ERROR: dwGTKeyIndex=
 =3D=3D 0 !!!\n");
                     return false;
                 }
-                if (pTable->KeyTable[i].GroupKey[(pTable->KeyTable[i].dwGT=
KeyIndex&0x000000FF)].bKeyValid =3D=3D true) {
+                if (pTable->KeyTable[i].GroupKey[(pTable->KeyTable[i].dwGT=
KeyIndex & 0x000000FF)].bKeyValid) {
                     *pKey =3D &(pTable->KeyTable[i].GroupKey[(pTable->KeyT=
able[i].dwGTKeyIndex&0x000000FF)]);
=20
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybGetTransmit=
Key:");
@@ -606,8 +606,8 @@ bool KeybCheckPairewiseKey (
=20
     *pKey =3D NULL;
     for (i=3D0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse =3D=3D true) &&
-            (pTable->KeyTable[i].PairwiseKey.bKeyValid =3D=3D true)) {
+        if ((pTable->KeyTable[i].bInUse) &&
+            (pTable->KeyTable[i].PairwiseKey.bKeyValid)) {
             *pKey =3D &(pTable->KeyTable[i].PairwiseKey);
             return (true);
         }
@@ -678,7 +678,7 @@ bool KeybSetDefaultKey (
         pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl |=3D 0x4000;            =
  // disable on-fly disable address match
         pTable->KeyTable[MAX_KEY_TABLE-1].bSoftWEP =3D true;
     } else {
-        if (pTable->KeyTable[MAX_KEY_TABLE-1].bSoftWEP =3D=3D false)
+        if (!pTable->KeyTable[MAX_KEY_TABLE - 1].bSoftWEP)
             pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl |=3D 0xC000;        =
  // enable on-fly disable address match
     }
=20
@@ -764,7 +764,7 @@ bool KeybSetAllGroupKey (
     }
=20
     for (i=3D0; i < MAX_KEY_TABLE-1; i++) {
-        if (pTable->KeyTable[i].bInUse =3D=3D true) {
+        if (pTable->KeyTable[i].bInUse) {
             // found table already exist
             // Group key
             pKey =3D &(pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000F=
F]);
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index f8d1651..85e83c1 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -968,13 +968,13 @@ bool MACbSafeStop (unsigned long dwIoBase)
 {
     MACvRegBitsOff(dwIoBase, MAC_REG_TCR, TCR_AUTOBCNTX);
=20
-    if (MACbSafeRxOff(dwIoBase) =3D=3D false) {
+    if (!MACbSafeRxOff(dwIoBase)) {
         DBG_PORT80(0xA1);
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" MACbSafeRxOff =3D=3D false)\n"=
);
         MACbSafeSoftwareReset(dwIoBase);
         return false;
     }
-    if (MACbSafeTxOff(dwIoBase) =3D=3D false) {
+    if (!MACbSafeTxOff(dwIoBase)) {
         DBG_PORT80(0xA2);
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" MACbSafeTxOff =3D=3D false)\n"=
);
         MACbSafeSoftwareReset(dwIoBase);
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.=
c
index 4c0b02e..0ef4e44 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -307,16 +307,16 @@ PSbSendNullPacket(
     unsigned int uIdx;
=20
=20
-    if (pDevice->bLinkPass =3D=3D false) {
+    if (!pDevice->bLinkPass) {
         return false;
     }
     #ifdef TxInSleep
-     if ((pDevice->bEnablePSMode =3D=3D false) &&
-	  (pDevice->fTxDataInSleep =3D=3D false)){
+     if ((!pDevice->bEnablePSMode) &&
+	  (!pDevice->fTxDataInSleep)){
         return false;
     }
 #else
-    if (pDevice->bEnablePSMode =3D=3D false) {
+    if (!pDevice->bEnablePSMode) {
         return false;
     }
 #endif
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index b8ec783..94552ab 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -1115,7 +1115,7 @@ unsigned char byPwrdBm =3D 0;
     }
     bResult =3D RFbRawSetPower(pDevice, byPwr, uRATE);
 //    }
-    if (bResult =3D=3D true) {
+    if (bResult) {
        pDevice->byCurPwr =3D byPwr;
     }
     return bResult;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 6935b37..3149fc9 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -453,20 +453,20 @@ s_uGetDataDuration (
     unsigned char byFBOption
     )
 {
-    bool bLastFrag =3D 0;
+    bool bLastFrag =3D false;
     unsigned int uAckTime =3D0, uNextPktTime =3D 0;
=20
=20
=20
     if (uFragIdx =3D=3D (uMACfragNum-1)) {
-        bLastFrag =3D 1;
+        bLastFrag =3D true;
     }
=20
=20
     switch (byDurType) {
=20
     case DATADUR_B:    //DATADUR_B
-        if (((uMACfragNum =3D=3D 1)) || (bLastFrag =3D=3D 1)) {//Non Frag =
or Last Frag
+        if (((uMACfragNum =3D=3D 1)) || (bLastFrag)) {//Non Frag or Last F=
rag
             if (bNeedAck) {
             	uAckTime =3D BBuGetFrameTime(pDevice->byPreambleType, byPktTy=
pe, 14, pDevice->byTopCCKBasicRate);
                 return (pDevice->uSIFS + uAckTime);
@@ -490,7 +490,7 @@ s_uGetDataDuration (
         break;
=20
     case DATADUR_A:    //DATADUR_A
-        if (((uMACfragNum=3D=3D1)) || (bLastFrag=3D=3D1)) {//Non Frag or L=
ast Frag
+        if (((uMACfragNum=3D=3D1)) || (bLastFrag)) {//Non Frag or Last Fra=
g
             if(bNeedAck){
             	uAckTime =3D BBuGetFrameTime(pDevice->byPreambleType, byPktTy=
pe, 14, pDevice->byTopOFDMBasicRate);
                 return (pDevice->uSIFS + uAckTime);
@@ -514,7 +514,7 @@ s_uGetDataDuration (
         break;
=20
     case DATADUR_A_F0:    //DATADUR_A_F0
-	    if (((uMACfragNum=3D=3D1)) || (bLastFrag=3D=3D1)) {//Non Frag or Last=
 Frag
+	    if (((uMACfragNum=3D=3D1)) || (bLastFrag)) {//Non Frag or Last Frag
             if(bNeedAck){
             	uAckTime =3D BBuGetFrameTime(pDevice->byPreambleType, byPktTy=
pe, 14, pDevice->byTopOFDMBasicRate);
                 return (pDevice->uSIFS + uAckTime);
@@ -557,7 +557,7 @@ s_uGetDataDuration (
         break;
=20
     case DATADUR_A_F1:    //DATADUR_A_F1
-        if (((uMACfragNum=3D=3D1)) || (bLastFrag=3D=3D1)) {//Non Frag or L=
ast Frag
+        if (((uMACfragNum=3D=3D1)) || (bLastFrag)) {//Non Frag or Last Fra=
g
             if(bNeedAck){
             	uAckTime =3D BBuGetFrameTime(pDevice->byPreambleType, byPktTy=
pe, 14, pDevice->byTopOFDMBasicRate);
                 return (pDevice->uSIFS + uAckTime);
@@ -1390,7 +1390,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
         cbMACHdLen =3D WLAN_HDR_ADDR3_LEN;
=20
=20
-    if ((bNeedEncrypt =3D=3D true) && (pTransmitKey !=3D NULL)) {
+    if ((bNeedEncrypt) && (pTransmitKey !=3D NULL)) {
         if (pTransmitKey->byCipherSuite =3D=3D KEY_CTL_WEP) {
             cbIVlen =3D 4;
             cbICVlen =3D 4;
@@ -1418,7 +1418,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
=20
     cbFrameSize =3D cbMACHdLen + cbIVlen + (cbFrameBodySize + cbMIClen) + =
cbICVlen + cbFCSlen;
=20
-    if ((bNeedACK =3D=3D false) ||
+    if ((!bNeedACK) ||
         (cbFrameSize < pDevice->wRTSThreshold) ||
         ((cbFrameSize >=3D pDevice->wFragmentationThreshold) && (pDevice->=
wFragmentationThreshold <=3D pDevice->wRTSThreshold))
         ) {
@@ -1444,7 +1444,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
     if (byPktType =3D=3D PK_TYPE_11GB || byPktType =3D=3D PK_TYPE_11GA) {/=
/802.11g packet
=20
         if (byFBOption =3D=3D AUTO_FB_NONE) {
-            if (bRTS =3D=3D true) {//RTS_need
+            if (bRTS) {//RTS_need
                 pvRrvTime =3D (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSi=
ze);
                 pMICHDR =3D (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +=
 sizeof(SRrvTime_gRTS));
                 pvRTS =3D (PSRTS_g) (pbyTxBufferAddr + wTxBufSize + sizeof=
(SRrvTime_gRTS) + cbMICHDR);
@@ -1462,7 +1462,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
             }
         } else {
             // Auto Fall Back
-            if (bRTS =3D=3D true) {//RTS_need
+            if (bRTS) {//RTS_need
                 pvRrvTime =3D (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSi=
ze);
                 pMICHDR =3D (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +=
 sizeof(SRrvTime_gRTS));
                 pvRTS =3D (PSRTS_g_FB) (pbyTxBufferAddr + wTxBufSize + siz=
eof(SRrvTime_gRTS) + cbMICHDR);
@@ -1483,7 +1483,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
     else {//802.11a/b packet
=20
         if (byFBOption =3D=3D AUTO_FB_NONE) {
-            if (bRTS =3D=3D true) {
+            if (bRTS) {
                 pvRrvTime =3D (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize=
);
                 pMICHDR =3D (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +=
 sizeof(SRrvTime_ab));
                 pvRTS =3D (PSRTS_ab) (pbyTxBufferAddr + wTxBufSize + sizeo=
f(SRrvTime_ab) + cbMICHDR);
@@ -1501,7 +1501,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
             }
         } else {
             // Auto Fall Back
-            if (bRTS =3D=3D true) {//RTS_need
+            if (bRTS) {//RTS_need
                 pvRrvTime =3D (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize=
);
                 pMICHDR =3D (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +=
 sizeof(SRrvTime_ab));
                 pvRTS =3D (PSRTS_a_FB) (pbyTxBufferAddr + wTxBufSize + siz=
eof(SRrvTime_ab) + cbMICHDR);
@@ -1522,7 +1522,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
     memset((void *)(pbyTxBufferAddr + wTxBufSize), 0, (cbHeaderLength - wT=
xBufSize));
=20
 //////////////////////////////////////////////////////////////////
-    if ((bNeedEncrypt =3D=3D true) && (pTransmitKey !=3D NULL) && (pTransm=
itKey->byCipherSuite =3D=3D KEY_CTL_TKIP)) {
+    if ((bNeedEncrypt) && (pTransmitKey !=3D NULL) && (pTransmitKey->byCip=
herSuite =3D=3D KEY_CTL_TKIP)) {
         if (pDevice->pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPANONE) {
             dwMICKey0 =3D *(unsigned long *)(&pTransmitKey->abyKey[16]);
             dwMICKey1 =3D *(unsigned long *)(&pTransmitKey->abyKey[20]);
@@ -1549,7 +1549,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
     pbyPayloadHead =3D (unsigned char *)(pbyMacHdr + cbMACHdLen + uPadding=
 + cbIVlen);
     pbyIVHead =3D (unsigned char *)(pbyMacHdr + cbMACHdLen + uPadding);
=20
-    if ((cbFrameSize > pDevice->wFragmentationThreshold) && (bNeedACK =3D=
=3D true) && (bIsWEP256 =3D=3D false)) {
+    if ((cbFrameSize > pDevice->wFragmentationThreshold) && (bNeedACK) && =
(!bIsWEP256)) {
         // Fragmentation
         // FragThreshold =3D Fragment size(Hdr+(IV)+fragment payload+(MIC)=
+(ICV)+FCS)
         cbFragmentSize =3D pDevice->wFragmentationThreshold;
@@ -1584,7 +1584,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
                 vGenerateMACHeader(pDevice, pbyMacHdr, (unsigned short)uDu=
ration, psEthHeader, bNeedEncrypt,
                                    wFragType, uDMAIdx, uFragIdx);
=20
-                if (bNeedEncrypt =3D=3D true) {
+                if (bNeedEncrypt) {
                     //Fill TXKEY
                     s_vFillTxKey(pDevice, (unsigned char *)(psTxBufHd->adw=
TxKey), pbyIVHead, pTransmitKey,
                                  pbyMacHdr, (unsigned short)cbFragPayloadS=
ize, (unsigned char *)pMICHDR);
@@ -1636,7 +1636,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
=20
                 uTotalCopyLength +=3D cbFragPayloadSize - cb802_1_H_len;
=20
-                if ((bNeedEncrypt =3D=3D true) && (pTransmitKey !=3D NULL)=
 && (pTransmitKey->byCipherSuite =3D=3D KEY_CTL_TKIP)) {
+                if ((bNeedEncrypt) && (pTransmitKey !=3D NULL) && (pTransm=
itKey->byCipherSuite =3D=3D KEY_CTL_TKIP)) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Start MIC: %d\n", c=
bFragPayloadSize);
                     MIC_vAppend((pbyBuffer + uLength - cb802_1_H_len), cbF=
ragPayloadSize);
=20
@@ -1689,7 +1689,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
                 vGenerateMACHeader(pDevice, pbyMacHdr, (unsigned short)uDu=
ration, psEthHeader, bNeedEncrypt,
                                    wFragType, uDMAIdx, uFragIdx);
=20
-                if (bNeedEncrypt =3D=3D true) {
+                if (bNeedEncrypt) {
                     //Fill TXKEY
                     s_vFillTxKey(pDevice, (unsigned char *)(psTxBufHd->adw=
TxKey), pbyIVHead, pTransmitKey,
                                  pbyMacHdr, (unsigned short)cbLastFragPayl=
oadSize, (unsigned char *)pMICHDR);
@@ -1718,7 +1718,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
                 memcpy(pbyBuffer, (void *)psTxBufHd, uLength);
=20
                 // Copy the Packet into a tx Buffer
-                if (bMIC2Frag =3D=3D false) {
+                if (!bMIC2Frag) {
=20
                     memcpy((pbyBuffer + uLength),
                              (pPacket + 14 + uTotalCopyLength),
@@ -1728,11 +1728,11 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char b=
yPktType, unsigned char *pbyT
                     uTmpLen =3D cbLastFragPayloadSize - cbMIClen;
=20
                 }
-                if ((bNeedEncrypt =3D=3D true) && (pTransmitKey !=3D NULL)=
 && (pTransmitKey->byCipherSuite =3D=3D KEY_CTL_TKIP)) {
+                if ((bNeedEncrypt) && (pTransmitKey !=3D NULL) && (pTransm=
itKey->byCipherSuite =3D=3D KEY_CTL_TKIP)) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"LAST: uMICFragLen:%=
d, cbLastFragPayloadSize:%d, uTmpLen:%d\n",
                                    uMICFragLen, cbLastFragPayloadSize, uTm=
pLen);
=20
-                    if (bMIC2Frag =3D=3D false) {
+                    if (!bMIC2Frag) {
                         if (uTmpLen !=3D 0)
                             MIC_vAppend((pbyBuffer + uLength), uTmpLen);
                         pdwMIC_L =3D (unsigned long *)(pbyBuffer + uLength=
 + uTmpLen);
@@ -1820,7 +1820,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
                                    wFragType, uDMAIdx, uFragIdx);
=20
=20
-                if (bNeedEncrypt =3D=3D true) {
+                if (bNeedEncrypt) {
                     //Fill TXKEY
                     s_vFillTxKey(pDevice, (unsigned char *)(psTxBufHd->adw=
TxKey), pbyIVHead, pTransmitKey,
                                  pbyMacHdr, (unsigned short)cbFragPayloadS=
ize, (unsigned char *)pMICHDR);
@@ -1861,7 +1861,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
=20
                 uTotalCopyLength +=3D uTmpLen;
=20
-                if ((bNeedEncrypt =3D=3D true) && (pTransmitKey !=3D NULL)=
 && (pTransmitKey->byCipherSuite =3D=3D KEY_CTL_TKIP)) {
+                if ((bNeedEncrypt) && (pTransmitKey !=3D NULL) && (pTransm=
itKey->byCipherSuite =3D=3D KEY_CTL_TKIP)) {
=20
                     MIC_vAppend((pbyBuffer + uLength), uTmpLen);
=20
@@ -1949,7 +1949,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
         vGenerateMACHeader(pDevice, pbyMacHdr, (unsigned short)uDuration, =
psEthHeader, bNeedEncrypt,
                            wFragType, uDMAIdx, 0);
=20
-        if (bNeedEncrypt =3D=3D true) {
+        if (bNeedEncrypt) {
             //Fill TXKEY
             s_vFillTxKey(pDevice, (unsigned char *)(psTxBufHd->adwTxKey), =
pbyIVHead, pTransmitKey,
                          pbyMacHdr, (unsigned short)cbFrameBodySize, (unsi=
gned char *)pMICHDR);
@@ -1998,7 +1998,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
                  cbFrameBodySize - cb802_1_H_len
                  );
=20
-        if ((bNeedEncrypt =3D=3D true) && (pTransmitKey !=3D NULL) && (pTr=
ansmitKey->byCipherSuite =3D=3D KEY_CTL_TKIP)){
+        if ((bNeedEncrypt) && (pTransmitKey !=3D NULL) && (pTransmitKey->b=
yCipherSuite =3D=3D KEY_CTL_TKIP)){
=20
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Length:%d, %d\n", cbFrameBo=
dySize - cb802_1_H_len, uLength);
             /*
@@ -2017,7 +2017,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byP=
ktType, unsigned char *pbyT
             MIC_vUnInit();
=20
=20
-            if (pDevice->bTxMICFail =3D=3D true) {
+            if (pDevice->bTxMICFail) {
                 *pdwMIC_L =3D 0;
                 *pdwMIC_R =3D 0;
                 pDevice->bTxMICFail =3D false;
@@ -2145,7 +2145,7 @@ vGenerateFIFOHeader(PSDevice pDevice, unsigned char b=
yPktType, unsigned char *pb
         pTxBufHead->wFIFOCtl |=3D FIFOCTL_11GA;
     }
     //Set FIFOCTL_GrpAckPolicy
-    if (pDevice->bGrpAckPolicy =3D=3D true) {//0000 0100 0000 0000
+    if (pDevice->bGrpAckPolicy) {//0000 0100 0000 0000
         pTxBufHead->wFIFOCtl |=3D	FIFOCTL_GRPACK;
     }
=20
@@ -2454,7 +2454,7 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPack=
et pPacket) {
     cbFrameSize =3D cbMacHdLen + cbFrameBodySize + cbIVlen + cbMIClen + cb=
ICVlen + cbFCSlen;
=20
     //Set FIFOCTL_GrpAckPolicy
-    if (pDevice->bGrpAckPolicy =3D=3D true) {//0000 0100 0000 0000
+    if (pDevice->bGrpAckPolicy) {//0000 0100 0000 0000
         pTxBufHead->wFIFOCtl |=3D	FIFOCTL_GRPACK;
     }
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFil=
lFragParameter()
@@ -2524,7 +2524,7 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPack=
et pPacket) {
         //}
         do {
             if ((pDevice->eOPMode =3D=3D OP_MODE_INFRASTRUCTURE) &&
-                (pDevice->bLinkPass =3D=3D true)) {
+                (pDevice->bLinkPass)) {
                 pbyBSSID =3D pDevice->abyBSSID;
                 // get pairwise key
                 if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWIS=
E_KEY, &pTransmitKey) =3D=3D false) {
@@ -2738,7 +2738,7 @@ cbGetFragCount (
         cbMACHdLen =3D WLAN_HDR_ADDR3_LEN;
=20
=20
-    if (pDevice->bEncryptionEnable =3D=3D true) {
+    if (pDevice->bEncryptionEnable) {
=20
         if (pTransmitKey =3D=3D NULL) {
             if ((pDevice->eEncryptionStatus =3D=3D Ndis802_11Encryption1En=
abled) ||
@@ -2768,7 +2768,7 @@ cbGetFragCount (
=20
     cbFrameSize =3D cbMACHdLen + cbIVlen + (cbFrameBodySize + cbMIClen) + =
cbICVlen + cbFCSlen;
=20
-    if ((cbFrameSize > pDevice->wFragmentationThreshold) && (bNeedACK =3D=
=3D true)) {
+    if ((cbFrameSize > pDevice->wFragmentationThreshold) && (bNeedACK)) {
         // Fragmentation
         cbFragmentSize =3D pDevice->wFragmentationThreshold;
         cbFragPayloadSize =3D cbFragmentSize - cbMACHdLen - cbIVlen - cbIC=
Vlen - cbFCSlen;
@@ -2992,7 +2992,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb=
, unsigned char *pbMPDU, un
     cbFrameSize =3D cbMacHdLen + cbFrameBodySize + cbIVlen + cbMIClen + cb=
ICVlen + cbFCSlen + cbExtSuppRate;
=20
     //Set FIFOCTL_GrpAckPolicy
-    if (pDevice->bGrpAckPolicy =3D=3D true) {//0000 0100 0000 0000
+    if (pDevice->bGrpAckPolicy) {//0000 0100 0000 0000
         pTxBufHead->wFIFOCtl |=3D	FIFOCTL_GRPACK;
     }
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFil=
lFragParameter()
@@ -3105,7 +3105,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb=
, unsigned char *pbMPDU, un
             MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
             MIC_vUnInit();
=20
-            if (pDevice->bTxMICFail =3D=3D true) {
+            if (pDevice->bTxMICFail) {
                 *pdwMIC_L =3D 0;
                 *pdwMIC_R =3D 0;
                 pDevice->bTxMICFail =3D false;
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntw=
ifi.c
index 0491d0b..71e3435 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -510,7 +510,7 @@ VNTWIFIvUpdateNodeTxCounter(
         }
     }
     pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts++;
-    if (bTxOk =3D=3D true) {
+    if (bTxOk) {
         // transmit success, TxAttempts at least plus one
         pMgmt->sNodeDBTable[uNodeIndex].uTxOk[MAX_RATE]++;
         pMgmt->sNodeDBTable[uNodeIndex].uTxOk[wRate]++;
@@ -603,7 +603,7 @@ VNTWIFIbyGetKeyCypher(
 {
     PSMgmtObject    pMgmt =3D (PSMgmtObject)pMgmtHandle;
=20
-    if (bGroupKey =3D=3D true) {
+    if (bGroupKey) {
         return (pMgmt->byCSSGK);
     } else {
         return (pMgmt->byCSSPK);
@@ -759,7 +759,7 @@ VNTWIFIbMeasureReport(
         pMgmt->uLengthOfRepEIDs +=3D (2 + pMgmt->pCurrMeasureEIDRep->len);
         pMgmt->pCurrMeasureEIDRep =3D (PWLAN_IE_MEASURE_REP) pbyCurrentEID=
;
     }
-    if (bEndOfReport =3D=3D true) {
+    if (bEndOfReport) {
         IEEE11hbMSRRepTx(pMgmt);
     }
     //spin_unlock_irq(&pDevice->lock);
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index bab3b01..d18e60c 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -355,7 +355,7 @@ vCommandTimer (
=20
     if (pDevice->dwDiagRefCount !=3D 0)
         return;
-    if (pDevice->bCmdRunning !=3D true)
+    if (!pDevice->bCmdRunning)
         return;
=20
     spin_lock_irq(&pDevice->lock);
@@ -365,7 +365,7 @@ vCommandTimer (
         case WLAN_CMD_SCAN_START:
=20
 	pDevice->byReAssocCount =3D 0;
-            if (pDevice->bRadioOff =3D=3D true) {
+            if (pDevice->bRadioOff) {
                 s_bCommandComplete(pDevice);
                 spin_unlock_irq(&pDevice->lock);
                 return;
@@ -432,7 +432,7 @@ vCommandTimer (
=20
                 vAdHocBeaconStop(pDevice);
=20
-                if (set_channel(pMgmt->pAdapter, pMgmt->uScanChannel) =3D=
=3D true) {
+                if (set_channel(pMgmt->pAdapter, pMgmt->uScanChannel)) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"SCAN Channel: %d\n"=
, pMgmt->uScanChannel);
                 } else {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"SET SCAN Channel Fa=
il: %d\n", pMgmt->uScanChannel);
@@ -450,7 +450,7 @@ vCommandTimer (
                 }
=20
=20
-                if ((pMgmt->b11hEnable =3D=3D false) ||
+                if ((!pMgmt->b11hEnable) ||
                     (pMgmt->uScanChannel < CB_MAX_CHANNEL_24G)) {
                     s_vProbeChannel(pDevice);
                     spin_unlock_irq(&pDevice->lock);
@@ -540,7 +540,7 @@ vCommandTimer (
=20
         case WLAN_CMD_SSID_START:
         	pDevice->byReAssocCount =3D 0;
-            if (pDevice->bRadioOff =3D=3D true) {
+            if (pDevice->bRadioOff) {
                 s_bCommandComplete(pDevice);
                 spin_unlock_irq(&pDevice->lock);
                 return;
@@ -720,7 +720,7 @@ printk("chester-abyDesireSSID=3D%s\n",((PWLAN_IE_SSID)p=
Mgmt->abyDesireSSID)->abySS
                     netif_wake_queue(pDevice->dev);
                 }
 	     #ifdef TxInSleep
-		 if(pDevice->IsTxDataTrigger !=3D false)   {    //TxDataTimer is not tri=
ggered at the first time
+		 if(pDevice->IsTxDataTrigger)   {    //TxDataTimer is not triggered at t=
he first time
                      // printk("Re-initial TxDataTimer****\n");
 		    del_timer(&pDevice->sTimerTxData);
                       init_timer(&pDevice->sTimerTxData);
@@ -772,7 +772,7 @@ printk("chester-abyDesireSSID=3D%s\n",((PWLAN_IE_SSID)p=
Mgmt->abyDesireSSID)->abySS
                 pMgmt->eCurrState =3D WMAC_STATE_IDLE;
                 pMgmt->eCurrMode =3D WMAC_MODE_STANDBY;
                 pDevice->bLinkPass =3D false;
-                if (pDevice->bEnableHostWEP =3D=3D true)
+                if (pDevice->bEnableHostWEP)
                     BSSvClearNodeDBTable(pDevice, 1);
                 else
                     BSSvClearNodeDBTable(pDevice, 0);
@@ -857,7 +857,7 @@ printk("chester-abyDesireSSID=3D%s\n",((PWLAN_IE_SSID)p=
Mgmt->abyDesireSSID)->abySS
=20
         case WLAN_CMD_RADIO_START :
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"eCommandState =3D=3D WLAN_C=
MD_RADIO_START\n");
-            if (pDevice->bRadioCmd =3D=3D true)
+            if (pDevice->bRadioCmd)
                 CARDbRadioPowerOn(pDevice);
             else
                 CARDbRadioPowerOff(pDevice);
@@ -1038,7 +1038,7 @@ bool bScheduleCommand (
     ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdEnqueueIdx, CMD_Q_SIZE);
     pDevice->cbFreeCmdQueue--;
=20
-    if (pDevice->bCmdRunning =3D=3D false) {
+    if (!pDevice->bCmdRunning) {
         s_bCommandComplete(pDevice);
     }
     else {
@@ -1126,8 +1126,8 @@ BSSvSecondTxData(
=20
   spin_lock_irq(&pDevice->lock);
   #if 1
-  if(((pDevice->bLinkPass =3D=3Dtrue)&&(pMgmt->eAuthenMode < WMAC_AUTH_WPA=
)) ||  //open && sharekey linking
-      (pDevice->fWPA_Authened =3D=3D true)) {   //wpa linking
+  if(((pDevice->bLinkPass)&&(pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||  //op=
en && sharekey linking
+      (pDevice->fWPA_Authened)) {   //wpa linking
  #else
   if(pDevice->bLinkPass =3D=3Dtrue) {
  #endif
diff --git a/drivers/staging/vt6655/wctl.c b/drivers/staging/vt6655/wctl.c
index c096583..08381e4 100644
--- a/drivers/staging/vt6655/wctl.c
+++ b/drivers/staging/vt6655/wctl.c
@@ -113,7 +113,7 @@ unsigned int WCTLuSearchDFCB (PSDevice pDevice, PS802_1=
1Header pMACHeader)
 unsigned int ii;
=20
     for(ii=3D0;ii<pDevice->cbDFCB;ii++) {
-        if ((pDevice->sRxDFCB[ii].bInUse =3D=3D true) &&
+        if ((pDevice->sRxDFCB[ii].bInUse) &&
             (!compare_ether_addr(&(pDevice->sRxDFCB[ii].abyAddr2[0]), &(pM=
ACHeader->abyAddr2[0])))
             ) {
             //
@@ -145,7 +145,7 @@ unsigned int ii;
     if (pDevice->cbFreeDFCB =3D=3D 0)
         return(pDevice->cbDFCB);
     for(ii=3D0;ii<pDevice->cbDFCB;ii++) {
-        if (pDevice->sRxDFCB[ii].bInUse =3D=3D false) {
+        if (!pDevice->sRxDFCB[ii].bInUse) {
             pDevice->cbFreeDFCB--;
             pDevice->sRxDFCB[ii].uLifetime =3D pDevice->dwMaxReceiveLifeti=
me;
             pDevice->sRxDFCB[ii].bInUse =3D true;
@@ -180,7 +180,7 @@ bool WCTLbHandleFragment (PSDevice pDevice, PS802_11Hea=
der pMACHeader, unsigned
 unsigned int uHeaderSize;
=20
=20
-    if (bWEP =3D=3D true) {
+    if (bWEP) {
         uHeaderSize =3D 28;
         if (bExtIV)
         // ExtIV
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index c46d519..0217306 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -488,15 +488,15 @@ vMgrAssocBeginSta(
     // ERP Phy (802.11g) should support short preamble.
     if (pMgmt->eCurrentPHYMode =3D=3D PHY_TYPE_11G) {
         pMgmt->wCurrCapInfo |=3D WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
-        if (CARDbIsShorSlotTime(pMgmt->pAdapter) =3D=3D true) {
+        if (CARDbIsShorSlotTime(pMgmt->pAdapter)) {
             pMgmt->wCurrCapInfo |=3D WLAN_SET_CAP_INFO_SHORTSLOTTIME(1);
         }
     } else if (pMgmt->eCurrentPHYMode =3D=3D PHY_TYPE_11B) {
-        if (CARDbIsShortPreamble(pMgmt->pAdapter) =3D=3D true) {
+        if (CARDbIsShortPreamble(pMgmt->pAdapter)) {
             pMgmt->wCurrCapInfo |=3D WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
         }
     }
-    if (pMgmt->b11hEnable =3D=3D true)
+    if (pMgmt->b11hEnable)
         pMgmt->wCurrCapInfo |=3D WLAN_SET_CAP_INFO_SPECTRUMMNG(1);
=20
     /* build an assocreq frame and send it */
@@ -567,15 +567,15 @@ vMgrReAssocBeginSta(
     // ERP Phy (802.11g) should support short preamble.
     if (pMgmt->eCurrentPHYMode =3D=3D PHY_TYPE_11G) {
         pMgmt->wCurrCapInfo |=3D WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
-        if (CARDbIsShorSlotTime(pMgmt->pAdapter) =3D=3D true) {
+        if (CARDbIsShorSlotTime(pMgmt->pAdapter)) {
             pMgmt->wCurrCapInfo |=3D WLAN_SET_CAP_INFO_SHORTSLOTTIME(1);
         }
     } else if (pMgmt->eCurrentPHYMode =3D=3D PHY_TYPE_11B) {
-        if (CARDbIsShortPreamble(pMgmt->pAdapter) =3D=3D true) {
+        if (CARDbIsShortPreamble(pMgmt->pAdapter)) {
             pMgmt->wCurrCapInfo |=3D WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
         }
     }
-    if (pMgmt->b11hEnable =3D=3D true)
+    if (pMgmt->b11hEnable)
         pMgmt->wCurrCapInfo |=3D WLAN_SET_CAP_INFO_SPECTRUMMNG(1);
=20
=20
@@ -771,7 +771,7 @@ s_vMgrRxAssocRequest(
             pDevice->bProtectMode =3D true;
             pDevice->bNonERPPresent =3D true;
         }
-        if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble =3D=3D false) {
+        if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble) {
             pDevice->bBarkerPreambleMd =3D true;
         }
=20
@@ -931,7 +931,7 @@ s_vMgrRxReAssocRequest(
             pDevice->bProtectMode =3D true;
             pDevice->bNonERPPresent =3D true;
         }
-        if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble =3D=3D false) {
+        if (!pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble) {
             pDevice->bBarkerPreambleMd =3D true;
         }
=20
@@ -1932,7 +1932,7 @@ s_vMgrRxBeacon(
         bChannelHit =3D true;
     }
 //2008-0730-01<Add>by MikeLiu
-if(ChannelExceedZoneType(pDevice,byCurrChannel)=3D=3Dtrue)
+if(ChannelExceedZoneType(pDevice, byCurrChannel))
       return;
=20
     if (sFrame.pERP !=3D NULL) {
@@ -2058,8 +2058,8 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)=3D=3D=
true)
     }
=20
     if ((WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)=3D=3D true) &&
-        (bIsBSSIDEqual =3D=3D true) &&
-        (bIsSSIDEqual =3D=3D true) &&
+        (bIsBSSIDEqual) &&
+        (bIsSSIDEqual) &&
         (pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_STA) &&
         (pMgmt->eCurrState =3D=3D WMAC_STATE_ASSOC)) {
         // add state check to prevent reconnect fail since we'll receive B=
eacon
@@ -2105,7 +2105,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)=3D=3D=
true)
 #ifdef	PLICE_DEBUG
 		//printk("RxBeacon:MaxSuppRate is %d\n",pMgmt->sNodeDBTable[0].wMaxSuppR=
ate);
 #endif
-			if (bUpdatePhyParameter =3D=3D true) {
+			if (bUpdatePhyParameter) {
                 CARDbSetPhyParameter( pMgmt->pAdapter,
                                       pMgmt->eCurrentPHYMode,
                                       pMgmt->wCurrCapInfo,
@@ -2127,7 +2127,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)=3D=3D=
true)
                                     sFrame.pIE_CHSW->byCount
                                     );
=20
-            } else if (bIsChannelEqual =3D=3D false) {
+            } else if (!bIsChannelEqual) {
                 set_channel(pMgmt->pAdapter, pBSSList->uChannel);
             }
         }
@@ -2176,13 +2176,13 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)=3D=
=3Dtrue)
=20
=20
     // if infra mode
-    if (bIsAPBeacon =3D=3D true) {
+    if (bIsAPBeacon) {
=20
         // Infra mode: Local TSF always follow AP's TSF if Difference huge=
.
         if (bTSFLargeDiff)
             bUpdateTSF =3D true;
=20
-        if ((pDevice->bEnablePSMode =3D=3D true) &&(sFrame.pTIM !=3D 0)) {
+        if ((pDevice->bEnablePSMode) &&(sFrame.pTIM !=3D 0)) {
=20
             // deal with DTIM, analysis TIM
             pMgmt->bMulticastTIM =3D WLAN_MGMT_IS_MULTICAST_TIM(sFrame.pTI=
M->byBitMapCtl) ? true : false ;
@@ -2224,7 +2224,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)=3D=3D=
true)
             else {
                 pMgmt->bInTIMWake =3D false;
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Not In TIM..\n");
-                if (pDevice->bPWBitOn =3D=3D false) {
+                if (!pDevice->bPWBitOn) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Send Null Pac=
ket\n");
                     if (PSbSendNullPacket(pDevice))
                         pDevice->bPWBitOn =3D true;
@@ -2456,10 +2456,10 @@ vMgrCreateOwnIBSS(
=20
=20
     // Disable Protect Mode
-    pDevice->bProtectMode =3D 0;
+    pDevice->bProtectMode =3D false;
     MACvDisableProtectMD(pDevice->PortOffset);
=20
-    pDevice->bBarkerPreambleMd =3D 0;
+    pDevice->bBarkerPreambleMd =3D false;
     MACvDisableBarkerPreambleMd(pDevice->PortOffset);
=20
     // Kyle Test 2003.11.04
@@ -2609,7 +2609,7 @@ vMgrCreateOwnIBSS(
         pMgmt->wCurrCapInfo &=3D (~WLAN_SET_CAP_INFO_SHORTPREAMBLE(1));
     }
=20
-    if ((pMgmt->b11hEnable =3D=3D true) &&
+    if ((pMgmt->b11hEnable) &&
         (pMgmt->eCurrentPHYMode =3D=3D PHY_TYPE_11A)) {
         pMgmt->wCurrCapInfo |=3D WLAN_SET_CAP_INFO_SPECTRUMMNG(1);
     } else {
@@ -2663,7 +2663,7 @@ vMgrJoinBSSBegin(
=20
=20
     for (ii =3D 0; ii < MAX_BSS_NUM; ii++) {
-        if (pMgmt->sBSSList[ii].bActive =3D=3D true)
+        if (pMgmt->sBSSList[ii].bActive)
             break;
     }
=20
@@ -2793,7 +2793,7 @@ vMgrJoinBSSBegin(
             if (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPA2) {
                 bool bResult =3D bAdd_PMKID_Candidate((void *)pDevice, pMg=
mt->abyCurrBSSID, &pCurr->sRSNCapObj);
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"bAdd_PMKID_Candidate: 1=
(%d)\n", bResult);
-                if (bResult =3D=3D false) {
+                if (!bResult) {
                     vFlush_PMKID_Candidate((void *)pDevice);
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"vFlush_PMKID_Candid=
ate: 4\n");
                     bAdd_PMKID_Candidate((void *)pDevice, pMgmt->abyCurrBS=
SID, &pCurr->sRSNCapObj);
@@ -2820,13 +2820,13 @@ vMgrJoinBSSBegin(
         if (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPANONE) {
=20
             if (pDevice->eEncryptionStatus =3D=3D Ndis802_11Encryption2Ena=
bled) {
-                if (WPA_SearchRSN(0, WPA_TKIP, pCurr) =3D=3D false) {
+                if (!WPA_SearchRSN(0, WPA_TKIP, pCurr)) {
                     // encryption mode error
                     pMgmt->eCurrState =3D WMAC_STATE_IDLE;
                     return;
                 }
             } else if (pDevice->eEncryptionStatus =3D=3D Ndis802_11Encrypt=
ion3Enabled) {
-                if (WPA_SearchRSN(0, WPA_AESCCMP, pCurr) =3D=3D false) {
+                if (!WPA_SearchRSN(0, WPA_AESCCMP, pCurr)) {
                     // encryption mode error
                     pMgmt->eCurrState =3D WMAC_STATE_IDLE;
                     return;
@@ -2924,10 +2924,7 @@ s_vMgrSynchBSS (
=20
     *pStatus =3D CMD_STATUS_FAILURE;
=20
-    if (s_bCipherMatch(pCurr,
-                       pDevice->eEncryptionStatus,
-                       &(pMgmt->byCSSPK),
-                       &(pMgmt->byCSSGK)) =3D=3D false) {
+    if (!s_bCipherMatch(pCurr, pDevice->eEncryptionStatus, &(pMgmt->byCSSP=
K), &(pMgmt->byCSSGK))) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "s_bCipherMatch Fail .......\n"=
);
         return;
     }
@@ -3018,18 +3015,12 @@ s_vMgrSynchBSS (
         CARDbSetBSSID(pMgmt->pAdapter, pCurr->abyBSSID, OP_MODE_ADHOC);
     }
=20
-    if (CARDbSetPhyParameter(   pMgmt->pAdapter,
-                                ePhyType,
-                                pCurr->wCapInfo,
-                                pCurr->sERP.byERP,
-                                pMgmt->abyCurrSuppRates,
-                                pMgmt->abyCurrExtSuppRates
-                            ) !=3D true) {
+    if (!CARDbSetPhyParameter(pMgmt->pAdapter, ePhyType, pCurr->wCapInfo, =
pCurr->sERP.byERP, pMgmt->abyCurrSuppRates, pMgmt->abyCurrExtSuppRates)) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "<----s_bSynchBSS Set Phy Mode =
Fail [%d]\n", ePhyType);
         return;
     }
     // set channel and clear NAV
-    if (set_channel(pMgmt->pAdapter, pCurr->uChannel) =3D=3D false) {
+    if (!set_channel(pMgmt->pAdapter, pCurr->uChannel)) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "<----s_bSynchBSS Set Channel [=
%d]\n", pCurr->uChannel);
         return;
     }
@@ -3083,7 +3074,7 @@ s_vMgrSynchBSS (
   //   if( uSameBssidNum>=3D2) {	 //we only check AP in hidden sssid  mode
         if ((pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPAPSK) ||           //ne=
tworkmanager 0.7.0 does not give the pairwise-key selsection,
              (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPA2PSK)) {         // s=
o we need re-selsect it according to real pairwise-key info.
-               if(pCurr->bWPAValid =3D=3D true)  {   //WPA-PSK
+               if(pCurr->bWPAValid)  {   //WPA-PSK
                           pMgmt->eAuthenMode =3D WMAC_AUTH_WPAPSK;
 		    if(pCurr->abyPKType[0] =3D=3D WPA_TKIP) {
      		        pDevice->eEncryptionStatus =3D Ndis802_11Encryption2Enabled=
;    //TKIP
@@ -3094,7 +3085,7 @@ s_vMgrSynchBSS (
                           PRINT_K("Encyption_Rebuild--->ssid reset config =
to [WPAPSK-AES]\n");
      		     }
                	}
-               else if(pCurr->bWPA2Valid =3D=3D true) {  //WPA2-PSK
+               else if(pCurr->bWPA2Valid) {  //WPA2-PSK
                          pMgmt->eAuthenMode =3D WMAC_AUTH_WPA2PSK;
 		       if(pCurr->abyCSSPK[0] =3D=3D WLAN_11i_CSS_TKIP) {
       		           pDevice->eEncryptionStatus =3D Ndis802_11Encryption2Ena=
bled;     //TKIP
@@ -3317,7 +3308,7 @@ s_MgrMakeBeacon(
         }
     }
=20
-    if ((pMgmt->b11hEnable =3D=3D true) &&
+    if ((pMgmt->b11hEnable) &&
         (pMgmt->eCurrentPHYMode =3D=3D PHY_TYPE_11A)) {
         // Country IE
         pbyBuffer =3D (unsigned char *)(sFrame.pBuf + sFrame.len);
@@ -3331,7 +3322,7 @@ s_MgrMakeBeacon(
         ((PWLAN_IE_PW_CONST) pbyBuffer)->byPower =3D 0;
         pbyBuffer +=3D (1) + WLAN_IEHDR_LEN;
         uLength +=3D (1) + WLAN_IEHDR_LEN;
-        if (pMgmt->bSwitchChannel =3D=3D true) {
+        if (pMgmt->bSwitchChannel) {
             // Channel Switch IE
             ((PWLAN_IE_CH_SW) pbyBuffer)->byElementID =3D WLAN_EID_CH_SWIT=
CH;
             ((PWLAN_IE_CH_SW) pbyBuffer)->len =3D 3;
@@ -3360,7 +3351,7 @@ s_MgrMakeBeacon(
             pbyBuffer +=3D (7) + WLAN_IEHDR_LEN;
             uLength +=3D (7) + WLAN_IEHDR_LEN;
             for(ii=3DCB_MAX_CHANNEL_24G+1; ii<=3DCB_MAX_CHANNEL; ii++ ) {
-                if (get_channel_map_info(pMgmt->pAdapter, ii, pbyBuffer, p=
byBuffer+1) =3D=3D true) {
+                if (get_channel_map_info(pMgmt->pAdapter, ii, pbyBuffer, p=
byBuffer + 1)) {
                     pbyBuffer +=3D 2;
                     uLength +=3D 2;
                     pIBSSDFS->len +=3D 2;
@@ -3376,11 +3367,11 @@ s_MgrMakeBeacon(
         sFrame.pERP->byElementID =3D WLAN_EID_ERP;
         sFrame.pERP->len =3D 1;
         sFrame.pERP->byContext =3D 0;
-        if (pDevice->bProtectMode =3D=3D true)
+        if (pDevice->bProtectMode)
             sFrame.pERP->byContext |=3D WLAN_EID_ERP_USE_PROTECTION;
-        if (pDevice->bNonERPPresent =3D=3D true)
+        if (pDevice->bNonERPPresent)
             sFrame.pERP->byContext |=3D WLAN_EID_ERP_NONERP_PRESENT;
-        if (pDevice->bBarkerPreambleMd =3D=3D true)
+        if (pDevice->bBarkerPreambleMd)
             sFrame.pERP->byContext |=3D WLAN_EID_ERP_BARKER_MODE;
     }
     if (((PWLAN_IE_SUPP_RATES)pCurrExtSuppRates)->len !=3D 0) {
@@ -3392,7 +3383,7 @@ s_MgrMakeBeacon(
              );
     }
     // hostapd wpa/wpa2 IE
-    if ((pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_AP) && (pDevice->bEnableHos=
tapd =3D=3D true)) {
+    if ((pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_AP) && (pDevice->bEnableHos=
tapd)) {
          if (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPANONE) {
              if (pMgmt->wWPAIELen !=3D 0) {
                  sFrame.pRSN =3D (PWLAN_IE_RSN)(sFrame.pBuf + sFrame.len);
@@ -3513,15 +3504,15 @@ s_MgrMakeProbeResponse(
         sFrame.pERP->byElementID =3D WLAN_EID_ERP;
         sFrame.pERP->len =3D 1;
         sFrame.pERP->byContext =3D 0;
-        if (pDevice->bProtectMode =3D=3D true)
+        if (pDevice->bProtectMode)
             sFrame.pERP->byContext |=3D WLAN_EID_ERP_USE_PROTECTION;
-        if (pDevice->bNonERPPresent =3D=3D true)
+        if (pDevice->bNonERPPresent)
             sFrame.pERP->byContext |=3D WLAN_EID_ERP_NONERP_PRESENT;
-        if (pDevice->bBarkerPreambleMd =3D=3D true)
+        if (pDevice->bBarkerPreambleMd)
             sFrame.pERP->byContext |=3D WLAN_EID_ERP_BARKER_MODE;
     }
=20
-    if ((pMgmt->b11hEnable =3D=3D true) &&
+    if ((pMgmt->b11hEnable) &&
         (pMgmt->eCurrentPHYMode =3D=3D PHY_TYPE_11A)) {
         // Country IE
         pbyBuffer =3D (unsigned char *)(sFrame.pBuf + sFrame.len);
@@ -3535,7 +3526,7 @@ s_MgrMakeProbeResponse(
         ((PWLAN_IE_PW_CONST) pbyBuffer)->byPower =3D 0;
         pbyBuffer +=3D (1) + WLAN_IEHDR_LEN;
         uLength +=3D (1) + WLAN_IEHDR_LEN;
-        if (pMgmt->bSwitchChannel =3D=3D true) {
+        if (pMgmt->bSwitchChannel) {
             // Channel Switch IE
             ((PWLAN_IE_CH_SW) pbyBuffer)->byElementID =3D WLAN_EID_CH_SWIT=
CH;
             ((PWLAN_IE_CH_SW) pbyBuffer)->len =3D 3;
@@ -3564,7 +3555,7 @@ s_MgrMakeProbeResponse(
             pbyBuffer +=3D (7) + WLAN_IEHDR_LEN;
             uLength +=3D (7) + WLAN_IEHDR_LEN;
             for(ii=3DCB_MAX_CHANNEL_24G+1; ii<=3DCB_MAX_CHANNEL; ii++ ) {
-                if (get_channel_map_info(pMgmt->pAdapter, ii, pbyBuffer, p=
byBuffer+1) =3D=3D true) {
+                if (get_channel_map_info(pMgmt->pAdapter, ii, pbyBuffer, p=
byBuffer + 1)) {
                     pbyBuffer +=3D 2;
                     uLength +=3D 2;
                     pIBSSDFS->len +=3D 2;
@@ -3585,7 +3576,7 @@ s_MgrMakeProbeResponse(
     }
=20
     // hostapd wpa/wpa2 IE
-    if ((pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_AP) && (pDevice->bEnableHos=
tapd =3D=3D true)) {
+    if ((pMgmt->eCurrMode =3D=3D WMAC_MODE_ESS_AP) && (pDevice->bEnableHos=
tapd)) {
          if (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPANONE) {
              if (pMgmt->wWPAIELen !=3D 0) {
                  sFrame.pRSN =3D (PWLAN_IE_RSN)(sFrame.pBuf + sFrame.len);
@@ -3687,7 +3678,7 @@ s_MgrMakeAssocRequest(
     pbyIEs +=3D pCurrRates->len + WLAN_IEHDR_LEN;
=20
     // for 802.11h
-    if (pMgmt->b11hEnable =3D=3D true) {
+    if (pMgmt->b11hEnable) {
         if (sFrame.pCurrPowerCap =3D=3D NULL) {
             sFrame.pCurrPowerCap =3D (PWLAN_IE_PW_CAP)(sFrame.pBuf + sFram=
e.len);
             sFrame.len +=3D (2 + WLAN_IEHDR_LEN);
@@ -3832,7 +3823,7 @@ s_MgrMakeAssocRequest(
         sFrame.pRSN->len +=3D6;
=20
         // RSN Capabilites
-        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist =3D=3D true) {
+        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist) {
             memcpy(&sFrame.pRSN->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.=
wRSNCap, 2);
         } else {
             sFrame.pRSN->abyRSN[16] =3D 0;
@@ -3840,7 +3831,7 @@ s_MgrMakeAssocRequest(
         }
         sFrame.pRSN->len +=3D2;
=20
-        if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && (pDevice->bRoaming =
=3D=3D true) && (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPA2)) {
+        if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && (pDevice->bRoaming) &=
& (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPA2)) {
             // RSN PMKID
             pbyRSN =3D &sFrame.pRSN->abyRSN[18];
             pwPMKID =3D (unsigned short *)pbyRSN; // Point to PMKID count
@@ -4088,7 +4079,7 @@ s_MgrMakeReAssocRequest(
         sFrame.pRSN->len +=3D6;
=20
         // RSN Capabilites
-        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist =3D=3D true) {
+        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist) {
             memcpy(&sFrame.pRSN->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.=
wRSNCap, 2);
         } else {
             sFrame.pRSN->abyRSN[16] =3D 0;
@@ -4096,7 +4087,7 @@ s_MgrMakeReAssocRequest(
         }
         sFrame.pRSN->len +=3D2;
=20
-        if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && (pDevice->bRoaming =
=3D=3D true) && (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPA2)) {
+        if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && (pDevice->bRoaming) &=
& (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPA2)) {
             // RSN PMKID
             pbyRSN =3D &sFrame.pRSN->abyRSN[18];
             pwPMKID =3D (unsigned short *)pbyRSN; // Point to PMKID count
@@ -4343,7 +4334,7 @@ s_vMgrRxProbeResponse(
     }
=20
 //2008-0730-01<Add>by MikeLiu
-if(ChannelExceedZoneType(pDevice,byCurrChannel)=3D=3Dtrue)
+if(ChannelExceedZoneType(pDevice, byCurrChannel))
       return;
=20
     if (sFrame.pERP !=3D NULL) {
@@ -4804,7 +4795,7 @@ bAdd_PMKID_Candidate (
     for (ii =3D 0; ii < pDevice->gsPMKIDCandidate.NumCandidates; ii++) {
         pCandidateList =3D &pDevice->gsPMKIDCandidate.CandidateList[ii];
         if ( !memcmp(pCandidateList->BSSID, pbyBSSID, ETH_ALEN)) {
-            if ((psRSNCapObj->bRSNCapExist =3D=3D true) && (psRSNCapObj->w=
RSNCap & BIT0)) {
+            if ((psRSNCapObj->bRSNCapExist) && (psRSNCapObj->wRSNCap & BIT=
0)) {
                 pCandidateList->Flags |=3D NDIS_802_11_PMKID_CANDIDATE_PRE=
AUTH_ENABLED;
             } else {
                 pCandidateList->Flags &=3D ~(NDIS_802_11_PMKID_CANDIDATE_P=
REAUTH_ENABLED);
@@ -4815,7 +4806,7 @@ bAdd_PMKID_Candidate (
=20
     // New Candidate
     pCandidateList =3D &pDevice->gsPMKIDCandidate.CandidateList[pDevice->g=
sPMKIDCandidate.NumCandidates];
-    if ((psRSNCapObj->bRSNCapExist =3D=3D true) && (psRSNCapObj->wRSNCap &=
 BIT0)) {
+    if ((psRSNCapObj->bRSNCapExist) && (psRSNCapObj->wRSNCap & BIT0)) {
         pCandidateList->Flags |=3D NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENA=
BLED;
     } else {
         pCandidateList->Flags &=3D ~(NDIS_802_11_PMKID_CANDIDATE_PREAUTH_E=
NABLED);
@@ -4876,7 +4867,7 @@ s_bCipherMatch (
     }
=20
     if ((WLAN_GET_CAP_INFO_PRIVACY(pBSSNode->wCapInfo) !=3D 0) &&
-        (pBSSNode->bWPA2Valid =3D=3D true) &&
+        (pBSSNode->bWPA2Valid) &&
           //20080123-01,<Add> by Einsn Liu
         ((EncStatus =3D=3D Ndis802_11Encryption3Enabled)||(EncStatus =3D=
=3D Ndis802_11Encryption2Enabled))) {
         //WPA2
@@ -4910,7 +4901,7 @@ s_bCipherMatch (
         }
=20
     } else if ((WLAN_GET_CAP_INFO_PRIVACY(pBSSNode->wCapInfo) !=3D 0) &&
-                (pBSSNode->bWPAValid =3D=3D true) &&
+                (pBSSNode->bWPAValid) &&
                 ((EncStatus =3D=3D Ndis802_11Encryption3Enabled) || (EncSt=
atus =3D=3D Ndis802_11Encryption2Enabled))) {
         //WPA
         // check Group Key Cipher
diff --git a/drivers/staging/vt6655/wpa.c b/drivers/staging/vt6655/wpa.c
index 61ac46f..c109b3d 100644
--- a/drivers/staging/vt6655/wpa.c
+++ b/drivers/staging/vt6655/wpa.c
@@ -247,7 +247,7 @@ WPA_SearchRSN (
     int ii;
     unsigned char byPKType =3D WPA_NONE;
=20
-    if (pBSSList->bWPAValid =3D=3D false)
+    if (!pBSSList->bWPAValid)
         return false;
=20
     switch(byCmd) {
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index 744799c..4e9623e 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -195,7 +195,7 @@ WPA2vParseRSN (
                     break;
             } //for
=20
-            if (bUseGK =3D=3D true) {
+            if (bUseGK) {
                 if (j !=3D 1) {
                     // invalid CSS, This should be only PK CSS.
                     return;
@@ -339,7 +339,7 @@ WPA2uSetIEs(
         pRSNIEs->len +=3D2;
=20
         if ((pMgmt->gsPMKIDCache.BSSIDInfoCount > 0) &&
-            (pMgmt->bRoaming =3D=3D true) &&
+            (pMgmt->bRoaming) &&
             (pMgmt->eAuthenMode =3D=3D WMAC_AUTH_WPA2)) {
             // RSN PMKID
             pwPMKID =3D (unsigned short *)(&pRSNIEs->abyRSN[18]);  // Poin=
t to PMKID count
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpact=
l.c
index 732ba88..411380d 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -357,22 +357,8 @@ spin_lock_irq(&pDevice->lock);
         // If is_broadcast_ether_addr, set the key as every key entry's gr=
oup key.
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Groupe Key Assign.\n");
=20
-        if ((KeybSetAllGroupKey(&(pDevice->sKey),
-                            dwKeyIndex,
-                            param->u.wpa_key.key_len,
-                            (PQWORD) &(KeyRSC),
-                            (unsigned char *)abyKey,
-                            byKeyDecMode,
-                            pDevice->PortOffset,
-                            pDevice->byLocalID) =3D=3D true) &&
-            (KeybSetDefaultKey(&(pDevice->sKey),
-                            dwKeyIndex,
-                            param->u.wpa_key.key_len,
-                            (PQWORD) &(KeyRSC),
-                            (unsigned char *)abyKey,
-                            byKeyDecMode,
-                            pDevice->PortOffset,
-                            pDevice->byLocalID) =3D=3D true) ) {
+        if ((KeybSetAllGroupKey(&(pDevice->sKey), dwKeyIndex, param->u.wpa=
_key.key_len, (PQWORD) & (KeyRSC), (unsigned char *)abyKey, byKeyDecMode, p=
Device->PortOffset, pDevice->byLocalID)) &&
+            (KeybSetDefaultKey(&(pDevice->sKey), dwKeyIndex, param->u.wpa_=
key.key_len, (PQWORD) & (KeyRSC), (unsigned char *)abyKey, byKeyDecMode, pD=
evice->PortOffset, pDevice->byLocalID)) ) {
              DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GROUP Key Assign.\n");
=20
         } else {
@@ -397,15 +383,7 @@ spin_lock_irq(&pDevice->lock);
             //spin_unlock_irq(&pDevice->lock);
             return -EINVAL;
         }
-        if (KeybSetKey(&(pDevice->sKey),
-                       &param->addr[0],
-                       dwKeyIndex,
-                       param->u.wpa_key.key_len,
-                       (PQWORD) &(KeyRSC),
-                       (unsigned char *)abyKey,
-                        byKeyDecMode,
-                        pDevice->PortOffset,
-                        pDevice->byLocalID) =3D=3D true) {
+        if (KeybSetKey(&(pDevice->sKey), &param->addr[0], dwKeyIndex, para=
m->u.wpa_key.key_len, (PQWORD) & (KeyRSC), (unsigned char *)abyKey, byKeyDe=
cMode, pDevice->PortOffset, pDevice->byLocalID)) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Set\n");
=20
         } else {
@@ -857,7 +835,7 @@ else
     else
         pDevice->bEncryptionEnable =3D false;
 if (!((pMgmt->eAuthenMode =3D=3D WMAC_AUTH_SHAREKEY) ||
-      ((pMgmt->eAuthenMode =3D=3D WMAC_AUTH_OPEN) && (bWepEnabled=3D=3Dtru=
e))) )  //DavidWang  //20080717-06,<Modify> by chester//Not to initial WEP
+      ((pMgmt->eAuthenMode =3D=3D WMAC_AUTH_OPEN) && (bWepEnabled))) )  //=
DavidWang  //20080717-06,<Modify> by chester//Not to initial WEP
     KeyvInitTable(&pDevice->sKey, pDevice->PortOffset);
     spin_lock_irq(&pDevice->lock);
     pDevice->bLinkPass =3D false;
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/=
zcache-main.c
index ef7c52b..db95a0e 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -218,7 +218,7 @@ static struct zbud_page *zbud_alloc_raw_page(void)
 {
 	struct zbud_page *zbpg =3D NULL;
 	struct zbud_hdr *zh0, *zh1;
-	bool recycled =3D 0;
+	bool recycled =3D false;
=20
 	/* if any pages on the zbpg list, use one */
 	spin_lock(&zbpg_unused_list_spinlock);
@@ -227,7 +227,7 @@ static struct zbud_page *zbud_alloc_raw_page(void)
 				struct zbud_page, bud_list);
 		list_del_init(&zbpg->bud_list);
 		zcache_zbpg_unused_list_count--;
-		recycled =3D 1;
+		recycled =3D true;
 	}
 	spin_unlock(&zbpg_unused_list_spinlock);
 	if (zbpg =3D=3D NULL)
@@ -946,7 +946,7 @@ int zcache_new_client(uint16_t cli_id)
 		goto out;
 	if (cli->allocated)
 		goto out;
-	cli->allocated =3D 1;
+	cli->allocated =3D true;
 #ifdef CONFIG_FRONTSWAP
 	cli->xvpool =3D xv_create_pool();
 	if (cli->xvpool =3D=3D NULL)
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index 4426290..935ec9b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3243,10 +3243,10 @@ static int iscsit_build_sendtargets_response(struct=
 iscsi_cmd *cmd)
 				len =3D sprintf(buf, "TargetAddress=3D"
 					"%s%s%s:%hu,%hu",
 					(np->np_sockaddr.ss_family =3D=3D AF_INET6) ?
-					"[" : "", (inaddr_any =3D=3D false) ?
+					"[" : "", (!inaddr_any) ?
 						np->np_ip : conn->local_ip,
 					(np->np_sockaddr.ss_family =3D=3D AF_INET6) ?
-					"]" : "", (inaddr_any =3D=3D false) ?
+					"]" : "", (!inaddr_any) ?
 						np->np_port : conn->local_port,
 					tpg->tpgt);
 				len +=3D 1;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target=
_core_transport.c
index 58cea07..2d0b0fa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4006,7 +4006,7 @@ void target_get_sess_cmd(struct se_session *se_sess, =
struct se_cmd *se_cmd,
 	 * fabric acknowledgement that requires two target_put_sess_cmd()
 	 * invocations before se_cmd descriptor release.
 	 */
-	if (ack_kref =3D=3D true)
+	if (ack_kref)
 		kref_get(&se_cmd->cmd_kref);
=20
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 18b48cd..40f3398 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -2139,7 +2139,7 @@ static void isr_rxdata(struct slgt_info *info)
 		if (desc_complete(info->rbufs[i])) {
 			/* all buffers full */
 			rx_stop(info);
-			info->rx_restart =3D 1;
+			info->rx_restart =3D true;
 			continue;
 		}
 		info->rbufs[i].buf[count++] =3D (unsigned char)reg;
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index a7efe53..8cc640a 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -456,7 +456,7 @@ static int synclinkmp_device_count =3D 0;
  * .text section address and breakpoint on module load.
  * This is useful for use with gdb and add-symbol-file command.
  */
-static bool break_on_load =3D 0;
+static bool break_on_load =3D false;
=20
 /*
  * Driver major number, defaults to zero to get auto
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 70d69d0..6cedc21 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1019,11 +1019,11 @@ static int usbtmc_probe(struct usb_interface *intf,
 	usb_set_intfdata(intf, data);
 	kref_init(&data->kref);
 	mutex_init(&data->io_mutex);
-	data->zombie =3D 0;
+	data->zombie =3D false;
=20
 	/* Initialize USBTMC bTag and other fields */
 	data->bTag	=3D 1;
-	data->TermCharEnabled =3D 0;
+	data->TermCharEnabled =3D false;
 	data->TermChar =3D '\n';
=20
 	/* USBTMC devices have only one setting, so use that */
@@ -1091,7 +1091,7 @@ static void usbtmc_disconnect(struct usb_interface *i=
ntf)
 	sysfs_remove_group(&intf->dev.kobj, &capability_attr_grp);
 	sysfs_remove_group(&intf->dev.kobj, &data_attr_grp);
 	mutex_lock(&data->io_mutex);
-	data->zombie =3D 1;
+	data->zombie =3D true;
 	mutex_unlock(&data->io_mutex);
 	kref_put(&data->kref, usbtmc_delete);
 }
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a0613d8..500a614 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -102,7 +102,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khubd_wait);
 static struct task_struct *khubd_task;
=20
 /* cycle leds on hubs that aren't blinking for attention */
-static bool blinkenlights =3D 0;
+static bool blinkenlights =3D false;
 module_param (blinkenlights, bool, S_IRUGO);
 MODULE_PARM_DESC (blinkenlights, "true to cycle leds on hubs");
=20
@@ -131,12 +131,12 @@ MODULE_PARM_DESC(initial_descriptor_timeout,
  * otherwise the new scheme is used.  If that fails and "use_both_schemes"
  * is set, then the driver will make another attempt, using the other sche=
me.
  */
-static bool old_scheme_first =3D 0;
+static bool old_scheme_first =3D false;
 module_param(old_scheme_first, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(old_scheme_first,
 		 "start with the old device initialization scheme");
=20
-static bool use_both_schemes =3D 1;
+static bool use_both_schemes =3D true;
 module_param(use_both_schemes, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(use_both_schemes,
 		"try the other device initialization scheme if the "
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536ud=
c.c
index c16ff55..265e5a1 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -152,9 +152,9 @@ static const char *ep_string[] =3D {
 };
=20
 /* DMA usage flag */
-static bool use_dma =3D 1;
+static bool use_dma =3D true;
 /* packet per buffer dma */
-static bool use_dma_ppb =3D 1;
+static bool use_dma_ppb =3D true;
 /* with per descr. update */
 static bool use_dma_ppb_du;
 /* buffer fill mode */
@@ -3171,7 +3171,7 @@ static int init_dma_pools(struct udc *dev)
 	if (use_dma_ppb) {
 		use_dma_bufferfill_mode =3D 0;
 	} else {
-		use_dma_ppb_du =3D 0;
+		use_dma_ppb_du =3D false;
 		use_dma_bufferfill_mode =3D 1;
 	}
=20
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index a28f6ff..de0846c 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -250,7 +250,7 @@ static struct usb_configuration rndis_config_driver =3D=
 {
 /*------------------------------------------------------------------------=
-*/
=20
 #ifdef CONFIG_USB_ETH_EEM
-static bool use_eem =3D 1;
+static bool use_eem =3D true;
 #else
 static bool use_eem;
 #endif
diff --git a/drivers/usb/gadget/f_eem.c b/drivers/usb/gadget/f_eem.c
index 1a7b2dd..10e0b92 100644
--- a/drivers/usb/gadget/f_eem.c
+++ b/drivers/usb/gadget/f_eem.c
@@ -213,7 +213,7 @@ static int eem_set_alt(struct usb_function *f, unsigned=
 intf, unsigned alt)
 		/* zlps should not occur because zero-length EEM packets
 		 * will be inserted in those cases where they would occur
 		 */
-		eem->port.is_zlp_ok =3D 1;
+		eem->port.is_zlp_ok =3D true;
 		eem->port.cdc_filter =3D DEFAULT_FILTER;
 		DBG(cdev, "activate eem\n");
 		net =3D gether_connect(&eem->port);
diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index b211342..6fd455c 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -181,7 +181,7 @@ static void f_hidg_req_complete(struct usb_ep *ep, stru=
ct usb_request *req)
 			"End Point Request ERROR: %d\n", req->status);
 	}
=20
-	hidg->write_pending =3D 0;
+	hidg->write_pending =3D false;
 	wake_up(&hidg->write_queue);
 }
=20
@@ -226,13 +226,13 @@ static ssize_t f_hidg_write(struct file *file, const =
char __user *buffer,
 	hidg->req->length   =3D count;
 	hidg->req->complete =3D f_hidg_req_complete;
 	hidg->req->context  =3D hidg;
-	hidg->write_pending =3D 1;
+	hidg->write_pending =3D true;
=20
 	status =3D usb_ep_queue(hidg->in_ep, hidg->req, GFP_ATOMIC);
 	if (status < 0) {
 		ERROR(hidg->func.config->cdev,
 			"usb_ep_queue error on int endpoint %zd\n", status);
-		hidg->write_pending =3D 0;
+		hidg->write_pending =3D false;
 		wake_up(&hidg->write_queue);
 	} else {
 		status =3D count;
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_st=
orage.c
index 47766f0..c47ed32 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3226,7 +3226,7 @@ static int __init check_parameters(struct fsg_dev *fs=
g)
 	 * disable stalls.
 	 */
 	if (gadget_is_at91(fsg->gadget))
-		mod_data.can_stall =3D 0;
+		mod_data.can_stall =3D false;
=20
 	if (mod_data.release =3D=3D 0xffff) {	// Parameter wasn't set
 		gcnum =3D usb_gadget_controller_number(fsg->gadget);
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_c=
ore.c
index f97e737..372dbee 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -1474,7 +1474,7 @@ udc_prime_status(struct mv_udc *udc, u8 direction, u1=
6 status, bool empty)
 	req =3D udc->status_req;
=20
 	/* fill in the reqest structure */
-	if (empty =3D=3D false) {
+	if (!empty) {
 		*((u16 *) req->req.buf) =3D cpu_to_le16(status);
 		req->req.length =3D 2;
 	} else
@@ -1707,7 +1707,7 @@ static void handle_setup_packet(struct mv_udc *udc, u=
8 ep_num,
 		delegate =3D true;
=20
 	/* delegate USB standard requests to the gadget driver */
-	if (delegate =3D=3D true) {
+	if (delegate) {
 		/* USB requests handled by gadget */
 		if (setup->wLength) {
 			/* DATA phase from gadget, STATUS phase from udc */
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index 7322d29..03cd6c7 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -69,7 +69,7 @@ static const char * const ep_name[] =3D {
  *
  * If use_dma is disabled, pio will be used instead.
  */
-static bool use_dma =3D 0;
+static bool use_dma =3D false;
 module_param(use_dma, bool, 0644);
=20
 /*
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index cdedd13..acffe30 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -90,8 +90,8 @@ static const char *const ep_name [] =3D {
  * Some gadget drivers work better with the dma support here than others.
  * These two parameters let you use PIO or more aggressive DMA.
  */
-static bool use_dma =3D 1;
-static bool use_dma_chaining =3D 0;
+static bool use_dma =3D true;
+static bool use_dma_chaining =3D false;
=20
 /* "modprobe net2280 use_dma=3Dn" etc */
 module_param (use_dma, bool, S_IRUGO);
@@ -112,7 +112,7 @@ module_param (fifo_mode, ushort, 0644);
  * USB suspend requests will be ignored.  This is acceptable for
  * self-powered devices
  */
-static bool enable_suspend =3D 0;
+static bool enable_suspend =3D false;
=20
 /* "modprobe net2280 enable_suspend=3D1" etc */
 module_param (enable_suspend, bool, S_IRUGO);
@@ -2886,7 +2886,7 @@ MODULE_LICENSE ("GPL");
 static int __init init (void)
 {
 	if (!use_dma)
-		use_dma_chaining =3D 0;
+		use_dma_chaining =3D false;
 	return pci_register_driver (&net2280_pci_driver);
 }
 module_init (init);
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 576cd85..a57f834 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -98,7 +98,7 @@ module_param (fifo_mode, uint, 0);
 MODULE_PARM_DESC (fifo_mode, "endpoint configuration");
=20
 #ifdef	USE_DMA
-static bool use_dma =3D 1;
+static bool use_dma =3D true;
=20
 /* "modprobe omap_udc use_dma=3Dy", or else as a kernel
  * boot parameter "omap_udc:use_dma=3Dy"
@@ -3122,7 +3122,7 @@ static int __init udc_init(void)
 {
 	/* Disable DMA for omap7xx -- it doesn't work right. */
 	if (cpu_is_omap7xx())
-		use_dma =3D 0;
+		use_dma =3D false;
=20
 	INFO("%s, version: " DRIVER_VERSION
 #ifdef	USE_ISO
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 31d3483..8d06024 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -81,7 +81,7 @@ module_param(buflen, uint, 0);
  * work better with hosts where config changes are problematic or
  * controllers (like original superh) that only support one config.
  */
-static bool loopdefault =3D 0;
+static bool loopdefault =3D false;
 module_param(loopdefault, bool, S_IRUGO|S_IWUSR);
=20
 /*------------------------------------------------------------------------=
-*/
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index a007a9f..e850b57 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -112,7 +112,7 @@ module_param (park, uint, S_IRUGO);
 MODULE_PARM_DESC (park, "park setting; 1-3 back-to-back async packets");
=20
 /* for flakey hardware, ignore overcurrent indicators */
-static bool ignore_oc =3D 0;
+static bool ignore_oc =3D false;
 module_param (ignore_oc, bool, S_IRUGO);
 MODULE_PARM_DESC (ignore_oc, "ignore bogus hardware overcurrent indication=
s");
=20
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 34b9edd..0a2c2d2 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -115,13 +115,13 @@ static inline void sb800_prefetch(struct ohci_hcd *oh=
ci, int on)
=20
=20
 /* Some boards misreport power switching/overcurrent */
-static bool distrust_firmware =3D 1;
+static bool distrust_firmware =3D true;
 module_param (distrust_firmware, bool, 0);
 MODULE_PARM_DESC (distrust_firmware,
 	"true to distrust firmware power/overcurrent setup");
=20
 /* Some boards leave IR set wrongly, since they fail BIOS/SMM handshakes *=
/
-static bool no_handshake =3D 0;
+static bool no_handshake =3D false;
 module_param (no_handshake, bool, 0);
 MODULE_PARM_DESC (no_handshake, "true (not default) disables BIOS handshak=
e");
=20
diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 16dd6a6..4280a63 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -74,7 +74,7 @@ MODULE_LICENSE("GPL");
 #define INT_MODULE_PARM(n, v) static int n =3D v;module_param(n, int, 0444=
)
 INT_MODULE_PARM(testing, 0);
 /* Some boards misreport power switching/overcurrent*/
-static bool distrust_firmware =3D 1;
+static bool distrust_firmware =3D true;
 module_param(distrust_firmware, bool, 0);
 MODULE_PARM_DESC(distrust_firmware, "true to distrust firmware power/overc=
urren"
 	"t setup");
diff --git a/drivers/usb/host/whci/qset.c b/drivers/usb/host/whci/qset.c
index 76083ae..9ba984a 100644
--- a/drivers/usb/host/whci/qset.c
+++ b/drivers/usb/host/whci/qset.c
@@ -396,7 +396,7 @@ static void urb_dequeue_work(struct work_struct *work)
 	struct whc *whc =3D qset->whc;
 	unsigned long flags;
=20
-	if (wurb->is_async =3D=3D true)
+	if (wurb->is_async)
 		asl_update(whc, WUSBCMD_ASYNC_UPDATED
 			   | WUSBCMD_ASYNC_SYNCED_DB
 			   | WUSBCMD_ASYNC_QSET_RM);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6bbe3c3..5e5d28e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2448,7 +2448,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *x=
hci,
 	if (timeleft <=3D 0) {
 		xhci_warn(xhci, "%s while waiting for %s command\n",
 				timeleft =3D=3D 0 ? "Timeout" : "Signal",
-				ctx_change =3D=3D 0 ?
+				!ctx_change ?
 					"configure endpoint" :
 					"evaluate context");
 		/* FIXME cancel the configure endpoint command */
diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index a4a3c7c..2671fcf 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -53,7 +53,7 @@ MODULE_AUTHOR("Tony Olech");
 MODULE_DESCRIPTION("FTDI ELAN driver");
 MODULE_LICENSE("GPL");
 #define INT_MODULE_PARM(n, v) static int n =3D v;module_param(n, int, 0444=
)
-static bool distrust_firmware =3D 1;
+static bool distrust_firmware =3D true;
 module_param(distrust_firmware, bool, 0);
 MODULE_PARM_DESC(distrust_firmware, "true to distrust firmware power/overc=
urren"
         "t setup");
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 4fd0dc8..aba4e79 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -62,7 +62,7 @@ MODULE_LICENSE("GPL");
=20
 /* Module parameters */
 static DEFINE_MUTEX(iowarrior_mutex);
-static bool debug =3D 0;
+static bool debug =3D false;
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "debug=3D1 enables debugging messages");
=20
diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index 66bc376..3a5af9a 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -750,7 +750,7 @@ cppi_next_tx_segment(struct musb *musb, struct cppi_cha=
nnel *tx)
  * So this module parameter lets the heuristic be disabled.  When using
  * gadgetfs, the heuristic will probably need to be disabled.
  */
-static bool cppi_rx_rndis =3D 1;
+static bool cppi_rx_rndis =3D true;
=20
 module_param(cppi_rx_rndis, bool, 0);
 MODULE_PARM_DESC(cppi_rx_rndis, "enable/disable RX RNDIS heuristic");
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 3d11cf64..e8acd08 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1589,7 +1589,7 @@ irqreturn_t musb_interrupt(struct musb *musb)
 EXPORT_SYMBOL_GPL(musb_interrupt);
=20
 #ifndef CONFIG_MUSB_PIO_ONLY
-static bool __initdata use_dma =3D 1;
+static bool __initdata use_dma =3D true;
=20
 /* "modprobe ... use_dma=3D0" etc */
 module_param(use_dma, bool, 0);
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoe=
nix.c
index 3077a44..9bdc072 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -34,7 +34,7 @@
=20
=20
 #ifdef CONFIG_USB_SERIAL_DEBUG
-static bool debug =3D 1;
+static bool debug =3D true;
 #else
 static bool debug;
 #endif
@@ -406,7 +406,7 @@ static void iuu_led_activity_on(struct urb *urb)
 	int result;
 	char *buf_ptr =3D port->write_urb->transfer_buffer;
 	*buf_ptr++ =3D IUU_SET_LED;
-	if (xmas =3D=3D 1) {
+	if (xmas) {
 		get_random_bytes(buf_ptr, 6);
 		*(buf_ptr+7) =3D 1;
 	} else {
@@ -426,7 +426,7 @@ static void iuu_led_activity_off(struct urb *urb)
 	struct usb_serial_port *port =3D urb->context;
 	int result;
 	char *buf_ptr =3D port->write_urb->transfer_buffer;
-	if (xmas =3D=3D 1) {
+	if (xmas) {
 		iuu_rxcmd(urb);
 		return;
 	} else {
@@ -671,7 +671,7 @@ static int iuu_bulk_write(struct usb_serial_port *port)
 	buf_len =3D priv->writelen;
 	priv->writelen =3D 0;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	if (debug =3D=3D 1) {
+	if (debug) {
 		for (i =3D 0; i < buf_len; i++)
 			sprintf(priv->dbgbuf + i*2 ,
 				"%02X", priv->writebuf[i]);
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 03b5e24..98346ca 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2055,7 +2055,7 @@ static void mos7840_change_port_settings(struct tty_s=
truct *tty,
 	Data =3D 0x0c;
 	mos7840_set_uart_reg(port, INTERRUPT_ENABLE_REGISTER, Data);
=20
-	if (mos7840_port->read_urb_busy =3D=3D false) {
+	if (!mos7840_port->read_urb_busy) {
 		mos7840_port->read_urb_busy =3D true;
 		status =3D usb_submit_urb(mos7840_port->read_urb, GFP_ATOMIC);
 		if (status) {
@@ -2126,7 +2126,7 @@ static void mos7840_set_termios(struct tty_struct *tt=
y,
 		return;
 	}
=20
-	if (mos7840_port->read_urb_busy =3D=3D false) {
+	if (!mos7840_port->read_urb_busy) {
 		mos7840_port->read_urb_busy =3D true;
 		status =3D usb_submit_urb(mos7840_port->read_urb, GFP_ATOMIC);
 		if (status) {
diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_ser=
ial.c
index d074b37..d1d5f82 100644
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -82,7 +82,7 @@
 #endif
=20
 static bool debug;
-static bool safe =3D 1;
+static bool safe =3D true;
 static bool padded =3D CONFIG_USB_SERIAL_SAFE_PADDED;
=20
 #define DRIVER_VERSION "v0.1"
@@ -295,7 +295,7 @@ static int safe_startup(struct usb_serial *serial)
 	case LINEO_SAFESERIAL_CRC:
 		break;
 	case LINEO_SAFESERIAL_CRC_PADDED:
-		padded =3D 1;
+		padded =3D true;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index b4a7167..34ba15f 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -186,7 +186,7 @@ static void skel_read_bulk_callback(struct urb *urb)
 	} else {
 		dev->bulk_in_filled =3D urb->actual_length;
 	}
-	dev->ongoing_read =3D 0;
+	dev->ongoing_read =3D false;
 	spin_unlock(&dev->err_lock);
=20
 	complete(&dev->bulk_in_completion);
@@ -207,7 +207,7 @@ static int skel_do_read_io(struct usb_skel *dev, size_t=
 count)
 			dev);
 	/* tell everybody to leave the URB alone */
 	spin_lock_irq(&dev->err_lock);
-	dev->ongoing_read =3D 1;
+	dev->ongoing_read =3D true;
 	spin_unlock_irq(&dev->err_lock);
=20
 	/* do it */
@@ -218,7 +218,7 @@ static int skel_do_read_io(struct usb_skel *dev, size_t=
 count)
 		dev->bulk_in_filled =3D 0;
 		rv =3D (rv =3D=3D -ENOMEM) ? rv : -EIO;
 		spin_lock_irq(&dev->err_lock);
-		dev->ongoing_read =3D 0;
+		dev->ongoing_read =3D false;
 		spin_unlock_irq(&dev->err_lock);
 	}
=20
@@ -272,7 +272,7 @@ retry:
 		 * we must finish now
 		 */
 		dev->bulk_in_copied =3D 0;
-		dev->processed_urb =3D 1;
+		dev->processed_urb =3D true;
 	}
=20
 	if (!dev->processed_urb) {
@@ -282,7 +282,7 @@ retry:
 		 */
 		wait_for_completion(&dev->bulk_in_completion);
 		dev->bulk_in_copied =3D 0;
-		dev->processed_urb =3D 1;
+		dev->processed_urb =3D true;
 	}
=20
 	/* errors must be reported */
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index b0b2ac3..f6182c1 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1661,7 +1661,7 @@ static int __devinit aty128fb_setup(char *options)
 		}
 #ifdef CONFIG_MTRR
 		if(!strncmp(this_opt, "nomtrr", 6)) {
-			mtrr =3D 0;
+			mtrr =3D false;
 			continue;
 		}
 #endif
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.=
c
index 622f12b..0e67607 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -3854,10 +3854,10 @@ static int __init atyfb_setup(char *options)
=20
 	while ((this_opt =3D strsep(&options, ",")) !=3D NULL) {
 		if (!strncmp(this_opt, "noaccel", 7)) {
-			noaccel =3D 1;
+			noaccel =3D true;
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
-			nomtrr =3D 1;
+			nomtrr =3D true;
 #endif
 		} else if (!strncmp(this_opt, "vram:", 5))
 			vram =3D simple_strtoul(this_opt + 5, NULL, 0);
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_bas=
e.c
index ce1506b..f2aaf69 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -263,16 +263,16 @@ static reg_val common_regs[] =3D {
        =20
 static char *mode_option;
 static char *monitor_layout;
-static bool noaccel =3D 0;
+static bool noaccel =3D false;
 static int default_dynclk =3D -2;
-static bool nomodeset =3D 0;
-static bool ignore_edid =3D 0;
-static bool mirror =3D 0;
+static bool nomodeset =3D false;
+static bool ignore_edid =3D false;
+static bool mirror =3D false;
 static int panel_yres =3D 0;
-static bool force_dfp =3D 0;
-static bool force_measure_pll =3D 0;
+static bool force_dfp =3D false;
+static bool force_measure_pll =3D false;
 #ifdef CONFIG_MTRR
-static bool nomtrr =3D 0;
+static bool nomtrr =3D false;
 #endif
 static bool force_sleep;
 static bool ignore_devlist;
@@ -899,12 +899,12 @@ static int radeonfb_ioctl (struct fb_info *info, unsi=
gned int cmd,
 				tmp =3D INREG(CRTC_EXT_CNTL);
 				tmp |=3D CRTC_CRT_ON;
=20
-				mirror =3D 1;
+				mirror =3D true;
 			} else {
 				tmp =3D INREG(CRTC_EXT_CNTL);
 				tmp &=3D ~CRTC_CRT_ON;
=20
-				mirror =3D 0;
+				mirror =3D false;
 			}
=20
 			OUTREG(CRTC_EXT_CNTL, tmp);
@@ -2485,30 +2485,30 @@ static int __init radeonfb_setup (char *options)
 			continue;
=20
 		if (!strncmp(this_opt, "noaccel", 7)) {
-			noaccel =3D 1;
+			noaccel =3D true;
 		} else if (!strncmp(this_opt, "mirror", 6)) {
-			mirror =3D 1;
+			mirror =3D true;
 		} else if (!strncmp(this_opt, "force_dfp", 9)) {
-			force_dfp =3D 1;
+			force_dfp =3D true;
 		} else if (!strncmp(this_opt, "panel_yres:", 11)) {
 			panel_yres =3D simple_strtoul((this_opt+11), NULL, 0);
 		} else if (!strncmp(this_opt, "backlight:", 10)) {
 			backlight =3D simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
-			nomtrr =3D 1;
+			nomtrr =3D true;
 #endif
 		} else if (!strncmp(this_opt, "nomodeset", 9)) {
-			nomodeset =3D 1;
+			nomodeset =3D true;
 		} else if (!strncmp(this_opt, "force_measure_pll", 17)) {
-			force_measure_pll =3D 1;
+			force_measure_pll =3D true;
 		} else if (!strncmp(this_opt, "ignore_edid", 11)) {
-			ignore_edid =3D 1;
+			ignore_edid =3D true;
 #if defined(CONFIG_PM) && defined(CONFIG_X86)
 	 	} else if (!strncmp(this_opt, "force_sleep", 11)) {
-			force_sleep =3D 1;
+			force_sleep =3D true;
 		} else if (!strncmp(this_opt, "ignore_devlist", 14)) {
-			ignore_devlist =3D 1;
+			ignore_devlist =3D true;
 #endif
 		} else
 			mode_option =3D this_opt;
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 738c8ce..e766011 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2381,7 +2381,7 @@ static int __init cirrusfb_setup(char *options)
 			continue;
=20
 		if (!strcmp(this_opt, "noaccel"))
-			noaccel =3D 1;
+			noaccel =3D true;
 		else if (!strncmp(this_opt, "mode:", 5))
 			mode_option =3D this_opt + 5;
 		else
diff --git a/drivers/video/hgafb.c b/drivers/video/hgafb.c
index c645f92..905b29d 100644
--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -133,7 +133,7 @@ static struct fb_fix_screeninfo hga_fix __devinitdata =
=3D {
 /* Don't assume that tty1 will be the initial current console. */
 static int release_io_port =3D 0;
 static int release_io_ports =3D 0;
-static bool nologo =3D 0;
+static bool nologo =3D false;
=20
 /* -----------------------------------------------------------------------=
--
  *
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.=
c
index b83f361..a9e6cb6 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -1965,13 +1965,13 @@ static int __devinit i810fb_setup(char *options)
 =09
 	while ((this_opt =3D strsep(&options, ",")) !=3D NULL) {
 		if (!strncmp(this_opt, "mtrr", 4))
-			mtrr =3D 1;
+			mtrr =3D true;
 		else if (!strncmp(this_opt, "accel", 5))
-			accel =3D 1;
+			accel =3D true;
 		else if (!strncmp(this_opt, "extvga", 6))
-			extvga =3D 1;
+			extvga =3D true;
 		else if (!strncmp(this_opt, "sync", 4))
-			sync =3D 1;
+			sync =3D true;
 		else if (!strncmp(this_opt, "vram:", 5))
 			vram =3D (simple_strtoul(this_opt+5, NULL, 0));
 		else if (!strncmp(this_opt, "voffset:", 8))
@@ -1997,7 +1997,7 @@ static int __devinit i810fb_setup(char *options)
 		else if (!strncmp(this_opt, "vsync2:", 7))
 			vsync2 =3D simple_strtoul(this_opt+7, NULL, 0);
 		else if (!strncmp(this_opt, "dcolor", 6))
-			dcolor =3D 1;
+			dcolor =3D true;
 		else if (!strncmp(this_opt, "ddc3", 4))
 			ddc3 =3D true;
 		else
diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/int=
elfbdrv.c
index 02fd226..a091aba 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -230,15 +230,15 @@ MODULE_DESCRIPTION("Framebuffer driver for Intel(R) "=
 SUPPORTED_CHIPSETS
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DEVICE_TABLE(pci, intelfb_pci_table);
=20
-static bool accel       =3D 1;
+static bool accel       =3D true;
 static int vram         =3D 4;
-static bool hwcursor    =3D 0;
-static bool mtrr        =3D 1;
-static bool fixed       =3D 0;
-static bool noinit      =3D 0;
-static bool noregister  =3D 0;
-static bool probeonly   =3D 0;
-static bool idonly      =3D 0;
+static bool hwcursor    =3D false;
+static bool mtrr        =3D true;
+static bool fixed       =3D false;
+static bool noinit      =3D false;
+static bool noregister  =3D false;
+static bool probeonly   =3D false;
+static bool idonly      =3D false;
 static int bailearly    =3D 0;
 static int voffset	=3D 48;
 static char *mode       =3D NULL;
diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
index fb3f673..9754500 100644
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -2215,15 +2215,15 @@ static int __init neofb_setup(char *options)
 			continue;
=20
 		if (!strncmp(this_opt, "internal", 8))
-			internal =3D 1;
+			internal =3D true;
 		else if (!strncmp(this_opt, "external", 8))
-			external =3D 1;
+			external =3D true;
 		else if (!strncmp(this_opt, "nostretch", 9))
-			nostretch =3D 1;
+			nostretch =3D true;
 		else if (!strncmp(this_opt, "nopciburst", 10))
-			nopciburst =3D 1;
+			nopciburst =3D true;
 		else if (!strncmp(this_opt, "libretto", 8))
-			libretto =3D 1;
+			libretto =3D true;
 		else
 			mode_option =3D this_opt;
 	}
diff --git a/drivers/video/omap/omapfb_main.c b/drivers/video/omap/omapfb_m=
ain.c
index b291bfa..a1b7005 100644
--- a/drivers/video/omap/omapfb_main.c
+++ b/drivers/video/omap/omapfb_main.c
@@ -47,7 +47,7 @@ static unsigned int	def_rotate;
 static unsigned int	def_mirror;
=20
 #ifdef CONFIG_FB_OMAP_MANUAL_UPDATE
-static bool		manual_update =3D 1;
+static bool		manual_update =3D true;
 #else
 static bool		manual_update;
 #endif
@@ -1952,7 +1952,7 @@ static int __init omapfb_setup(char *options)
 		else if (!strncmp(this_opt, "mirror:", 7))
 			def_mirror =3D (simple_strtoul(this_opt + 7, NULL, 0));
 		else if (!strncmp(this_opt, "manual_update", 13))
-			manual_update =3D 1;
+			manual_update =3D true;
 		else {
 			pr_debug("omapfb: invalid option\n");
 			r =3D -1;
diff --git a/drivers/video/omap2/displays/panel-taal.c b/drivers/video/omap=
2/displays/panel-taal.c
index 00c5c61..c6822f2 100644
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@ -1186,7 +1186,7 @@ static int taal_power_on(struct omap_dss_device *dssd=
ev)
 	if (r)
 		goto err;
=20
-	td->enabled =3D 1;
+	td->enabled =3D true;
=20
 	if (!td->intro_printed) {
 		dev_info(&dssdev->dev, "%s panel revision %02x.%02x.%02x\n",
@@ -1229,7 +1229,7 @@ static void taal_power_off(struct omap_dss_device *ds=
sdev)
=20
 	omapdss_dsi_display_disable(dssdev, true, false);
=20
-	td->enabled =3D 0;
+	td->enabled =3D false;
 }
=20
 static int taal_panel_reset(struct omap_dss_device *dssdev)
diff --git a/drivers/video/omap2/dss/dispc.c b/drivers/video/omap2/dss/disp=
c.c
index e1626a1..7f35462 100644
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@ -1761,7 +1761,7 @@ int dispc_ovl_setup(enum omap_plane plane, struct oma=
p_overlay_info *oi,
 {
 	struct omap_overlay *ovl =3D omap_dss_get_overlay(plane);
 	bool five_taps =3D true;
-	bool fieldmode =3D 0;
+	bool fieldmode =3D false;
 	int r, cconv =3D 0;
 	unsigned offset0, offset1;
 	s32 row_inc;
@@ -1787,7 +1787,7 @@ int dispc_ovl_setup(enum omap_plane plane, struct oma=
p_overlay_info *oi,
 	outh =3D oi->out_height =3D=3D 0 ? oi->height : oi->out_height;
=20
 	if (ilace && oi->height =3D=3D outh)
-		fieldmode =3D 1;
+		fieldmode =3D true;
=20
 	if (ilace) {
 		if (fieldmode)
@@ -1993,7 +1993,7 @@ static void dispc_mgr_enable_digit_out(bool enable)
 	 * wait for the extra sync losts */
 	init_completion(&frame_done_completion);
=20
-	if (src =3D=3D DSS_HDMI_M_PCLK && enable =3D=3D false) {
+	if (src =3D=3D DSS_HDMI_M_PCLK && !enable) {
 		irq_mask =3D DISPC_IRQ_FRAMEDONETV;
 		num_irqs =3D 1;
 	} else {
diff --git a/drivers/video/omap2/dss/dsi.c b/drivers/video/omap2/dss/dsi.c
index 52f36ec..981efa3 100644
--- a/drivers/video/omap2/dss/dsi.c
+++ b/drivers/video/omap2/dss/dsi.c
@@ -1378,7 +1378,7 @@ retry:
=20
 	memset(&cur, 0, sizeof(cur));
 	cur.clkin =3D dss_sys_clk;
-	cur.use_sys_clk =3D 1;
+	cur.use_sys_clk =3D true;
 	cur.highfreq =3D 0;
=20
 	/* no highfreq: 0.75MHz < Fint =3D clkin / regn < 2.1MHz */
diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/omap2=
/omapfb/omapfb-main.c
index ce15831..1bbb6ce 100644
--- a/drivers/video/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/omap2/omapfb/omapfb-main.c
@@ -1350,7 +1350,7 @@ static void omapfb_free_fbmem(struct fb_info *fbi)
=20
 	rg->vaddr =3D NULL;
 	rg->paddr =3D 0;
-	rg->alloc =3D 0;
+	rg->alloc =3D false;
 	rg->size =3D 0;
 }
=20
@@ -1434,7 +1434,7 @@ static int omapfb_alloc_fbmem(struct fb_info *fbi, un=
signed long size,
 	rg->paddr =3D paddr;
 	rg->vaddr =3D vaddr;
 	rg->size =3D size;
-	rg->alloc =3D 1;
+	rg->alloc =3D true;
=20
 	return 0;
 }
@@ -2431,7 +2431,7 @@ static int omapfb_probe(struct platform_device *pdev)
 	*	 available for OMAP2 and OMAP3
 	*/
 	if (def_vrfb && !cpu_is_omap24xx() && !cpu_is_omap34xx()) {
-		def_vrfb =3D 0;
+		def_vrfb =3D false;
 		dev_warn(&pdev->dev, "VRFB is not supported on this hardware, "
 				"ignoring the module parameter vrfb=3Dy\n");
 	}
diff --git a/drivers/video/omap2/vram.c b/drivers/video/omap2/vram.c
index 9441e2e..55c2836 100644
--- a/drivers/video/omap2/vram.c
+++ b/drivers/video/omap2/vram.c
@@ -482,7 +482,7 @@ static __init int omap_vram_init(void)
 {
 	int i;
=20
-	vram_initialized =3D 1;
+	vram_initialized =3D true;
=20
 	for (i =3D 0; i < postponed_cnt; i++)
 		omap_vram_add_region(postponed_regions[i].paddr,
diff --git a/drivers/video/pm2fb.c b/drivers/video/pm2fb.c
index df31a24..ea15a84 100644
--- a/drivers/video/pm2fb.c
+++ b/drivers/video/pm2fb.c
@@ -1788,17 +1788,17 @@ static int __init pm2fb_setup(char *options)
 		if (!*this_opt)
 			continue;
 		if (!strcmp(this_opt, "lowhsync"))
-			lowhsync =3D 1;
+			lowhsync =3D true;
 		else if (!strcmp(this_opt, "lowvsync"))
-			lowvsync =3D 1;
+			lowvsync =3D true;
 		else if (!strncmp(this_opt, "hwcursor=3D", 9))
 			hwcursor =3D simple_strtoul(this_opt + 9, NULL, 0);
 #ifdef CONFIG_MTRR
 		else if (!strncmp(this_opt, "nomtrr", 6))
-			nomtrr =3D 1;
+			nomtrr =3D true;
 #endif
 		else if (!strncmp(this_opt, "noaccel", 7))
-			noaccel =3D 1;
+			noaccel =3D true;
 		else
 			mode_option =3D this_opt;
 	}
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
index 055e527..1195165 100644
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -1533,12 +1533,12 @@ static int __init pm3fb_setup(char *options)
 		if (!*this_opt)
 			continue;
 		else if (!strncmp(this_opt, "noaccel", 7))
-			noaccel =3D 1;
+			noaccel =3D true;
 		else if (!strncmp(this_opt, "hwcursor=3D", 9))
 			hwcursor =3D simple_strtoul(this_opt + 9, NULL, 0);
 #ifdef CONFIG_MTRR
 		else if (!strncmp(this_opt, "nomtrr", 6))
-			nomtrr =3D 1;
+			nomtrr =3D true;
 #endif
 		else
 			mode_option =3D this_opt;
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 2f58cf9..cada4ed 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -207,9 +207,9 @@ MODULE_DEVICE_TABLE(pci, rivafb_pci_tbl);
 /* command line data, set in rivafb_setup() */
 static int flatpanel __devinitdata =3D -1; /* Autodetect later */
 static int forceCRTC __devinitdata =3D -1;
-static bool noaccel  __devinitdata =3D 0;
+static bool noaccel  __devinitdata =3D false;
 #ifdef CONFIG_MTRR
-static bool nomtrr __devinitdata =3D 0;
+static bool nomtrr __devinitdata =3D false;
 #endif
 #ifdef CONFIG_PMAC_BACKLIGHT
 static int backlight __devinitdata =3D 1;
@@ -218,7 +218,7 @@ static int backlight __devinitdata =3D 0;
 #endif
=20
 static char *mode_option __devinitdata =3D NULL;
-static bool strictmode       =3D 0;
+static bool strictmode       =3D false;
=20
 static struct fb_fix_screeninfo __devinitdata rivafb_fix =3D {
 	.type		=3D FB_TYPE_PACKED_PIXELS,
@@ -2169,12 +2169,12 @@ static int __devinit rivafb_setup(char *options)
 			backlight =3D simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
-			nomtrr =3D 1;
+			nomtrr =3D true;
 #endif
 		} else if (!strncmp(this_opt, "strictmode", 10)) {
-			strictmode =3D 1;
+			strictmode =3D true;
 		} else if (!strncmp(this_opt, "noaccel", 7)) {
-			noaccel =3D 1;
+			noaccel =3D true;
 		} else
 			mode_option =3D this_opt;
 	}
diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
index 111fb32..e5ef994 100644
--- a/drivers/video/sstfb.c
+++ b/drivers/video/sstfb.c
@@ -95,7 +95,7 @@
=20
 static bool vgapass;		/* enable VGA passthrough cable */
 static int mem;			/* mem size in MB, 0 =3D autodetect */
-static bool clipping =3D 1;	/* use clipping (slower, safer) */
+static bool clipping =3D true;	/* use clipping (slower, safer) */
 static int gfxclk;		/* force FBI freq in Mhz . Dangerous */
 static bool slowpci;		/* slow PCI settings */
=20
@@ -1284,17 +1284,17 @@ static int  __devinit sstfb_setup(char *options)
 		f_ddprintk("option %s\n", this_opt);
=20
 		if (!strcmp(this_opt, "vganopass"))
-			vgapass =3D 0;
+			vgapass =3D false;
 		else if (!strcmp(this_opt, "vgapass"))
-			vgapass =3D 1;
+			vgapass =3D true;
 		else if (!strcmp(this_opt, "clipping"))
-		        clipping =3D 1;
+		        clipping =3D true;
 		else if (!strcmp(this_opt, "noclipping"))
-		        clipping =3D 0;
+		        clipping =3D false;
 		else if (!strcmp(this_opt, "fastpci"))
-		        slowpci =3D 0;
+		        slowpci =3D false;
 		else if (!strcmp(this_opt, "slowpci"))
-		        slowpci =3D 1;
+		        slowpci =3D true;
 		else if (!strncmp(this_opt, "mem:",4))
 			mem =3D simple_strtoul (this_opt+4, NULL, 0);
 		else if (!strncmp(this_opt, "gfxclk:",7))
diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
index e026724..b7e5482 100644
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -1608,7 +1608,7 @@ static void __init tdfxfb_setup(char *options)
 			hwcursor =3D simple_strtoul(this_opt + 9, NULL, 0);
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
-			nomtrr =3D 1;
+			nomtrr =3D true;
 #endif
 		} else {
 			mode_option =3D this_opt;
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index a197731..f42b9f4 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -69,9 +69,9 @@ static struct usb_device_id id_table[] =3D {
 MODULE_DEVICE_TABLE(usb, id_table);
=20
 /* module options */
-static bool console =3D 1; /* Allow fbcon to open framebuffer */
-static bool fb_defio =3D 1;  /* Detect mmap writes using page faults */
-static bool shadow =3D 1; /* Optionally disable shadow framebuffer */
+static bool console =3D true; /* Allow fbcon to open framebuffer */
+static bool fb_defio =3D true;  /* Detect mmap writes using page faults */
+static bool shadow =3D true; /* Optionally disable shadow framebuffer */
=20
 /* dlfb keeps a list of urbs for efficient bulk transfers */
 static void dlfb_urb_completion(struct urb *urb);
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index e7f69ef..fc5cc2c 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -44,7 +44,7 @@ static struct fb_fix_screeninfo uvesafb_fix __devinitdata=
 =3D {
 };
=20
 static int mtrr		__devinitdata =3D 3; /* enable mtrr by default */
-static bool blank	=3D 1;		   /* enable blanking by default */
+static bool blank	=3D true;		   /* enable blanking by default */
 static int ypan		=3D 1; 		 /* 0: scroll, 1: ypan, 2: ywrap */
 static bool pmi_setpal	__devinitdata =3D true; /* use PMI for palette chan=
ges */
 static bool nocrtc	__devinitdata; /* ignore CRTC settings */
@@ -1882,19 +1882,19 @@ static int __devinit uvesafb_setup(char *options)
 		else if (!strcmp(this_opt, "ywrap"))
 			ypan =3D 2;
 		else if (!strcmp(this_opt, "vgapal"))
-			pmi_setpal =3D 0;
+			pmi_setpal =3D false;
 		else if (!strcmp(this_opt, "pmipal"))
-			pmi_setpal =3D 1;
+			pmi_setpal =3D true;
 		else if (!strncmp(this_opt, "mtrr:", 5))
 			mtrr =3D simple_strtoul(this_opt+5, NULL, 0);
 		else if (!strcmp(this_opt, "nomtrr"))
 			mtrr =3D 0;
 		else if (!strcmp(this_opt, "nocrtc"))
-			nocrtc =3D 1;
+			nocrtc =3D true;
 		else if (!strcmp(this_opt, "noedid"))
-			noedid =3D 1;
+			noedid =3D true;
 		else if (!strcmp(this_opt, "noblank"))
-			blank =3D 0;
+			blank =3D false;
 		else if (!strncmp(this_opt, "vtotal:", 7))
 			vram_total =3D simple_strtoul(this_opt + 7, NULL, 0);
 		else if (!strncmp(this_opt, "vremap:", 7))
diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
index 501a922..d92f61c 100644
--- a/drivers/video/vfb.c
+++ b/drivers/video/vfb.c
@@ -110,7 +110,7 @@ static struct fb_fix_screeninfo vfb_fix __devinitdata =
=3D {
 	.accel =3D	FB_ACCEL_NONE,
 };
=20
-static bool vfb_enable __initdata =3D 0;	/* disabled by default */
+static bool vfb_enable __initdata =3D false;	/* disabled by default */
 module_param(vfb_enable, bool, 0);
=20
 static int vfb_check_var(struct fb_var_screeninfo *var,
@@ -453,12 +453,12 @@ static int __init vfb_setup(char *options)
 {
 	char *this_opt;
=20
-	vfb_enable =3D 0;
+	vfb_enable =3D false;
=20
 	if (!options)
 		return 1;
=20
-	vfb_enable =3D 1;
+	vfb_enable =3D true;
=20
 	if (!*options)
 		return 1;
@@ -468,7 +468,7 @@ static int __init vfb_setup(char *options)
 			continue;
 		/* Test disable for backwards compatibility */
 		if (!strcmp(this_opt, "disable"))
-			vfb_enable =3D 0;
+			vfb_enable =3D false;
 	}
 	return 1;
 }
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.=
c
index 20feb4d..3e87419 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -55,7 +55,7 @@ module_param(timeout, ushort, 0);
 MODULE_PARM_DESC(timeout,
 	"Watchdog timeout in ticks. (0<timeout<65536, default=3D65535)");
=20
-static bool reset =3D 1;
+static bool reset =3D true;
 module_param(reset, bool, 0);
 MODULE_PARM_DESC(reset,
 	"Watchdog Interrupt/Reset Mode. 0 =3D interrupt, 1 =3D reset");
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bcb884e..9bc10be 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1549,7 +1549,7 @@ static size_t get_note_info_size(struct elf_note_info=
 *info)
 static int write_note_info(struct elf_note_info *info,
 			   struct file *file, loff_t *foffset)
 {
-	bool first =3D 1;
+	bool first =3D true;
 	struct elf_thread_core_info *t =3D info->thread;
=20
 	do {
@@ -1568,7 +1568,7 @@ static int write_note_info(struct elf_note_info *info=
,
 			    !writenote(&t->notes[i], file, foffset))
 				return 0;
=20
-		first =3D 0;
+		first =3D false;
 		t =3D t->next;
 	} while (t);
=20
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index fe4cd0f..c122a18 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -53,8 +53,8 @@ static inline void btrfs_init_delayed_node(
 	delayed_node->inode_id =3D inode_id;
 	atomic_set(&delayed_node->refs, 0);
 	delayed_node->count =3D 0;
-	delayed_node->in_list =3D 0;
-	delayed_node->inode_dirty =3D 0;
+	delayed_node->in_list =3D false;
+	delayed_node->inode_dirty =3D false;
 	delayed_node->ins_root =3D RB_ROOT;
 	delayed_node->del_root =3D RB_ROOT;
 	mutex_init(&delayed_node->mutex);
@@ -178,7 +178,7 @@ static void btrfs_queue_delayed_node(struct btrfs_delay=
ed_root *root,
 		list_add_tail(&node->p_list, &root->prepare_list);
 		atomic_inc(&node->refs);	/* inserted into list */
 		root->nodes++;
-		node->in_list =3D 1;
+		node->in_list =3D true;
 	}
 	spin_unlock(&root->lock);
 }
@@ -194,7 +194,7 @@ static void btrfs_dequeue_delayed_node(struct btrfs_del=
ayed_root *root,
 		list_del_init(&node->n_list);
 		if (!list_empty(&node->p_list))
 			list_del_init(&node->p_list);
-		node->in_list =3D 0;
+		node->in_list =3D false;
 	}
 	spin_unlock(&root->lock);
 }
@@ -1051,7 +1051,7 @@ static void btrfs_release_delayed_inode(struct btrfs_=
delayed_node *delayed_node)
=20
 	if (delayed_node && delayed_node->inode_dirty) {
 		BUG_ON(!delayed_node->root);
-		delayed_node->inode_dirty =3D 0;
+		delayed_node->inode_dirty =3D false;
 		delayed_node->count--;
=20
 		delayed_root =3D delayed_node->root->fs_info->delayed_root;
@@ -1790,7 +1790,7 @@ int btrfs_delayed_update_inode(struct btrfs_trans_han=
dle *trans,
 		goto release_node;
=20
 	fill_stack_inode_item(trans, &delayed_node->inode_item, inode);
-	delayed_node->inode_dirty =3D 1;
+	delayed_node->inode_dirty =3D true;
 	delayed_node->count++;
 	atomic_inc(&root->fs_info->delayed_root->items);
 release_node:
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8b7794c..543cbbf 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4434,7 +4434,7 @@ findFirstRetry:
 				psrch_inf->unicode =3D false;
=20
 			psrch_inf->ntwrk_buf_start =3D (char *)pSMBr;
-			psrch_inf->smallBuf =3D 0;
+			psrch_inf->smallBuf =3D false;
 			psrch_inf->srch_entries_start =3D
 				(char *) &pSMBr->hdr.Protocol +
 					le16_to_cpu(pSMBr->t2.DataOffset);
@@ -4567,7 +4567,7 @@ int CIFSFindNext(const int xid, struct cifs_tcon *tco=
n,
 				cifs_buf_release(psrch_inf->ntwrk_buf_start);
 			psrch_inf->srch_entries_start =3D response_data;
 			psrch_inf->ntwrk_buf_start =3D (char *)pSMB;
-			psrch_inf->smallBuf =3D 0;
+			psrch_inf->smallBuf =3D false;
 			if (parms->EndofSearch)
 				psrch_inf->endOfSearch =3D true;
 			else
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9c28865..6b0333f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -963,9 +963,9 @@ cifs_parse_mount_options(const char *mountdata, const c=
har *devname,
=20
 	/* vol->retry default is 0 (i.e. "soft" limited retry not hard retry) */
 	/* default is always to request posix paths. */
-	vol->posix_paths =3D 1;
+	vol->posix_paths =3D true;
 	/* default to using server inode numbers where available */
-	vol->server_ino =3D 1;
+	vol->server_ino =3D true;
=20
 	vol->actimeo =3D CIFS_DEF_ACTIMEO;
=20
@@ -997,9 +997,9 @@ cifs_parse_mount_options(const char *mountdata, const c=
har *devname,
=20
 		/* Have to parse this before we parse for "user" */
 		if (strnicmp(data, "user_xattr", 10) =3D=3D 0) {
-			vol->no_xattr =3D 0;
+			vol->no_xattr =3D false;
 		} else if (strnicmp(data, "nouser_xattr", 12) =3D=3D 0) {
-			vol->no_xattr =3D 1;
+			vol->no_xattr =3D true;
 		} else if (strnicmp(data, "user", 4) =3D=3D 0) {
 			if (!value) {
 				printk(KERN_WARNING
@@ -1007,7 +1007,7 @@ cifs_parse_mount_options(const char *mountdata, const=
 char *devname,
 				goto cifs_parse_mount_err;
 			} else if (!*value) {
 				/* null user, ie anonymous, authentication */
-				vol->nullauth =3D 1;
+				vol->nullauth =3D true;
 			}
 			if (strnlen(value, MAX_USERNAME_SIZE) <
 						MAX_USERNAME_SIZE) {
@@ -1158,7 +1158,7 @@ cifs_parse_mount_options(const char *mountdata, const=
 char *devname,
 				vol->secFlg |=3D CIFSSEC_MAY_LANMAN;
 #endif
 			} else if (strnicmp(value, "none", 4) =3D=3D 0) {
-				vol->nullauth =3D 1;
+				vol->nullauth =3D true;
 			} else {
 				cERROR(1, "bad security option: %s", value);
 				goto cifs_parse_mount_err;
@@ -1334,7 +1334,7 @@ cifs_parse_mount_options(const char *mountdata, const=
 char *devname,
 				cERROR(1, "no socket option specified");
 				continue;
 			} else if (strnicmp(value, "TCP_NODELAY", 11) =3D=3D 0) {
-				vol->sockopt_tcp_nodelay =3D 1;
+				vol->sockopt_tcp_nodelay =3D true;
 			}
 		} else if (strnicmp(data, "netbiosname", 4) =3D=3D 0) {
 			if (!value || !*value || (*value =3D=3D ' ')) {
@@ -1408,9 +1408,9 @@ cifs_parse_mount_options(const char *mountdata, const=
 char *devname,
 		} else if (strnicmp(data, "ro", 2) =3D=3D 0) {
 			/* ignore */
 		} else if (strnicmp(data, "noblocksend", 11) =3D=3D 0) {
-			vol->noblocksnd =3D 1;
+			vol->noblocksnd =3D true;
 		} else if (strnicmp(data, "noautotune", 10) =3D=3D 0) {
-			vol->noautotune =3D 1;
+			vol->noautotune =3D true;
 		} else if ((strnicmp(data, "suid", 4) =3D=3D 0) ||
 				   (strnicmp(data, "nosuid", 6) =3D=3D 0) ||
 				   (strnicmp(data, "exec", 4) =3D=3D 0) ||
@@ -1426,34 +1426,34 @@ cifs_parse_mount_options(const char *mountdata, con=
st char *devname,
 			    is ok to just ignore them */
 			continue;
 		} else if (strnicmp(data, "hard", 4) =3D=3D 0) {
-			vol->retry =3D 1;
+			vol->retry =3D true;
 		} else if (strnicmp(data, "soft", 4) =3D=3D 0) {
-			vol->retry =3D 0;
+			vol->retry =3D false;
 		} else if (strnicmp(data, "perm", 4) =3D=3D 0) {
-			vol->noperm =3D 0;
+			vol->noperm =3D false;
 		} else if (strnicmp(data, "noperm", 6) =3D=3D 0) {
-			vol->noperm =3D 1;
+			vol->noperm =3D true;
 		} else if (strnicmp(data, "mapchars", 8) =3D=3D 0) {
-			vol->remap =3D 1;
+			vol->remap =3D true;
 		} else if (strnicmp(data, "nomapchars", 10) =3D=3D 0) {
-			vol->remap =3D 0;
+			vol->remap =3D false;
 		} else if (strnicmp(data, "sfu", 3) =3D=3D 0) {
-			vol->sfu_emul =3D 1;
+			vol->sfu_emul =3D true;
 		} else if (strnicmp(data, "nosfu", 5) =3D=3D 0) {
-			vol->sfu_emul =3D 0;
+			vol->sfu_emul =3D false;
 		} else if (strnicmp(data, "nodfs", 5) =3D=3D 0) {
-			vol->nodfs =3D 1;
+			vol->nodfs =3D true;
 		} else if (strnicmp(data, "posixpaths", 10) =3D=3D 0) {
-			vol->posix_paths =3D 1;
+			vol->posix_paths =3D true;
 		} else if (strnicmp(data, "noposixpaths", 12) =3D=3D 0) {
-			vol->posix_paths =3D 0;
+			vol->posix_paths =3D false;
 		} else if (strnicmp(data, "nounix", 6) =3D=3D 0) {
-			vol->no_linux_ext =3D 1;
+			vol->no_linux_ext =3D true;
 		} else if (strnicmp(data, "nolinux", 7) =3D=3D 0) {
-			vol->no_linux_ext =3D 1;
+			vol->no_linux_ext =3D true;
 		} else if ((strnicmp(data, "nocase", 6) =3D=3D 0) ||
 			   (strnicmp(data, "ignorecase", 10)  =3D=3D 0)) {
-			vol->nocase =3D 1;
+			vol->nocase =3D true;
 		} else if (strnicmp(data, "mand", 4) =3D=3D 0) {
 			/* ignore */
 		} else if (strnicmp(data, "nomand", 6) =3D=3D 0) {
@@ -1461,10 +1461,10 @@ cifs_parse_mount_options(const char *mountdata, con=
st char *devname,
 		} else if (strnicmp(data, "_netdev", 7) =3D=3D 0) {
 			/* ignore */
 		} else if (strnicmp(data, "brl", 3) =3D=3D 0) {
-			vol->nobrl =3D  0;
+			vol->nobrl =3D  false;
 		} else if ((strnicmp(data, "nobrl", 5) =3D=3D 0) ||
 			   (strnicmp(data, "nolock", 6) =3D=3D 0)) {
-			vol->nobrl =3D  1;
+			vol->nobrl =3D  true;
 			/* turn off mandatory locking in mode
 			if remote locking is turned off since the
 			local vfs will do advisory */
@@ -1481,43 +1481,43 @@ cifs_parse_mount_options(const char *mountdata, con=
st char *devname,
 			  negotiated this has no effect since mandatory locks
 			  would be used (mandatory locks is all that those
 			  those servers support) */
-			vol->mand_lock =3D 1;
+			vol->mand_lock =3D true;
 		} else if (strnicmp(data, "setuids", 7) =3D=3D 0) {
-			vol->setuids =3D 1;
+			vol->setuids =3D true;
 		} else if (strnicmp(data, "nosetuids", 9) =3D=3D 0) {
-			vol->setuids =3D 0;
+			vol->setuids =3D false;
 		} else if (strnicmp(data, "dynperm", 7) =3D=3D 0) {
 			vol->dynperm =3D true;
 		} else if (strnicmp(data, "nodynperm", 9) =3D=3D 0) {
 			vol->dynperm =3D false;
 		} else if (strnicmp(data, "nohard", 6) =3D=3D 0) {
-			vol->retry =3D 0;
+			vol->retry =3D false;
 		} else if (strnicmp(data, "nosoft", 6) =3D=3D 0) {
-			vol->retry =3D 1;
+			vol->retry =3D true;
 		} else if (strnicmp(data, "nointr", 6) =3D=3D 0) {
-			vol->intr =3D 0;
+			vol->intr =3D false;
 		} else if (strnicmp(data, "intr", 4) =3D=3D 0) {
-			vol->intr =3D 1;
+			vol->intr =3D true;
 		} else if (strnicmp(data, "nostrictsync", 12) =3D=3D 0) {
-			vol->nostrictsync =3D 1;
+			vol->nostrictsync =3D true;
 		} else if (strnicmp(data, "strictsync", 10) =3D=3D 0) {
-			vol->nostrictsync =3D 0;
+			vol->nostrictsync =3D false;
 		} else if (strnicmp(data, "serverino", 7) =3D=3D 0) {
-			vol->server_ino =3D 1;
+			vol->server_ino =3D true;
 		} else if (strnicmp(data, "noserverino", 9) =3D=3D 0) {
-			vol->server_ino =3D 0;
+			vol->server_ino =3D false;
 		} else if (strnicmp(data, "rwpidforward", 12) =3D=3D 0) {
-			vol->rwpidforward =3D 1;
+			vol->rwpidforward =3D true;
 		} else if (strnicmp(data, "cifsacl", 7) =3D=3D 0) {
-			vol->cifs_acl =3D 1;
+			vol->cifs_acl =3D true;
 		} else if (strnicmp(data, "nocifsacl", 9) =3D=3D 0) {
-			vol->cifs_acl =3D 0;
+			vol->cifs_acl =3D false;
 		} else if (strnicmp(data, "acl", 3) =3D=3D 0) {
-			vol->no_psx_acl =3D 0;
+			vol->no_psx_acl =3D false;
 		} else if (strnicmp(data, "noacl", 5) =3D=3D 0) {
-			vol->no_psx_acl =3D 1;
+			vol->no_psx_acl =3D true;
 		} else if (strnicmp(data, "locallease", 6) =3D=3D 0) {
-			vol->local_lease =3D 1;
+			vol->local_lease =3D true;
 		} else if (strnicmp(data, "sign", 4) =3D=3D 0) {
 			vol->secFlg |=3D CIFSSEC_MUST_SIGN;
 		} else if (strnicmp(data, "seal", 4) =3D=3D 0) {
@@ -1525,13 +1525,13 @@ cifs_parse_mount_options(const char *mountdata, con=
st char *devname,
 			   is a per tree connection (mount) not a per socket
 			   or per-smb connection option in the protocol */
 			/* vol->secFlg |=3D CIFSSEC_MUST_SEAL; */
-			vol->seal =3D 1;
+			vol->seal =3D true;
 		} else if (strnicmp(data, "direct", 6) =3D=3D 0) {
-			vol->direct_io =3D 1;
+			vol->direct_io =3D true;
 		} else if (strnicmp(data, "forcedirectio", 13) =3D=3D 0) {
-			vol->direct_io =3D 1;
+			vol->direct_io =3D true;
 		} else if (strnicmp(data, "strictcache", 11) =3D=3D 0) {
-			vol->strict_io =3D 1;
+			vol->strict_io =3D true;
 		} else if (strnicmp(data, "noac", 4) =3D=3D 0) {
 			printk(KERN_WARNING "CIFS: Mount option noac not "
 				"supported. Instead set "
@@ -2270,7 +2270,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, stru=
ct smb_vol *volume_info)
=20
 	/* ntlmv2 is much stronger than ntlm security, and has been broadly
 	supported for many years, time to update default security mechanism */
-	if ((volume_info->secFlg =3D=3D 0) && warned_on_ntlm =3D=3D false) {
+	if ((volume_info->secFlg =3D=3D 0) && !warned_on_ntlm) {
 		warned_on_ntlm =3D true;
 		cERROR(1, "default security mechanism requested.  The default "
 			"security mechanism will be upgraded from ntlm to "
@@ -2859,13 +2859,13 @@ void reset_cifs_unix_caps(int xid, struct cifs_tcon=
 *tcon,
=20
 	if (vol_info && vol_info->no_linux_ext) {
 		tcon->fsUnixInfo.Capability =3D 0;
-		tcon->unix_ext =3D 0; /* Unix Extensions disabled */
+		tcon->unix_ext =3D false; /* Unix Extensions disabled */
 		cFYI(1, "Linux protocol extensions disabled");
 		return;
 	} else if (vol_info)
-		tcon->unix_ext =3D 1; /* Unix Extensions supported */
+		tcon->unix_ext =3D true; /* Unix Extensions supported */
=20
-	if (tcon->unix_ext =3D=3D 0) {
+	if (!tcon->unix_ext) {
 		cFYI(1, "Unix extensions disabled so not set on reconnect");
 		return;
 	}
@@ -2903,7 +2903,7 @@ void reset_cifs_unix_caps(int xid, struct cifs_tcon *=
tcon,
 					CIFS_MOUNT_POSIXACL;
 		}
=20
-		if (vol_info && vol_info->posix_paths =3D=3D 0)
+		if (vol_info && !vol_info->posix_paths)
 			cap &=3D ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
 		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
 			cFYI(1, "negotiate posix pathnames");
@@ -3441,7 +3441,7 @@ try_mount_again:
 			goto mount_fail_check;
 		}
 	} else
-		tcon->unix_ext =3D 0; /* server does not support them */
+		tcon->unix_ext =3D false; /* server does not support them */
=20
 	/* do not care if following two calls succeed - informational */
 	if (!tcon->ipc) {
@@ -3685,7 +3685,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 			if ((bcc_ptr[0] =3D=3D 'I') && (bcc_ptr[1] =3D=3D 'P') &&
 			    (bcc_ptr[2] =3D=3D 'C')) {
 				cFYI(1, "IPC connection");
-				tcon->ipc =3D 1;
+				tcon->ipc =3D true;
 			}
 		} else if (length =3D=3D 2) {
 			if ((bcc_ptr[0] =3D=3D 'A') && (bcc_ptr[1] =3D=3D ':')) {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4dd9283..c50ab24 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2859,7 +2859,7 @@ void cifs_oplock_break(struct work_struct *work)
 		else
 			break_lease(inode, O_WRONLY);
 		rc =3D filemap_fdatawrite(inode->i_mapping);
-		if (cinode->clientCanCacheRead =3D=3D 0) {
+		if (!cinode->clientCanCacheRead) {
 			rc =3D filemap_fdatawait(inode->i_mapping);
 			mapping_set_error(inode->i_mapping, rc);
 			invalidate_remote_inode(inode);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 551d0c2..ddc210c 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -45,7 +45,7 @@ static bool is_first_ses_reconnect(struct cifs_ses *ses)
 	list_for_each(tmp, &ses->server->smb_ses_list) {
 		tmp_ses =3D list_entry(tmp, struct cifs_ses,
 				     smb_ses_list);
-		if (tmp_ses->need_reconnect =3D=3D false)
+		if (!tmp_ses->need_reconnect)
 			return false;
 	}
 	/* could not find a session that was already connected,
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index d22cd16..512599e 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -116,7 +116,7 @@ static int parse_options(char *options, struct exofs_mo=
untopt *opts)
 					  EXOFS_MIN_PID);
 				return -EINVAL;
 			}
-			s_pid =3D 1;
+			s_pid =3D true;
 			break;
 		case Opt_to:
 			if (match_int(&args[0], &option))
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 066836e..253d77a 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -308,7 +308,7 @@ int __generic_block_fiemap(struct inode *inode,
 			 */
 			if (!past_eof &&
 			    blk_to_logical(inode, start_blk) >=3D isize)
-				past_eof =3D 1;
+				past_eof =3D true;
=20
 			/*
 			 * First hole after going past the EOF, this is our
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index 54cea8a..8e8d1c6 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -386,7 +386,7 @@ static bool referring_call_exists(struct nfs_client *cl=
p,
 				  uint32_t nrclists,
 				  struct referring_call_list *rclists)
 {
-	bool status =3D 0;
+	bool status =3D false;
 	int i, j;
 	struct nfs4_session *session;
 	struct nfs4_slot_table *tbl;
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 31778f7..77875b7 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1203,7 +1203,7 @@ nfs4_find_client_no_ident(const struct sockaddr *addr=
)
=20
 	spin_lock(&nfs_client_lock);
 	list_for_each_entry(clp, &nfs_client_list, cl_share_link) {
-		if (nfs4_cb_match_client(addr, clp, 0) =3D=3D false)
+		if (!nfs4_cb_match_client(addr, clp, 0))
 			continue;
 		atomic_inc(&clp->cl_count);
 		spin_unlock(&nfs_client_lock);
@@ -1247,7 +1247,7 @@ nfs4_find_client_sessionid(const struct sockaddr *add=
r,
=20
 	spin_lock(&nfs_client_lock);
 	list_for_each_entry(clp, &nfs_client_list, cl_share_link) {
-		if (nfs4_cb_match_client(addr, clp, 1) =3D=3D false)
+		if (!nfs4_cb_match_client(addr, clp, 1))
 			continue;
=20
 		if (!nfs4_has_session(clp))
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f0c849c..e47c6d9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6021,7 +6021,7 @@ nfs4_proc_layoutcommit(struct nfs4_layoutcommit_data =
*data, bool sync)
 	task =3D rpc_run_task(&task_setup_data);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
-	if (sync =3D=3D false)
+	if (!sync)
 		goto out;
 	status =3D nfs4_wait_for_completion_rpc_task(task);
 	if (status !=3D 0)
diff --git a/fs/nfs/objlayout/objio_osd.c b/fs/nfs/objlayout/objio_osd.c
index 55d0128..2f8567b 100644
--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -334,7 +334,7 @@ objio_alloc_io_state(struct pnfs_layout_hdr *pnfs_layou=
t_type, bool is_reading,
 	ios->private =3D aos;
 	BUG_ON(ios->nr_pages > (pgbase + count + PAGE_SIZE - 1) >> PAGE_SHIFT);
=20
-	aos->objios.sync =3D 0;
+	aos->objios.sync =3D false;
 	aos->objios.ios =3D ios;
 	*outp =3D &aos->objios;
 	return 0;
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 896da74..ef38797 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -196,7 +196,7 @@ do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *c=
urrent_fh, struct nfsd4_o
 	__be32 status;
=20
 	fh_init(&resfh, NFS4_FHSIZE);
-	open->op_truncate =3D 0;
+	open->op_truncate =3D false;
=20
 	if (open->op_create) {
 		/* FIXME: check session persistence and pnfs flags.
@@ -313,7 +313,7 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compoun=
d_state *cstate,
 	/* We don't yet support WANT bits: */
 	open->op_share_access &=3D NFS4_SHARE_ACCESS_MASK;
=20
-	open->op_created =3D 0;
+	open->op_created =3D false;
 	/*
 	 * RFC5661 18.51.3
 	 * Before RECLAIM_COMPLETE done, server should deny new lock
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 0ec5a1b..7b96c9a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3532,7 +3532,7 @@ int nfsd4_check_resp_size(struct nfsd4_compoundres *r=
esp, u32 pad)
 	if (length > session->se_fchannel.maxresp_sz)
 		return nfserr_rep_too_big;
=20
-	if (slot->sl_cachethis =3D=3D 1 &&
+	if (slot->sl_cachethis &&
 	    length > session->se_fchannel.maxresp_cached)
 		return nfserr_rep_too_big_to_cache;
=20
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index edf6d3e..88cda07 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1490,7 +1490,7 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh =
*fhp,
 		goto out_nfserr;
 	}
 	if (created)
-		*created =3D 1;
+		*created =3D true;
=20
 	nfsd_check_ignore_resizing(iap);
=20
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 32df2b6..bd0ca92 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -616,7 +616,7 @@ static inline bool ata_id_has_flush(const u16 *id)
=20
 static inline bool ata_id_flush_enabled(const u16 *id)
 {
-	if (ata_id_has_flush(id) =3D=3D 0)
+	if (!ata_id_has_flush(id))
 		return false;
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) !=3D 0x4000)
 		return false;
@@ -632,7 +632,7 @@ static inline bool ata_id_has_flush_ext(const u16 *id)
=20
 static inline bool ata_id_flush_ext_enabled(const u16 *id)
 {
-	if (ata_id_has_flush_ext(id) =3D=3D 0)
+	if (!ata_id_has_flush_ext(id))
 		return false;
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) !=3D 0x4000)
 		return false;
@@ -699,7 +699,7 @@ static inline bool ata_id_has_lba48(const u16 *id)
=20
 static inline bool ata_id_lba48_enabled(const u16 *id)
 {
-	if (ata_id_has_lba48(id) =3D=3D 0)
+	if (!ata_id_has_lba48(id))
 		return false;
 	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) !=3D 0x4000)
 		return false;
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 611cd60..4bac914 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -329,7 +329,7 @@ bool noirqdebug __read_mostly;
=20
 int noirqdebug_setup(char *str)
 {
-	noirqdebug =3D 1;
+	noirqdebug =3D true;
 	printk(KERN_INFO "IRQ lockup detection disabled\n");
=20
 	return 1;
diff --git a/kernel/printk.c b/kernel/printk.c
index 13c0a11..ce14a53 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -525,7 +525,7 @@ static bool __read_mostly ignore_loglevel;
=20
 static int __init ignore_loglevel_setup(char *str)
 {
-	ignore_loglevel =3D 1;
+	ignore_loglevel =3D true;
 	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
=20
 	return 0;
@@ -696,9 +696,9 @@ static void zap_locks(void)
 }
=20
 #if defined(CONFIG_PRINTK_TIME)
-static bool printk_time =3D 1;
+static bool printk_time =3D true;
 #else
-static bool printk_time =3D 0;
+static bool printk_time =3D false;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
=20
@@ -1098,12 +1098,12 @@ int update_console_cmdline(char *name, int idx, cha=
r *name_new, int idx_new, cha
 	return -1;
 }
=20
-bool console_suspend_enabled =3D 1;
+bool console_suspend_enabled =3D true;
 EXPORT_SYMBOL(console_suspend_enabled);
=20
 static int __init console_suspend_disable(char *str)
 {
-	console_suspend_enabled =3D 0;
+	console_suspend_enabled =3D false;
 	return 1;
 }
 __setup("no_console_suspend", console_suspend_disable);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..ee1dd3e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4576,7 +4576,7 @@ bool __sched yield_to(struct task_struct *p, bool pre=
empt)
 	struct task_struct *curr =3D current;
 	struct rq *rq, *p_rq;
 	unsigned long flags;
-	bool yielded =3D 0;
+	bool yielded =3D false;
=20
 	local_irq_save(flags);
 	rq =3D this_rq();
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f487f25..214fe52 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2812,7 +2812,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int=
 write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err =3D 0;
-	bool first =3D 1;
+	bool first =3D true;
 	size_t left =3D *lenp;
 	unsigned long bitmap_len =3D table->maxlen;
 	unsigned long *bitmap =3D (unsigned long *) table->data;
@@ -2887,7 +2887,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int=
 write,
 			while (val_a <=3D val_b)
 				set_bit(val_a++, tmp_bitmap);
=20
-			first =3D 0;
+			first =3D false;
 			proc_skip_char(&kbuf, &left, '\n');
 		}
 		free_page(page);
@@ -2918,7 +2918,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int=
 write,
 					break;
 			}
=20
-			first =3D 0; bit_b++;
+			first =3D false; bit_b++;
 		}
 		if (!err)
 			err =3D proc_put_char(&buffer, &left, '\n');
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3f1bc5..fc8bf9d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -827,7 +827,7 @@ __acquires(kernel_lock)
 	tracing_set_tracer(type->name);
 	default_bootup_tracer =3D NULL;
 	/* disable other selftests, since this will break it. */
-	tracing_selftest_disabled =3D 1;
+	tracing_selftest_disabled =3D true;
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n=
",
 	       type->name);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 8e75003..6eab76f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1870,7 +1870,7 @@ int vsscanf(const char *buf, const char *fmt, va_list=
 args)
 			break;
=20
 		base =3D 10;
-		is_sign =3D 0;
+		is_sign =3D false;
=20
 		switch (*fmt++) {
 		case 'c':
@@ -1916,7 +1916,7 @@ int vsscanf(const char *buf, const char *fmt, va_list=
 args)
 		case 'i':
 			base =3D 0;
 		case 'd':
-			is_sign =3D 1;
+			is_sign =3D true;
 		case 'u':
 			break;
 		case '%':
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index b6f4b99..10c6d2d 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -269,7 +269,7 @@ void wait_for_unix_gc(void)
 	 */
 	if (unix_tot_inflight > UNIX_INFLIGHT_TRIGGER_GC && !gc_in_progress)
 		unix_gc();
-	wait_event(unix_gc_wait, gc_in_progress =3D=3D false);
+	wait_event(unix_gc_wait, !gc_in_progress);
 }
=20
 /* The external entry point: unix_gc() */
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 97ce8fa..b22e027 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -719,7 +719,7 @@ module_param_call(audit, param_set_audit, param_get_aud=
it,
 /* Determines if audit header is included in audited messages.  This
  * provides more context if the audit daemon is not running
  */
-bool aa_g_audit_header =3D 1;
+bool aa_g_audit_header =3D true;
 module_param_named(audit_header, aa_g_audit_header, aabool,
 		   S_IRUSR | S_IWUSR);
=20
@@ -742,7 +742,7 @@ module_param_named(path_max, aa_g_path_max, aauint, S_I=
RUSR | S_IWUSR);
 /* Determines how paranoid loading of policy is and how much verification
  * on the loaded policy is done.
  */
-bool aa_g_paranoid_load =3D 1;
+bool aa_g_paranoid_load =3D true;
 module_param_named(paranoid_load, aa_g_paranoid_load, aabool,
 		   S_IRUSR | S_IWUSR);
=20
@@ -902,7 +902,7 @@ static int __init apparmor_init(void)
=20
 	if (!apparmor_enabled || !security_module_enable(&apparmor_ops)) {
 		aa_info_message("AppArmor disabled by boot time parameter");
-		apparmor_enabled =3D 0;
+		apparmor_enabled =3D false;
 		return 0;
 	}
=20
@@ -944,7 +944,7 @@ register_security_out:
 alloc_out:
 	aa_destroy_aafs();
=20
-	apparmor_enabled =3D 0;
+	apparmor_enabled =3D false;
 	return error;
 }
=20
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/i=
ma_policy.c
index d45061d..d941e94 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -81,7 +81,7 @@ static DEFINE_MUTEX(ima_measure_mutex);
 static bool ima_use_tcb __initdata;
 static int __init default_policy_setup(char *str)
 {
-	ima_use_tcb =3D 1;
+	ima_use_tcb =3D true;
 	return 1;
 }
 __setup("ima_tcb", default_policy_setup);
diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index fbf9c58..6a9d7d4 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -532,7 +532,7 @@ int mls_compute_sid(struct context *scontext,
 			return mls_range_set(newcontext, r);
 		/* Fallthrough */
 	case AVTAB_CHANGE:
-		if ((tclass =3D=3D policydb.process_class) || (sock =3D=3D true))
+		if ((tclass =3D=3D policydb.process_class) || (sock))
 			/* Use the process MLS attributes. */
 			return mls_context_cpy(newcontext, scontext);
 		else
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.=
c
index 185f849..7e50765 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1451,7 +1451,7 @@ static int security_compute_sid(u32 ssid,
 	}
=20
 	/* Set the role and type to default values. */
-	if ((tclass =3D=3D policydb.process_class) || (sock =3D=3D true)) {
+	if ((tclass =3D=3D policydb.process_class) || (sock)) {
 		/* Use the current role and type of process. */
 		newcontext.role =3D scontext->role;
 		newcontext.type =3D scontext->type;
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index c47d3ce..6c63c58 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -1015,7 +1015,7 @@ static bool tomoyo_select_domain(struct tomoyo_io_buf=
fer *head,
 	if (domain)
 		head->r.domain =3D &domain->list;
 	else
-		head->r.eof =3D 1;
+		head->r.eof =3D true;
 	tomoyo_io_printf(head, "# select %s\n", data);
 	if (domain && domain->is_deleted)
 		tomoyo_io_printf(head, "# This is a deleted domain.\n");
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 08fde00..91fb06d 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -47,7 +47,7 @@
=20
 static int dsp_map[SNDRV_CARDS];
 static int adsp_map[SNDRV_CARDS] =3D {[0 ... (SNDRV_CARDS-1)] =3D 1};
-static bool nonblock_open =3D 1;
+static bool nonblock_open =3D true;
=20
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>, Abramo Bagnara <abramo@al=
sa-project.org>");
 MODULE_DESCRIPTION("PCM OSS emulation for ALSA.");
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index ad9434f..76e7bc9 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -66,9 +66,9 @@ static int pcm_devs[SNDRV_CARDS] =3D {[0 ... (SNDRV_CARDS=
 - 1)] =3D 1};
 static int pcm_substreams[SNDRV_CARDS] =3D {[0 ... (SNDRV_CARDS - 1)] =3D =
8};
 //static int midi_devs[SNDRV_CARDS] =3D {[0 ... (SNDRV_CARDS - 1)] =3D 2};
 #ifdef CONFIG_HIGH_RES_TIMERS
-static bool hrtimer =3D 1;
+static bool hrtimer =3D true;
 #endif
-static bool fake_buffer =3D 1;
+static bool fake_buffer =3D true;
=20
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for dummy soundcard.");
diff --git a/sound/drivers/opl3/opl3_seq.c b/sound/drivers/opl3/opl3_seq.c
index 6839953..2932fd6 100644
--- a/sound/drivers/opl3/opl3_seq.c
+++ b/sound/drivers/opl3/opl3_seq.c
@@ -32,7 +32,7 @@ MODULE_AUTHOR("Uros Bizjak <uros@kss-loka.si>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ALSA driver for OPL3 FM synth");
=20
-bool use_internal_drums =3D 0;
+bool use_internal_drums =3D false;
 module_param(use_internal_drums, bool, 0444);
 MODULE_PARM_DESC(use_internal_drums, "Enable internal OPL2/3 drums.");
=20
diff --git a/sound/drivers/pcsp/pcsp.c b/sound/drivers/pcsp/pcsp.c
index 99704e6..4a77c0f 100644
--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -54,7 +54,7 @@ static int __devinit snd_pcsp_create(struct snd_card *car=
d)
 			printk(KERN_ERR "PCSP: Make sure you have HPET and ACPI "
 				"enabled.\n");
 			printk(KERN_ERR "PCSP: Turned into nopcm mode.\n");
-			nopcm =3D 1;
+			nopcm =3D true;
 		}
 	}
=20
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index c24594c..ffeaf8f 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -61,7 +61,7 @@ static int dma2 =3D SNDRV_DEFAULT_DMA1;		/* 0,1,3 */
 static int wss;
 static int ide;
 #ifdef CONFIG_PNP
-static bool isapnp =3D 1;				/* Enable ISA PnP detection */
+static bool isapnp =3D true;				/* Enable ISA PnP detection */
 #endif
=20
 module_param(index, int, 0444);
diff --git a/sound/oss/ad1848.c b/sound/oss/ad1848.c
index 98d23bd..e7fe1a9 100644
--- a/sound/oss/ad1848.c
+++ b/sound/oss/ad1848.c
@@ -1918,7 +1918,7 @@ int ad1848_detect(struct resource *ports, int *ad_fla=
gs, int *osp)
 		for (i =3D 0; i < 16; i++) {
 			if ((tmp1 =3D ad_read(devc, i)) !=3D (tmp2 =3D ad_read(devc, i + 16))) =
{
 				DDB(printk("ad1848 detect step H(%d/%x/%x) - SoundPro chip?\n", i, tmp=
1, tmp2));
-				soundpro =3D 1;
+				soundpro =3D true;
 				devc->chip_name =3D "SoundPro CMI 8330";
 				break;
 			}
diff --git a/sound/oss/pas2_card.c b/sound/oss/pas2_card.c
index dabf8a8..344b0a5 100644
--- a/sound/oss/pas2_card.c
+++ b/sound/oss/pas2_card.c
@@ -43,15 +43,15 @@ DEFINE_SPINLOCK(pas_lock);
 #ifndef CONFIG_PAS_JOYSTICK
 static bool	joystick;
 #else
-static bool 	joystick =3D 1;
+static bool 	joystick =3D true;
 #endif
 #ifdef SYMPHONY_PAS
-static bool 	symphony =3D 1;
+static bool 	symphony =3D true;
 #else
 static bool 	symphony;
 #endif
 #ifdef BROKEN_BUS_CLOCK
-static bool	broken_bus_clock =3D 1;
+static bool	broken_bus_clock =3D true;
 #else
 static bool	broken_bus_clock;
 #endif
diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 0f32a56..69467a5 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -117,7 +117,7 @@
=20
 /* If compiled into kernel, it enable or disable pss mixer */
 #ifdef CONFIG_PSS_MIXER
-static bool pss_mixer =3D 1;
+static bool pss_mixer =3D true;
 #else
 static bool pss_mixer;
 #endif
@@ -1133,8 +1133,8 @@ static int mss_irq __initdata	=3D -1;
 static int mss_dma __initdata	=3D -1;
 static int mpu_io __initdata	=3D -1;
 static int mpu_irq __initdata	=3D -1;
-static bool pss_no_sound =3D 0;	/* Just configure non-sound components */
-static bool pss_keep_settings  =3D 1;	/* Keep hardware settings at module =
exit */
+static bool pss_no_sound =3D false;	/* Just configure non-sound components=
 */
+static bool pss_keep_settings  =3D true;	/* Keep hardware settings at modu=
le exit */
 static char *pss_firmware =3D "/etc/sound/pss_synth";
=20
 module_param(pss_io, int, 0);
diff --git a/sound/oss/trix.c b/sound/oss/trix.c
index 944e0c0..b33fe0b 100644
--- a/sound/oss/trix.c
+++ b/sound/oss/trix.c
@@ -218,7 +218,7 @@ static int __init init_trix_wss(struct address_info *hw=
_config)
 	if (!ret)
 		goto fail;
=20
-	if (joystick=3D=3D1)
+	if (joystick)
 		trix_write(0x15, 0x80);
=20
 	/*
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index e8de831..d529eb1 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -68,7 +68,7 @@ MODULE_DESCRIPTION("AudioScience ALSA ASI5000 ASI6000 ASI=
87xx ASI89xx "
 static int index[SNDRV_CARDS] =3D SNDRV_DEFAULT_IDX;	/* index 0-MAX */
 static char *id[SNDRV_CARDS] =3D SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] =3D SNDRV_DEFAULT_ENABLE_PNP;
-static bool enable_hpi_hwdep =3D 1;
+static bool enable_hpi_hwdep =3D true;
=20
 module_param_array(index, int, NULL, S_IRUGO);
 MODULE_PARM_DESC(index, "ALSA index value for AudioScience soundcard.");
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 590682f..874d979 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -43,7 +43,7 @@ static int index =3D SNDRV_DEFAULT_IDX1;	/* Index 0-MAX *=
/
 static char *id =3D SNDRV_DEFAULT_STR1;	/* ID for this card */
 static int ac97_clock =3D 48000;
 static char *ac97_quirk;
-static bool spdif_aclink =3D 1;
+static bool spdif_aclink =3D true;
 static int ac97_codec =3D -1;
=20
 module_param(index, int, 0444);
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 95ffa6a..ed809c1 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -715,14 +715,14 @@ snd_azf3328_mixer_ac97_read(struct snd_ac97 *ac97, un=
signed short reg_ac97)
 	const struct snd_azf3328 *chip =3D ac97->private_data;
 	unsigned short reg_azf =3D snd_azf3328_mixer_ac97_map_reg_idx(reg_ac97);
 	unsigned short reg_val =3D 0;
-	bool unsupported =3D 0;
+	bool unsupported =3D false;
=20
 	snd_azf3328_dbgmixer(
 		"snd_azf3328_mixer_ac97_read reg_ac97 %u\n",
 			reg_ac97
 	);
 	if (reg_azf & AZF_AC97_REG_UNSUPPORTED)
-		unsupported =3D 1;
+		unsupported =3D true;
 	else {
 		if (reg_azf & AZF_AC97_REG_REAL_IO_READ)
 			reg_val =3D snd_azf3328_mixer_inw(chip,
@@ -759,7 +759,7 @@ snd_azf3328_mixer_ac97_read(struct snd_ac97 *ac97, unsi=
gned short reg_ac97)
 				reg_val =3D azf_emulated_ac97_vendor_id & 0xffff;
 				break;
 			default:
-				unsupported =3D 1;
+				unsupported =3D true;
 				break;
 			}
 		}
@@ -776,14 +776,14 @@ snd_azf3328_mixer_ac97_write(struct snd_ac97 *ac97,
 {
 	const struct snd_azf3328 *chip =3D ac97->private_data;
 	unsigned short reg_azf =3D snd_azf3328_mixer_ac97_map_reg_idx(reg_ac97);
-	bool unsupported =3D 0;
+	bool unsupported =3D false;
=20
 	snd_azf3328_dbgmixer(
 		"snd_azf3328_mixer_ac97_write reg_ac97 %u val %u\n",
 			reg_ac97, val
 	);
 	if (reg_azf & AZF_AC97_REG_UNSUPPORTED)
-		unsupported =3D 1;
+		unsupported =3D true;
 	else {
 		if (reg_azf & AZF_AC97_REG_REAL_IO_WRITE)
 			snd_azf3328_mixer_outw(
@@ -808,7 +808,7 @@ snd_azf3328_mixer_ac97_write(struct snd_ac97 *ac97,
 				 */
 				break;
 			default:
-				unsupported =3D 1;
+				unsupported =3D true;
 				break;
 			}
 		}
@@ -1446,7 +1446,7 @@ snd_azf3328_ctrl_codec_activity(struct snd_azf3328 *c=
hip,
 		if (enable)
 			/* if enable codec, call enable_codecs func
 			   to enable codec supply... */
-			call_function =3D 1;
+			call_function =3D true;
 		else {
 			/* ...otherwise call enable_codecs func
 			   (which globally shuts down operation of codecs)
@@ -1559,7 +1559,7 @@ snd_azf3328_pcm_trigger(struct snd_pcm_substream *sub=
stream, int cmd)
 	struct snd_azf3328_codec_data *codec =3D runtime->private_data;
 	int result =3D 0;
 	u16 flags1;
-	bool previously_muted =3D 0;
+	bool previously_muted =3D false;
 	bool is_main_mixer_playback_codec =3D (AZF_CODEC_PLAYBACK =3D=3D codec->t=
ype);
=20
 	snd_azf3328_dbgcalls("snd_azf3328_pcm_trigger cmd %d\n", cmd);
@@ -2590,7 +2590,7 @@ snd_azf3328_create(struct snd_card *card,
=20
 		/* shutdown codecs to reduce power / noise */
 			/* have ...ctrl_codec_activity() act properly */
-		codec->running =3D 1;
+		codec->running =3D true;
 		snd_azf3328_ctrl_codec_activity(chip, codec_type, 0);
=20
 		spin_lock_irq(codec->lock);
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 95dfb68..dbbde6c 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -116,12 +116,12 @@ MODULE_PARM_DESC(power_save, "Automatic power-saving =
timeout "
  * this may give more power-saving, but will take longer time to
  * wake up.
  */
-static bool power_save_controller =3D 1;
+static bool power_save_controller =3D true;
 module_param(power_save_controller, bool, 0644);
 MODULE_PARM_DESC(power_save_controller, "Reset controller in power save mo=
de.");
 #endif
=20
-static bool align_buffer_size =3D 1;
+static bool align_buffer_size =3D true;
 module_param(align_buffer_size, bool, 0644);
 MODULE_PARM_DESC(align_buffer_size,
 		"Force buffer and period sizes to be multiple of 128 bytes.");
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 284e311..4299fe6 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -2400,7 +2400,7 @@ static bool add_input_route(struct hda_codec *codec, =
hda_nid_t pin)
 		    spec->num_inputs > 0 && spec->inputs[0].adc_idx !=3D c) {
 			snd_printd(KERN_INFO
 				   "via: dynamic ADC switching enabled\n");
-			spec->dyn_adc_switch =3D 1;
+			spec->dyn_adc_switch =3D true;
 		}
 		return true;
 	}
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index ade2c64..1adc180 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -1660,10 +1660,10 @@ static int __devinit snd_nm256_probe(struct pci_dev=
 *pci,
 			       "Loading stopped\n");
 			return -ENODEV;
 		case NM_RESET_WORKAROUND_2:
-			reset_workaround_2 =3D 1;
+			reset_workaround_2 =3D true;
 			/* Fall-through */
 		case NM_RESET_WORKAROUND:
-			reset_workaround =3D 1;
+			reset_workaround =3D true;
 			break;
 		}
 	}
diff --git a/sound/pci/oxygen/xonar_pcm179x.c b/sound/pci/oxygen/xonar_pcm1=
79x.c
index 8433aa7..204d4d2 100644
--- a/sound/pci/oxygen/xonar_pcm179x.c
+++ b/sound/pci/oxygen/xonar_pcm179x.c
@@ -467,7 +467,7 @@ static void xonar_st_init(struct oxygen *chip)
=20
 	data->generic.anti_pop_delay =3D 100;
 	data->h6 =3D chip->model.dac_channels_mixer > 2;
-	data->has_cs2000 =3D 1;
+	data->has_cs2000 =3D true;
 	data->cs2000_regs[CS2000_FUN_CFG_1] =3D CS2000_REF_CLK_DIV_1;
 	data->broken_i2c =3D true;
=20
diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
index ff500a8..0421296 100644
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -40,7 +40,7 @@ MODULE_SUPPORTED_DEVICE("{{SiS,SiS7019 Audio Accelerator}=
}");
=20
 static int index =3D SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
 static char *id =3D SNDRV_DEFAULT_STR1;	/* ID for this card */
-static bool enable =3D 1;
+static bool enable =3D true;
 static int codecs =3D 1;
=20
 module_param(index, int, 0444);
diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
index 5a4e263..7a0683e 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -36,7 +36,7 @@ MODULE_LICENSE("GPL");
=20
 static int index =3D SNDRV_DEFAULT_IDX1;		/* Index 0-MAX */
 static char *id =3D SNDRV_DEFAULT_STR1;		/* ID for this card */
-static bool enable_beep =3D 1;
+static bool enable_beep =3D true;
=20
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for " CHIP_NAME " soundchip.");
diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 391a38c..8ef98d2 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -55,7 +55,7 @@ MODULE_FIRMWARE("aica_firmware.bin");
 #define CARD_NAME "AICA"
 static int index =3D -1;
 static char *id;
-static bool enable =3D 1;
+static bool enable =3D true;
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for " CARD_NAME " soundcard.");
 module_param(id, charp, 0444);
diff --git a/sound/soc/codecs/cs4271.c b/sound/soc/codecs/cs4271.c
index f6fe846..3ab228b 100644
--- a/sound/soc/codecs/cs4271.c
+++ b/sound/soc/codecs/cs4271.c
@@ -192,10 +192,10 @@ static int cs4271_set_dai_fmt(struct snd_soc_dai *cod=
ec_dai,
=20
 	switch (format & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
-		cs4271->master =3D 0;
+		cs4271->master =3D false;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
-		cs4271->master =3D 1;
+		cs4271->master =3D true;
 		val |=3D CS4271_MODE1_MASTER;
 		break;
 	default:
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 7f4ba81..7002957 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -766,7 +766,7 @@ static int ldo_regulator_enable(struct regulator_dev *d=
ev)
 				SGTL5000_LINREG_SIMPLE_POWERUP,
 				0);
=20
-	ldo->enabled =3D 1;
+	ldo->enabled =3D true;
 	return 0;
 }
=20
@@ -783,7 +783,7 @@ static int ldo_regulator_disable(struct regulator_dev *=
dev)
 	snd_soc_update_bits(codec, SGTL5000_CHIP_LINREG_CTRL,
 				SGTL5000_LINREG_VDDD_MASK, 0);
=20
-	ldo->enabled =3D 0;
+	ldo->enabled =3D false;
=20
 	return 0;
 }
diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2=
s.c
index 0a74b95..071f365 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -395,7 +395,7 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *=
cpu_dai,
 	default:
 		return -EINVAL;
 	}
-	if (inv_fs =3D=3D true)
+	if (inv_fs)
 		pcr ^=3D (DAVINCI_MCBSP_PCR_FSXP | DAVINCI_MCBSP_PCR_FSRP);
 	davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_SRGR_REG, srgr);
 	dev->pcr =3D pcr;
diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
index 4f59bba..e163650 100644
--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -460,7 +460,7 @@ static int fsl_dma_open(struct snd_pcm_substream *subst=
ream)
 		return ret;
 	}
=20
-	dma->assigned =3D 1;
+	dma->assigned =3D true;
=20
 	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
 	snd_soc_set_runtime_hwparams(substream, &fsl_dma_hardware);
@@ -835,7 +835,7 @@ static int fsl_dma_close(struct snd_pcm_substream *subs=
tream)
 		substream->runtime->private_data =3D NULL;
 	}
=20
-	dma->assigned =3D 0;
+	dma->assigned =3D false;
=20
 	return 0;
 }
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index a67f437..e6832f2 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -261,7 +261,7 @@ static void cx81801_timeout(unsigned long data)
 	int muted;
=20
 	spin_lock(&ams_delta_lock);
-	cx81801_cmd_pending =3D 0;
+	cx81801_cmd_pending =3D false;
 	muted =3D ams_delta_muted;
 	spin_unlock(&ams_delta_lock);
=20
@@ -372,7 +372,7 @@ static void cx81801_receive(struct tty_struct *tty,
 		spin_lock_bh(&ams_delta_lock);
 		mod_timer(&cx81801_timer, jiffies + msecs_to_jiffies(150));
 		apply =3D !ams_delta_muted && !cx81801_cmd_pending;
-		cx81801_cmd_pending =3D 1;
+		cx81801_cmd_pending =3D true;
 		spin_unlock_bh(&ams_delta_lock);
=20
 		/* Apply config pulse by connecting the codec to the modem
@@ -451,7 +451,7 @@ static int ams_delta_set_bias_level(struct snd_soc_card=
 *card,
=20
 /* Digital mute implemented using modem/CPU multiplexer.
  * Shares hardware with codec config pulse generation */
-static bool ams_delta_muted =3D 1;
+static bool ams_delta_muted =3D true;
=20
 static int ams_delta_digital_mute(struct snd_soc_dai *dai, int mute)
 {
diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
index 0855c1c..5d8d13c 100644
--- a/sound/soc/omap/omap-dmic.c
+++ b/sound/soc/omap/omap-dmic.c
@@ -115,7 +115,7 @@ static int omap_dmic_dai_startup(struct snd_pcm_substre=
am *substream,
=20
 	if (!dai->active) {
 		snd_pcm_hw_constraint_msbits(substream->runtime, 0, 32, 24);
-		dmic->active =3D 1;
+		dmic->active =3D true;
 	} else {
 		ret =3D -EBUSY;
 	}
@@ -133,7 +133,7 @@ static void omap_dmic_dai_shutdown(struct snd_pcm_subst=
ream *substream,
 	mutex_lock(&dmic->mutex);
=20
 	if (!dai->active)
-		dmic->active =3D 0;
+		dmic->active =3D false;
=20
 	mutex_unlock(&dmic->mutex);
 }
diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index 0173719..3894324 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -495,7 +495,7 @@ static int omap_mcbsp_dai_set_dai_fmt(struct snd_soc_da=
i *cpu_dai,
 	default:
 		return -EINVAL;
 	}
-	if (inv_fs =3D=3D true)
+	if (inv_fs)
 		regs->pcr0 ^=3D FSXP | FSRP;
=20
 	return 0;
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 92cee24..03d9a7d 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2405,7 +2405,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	unsigned int mask =3D (1 << fls(max)) - 1;
 	unsigned int invert =3D mc->invert;
 	int err;
-	bool type_2r =3D 0;
+	bool type_2r =3D false;
 	unsigned int val2 =3D 0;
 	unsigned int val, val_mask;
=20
@@ -2423,7 +2423,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 			val |=3D val2 << rshift;
 		} else {
 			val2 =3D val2 << shift;
-			type_2r =3D 1;
+			type_2r =3D true;
 		}
 	}
 	err =3D snd_soc_update_bits_locked(codec, reg, val_mask, val);
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 4a7be7b..3e56808 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -83,7 +83,7 @@ static bool enable[SNDRV_CARDS] =3D SNDRV_DEFAULT_ENABLE_=
PNP;/* Enable this card *
 static int vid[SNDRV_CARDS] =3D { [0 ... (SNDRV_CARDS-1)] =3D -1 };
 static int pid[SNDRV_CARDS] =3D { [0 ... (SNDRV_CARDS-1)] =3D -1 };
 static int nrpacks =3D 8;		/* max. number of packets per urb */
-static bool async_unlink =3D 1;
+static bool async_unlink =3D true;
 static int device_setup[SNDRV_CARDS]; /* device parameter for this card */
 static bool ignore_ctl_error;
=20
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0abfb18..9e6a320 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -428,7 +428,7 @@ static int __cmd_record(struct perf_record *rec, int ar=
gc, const char **argv)
=20
 	flags =3D O_CREAT|O_RDWR;
 	if (rec->write_mode =3D=3D WRITE_APPEND)
-		rec->file_new =3D 0;
+		rec->file_new =3D false;
 	else
 		flags |=3D O_TRUNC;
=20
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25d34d4..8c8946d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -582,7 +582,7 @@ int cmd_report(int argc, const char **argv, const char =
*prefix __used)
 		 * for filtering, we don't want it.
 		 */
 		if (!strstr(sort_order, "parent"))
-			sort_parent.elide =3D 1;
+			sort_parent.elide =3D true;
 	} else
 		symbol_conf.exclude_other =3D false;
=20
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 29cb654..8e0bf40 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -838,7 +838,7 @@ static int parse_perf_probe_point(char *arg, struct per=
f_probe_event *pev)
 			break;
 		case '%':	/* Probe places */
 			if (strcmp(arg, "return") =3D=3D 0) {
-				pp->retprobe =3D 1;
+				pp->retprobe =3D true;
 			} else {	/* Others not supported yet */
 				semantic_error("%%%s is not supported.\n", arg);
 				return -ENOTSUP;

--=20
Best Regards,
Artem Bityutskiy

--=-Amhou7dANKJl/piYECUK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPNWk2AAoJECmIfjd9wqK0gvAP/RjjmVPf1qljIj9rGznw20wv
pSYIL23nrjVVHF0/wYV6NZ8+3+3EAb1mSs8vYMOxikFAS4cAzQap3PZE0KFb3djw
JKXH+QtBPQWt7xE/wnpjdexJVp7yD+GjbJApzjLb0XCl/7ljWuw1arvd7a/Z2lVv
ofVHk2aiTuwajRI7VWcud6yFefrMTgXB0eBTIy7iiuu8gRu2WmLMhfpX+53pwwok
uN4fmwiHYpAE0Ihu6hCR5Lx5J1ZFZ1R+wiliZgKZmZ3uHhC8rioCUFIERUHdNVEh
W7RT9NMF9/UGJj5tYuLxhVZguEteCPlpX/HKEHHa3HODK+SL9tT/cv66EOgBgt2v
A48W0ppUBwz3tc3kVfac4VwOQY2qaX8gmAMjNr8oSfwfA526VmQhbu4s+7e7b39F
jSWSadFLRZNYQTjGC5BUNZA6K+qU2X7rO8n8EoH8Xdm4vNJtu7DPjFp5dhhPr+XR
VcN7f7t5no+dd59SZPapRNfXe5/rhzDkL+aDwliJ+8HawWOC0FUzal7uR7A4LiyX
DDl/bZZoxvmKdejbr9vW7f+MLOa1PkFPE00E6I1ZY9ebFVKeCXgmUvSaNc7Y0ktu
vTc5vduJkvUyx+idLaEiB/8xIRvUcOGzWTbTrp5yv5zKeAAmLKcuH0mtACg0K2C2
EdVAabRmndYzrO87Cbc9
=MAsV
-----END PGP SIGNATURE-----

--=-Amhou7dANKJl/piYECUK--

