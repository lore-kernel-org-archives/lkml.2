Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab1COC7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 22:59:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40754 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1COC7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 22:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=TrgHkXWEUnFNChiznW+UAJBIHUK6LQluGVsV1tD+cDTx5D9QiMaYvDjg0maeK2uvKT
         5r0pQwMoOMna6CTSgU7JOXwhRj749wa2IpDlKiMW4bqDNFr3Wg4oD3X7qlTQq6ztR3K7
         XESSRiwXFb6YLRl1nY217WKe2vT85X45hB1zY=
Date: Tue, 15 Mar 2011 10:58:41 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH v2/resend] trivial: fix common spelling mistakes
Message-ID: <20110315025835.GA3372@gmail.com>
Mail-Followup-To: Peter Huewe <peterhuewe@gmx.de>, greg@kroah.com,
	linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
References: <alpine.LNX.2.00.1101071103440.26685@pobox.suse.cz>
 <1299624593-13058-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299624593-13058-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 11:49:53PM +0100, Peter Huewe wrote:
> This patch fixes some very common spelling mistakes.
> The changes were carried out by hand and are made in
> documentation/comments only - no functional change.
> Variables were left untouched on purpose.
> Linebreaks were also left untouched on purpose.
Hi Peter,
   I have sense that you should split this
patch for patches, which one patch just do
one spelling mistakes.
   But there are so many spelling mistakes. 
I wanna help you with this stuff. Would you 
like to assign some to me. I am so pleasure 
for this.

Thanks.
Best Regards.
Harry Wei.
> 
> v2: Added some more spellchecks
> 
> The fixed spelling mistakes are:
> WRONG -> RIGHT
> 
> accomodate -> accommodate
> acommodate -> accommodate
> 
> adress -> address
> addres -> address
> 
> hightest -> highest
> hight -> height
> hight -> high (when mentioned in contrast to low)
> hightlight -> highlight
> 
> libary -> library
> libaray -> library
> 
> occured -> occurred
> 
> reqest -> request
> reguest -> request
> requst -> request
> reqeust -> request
> 
> acheive -> achieve
> beggining -> beginning
> embarass -> embarrass
> enviroment -> environment
> fagment -> fragment
> indefinately-> indefinitely
> knowlege -> knowledge
> regester -> register
> unferflow -> underflow
> 
> recieve -> receive
> 
> interupt -> interrupt
> interrrupt -> interrupt
> 
> paralell -> parallel
> paralel -> parallel
> preceeding -> preceding
> publically -> publicly
> shedule -> shedule
> supercede -> supersede
> wierd -> weird
> writen -> written
> writting -> writing
> 
> And some other minor changes that caught my eye doing the changes
> 
> KernelVersion: Trivial Git (795abaf1e) 20110308
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  arch/x86/crypto/aesni-intel_asm.S                  |    2 +-
>  arch/x86/kernel/i387.c                             |    2 +-
>  arch/x86/kernel/kvmclock.c                         |    2 +-
>  arch/x86/kvm/x86.c                                 |    2 +-
>  arch/x86/pci/i386.c                                |    2 +-
>  crypto/async_tx/async_xor.c                        |    2 +-
>  drivers/ata/ahci.h                                 |    2 +-
>  drivers/ata/ata_piix.c                             |    4 +-
>  drivers/ata/libata-scsi.c                          |    2 +-
>  drivers/ata/pata_amd.c                             |    2 +-
>  drivers/ata/pata_cs5520.c                          |    2 +-
>  drivers/ata/pata_sil680.c                          |    2 +-
>  drivers/ata/pata_triflex.c                         |    2 +-
>  drivers/ata/sata_mv.c                              |    2 +-
>  drivers/atm/idt77252.h                             |    2 +-
>  drivers/block/cciss.c                              |    2 +-
>  drivers/block/drbd/drbd_int.h                      |    2 +-
>  drivers/block/ps3vram.c                            |    2 +-
>  drivers/block/xsysace.c                            |    2 +-
>  drivers/bluetooth/btmrvl_sdio.c                    |    2 +-
>  drivers/char/mxser.h                               |    2 +-
>  drivers/dma/intel_mid_dma.c                        |    4 +-
>  drivers/dma/intel_mid_dma_regs.h                   |    4 +-
>  drivers/edac/edac_core.h                           |    2 +-
>  drivers/gpu/drm/i915/intel_dp.c                    |    2 +-
>  drivers/gpu/drm/nouveau/nv40_graph.c               |    2 +-
>  drivers/gpu/drm/radeon/atombios.h                  |    6 ++--
>  drivers/gpu/drm/radeon/radeon.h                    |    2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |    4 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    2 +-
>  drivers/gpu/vga/vgaarb.c                           |    2 +-
>  drivers/hid/hid-core.c                             |    4 +-
>  drivers/hid/hid-roccat-kone.h                      |    2 +-
>  drivers/hwmon/hp_accel.c                           |    2 +-
>  drivers/hwmon/sht15.c                              |    4 +-
>  drivers/hwmon/w83791d.c                            |    2 +-
>  drivers/i2c/algos/i2c-algo-pcf.c                   |    2 +-
>  drivers/i2c/busses/i2c-cpm.c                       |    2 +-
>  drivers/i2c/busses/i2c-elektor.c                   |    4 +-
>  drivers/i2c/busses/i2c-intel-mid.c                 |   12 ++++----
>  drivers/ide/piix.c                                 |    4 +-
>  drivers/ide/triflex.c                              |    2 +-
>  drivers/ide/via82cxxx.c                            |    2 +-
>  drivers/infiniband/hw/ipath/ipath_intr.c           |    2 +-
>  drivers/infiniband/hw/ipath/ipath_ruc.c            |    2 +-
>  drivers/infiniband/hw/qib/qib_iba6120.c            |    2 +-
>  drivers/infiniband/hw/qib/qib_iba7220.c            |    2 +-
>  drivers/infiniband/hw/qib/qib_iba7322.c            |    2 +-
>  drivers/infiniband/hw/qib/qib_keys.c               |    2 +-
>  drivers/infiniband/hw/qib/qib_mad.h                |    2 +-
>  drivers/infiniband/hw/qib/qib_ruc.c                |    2 +-
>  drivers/input/misc/keyspan_remote.c                |    2 +-
>  drivers/input/mouse/bcm5974.c                      |    2 +-
>  drivers/input/mouse/logips2pp.c                    |    2 +-
>  drivers/input/mouse/vsxxxaa.c                      |    2 +-
>  drivers/isdn/hardware/mISDN/mISDNipac.c            |    2 +-
>  drivers/isdn/hardware/mISDN/w6692.c                |    2 +-
>  drivers/isdn/hisax/amd7930_fn.c                    |    2 +-
>  drivers/isdn/hisax/avm_pci.c                       |    2 +-
>  drivers/isdn/hisax/elsa.c                          |    2 +-
>  drivers/isdn/hisax/hisax_fcpcipnp.c                |    4 +-
>  drivers/isdn/hisax/l3dss1.c                        |    2 +-
>  drivers/isdn/isdnloop/isdnloop.c                   |    2 +-
>  drivers/isdn/mISDN/dsp_dtmf.c                      |    2 +-
>  drivers/md/dm-region-hash.c                        |    2 +-
>  drivers/md/md.h                                    |    2 +-
>  drivers/media/common/saa7146_i2c.c                 |    6 ++--
>  drivers/media/common/tuners/mxl5005s.c             |    2 +-
>  drivers/media/dvb/b2c2/flexcop-pci.c               |    2 +-
>  drivers/media/dvb/dvb-core/dvb_frontend.c          |    2 +-
>  drivers/media/dvb/dvb-usb/dvb-usb.h                |    2 +-
>  drivers/media/dvb/dvb-usb/lmedm04.c                |   12 ++++----
>  drivers/media/dvb/frontends/dib7000m.c             |    2 +-
>  drivers/media/dvb/frontends/dib7000p.c             |    2 +-
>  drivers/media/dvb/frontends/s5h1420.c              |    2 +-
>  drivers/media/dvb/pluto2/pluto2.c                  |    4 +-
>  drivers/media/dvb/ttusb-dec/ttusb_dec.c            |    2 +-
>  drivers/media/rc/nuvoton-cir.c                     |    2 +-
>  drivers/media/rc/rc-main.c                         |    2 +-
>  drivers/media/video/cafe_ccic.c                    |    2 +-
>  drivers/media/video/cx23885/cx23885.h              |    4 +-
>  drivers/media/video/davinci/dm644x_ccdc.c          |    2 +-
>  drivers/media/video/gspca/sonixj.c                 |    2 +-
>  drivers/media/video/gspca/spca501.c                |    2 +-
>  drivers/media/video/gspca/zc3xx.c                  |    2 +-
>  drivers/media/video/ivtv/ivtv-firmware.c           |    2 +-
>  drivers/media/video/ov6650.c                       |    2 +-
>  drivers/media/video/ov9640.c                       |    2 +-
>  drivers/media/video/saa7164/saa7164-cmd.c          |    2 +-
>  drivers/media/video/stk-sensor.c                   |    2 +-
>  drivers/media/video/uvc/uvc_video.c                |    4 +-
>  drivers/message/fusion/lsi/mpi_log_sas.h           |   10 ++++----
>  drivers/message/fusion/lsi/mpi_raid.h              |    2 +-
>  drivers/message/fusion/mptbase.c                   |    2 +-
>  drivers/message/fusion/mptctl.c                    |    2 +-
>  drivers/misc/iwmc3200top/main.c                    |    2 +-
>  drivers/misc/kgdbts.c                              |    2 +-
>  drivers/misc/sgi-gru/grukservices.c                |    2 +-
>  drivers/mmc/core/mmc_ops.c                         |    2 +-
>  drivers/mmc/host/atmel-mci.c                       |    2 +-
>  drivers/mtd/chips/cfi_cmdset_0001.c                |    4 +-
>  drivers/mtd/lpddr/lpddr_cmds.c                     |    2 +-
>  drivers/mtd/maps/ceiva.c                           |    2 +-
>  drivers/mtd/maps/pmcmsp-flash.c                    |    2 +-
>  drivers/mtd/mtdchar.c                              |    2 +-
>  drivers/mtd/nand/diskonchip.c                      |    4 +-
>  drivers/mtd/nand/r852.c                            |    6 ++--
>  drivers/mtd/nand/sh_flctl.c                        |    2 +-
>  drivers/net/amd8111e.c                             |    2 +-
>  drivers/net/amd8111e.h                             |    2 +-
>  drivers/net/arm/ks8695net.c                        |    2 +-
>  drivers/net/atl1c/atl1c_hw.c                       |    2 +-
>  drivers/net/atl1e/atl1e_hw.c                       |    2 +-
>  drivers/net/atlx/atl2.c                            |    2 +-
>  drivers/net/bfin_mac.c                             |    4 +-
>  drivers/net/bnx2x/bnx2x_main.c                     |    2 +-
>  drivers/net/bonding/bond_alb.c                     |    2 +-
>  drivers/net/caif/caif_shmcore.c                    |    2 +-
>  drivers/net/caif/caif_spi_slave.c                  |    2 +-
>  drivers/net/can/janz-ican3.c                       |    8 +++---
>  drivers/net/can/sja1000/sja1000.c                  |    2 +-
>  drivers/net/can/usb/ems_usb.c                      |    2 +-
>  drivers/net/can/usb/esd_usb2.c                     |    2 +-
>  drivers/net/cassini.c                              |    2 +-
>  drivers/net/cxgb3/t3_hw.c                          |    6 ++--
>  drivers/net/cxgb4/t4_hw.c                          |    2 +-
>  drivers/net/davinci_emac.c                         |    2 +-
>  drivers/net/e1000e/netdev.c                        |    2 +-
>  drivers/net/fec.h                                  |    2 +-
>  drivers/net/ibm_newemac/tah.c                      |    2 +-
>  drivers/net/igb/e1000_phy.c                        |    2 +-
>  drivers/net/igb/igb_main.c                         |    2 +-
>  drivers/net/igbvf/netdev.c                         |    2 +-
>  drivers/net/ipg.c                                  |   20 +++++++-------
>  drivers/net/irda/donauboe.c                        |    2 +-
>  drivers/net/irda/mcs7780.c                         |    2 +-
>  drivers/net/irda/pxaficp_ir.c                      |    4 +-
>  drivers/net/irda/via-ircc.c                        |    2 +-
>  drivers/net/ixgbe/ixgbe_phy.c                      |    2 +-
>  drivers/net/mlx4/en_ethtool.c                      |    2 +-
>  drivers/net/mlx4/en_rx.c                           |    4 +-
>  drivers/net/natsemi.c                              |    2 +-
>  drivers/net/ppp_async.c                            |    2 +-
>  drivers/net/pxa168_eth.c                           |    2 +-
>  drivers/net/s2io.c                                 |    2 +-
>  drivers/net/sfc/mcdi_pcol.h                        |    4 +-
>  drivers/net/sis190.c                               |    4 +-
>  drivers/net/sis900.c                               |    4 +-
>  drivers/net/skge.h                                 |    8 +++---
>  drivers/net/sky2.c                                 |    2 +-
>  drivers/net/sky2.h                                 |    6 ++--
>  drivers/net/smc91x.h                               |    2 +-
>  drivers/net/smsc911x.c                             |    2 +-
>  drivers/net/smsc9420.c                             |    2 +-
>  drivers/net/tc35815.c                              |    8 +++---
>  drivers/net/tehuti.c                               |    4 +-
>  drivers/net/tokenring/olympic.c                    |    2 +-
>  drivers/net/tsi108_eth.h                           |    8 +++---
>  drivers/net/usb/rndis_host.c                       |    2 +-
>  drivers/net/via-rhine.c                            |    4 +-
>  drivers/net/via-velocity.c                         |    2 +-
>  drivers/net/vmxnet3/vmxnet3_drv.c                  |    2 +-
>  drivers/net/vxge/vxge-config.h                     |    2 +-
>  drivers/net/wan/lmc/lmc_var.h                      |    2 +-
>  drivers/net/wimax/i2400m/driver.c                  |    2 +-
>  drivers/net/wimax/i2400m/i2400m-usb.h              |    2 +-
>  drivers/net/wimax/i2400m/rx.c                      |    4 +-
>  drivers/net/wireless/ath/ath5k/reg.h               |    4 +-
>  drivers/net/wireless/ath/regd.c                    |    2 +-
>  drivers/net/wireless/b43/b43.h                     |    4 +-
>  drivers/net/wireless/ipw2x00/ipw2200.c             |    2 +-
>  drivers/net/wireless/libertas/cfg.c                |    2 +-
>  drivers/net/wireless/libertas/if_spi.h             |    2 +-
>  drivers/net/wireless/rt2x00/rt2800.h               |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00link.c           |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00queue.h          |    8 +++---
>  drivers/net/wireless/rt2x00/rt2x00usb.c            |    4 +-
>  drivers/net/wireless/rt2x00/rt2x00usb.h            |    2 +-
>  drivers/net/wireless/rtlwifi/debug.h               |    2 +-
>  drivers/net/wireless/rtlwifi/pci.c                 |    2 +-
>  drivers/net/wireless/rtlwifi/regd.c                |    2 +-
>  drivers/net/wireless/wl12xx/io.h                   |    2 +-
>  drivers/net/wireless/zd1211rw/zd_rf_uw2453.c       |    2 +-
>  drivers/parisc/pdc_stable.c                        |    2 +-
>  drivers/parport/parport_pc.c                       |    2 +-
>  drivers/pnp/pnpbios/bioscalls.c                    |    2 +-
>  drivers/ps3/ps3-lpm.c                              |    4 +-
>  drivers/ps3/ps3-sys-manager.c                      |    2 +-
>  drivers/rapidio/rio-scan.c                         |    2 +-
>  drivers/rtc/interface.c                            |    2 +-
>  drivers/rtc/rtc-sa1100.c                           |    2 +-
>  drivers/s390/block/dasd_3990_erp.c                 |    4 +-
>  drivers/s390/char/tty3270.c                        |    2 +-
>  drivers/s390/cio/device_fsm.c                      |    2 +-
>  drivers/s390/net/claw.c                            |    2 +-
>  drivers/s390/net/ctcm_fsms.c                       |    2 +-
>  drivers/scsi/3w-9xxx.h                             |    2 +-
>  drivers/scsi/advansys.c                            |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_core.c                |    6 ++--
>  drivers/scsi/aic7xxx/aic7xxx_core.c                |    4 +-
>  drivers/scsi/be2iscsi/be_cmds.h                    |   18 +++++++-------
>  drivers/scsi/bfa/bfa_defs_svc.h                    |    2 +-
>  drivers/scsi/bfa/bfa_fc.h                          |    2 +-
>  drivers/scsi/bfa/bfa_svc.c                         |    2 +-
>  drivers/scsi/bnx2i/bnx2i_hwi.c                     |    2 +-
>  drivers/scsi/cxgbi/libcxgbi.h                      |    6 ++--
>  drivers/scsi/dc395x.c                              |    2 +-
>  drivers/scsi/fcoe/libfcoe.c                        |    2 +-
>  drivers/scsi/fdomain.c                             |    2 +-
>  drivers/scsi/gdth.h                                |    2 +-
>  drivers/scsi/initio.c                              |    2 +-
>  drivers/scsi/libfc/fc_lport.c                      |    4 +-
>  drivers/scsi/lpfc/lpfc_bsg.c                       |    2 +-
>  drivers/scsi/lpfc/lpfc_hbadisc.c                   |    4 +-
>  drivers/scsi/lpfc/lpfc_sli.c                       |    4 +-
>  drivers/scsi/megaraid/mega_common.h                |    2 +-
>  drivers/scsi/megaraid/megaraid_mbox.c              |    2 +-
>  drivers/scsi/mpt2sas/mpt2sas_base.c                |    2 +-
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c                 |    2 +-
>  drivers/scsi/mpt2sas/mpt2sas_ctl.h                 |    2 +-
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    6 ++--
>  drivers/scsi/pmcraid.c                             |    4 +-
>  drivers/scsi/qla2xxx/qla_fw.h                      |    2 +-
>  drivers/scsi/qla2xxx/qla_isr.c                     |    2 +-
>  drivers/scsi/qla2xxx/qla_mbx.c                     |    6 ++--
>  drivers/scsi/qla2xxx/qla_nx.c                      |    2 +-
>  drivers/scsi/qla4xxx/ql4_def.h                     |    2 +-
>  drivers/scsi/scsi_netlink.c                        |    2 +-
>  drivers/scsi/scsi_transport_fc.c                   |    4 +-
>  drivers/spi/amba-pl022.c                           |    2 +-
>  .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    4 +-
>  drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    2 +-
>  drivers/staging/bcm/Adapter.h                      |    2 +-
>  drivers/staging/bcm/CmHost.c                       |    6 ++--
>  drivers/staging/bcm/HostMIBSInterface.h            |    2 +-
>  drivers/staging/bcm/IPv6Protocol.c                 |    4 +-
>  drivers/staging/bcm/InterfaceIdleMode.c            |    4 +-
>  drivers/staging/bcm/InterfaceIsr.c                 |    2 +-
>  drivers/staging/bcm/InterfaceRx.c                  |   10 ++++----
>  drivers/staging/bcm/Misc.c                         |    2 +-
>  drivers/staging/bcm/PHSModule.c                    |    2 +-
>  drivers/staging/bcm/Qos.c                          |    2 +-
>  drivers/staging/bcm/cntrl_SignalingInterface.h     |    4 +-
>  drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    2 +-
>  drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
>  drivers/staging/comedi/comedi_fops.c               |    2 +-
>  .../comedi/drivers/addi-data/hwdrv_apci2032.c      |    8 +++---
>  drivers/staging/comedi/drivers/adv_pci1710.c       |    2 +-
>  drivers/staging/comedi/drivers/cb_pcidas.c         |    2 +-
>  drivers/staging/comedi/drivers/comedi_test.c       |    2 +-
>  drivers/staging/comedi/drivers/me4000.c            |    4 +-
>  drivers/staging/comedi/drivers/ni_at_a2150.c       |    4 +-
>  drivers/staging/comedi/drivers/ni_labpc.c          |    6 ++--
>  drivers/staging/comedi/drivers/s626.c              |   12 ++++----
>  drivers/staging/comedi/drivers/unioxx5.c           |    4 +-
>  drivers/staging/crystalhd/crystalhd_hw.c           |    2 +-
>  drivers/staging/dt3155v4l/dt3155v4l.c              |    6 ++--
>  drivers/staging/easycap/easycap_low.c              |    2 +-
>  drivers/staging/et131x/et1310_rx.c                 |    2 +-
>  drivers/staging/et131x/et131x_isr.c                |    2 +-
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 +-
>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    4 +-
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    2 +-
>  drivers/staging/iio/Documentation/iio_utils.h      |    2 +-
>  drivers/staging/iio/accel/adis16201.h              |    2 +-
>  drivers/staging/iio/accel/adis16203.h              |    2 +-
>  drivers/staging/iio/accel/adis16204.h              |    2 +-
>  drivers/staging/iio/accel/adis16209.h              |    2 +-
>  drivers/staging/iio/accel/adis16220.h              |    2 +-
>  drivers/staging/iio/accel/adis16240.h              |    2 +-
>  drivers/staging/iio/accel/lis3l02dq.h              |   26 ++++++++++----------
>  drivers/staging/iio/accel/lis3l02dq_core.c         |    2 +-
>  drivers/staging/iio/accel/lis3l02dq_ring.c         |    4 +-
>  drivers/staging/iio/accel/sca3000.h                |    2 +-
>  drivers/staging/iio/adc/max1363_core.c             |    2 +-
>  drivers/staging/iio/chrdev.h                       |    2 +-
>  drivers/staging/iio/gyro/adis16060.h               |    2 +-
>  drivers/staging/iio/gyro/adis16080.h               |    2 +-
>  drivers/staging/iio/gyro/adis16130.h               |    2 +-
>  drivers/staging/iio/gyro/adis16251.h               |    2 +-
>  drivers/staging/iio/gyro/adis16260.h               |    2 +-
>  drivers/staging/iio/iio.h                          |    2 +-
>  drivers/staging/iio/imu/adis16300.h                |    2 +-
>  drivers/staging/iio/imu/adis16350.h                |    2 +-
>  drivers/staging/iio/imu/adis16400.h                |    2 +-
>  drivers/staging/iio/meter/ade7753.h                |    2 +-
>  drivers/staging/iio/meter/ade7754.h                |    2 +-
>  drivers/staging/iio/meter/ade7758.h                |    2 +-
>  drivers/staging/iio/meter/ade7759.h                |    2 +-
>  drivers/staging/iio/meter/ade7854.h                |    2 +-
>  .../staging/intel_sst/intel_sst_app_interface.c    |   14 +++++-----
>  drivers/staging/intel_sst/intel_sst_dsp.c          |    2 +-
>  drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    2 +-
>  drivers/staging/lirc/lirc_ene0100.h                |    2 +-
>  drivers/staging/octeon/cvmx-helper.c               |    2 +-
>  drivers/staging/olpc_dcon/olpc_dcon_xo_1.c         |    2 +-
>  drivers/staging/quatech_usb2/quatech_usb2.c        |    8 +++---
>  drivers/staging/rt2860/common/action.c             |    2 +-
>  drivers/staging/rt2860/common/ba_action.c          |    4 +-
>  drivers/staging/rt2860/common/cmm_data_usb.c       |    2 +-
>  drivers/staging/rt2860/sta/connect.c               |    2 +-
>  drivers/staging/sbe-2t3e3/io.c                     |    4 +-
>  drivers/staging/sep/sep_driver.c                   |    2 +-
>  drivers/staging/spectra/flash.c                    |    2 +-
>  drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      |    2 +-
>  drivers/staging/tidspbridge/hw/hw_mmu.c            |    6 ++--
>  drivers/staging/usbvideo/usbvideo.c                |    2 +-
>  drivers/staging/vme/bridges/vme_tsi148.h           |    8 +++---
>  drivers/staging/vt6655/device_main.c               |    2 +-
>  drivers/staging/vt6655/tether.h                    |    4 +-
>  drivers/staging/vt6656/baseband.c                  |    2 +-
>  .../westbridge/astoria/api/src/cyaslowlevel.c      |    2 +-
>  .../staging/westbridge/astoria/api/src/cyasmisc.c  |    4 +-
>  .../westbridge/astoria/block/cyasblkdev_block.c    |    2 +-
>  .../westbridge/astoria/block/cyasblkdev_queue.c    |    2 +-
>  drivers/staging/wlags49_h2/hcf.c                   |    2 +-
>  drivers/staging/wlags49_h2/mdd.h                   |    2 +-
>  drivers/staging/wlan-ng/p80211req.c                |    2 +-
>  drivers/target/target_core_pr.c                    |    4 +-
>  drivers/target/target_core_transport.c             |    2 +-
>  drivers/telephony/ixj.c                            |    2 +-
>  drivers/tty/hvc/hvc_iucv.c                         |    4 +-
>  drivers/tty/serial/8250.c                          |    2 +-
>  drivers/tty/serial/bfin_sport_uart.c               |    2 +-
>  drivers/tty/serial/icom.c                          |    2 +-
>  drivers/tty/serial/jsm/jsm.h                       |    2 +-
>  drivers/tty/serial/max3107.c                       |    2 +-
>  drivers/tty/serial/mrst_max3110.c                  |    2 +-
>  drivers/tty/serial/sn_console.c                    |    2 +-
>  drivers/tty/serial/ucc_uart.c                      |    2 +-
>  drivers/usb/atm/ueagle-atm.c                       |    2 +-
>  drivers/usb/c67x00/c67x00-sched.c                  |    2 +-
>  drivers/usb/class/cdc-acm.h                        |    2 +-
>  drivers/usb/class/usbtmc.c                         |    2 +-
>  drivers/usb/gadget/amd5536udc.c                    |   10 ++++----
>  drivers/usb/gadget/fsl_qe_udc.h                    |    6 ++--
>  drivers/usb/gadget/fsl_udc_core.c                  |    4 +-
>  drivers/usb/gadget/langwell_udc.c                  |    4 +-
>  drivers/usb/gadget/mv_udc_core.c                   |    4 +-
>  drivers/usb/gadget/pch_udc.c                       |    2 +-
>  drivers/usb/gadget/s3c-hsotg.c                     |    4 +-
>  drivers/usb/host/fhci-tds.c                        |    6 ++--
>  drivers/usb/host/fhci.h                            |    2 +-
>  drivers/usb/host/oxu210hp-hcd.c                    |    4 +-
>  drivers/usb/host/whci/whcd.h                       |    2 +-
>  drivers/usb/musb/musb_gadget.c                     |    2 +-
>  drivers/uwb/drp.c                                  |    4 +-
>  drivers/uwb/reset.c                                |    2 +-
>  drivers/video/aty/mach64_cursor.c                  |    2 +-
>  drivers/video/da8xx-fb.c                           |    2 +-
>  drivers/video/fbsysfs.c                            |    2 +-
>  drivers/watchdog/acquirewdt.c                      |    2 +-
>  drivers/watchdog/sch311x_wdt.c                     |    2 +-
>  drivers/watchdog/smsc37b787_wdt.c                  |    2 +-
>  drivers/watchdog/sp805_wdt.c                       |    2 +-
>  drivers/xen/events.c                               |    2 +-
>  fs/btrfs/super.c                                   |    2 +-
>  fs/ceph/caps.c                                     |    2 +-
>  fs/ecryptfs/inode.c                                |    2 +-
>  fs/ecryptfs/main.c                                 |    2 +-
>  fs/ext4/extents.c                                  |    2 +-
>  fs/ext4/inode.c                                    |    2 +-
>  fs/jffs2/readinode.c                               |    2 +-
>  fs/jfs/jfs_imap.c                                  |    8 +++---
>  fs/nfs/file.c                                      |    2 +-
>  fs/nfsd/nfs4state.c                                |    2 +-
>  fs/notify/inotify/inotify_fsnotify.c               |    2 +-
>  fs/notify/inotify/inotify_user.c                   |    2 +-
>  fs/ntfs/attrib.c                                   |    2 +-
>  fs/ntfs/inode.c                                    |    2 +-
>  fs/ntfs/logfile.c                                  |    2 +-
>  fs/ntfs/logfile.h                                  |    2 +-
>  fs/ntfs/mft.c                                      |    4 +-
>  fs/ntfs/super.c                                    |   14 +++++-----
>  fs/ocfs2/cluster/quorum.c                          |    2 +-
>  fs/ocfs2/namei.c                                   |    2 +-
>  fs/ocfs2/stackglue.h                               |    2 +-
>  fs/reiserfs/xattr.c                                |    2 +-
>  fs/udf/inode.c                                     |    2 +-
>  fs/xfs/linux-2.6/xfs_file.c                        |    2 +-
>  fs/xfs/quota/xfs_qm_bhv.c                          |    2 +-
>  fs/xfs/xfs_log_recover.c                           |    4 +-
>  fs/xfs/xfs_vnodeops.c                              |    2 +-
>  include/drm/ttm/ttm_bo_driver.h                    |    4 +-
>  include/linux/atmlec.h                             |    2 +-
>  include/linux/can/error.h                          |    2 +-
>  include/linux/cgroup.h                             |    2 +-
>  include/linux/fb.h                                 |    4 +-
>  include/linux/interrupt.h                          |    2 +-
>  include/linux/mmc/dw_mmc.h                         |    2 +-
>  include/linux/netfilter/nf_conntrack_proto_gre.h   |    2 +-
>  include/linux/pci_regs.h                           |    2 +-
>  include/linux/percpu.h                             |    2 +-
>  include/linux/pxa2xx_ssp.h                         |    2 +-
>  include/linux/spi/spidev.h                         |    2 +-
>  include/linux/sunrpc/svc.h                         |    2 +-
>  include/linux/tcp.h                                |    2 +-
>  include/linux/usb.h                                |    2 +-
>  include/linux/uwb.h                                |    4 +-
>  include/net/9p/client.h                            |    2 +-
>  include/scsi/libfc.h                               |    2 +-
>  include/scsi/libiscsi_tcp.h                        |    2 +-
>  include/scsi/osd_initiator.h                       |    2 +-
>  include/sound/cs46xx_dsp_task_types.h              |    2 +-
>  include/sound/cs8427.h                             |    2 +-
>  include/xen/interface/physdev.h                    |    4 +-
>  kernel/cgroup.c                                    |    2 +-
>  kernel/irq/chip.c                                  |    2 +-
>  kernel/latencytop.c                                |    2 +-
>  kernel/module.c                                    |    2 +-
>  kernel/padata.c                                    |    2 +-
>  kernel/power/main.c                                |    2 +-
>  kernel/time/jiffies.c                              |    2 +-
>  kernel/trace/trace_event_perf.c                    |    2 +-
>  kernel/user-return-notifier.c                      |    2 +-
>  lib/timerqueue.c                                   |    2 +-
>  mm/hugetlb.c                                       |    6 ++--
>  mm/kmemleak.c                                      |    6 ++--
>  mm/percpu.c                                        |    6 ++--
>  mm/slub.c                                          |    4 +-
>  net/9p/client.c                                    |    2 +-
>  net/ipv4/tcp.c                                     |    2 +-
>  net/ipv4/tcp_output.c                              |    2 +-
>  net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |    2 +-
>  net/irda/irlap_event.c                             |    2 +-
>  net/irda/irttp.c                                   |    2 +-
>  net/irda/timer.c                                   |    2 +-
>  net/mac80211/rc80211_pid.h                         |    2 +-
>  net/netfilter/ipvs/ip_vs_proto_sctp.c              |    8 +++---
>  net/netfilter/nf_conntrack_core.c                  |    2 +-
>  net/netfilter/nf_conntrack_sip.c                   |    2 +-
>  net/rds/ib_send.c                                  |    2 +-
>  net/rds/iw_cm.c                                    |    2 +-
>  net/rds/iw_send.c                                  |    2 +-
>  net/sctp/output.c                                  |    2 +-
>  net/sctp/sm_statefuns.c                            |    2 +-
>  net/sctp/ulpqueue.c                                |    2 +-
>  net/sunrpc/xprtsock.c                              |    4 +-
>  net/wireless/reg.c                                 |    2 +-
>  scripts/dtc/livetree.c                             |    2 +-
>  security/apparmor/procattr.c                       |    2 +-
>  security/smack/smack_lsm.c                         |    2 +-
>  sound/drivers/pcm-indirect2.c                      |    2 +-
>  sound/drivers/serial-u16550.c                      |    2 +-
>  sound/oss/swarm_cs4297a.c                          |    2 +-
>  sound/pci/asihpi/hpi.h                             |    2 +-
>  sound/pci/ctxfi/cthw20k1.c                         |    2 +-
>  sound/pci/ctxfi/cthw20k2.c                         |    2 +-
>  sound/pci/pcxhr/pcxhr_core.c                       |   12 ++++----
>  sound/pci/sis7019.c                                |    2 +-
>  sound/ppc/snd_ps3.c                                |    2 +-
>  sound/ppc/snd_ps3_reg.h                            |    8 +++---
>  sound/soc/atmel/atmel_ssc_dai.c                    |    2 +-
>  sound/soc/codecs/wm8962.c                          |    2 +-
>  sound/soc/omap/ams-delta.c                         |    2 +-
>  455 files changed, 661 insertions(+), 661 deletions(-)
> 
> diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
> index 8fe2a49..ebfe065 100644
> --- a/arch/x86/crypto/aesni-intel_asm.S
> +++ b/arch/x86/crypto/aesni-intel_asm.S
> @@ -1355,7 +1355,7 @@ _zero_cipher_left_decrypt:
>  	ENCRYPT_SINGLE_BLOCK  %xmm0, %xmm1    # E(K, Yn)
>  	sub $16, %r11
>  	add %r13, %r11
> -	movdqu (%arg3,%r11,1), %xmm1   # recieve the last <16 byte block
> +	movdqu (%arg3,%r11,1), %xmm1   # receive the last <16 byte block
>  	lea SHIFT_MASK+16(%rip), %r12
>  	sub %r13, %r12
>  # adjust the shuffle mask pointer to be able to shift 16-%r13 bytes
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index e60c38c..5bcfdff 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -63,7 +63,7 @@ void __cpuinit mxcsr_feature_mask_init(void)
>  static void __cpuinit init_thread_xstate(void)
>  {
>  	/*
> -	 * Note that xstate_size might be overwriten later during
> +	 * Note that xstate_size might be overwritten later during
>  	 * xsave_init().
>  	 */
>  
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index f98d3ea..5ceafe5 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -157,7 +157,7 @@ static void __cpuinit kvm_setup_secondary_clock(void)
>   * registered memory location. If the guest happens to shutdown, this memory
>   * won't be valid. In cases like kexec, in which you install a new kernel, this
>   * means a random memory location will be kept being written. So before any
> - * kind of shutdown from our side, we unregister the clock by writting anything
> + * kind of shutdown from our side, we unregister the clock by writing anything
>   * that does not have the 'enable' bit set in the msr
>   */
>  #ifdef CONFIG_KEXEC
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bcc0efc..e3a9e4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1028,7 +1028,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	/*
>  	 * Special case: close write to TSC within 5 seconds of
>  	 * another CPU is interpreted as an attempt to synchronize
> -	 * The 5 seconds is to accomodate host load / swapping as
> +	 * The 5 seconds is to accommodate host load / swapping as
>  	 * well as any reset of TSC during the boot process.
>  	 *
>  	 * In that case, for a reliable TSC, we can match TSC offsets,
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index b1805b7..bbce412 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -241,7 +241,7 @@ void __init pcibios_resource_survey(void)
>  	e820_reserve_resources_late();
>  	/*
>  	 * Insert the IO APIC resources after PCI initialization has
> -	 * occured to handle IO APICS that are mapped in on a BAR in
> +	 * occurred to handle IO APICS that are mapped in on a BAR in
>  	 * PCI space, but before trying to assign unassigned pci res.
>  	 */
>  	ioapic_insert_resources();
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index 079ae8c..bc28337 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -94,7 +94,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
>  		if (unlikely(!tx))
>  			async_tx_quiesce(&submit->depend_tx);
>  
> -		/* spin wait for the preceeding transactions to complete */
> +		/* spin wait for the preceding transactions to complete */
>  		while (unlikely(!tx)) {
>  			dma_async_issue_pending(chan);
>  			tx = dma->device_prep_dma_xor(chan, dma_dest,
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 3e606c3..31fed35 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -227,7 +227,7 @@ enum {
>  	/* em_ctl bits */
>  	EM_CTL_RST		= (1 << 9), /* Reset */
>  	EM_CTL_TM		= (1 << 8), /* Transmit Message */
> -	EM_CTL_MR		= (1 << 0), /* Message Recieved */
> +	EM_CTL_MR		= (1 << 0), /* Message Received */
>  	EM_CTL_ALHD		= (1 << 26), /* Activity LED */
>  	EM_CTL_XMT		= (1 << 25), /* Transmit Only */
>  	EM_CTL_SMB		= (1 << 24), /* Single Message Buffer */
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 6cb14ca..b4f3e5c 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -38,8 +38,8 @@
>   *  Hardware documentation available at http://developer.intel.com/
>   *
>   * Documentation
> - *	Publically available from Intel web site. Errata documentation
> - * is also publically available. As an aide to anyone hacking on this
> + *	Publicly available from Intel web site. Errata documentation
> + * is also publicly available. As an aide to anyone hacking on this
>   * driver the list of errata that are relevant is below, going back to
>   * PIIX4. Older device documentation is now a bit tricky to find.
>   *
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 600f635..ebe0c77 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -999,7 +999,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
>   *	@qc: Command that we are erroring out
>   *
>   *	Generate sense block for a failed ATA command @qc.  Descriptor
> - *	format is used to accomodate LBA48 block address.
> + *	format is used to accommodate LBA48 block address.
>   *
>   *	LOCKING:
>   *	None.
> diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
> index 620a07c..b0975a5 100644
> --- a/drivers/ata/pata_amd.c
> +++ b/drivers/ata/pata_amd.c
> @@ -11,7 +11,7 @@
>   *	Power management on ports
>   *
>   *
> - *  Documentation publically available.
> + *  Documentation publicly available.
>   */
>  
>  #include <linux/kernel.h>
> diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
> index 030952f..e3254fc 100644
> --- a/drivers/ata/pata_cs5520.c
> +++ b/drivers/ata/pata_cs5520.c
> @@ -29,7 +29,7 @@
>   * General Public License for more details.
>   *
>   * Documentation:
> - *	Not publically available.
> + *	Not publicly available.
>   */
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
> index 00eefbd..1f4e9af 100644
> --- a/drivers/ata/pata_sil680.c
> +++ b/drivers/ata/pata_sil680.c
> @@ -11,7 +11,7 @@
>   *
>   *  May be copied or modified under the terms of the GNU General Public License
>   *
> - *  Documentation publically available.
> + *  Documentation publicly available.
>   *
>   *	If you have strange problems with nVidia chipset systems please
>   *	see the SI support documentation and update your system BIOS
> diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
> index 0d1f89e..03b6d69 100644
> --- a/drivers/ata/pata_triflex.c
> +++ b/drivers/ata/pata_triflex.c
> @@ -30,7 +30,7 @@
>   * Loosely based on the piix & svwks drivers.
>   *
>   * Documentation:
> - *	Not publically available.
> + *	Not publicly available.
>   */
>  
>  #include <linux/kernel.h>
> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> index bf74a36..82693fa 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -2045,7 +2045,7 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
>  
>  	cw = &pp->crqb[in_index].ata_cmd[0];
>  
> -	/* Sadly, the CRQB cannot accomodate all registers--there are
> +	/* Sadly, the CRQB cannot accommodate all registers--there are
>  	 * only 11 bytes...so we must pick and choose required
>  	 * registers based on the command.  So, we drop feature and
>  	 * hob_feature for [RW] DMA commands, but they are needed for
> diff --git a/drivers/atm/idt77252.h b/drivers/atm/idt77252.h
> index f53a43a..3a82cc2 100644
> --- a/drivers/atm/idt77252.h
> +++ b/drivers/atm/idt77252.h
> @@ -766,7 +766,7 @@ struct idt77252_dev
>  #define SAR_RCTE_BUFFSTAT_MASK 0x00003000  /* buffer status                  */
>  #define SAR_RCTE_EFCI          0x00000800  /* EFCI Congestion flag           */
>  #define SAR_RCTE_CLP           0x00000400  /* Cell Loss Priority flag        */
> -#define SAR_RCTE_CRC           0x00000200  /* Recieved CRC Error             */
> +#define SAR_RCTE_CRC           0x00000200  /* Received CRC Error             */
>  #define SAR_RCTE_CELLCNT_MASK  0x000001FF  /* cell Count                     */
>  
>  #define SAR_RCTE_AAL0          0x00000000  /* AAL types for ALL field        */
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 9279272..eb0babc 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -2424,7 +2424,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
>  
>  	--h->num_luns;
>  
> -	/* if it was the last disk, find the new hightest lun */
> +	/* if it was the last disk, find the new highest lun */
>  	if (clear_all && recalculate_highest_lun) {
>  		int newhighest = -1;
>  		for (i = 0; i <= h->highest_lun; i++) {
> diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
> index 3803a03..3adee60 100644
> --- a/drivers/block/drbd/drbd_int.h
> +++ b/drivers/block/drbd/drbd_int.h
> @@ -1761,7 +1761,7 @@ static inline int _drbd_set_state(struct drbd_conf *mdev,
>  }
>  
>  /**
> - * drbd_request_state() - Reqest a state change
> + * drbd_request_state() - Request a state change
>   * @mdev:	DRBD device.
>   * @mask:	mask of state bits to change.
>   * @val:	value of new state bits.
> diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
> index b3bdb8a..43b3efc 100644
> --- a/drivers/block/ps3vram.c
> +++ b/drivers/block/ps3vram.c
> @@ -648,7 +648,7 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
>  		goto fail_free_priv;
>  	}
>  
> -	/* Put FIFO at begginning of XDR buffer */
> +	/* Put FIFO at beginning of XDR buffer */
>  	priv->fifo_base = (u32 *) (priv->xdr_buf + FIFO_OFFSET);
>  	priv->fifo_ptr = priv->fifo_base;
>  
> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> index 829161e..17c5408 100644
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -621,7 +621,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
>  		ace_dump_mem(ace->cf_id, 512);	/* Debug: Dump out disk ID */
>  
>  		if (ace->data_result) {
> -			/* Error occured, disable the disk */
> +			/* Error occurred, disable the disk */
>  			ace->media_change = 1;
>  			set_capacity(ace->gd, 0);
>  			dev_err(ace->dev, "error fetching CF id (%i)\n",
> diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
> index dcc2a6e..551052d 100644
> --- a/drivers/bluetooth/btmrvl_sdio.c
> +++ b/drivers/bluetooth/btmrvl_sdio.c
> @@ -966,7 +966,7 @@ static void btmrvl_sdio_remove(struct sdio_func *func)
>  							MODULE_SHUTDOWN_REQ);
>  				btmrvl_sdio_disable_host_int(card);
>  			}
> -			BT_DBG("unregester dev");
> +			BT_DBG("unregister dev");
>  			btmrvl_sdio_unregister_dev(card);
>  			btmrvl_remove_card(card->priv);
>  			kfree(card);
> diff --git a/drivers/char/mxser.h b/drivers/char/mxser.h
> index 41878a6..0bf7943 100644
> --- a/drivers/char/mxser.h
> +++ b/drivers/char/mxser.h
> @@ -113,7 +113,7 @@
>  #define MOXA_MUST_IIR_RTO		0x0C
>  #define MOXA_MUST_IIR_LSR		0x06
>  
> -/* recieved Xon/Xoff or specical interrupt pending */
> +/* received Xon/Xoff or specical interrupt pending */
>  #define MOXA_MUST_IIR_XSC		0x10
>  
>  /* RTS/CTS change state interrupt pending */
> diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
> index 798f46a..894b9fe 100644
> --- a/drivers/dma/intel_mid_dma.c
> +++ b/drivers/dma/intel_mid_dma.c
> @@ -911,8 +911,8 @@ static int intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
>  
>  /**
>   * midc_handle_error -	Handle DMA txn error
> - * @mid: controller where error occured
> - * @midc: chan where error occured
> + * @mid: controller where error occurred
> + * @midc: chan where error occurred
>   *
>   * Scan the descriptor for error
>   */
> diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
> index 709fecb..aea5ee8 100644
> --- a/drivers/dma/intel_mid_dma_regs.h
> +++ b/drivers/dma/intel_mid_dma_regs.h
> @@ -174,8 +174,8 @@ union intel_mid_dma_cfg_hi {
>   * @dma: dma device struture pointer
>   * @busy: bool representing if ch is busy (active txn) or not
>   * @in_use: bool representing if ch is in use or not
> - * @raw_tfr: raw trf interrupt recieved
> - * @raw_block: raw block interrupt recieved
> + * @raw_tfr: raw trf interrupt received
> + * @raw_block: raw block interrupt received
>   */
>  struct intel_mid_dma_chan {
>  	struct dma_chan		chan;
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index 3d96534..71e6eac 100644
> --- a/drivers/edac/edac_core.h
> +++ b/drivers/edac/edac_core.h
> @@ -823,7 +823,7 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
>   * There are a limited number of error logging registers that can
>   * be exausted.  When all registers are exhausted and an additional
>   * error occurs then an error overflow register records that an
> - * error occured and the type of error, but doesn't have any
> + * error occurred and the type of error, but doesn't have any
>   * further information.  The ce/ue versions make for cleaner
>   * reporting logic and function interface - reduces conditional
>   * statement clutter and extra function arguments.
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 1f4242b..5cbd171 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -212,7 +212,7 @@ intel_dp_mode_valid(struct drm_connector *connector,
>  			return MODE_PANEL;
>  	}
>  
> -	/* only refuse the mode on non eDP since we have seen some wierd eDP panels
> +	/* only refuse the mode on non eDP since we have seen some weird eDP panels
>  	   which are outside spec tolerances but somehow work by magic */
>  	if (!is_edp(intel_dp) &&
>  	    (intel_dp_link_required(connector->dev, intel_dp, mode->clock)
> diff --git a/drivers/gpu/drm/nouveau/nv40_graph.c b/drivers/gpu/drm/nouveau/nv40_graph.c
> index 8870d72..de12edb 100644
> --- a/drivers/gpu/drm/nouveau/nv40_graph.c
> +++ b/drivers/gpu/drm/nouveau/nv40_graph.c
> @@ -181,7 +181,7 @@ nv40_graph_load_context(struct nouveau_channel *chan)
>  		  NV40_PGRAPH_CTXCTL_CUR_LOADED);
>  	/* 0x32E0 records the instance address of the active FIFO's PGRAPH
>  	 * context.  If at any time this doesn't match 0x40032C, you will
> -	 * recieve PGRAPH_INTR_CONTEXT_SWITCH
> +	 * receive PGRAPH_INTR_CONTEXT_SWITCH
>  	 */
>  	nv_wr32(dev, NV40_PFIFO_GRCTX_INSTANCE, inst);
>  	return 0;
> diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
> index 04b269d..4ff407a4 100644
> --- a/drivers/gpu/drm/radeon/atombios.h
> +++ b/drivers/gpu/drm/radeon/atombios.h
> @@ -4995,7 +4995,7 @@ typedef struct _ENABLE_HARDWARE_ICON_CURSOR_PS_ALLOCATION
>  
>  typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS
>  {
> -  USHORT usHight;                     // Image Hight
> +  USHORT usHight;                     // Image Height
>    USHORT usWidth;                     // Image Width
>    UCHAR  ucSurface;                   // Surface 1 or 2	
>    UCHAR  ucPadding[3];
> @@ -5003,7 +5003,7 @@ typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS
>  
>  typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS_V1_2
>  {
> -  USHORT usHight;                     // Image Hight
> +  USHORT usHight;                     // Image Height
>    USHORT usWidth;                     // Image Width
>    UCHAR  ucSurface;                   // Surface 1 or 2
>    UCHAR  ucEnable;                    // ATOM_ENABLE or ATOM_DISABLE
> @@ -5012,7 +5012,7 @@ typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS_V1_2
>  
>  typedef struct _ENABLE_GRAPH_SURFACE_PARAMETERS_V1_3
>  {
> -  USHORT usHight;                     // Image Hight
> +  USHORT usHight;                     // Image Height
>    USHORT usWidth;                     // Image Width
>    UCHAR  ucSurface;                   // Surface 1 or 2
>    UCHAR  ucEnable;                    // ATOM_ENABLE or ATOM_DISABLE
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index 56c48b6..f07b8fe 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -1364,7 +1364,7 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
>  {
>  #if DRM_DEBUG_CODE
>  	if (rdev->cp.count_dw <= 0) {
> -		DRM_ERROR("radeon: writting more dword to ring than expected !\n");
> +		DRM_ERROR("radeon: writing more dword to ring than expected !\n");
>  	}
>  #endif
>  	rdev->cp.ring[rdev->cp.wptr++] = v;
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
> index bfab60c..16ac5a5 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
> @@ -371,7 +371,7 @@ static int vmw_fb_create_bo(struct vmw_private *vmw_priv,
>  
>  	ne_placement.lpfn = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  
> -	/* interuptable? */
> +	/* interruptable? */
>  	ret = ttm_write_lock(&vmw_priv->fbdev_master.lock, false);
>  	if (unlikely(ret != 0))
>  		return ret;
> @@ -613,7 +613,7 @@ int vmw_dmabuf_to_start_of_vram(struct vmw_private *vmw_priv,
>  
>  	ne_placement.lpfn = bo->num_pages;
>  
> -	/* interuptable? */
> +	/* interruptable? */
>  	ret = ttm_write_lock(&vmw_priv->active_master->lock, false);
>  	if (unlikely(ret != 0))
>  		return ret;
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> index cceeb42..9ea870d 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> @@ -245,7 +245,7 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
>  		/* TODO handle none page aligned offsets */
>  		/* TODO handle partial uploads and pitch != 256 */
>  		/* TODO handle more then one copy (size != 64) */
> -		DRM_ERROR("lazy programer, cant handle wierd stuff\n");
> +		DRM_ERROR("lazy programer, cant handle weird stuff\n");
>  		return;
>  	}
>  
> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
> index ace2b16..1f68731 100644
> --- a/drivers/gpu/vga/vgaarb.c
> +++ b/drivers/gpu/vga/vgaarb.c
> @@ -151,7 +151,7 @@ static inline void vga_irq_set_state(struct vga_device *vgadev, bool state)
>  static void vga_check_first_use(void)
>  {
>  	/* we should inform all GPUs in the system that
> -	 * VGA arb has occured and to try and disable resources
> +	 * VGA arb has occurred and to try and disable resources
>  	 * if they can */
>  	if (!vga_arbiter_used) {
>  		vga_arbiter_used = true;
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index d678cf3..f6dbe56 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -306,7 +306,7 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
>  	case HID_GLOBAL_ITEM_TAG_PUSH:
>  
>  		if (parser->global_stack_ptr == HID_GLOBAL_STACK_SIZE) {
> -			dbg_hid("global enviroment stack overflow\n");
> +			dbg_hid("global environment stack overflow\n");
>  			return -1;
>  		}
>  
> @@ -317,7 +317,7 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
>  	case HID_GLOBAL_ITEM_TAG_POP:
>  
>  		if (!parser->global_stack_ptr) {
> -			dbg_hid("global enviroment stack underflow\n");
> +			dbg_hid("global environment stack underflow\n");
>  			return -1;
>  		}
>  
> diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
> index 64abb5b..4109a02 100644
> --- a/drivers/hid/hid-roccat-kone.h
> +++ b/drivers/hid/hid-roccat-kone.h
> @@ -166,7 +166,7 @@ enum kone_mouse_events {
>  	/* osd events are thought to be display on screen */
>  	kone_mouse_event_osd_dpi = 0xa0,
>  	kone_mouse_event_osd_profile = 0xb0,
> -	/* TODO clarify meaning and occurence of kone_mouse_event_calibration */
> +	/* TODO clarify meaning and occurrence of kone_mouse_event_calibration */
>  	kone_mouse_event_calibration = 0xc0,
>  	kone_mouse_event_call_overlong_macro = 0xe0,
>  	/* switch events notify if user changed values with mousebutton click */
> diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
> index 3d21fa2..286e9085 100644
> --- a/drivers/hwmon/hp_accel.c
> +++ b/drivers/hwmon/hp_accel.c
> @@ -131,7 +131,7 @@ int lis3lv02d_acpi_read(struct lis3lv02d *lis3, int reg, u8 *ret)
>  int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
>  {
>  	struct acpi_device *dev = lis3->bus_priv;
> -	unsigned long long ret; /* Not used when writting */
> +	unsigned long long ret; /* Not used when writing */
>  	union acpi_object in_obj[2];
>  	struct acpi_object_list args = { 2, in_obj };
>  
> diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
> index a610e78..fe92360 100644
> --- a/drivers/hwmon/sht15.c
> +++ b/drivers/hwmon/sht15.c
> @@ -251,7 +251,7 @@ static inline int sht15_update_single_val(struct sht15_data *data,
>  	enable_irq(gpio_to_irq(data->pdata->gpio_data));
>  	if (gpio_get_value(data->pdata->gpio_data) == 0) {
>  		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
> -		/* Only relevant if the interrupt hasn't occured. */
> +		/* Only relevant if the interrupt hasn't occurred. */
>  		if (!atomic_read(&data->interrupt_handled))
>  			schedule_work(&data->read_work);
>  	}
> @@ -452,7 +452,7 @@ static void sht15_bh_read_data(struct work_struct *work_s)
>  		*/
>  		atomic_set(&data->interrupt_handled, 0);
>  		enable_irq(gpio_to_irq(data->pdata->gpio_data));
> -		/* If still not occured or another handler has been scheduled */
> +		/* If still not occurred or another handler has been scheduled */
>  		if (gpio_get_value(data->pdata->gpio_data)
>  		    || atomic_read(&data->interrupt_handled))
>  			return;
> diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
> index 400a88b..17cf1ab 100644
> --- a/drivers/hwmon/w83791d.c
> +++ b/drivers/hwmon/w83791d.c
> @@ -556,7 +556,7 @@ static ssize_t show_fan_div(struct device *dev, struct device_attribute *attr,
>  
>  /* Note: we save and restore the fan minimum here, because its value is
>     determined in part by the fan divisor.  This follows the principle of
> -   least suprise; the user doesn't expect the fan minimum to change just
> +   least surprise; the user doesn't expect the fan minimum to change just
>     because the divisor changed. */
>  static ssize_t store_fan_div(struct device *dev, struct device_attribute *attr,
>  				const char *buf, size_t count)
> diff --git a/drivers/i2c/algos/i2c-algo-pcf.c b/drivers/i2c/algos/i2c-algo-pcf.c
> index 5eebf56..6913910 100644
> --- a/drivers/i2c/algos/i2c-algo-pcf.c
> +++ b/drivers/i2c/algos/i2c-algo-pcf.c
> @@ -22,7 +22,7 @@
>   * Frodo Looijaard <frodol@dds.nl>, and also from Martin Bailey
>   * <mbailey@littlefeet-inc.com>
>   *
> - * Partially rewriten by Oleg I. Vdovikin <vdovikin@jscc.ru> to handle multiple
> + * Partially rewritten by Oleg I. Vdovikin <vdovikin@jscc.ru> to handle multiple
>   * messages, proper stop/repstart signaling during receive, added detect code
>   */
>  
> diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
> index f2de3be..75d1d9c 100644
> --- a/drivers/i2c/busses/i2c-cpm.c
> +++ b/drivers/i2c/busses/i2c-cpm.c
> @@ -348,7 +348,7 @@ static int cpm_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
>  		tptr++;
>  	}
>  	/* Start transfer now */
> -	/* Enable RX/TX/Error interupts */
> +	/* Enable RX/TX/Error interrupts */
>  	out_8(&i2c_reg->i2cmr, I2CER_TXE | I2CER_TXB | I2CER_RXB);
>  	out_8(&i2c_reg->i2cer, 0xff);	/* Clear interrupt status */
>  	/* Chip bug, set enable here */
> diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
> index e5b1a3b..00b44db 100644
> --- a/drivers/i2c/busses/i2c-elektor.c
> +++ b/drivers/i2c/busses/i2c-elektor.c
> @@ -22,7 +22,7 @@
>  /* With some changes from Ky??sti M??lkki <kmalkki@cc.hut.fi> and even
>     Frodo Looijaard <frodol@dds.nl> */
>  
> -/* Partialy rewriten by Oleg I. Vdovikin for mmapped support of
> +/* Partialy rewritten by Oleg I. Vdovikin for mmapped support of
>     for Alpha Processor Inc. UP-2000(+) boards */
>  
>  #include <linux/kernel.h>
> @@ -56,7 +56,7 @@ static int mmapped;
>  /* vdovikin: removed static struct i2c_pcf_isa gpi; code -
>    this module in real supports only one device, due to missing arguments
>    in some functions, called from the algo-pcf module. Sometimes it's
> -  need to be rewriten - but for now just remove this for simpler reading */
> +  need to be rewritten - but for now just remove this for simpler reading */
>  
>  static wait_queue_head_t pcf_wait;
>  static int pcf_pending;
> diff --git a/drivers/i2c/busses/i2c-intel-mid.c b/drivers/i2c/busses/i2c-intel-mid.c
> index c714927..46c6341 100644
> --- a/drivers/i2c/busses/i2c-intel-mid.c
> +++ b/drivers/i2c/busses/i2c-intel-mid.c
> @@ -170,8 +170,8 @@ struct intel_mid_i2c_private {
>  /* Raw Interrupt Status Register */
>  #define IC_RAW_INTR_STAT	0x34		/* Read Only */
>  #define GEN_CALL		(1 << 11)	/* General call */
> -#define START_DET		(1 << 10)	/* (RE)START occured */
> -#define STOP_DET		(1 << 9)	/* STOP occured */
> +#define START_DET		(1 << 10)	/* (RE)START occurred */
> +#define STOP_DET		(1 << 9)	/* STOP occurred */
>  #define ACTIVITY		(1 << 8)	/* Bus busy */
>  #define RX_DONE			(1 << 7)	/* Not used in Master mode */
>  #define	TX_ABRT			(1 << 6)	/* Transmit Abort */
> @@ -353,7 +353,7 @@ static int intel_mid_i2c_disable(struct i2c_adapter *adap)
>  	readl(i2c->base + IC_CLR_RX_DONE);
>  	readl(i2c->base + IC_CLR_GEN_CALL);
>  
> -	/* Disable all interupts */
> +	/* Disable all interrupts */
>  	writel(0x0000, i2c->base + IC_INTR_MASK);
>  
>  	return err;
> @@ -455,7 +455,7 @@ static inline bool intel_mid_i2c_address_neq(const struct i2c_msg *p1,
>   *
>   * By reading register IC_TX_ABRT_SOURCE, various transfer errors can be
>   * distingushed. At present, no circumstances have been found out that
> - * multiple errors would be occured simutaneously, so we simply use the
> + * multiple errors would be occurred simutaneously, so we simply use the
>   * register value directly.
>   *
>   * At last the error bits are cleared. (Note clear ABRT_SBYTE_NORSTRT bit need
> @@ -469,7 +469,7 @@ static void intel_mid_i2c_abort(struct intel_mid_i2c_private *i2c)
>  
>  	/* Single transfer error check:
>  	 * According to databook, TX/RX FIFOs would be flushed when
> -	 * the abort interrupt occured.
> +	 * the abort interrupt occurred.
>  	 */
>  	if (abort & ABRT_MASTER_DIS)
>  		dev_err(&adap->dev,
> @@ -569,7 +569,7 @@ static int xfer_read(struct i2c_adapter *adap, unsigned char *buf, int length)
>   * Return Values:
>   * 0	if the read transfer succeeds
>   * -ETIMEDOUT	if we cannot read the "raw" interrupt register
> - * -EINVAL	if a transfer abort occured
> + * -EINVAL	if a transfer abort occurred
>   *
>   * For every byte, a "WRITE" command will be loaded into IC_DATA_CMD prior to
>   * data transfer. The actual "write" operation will be performed when the
> diff --git a/drivers/ide/piix.c b/drivers/ide/piix.c
> index 1bdca49..b59d04c 100644
> --- a/drivers/ide/piix.c
> +++ b/drivers/ide/piix.c
> @@ -8,8 +8,8 @@
>   *
>   * Documentation:
>   *
> - *	Publically available from Intel web site. Errata documentation
> - * is also publically available. As an aide to anyone hacking on this
> + *	Publicly available from Intel web site. Errata documentation
> + * is also publicly available. As an aide to anyone hacking on this
>   * driver the list of errata that are relevant is below.going back to
>   * PIIX4. Older device documentation is now a bit tricky to find.
>   *
> diff --git a/drivers/ide/triflex.c b/drivers/ide/triflex.c
> index 7953447..e53a1b7 100644
> --- a/drivers/ide/triflex.c
> +++ b/drivers/ide/triflex.c
> @@ -22,7 +22,7 @@
>   * Loosely based on the piix & svwks drivers.
>   *
>   * Documentation:
> - *	Not publically available.
> + *	Not publicly available.
>   */
>  
>  #include <linux/types.h>
> diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
> index d2a0997..f46f49c 100644
> --- a/drivers/ide/via82cxxx.c
> +++ b/drivers/ide/via82cxxx.c
> @@ -14,7 +14,7 @@
>   *	Andre Hedrick
>   *
>   * Documentation:
> - *	Obsolete device documentation publically available from via.com.tw
> + *	Obsolete device documentation publicly available from via.com.tw
>   *	Current device documentation available under NDA only
>   */
>  
> diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
> index c0a03ac..6ee41b4 100644
> --- a/drivers/infiniband/hw/ipath/ipath_intr.c
> +++ b/drivers/infiniband/hw/ipath/ipath_intr.c
> @@ -890,7 +890,7 @@ void ipath_clear_freeze(struct ipath_devdata *dd)
>  	/* disable error interrupts, to avoid confusion */
>  	ipath_write_kreg(dd, dd->ipath_kregs->kr_errormask, 0ULL);
>  
> -	/* also disable interrupts; errormask is sometimes overwriten */
> +	/* also disable interrupts; errormask is sometimes overwritten */
>  	ipath_write_kreg(dd, dd->ipath_kregs->kr_intmask, 0ULL);
>  
>  	ipath_cancel_sends(dd, 1);
> diff --git a/drivers/infiniband/hw/ipath/ipath_ruc.c b/drivers/infiniband/hw/ipath/ipath_ruc.c
> index 1f95bba..edfe687 100644
> --- a/drivers/infiniband/hw/ipath/ipath_ruc.c
> +++ b/drivers/infiniband/hw/ipath/ipath_ruc.c
> @@ -289,7 +289,7 @@ again:
>  		goto clr_busy;
>  	wqe = get_swqe_ptr(sqp, sqp->s_last);
>  
> -	/* Return if it is not OK to start a new work reqeust. */
> +	/* Return if it is not OK to start a new work request. */
>  	if (!(ib_ipath_state_ops[sqp->state] & IPATH_PROCESS_NEXT_SEND_OK)) {
>  		if (!(ib_ipath_state_ops[sqp->state] & IPATH_FLUSH_SEND))
>  			goto clr_busy;
> diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
> index 774dea8..f605b38 100644
> --- a/drivers/infiniband/hw/qib/qib_iba6120.c
> +++ b/drivers/infiniband/hw/qib/qib_iba6120.c
> @@ -705,7 +705,7 @@ static void qib_6120_clear_freeze(struct qib_devdata *dd)
>  	/* disable error interrupts, to avoid confusion */
>  	qib_write_kreg(dd, kr_errmask, 0ULL);
>  
> -	/* also disable interrupts; errormask is sometimes overwriten */
> +	/* also disable interrupts; errormask is sometimes overwritten */
>  	qib_6120_set_intr_state(dd, 0);
>  
>  	qib_cancel_sends(dd->pport);
> diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
> index de799f1..c9bb402 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7220.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7220.c
> @@ -1256,7 +1256,7 @@ static void qib_7220_clear_freeze(struct qib_devdata *dd)
>  	/* disable error interrupts, to avoid confusion */
>  	qib_write_kreg(dd, kr_errmask, 0ULL);
>  
> -	/* also disable interrupts; errormask is sometimes overwriten */
> +	/* also disable interrupts; errormask is sometimes overwritten */
>  	qib_7220_set_intr_state(dd, 0);
>  
>  	qib_cancel_sends(dd->pport);
> diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
> index b01809a..d0950f7 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7322.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7322.c
> @@ -1950,7 +1950,7 @@ static void qib_7322_clear_freeze(struct qib_devdata *dd)
>  			qib_write_kreg_port(dd->pport + pidx, krp_errmask,
>  					    0ULL);
>  
> -	/* also disable interrupts; errormask is sometimes overwriten */
> +	/* also disable interrupts; errormask is sometimes overwritten */
>  	qib_7322_set_intr_state(dd, 0);
>  
>  	/* clear the freeze, and be sure chip saw it */
> diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
> index 8fd19a4..e963966 100644
> --- a/drivers/infiniband/hw/qib/qib_keys.c
> +++ b/drivers/infiniband/hw/qib/qib_keys.c
> @@ -307,7 +307,7 @@ bail:
>  }
>  
>  /*
> - * Initialize the memory region specified by the work reqeust.
> + * Initialize the memory region specified by the work request.
>   */
>  int qib_fast_reg_mr(struct qib_qp *qp, struct ib_send_wr *wr)
>  {
> diff --git a/drivers/infiniband/hw/qib/qib_mad.h b/drivers/infiniband/hw/qib/qib_mad.h
> index 147aff9..7840ab5 100644
> --- a/drivers/infiniband/hw/qib/qib_mad.h
> +++ b/drivers/infiniband/hw/qib/qib_mad.h
> @@ -73,7 +73,7 @@ struct ib_mad_notice_attr {
>  
>  		struct {
>  			__be16	reserved;
> -			__be16	lid;		/* LID where change occured */
> +			__be16	lid;		/* LID where change occurred */
>  			u8	reserved2;
>  			u8	local_changes;	/* low bit - local changes */
>  			__be32	new_cap_mask;	/* new capability mask */
> diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
> index eb78d93..d1823b9 100644
> --- a/drivers/infiniband/hw/qib/qib_ruc.c
> +++ b/drivers/infiniband/hw/qib/qib_ruc.c
> @@ -381,7 +381,7 @@ again:
>  		goto clr_busy;
>  	wqe = get_swqe_ptr(sqp, sqp->s_last);
>  
> -	/* Return if it is not OK to start a new work reqeust. */
> +	/* Return if it is not OK to start a new work request. */
>  	if (!(ib_qib_state_ops[sqp->state] & QIB_PROCESS_NEXT_SEND_OK)) {
>  		if (!(ib_qib_state_ops[sqp->state] & QIB_FLUSH_SEND))
>  			goto clr_busy;
> diff --git a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keyspan_remote.c
> index a93c525..fc62256 100644
> --- a/drivers/input/misc/keyspan_remote.c
> +++ b/drivers/input/misc/keyspan_remote.c
> @@ -312,7 +312,7 @@ static void keyspan_check_data(struct usb_keyspan *remote)
>  			remote->data.tester = remote->data.tester >> 5;
>  			remote->data.bits_left -= 5;
>  		} else {
> -			err("Bad message recieved, no stop bit found.\n");
> +			err("Bad message received, no stop bit found.\n");
>  		}
>  
>  		dev_dbg(&remote->udev->dev,
> diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
> index ee82851..5d1666a 100644
> --- a/drivers/input/mouse/bcm5974.c
> +++ b/drivers/input/mouse/bcm5974.c
> @@ -619,7 +619,7 @@ exit:
>   * device, resulting in trackpad malfunction under certain
>   * circumstances. To get around this problem, there is at least one
>   * example that utilizes the USB_QUIRK_RESET_RESUME quirk in order to
> - * recieve a reset_resume request rather than the normal resume.
> + * receive a reset_resume request rather than the normal resume.
>   * Since the implementation of reset_resume is equal to mode switch
>   * plus start_traffic, it seems easier to always do the switch when
>   * starting traffic on the device.
> diff --git a/drivers/input/mouse/logips2pp.c b/drivers/input/mouse/logips2pp.c
> index c9983ae..b8074bd 100644
> --- a/drivers/input/mouse/logips2pp.c
> +++ b/drivers/input/mouse/logips2pp.c
> @@ -215,7 +215,7 @@ static const struct ps2pp_info *get_model_info(unsigned char model)
>  		{ 61,	PS2PP_KIND_MX,					/* MX700 */
>  				PS2PP_WHEEL | PS2PP_SIDE_BTN | PS2PP_TASK_BTN |
>  				PS2PP_EXTRA_BTN | PS2PP_NAV_BTN },
> -		{ 66,	PS2PP_KIND_MX,					/* MX3100 reciver */
> +		{ 66,	PS2PP_KIND_MX,					/* MX3100 receiver */
>  				PS2PP_WHEEL | PS2PP_SIDE_BTN | PS2PP_TASK_BTN |
>  				PS2PP_EXTRA_BTN | PS2PP_NAV_BTN | PS2PP_HWHEEL },
>  		{ 72,	PS2PP_KIND_TRACKMAN,	0 },			/* T-CH11: TrackMan Marble */
> diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
> index bf2c0c8..eb9a3cf 100644
> --- a/drivers/input/mouse/vsxxxaa.c
> +++ b/drivers/input/mouse/vsxxxaa.c
> @@ -334,7 +334,7 @@ static void vsxxxaa_handle_POR_packet(struct vsxxxaa *mouse)
>  	 * M: manufacturer location code
>  	 * R: revision code
>  	 * E: Error code. If it's in the range of 0x00..0x1f, only some
> -	 *    minor problem occured. Errors >= 0x20 are considered bad
> +	 *    minor problem occurred. Errors >= 0x20 are considered bad
>  	 *    and the device may not work properly...
>  	 * D: <0010> == mouse, <0100> == tablet
>  	 */
> diff --git a/drivers/isdn/hardware/mISDN/mISDNipac.c b/drivers/isdn/hardware/mISDN/mISDNipac.c
> index 64ecc6f..dafc0f9 100644
> --- a/drivers/isdn/hardware/mISDN/mISDNipac.c
> +++ b/drivers/isdn/hardware/mISDN/mISDNipac.c
> @@ -1627,7 +1627,7 @@ mISDNipac_init(struct ipac_hw *ipac, void *hw)
>  		ipac->hscx[i].bch.hw = hw;
>  		ipac->hscx[i].ip = ipac;
>  		/* default values for IOM time slots
> -		 * can be overwriten by card */
> +		 * can be overwritten by card */
>  		ipac->hscx[i].slot = (i == 0) ? 0x2f : 0x03;
>  	}
>  
> diff --git a/drivers/isdn/hardware/mISDN/w6692.c b/drivers/isdn/hardware/mISDN/w6692.c
> index 9e84870..3c376df 100644
> --- a/drivers/isdn/hardware/mISDN/w6692.c
> +++ b/drivers/isdn/hardware/mISDN/w6692.c
> @@ -779,7 +779,7 @@ w6692_irq(int intno, void *dev_id)
>  	spin_lock(&card->lock);
>  	ista = ReadW6692(card, W_ISTA);
>  	if ((ista | card->imask) == card->imask) {
> -		/* possible a shared  IRQ reqest */
> +		/* possible a shared  IRQ request */
>  		spin_unlock(&card->lock);
>  		return IRQ_NONE;
>  	}
> diff --git a/drivers/isdn/hisax/amd7930_fn.c b/drivers/isdn/hisax/amd7930_fn.c
> index 5d72783..6ce042b 100644
> --- a/drivers/isdn/hisax/amd7930_fn.c
> +++ b/drivers/isdn/hisax/amd7930_fn.c
> @@ -628,7 +628,7 @@ Amd7930_l1hw(struct PStack *st, int pr, void *arg)
>  			if ((cs->dc.amd7930.ph_state == 8)) {
>  				/* b-channels off, PH-AR cleared
>  				 * change to F3 */
> -				Amd7930_ph_command(cs, 0x20, "HW_RESET REQEST"); //LMR1 bit 5
> +				Amd7930_ph_command(cs, 0x20, "HW_RESET REQUEST"); //LMR1 bit 5
>  				spin_unlock_irqrestore(&cs->lock, flags);
>  			} else {
>  				Amd7930_ph_command(cs, 0x40, "HW_RESET REQUEST");
> diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
> index 0e66af1..5aa64ec 100644
> --- a/drivers/isdn/hisax/avm_pci.c
> +++ b/drivers/isdn/hisax/avm_pci.c
> @@ -653,7 +653,7 @@ avm_pcipnp_interrupt(int intno, void *dev_id)
>  	spin_lock_irqsave(&cs->lock, flags);
>  	sval = inb(cs->hw.avm.cfg_reg + 2);
>  	if ((sval & AVM_STATUS0_IRQ_MASK) == AVM_STATUS0_IRQ_MASK) {
> -		/* possible a shared  IRQ reqest */
> +		/* possible a shared  IRQ request */
>  		spin_unlock_irqrestore(&cs->lock, flags);
>  		return IRQ_NONE;
>  	}
> diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
> index 5d9d338..6d097f5 100644
> --- a/drivers/isdn/hisax/elsa.c
> +++ b/drivers/isdn/hisax/elsa.c
> @@ -70,7 +70,7 @@ static const char *ITACVer[] =
>  /* PCI stuff */
>  #define ELSA_PCI_IRQ_MASK	0x04
>  
> -/* ITAC Registeradressen (only Microlink PC) */
> +/* ITAC register addresses (only Microlink PC) */
>  #define ITAC_SYS	0x34
>  #define ITAC_ISEN	0x48
>  #define ITAC_RFIE	0x4A
> diff --git a/drivers/isdn/hisax/hisax_fcpcipnp.c b/drivers/isdn/hisax/hisax_fcpcipnp.c
> index 8b0a7d8..5e3e458 100644
> --- a/drivers/isdn/hisax/hisax_fcpcipnp.c
> +++ b/drivers/isdn/hisax/hisax_fcpcipnp.c
> @@ -659,7 +659,7 @@ fcpci2_irq(int intno, void *dev)
>  
>  	val = inb(adapter->io + AVM_STATUS0);
>  	if (!(val & AVM_STATUS0_IRQ_MASK))
> -		/* hopefully a shared  IRQ reqest */
> +		/* hopefully a shared  IRQ request */
>  		return IRQ_NONE;
>  	DBG(2, "STATUS0 %#x", val);
>  	if (val & AVM_STATUS0_IRQ_ISAC)
> @@ -679,7 +679,7 @@ fcpci_irq(int intno, void *dev)
>  
>  	sval = inb(adapter->io + 2);
>  	if ((sval & AVM_STATUS0_IRQ_MASK) == AVM_STATUS0_IRQ_MASK)
> -		/* possibly a shared  IRQ reqest */
> +		/* possibly a shared  IRQ request */
>  		return IRQ_NONE;
>  	DBG(2, "sval %#x", sval);
>  	if (!(sval & AVM_STATUS0_IRQ_ISAC))
> diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
> index cc6ee2d..ddf8fae 100644
> --- a/drivers/isdn/hisax/l3dss1.c
> +++ b/drivers/isdn/hisax/l3dss1.c
> @@ -1595,7 +1595,7 @@ l3dss1_setup(struct l3_process *pc, u_char pr, void *arg)
>  	 * Bearer Capabilities
>  	 */
>  	p = skb->data;
> -	/* only the first occurence 'll be detected ! */
> +	/* only the first occurrence 'll be detected ! */
>  	if ((p = findie(p, skb->len, 0x04, 0))) {
>  		if ((p[1] < 2) || (p[1] > 11))
>  			err = 1;
> diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
> index b8a1098..d497db0 100644
> --- a/drivers/isdn/isdnloop/isdnloop.c
> +++ b/drivers/isdn/isdnloop/isdnloop.c
> @@ -954,7 +954,7 @@ isdnloop_parse_cmd(isdnloop_card * card)
>  /*
>   * Put command-strings into the of the 'card'. In reality, execute them
>   * right in place by calling isdnloop_parse_cmd(). Also copy every
> - * command to the read message ringbuffer, preceeding it with a '>'.
> + * command to the read message ringbuffer, preceding it with a '>'.
>   * These mesagges can be read at /dev/isdnctrl.
>   *
>   * Parameter:
> diff --git a/drivers/isdn/mISDN/dsp_dtmf.c b/drivers/isdn/mISDN/dsp_dtmf.c
> index 9ae2d33..f950782 100644
> --- a/drivers/isdn/mISDN/dsp_dtmf.c
> +++ b/drivers/isdn/mISDN/dsp_dtmf.c
> @@ -106,7 +106,7 @@ void dsp_dtmf_hardware(struct dsp *dsp)
>   * tested it allot. it even works with very short tones (40ms). the only
>   * disadvantage is, that it doesn't work good with different volumes of both
>   * tones. this will happen, if accoustically coupled dialers are used.
> - * it sometimes detects tones during speach, which is normal for decoders.
> + * it sometimes detects tones during speech, which is normal for decoders.
>   * use sequences to given commands during calls.
>   *
>   * dtmf - points to a structure of the current dtmf state
> diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> index dad011a..7771ed2 100644
> --- a/drivers/md/dm-region-hash.c
> +++ b/drivers/md/dm-region-hash.c
> @@ -419,7 +419,7 @@ void dm_rh_mark_nosync(struct dm_region_hash *rh, struct bio *bio)
>  	/*
>  	 * Possible cases:
>  	 *   1) DM_RH_DIRTY
> -	 *   2) DM_RH_NOSYNC: was dirty, other preceeding writes failed
> +	 *   2) DM_RH_NOSYNC: was dirty, other preceding writes failed
>  	 *   3) DM_RH_RECOVERING: flushing pending writes
>  	 * Either case, the region should have not been connected to list.
>  	 */
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 7e90b85..c95def5 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -94,7 +94,7 @@ struct mdk_rdev_s
>  #define	In_sync		2		/* device is in_sync with rest of array */
>  #define	WriteMostly	4		/* Avoid reading if at all possible */
>  #define	AutoDetected	7		/* added by auto-detect */
> -#define Blocked		8		/* An error occured on an externally
> +#define Blocked		8		/* An error occurred on an externally
>  					 * managed array, don't allow writes
>  					 * until it is cleared */
>  	wait_queue_head_t blocked_wait;
> diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146_i2c.c
> index 74ee172..8434c0c 100644
> --- a/drivers/media/common/saa7146_i2c.c
> +++ b/drivers/media/common/saa7146_i2c.c
> @@ -161,7 +161,7 @@ static int saa7146_i2c_reset(struct saa7146_dev *dev)
>  		msleep(SAA7146_I2C_DELAY);
>  	}
>  
> -	/* if any error is still present, a fatal error has occured ... */
> +	/* if any error is still present, a fatal error has occurred ... */
>  	status = saa7146_i2c_status(dev);
>  	if ( dev->i2c_bitrate != status ) {
>  		DEB_I2C(("fatal error. status:0x%08x\n",status));
> @@ -326,9 +326,9 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
>  			if ( 0 != err) {
>  				/* this one is unsatisfying: some i2c slaves on some
>  				   dvb cards don't acknowledge correctly, so the saa7146
> -				   thinks that an address error occured. in that case, the
> +				   thinks that an address error occurred. in that case, the
>  				   transaction should be retrying, even if an address error
> -				   occured. analog saa7146 based cards extensively rely on
> +				   occurred. analog saa7146 based cards extensively rely on
>  				   i2c address probing, however, and address errors indicate that a
>  				   device is really *not* there. retrying in that case
>  				   increases the time the device needs to probe greatly, so
> diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
> index 605e28b..0d6e094 100644
> --- a/drivers/media/common/tuners/mxl5005s.c
> +++ b/drivers/media/common/tuners/mxl5005s.c
> @@ -106,7 +106,7 @@ enum {
>  /* MXL5005 Tuner Register Struct */
>  struct TunerReg {
>  	u16 Reg_Num;	/* Tuner Register Address */
> -	u16 Reg_Val;	/* Current sw programmed value waiting to be writen */
> +	u16 Reg_Val;	/* Current sw programmed value waiting to be written */
>  };
>  
>  enum {
> diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
> index 227c020..9552540 100644
> --- a/drivers/media/dvb/b2c2/flexcop-pci.c
> +++ b/drivers/media/dvb/b2c2/flexcop-pci.c
> @@ -58,7 +58,7 @@ struct flexcop_pci {
>  
>  	int active_dma1_addr; /* 0 = addr0 of dma1; 1 = addr1 of dma1 */
>  	u32 last_dma1_cur_pos;
> -	/* position of the pointer last time the timer/packet irq occured */
> +	/* position of the pointer last time the timer/packet irq occurred */
>  	int count;
>  	int count_prev;
>  	int stream_problem;
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index cad6634..312bf46 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1638,7 +1638,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>  	case FE_READ_STATUS: {
>  		fe_status_t* status = parg;
>  
> -		/* if retune was requested but hasn't occured yet, prevent
> +		/* if retune was requested but hasn't occurred yet, prevent
>  		 * that user get signal state from previous tuning */
>  		if (fepriv->state == FESTATE_RETUNE ||
>  		    fepriv->state == FESTATE_ERROR) {
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
> index 65fa926..236f085 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
> @@ -322,7 +322,7 @@ struct usb_data_stream {
>   * struct dvb_usb_adapter - a DVB adapter on a USB device
>   * @id: index of this adapter (starting with 0).
>   *
> - * @feedcount: number of reqested feeds (used for streaming-activation)
> + * @feedcount: number of requested feeds (used for streaming-activation)
>   * @pid_filtering: is hardware pid_filtering used or not.
>   *
>   * @pll_addr: I2C address of the tuner for programming
> diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> index 9eea418..d7d2b9f 100644
> --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> @@ -306,7 +306,7 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
>  	lme_int->lme_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
>  
>  	usb_submit_urb(lme_int->lme_urb, GFP_ATOMIC);
> -	info("INT Interupt Service Started");
> +	info("INT Interrupt Service Started");
>  
>  	return 0;
>  }
> @@ -427,7 +427,7 @@ static int lme2510_msg(struct dvb_usb_device *d,
>  			break;
>  		}
>  
> -		deb_info(4, "I2C From Interupt Message out(%02x) in(%02x)",
> +		deb_info(4, "I2C From Interrupt Message out(%02x) in(%02x)",
>  				wbuf[3], rbuf[1]);
>  
>  	}
> @@ -580,11 +580,11 @@ static int lme2510_int_service(struct dvb_usb_adapter *adap)
>  	}
>  	d->rc_dev = rc;
>  
> -	/* Start the Interupt */
> +	/* Start the Interrupt */
>  	ret = lme2510_int_read(adap);
>  	if (ret < 0) {
>  		rc_unregister_device(rc);
> -		info("INT Unable to start Interupt Service");
> +		info("INT Unable to start Interrupt Service");
>  		return -ENODEV;
>  	}
>  
> @@ -888,7 +888,7 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
>  		return -ENODEV;
>  	}
>  
> -	/* Start the Interupt & Remote*/
> +	/* Start the Interrupt & Remote*/
>  	ret = lme2510_int_service(adap);
>  
>  	return ret;
> @@ -1060,7 +1060,7 @@ void *lme2510_exit_int(struct dvb_usb_device *d)
>  		usb_kill_urb(st->lme_urb);
>  		usb_free_coherent(d->udev, 5000, st->buffer,
>  				  st->lme_urb->transfer_dma);
> -		info("Interupt Service Stopped");
> +		info("Interrupt Service Stopped");
>  		rc_unregister_device(d->rc_dev);
>  		info("Remote Stopped");
>  	}
> diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
> index c7f5ccf..b0ca946 100644
> --- a/drivers/media/dvb/frontends/dib7000m.c
> +++ b/drivers/media/dvb/frontends/dib7000m.c
> @@ -322,7 +322,7 @@ static int dib7000m_sad_calib(struct dib7000m_state *state)
>  {
>  
>  /* internal */
> -//	dib7000m_write_word(state, 928, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is writting in set_bandwidth
> +//	dib7000m_write_word(state, 928, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is writing in set_bandwidth
>  	dib7000m_write_word(state, 929, (0 << 1) | (0 << 0));
>  	dib7000m_write_word(state, 930, 776); // 0.625*3.3 / 4096
>  
> diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
> index 6aa02cb..2a13127 100644
> --- a/drivers/media/dvb/frontends/dib7000p.c
> +++ b/drivers/media/dvb/frontends/dib7000p.c
> @@ -293,7 +293,7 @@ static int dib7000p_set_bandwidth(struct dib7000p_state *state, u32 bw)
>  static int dib7000p_sad_calib(struct dib7000p_state *state)
>  {
>  /* internal */
> -//	dib7000p_write_word(state, 72, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is writting in set_bandwidth
> +//	dib7000p_write_word(state, 72, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is writing in set_bandwidth
>  	dib7000p_write_word(state, 73, (0 << 1) | (0 << 0));
>  	dib7000p_write_word(state, 74, 776); // 0.625*3.3 / 4096
>  
> diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
> index e87b747..17f8cdf 100644
> --- a/drivers/media/dvb/frontends/s5h1420.c
> +++ b/drivers/media/dvb/frontends/s5h1420.c
> @@ -225,7 +225,7 @@ static int s5h1420_recv_slave_reply (struct dvb_frontend* fe,
>  	unsigned long timeout;
>  	int result = 0;
>  
> -	/* setup for DISEQC recieve */
> +	/* setup for DISEQC receive */
>  	val = s5h1420_readreg(state, 0x3b);
>  	s5h1420_writereg(state, 0x3b, 0x82); /* FIXME: guess - do we need to set DIS_RDY(0x08) in receive mode? */
>  	msleep(15);
> diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
> index 6ca6713..d6baa79 100644
> --- a/drivers/media/dvb/pluto2/pluto2.c
> +++ b/drivers/media/dvb/pluto2/pluto2.c
> @@ -299,7 +299,7 @@ static void pluto_dma_end(struct pluto *pluto, unsigned int nbpackets)
>  	 *     although one packet has been transfered.
>  	 * [3] Sometimes (actually rarely), the card gets into an erroneous
>  	 *     mode where it continuously generates interrupts, claiming it
> -	 *     has recieved nbpackets>TS_DMA_PACKETS packets, but no packet
> +	 *     has received nbpackets>TS_DMA_PACKETS packets, but no packet
>  	 *     has been transfered. Only a reset seems to solve this
>  	 */
>  	if ((nbpackets == 0) || (nbpackets > TS_DMA_PACKETS)) {
> @@ -332,7 +332,7 @@ static irqreturn_t pluto_irq(int irq, void *dev_id)
>  	struct pluto *pluto = dev_id;
>  	u32 tscr;
>  
> -	/* check whether an interrupt occured on this device */
> +	/* check whether an interrupt occurred on this device */
>  	tscr = pluto_readreg(pluto, REG_TSCR);
>  	if (!(tscr & (TSCR_DE | TSCR_OVR)))
>  		return IRQ_NONE;
> diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
> index fe1b803..f893bff 100644
> --- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
> +++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
> @@ -234,7 +234,7 @@ static void ttusb_dec_handle_irq( struct urb *urb)
>  		 * (with buffer[3] == 0x40) in an intervall of ~100ms.
>  		 * But to handle this correctly we had to imlemenent some
>  		 * kind of timer which signals a 'key up' event if no
> -		 * keyrepeat signal is recieved for lets say 200ms.
> +		 * keyrepeat signal is received for lets say 200ms.
>  		 * this should/could be added later ...
>  		 * for now lets report each signal as a key down and up*/
>  		dprintk("%s:rc signal:%d\n", __func__, buffer[4]);
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 273d9d6..f93f42a 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -503,7 +503,7 @@ static int nvt_set_tx_carrier(struct rc_dev *dev, u32 carrier)
>   * in interrupt_handler:
>   * 5) send all data out
>   * go back to write():
> - * 6) disable TX interrupts, re-enable RX interupts
> + * 6) disable TX interrupts, re-enable RX interrupts
>   *
>   * The key problem of this function is user space data may larger than
>   * driver's data buf length. So nvt_tx_ir() will only copy TX_BUF_LEN data to
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 512a2f4..4b3f63f 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -255,7 +255,7 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
>   * @rc_map:	scancode table to be searched
>   * @scancode:	the desired scancode
>   * @resize:	controls whether we allowed to resize the table to
> - *		accomodate not yet present scancodes
> + *		accommodate not yet present scancodes
>   * @return:	index of the mapping containing scancode in question
>   *		or -1U in case of failure.
>   *
> diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
> index 55ffd60..6647033 100644
> --- a/drivers/media/video/cafe_ccic.c
> +++ b/drivers/media/video/cafe_ccic.c
> @@ -383,7 +383,7 @@ static int cafe_smbus_write_data(struct cafe_camera *cam,
>  	 * causes the device to die.
>  	 * Use a busy-wait because we often send a large quantity of small
>  	 * commands at-once; using msleep() would cause a lot of context
> -	 * switches which take longer than 2ms, resulting in a noticable
> +	 * switches which take longer than 2ms, resulting in a noticeable
>  	 * boot-time and capture-start delays.
>  	 */
>  	mdelay(2);
> diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
> index 62e41ab..3c47299 100644
> --- a/drivers/media/video/cx23885/cx23885.h
> +++ b/drivers/media/video/cx23885/cx23885.h
> @@ -211,8 +211,8 @@ struct cx23885_board {
>  
>  	/* Vendors can and do run the PCIe bridge at different
>  	 * clock rates, driven physically by crystals on the PCBs.
> -	 * The core has to accomodate this. This allows the user
> -	 * to add new boards with new frequencys. The value is
> +	 * The core has to accommodate this. This allows the user
> +	 * to add new boards with new frequencies. The value is
>  	 * expressed in Hz.
>  	 *
>  	 * The core framework will default this value based on
> diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
> index 490aafb..b3fe98d 100644
> --- a/drivers/media/video/davinci/dm644x_ccdc.c
> +++ b/drivers/media/video/davinci/dm644x_ccdc.c
> @@ -258,7 +258,7 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
>  	/*
>  	 * Allocate memory for FPC table if current
>  	 * FPC table buffer is not big enough to
> -	 * accomodate FPC Number requested
> +	 * accommodate FPC Number requested
>  	 */
>  	if (raw_params->fault_pxl.fp_num != config_params->fault_pxl.fp_num) {
>  		if (fpc_physaddr != NULL) {
> diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
> index d6f39ce..ce616ac 100644
> --- a/drivers/media/video/gspca/sonixj.c
> +++ b/drivers/media/video/gspca/sonixj.c
> @@ -1114,7 +1114,7 @@ static const u8 ov7660_sensor_param1[][8] = {
>  /*	{0xb1, 0x21, 0x01, 0x78, 0x78, 0x00, 0x00, 0x10}, * BLUE */
>  /****** (some exchanges in the win trace) ******/
>  /*fixme:param2*/
> -	{0xa1, 0x21, 0x93, 0x00, 0x00, 0x00, 0x00, 0x10},/* dummy line hight */
> +	{0xa1, 0x21, 0x93, 0x00, 0x00, 0x00, 0x00, 0x10},/* dummy line high */
>  	{0xa1, 0x21, 0x92, 0x25, 0x00, 0x00, 0x00, 0x10}, /* dummy line low */
>  	{0xa1, 0x21, 0x2a, 0x00, 0x00, 0x00, 0x00, 0x10}, /* EXHCH */
>  	{0xa1, 0x21, 0x2b, 0x00, 0x00, 0x00, 0x00, 0x10}, /* EXHCL */
> diff --git a/drivers/media/video/gspca/spca501.c b/drivers/media/video/gspca/spca501.c
> index f7ef282..cada74e 100644
> --- a/drivers/media/video/gspca/spca501.c
> +++ b/drivers/media/video/gspca/spca501.c
> @@ -1715,7 +1715,7 @@ static const __u16 spca501c_mysterious_init_data[][3] = {
>  	{0x00, 0x0080, 0x0021},	/* 640 */
>  	{0x00, 0x0001, 0x0022},
>  	{0x00, 0x00e0, 0x0023},	/* 480 */
> -	{0x00, 0x0000, 0x0024},	/* Offset H hight */
> +	{0x00, 0x0000, 0x0024},	/* Offset H high */
>  	{0x00, 0x00d3, 0x0025},	/* low */
>  	{0x00, 0x0000, 0x0026},	/* Offset V */
>  	{0x00, 0x000d, 0x0027},	/* low */
> diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
> index 47236a5..d46e0bd 100644
> --- a/drivers/media/video/gspca/zc3xx.c
> +++ b/drivers/media/video/gspca/zc3xx.c
> @@ -5740,7 +5740,7 @@ static u16 i2c_read(struct gspca_dev *gspca_dev,
>  	if (retbyte != 0x00)
>  		err("i2c_r status error %02x", retbyte);
>  	retval = reg_r_i(gspca_dev, 0x0095);		/* read Lowbyte */
> -	retval |= reg_r_i(gspca_dev, 0x0096) << 8;	/* read Hightbyte */
> +	retval |= reg_r_i(gspca_dev, 0x0096) << 8;	/* read Highbyte */
>  	PDEBUG(D_USBI, "i2c r [%02x] -> %04x (%02x)",
>  			reg, retval, retbyte);
>  	return retval;
> diff --git a/drivers/media/video/ivtv/ivtv-firmware.c b/drivers/media/video/ivtv/ivtv-firmware.c
> index 4df0194..0f27f5b 100644
> --- a/drivers/media/video/ivtv/ivtv-firmware.c
> +++ b/drivers/media/video/ivtv/ivtv-firmware.c
> @@ -377,7 +377,7 @@ int ivtv_firmware_check(struct ivtv *itv, char *where)
>  			  "Reloading\n", where);
>  		res = ivtv_firmware_restart(itv);
>  		/*
> -		 * Even if restarted ok, still signal a problem had occured.
> +		 * Even if restarted ok, still signal a problem had occurred.
>  		 * The caller can come through this function again to check
>  		 * if things are really ok after the restart.
>  		 */
> diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
> index cf93de9..336180b 100644
> --- a/drivers/media/video/ov6650.c
> +++ b/drivers/media/video/ov6650.c
> @@ -1038,7 +1038,7 @@ static int ov6650_reset(struct i2c_client *client)
>  	ret = ov6650_reg_rmw(client, REG_COMA, COMA_RESET, 0);
>  	if (ret)
>  		dev_err(&client->dev,
> -			"An error occured while entering soft reset!\n");
> +			"An error occurred while entering soft reset!\n");
>  
>  	return ret;
>  }
> diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
> index 53d88a2..5173ac4 100644
> --- a/drivers/media/video/ov9640.c
> +++ b/drivers/media/video/ov9640.c
> @@ -273,7 +273,7 @@ static int ov9640_reset(struct i2c_client *client)
>  	ret = ov9640_reg_write(client, OV9640_COM7, OV9640_COM7_SCCB_RESET);
>  	if (ret)
>  		dev_err(&client->dev,
> -			"An error occured while entering soft reset!\n");
> +			"An error occurred while entering soft reset!\n");
>  
>  	return ret;
>  }
> diff --git a/drivers/media/video/saa7164/saa7164-cmd.c b/drivers/media/video/saa7164/saa7164-cmd.c
> index a97ae17..135a6e4 100644
> --- a/drivers/media/video/saa7164/saa7164-cmd.c
> +++ b/drivers/media/video/saa7164/saa7164-cmd.c
> @@ -257,7 +257,7 @@ out:
>  }
>  
>  /* Wait for a signal event, without holding a mutex. Either return TIMEOUT if
> - * the event never occured, or SAA_OK if it was signaled during the wait.
> + * the event never occurred, or SAA_OK if it was signaled during the wait.
>   */
>  int saa7164_cmd_wait(struct saa7164_dev *dev, u8 seqno)
>  {
> diff --git a/drivers/media/video/stk-sensor.c b/drivers/media/video/stk-sensor.c
> index e546b01..5d0f84c 100644
> --- a/drivers/media/video/stk-sensor.c
> +++ b/drivers/media/video/stk-sensor.c
> @@ -502,7 +502,7 @@ int stk_sensor_configure(struct stk_camera *dev)
>  	int com7;
>  	/*
>  	 * We setup the sensor to output dummy lines in low-res modes,
> -	 * so we don't get absurdly hight framerates.
> +	 * so we don't get absurdly high framerates.
>  	 */
>  	unsigned dummylines;
>  	int flip;
> diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
> index 5673d67..d270f24 100644
> --- a/drivers/media/video/uvc/uvc_video.c
> +++ b/drivers/media/video/uvc/uvc_video.c
> @@ -390,7 +390,7 @@ int uvc_commit_video(struct uvc_streaming *stream,
>   *
>   * uvc_video_decode_end is called with header data at the end of a bulk or
>   * isochronous payload. It performs any additional header data processing and
> - * returns 0 or a negative error code if an error occured. As header data have
> + * returns 0 or a negative error code if an error occurred. As header data have
>   * already been processed by uvc_video_decode_start, this functions isn't
>   * required to perform sanity checks a second time.
>   *
> @@ -654,7 +654,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
>  							    buf);
>  		} while (ret == -EAGAIN);
>  
> -		/* If an error occured skip the rest of the payload. */
> +		/* If an error occurred skip the rest of the payload. */
>  		if (ret < 0 || buf == NULL) {
>  			stream->bulk.skip_payload = 1;
>  		} else {
> diff --git a/drivers/message/fusion/lsi/mpi_log_sas.h b/drivers/message/fusion/lsi/mpi_log_sas.h
> index 8b04810..f16e7cc 100644
> --- a/drivers/message/fusion/lsi/mpi_log_sas.h
> +++ b/drivers/message/fusion/lsi/mpi_log_sas.h
> @@ -56,9 +56,9 @@
>  #define IOP_LOGINFO_CODE_FWUPLOAD_NO_FLASH_AVAILABLE         (0x0003E000) /* Tried to upload from flash, but there is none */
>  #define IOP_LOGINFO_CODE_FWUPLOAD_UNKNOWN_IMAGE_TYPE         (0x0003E001) /* ImageType field contents were invalid */
>  #define IOP_LOGINFO_CODE_FWUPLOAD_WRONG_IMAGE_SIZE           (0x0003E002) /* ImageSize field in TCSGE was bad/offset in MfgPg 4 was wrong */
> -#define IOP_LOGINFO_CODE_FWUPLOAD_ENTIRE_FLASH_UPLOAD_FAILED (0x0003E003) /* Error occured while attempting to upload the entire flash */
> -#define IOP_LOGINFO_CODE_FWUPLOAD_REGION_UPLOAD_FAILED       (0x0003E004) /* Error occured while attempting to upload single flash region */
> -#define IOP_LOGINFO_CODE_FWUPLOAD_DMA_FAILURE                (0x0003E005) /* Problem occured while DMAing FW to host memory */
> +#define IOP_LOGINFO_CODE_FWUPLOAD_ENTIRE_FLASH_UPLOAD_FAILED (0x0003E003) /* Error occurred while attempting to upload the entire flash */
> +#define IOP_LOGINFO_CODE_FWUPLOAD_REGION_UPLOAD_FAILED       (0x0003E004) /* Error occurred while attempting to upload single flash region */
> +#define IOP_LOGINFO_CODE_FWUPLOAD_DMA_FAILURE                (0x0003E005) /* Problem occurred while DMAing FW to host memory */
>  
>  #define IOP_LOGINFO_CODE_DIAG_MSG_ERROR                      (0x00040000) /* Error handling diag msg - or'd with diag status */
>  
> @@ -187,8 +187,8 @@
>  #define PL_LOGINFO_SUB_CODE_BREAK_ON_INCOMPLETE_BREAK_RCVD   (0x00005000)
>  
>  #define PL_LOGINFO_CODE_ENCL_MGMT_SMP_FRAME_FAILURE          (0x00200000) /* Can't get SMP Frame */
> -#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR             (0x00200010) /* Error occured on SMP Read */
> -#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_WRITE_ERROR            (0x00200020) /* Error occured on SMP Write */
> +#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR             (0x00200010) /* Error occurred on SMP Read */
> +#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_WRITE_ERROR            (0x00200020) /* Error occurred on SMP Write */
>  #define PL_LOGINFO_CODE_ENCL_MGMT_NOT_SUPPORTED_ON_ENCL      (0x00200040) /* Encl Mgmt services not available for this WWID */
>  #define PL_LOGINFO_CODE_ENCL_MGMT_ADDR_MODE_NOT_SUPPORTED    (0x00200050) /* Address Mode not suppored */
>  #define PL_LOGINFO_CODE_ENCL_MGMT_BAD_SLOT_NUM               (0x00200060) /* Invalid Slot Number in SEP Msg */
> diff --git a/drivers/message/fusion/lsi/mpi_raid.h b/drivers/message/fusion/lsi/mpi_raid.h
> index add60cc..0f2c8b4 100644
> --- a/drivers/message/fusion/lsi/mpi_raid.h
> +++ b/drivers/message/fusion/lsi/mpi_raid.h
> @@ -217,7 +217,7 @@ typedef struct _MSG_SCSI_IO_RAID_PT_REPLY
>  
>  
>  /****************************************************************************/
> -/* Mailbox reqeust structure */
> +/* Mailbox request structure */
>  /****************************************************************************/
>  
>  typedef struct _MSG_MAILBOX_REQUEST
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 3358c0a..7cd44b1 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -7900,7 +7900,7 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info)
>  		    "Owner", 					/* 15h */
>  		"Open Transmit DMA Abort",			/* 16h */
>  		"IO Device Missing Delay Retry",		/* 17h */
> -		"IO Cancelled Due to Recieve Error",		/* 18h */
> +		"IO Cancelled Due to Receive Error",		/* 18h */
>  		NULL,						/* 19h */
>  		NULL,						/* 1Ah */
>  		NULL,						/* 1Bh */
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
> index a3856ed..f79d5a2 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -2398,7 +2398,7 @@ done_free_mem:
>  	}
>  
>  	/* mf is null if command issued successfully
> -	 * otherwise, failure occured after mf acquired.
> +	 * otherwise, failure occurred after mf acquired.
>  	 */
>  	if (mf)
>  		mpt_free_msg_frame(ioc, mf);
> diff --git a/drivers/misc/iwmc3200top/main.c b/drivers/misc/iwmc3200top/main.c
> index c73cef2..cce7b63 100644
> --- a/drivers/misc/iwmc3200top/main.c
> +++ b/drivers/misc/iwmc3200top/main.c
> @@ -268,7 +268,7 @@ static void iwmct_irq_read_worker(struct work_struct *ws)
>  		LOG_INFO(priv, IRQ, "ACK barker arrived "
>  				"- starting FW download\n");
>  	} else { /* REBOOT barker */
> -		LOG_INFO(priv, IRQ, "Recieved reboot barker: %x\n", barker);
> +		LOG_INFO(priv, IRQ, "Received reboot barker: %x\n", barker);
>  		priv->barker = barker;
>  
>  		if (barker & BARKER_DNLOAD_SYNC_MSK) {
> diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
> index 59c118c..b076b0c 100644
> --- a/drivers/misc/kgdbts.c
> +++ b/drivers/misc/kgdbts.c
> @@ -645,7 +645,7 @@ static int validate_simple_test(char *put_str)
>  
>  	while (*chk_str != '\0' && *put_str != '\0') {
>  		/* If someone does a * to match the rest of the string, allow
> -		 * it, or stop if the recieved string is complete.
> +		 * it, or stop if the received string is complete.
>  		 */
>  		if (*put_str == '#' || *chk_str == '*')
>  			return 0;
> diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
> index 34749ee..9e9bdda 100644
> --- a/drivers/misc/sgi-gru/grukservices.c
> +++ b/drivers/misc/sgi-gru/grukservices.c
> @@ -229,7 +229,7 @@ again:
>  	bid = blade_id < 0 ? uv_numa_blade_id() : blade_id;
>  	bs = gru_base[bid];
>  
> -	/* Handle the case where migration occured while waiting for the sema */
> +	/* Handle the case where migration occurred while waiting for the sema */
>  	down_read(&bs->bs_kgts_sema);
>  	if (blade_id < 0 && bid != uv_numa_blade_id()) {
>  		up_read(&bs->bs_kgts_sema);
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index 60842f8..f3b22bf 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -105,7 +105,7 @@ int mmc_go_idle(struct mmc_host *host)
>  	 * that in case of hardware that won't pull up DAT3/nCS otherwise.
>  	 *
>  	 * SPI hosts ignore ios.chip_select; it's managed according to
> -	 * rules that must accomodate non-MMC slaves which this layer
> +	 * rules that must accommodate non-MMC slaves which this layer
>  	 * won't even know about.
>  	 */
>  	if (!mmc_host_is_spi(host)) {
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index ad2a7a0..a3b2bb8 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -127,7 +127,7 @@ struct atmel_mci_dma {
>   * EVENT_DATA_COMPLETE is set in @pending_events, all data-related
>   * interrupts must be disabled and @data_status updated with a
>   * snapshot of SR. Similarly, before EVENT_CMD_COMPLETE is set, the
> - * CMDRDY interupt must be disabled and @cmd_status updated with a
> + * CMDRDY interrupt must be disabled and @cmd_status updated with a
>   * snapshot of SR, and before EVENT_XFER_COMPLETE can be set, the
>   * bytes_xfered field of @data must be written. This is ensured by
>   * using barriers.
> diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
> index a8c3e1c..ce5d394 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0001.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0001.c
> @@ -1269,12 +1269,12 @@ static int inval_cache_and_wait_for_operation(
>  			mutex_lock(&chip->mutex);
>  		}
>  		if (chip->erase_suspended && chip_state == FL_ERASING)  {
> -			/* Erase suspend occured while sleep: reset timeout */
> +			/* Erase suspend occurred while sleep: reset timeout */
>  			timeo = reset_timeo;
>  			chip->erase_suspended = 0;
>  		}
>  		if (chip->write_suspended && chip_state == FL_WRITING)  {
> -			/* Write suspend occured while sleep: reset timeout */
> +			/* Write suspend occurred while sleep: reset timeout */
>  			timeo = reset_timeo;
>  			chip->write_suspended = 0;
>  		}
> diff --git a/drivers/mtd/lpddr/lpddr_cmds.c b/drivers/mtd/lpddr/lpddr_cmds.c
> index 04fdfcc..28bdc1c 100644
> --- a/drivers/mtd/lpddr/lpddr_cmds.c
> +++ b/drivers/mtd/lpddr/lpddr_cmds.c
> @@ -171,7 +171,7 @@ static int wait_for_ready(struct map_info *map, struct flchip *chip,
>  			mutex_lock(&chip->mutex);
>  		}
>  		if (chip->erase_suspended || chip->write_suspended)  {
> -			/* Suspend has occured while sleep: reset timeout */
> +			/* Suspend has occurred while sleep: reset timeout */
>  			timeo = reset_timeo;
>  			chip->erase_suspended = chip->write_suspended = 0;
>  		}
> diff --git a/drivers/mtd/maps/ceiva.c b/drivers/mtd/maps/ceiva.c
> index c09f4f5..7e643c8 100644
> --- a/drivers/mtd/maps/ceiva.c
> +++ b/drivers/mtd/maps/ceiva.c
> @@ -42,7 +42,7 @@
>   *
>   * Please note:
>   *  1. The flash size given should be the largest flash size that can
> - *     be accomodated.
> + *     be accommodated.
>   *
>   *  2. The bus width must defined in clps_setup_flash.
>   *
> diff --git a/drivers/mtd/maps/pmcmsp-flash.c b/drivers/mtd/maps/pmcmsp-flash.c
> index acb13fa..64aea6a 100644
> --- a/drivers/mtd/maps/pmcmsp-flash.c
> +++ b/drivers/mtd/maps/pmcmsp-flash.c
> @@ -3,7 +3,7 @@
>   * Config with both CFI and JEDEC device support.
>   *
>   * Basically physmap.c with the addition of partitions and
> - * an array of mapping info to accomodate more than one flash type per board.
> + * an array of mapping info to accommodate more than one flash type per board.
>   *
>   * Copyright 2005-2007 PMC-Sierra, Inc.
>   *
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 145b3d0d..4c36ef6 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -234,7 +234,7 @@ static ssize_t mtd_read(struct file *file, char __user *buf, size_t count,loff_t
>  		 * the data. For our userspace tools it is important
>  		 * to dump areas with ecc errors !
>  		 * For kernel internal usage it also might return -EUCLEAN
> -		 * to signal the caller that a bitflip has occured and has
> +		 * to signal the caller that a bitflip has occurred and has
>  		 * been corrected by the ECC algorithm.
>  		 * Userspace software which accesses NAND this way
>  		 * must be aware of the fact that it deals with NAND
> diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
> index b7f8de7..39cd047 100644
> --- a/drivers/mtd/nand/diskonchip.c
> +++ b/drivers/mtd/nand/diskonchip.c
> @@ -137,7 +137,7 @@ static struct rs_control *rs_decoder;
>   *
>   * Fabrice Bellard figured this out in the old docecc code. I added
>   * some comments, improved a minor bit and converted it to make use
> - * of the generic Reed-Solomon libary. tglx
> + * of the generic Reed-Solomon library. tglx
>   */
>  static int doc_ecc_decode(struct rs_control *rs, uint8_t *data, uint8_t *ecc)
>  {
> @@ -986,7 +986,7 @@ static int doc200x_correct_data(struct mtd_info *mtd, u_char *dat,
>  		dummy = ReadDOC(docptr, ECCConf);
>  	}
>  
> -	/* Error occured ? */
> +	/* Error occurred ? */
>  	if (dummy & 0x80) {
>  		for (i = 0; i < 6; i++) {
>  			if (DoC_is_MillenniumPlus(doc))
> diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
> index d9d7efb..d7dfa65 100644
> --- a/drivers/mtd/nand/r852.c
> +++ b/drivers/mtd/nand/r852.c
> @@ -766,7 +766,7 @@ static irqreturn_t r852_irq(int irq, void *data)
>  		ret = IRQ_HANDLED;
>  		dev->card_detected = !!(card_status & R852_CARD_IRQ_INSERT);
>  
> -		/* we shouldn't recieve any interrupts if we wait for card
> +		/* we shouldn't receive any interrupts if we wait for card
>  			to settle */
>  		WARN_ON(dev->card_unstable);
>  
> @@ -794,13 +794,13 @@ static irqreturn_t r852_irq(int irq, void *data)
>  		ret = IRQ_HANDLED;
>  
>  		if (dma_status & R852_DMA_IRQ_ERROR) {
> -			dbg("recieved dma error IRQ");
> +			dbg("received dma error IRQ");
>  			r852_dma_done(dev, -EIO);
>  			complete(&dev->dma_done);
>  			goto out;
>  		}
>  
> -		/* recieved DMA interrupt out of nowhere? */
> +		/* received DMA interrupt out of nowhere? */
>  		WARN_ON_ONCE(dev->dma_stage == 0);
>  
>  		if (dev->dma_stage == 0)
> diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
> index 546c2f0..81bbb5e 100644
> --- a/drivers/mtd/nand/sh_flctl.c
> +++ b/drivers/mtd/nand/sh_flctl.c
> @@ -78,7 +78,7 @@ static void start_translation(struct sh_flctl *flctl)
>  
>  static void timeout_error(struct sh_flctl *flctl, const char *str)
>  {
> -	dev_err(&flctl->pdev->dev, "Timeout occured in %s\n", str);
> +	dev_err(&flctl->pdev->dev, "Timeout occurred in %s\n", str);
>  }
>  
>  static void wait_completion(struct sh_flctl *flctl)
> diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
> index 2ca880b..69ee7c1 100644
> --- a/drivers/net/amd8111e.c
> +++ b/drivers/net/amd8111e.c
> @@ -1170,7 +1170,7 @@ static irqreturn_t amd8111e_interrupt(int irq, void *dev_id)
>  	/* Check if Receive Interrupt has occurred. */
>  	if (intr0 & RINT0) {
>  		if (napi_schedule_prep(&lp->napi)) {
> -			/* Disable receive interupts */
> +			/* Disable receive interrupts */
>  			writel(RINTEN0, mmio + INTEN0);
>  			/* Schedule a polling routine */
>  			__napi_schedule(&lp->napi);
> diff --git a/drivers/net/amd8111e.h b/drivers/net/amd8111e.h
> index b5926af..854323e 100644
> --- a/drivers/net/amd8111e.h
> +++ b/drivers/net/amd8111e.h
> @@ -754,7 +754,7 @@ struct amd8111e_priv{
>  	const char *name;
>  	struct pci_dev *pci_dev;	/* Ptr to the associated pci_dev */
>  	struct net_device* amd8111e_net_dev; 	/* ptr to associated net_device */
> -	/* Transmit and recive skbs */
> +	/* Transmit and receive skbs */
>  	struct sk_buff *tx_skbuff[NUM_TX_BUFFERS];
>  	struct sk_buff *rx_skbuff[NUM_RX_BUFFERS];
>  	/* Transmit and receive dma mapped addr */
> diff --git a/drivers/net/arm/ks8695net.c b/drivers/net/arm/ks8695net.c
> index aa07657..f251fe0 100644
> --- a/drivers/net/arm/ks8695net.c
> +++ b/drivers/net/arm/ks8695net.c
> @@ -412,7 +412,7 @@ ks8695_tx_irq(int irq, void *dev_id)
>   *    Interrupt Status Register (Offset 0xF208)
>   *        Bit29: WAN MAC Receive Status
>   *        Bit16: LAN MAC Receive Status
> - *    So, this Rx interrrupt enable/status bit number is equal
> + *    So, this Rx interrupt enable/status bit number is equal
>   *    as Rx IRQ number.
>   */
>  static inline u32 ks8695_get_rx_enable_bit(struct ks8695_priv *ksp)
> diff --git a/drivers/net/atl1c/atl1c_hw.c b/drivers/net/atl1c/atl1c_hw.c
> index 1bf6720..fc3cbb0 100644
> --- a/drivers/net/atl1c/atl1c_hw.c
> +++ b/drivers/net/atl1c/atl1c_hw.c
> @@ -56,7 +56,7 @@ void atl1c_hw_set_mac_addr(struct atl1c_hw *hw)
>  		(((u32)hw->mac_addr[4]) << 8)  |
>  		(((u32)hw->mac_addr[5])) ;
>  	AT_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 0, value);
> -	/* hight dword */
> +	/* high dword */
>  	value = (((u32)hw->mac_addr[0]) << 8) |
>  		(((u32)hw->mac_addr[1])) ;
>  	AT_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 1, value);
> diff --git a/drivers/net/atl1e/atl1e_hw.c b/drivers/net/atl1e/atl1e_hw.c
> index 76cc043..d9ae31f 100644
> --- a/drivers/net/atl1e/atl1e_hw.c
> +++ b/drivers/net/atl1e/atl1e_hw.c
> @@ -55,7 +55,7 @@ void atl1e_hw_set_mac_addr(struct atl1e_hw *hw)
>  		(((u32)hw->mac_addr[4]) << 8)  |
>  		(((u32)hw->mac_addr[5])) ;
>  	AT_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 0, value);
> -	/* hight dword */
> +	/* high dword */
>  	value = (((u32)hw->mac_addr[0]) << 8) |
>  		(((u32)hw->mac_addr[1])) ;
>  	AT_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 1, value);
> diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
> index 4e6f4e9..fd65777 100644
> --- a/drivers/net/atlx/atl2.c
> +++ b/drivers/net/atlx/atl2.c
> @@ -2751,7 +2751,7 @@ static void atl2_set_mac_addr(struct atl2_hw *hw)
>  		(((u32)hw->mac_addr[4]) << 8)  |
>  		(((u32)hw->mac_addr[5]));
>  	ATL2_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 0, value);
> -	/* hight dword */
> +	/* high dword */
>  	value = (((u32)hw->mac_addr[0]) << 8) |
>  		(((u32)hw->mac_addr[1]));
>  	ATL2_WRITE_REG_ARRAY(hw, REG_MAC_STA_ADDR, 1, value);
> diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
> index 22abfb3..fd122fd 100644
> --- a/drivers/net/bfin_mac.c
> +++ b/drivers/net/bfin_mac.c
> @@ -194,7 +194,7 @@ static int desc_list_init(void)
>  		}
>  		skb_reserve(new_skb, NET_IP_ALIGN);
>  		/* Invidate the data cache of skb->data range when it is write back
> -		 * cache. It will prevent overwritting the new data from DMA
> +		 * cache. It will prevent overwriting the new data from DMA
>  		 */
>  		blackfin_dcache_invalidate_range((unsigned long)new_skb->head,
>  					 (unsigned long)new_skb->end);
> @@ -1099,7 +1099,7 @@ static void bfin_mac_rx(struct net_device *dev)
>  	/* reserve 2 bytes for RXDWA padding */
>  	skb_reserve(new_skb, NET_IP_ALIGN);
>  	/* Invidate the data cache of skb->data range when it is write back
> -	 * cache. It will prevent overwritting the new data from DMA
> +	 * cache. It will prevent overwriting the new data from DMA
>  	 */
>  	blackfin_dcache_invalidate_range((unsigned long)new_skb->head,
>  					 (unsigned long)new_skb->end);
> diff --git a/drivers/net/bnx2x/bnx2x_main.c b/drivers/net/bnx2x/bnx2x_main.c
> index d584d32..2b1e87e 100644
> --- a/drivers/net/bnx2x/bnx2x_main.c
> +++ b/drivers/net/bnx2x/bnx2x_main.c
> @@ -9441,7 +9441,7 @@ static int __devinit bnx2x_init_one(struct pci_dev *pdev,
>  
>  #endif
>  
> -	/* Configure interupt mode: try to enable MSI-X/MSI if
> +	/* Configure interrupt mode: try to enable MSI-X/MSI if
>  	 * needed, set bp->num_queues appropriately.
>  	 */
>  	bnx2x_set_int_mode(bp);
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 5c6fba8..fc5cdea 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -639,7 +639,7 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb, struct bonding *bon
>  	if (assigned_slave) {
>  		client_info->ip_src = arp->ip_src;
>  		client_info->ip_dst = arp->ip_dst;
> -		/* arp->mac_dst is broadcast for arp reqeusts.
> +		/* arp->mac_dst is broadcast for arp requests.
>  		 * will be updated with clients actual unicast mac address
>  		 * upon receiving an arp reply.
>  		 */
> diff --git a/drivers/net/caif/caif_shmcore.c b/drivers/net/caif/caif_shmcore.c
> index 8051116..731aa11 100644
> --- a/drivers/net/caif/caif_shmcore.c
> +++ b/drivers/net/caif/caif_shmcore.c
> @@ -591,7 +591,7 @@ int caif_shmcore_probe(struct shmdev_layer *pshm_dev)
>  			(NR_TX_BUF * TX_BUF_SZ + NR_RX_BUF * RX_BUF_SZ)) {
>  
>  		pr_warn("ERROR, Amount of available"
> -				" Phys. SHM cannot accomodate current SHM "
> +				" Phys. SHM cannot accommodate current SHM "
>  				"driver configuration, Bailing out ...\n");
>  		free_netdev(pshm_dev->pshm_netdev);
>  		return -ENOMEM;
> diff --git a/drivers/net/caif/caif_spi_slave.c b/drivers/net/caif/caif_spi_slave.c
> index 1b9943a..9fee8e3 100644
> --- a/drivers/net/caif/caif_spi_slave.c
> +++ b/drivers/net/caif/caif_spi_slave.c
> @@ -158,7 +158,7 @@ void cfspi_xfer(struct work_struct *work)
>  
>  		cfspi_dbg_state(cfspi, CFSPI_STATE_SIG_ACTIVE);
>  
> -		/* Signal that we are ready to recieve data. */
> +		/* Signal that we are ready to receive data. */
>  		cfspi->dev->sig_xfer(true, cfspi->dev);
>  
>  		cfspi_dbg_state(cfspi, CFSPI_STATE_WAIT_XFER_DONE);
> diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
> index 366f5cc..f1942ca 100644
> --- a/drivers/net/can/janz-ican3.c
> +++ b/drivers/net/can/janz-ican3.c
> @@ -273,7 +273,7 @@ static inline void ican3_set_page(struct ican3_dev *mod, unsigned int page)
>   */
>  
>  /*
> - * Recieve a message from the ICAN3 "old-style" firmware interface
> + * Receive a message from the ICAN3 "old-style" firmware interface
>   *
>   * LOCKING: must hold mod->lock
>   *
> @@ -1049,7 +1049,7 @@ static void ican3_handle_inquiry(struct ican3_dev *mod, struct ican3_msg *msg)
>  		complete(&mod->termination_comp);
>  		break;
>  	default:
> -		dev_err(mod->dev, "recieved an unknown inquiry response\n");
> +		dev_err(mod->dev, "received an unknown inquiry response\n");
>  		break;
>  	}
>  }
> @@ -1057,7 +1057,7 @@ static void ican3_handle_inquiry(struct ican3_dev *mod, struct ican3_msg *msg)
>  static void ican3_handle_unknown_message(struct ican3_dev *mod,
>  					struct ican3_msg *msg)
>  {
> -	dev_warn(mod->dev, "recieved unknown message: spec 0x%.2x length %d\n",
> +	dev_warn(mod->dev, "received unknown message: spec 0x%.2x length %d\n",
>  			   msg->spec, le16_to_cpu(msg->len));
>  }
>  
> @@ -1112,7 +1112,7 @@ static bool ican3_txok(struct ican3_dev *mod)
>  }
>  
>  /*
> - * Recieve one CAN frame from the hardware
> + * Receive one CAN frame from the hardware
>   *
>   * CONTEXT: must be called from user context
>   */
> diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
> index 0a8de01..a358ea9 100644
> --- a/drivers/net/can/sja1000/sja1000.c
> +++ b/drivers/net/can/sja1000/sja1000.c
> @@ -425,7 +425,7 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
>  			cf->data[3] = ecc & ECC_SEG;
>  			break;
>  		}
> -		/* Error occured during transmission? */
> +		/* Error occurred during transmission? */
>  		if ((ecc & ECC_DIR) == 0)
>  			cf->data[2] |= CAN_ERR_PROT_TX;
>  	}
> diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
> index e75f1a8..a72c7bf 100644
> --- a/drivers/net/can/usb/ems_usb.c
> +++ b/drivers/net/can/usb/ems_usb.c
> @@ -386,7 +386,7 @@ static void ems_usb_rx_err(struct ems_usb *dev, struct ems_cpc_msg *msg)
>  			break;
>  		}
>  
> -		/* Error occured during transmission? */
> +		/* Error occurred during transmission? */
>  		if ((ecc & SJA1000_ECC_DIR) == 0)
>  			cf->data[2] |= CAN_ERR_PROT_TX;
>  
> diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
> index 05a5275..b7f155f 100644
> --- a/drivers/net/can/usb/esd_usb2.c
> +++ b/drivers/net/can/usb/esd_usb2.c
> @@ -284,7 +284,7 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
>  				break;
>  			}
>  
> -			/* Error occured during transmission? */
> +			/* Error occurred during transmission? */
>  			if (!(ecc & SJA1000_ECC_DIR))
>  				cf->data[2] |= CAN_ERR_PROT_TX;
>  
> diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
> index 3437613..15ba5b9 100644
> --- a/drivers/net/cassini.c
> +++ b/drivers/net/cassini.c
> @@ -5165,7 +5165,7 @@ err_out_free_res:
>  	pci_release_regions(pdev);
>  
>  err_write_cacheline:
> -	/* Try to restore it in case the error occured after we
> +	/* Try to restore it in case the error occurred after we
>  	 * set it.
>  	 */
>  	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, orig_cacheline_size);
> diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
> index d55db6b..626ad4c 100644
> --- a/drivers/net/cxgb3/t3_hw.c
> +++ b/drivers/net/cxgb3/t3_hw.c
> @@ -1386,11 +1386,11 @@ struct intr_info {
>   *	@reg: the interrupt status register to process
>   *	@mask: a mask to apply to the interrupt status
>   *	@acts: table of interrupt actions
> - *	@stats: statistics counters tracking interrupt occurences
> + *	@stats: statistics counters tracking interrupt occurrences
>   *
>   *	A table driven interrupt handler that applies a set of masks to an
>   *	interrupt status word and performs the corresponding actions if the
> - *	interrupts described by the mask have occured.  The actions include
> + *	interrupts described by the mask have occurred. The actions include
>   *	optionally printing a warning or alert message, and optionally
>   *	incrementing a stat counter.  The table is terminated by an entry
>   *	specifying mask 0.  Returns the number of fatal interrupt conditions.
> @@ -2783,7 +2783,7 @@ static void init_mtus(unsigned short mtus[])
>  {
>  	/*
>  	 * See draft-mathis-plpmtud-00.txt for the values.  The min is 88 so
> -	 * it can accomodate max size TCP/IP headers when SACK and timestamps
> +	 * it can accommodate max size TCP/IP headers when SACK and timestamps
>  	 * are enabled and still have at least 8 bytes of payload.
>  	 */
>  	mtus[0] = 88;
> diff --git a/drivers/net/cxgb4/t4_hw.c b/drivers/net/cxgb4/t4_hw.c
> index b9fd8a6..d1ec111 100644
> --- a/drivers/net/cxgb4/t4_hw.c
> +++ b/drivers/net/cxgb4/t4_hw.c
> @@ -883,7 +883,7 @@ struct intr_info {
>   *
>   *	A table driven interrupt handler that applies a set of masks to an
>   *	interrupt status word and performs the corresponding actions if the
> - *	interrupts described by the mask have occured.  The actions include
> + *	interrupts described by the mask have occurred.  The actions include
>   *	optionally emitting a warning or alert message.  The table is terminated
>   *	by an entry specifying mask 0.  Returns the number of fatal interrupt
>   *	conditions.
> diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
> index 2a628d1..ee8ec73 100644
> --- a/drivers/net/davinci_emac.c
> +++ b/drivers/net/davinci_emac.c
> @@ -1013,7 +1013,7 @@ static void emac_rx_handler(void *token, int len, int status)
>  		return;
>  	}
>  
> -	/* recycle on recieve error */
> +	/* recycle on receive error */
>  	if (status < 0) {
>  		ndev->stats.rx_errors++;
>  		goto recycle;
> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> index 3065870..c605a98 100644
> --- a/drivers/net/e1000e/netdev.c
> +++ b/drivers/net/e1000e/netdev.c
> @@ -4853,7 +4853,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
>  	if (skb->protocol == htons(ETH_P_IP))
>  		tx_flags |= E1000_TX_FLAGS_IPV4;
>  
> -	/* if count is 0 then mapping error has occured */
> +	/* if count is 0 then mapping error has occurred */
>  	count = e1000_tx_map(adapter, skb, first, max_per_txd, nr_frags, mss);
>  	if (count) {
>  		e1000_tx_queue(adapter, tx_flags, count);
> diff --git a/drivers/net/fec.h b/drivers/net/fec.h
> index ace318d..3802949 100644
> --- a/drivers/net/fec.h
> +++ b/drivers/net/fec.h
> @@ -97,7 +97,7 @@ struct bufdesc {
>   *	The following definitions courtesy of commproc.h, which where
>   *	Copyright (c) 1997 Dan Malek (dmalek@jlc.net).
>   */
> -#define BD_SC_EMPTY     ((ushort)0x8000)        /* Recieve is empty */
> +#define BD_SC_EMPTY     ((ushort)0x8000)        /* Receive is empty */
>  #define BD_SC_READY     ((ushort)0x8000)        /* Transmit is ready */
>  #define BD_SC_WRAP      ((ushort)0x2000)        /* Last buffer descriptor */
>  #define BD_SC_INTRPT    ((ushort)0x1000)        /* Interrupt on change */
> diff --git a/drivers/net/ibm_newemac/tah.c b/drivers/net/ibm_newemac/tah.c
> index 299aa49..02b1d7c 100644
> --- a/drivers/net/ibm_newemac/tah.c
> +++ b/drivers/net/ibm_newemac/tah.c
> @@ -60,7 +60,7 @@ void tah_reset(struct platform_device *ofdev)
>  		printk(KERN_ERR "%s: reset timeout\n",
>  			ofdev->dev.of_node->full_name);
>  
> -	/* 10KB TAH TX FIFO accomodates the max MTU of 9000 */
> +	/* 10KB TAH TX FIFO accommodates the max MTU of 9000 */
>  	out_be32(&p->mr,
>  		 TAH_MR_CVR | TAH_MR_ST_768 | TAH_MR_TFS_10KB | TAH_MR_DTFP |
>  		 TAH_MR_DIG);
> diff --git a/drivers/net/igb/e1000_phy.c b/drivers/net/igb/e1000_phy.c
> index 6694bf3..d639706 100644
> --- a/drivers/net/igb/e1000_phy.c
> +++ b/drivers/net/igb/e1000_phy.c
> @@ -1421,7 +1421,7 @@ out:
>  }
>  
>  /**
> - *  igb_check_downshift - Checks whether a downshift in speed occured
> + *  igb_check_downshift - Checks whether a downshift in speed occurred
>   *  @hw: pointer to the HW structure
>   *
>   *  Success returns 0, Failure returns 1
> diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
> index 58c665b..25bcba4 100644
> --- a/drivers/net/igb/igb_main.c
> +++ b/drivers/net/igb/igb_main.c
> @@ -4198,7 +4198,7 @@ netdev_tx_t igb_xmit_frame_ring_adv(struct sk_buff *skb,
>  
>  	/*
>  	 * count reflects descriptors mapped, if 0 or less then mapping error
> -	 * has occured and we need to rewind the descriptor queue
> +	 * has occurred and we need to rewind the descriptor queue
>  	 */
>  	count = igb_tx_map_adv(tx_ring, skb, first);
>  	if (!count) {
> diff --git a/drivers/net/igbvf/netdev.c b/drivers/net/igbvf/netdev.c
> index 6352c81..219a2db 100644
> --- a/drivers/net/igbvf/netdev.c
> +++ b/drivers/net/igbvf/netdev.c
> @@ -2287,7 +2287,7 @@ static netdev_tx_t igbvf_xmit_frame_ring_adv(struct sk_buff *skb,
>  
>  	/*
>  	 * count reflects descriptors mapped, if 0 then mapping error
> -	 * has occured and we need to rewind the descriptor queue
> +	 * has occurred and we need to rewind the descriptor queue
>  	 */
>  	count = igbvf_tx_map_adv(adapter, tx_ring, skb, first);
>  
> diff --git a/drivers/net/ipg.c b/drivers/net/ipg.c
> index aa93655..650e843 100644
> --- a/drivers/net/ipg.c
> +++ b/drivers/net/ipg.c
> @@ -493,7 +493,7 @@ static int ipg_config_autoneg(struct net_device *dev)
>  	txflowcontrol = 0;
>  	rxflowcontrol = 0;
>  
> -	/* To accomodate a problem in 10Mbps operation,
> +	/* To accommodate a problem in 10Mbps operation,
>  	 * set a global flag if PHY running in 10Mbps mode.
>  	 */
>  	sp->tenmbpsmode = 0;
> @@ -1141,13 +1141,13 @@ static int ipg_nic_rx_check_error(struct net_device *dev)
>  
>  		/* Increment detailed receive error statistics. */
>  		if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXFIFOOVERRUN) {
> -			IPG_DEBUG_MSG("RX FIFO overrun occured.\n");
> +			IPG_DEBUG_MSG("RX FIFO overrun occurred.\n");
>  
>  			sp->stats.rx_fifo_errors++;
>  		}
>  
>  		if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXRUNTFRAME) {
> -			IPG_DEBUG_MSG("RX runt occured.\n");
> +			IPG_DEBUG_MSG("RX runt occurred.\n");
>  			sp->stats.rx_length_errors++;
>  		}
>  
> @@ -1156,7 +1156,7 @@ static int ipg_nic_rx_check_error(struct net_device *dev)
>  		 */
>  
>  		if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXALIGNMENTERROR) {
> -			IPG_DEBUG_MSG("RX alignment error occured.\n");
> +			IPG_DEBUG_MSG("RX alignment error occurred.\n");
>  			sp->stats.rx_frame_errors++;
>  		}
>  
> @@ -1421,12 +1421,12 @@ static int ipg_nic_rx(struct net_device *dev)
>  
>  			/* Increment detailed receive error statistics. */
>  			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXFIFOOVERRUN) {
> -				IPG_DEBUG_MSG("RX FIFO overrun occured.\n");
> +				IPG_DEBUG_MSG("RX FIFO overrun occurred.\n");
>  				sp->stats.rx_fifo_errors++;
>  			}
>  
>  			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXRUNTFRAME) {
> -				IPG_DEBUG_MSG("RX runt occured.\n");
> +				IPG_DEBUG_MSG("RX runt occurred.\n");
>  				sp->stats.rx_length_errors++;
>  			}
>  
> @@ -1436,7 +1436,7 @@ static int ipg_nic_rx(struct net_device *dev)
>  			 */
>  
>  			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXALIGNMENTERROR) {
> -				IPG_DEBUG_MSG("RX alignment error occured.\n");
> +				IPG_DEBUG_MSG("RX alignment error occurred.\n");
>  				sp->stats.rx_frame_errors++;
>  			}
>  
> @@ -1460,7 +1460,7 @@ static int ipg_nic_rx(struct net_device *dev)
>  			}
>  		} else {
>  
> -			/* Adjust the new buffer length to accomodate the size
> +			/* Adjust the new buffer length to accommodate the size
>  			 * of the received frame.
>  			 */
>  			skb_put(skb, framelen);
> @@ -1886,7 +1886,7 @@ static netdev_tx_t ipg_nic_hard_start_xmit(struct sk_buff *skb,
>  	/* Request TxComplete interrupts at an interval defined
>  	 * by the constant IPG_FRAMESBETWEENTXCOMPLETES.
>  	 * Request TxComplete interrupt for every frame
> -	 * if in 10Mbps mode to accomodate problem with 10Mbps
> +	 * if in 10Mbps mode to accommodate problem with 10Mbps
>  	 * processing.
>  	 */
>  	if (sp->tenmbpsmode)
> @@ -2100,7 +2100,7 @@ static int ipg_nic_change_mtu(struct net_device *dev, int new_mtu)
>  	struct ipg_nic_private *sp = netdev_priv(dev);
>  	int err;
>  
> -	/* Function to accomodate changes to Maximum Transfer Unit
> +	/* Function to accommodate changes to Maximum Transfer Unit
>  	 * (or MTU) of IPG NIC. Cannot use default function since
>  	 * the default will not allow for MTU > 1500 bytes.
>  	 */
> diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
> index f81d944..174cafa 100644
> --- a/drivers/net/irda/donauboe.c
> +++ b/drivers/net/irda/donauboe.c
> @@ -56,7 +56,7 @@
>  /* do_probe module parameter Enable this code */
>  /* Probe code is very useful for understanding how the hardware works */
>  /* Use it with various combinations of TT_LEN, RX_LEN */
> -/* Strongly recomended, disable if the probe fails on your machine */
> +/* Strongly recommended, disable if the probe fails on your machine */
>  /* and send me <james@fishsoup.dhs.org> the output of dmesg */
>  #define USE_PROBE 1
>  #undef  USE_PROBE
> diff --git a/drivers/net/irda/mcs7780.c b/drivers/net/irda/mcs7780.c
> index cc821de..a5810d6 100644
> --- a/drivers/net/irda/mcs7780.c
> +++ b/drivers/net/irda/mcs7780.c
> @@ -588,7 +588,7 @@ static int mcs_speed_change(struct mcs_cb *mcs)
>  
>  	mcs_get_reg(mcs, MCS_MODE_REG, &rval);
>  
> -	/* MINRXPW values recomended by MosChip */
> +	/* MINRXPW values recommended by MosChip */
>  	if (mcs->new_speed <= 115200) {
>  		rval &= ~MCS_FIR;
>  
> diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
> index c192c31..001ed0a 100644
> --- a/drivers/net/irda/pxaficp_ir.c
> +++ b/drivers/net/irda/pxaficp_ir.c
> @@ -40,7 +40,7 @@
>  
>  #define ICCR0_AME	(1 << 7)	/* Address match enable */
>  #define ICCR0_TIE	(1 << 6)	/* Transmit FIFO interrupt enable */
> -#define ICCR0_RIE	(1 << 5)	/* Recieve FIFO interrupt enable */
> +#define ICCR0_RIE	(1 << 5)	/* Receive FIFO interrupt enable */
>  #define ICCR0_RXE	(1 << 4)	/* Receive enable */
>  #define ICCR0_TXE	(1 << 3)	/* Transmit enable */
>  #define ICCR0_TUS	(1 << 2)	/* Transmit FIFO underrun select */
> @@ -483,7 +483,7 @@ static irqreturn_t pxa_irda_fir_irq(int irq, void *dev_id)
>  	}
>  
>  	if (icsr0 & ICSR0_EIF) {
> -		/* An error in FIFO occured, or there is a end of frame */
> +		/* An error in FIFO occurred, or there is a end of frame */
>  		pxa_irda_fir_irq_eif(si, dev, icsr0);
>  	}
>  
> diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
> index 67c0ad4..272b7f5 100644
> --- a/drivers/net/irda/via-ircc.c
> +++ b/drivers/net/irda/via-ircc.c
> @@ -246,7 +246,7 @@ static int __devinit via_init_one (struct pci_dev *pcidev, const struct pci_devi
>  			FirIRQ = bTmp1 & 0x0f;
>  
>  			pci_read_config_byte(pcidev,0x69,&bTmp);
> -			FirIOBase = bTmp << 8;//hight byte
> +			FirIOBase = bTmp << 8;//high byte
>  			pci_read_config_byte(pcidev,0x68,&bTmp);
>  			FirIOBase = (FirIOBase | bTmp ) & 0xfff0;
>    //-------------------------
> diff --git a/drivers/net/ixgbe/ixgbe_phy.c b/drivers/net/ixgbe/ixgbe_phy.c
> index 8f7123e..99024ca 100644
> --- a/drivers/net/ixgbe/ixgbe_phy.c
> +++ b/drivers/net/ixgbe/ixgbe_phy.c
> @@ -1430,7 +1430,7 @@ s32 ixgbe_get_phy_firmware_version_generic(struct ixgbe_hw *hw,
>  }
>  
>  /**
> - *  ixgbe_tn_check_overtemp - Checks if an overtemp occured.
> + *  ixgbe_tn_check_overtemp - Checks if an overtemp occurred.
>   *  @hw: pointer to hardware structure
>   *
>   *  Checks if the LASI temp alarm status was triggered due to overtemp
> diff --git a/drivers/net/mlx4/en_ethtool.c b/drivers/net/mlx4/en_ethtool.c
> index 056152b..5847097 100644
> --- a/drivers/net/mlx4/en_ethtool.c
> +++ b/drivers/net/mlx4/en_ethtool.c
> @@ -111,7 +111,7 @@ static const char main_strings[][ETH_GSTRING_LEN] = {
>  #define NUM_ALL_STATS	(NUM_MAIN_STATS + NUM_PORT_STATS + NUM_PKT_STATS + NUM_PERF_STATS)
>  
>  static const char mlx4_en_test_names[][ETH_GSTRING_LEN]= {
> -	"Interupt Test",
> +	"Interrupt Test",
>  	"Link Test",
>  	"Speed Test",
>  	"Register Test",
> diff --git a/drivers/net/mlx4/en_rx.c b/drivers/net/mlx4/en_rx.c
> index 570f250..44f84e6 100644
> --- a/drivers/net/mlx4/en_rx.c
> +++ b/drivers/net/mlx4/en_rx.c
> @@ -706,8 +706,8 @@ int mlx4_en_poll_rx_cq(struct napi_struct *napi, int budget)
>  }
>  
>  
> -/* Calculate the last offset position that accomodates a full fragment
> - * (assuming fagment size = stride-align) */
> +/* Calculate the last offset position that accommodates a full fragment
> + * (assuming fragment size = stride-align) */
>  static int mlx4_en_last_alloc_offset(struct mlx4_en_priv *priv, u16 stride, u16 align)
>  {
>  	u16 res = MLX4_EN_ALLOC_SIZE % stride;
> diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
> index 2fd3963..ae8067d 100644
> --- a/drivers/net/natsemi.c
> +++ b/drivers/net/natsemi.c
> @@ -203,7 +203,7 @@ skbuff at an offset of "+2", 16-byte aligning the IP header.
>  IIId. Synchronization
>  
>  Most operations are synchronized on the np->lock irq spinlock, except the
> -recieve and transmit paths which are synchronised using a combination of
> +receive and transmit paths which are synchronised using a combination of
>  hardware descriptor ownership, disabling interrupts and NAPI poll scheduling.
>  
>  IVb. References
> diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
> index a1b82c9..3847fac 100644
> --- a/drivers/net/ppp_async.c
> +++ b/drivers/net/ppp_async.c
> @@ -546,7 +546,7 @@ ppp_async_encode(struct asyncppp *ap)
>  	proto = get_unaligned_be16(data);
>  
>  	/*
> -	 * LCP packets with code values between 1 (configure-reqest)
> +	 * LCP packets with code values between 1 (configure-request)
>  	 * and 7 (code-reject) must be sent as though no options
>  	 * had been negotiated.
>  	 */
> diff --git a/drivers/net/pxa168_eth.c b/drivers/net/pxa168_eth.c
> index 1b63c8a..c97be3d 100644
> --- a/drivers/net/pxa168_eth.c
> +++ b/drivers/net/pxa168_eth.c
> @@ -1235,7 +1235,7 @@ static int pxa168_rx_poll(struct napi_struct *napi, int budget)
>  		handle_link_event(pep);
>  	}
>  	/*
> -	 * We call txq_reclaim every time since in NAPI interupts are disabled
> +	 * We call txq_reclaim every time since in NAPI interrupts are disabled
>  	 * and due to this we miss the TX_DONE interrupt,which is not updated in
>  	 * interrupt status register.
>  	 */
> diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
> index 39c17ce..5591ce7 100644
> --- a/drivers/net/s2io.c
> +++ b/drivers/net/s2io.c
> @@ -3563,7 +3563,7 @@ static void s2io_reset(struct s2io_nic *sp)
>  	}
>  
>  	/*
> -	 * Clear spurious ECC interrupts that would have occured on
> +	 * Clear spurious ECC interrupts that would have occurred on
>  	 * XFRAME II cards after reset.
>  	 */
>  	if (sp->device_type == XFRAME_II_DEVICE) {
> diff --git a/drivers/net/sfc/mcdi_pcol.h b/drivers/net/sfc/mcdi_pcol.h
> index 90359e6..4379ff2 100644
> --- a/drivers/net/sfc/mcdi_pcol.h
> +++ b/drivers/net/sfc/mcdi_pcol.h
> @@ -48,8 +48,8 @@
>   *               \------------------------------ Resync (always set)
>   *
>   * The client writes it's request into MC shared memory, and rings the
> - * doorbell. Each request is completed by either by the MC writting
> - * back into shared memory, or by writting out an event.
> + * doorbell. Each request is completed by either by the MC writing
> + * back into shared memory, or by writing out an event.
>   *
>   * All MCDI commands support completion by shared memory response. Each
>   * request may also contain additional data (accounted for by HEADER.LEN),
> diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
> index 3406ed8..b436e00 100644
> --- a/drivers/net/sis190.c
> +++ b/drivers/net/sis190.c
> @@ -93,7 +93,7 @@ enum sis190_registers {
>  	IntrStatus		= 0x20,
>  	IntrMask		= 0x24,
>  	IntrControl		= 0x28,
> -	IntrTimer		= 0x2c,	// unused (Interupt Timer)
> +	IntrTimer		= 0x2c,	// unused (Interrupt Timer)
>  	PMControl		= 0x30,	// unused (Power Mgmt Control/Status)
>  	rsv2			= 0x34,	// reserved
>  	ROMControl		= 0x38,
> @@ -234,7 +234,7 @@ enum _DescStatusBit {
>  	RxSizeMask	= 0x0000ffff
>  	/*
>  	 * The asic could apparently do vlan, TSO, jumbo (sis191 only) and
> -	 * provide two (unused with Linux) Tx queues. No publically
> +	 * provide two (unused with Linux) Tx queues. No publicly
>  	 * available documentation alas.
>  	 */
>  };
> diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
> index 640e368..b7adfbb 100644
> --- a/drivers/net/sis900.c
> +++ b/drivers/net/sis900.c
> @@ -1650,7 +1650,7 @@ static irqreturn_t sis900_interrupt(int irq, void *dev_instance)
>  		status = inl(ioaddr + isr);
>  
>  		if ((status & (HIBERR|TxURN|TxERR|TxIDLE|RxORN|RxERR|RxOK)) == 0)
> -			/* nothing intresting happened */
> +			/* nothing interesting happened */
>  			break;
>  		handled = 1;
>  
> @@ -1723,7 +1723,7 @@ static int sis900_rx(struct net_device *net_dev)
>  		rx_size = data_size - CRC_SIZE;
>  
>  #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
> -		/* ``TOOLONG'' flag means jumbo packet recived. */
> +		/* ``TOOLONG'' flag means jumbo packet received. */
>  		if ((rx_status & TOOLONG) && data_size <= MAX_FRAME_SIZE)
>  			rx_status &= (~ ((unsigned int)TOOLONG));
>  #endif
> diff --git a/drivers/net/skge.h b/drivers/net/skge.h
> index 507addc..51c0214 100644
> --- a/drivers/net/skge.h
> +++ b/drivers/net/skge.h
> @@ -1038,7 +1038,7 @@ enum {
>  
>  	PHY_ST_PRE_SUP	= 1<<6, /* Bit  6:	Preamble Suppression */
>  	PHY_ST_AN_OVER	= 1<<5, /* Bit  5:	Auto-Negotiation Over */
> -	PHY_ST_REM_FLT	= 1<<4, /* Bit  4:	Remote Fault Condition Occured */
> +	PHY_ST_REM_FLT	= 1<<4, /* Bit  4:	Remote Fault Condition Occurred */
>  	PHY_ST_AN_CAP	= 1<<3, /* Bit  3:	Auto-Negotiation Capability */
>  	PHY_ST_LSYNC	= 1<<2, /* Bit  2:	Link Synchronized */
>  	PHY_ST_JAB_DET	= 1<<1, /* Bit  1:	Jabber Detected */
> @@ -1721,8 +1721,8 @@ enum {
>  	GM_GPSR_LINK_UP		= 1<<12, /* Bit 12:	Link Up Status */
>  	GM_GPSR_PAUSE		= 1<<11, /* Bit 11:	Pause State */
>  	GM_GPSR_TX_ACTIVE	= 1<<10, /* Bit 10:	Tx in Progress */
> -	GM_GPSR_EXC_COL		= 1<<9,	/* Bit  9:	Excessive Collisions Occured */
> -	GM_GPSR_LAT_COL		= 1<<8,	/* Bit  8:	Late Collisions Occured */
> +	GM_GPSR_EXC_COL		= 1<<9,	/* Bit  9:	Excessive Collisions Occurred */
> +	GM_GPSR_LAT_COL		= 1<<8,	/* Bit  8:	Late Collisions Occurred */
>  
>  	GM_GPSR_PHY_ST_CH	= 1<<5,	/* Bit  5:	PHY Status Change */
>  	GM_GPSR_GIG_SPEED	= 1<<4,	/* Bit  4:	Gigabit Speed (1 = 1000 Mbps) */
> @@ -2227,7 +2227,7 @@ enum {
>  	XM_ST_BC	= 1<<7,		/* Bit  7:	Broadcast packet */
>  	XM_ST_MC	= 1<<6,		/* Bit  6:	Multicast packet */
>  	XM_ST_UC	= 1<<5,		/* Bit  5:	Unicast packet */
> -	XM_ST_TX_UR	= 1<<4,		/* Bit  4:	FIFO Underrun occured */
> +	XM_ST_TX_UR	= 1<<4,		/* Bit  4:	FIFO Underrun occurred */
>  	XM_ST_CS_ERR	= 1<<3,		/* Bit  3:	Carrier Sense Error */
>  	XM_ST_LAT_COL	= 1<<2,		/* Bit  2:	Late Collision Error */
>  	XM_ST_MUL_COL	= 1<<1,		/* Bit  1:	Multiple Collisions */
> diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
> index 7d85a38..ec77231 100644
> --- a/drivers/net/sky2.c
> +++ b/drivers/net/sky2.c
> @@ -1972,7 +1972,7 @@ static void sky2_hw_down(struct sky2_port *sky2)
>  
>  	sky2_write8(hw, SK_REG(port, RX_GMF_CTRL_T), GMF_RST_SET);
>  
> -	/* Force any delayed status interrrupt and NAPI */
> +	/* Force any delayed status interrupt and NAPI */
>  	sky2_write32(hw, STAT_LEV_TIMER_CNT, 0);
>  	sky2_write32(hw, STAT_TX_TIMER_CNT, 0);
>  	sky2_write32(hw, STAT_ISR_TIMER_CNT, 0);
> diff --git a/drivers/net/sky2.h b/drivers/net/sky2.h
> index 6861b0e..0c6d10c 100644
> --- a/drivers/net/sky2.h
> +++ b/drivers/net/sky2.h
> @@ -1194,7 +1194,7 @@ enum {
>  
>  	PHY_ST_PRE_SUP	= 1<<6, /* Bit  6:	Preamble Suppression */
>  	PHY_ST_AN_OVER	= 1<<5, /* Bit  5:	Auto-Negotiation Over */
> -	PHY_ST_REM_FLT	= 1<<4, /* Bit  4:	Remote Fault Condition Occured */
> +	PHY_ST_REM_FLT	= 1<<4, /* Bit  4:	Remote Fault Condition Occurred */
>  	PHY_ST_AN_CAP	= 1<<3, /* Bit  3:	Auto-Negotiation Capability */
>  	PHY_ST_LSYNC	= 1<<2, /* Bit  2:	Link Synchronized */
>  	PHY_ST_JAB_DET	= 1<<1, /* Bit  1:	Jabber Detected */
> @@ -1725,8 +1725,8 @@ enum {
>  	GM_GPSR_LINK_UP		= 1<<12, /* Bit 12:	Link Up Status */
>  	GM_GPSR_PAUSE		= 1<<11, /* Bit 11:	Pause State */
>  	GM_GPSR_TX_ACTIVE	= 1<<10, /* Bit 10:	Tx in Progress */
> -	GM_GPSR_EXC_COL		= 1<<9,	/* Bit  9:	Excessive Collisions Occured */
> -	GM_GPSR_LAT_COL		= 1<<8,	/* Bit  8:	Late Collisions Occured */
> +	GM_GPSR_EXC_COL		= 1<<9,	/* Bit  9:	Excessive Collisions Occurred */
> +	GM_GPSR_LAT_COL		= 1<<8,	/* Bit  8:	Late Collisions Occurred */
>  
>  	GM_GPSR_PHY_ST_CH	= 1<<5,	/* Bit  5:	PHY Status Change */
>  	GM_GPSR_GIG_SPEED	= 1<<4,	/* Bit  4:	Gigabit Speed (1 = 1000 Mbps) */
> diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
> index ee74791..d2593ab 100644
> --- a/drivers/net/smc91x.h
> +++ b/drivers/net/smc91x.h
> @@ -983,7 +983,7 @@ static const char * chip_ids[ 16 ] =  {
>   * Hack Alert: Some setups just can't write 8 or 16 bits reliably when not
>   * aligned to a 32 bit boundary.  I tell you that does exist!
>   * Fortunately the affected register accesses can be easily worked around
> - * since we can write zeroes to the preceeding 16 bits without adverse
> + * since we can write zeroes to the preceding 16 bits without adverse
>   * effects and use a 32-bit access.
>   *
>   * Enforce it on any 32-bit capable setup for now.
> diff --git a/drivers/net/smsc911x.c b/drivers/net/smsc911x.c
> index 64bfdae..d3150d9 100644
> --- a/drivers/net/smsc911x.c
> +++ b/drivers/net/smsc911x.c
> @@ -1664,7 +1664,7 @@ static int smsc911x_eeprom_send_cmd(struct smsc911x_data *pdata, u32 op)
>  	}
>  
>  	if (e2cmd & E2P_CMD_EPC_TIMEOUT_) {
> -		SMSC_TRACE(DRV, "Error occured during eeprom operation");
> +		SMSC_TRACE(DRV, "Error occurred during eeprom operation");
>  		return -EINVAL;
>  	}
>  
> diff --git a/drivers/net/smsc9420.c b/drivers/net/smsc9420.c
> index b09ee1c..4c92ad8 100644
> --- a/drivers/net/smsc9420.c
> +++ b/drivers/net/smsc9420.c
> @@ -364,7 +364,7 @@ static int smsc9420_eeprom_send_cmd(struct smsc9420_pdata *pd, u32 op)
>  	}
>  
>  	if (e2cmd & E2P_CMD_EPC_TIMEOUT_) {
> -		smsc_info(HW, "Error occured during eeprom operation");
> +		smsc_info(HW, "Error occurred during eeprom operation");
>  		return -EINVAL;
>  	}
>  
> diff --git a/drivers/net/tc35815.c b/drivers/net/tc35815.c
> index b6eec8c..3066df8 100644
> --- a/drivers/net/tc35815.c
> +++ b/drivers/net/tc35815.c
> @@ -125,7 +125,7 @@ struct tc35815_regs {
>  #define DMA_RxAlign_2	       0x00800000
>  #define DMA_RxAlign_3	       0x00c00000
>  #define DMA_M66EnStat	       0x00080000 /* 1:66MHz Enable State	     */
> -#define DMA_IntMask	       0x00040000 /* 1:Interupt mask		     */
> +#define DMA_IntMask	       0x00040000 /* 1:Interrupt mask		     */
>  #define DMA_SWIntReq	       0x00020000 /* 1:Software Interrupt request    */
>  #define DMA_TxWakeUp	       0x00010000 /* 1:Transmit Wake Up		     */
>  #define DMA_RxBigE	       0x00008000 /* 1:Receive Big Endian	     */
> @@ -157,7 +157,7 @@ struct tc35815_regs {
>  #define PROM_Read	       0x00004000 /*10:Read operation		     */
>  #define PROM_Write	       0x00002000 /*01:Write operation		     */
>  #define PROM_Erase	       0x00006000 /*11:Erase operation		     */
> -					  /*00:Enable or Disable Writting,   */
> +					  /*00:Enable or Disable Writing,   */
>  					  /*	  as specified in PROM_Addr. */
>  #define PROM_Addr_Ena	       0x00000030 /*11xxxx:PROM Write enable	     */
>  					  /*00xxxx:	      disable	     */
> @@ -310,7 +310,7 @@ struct BDesc {
>  #define FD_BDCnt_SHIFT	       16
>  
>  /* Buffer Descripter bit asign --------------------------------------------- */
> -#define BD_BuffLength_MASK     0x0000FFFF /* Recieve Data Size		     */
> +#define BD_BuffLength_MASK     0x0000FFFF /* Receive Data Size		     */
>  #define BD_RxBDID_MASK	       0x00FF0000 /* BD ID Number MASK		     */
>  #define BD_RxBDSeqN_MASK       0x7F000000 /* Rx BD Sequence Number	     */
>  #define BD_CownsBD	       0x80000000 /* BD Controller owner bit	     */
> @@ -339,7 +339,7 @@ struct BDesc {
>  #define TX_THRESHOLD	1024
>  /* used threshold with packet max byte for low pci transfer ability.*/
>  #define TX_THRESHOLD_MAX 1536
> -/* setting threshold max value when overrun error occured this count. */
> +/* setting threshold max value when overrun error occurred this count. */
>  #define TX_THRESHOLD_KEEP_LIMIT 10
>  
>  /* 16 + RX_BUF_NUM * 8 + RX_FD_NUM * 16 + TX_FD_NUM * 32 <= PAGE_SIZE*FD_PAGE_NUM */
> diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
> index 3397618..df6f1ce 100644
> --- a/drivers/net/tehuti.c
> +++ b/drivers/net/tehuti.c
> @@ -275,7 +275,7 @@ static irqreturn_t bdx_isr_napi(int irq, void *dev)
>  			 * currently intrs are disabled (since we read ISR),
>  			 * and we have failed to register next poll.
>  			 * so we read the regs to trigger chip
> -			 * and allow further interupts. */
> +			 * and allow further interrupts. */
>  			READ_REG(priv, regTXF_WPTR_0);
>  			READ_REG(priv, regRXD_WPTR_0);
>  		}
> @@ -1200,7 +1200,7 @@ static void bdx_recycle_skb(struct bdx_priv *priv, struct rxd_desc *rxdd)
>  	RET();
>  }
>  
> -/* bdx_rx_receive - recieves full packets from RXD fifo and pass them to OS
> +/* bdx_rx_receive - receives full packets from RXD fifo and pass them to OS
>   * NOTE: a special treatment is given to non-continous descriptors
>   * that start near the end, wraps around and continue at the beginning. a second
>   * part is copied right after the first, and then descriptor is interpreted as
> diff --git a/drivers/net/tokenring/olympic.c b/drivers/net/tokenring/olympic.c
> index 3d2fbe6..83ba265 100644
> --- a/drivers/net/tokenring/olympic.c
> +++ b/drivers/net/tokenring/olympic.c
> @@ -12,7 +12,7 @@
>   *      Director, National Security Agency.
>   *
>   *  Thanks to Erik De Cock, Adrian Bridgett and Frank Fiene for their 
> - *  assistance and perserverance with the testing of this driver.
> + *  assistance and perseverance with the testing of this driver.
>   *
>   *  This software may be used and distributed according to the terms
>   *  of the GNU General Public License, incorporated herein by reference.
> diff --git a/drivers/net/tsi108_eth.h b/drivers/net/tsi108_eth.h
> index 5a77ae6..5fee7d7 100644
> --- a/drivers/net/tsi108_eth.h
> +++ b/drivers/net/tsi108_eth.h
> @@ -305,9 +305,9 @@
>  #define TSI108_TX_CRC	(1 << 5)	/* Generate CRC for this packet */
>  #define TSI108_TX_INT	(1 << 14)	/* Generate an IRQ after frag. processed */
>  #define TSI108_TX_RETRY	(0xf << 16)	/* 4 bit field indicating num. of retries */
> -#define TSI108_TX_COL	(1 << 20)	/* Set if a collision occured */
> -#define TSI108_TX_LCOL	(1 << 24)	/* Set if a late collision occured */
> -#define TSI108_TX_UNDER	(1 << 25)	/* Set if a FIFO underrun occured */
> +#define TSI108_TX_COL	(1 << 20)	/* Set if a collision occurred */
> +#define TSI108_TX_LCOL	(1 << 24)	/* Set if a late collision occurred */
> +#define TSI108_TX_UNDER	(1 << 25)	/* Set if a FIFO underrun occurred */
>  #define TSI108_TX_RLIM	(1 << 26)	/* Set if the retry limit was reached */
>  #define TSI108_TX_OK	(1 << 30)	/* Set if the frame TX was successful */
>  #define TSI108_TX_OWN	(1 << 31)	/* Set if the device owns the descriptor */
> @@ -332,7 +332,7 @@ typedef struct {
>  #define TSI108_RX_RUNT	(1 << 4)/* Packet is less than minimum size */
>  #define TSI108_RX_HASH	(1 << 7)/* Hash table match */
>  #define TSI108_RX_BAD	(1 << 8)	/* Bad frame */
> -#define TSI108_RX_OVER	(1 << 9)	/* FIFO overrun occured */
> +#define TSI108_RX_OVER	(1 << 9)	/* FIFO overrun occurred */
>  #define TSI108_RX_TRUNC	(1 << 11)	/* Packet truncated due to excess length */
>  #define TSI108_RX_CRC	(1 << 12)	/* Packet had a CRC error */
>  #define TSI108_RX_INT	(1 << 13)	/* Generate an IRQ after frag. processed */
> diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> index dd8a4ad..b3e44aa 100644
> --- a/drivers/net/usb/rndis_host.c
> +++ b/drivers/net/usb/rndis_host.c
> @@ -325,7 +325,7 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
>  	 * For RX we handle drivers that zero-pad to end-of-packet.
>  	 * Don't let userspace change these settings.
>  	 *
> -	 * NOTE: there still seems to be wierdness here, as if we need
> +	 * NOTE: there still seems to be weirdness here, as if we need
>  	 * to do some more things to make sure WinCE targets accept this.
>  	 * They default to jumbograms of 8KB or 16KB, which is absurd
>  	 * for such low data rates and which is also more than Linux
> diff --git a/drivers/net/via-rhine.c b/drivers/net/via-rhine.c
> index 5e7f069..eb5d75d 100644
> --- a/drivers/net/via-rhine.c
> +++ b/drivers/net/via-rhine.c
> @@ -1861,7 +1861,7 @@ static void rhine_restart_tx(struct net_device *dev) {
>  	u32 intr_status;
>  
>  	/*
> -	 * If new errors occured, we need to sort them out before doing Tx.
> +	 * If new errors occurred, we need to sort them out before doing Tx.
>  	 * In that case the ISR will be back here RSN anyway.
>  	 */
>  	intr_status = get_intr_status(dev);
> @@ -1887,7 +1887,7 @@ static void rhine_restart_tx(struct net_device *dev) {
>  		/* This should never happen */
>  		if (debug > 1)
>  			printk(KERN_WARNING "%s: rhine_restart_tx() "
> -			       "Another error occured %8.8x.\n",
> +			       "Another error occurred %8.8x.\n",
>  			       dev->name, intr_status);
>  	}
>  
> diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
> index 09cac70..8145f32 100644
> --- a/drivers/net/via-velocity.c
> +++ b/drivers/net/via-velocity.c
> @@ -292,7 +292,7 @@ VELOCITY_PARAM(DMA_length, "DMA length");
>  /* IP_byte_align[] is used for IP header DWORD byte aligned
>     0: indicate the IP header won't be DWORD byte aligned.(Default) .
>     1: indicate the IP header will be DWORD byte aligned.
> -      In some enviroment, the IP header should be DWORD byte aligned,
> +      In some environment, the IP header should be DWORD byte aligned,
>        or the packet will be droped when we receive it. (eg: IPVS)
>  */
>  VELOCITY_PARAM(IP_byte_align, "Enable IP header dword aligned");
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index cc14b4a..ffcca1d 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -892,7 +892,7 @@ vmxnet3_prepare_tso(struct sk_buff *skb,
>   * Transmits a pkt thru a given tq
>   * Returns:
>   *    NETDEV_TX_OK:      descriptors are setup successfully
> - *    NETDEV_TX_OK:      error occured, the pkt is dropped
> + *    NETDEV_TX_OK:      error occurred, the pkt is dropped
>   *    NETDEV_TX_BUSY:    tx ring is full, queue is stopped
>   *
>   * Side-effects:
> diff --git a/drivers/net/vxge/vxge-config.h b/drivers/net/vxge/vxge-config.h
> index e249e28..16b9cf8 100644
> --- a/drivers/net/vxge/vxge-config.h
> +++ b/drivers/net/vxge/vxge-config.h
> @@ -1133,7 +1133,7 @@ struct __vxge_hw_non_offload_db_wrapper {
>   *             override the selection of the physical transmit port.
>   *             Attention:
>   *             Normal sounds as if learned from the switch rather than from
> - *             the aggregation algorythms.
> + *             the aggregation algorithms.
>   *             00: Normal. Use Destination/MAC Address
>   *             lookup to determine the transmit port.
>   *             01: Send on physical Port1.
> diff --git a/drivers/net/wan/lmc/lmc_var.h b/drivers/net/wan/lmc/lmc_var.h
> index 65d0197..0398500 100644
> --- a/drivers/net/wan/lmc/lmc_var.h
> +++ b/drivers/net/wan/lmc/lmc_var.h
> @@ -380,7 +380,7 @@ struct lmc___softc {
>  /* CSR6 settings */
>  #define OPERATION_MODE  0x00000200 /* Full Duplex      */
>  #define PROMISC_MODE    0x00000040 /* Promiscuous Mode */
> -#define RECIEVE_ALL     0x40000000 /* Recieve All      */
> +#define RECIEVE_ALL     0x40000000 /* Receive All      */
>  #define PASS_BAD_FRAMES 0x00000008 /* Pass Bad Frames  */
>  
>  /* Dec control registers  CSR6 as well */
> diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
> index 65bc334..f510ec7 100644
> --- a/drivers/net/wimax/i2400m/driver.c
> +++ b/drivers/net/wimax/i2400m/driver.c
> @@ -755,7 +755,7 @@ EXPORT_SYMBOL_GPL(i2400m_error_recovery);
>   * Alloc the command and ack buffers for boot mode
>   *
>   * Get the buffers needed to deal with boot mode messages.  These
> - * buffers need to be allocated before the sdio recieve irq is setup.
> + * buffers need to be allocated before the sdio receive irq is setup.
>   */
>  static
>  int i2400m_bm_buf_alloc(struct i2400m *i2400m)
> diff --git a/drivers/net/wimax/i2400m/i2400m-usb.h b/drivers/net/wimax/i2400m/i2400m-usb.h
> index eb80243..4a4f916 100644
> --- a/drivers/net/wimax/i2400m/i2400m-usb.h
> +++ b/drivers/net/wimax/i2400m/i2400m-usb.h
> @@ -112,7 +112,7 @@ static inline void edc_init(struct edc *edc)
>   *
>   * This is way to determine if the number of acceptable errors per time
>   * period has been exceeded. It is not accurate as there are cases in which
> - * this scheme will not work, for example if there are periodic occurences
> + * this scheme will not work, for example if there are periodic occurrences
>   * of errors that straddle updates to the start time. This scheme is
>   * sufficient for our usage.
>   *
> diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
> index 844133b..2f94a87 100644
> --- a/drivers/net/wimax/i2400m/rx.c
> +++ b/drivers/net/wimax/i2400m/rx.c
> @@ -349,7 +349,7 @@ error_no_waiter:
>   *
>   * For reports: We can't clone the original skb where the data is
>   * because we need to send this up via netlink; netlink has to add
> - * headers and we can't overwrite what's preceeding the payload...as
> + * headers and we can't overwrite what's preceding the payload...as
>   * it is another message. So we just dup them.
>   */
>  static
> @@ -425,7 +425,7 @@ error_check:
>   *
>   * As in i2400m_rx_ctl(), we can't clone the original skb where the
>   * data is because we need to send this up via netlink; netlink has to
> - * add headers and we can't overwrite what's preceeding the
> + * add headers and we can't overwrite what's preceding the
>   * payload...as it is another message. So we just dup them.
>   */
>  static
> diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
> index fd14b91..fa5c3bb 100644
> --- a/drivers/net/wireless/ath/ath5k/reg.h
> +++ b/drivers/net/wireless/ath/ath5k/reg.h
> @@ -283,7 +283,7 @@
>   */
>  #define AR5K_ISR		0x001c			/* Register Address [5210] */
>  #define AR5K_PISR		0x0080			/* Register Address [5211+] */
> -#define AR5K_ISR_RXOK		0x00000001	/* Frame successfuly recieved */
> +#define AR5K_ISR_RXOK		0x00000001	/* Frame successfuly received */
>  #define AR5K_ISR_RXDESC		0x00000002	/* RX descriptor request */
>  #define AR5K_ISR_RXERR		0x00000004	/* Receive error */
>  #define AR5K_ISR_RXNOFRM	0x00000008	/* No frame received (receive timeout) */
> @@ -377,7 +377,7 @@
>   */
>  #define	AR5K_IMR		0x0020			/* Register Address [5210] */
>  #define AR5K_PIMR		0x00a0			/* Register Address [5211+] */
> -#define AR5K_IMR_RXOK		0x00000001	/* Frame successfuly recieved*/
> +#define AR5K_IMR_RXOK		0x00000001	/* Frame successfuly received*/
>  #define AR5K_IMR_RXDESC		0x00000002	/* RX descriptor request*/
>  #define AR5K_IMR_RXERR		0x00000004	/* Receive error*/
>  #define AR5K_IMR_RXNOFRM	0x00000008	/* No frame received (receive timeout)*/
> diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
> index 2b14775..8e981a0 100644
> --- a/drivers/net/wireless/ath/regd.c
> +++ b/drivers/net/wireless/ath/regd.c
> @@ -261,7 +261,7 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
>  	}
>  
>  	/*
> -	 * If a country IE has been recieved check its rule for this
> +	 * If a country IE has been received check its rule for this
>  	 * channel first before enabling active scan. The passive scan
>  	 * would have been enforced by the initial processing of our
>  	 * custom regulatory domain.
> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
> index bd4cb75..ebc93c1 100644
> --- a/drivers/net/wireless/b43/b43.h
> +++ b/drivers/net/wireless/b43/b43.h
> @@ -648,8 +648,8 @@ struct b43_request_fw_context {
>  	char errors[B43_NR_FWTYPES][128];
>  	/* Temporary buffer for storing the firmware name. */
>  	char fwname[64];
> -	/* A fatal error occured while requesting. Firmware reqest
> -	 * can not continue, as any other reqest will also fail. */
> +	/* A fatal error occurred while requesting. Firmware request
> +	 * can not continue, as any other request will also fail. */
>  	int fatal_failure;
>  };
>  
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index ae438ed..3991b9d 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -8367,7 +8367,7 @@ static void ipw_handle_mgmt_packet(struct ipw_priv *priv,
>  /*
>   * Main entry function for recieving a packet with 80211 headers.  This
>   * should be called when ever the FW has notified us that there is a new
> - * skb in the recieve queue.
> + * skb in the receive queue.
>   */
>  static void ipw_rx(struct ipw_priv *priv)
>  {
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 698a1f7..d27230d 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -123,7 +123,7 @@ static u8 lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
>  
>  
>  /* Various firmware commands need the list of supported rates, but with
> -   the hight-bit set for basic rates */
> +   the high-bit set for basic rates */
>  static int lbs_add_rates(u8 *rates)
>  {
>  	size_t i;
> diff --git a/drivers/net/wireless/libertas/if_spi.h b/drivers/net/wireless/libertas/if_spi.h
> index 8b1417d..d2ac1dc 100644
> --- a/drivers/net/wireless/libertas/if_spi.h
> +++ b/drivers/net/wireless/libertas/if_spi.h
> @@ -66,7 +66,7 @@
>  #define IF_SPI_HOST_INT_CTRL_REG 0x40	/* Host interrupt controller reg */
>  
>  #define IF_SPI_CARD_INT_CAUSE_REG 0x44	/* Card interrupt cause reg */
> -#define IF_SPI_CARD_INT_STATUS_REG 0x48 /* Card interupt status reg */
> +#define IF_SPI_CARD_INT_STATUS_REG 0x48 /* Card interrupt status reg */
>  #define IF_SPI_CARD_INT_EVENT_MASK_REG 0x4C /* Card interrupt event mask */
>  #define IF_SPI_CARD_INT_STATUS_MASK_REG	0x50 /* Card interrupt status mask */
>  
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 4c55e85..42d768e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -594,7 +594,7 @@
>   * READ_CONTROL: 0 write BBP, 1 read BBP
>   * BUSY: ASIC is busy executing BBP commands
>   * BBP_PAR_DUR: 0 4 MAC clocks, 1 8 MAC clocks
> - * BBP_RW_MODE: 0 serial, 1 paralell
> + * BBP_RW_MODE: 0 serial, 1 parallel
>   */
>  #define BBP_CSR_CFG			0x101c
>  #define BBP_CSR_CFG_VALUE		FIELD32(0x000000ff)
> diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
> index bfda60e..4c0fc1f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00link.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00link.c
> @@ -283,7 +283,7 @@ void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
>  	/**
>  	 * While scanning, link tuning is disabled. By default
>  	 * the most sensitive settings will be used to make sure
> -	 * that all beacons and probe responses will be recieved
> +	 * that all beacons and probe responses will be received
>  	 * during the scan.
>  	 */
>  	if (test_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags))
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
> index fab8e26..a8e05b3 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
> @@ -337,7 +337,7 @@ struct txentry_desc {
>   *	only be touched after the device has signaled it is done with it.
>   * @ENTRY_DATA_PENDING: This entry contains a valid frame and is waiting
>   *	for the signal to start sending.
> - * @ENTRY_DATA_IO_FAILED: Hardware indicated that an IO error occured
> + * @ENTRY_DATA_IO_FAILED: Hardware indicated that an IO error occurred
>   *	while transfering the data to the hardware. No TX status report will
>   *	be expected from the hardware.
>   * @ENTRY_DATA_STATUS_PENDING: The entry has been send to the device and
> @@ -358,7 +358,7 @@ enum queue_entry_flags {
>   * @flags: Entry flags, see &enum queue_entry_flags.
>   * @queue: The data queue (&struct data_queue) to which this entry belongs.
>   * @skb: The buffer which is currently being transmitted (for TX queue),
> - *	or used to directly recieve data in (for RX queue).
> + *	or used to directly receive data in (for RX queue).
>   * @entry_idx: The entry index number.
>   * @priv_data: Private data belonging to this queue entry. The pointer
>   *	points to data specific to a particular driver and queue type.
> @@ -620,7 +620,7 @@ static inline int rt2x00queue_threshold(struct data_queue *queue)
>  }
>  
>  /**
> - * rt2x00queue_status_timeout - Check if a timeout occured for STATUS reports
> + * rt2x00queue_status_timeout - Check if a timeout occurred for STATUS reports
>   * @queue: Queue to check.
>   */
>  static inline int rt2x00queue_status_timeout(struct data_queue *queue)
> @@ -630,7 +630,7 @@ static inline int rt2x00queue_status_timeout(struct data_queue *queue)
>  }
>  
>  /**
> - * rt2x00queue_timeout - Check if a timeout occured for DMA transfers
> + * rt2x00queue_timeout - Check if a timeout occurred for DMA transfers
>   * @queue: Queue to check.
>   */
>  static inline int rt2x00queue_dma_timeout(struct data_queue *queue)
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index 1a9937d..5f79f72 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -420,7 +420,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue)
>  		/*
>  		 * Check if the driver is already done, otherwise we
>  		 * have to sleep a little while to give the driver/hw
> -		 * the oppurtunity to complete interrupt process itself.
> +		 * the opportunity to complete interrupt process itself.
>  		 */
>  		if (rt2x00queue_empty(queue))
>  			break;
> @@ -433,7 +433,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue)
>  
>  		/*
>  		 * Wait for a little while to give the driver
> -		 * the oppurtunity to recover itself.
> +		 * the opportunity to recover itself.
>  		 */
>  		msleep(10);
>  	}
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
> index 6aaf51f..e11c759 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
> @@ -400,7 +400,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue);
>   * @rt2x00dev: Pointer to &struct rt2x00_dev
>   *
>   * Check the health of the USB communication and determine
> - * if timeouts have occured. If this is the case, this function
> + * if timeouts have occurred. If this is the case, this function
>   * will reset all communication to restore functionality again.
>   */
>  void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev);
> diff --git a/drivers/net/wireless/rtlwifi/debug.h b/drivers/net/wireless/rtlwifi/debug.h
> index 08bdec2..116a946 100644
> --- a/drivers/net/wireless/rtlwifi/debug.h
> +++ b/drivers/net/wireless/rtlwifi/debug.h
> @@ -45,7 +45,7 @@
>  /*
>   *Abnormal, rare, or unexpeted cases.
>   *For example, Packet/IO Ctl canceled,
> - *device suprisely unremoved and so on.
> + *device surprisely unremoved and so on.
>   */
>  #define	DBG_WARNING			2
>  
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 1758d44..1473476 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -1506,7 +1506,7 @@ void rtl_pci_stop(struct ieee80211_hw *hw)
>  	u8 RFInProgressTimeOut = 0;
>  
>  	/*
> -	 *should before disable interrrupt&adapter
> +	 *should before disable interrupt&adapter
>  	 *and will do it immediately.
>  	 */
>  	set_hal_stop(rtlhal);
> diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
> index 3336ca9..d26f957 100644
> --- a/drivers/net/wireless/rtlwifi/regd.c
> +++ b/drivers/net/wireless/rtlwifi/regd.c
> @@ -179,7 +179,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
>  	}
>  
>  	/*
> -	 *If a country IE has been recieved check its rule for this
> +	 *If a country IE has been received check its rule for this
>  	 *channel first before enabling active scan. The passive scan
>  	 *would have been enforced by the initial processing of our
>  	 *custom regulatory domain.
> diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
> index 844b32b..6ffe027 100644
> --- a/drivers/net/wireless/wl12xx/io.h
> +++ b/drivers/net/wireless/wl12xx/io.h
> @@ -94,7 +94,7 @@ static inline int wl1271_translate_addr(struct wl1271 *wl, int addr)
>  	 * translated region.
>  	 *
>  	 * The translated regions occur next to each other in physical device
> -	 * memory, so just add the sizes of the preceeding address regions to
> +	 * memory, so just add the sizes of the preceding address regions to
>  	 * get the offset to the new region.
>  	 *
>  	 * Currently, only the two first regions are addressed, and the
> diff --git a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
> index 9e74eb1..ba0a0cc 100644
> --- a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
> +++ b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
> @@ -353,7 +353,7 @@ static int uw2453_init_hw(struct zd_rf *rf)
>  	};
>  
>  	static const u32 rv[] = {
> -		UW2453_REGWRITE(4, 0x2b),    /* configure reciever gain */
> +		UW2453_REGWRITE(4, 0x2b),    /* configure receiver gain */
>  		UW2453_REGWRITE(5, 0x19e4f), /* configure transmitter gain */
>  		UW2453_REGWRITE(6, 0xf81ad), /* enable RX/TX filter tuning */
>  		UW2453_REGWRITE(7, 0x3fffe), /* disable TX gain in test mode */
> diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
> index 1062b8f..a73ac67 100644
> --- a/drivers/parisc/pdc_stable.c
> +++ b/drivers/parisc/pdc_stable.c
> @@ -213,7 +213,7 @@ pdcspath_store(struct pdcspath_entry *entry)
>  
>  	/* addr, devpath and count must be word aligned */
>  	if (pdc_stable_write(entry->addr, devpath, sizeof(*devpath)) != PDC_OK) {
> -		printk(KERN_ERR "%s: an error occured when writing to PDC.\n"
> +		printk(KERN_ERR "%s: an error occurred when writing to PDC.\n"
>  				"It is likely that the Stable Storage data has been corrupted.\n"
>  				"Please check it carefully upon next reboot.\n", __func__);
>  		WARN_ON(1);
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index 8d62fb7..1664dd8 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -1178,7 +1178,7 @@ out_no_data:
>   *	******************************************
>   */
>  
> -/* GCC is not inlining extern inline function later overwriten to non-inline,
> +/* GCC is not inlining extern inline function later overwritten to non-inline,
>     so we use outlined_ variants here.  */
>  static const struct parport_operations parport_pc_ops = {
>  	.write_data	= parport_pc_write_data,
> diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
> index 8591f6a..b859d16 100644
> --- a/drivers/pnp/pnpbios/bioscalls.c
> +++ b/drivers/pnp/pnpbios/bioscalls.c
> @@ -219,7 +219,7 @@ void pnpbios_print_status(const char *module, u16 status)
>  		       module);
>  		break;
>  	case PNP_HARDWARE_ERROR:
> -		printk(KERN_ERR "PnPBIOS: %s: a hardware failure has occured\n",
> +		printk(KERN_ERR "PnPBIOS: %s: a hardware failure has occurred\n",
>  		       module);
>  		break;
>  	default:
> diff --git a/drivers/ps3/ps3-lpm.c b/drivers/ps3/ps3-lpm.c
> index 8000985..1e5c4c3 100644
> --- a/drivers/ps3/ps3-lpm.c
> +++ b/drivers/ps3/ps3-lpm.c
> @@ -919,7 +919,7 @@ EXPORT_SYMBOL_GPL(ps3_disable_pm);
>   * @offset: Offset in bytes from the start of the trace buffer.
>   * @buf: Copy destination.
>   * @count: Maximum count of bytes to copy.
> - * @bytes_copied: Pointer to a variable that will recieve the number of
> + * @bytes_copied: Pointer to a variable that will receive the number of
>   *  bytes copied to @buf.
>   *
>   * On error @buf will contain any successfully copied trace buffer data
> @@ -974,7 +974,7 @@ EXPORT_SYMBOL_GPL(ps3_lpm_copy_tb);
>   * @offset: Offset in bytes from the start of the trace buffer.
>   * @buf: A __user copy destination.
>   * @count: Maximum count of bytes to copy.
> - * @bytes_copied: Pointer to a variable that will recieve the number of
> + * @bytes_copied: Pointer to a variable that will receive the number of
>   *  bytes copied to @buf.
>   *
>   * On error @buf will contain any successfully copied trace buffer data
> diff --git a/drivers/ps3/ps3-sys-manager.c b/drivers/ps3/ps3-sys-manager.c
> index d37c445..1b98367 100644
> --- a/drivers/ps3/ps3-sys-manager.c
> +++ b/drivers/ps3/ps3-sys-manager.c
> @@ -80,7 +80,7 @@ static void __maybe_unused _dump_sm_header(
>   *
>   * Currently all messages received from the system manager are either
>   * (16 bytes header + 8 bytes payload = 24 bytes) or (16 bytes header
> - * + 16 bytes payload = 32 bytes).  This knowlege is used to simplify
> + * + 16 bytes payload = 32 bytes).  This knowledge is used to simplify
>   * the logic.
>   */
>  
> diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
> index a50391b..9aafcd9 100644
> --- a/drivers/rapidio/rio-scan.c
> +++ b/drivers/rapidio/rio-scan.c
> @@ -295,7 +295,7 @@ static int __devinit rio_add_device(struct rio_dev *rdev)
>  }
>  
>  /**
> - * rio_enable_rx_tx_port - enable input reciever and output transmitter of
> + * rio_enable_rx_tx_port - enable input receiver and output transmitter of
>   * given port
>   * @port: Master port associated with the RIO network
>   * @local: local=1 select local port otherwise a far device is reached
> diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> index a0c0196..5d59c76 100644
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -259,7 +259,7 @@ EXPORT_SYMBOL_GPL(rtc_update_irq_enable);
>   * @rtc: pointer to the rtc device
>   *
>   * This function is called when an AIE, UIE or PIE mode interrupt
> - * has occured (or been emulated).
> + * has occurred (or been emulated).
>   *
>   * Triggers the registered irq_task function callback.
>   */
> diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
> index 88ea52b..819bba4 100644
> --- a/drivers/rtc/rtc-sa1100.c
> +++ b/drivers/rtc/rtc-sa1100.c
> @@ -468,7 +468,7 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
>  	 * initialization is unknown and could in principle happen during
>  	 * normal processing.
>  	 *
> -	 * Notice that clearing bit 1 and 0 is accomplished by writting ONES to
> +	 * Notice that clearing bit 1 and 0 is accomplished by writing ONES to
>  	 * the corresponding bits in RTSR. */
>  	RTSR = RTSR_AL | RTSR_HZ;
>  
> diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
> index 1654a24..fb9e483 100644
> --- a/drivers/s390/block/dasd_3990_erp.c
> +++ b/drivers/s390/block/dasd_3990_erp.c
> @@ -2207,7 +2207,7 @@ dasd_3990_erp_inspect_32(struct dasd_ccw_req * erp, char *sense)
>   * DASD_3990_ERP_CONTROL_CHECK
>   *
>   * DESCRIPTION
> - *   Does a generic inspection if a control check occured and sets up
> + *   Does a generic inspection if a control check occurred and sets up
>   *   the related error recovery procedure
>   *
>   * PARAMETER
> @@ -2250,7 +2250,7 @@ dasd_3990_erp_inspect(struct dasd_ccw_req *erp)
>  	struct dasd_ccw_req *erp_new = NULL;
>  	char *sense;
>  
> -	/* if this problem occured on an alias retry on base */
> +	/* if this problem occurred on an alias retry on base */
>  	erp_new = dasd_3990_erp_inspect_alias(erp);
>  	if (erp_new)
>  		return erp_new;
> diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
> index 911822db..d6add2f 100644
> --- a/drivers/s390/char/tty3270.c
> +++ b/drivers/s390/char/tty3270.c
> @@ -1013,7 +1013,7 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
>  		}
>  	}
>  	if (highlight != TAX_RESET)
> -		flen += 3;	/* TO_SA to reset hightlight. */
> +		flen += 3;	/* TO_SA to reset highlight. */
>  	if (f_color != TAC_RESET)
>  		flen += 3;	/* TO_SA to reset color. */
>  	if (line->len < tp->view.cols)
> diff --git a/drivers/s390/cio/device_fsm.c b/drivers/s390/cio/device_fsm.c
> index a845695..ee2410d 100644
> --- a/drivers/s390/cio/device_fsm.c
> +++ b/drivers/s390/cio/device_fsm.c
> @@ -318,7 +318,7 @@ ccw_device_sense_id_done(struct ccw_device *cdev, int err)
>  
>  /**
>    * ccw_device_notify() - inform the device's driver about an event
> -  * @cdev: device for which an event occured
> +  * @cdev: device for which an event occurred
>    * @event: event that occurred
>    *
>    * Returns:
> diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
> index ce3a5c1..92ed052 100644
> --- a/drivers/s390/net/claw.c
> +++ b/drivers/s390/net/claw.c
> @@ -775,7 +775,7 @@ claw_irq_handler(struct ccw_device *cdev,
>  	case CLAW_START_WRITE:
>  		if (p_ch->irb->scsw.cmd.dstat & DEV_STAT_UNIT_CHECK) {
>  			dev_info(&cdev->dev,
> -				"%s: Unit Check Occured in "
> +				"%s: Unit Check Occurred in "
>  				"write channel\n", dev->name);
>  			clear_bit(0, (void *)&p_ch->IO_active);
>  			if (p_ch->irb->ecw[0] & 0x80) {
> diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
> index 8c921fc..2d60220 100644
> --- a/drivers/s390/net/ctcm_fsms.c
> +++ b/drivers/s390/net/ctcm_fsms.c
> @@ -184,7 +184,7 @@ static void ctcmpc_chx_resend(fsm_instance *, int, void *);
>  static void ctcmpc_chx_send_sweep(fsm_instance *fsm, int event, void *arg);
>  
>  /**
> - * Check return code of a preceeding ccw_device call, halt_IO etc...
> + * Check return code of a preceding ccw_device call, halt_IO etc...
>   *
>   * ch	:	The channel, the error belongs to.
>   * Returns the error code (!= 0) to inspect.
> diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
> index 3343824..040f721 100644
> --- a/drivers/scsi/3w-9xxx.h
> +++ b/drivers/scsi/3w-9xxx.h
> @@ -61,7 +61,7 @@ static twa_message_type twa_aen_table[] = {
>  	{0x0000, "AEN queue empty"},
>  	{0x0001, "Controller reset occurred"},
>  	{0x0002, "Degraded unit detected"},
> -	{0x0003, "Controller error occured"},
> +	{0x0003, "Controller error occurred"},
>  	{0x0004, "Background rebuild failed"},
>  	{0x0005, "Background rebuild done"},
>  	{0x0006, "Incomplete unit detected"},
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 081c6de..bfd618a 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -4544,7 +4544,7 @@ AscMemWordCopyPtrToLram(PortAddr iop_base, ushort s_addr,
>   * Copy 4 bytes to LRAM.
>   *
>   * The source data is assumed to be in little-endian order in memory
> - * and is maintained in little-endian order when writen to LRAM.
> + * and is maintained in little-endian order when written to LRAM.
>   */
>  static void
>  AscMemDWordCopyPtrToLram(PortAddr iop_base,
> diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
> index 3233bf5..4ae5a9b 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_core.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_core.c
> @@ -599,7 +599,7 @@ void
>  ahd_outw(struct ahd_softc *ahd, u_int port, u_int value)
>  {
>  	/*
> -	 * Write low byte first to accomodate registers
> +	 * Write low byte first to accommodate registers
>  	 * such as PRGMCNT where the order maters.
>  	 */
>  	ahd_outb(ahd, port, value & 0xFF);
> @@ -5651,7 +5651,7 @@ ahd_handle_msg_reject(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
>  
>  		/*
>  		 * Requeue all tagged commands for this target
> -		 * currently in our posession so they can be
> +		 * currently in our possession so they can be
>  		 * converted to untagged commands.
>  		 */
>  		ahd_search_qinfifo(ahd, SCB_GET_TARGET(ahd, scb),
> @@ -6245,7 +6245,7 @@ ahd_shutdown(void *arg)
>  /*
>   * Reset the controller and record some information about it
>   * that is only available just after a reset.  If "reinit" is
> - * non-zero, this reset occured after initial configuration
> + * non-zero, this reset occurred after initial configuration
>   * and the caller requests that the chip be fully reinitialized
>   * to a runable state.  Chip interrupts are *not* enabled after
>   * a reinitialization.  The caller must enable interrupts via
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
> index 3f5a542..aef8111 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
> @@ -4131,7 +4131,7 @@ ahc_handle_msg_reject(struct ahc_softc *ahc, struct ahc_devinfo *devinfo)
>  
>  		/*
>  		 * Requeue all tagged commands for this target
> -		 * currently in our posession so they can be
> +		 * currently in our possession so they can be
>  		 * converted to untagged commands.
>  		 */
>  		ahc_search_qinfifo(ahc, SCB_GET_TARGET(ahc, scb),
> @@ -4581,7 +4581,7 @@ ahc_shutdown(void *arg)
>  /*
>   * Reset the controller and record some information about it
>   * that is only available just after a reset.  If "reinit" is
> - * non-zero, this reset occured after initial configuration
> + * non-zero, this reset occurred after initial configuration
>   * and the caller requests that the chip be fully reinitialized
>   * to a runable state.  Chip interrupts are *not* enabled after
>   * a reinitialization.  The caller must enable interrupts via
> diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
> index 5218de4..fbd1dc2 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.h
> +++ b/drivers/scsi/be2iscsi/be_cmds.h
> @@ -877,7 +877,7 @@ struct be_all_if_id {
>  						 */
>  #define CXN_KILLED_PDU_SIZE_EXCEEDS_DSL 3	/* Connection got invalidated
>  						 * internally
> -						 * due to a recieved PDU
> +						 * due to a received PDU
>  						 * size > DSL
>  						 */
>  #define CXN_KILLED_BURST_LEN_MISMATCH   4	/* Connection got invalidated
> @@ -886,7 +886,7 @@ struct be_all_if_id {
>  						 * FBL/MBL.
>  						 */
>  #define CXN_KILLED_AHS_RCVD		5	/* Connection got invalidated
> -						 * internally due to a recieved
> +						 * internally due to a received
>  						 * PDU Hdr that has
>  						 * AHS */
>  #define CXN_KILLED_HDR_DIGEST_ERR	6	/* Connection got invalidated
> @@ -899,12 +899,12 @@ struct be_all_if_id {
>  						 * pdu hdr
>  						 */
>  #define CXN_KILLED_STALE_ITT_TTT_RCVD	8	/* Connection got invalidated
> -						 * internally due to a recieved
> +						 * internally due to a received
>  						 * ITT/TTT that does not belong
>  						 * to this Connection
>  						 */
>  #define CXN_KILLED_INVALID_ITT_TTT_RCVD 9	/* Connection got invalidated
> -						 * internally due to recieved
> +						 * internally due to received
>  						 * ITT/TTT value > Max
>  						 * Supported ITTs/TTTs
>  						 */
> @@ -936,21 +936,21 @@ struct be_all_if_id {
>  						 * index.
>  						 */
>  #define CXN_KILLED_OVER_RUN_RESIDUAL	16	/* Command got invalidated
> -						 * internally due to recived
> +						 * internally due to received
>  						 * command has residual
>  						 * over run bytes.
>  						 */
>  #define CXN_KILLED_UNDER_RUN_RESIDUAL	17	/* Command got invalidated
> -						 * internally due to recived
> +						 * internally due to received
>  						 * command has residual under
>  						 * run bytes.
>  						 */
>  #define CMD_KILLED_INVALID_STATSN_RCVD	18	/* Command got invalidated
> -						 * internally due to a recieved
> +						 * internally due to a received
>  						 * PDU has an invalid StatusSN
>  						 */
>  #define CMD_KILLED_INVALID_R2T_RCVD	19	/* Command got invalidated
> -						 * internally due to a recieved
> +						 * internally due to a received
>  						 * an R2T with some invalid
>  						 * fields in it
>  						 */
> @@ -973,7 +973,7 @@ struct be_all_if_id {
>  						 */
>  #define CMD_CXN_KILLED_INVALID_DATASN_RCVD 24	/* Command got invalidated
>  						 * internally due to a
> -						 * recieved PDU has an invalid
> +						 * received PDU has an invalid
>  						 * DataSN
>  						 */
>  #define CXN_INVALIDATE_NOTIFY		25	/* Connection invalidation
> diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
> index 648c841..56399be 100644
> --- a/drivers/scsi/bfa/bfa_defs_svc.h
> +++ b/drivers/scsi/bfa/bfa_defs_svc.h
> @@ -145,7 +145,7 @@ struct bfa_fw_io_stats_s {
>  	u32	ioh_data_oor_event;	/*  Data out of range */
>  	u32	ioh_ro_ooo_event;	/*  Relative offset out of range */
>  	u32	ioh_cpu_owned_event;	/*  IOH hit -iost owned by f/w */
> -	u32	ioh_unexp_frame_event;	/*  unexpected frame recieved
> +	u32	ioh_unexp_frame_event;	/*  unexpected frame received
>  						 *   count */
>  	u32	ioh_err_int;		/*  IOH error int during data-phase
>  						 *   for scsi write
> diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
> index 8e764fa..bf0067e 100644
> --- a/drivers/scsi/bfa/bfa_fc.h
> +++ b/drivers/scsi/bfa/bfa_fc.h
> @@ -315,7 +315,7 @@ struct fc_plogi_csp_s {
>  			query_dbc:1,
>  			hg_supp:1;
>  #endif
> -	__be16		rxsz;		/* recieve data_field size */
> +	__be16		rxsz;		/* receive data_field size */
>  	__be16		conseq;
>  	__be16		ro_bitmap;
>  	__be32		e_d_tov;
> diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
> index 1d34921..f8debef 100644
> --- a/drivers/scsi/bfa/bfa_svc.c
> +++ b/drivers/scsi/bfa/bfa_svc.c
> @@ -5022,7 +5022,7 @@ bfa_uf_start(struct bfa_s *bfa)
>  }
>  
>  /*
> - * Register handler for all unsolicted recieve frames.
> + * Register handler for all unsolicted receive frames.
>   *
>   * @param[in]	bfa		BFA instance
>   * @param[in]	ufrecv	receive handler function
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index 96505e3..b3012ba 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -173,7 +173,7 @@ void bnx2i_arm_cq_event_coalescing(struct bnx2i_endpoint *ep, u8 action)
>  
>  /**
>   * bnx2i_get_rq_buf - copy RQ buffer contents to driver buffer
> - * @conn:		iscsi connection on which RQ event occured
> + * @conn:		iscsi connection on which RQ event occurred
>   * @ptr:		driver buffer to which RQ buffer contents is to
>   *			be copied
>   * @len:		length of valid data inside RQ buf
> diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
> index c57d59d..d25f08a 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.h
> +++ b/drivers/scsi/cxgbi/libcxgbi.h
> @@ -263,9 +263,9 @@ struct cxgbi_skb_tx_cb {
>  enum cxgbi_skcb_flags {
>  	SKCBF_TX_NEED_HDR,	/* packet needs a header */
>  	SKCBF_RX_COALESCED,	/* received whole pdu */
> -	SKCBF_RX_HDR,		/* recieved pdu header */
> -	SKCBF_RX_DATA,		/* recieved pdu payload */
> -	SKCBF_RX_STATUS,	/* recieved ddp status */
> +	SKCBF_RX_HDR,		/* received pdu header */
> +	SKCBF_RX_DATA,		/* received pdu payload */
> +	SKCBF_RX_STATUS,	/* received ddp status */
>  	SKCBF_RX_DATA_DDPD,	/* pdu payload ddp'd */
>  	SKCBF_RX_HCRC_ERR,	/* header digest error */
>  	SKCBF_RX_DCRC_ERR,	/* data digest error */
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index b0f8523..f35c8ba 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -1774,7 +1774,7 @@ static void dc395x_handle_interrupt(struct AdapterCtlBlk *acb,
>  		dc395x_statev(acb, srb, &scsi_status);
>  
>  		/* 
> -		 * if there were any exception occured scsi_status
> +		 * if there were any exception occurred scsi_status
>  		 * will be modify to bus free phase new scsi_status
>  		 * transfer out from ... previous dc395x_statev
>  		 */
> diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
> index 625c6be..317a416 100644
> --- a/drivers/scsi/fcoe/libfcoe.c
> +++ b/drivers/scsi/fcoe/libfcoe.c
> @@ -1902,7 +1902,7 @@ static void fcoe_ctlr_vn_send(struct fcoe_ctlr *fip,
>   * fcoe_ctlr_vn_rport_callback - Event handler for rport events.
>   * @lport: The lport which is receiving the event
>   * @rdata: remote port private data
> - * @event: The event that occured
> + * @event: The event that occurred
>   *
>   * Locking Note:  The rport lock must not be held when calling this function.
>   */
> diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
> index 69b7aa5..643f6d5 100644
> --- a/drivers/scsi/fdomain.c
> +++ b/drivers/scsi/fdomain.c
> @@ -174,7 +174,7 @@
>   Future Domain sold DOS BIOS source for $250 and the UN*X driver source was
>   $750, but these required a non-disclosure agreement, so even if I could
>   have afforded them, they would *not* have been useful for writing this
> - publically distributable driver.  Future Domain technical support has
> + publicly distributable driver.  Future Domain technical support has
>   provided some information on the phone and have sent a few useful FAXs.
>   They have been much more helpful since they started to recognize that the
>   word "Linux" refers to an operating system :-).
> diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
> index 120a062..d969855 100644
> --- a/drivers/scsi/gdth.h
> +++ b/drivers/scsi/gdth.h
> @@ -895,7 +895,7 @@ typedef struct {
>          u8          ldr_no;                 /* log. drive no. */
>          u8          rw_attribs;             /* r/w attributes */
>          u8          cluster_type;           /* cluster properties */
> -        u8          media_changed;          /* Flag:MOUNT/UNMOUNT occured */
> +        u8          media_changed;          /* Flag:MOUNT/UNMOUNT occurred */
>          u32         start_sec;              /* start sector */
>      } hdr[MAX_LDRIVES];                         /* host drives */
>      struct {
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 9627d06..b637b55 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -1917,7 +1917,7 @@ static int int_initio_scsi_rst(struct initio_host * host)
>  }
>  
>  /**
> - *	int_initio_scsi_resel	-	Reselection occured
> + *	int_initio_scsi_resel	-	Reselection occurred
>   *	@host: InitIO host adapter
>   *
>   *	A SCSI reselection event has been signalled and the interrupt
> diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
> index c5a10f9..b4675ca 100644
> --- a/drivers/scsi/libfc/fc_lport.c
> +++ b/drivers/scsi/libfc/fc_lport.c
> @@ -163,7 +163,7 @@ static int fc_frame_drop(struct fc_lport *lport, struct fc_frame *fp)
>   * fc_lport_rport_callback() - Event handler for rport events
>   * @lport: The lport which is receiving the event
>   * @rdata: private remote port data
> - * @event: The event that occured
> + * @event: The event that occurred
>   *
>   * Locking Note: The rport lock should not be held when calling
>   *		 this function.
> @@ -770,7 +770,7 @@ EXPORT_SYMBOL(fc_lport_set_local_id);
>  
>  /**
>   * fc_lport_recv_flogi_req() - Receive a FLOGI request
> - * @lport: The local port that recieved the request
> + * @lport: The local port that received the request
>   * @rx_fp: The FLOGI frame
>   *
>   * A received FLOGI request indicates a point-to-point connection.
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index 0dd43bb..f7e281b 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -1929,7 +1929,7 @@ out:
>   * @rxxri: Receive exchange id
>   * @len: Number of data bytes
>   *
> - * This function allocates and posts a data buffer of sufficient size to recieve
> + * This function allocates and posts a data buffer of sufficient size to receive
>   * an unsolicted CT command.
>   **/
>  static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index bb01596..de988ef 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4467,7 +4467,7 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
>  	if ((vport->fc_flag & FC_RSCN_MODE) &&
>  	    !(vport->fc_flag & FC_NDISC_ACTIVE)) {
>  		if (lpfc_rscn_payload_check(vport, did)) {
> -			/* If we've already recieved a PLOGI from this NPort
> +			/* If we've already received a PLOGI from this NPort
>  			 * we don't need to try to discover it again.
>  			 */
>  			if (ndlp->nlp_flag & NLP_RCV_PLOGI)
> @@ -4483,7 +4483,7 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
>  		} else
>  			ndlp = NULL;
>  	} else {
> -		/* If we've already recieved a PLOGI from this NPort,
> +		/* If we've already received a PLOGI from this NPort,
>  		 * or we are already in the process of discovery on it,
>  		 * we don't need to try to discover it again.
>  		 */
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index a359d2b..319ec89 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -6414,7 +6414,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
>  			return IOCB_ERROR;
>  		}
>  		wqe->els_req.payload_len = xmit_len;
> -		/* Els_reguest64 has a TMO */
> +		/* Els_request64 has a TMO */
>  		bf_set(wqe_tmo, &wqe->els_req.wqe_com,
>  			iocbq->iocb.ulpTimeout);
>  		/* Need a VF for word 4 set the vf bit*/
> @@ -9589,7 +9589,7 @@ out:
>   * @cq: Pointer to the completion queue.
>   * @wcqe: Pointer to a completion queue entry.
>   *
> - * This routine process a slow-path work-queue or recieve queue completion queue
> + * This routine process a slow-path work-queue or receive queue completion queue
>   * entry.
>   *
>   * Return: true if work posted to worker thread, otherwise false.
> diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
> index 5ead128..7d40e2b 100644
> --- a/drivers/scsi/megaraid/mega_common.h
> +++ b/drivers/scsi/megaraid/mega_common.h
> @@ -11,7 +11,7 @@
>   *
>   * FILE		: mega_common.h
>   *
> - * Libaray of common routine used by all low-level megaraid drivers
> + * Library of common routine used by all low-level megaraid drivers
>   */
>  
>  #ifndef _MEGA_COMMON_H_
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> index 5708cb2..1febff2 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -3973,7 +3973,7 @@ megaraid_sysfs_get_ldmap_timeout(unsigned long data)
>   * NOTE: The commands issuance functionality is not generalized and
>   * implemented in context of "get ld map" command only. If required, the
>   * command issuance logical can be trivially pulled out and implemented as a
> - * standalone libary. For now, this should suffice since there is no other
> + * standalone library. For now, this should suffice since there is no other
>   * user of this interface.
>   *
>   * Return 0 on success.
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 9ead039..6e1e3be 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -926,7 +926,7 @@ _base_interrupt(int irq, void *bus_id)
>  }
>  
>  /**
> - * mpt2sas_base_release_callback_handler - clear interupt callback handler
> + * mpt2sas_base_release_callback_handler - clear interrupt callback handler
>   * @cb_idx: callback index
>   *
>   * Return nothing.
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> index e92b77a..cb93810 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> @@ -1860,7 +1860,7 @@ _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
>   *
>   * This allows ownership of the specified buffer to returned to the driver,
>   * allowing an application to read the buffer without fear that firmware is
> - * overwritting information in the buffer.
> + * overwriting information in the buffer.
>   */
>  static long
>  _ctl_diag_release(void __user *arg, enum block_state state)
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
> index 69916e4..12db44c 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
> @@ -383,7 +383,7 @@ struct mpt2_diag_query {
>   *
>   * This allows ownership of the specified buffer to returned to the driver,
>   * allowing an application to read the buffer without fear that firmware is
> - * overwritting information in the buffer.
> + * overwriting information in the buffer.
>   */
>  struct mpt2_diag_release {
>  	struct mpt2_ioctl_header hdr;
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 5ded3db..516e6f7 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -2944,7 +2944,7 @@ _scsih_tm_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
>   * @smid: system request message index
>   *
>   * This will check delayed target reset list, and feed the
> - * next reqeust.
> + * next request.
>   *
>   * Return 1 meaning mf should be freed from _base_interrupt
>   *        0 means the mf is freed from this function.
> @@ -2984,7 +2984,7 @@ _scsih_check_for_pending_tm(struct MPT2SAS_ADAPTER *ioc, u16 smid)
>   *
>   * This routine added to better handle cable breaker.
>   *
> - * This handles the case where driver recieves multiple expander
> + * This handles the case where driver receives multiple expander
>   * add and delete events in a single shot.  When there is a delete event
>   * the routine will void any pending add events waiting in the event queue.
>   *
> @@ -3248,7 +3248,7 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
>  /**
>   * _scsih_setup_eedp - setup MPI request for EEDP transfer
>   * @scmd: pointer to scsi command object
> - * @mpi_request: pointer to the SCSI_IO reqest message frame
> + * @mpi_request: pointer to the SCSI_IO request message frame
>   *
>   * Supporting protection 1 and 3.
>   *
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 321cf3a..672a6e8 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -928,7 +928,7 @@ static void _pmcraid_fire_command(struct pmcraid_cmd *cmd)
>  	unsigned long lock_flags;
>  
>  	/* Add this command block to pending cmd pool. We do this prior to
> -	 * writting IOARCB to ioarrin because IOA might complete the command
> +	 * writing IOARCB to ioarrin because IOA might complete the command
>  	 * by the time we are about to add it to the list. Response handler
>  	 * (isr/tasklet) looks for cmd block in the pending pending list.
>  	 */
> @@ -2536,7 +2536,7 @@ static void pmcraid_request_sense(struct pmcraid_cmd *cmd)
>  
>  	/* request sense might be called as part of error response processing
>  	 * which runs in tasklets context. It is possible that mid-layer might
> -	 * schedule queuecommand during this time, hence, writting to IOARRIN
> +	 * schedule queuecommand during this time, hence, writing to IOARRIN
>  	 * must be protect by host_lock
>  	 */
>  	pmcraid_send_cmd(cmd, pmcraid_erp_done,
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index 631fefc..f5ba09c 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -539,7 +539,7 @@ struct sts_entry_24xx {
>  	 * If DIF Error is set in comp_status, these additional fields are
>  	 * defined:
>  	 * &data[10] : uint8_t report_runt_bg[2];	- computed guard
> -	 * &data[12] : uint8_t actual_dif[8];		- DIF Data recieved
> +	 * &data[12] : uint8_t actual_dif[8];		- DIF Data received
>  	 * &data[20] : uint8_t expected_dif[8];		- DIF Data computed
>  	*/
>  };
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index d17ed9a..712518d 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -414,7 +414,7 @@ skip_rio:
>  				    "marked OFFLINE!\n");
>  				vha->flags.online = 0;
>  			} else {
> -				/* Check to see if MPI timeout occured */
> +				/* Check to see if MPI timeout occurred */
>  				if ((mbx & MBX_3) && (ha->flags.port0))
>  					set_bit(MPI_RESET_NEEDED,
>  					    &vha->dpc_flags);
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index e473e9f..f8e3669 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -303,7 +303,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
>  			    !test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
>  
>  				qla_printk(KERN_WARNING, ha,
> -				    "Mailbox command timeout occured. "
> +				    "Mailbox command timeout occurred. "
>  				    "Scheduling ISP " "abort. eeh_busy: 0x%x\n",
>  				    ha->flags.eeh_busy);
>  				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> @@ -321,7 +321,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
>  			    !test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
>  
>  				qla_printk(KERN_WARNING, ha,
> -				    "Mailbox command timeout occured. "
> +				    "Mailbox command timeout occurred. "
>  				    "Issuing ISP abort.\n");
>  
>  				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
> @@ -3792,7 +3792,7 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
>  	mcp->mb[20] = LSW(MSD(mreq->send_dma));
>  	mcp->mb[21] = MSW(MSD(mreq->send_dma));
>  
> -	/* recieve data address */
> +	/* receive data address */
>  	mcp->mb[16] = LSW(mreq->rcv_dma);
>  	mcp->mb[17] = MSW(mreq->rcv_dma);
>  	mcp->mb[6] = LSW(MSD(mreq->rcv_dma));
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index fdb96a3..306df74 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -2597,7 +2597,7 @@ qla82xx_calc_dsd_lists(uint16_t dsds)
>   * qla82xx_start_scsi() - Send a SCSI command to the ISP
>   * @sp: command to send to the ISP
>   *
> - * Returns non-zero if a failure occured, else zero.
> + * Returns non-zero if a failure occurred, else zero.
>   */
>  int
>  qla82xx_start_scsi(srb_t *sp)
> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
> index 2fc0045..c1ed697 100644
> --- a/drivers/scsi/qla4xxx/ql4_def.h
> +++ b/drivers/scsi/qla4xxx/ql4_def.h
> @@ -179,7 +179,7 @@ struct srb {
>  	uint16_t flags;		/* (1) Status flags. */
>  
>  #define SRB_DMA_VALID		BIT_3	/* DMA Buffer mapped. */
> -#define SRB_GOT_SENSE		BIT_4	/* sense data recieved. */
> +#define SRB_GOT_SENSE		BIT_4	/* sense data received. */
>  	uint8_t state;		/* (1) Status flags. */
>  
>  #define SRB_NO_QUEUE_STATE	 0	/* Request is in between states */
> diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
> index a2ed201..26a8a45 100644
> --- a/drivers/scsi/scsi_netlink.c
> +++ b/drivers/scsi/scsi_netlink.c
> @@ -499,7 +499,7 @@ scsi_netlink_init(void)
>  				SCSI_NL_GRP_CNT, scsi_nl_rcv_msg, NULL,
>  				THIS_MODULE);
>  	if (!scsi_nl_sock) {
> -		printk(KERN_ERR "%s: register of recieve handler failed\n",
> +		printk(KERN_ERR "%s: register of receive handler failed\n",
>  				__func__);
>  		netlink_unregister_notifier(&scsi_netlink_notifier);
>  		return;
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 998c01b..d15d021 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2378,7 +2378,7 @@ fc_flush_devloss(struct Scsi_Host *shost)
>   * fc_remove_host - called to terminate any fc_transport-related elements for a scsi host.
>   * @shost:	Which &Scsi_Host
>   *
> - * This routine is expected to be called immediately preceeding the
> + * This routine is expected to be called immediately preceding the
>   * a driver's call to scsi_remove_host().
>   *
>   * WARNING: A driver utilizing the fc_transport, which fails to call
> @@ -4120,7 +4120,7 @@ fc_bsg_remove(struct request_queue *q)
>  		/* drain all requests in the queue */
>  		while (1) {
>  			/* need the lock to fetch a request
> -			 * this may fetch the same reqeust as the previous pass
> +			 * this may fetch the same request as the previous pass
>  			 */
>  			req = blk_fetch_request(q);
>  			/* save requests in use and starved */
> diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
> index 71a1219..1bd740a 100644
> --- a/drivers/spi/amba-pl022.c
> +++ b/drivers/spi/amba-pl022.c
> @@ -1415,7 +1415,7 @@ static void do_polling_transfer(struct pl022 *pl022)
>  		       SSP_CR1(pl022->virtbase));
>  
>  		dev_dbg(&pl022->adev->dev, "polling transfer ongoing ...\n");
> -		/* FIXME: insert a timeout so we don't hang here indefinately */
> +		/* FIXME: insert a timeout so we don't hang here indefinitely */
>  		while (pl022->tx < pl022->tx_end || pl022->rx < pl022->rx_end)
>  			readwriter(pl022);
>  
> diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
> index db6d30c..1514435 100644
> --- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
> +++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
> @@ -280,7 +280,7 @@ static void FailureCallback(void *pContext, A_STATUS Status)
>  {
>      GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)pContext; 
>      
> -        /* target assertion occured */           
> +        /* target assertion occurred */           
>      NotifyTransportFailure(pProt, Status);  
>  }
>  
> @@ -502,7 +502,7 @@ static A_STATUS HCIUartMessagePending(void *pContext, A_UINT8 LookAheadBytes[],
>          
>      } while (FALSE);
>          
> -        /* check if we need to disable the reciever */
> +        /* check if we need to disable the receiver */
>      if (A_FAILED(status) || blockRecv) {
>          DevGMboxIRQAction(pProt->pDev, GMBOX_RECV_IRQ_DISABLE, PROC_IO_SYNC); 
>      }
> diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> index 126a36a..93adbb3 100644
> --- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> +++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> @@ -522,7 +522,7 @@ dbglog_parse_debug_logs(A_INT8 *datap, A_UINT32 len)
>  int
>  ar6000_dbglog_get_debug_logs(AR_SOFTC_T *ar)
>  {
> -    A_UINT32 data[8]; /* Should be able to accomodate struct dbglog_buf_s */
> +    A_UINT32 data[8]; /* Should be able to accommodate struct dbglog_buf_s */
>      A_UINT32 address;
>      A_UINT32 length;
>      A_UINT32 dropped;
> diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
> index 32909e2..c37d795 100644
> --- a/drivers/staging/bcm/Adapter.h
> +++ b/drivers/staging/bcm/Adapter.h
> @@ -412,7 +412,7 @@ struct _MINI_ADAPTER
>  
>  	// this to keep track of the Tx and Rx MailBox Registers.
>  	atomic_t		    CurrNumFreeTxDesc;
> -	// to keep track the no of byte recieved
> +	// to keep track the no of byte received
>  	USHORT				PrevNumRecvDescs;
>  	USHORT				CurrNumRecvDescs;
>  	UINT				u32TotalDSD;
> diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
> index 5ac4582..5dcf64e 100644
> --- a/drivers/staging/bcm/CmHost.c
> +++ b/drivers/staging/bcm/CmHost.c
> @@ -1107,7 +1107,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
>  	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  "u8TrafficIndicationPreference	: 0x%X",
>  		pstAddIndication->sfAuthorizedSet.u8TrafficIndicationPreference);
>  
> -	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Recieved		: 0x%X",pstAddIndication->sfAuthorizedSet.u8TotalClassifiers);
> +	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Received		: 0x%X",pstAddIndication->sfAuthorizedSet.u8TotalClassifiers);
>  
>  	nCurClassifierCnt = pstAddIndication->sfAuthorizedSet.u8TotalClassifiers;
>  
> @@ -1309,7 +1309,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
>  	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  "u8TrafficIndicationPreference	: 0x%02X",
>  		pstAddIndication->sfAdmittedSet.u8TrafficIndicationPreference);
>  
> -	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Recieved		: 0x%X",pstAddIndication->sfAdmittedSet.u8TotalClassifiers);
> +	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Received		: 0x%X",pstAddIndication->sfAdmittedSet.u8TotalClassifiers);
>  
>  	nCurClassifierCnt = pstAddIndication->sfAdmittedSet.u8TotalClassifiers;
>  
> @@ -1506,7 +1506,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
>  	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " u8TrafficIndicationPreference	: 0x%X",
>  		pstAddIndication->sfActiveSet.u8TrafficIndicationPreference);
>  
> -	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Recieved		: 0x%X",pstAddIndication->sfActiveSet.u8TotalClassifiers);
> +	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Received		: 0x%X",pstAddIndication->sfActiveSet.u8TotalClassifiers);
>  
>  	nCurClassifierCnt = pstAddIndication->sfActiveSet.u8TotalClassifiers;
>  
> diff --git a/drivers/staging/bcm/HostMIBSInterface.h b/drivers/staging/bcm/HostMIBSInterface.h
> index f17a4f1..e34531b 100644
> --- a/drivers/staging/bcm/HostMIBSInterface.h
> +++ b/drivers/staging/bcm/HostMIBSInterface.h
> @@ -62,7 +62,7 @@ typedef struct _S_MIBS_HOST_INFO
>  	ULONG			NumDesUsed;
>  	ULONG			CurrNumFreeDesc;
>  	ULONG			PrevNumFreeDesc;
> -	// to keep track the no of byte recieved
> +	// to keep track the no of byte received
>  	ULONG			PrevNumRcevBytes;
>  	ULONG			CurrNumRcevBytes;
>  
> diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
> index 91b6fbe..5b4fd37 100644
> --- a/drivers/staging/bcm/IPv6Protocol.c
> +++ b/drivers/staging/bcm/IPv6Protocol.c
> @@ -287,7 +287,7 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
>  
>  	for(uiLoopIndex=0;uiLoopIndex<uiCountIPSrcAddresses;uiLoopIndex+=uiIpv6AddrNoLongWords)
>  	{
> -		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Recieved Packet : \n ");
> +		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Received Packet : \n ");
>  		DumpIpv6Address(aulSrcIP);
>  		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Mask In Classifier Rule: \n");
>  		DumpIpv6Address(&pstClassifierRule->stSrcIpAddress.ulIpv6Mask[uiLoopIndex]);
> @@ -340,7 +340,7 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
>  
>  	for(uiLoopIndex=0;uiLoopIndex<uiCountIPDestinationAddresses;uiLoopIndex+=uiIpv6AddrNoLongWords)
>  	{
> -		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Recieved Packet : \n ");
> +		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Received Packet : \n ");
>  		DumpIpv6Address(aulDestIP);
>  		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Mask In Classifier Rule: \n");
>  		DumpIpv6Address(&pstClassifierRule->stDestIpAddress.ulIpv6Mask[uiLoopIndex]);
> diff --git a/drivers/staging/bcm/InterfaceIdleMode.c b/drivers/staging/bcm/InterfaceIdleMode.c
> index bf5c0ad..96fa4ea 100644
> --- a/drivers/staging/bcm/InterfaceIdleMode.c
> +++ b/drivers/staging/bcm/InterfaceIdleMode.c
> @@ -11,7 +11,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
>  
>  
>  Return:				BCM_STATUS_SUCCESS - If Wakeup of the HW Interface was successful.
> -						Other           - If an error occured.
> +						Other           - If an error occurred.
>  */
>  
>  
> @@ -26,7 +26,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
>  
>  
>  Return:				BCM_STATUS_SUCCESS - If Idle mode response related HW configuration was successful.
> -						Other           - If an error occured.
> +						Other           - If an error occurred.
>  */
>  
>  /*
> diff --git a/drivers/staging/bcm/InterfaceIsr.c b/drivers/staging/bcm/InterfaceIsr.c
> index 220ff92..6dd5d9e 100644
> --- a/drivers/staging/bcm/InterfaceIsr.c
> +++ b/drivers/staging/bcm/InterfaceIsr.c
> @@ -81,7 +81,7 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
>  		case -EINPROGRESS:
>  		{
>  			//This situation may happend when URBunlink is used. for detail check usb_unlink_urb documentation.
> -			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Impossibe condition has occured... something very bad is going on");
> +			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Impossibe condition has occurred... something very bad is going on");
>  			break ;
>  			//return;
>  		}
> diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
> index 533f8eb..4a42cb4 100644
> --- a/drivers/staging/bcm/InterfaceRx.c
> +++ b/drivers/staging/bcm/InterfaceRx.c
> @@ -123,7 +123,7 @@ static void read_bulk_callback(struct urb *urb)
>  	if((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
>  	    (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F)))
>  	{
> -	    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Recived control pkt...");
> +	    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
>  		*(PUSHORT)skb->data = pLeader->Status;
>         	memcpy(skb->data+sizeof(USHORT), urb->transfer_buffer +
>  			(sizeof(LEADER)), pLeader->PLength);
> @@ -142,7 +142,7 @@ static void read_bulk_callback(struct urb *urb)
>  		  * Data Packet, Format a proper Ethernet Header
>          	  * and give it to the stack
>  		  */
> -        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Recived Data pkt...");
> +        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt...");
>  		skb_reserve(skb, 2 + SKB_RESERVE_PHS_BYTES);
>  		memcpy(skb->data+ETH_HLEN, (PUCHAR)urb->transfer_buffer + sizeof(LEADER), pLeader->PLength);
>  		skb->dev = Adapter->dev;
> @@ -151,7 +151,7 @@ static void read_bulk_callback(struct urb *urb)
>  		skb_put (skb, pLeader->PLength + ETH_HLEN);
>  		Adapter->PackInfo[QueueIndex].uiTotalRxBytes+=pLeader->PLength;
>  		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes+= pLeader->PLength;
> -        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Recived Data pkt of len :0x%X", pLeader->PLength);
> +        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
>  
>  		if(netif_running(Adapter->dev))
>  		{
> @@ -229,7 +229,7 @@ static int ReceiveRcb(PS_INTERFACE_ADAPTER psIntfAdapter, PUSB_RCB pRcb)
>  /*
>  Function:				InterfaceRx
>  
> -Description:			This is the hardware specific Function for Recieveing
> +Description:			This is the hardware specific Function for Receiveing
>  						data packet/control packets from the device.
>  
>  Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
> @@ -237,7 +237,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
>  
>  
>  Return:				TRUE  - If Rx was successful.
> -					Other - If an error occured.
> +					Other - If an error occurred.
>  */
>  
>  BOOLEAN InterfaceRx (PS_INTERFACE_ADAPTER psIntfAdapter)
> diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
> index f585aae..b737907 100644
> --- a/drivers/staging/bcm/Misc.c
> +++ b/drivers/staging/bcm/Misc.c
> @@ -604,7 +604,7 @@ VOID LinkControlResponseMessage(PMINI_ADAPTER Adapter,PUCHAR pucBuffer)
>  				Adapter->LinkStatus=LINKUP_DONE;
>  				Adapter->bPHSEnabled = *(pucBuffer+3);
>                 	Adapter->bETHCSEnabled = *(pucBuffer+4) & ETH_CS_MASK;
> -				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "PHS Support Status Recieved In LinkUp Ack : %x \n",Adapter->bPHSEnabled);
> +				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "PHS Support Status Received In LinkUp Ack : %x \n",Adapter->bPHSEnabled);
>  				if((FALSE == Adapter->bShutStatus)&&
>  					(FALSE == Adapter->IdleMode))
>  				{
> diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSModule.c
> index d1ca191..c028175 100644
> --- a/drivers/staging/bcm/PHSModule.c
> +++ b/drivers/staging/bcm/PHSModule.c
> @@ -66,7 +66,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter         - Miniport Adapter Context
>  						BOOLEAN bHeaderSuppressionEnabled - indicates if header suprression is enabled for SF.
>  
>  Return:					STATUS_SUCCESS - If the send was successful.
> -						Other          - If an error occured.
> +						Other          - If an error occurred.
>  */
>  
>  int PHSTransmit(PMINI_ADAPTER Adapter,
> diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
> index feade94..c97020f 100644
> --- a/drivers/staging/bcm/Qos.c
> +++ b/drivers/staging/bcm/Qos.c
> @@ -727,7 +727,7 @@ static BOOLEAN EthCSMatchVLANRules(S_CLASSIFIER_RULE *pstClassifierRule,struct s
>  
>  	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n",__FUNCTION__,ntohs(*((USHORT *)pstClassifierRule->usUserPriority)),pstClassifierRule->usVLANID);
>  
> -	/* In case FW didn't recieve the TLV, the priority field should be ignored */
> +	/* In case FW didn't receive the TLV, the priority field should be ignored */
>  	if(pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID))
>  	{
>  		if(pstEthCsPktInfo->eNwpktEthFrameType!=eEth802QVLANFrame)
> diff --git a/drivers/staging/bcm/cntrl_SignalingInterface.h b/drivers/staging/bcm/cntrl_SignalingInterface.h
> index 8907784..67bb2f5 100644
> --- a/drivers/staging/bcm/cntrl_SignalingInterface.h
> +++ b/drivers/staging/bcm/cntrl_SignalingInterface.h
> @@ -21,8 +21,8 @@
>  #define VENDOR_PHS_PARAM_LENGTH 10
>  #define MAX_NUM_ACTIVE_BS 10
>  #define AUTH_TOKEN_LENGTH	10
> -#define NUM_HARQ_CHANNELS	16	//Changed from 10 to 16 to accomodate all HARQ channels
> -#define VENDOR_CLASSIFIER_PARAM_LENGTH 1 //Changed the size to 1 byte since we dnt use it
> +#define NUM_HARQ_CHANNELS	16	//Changed from 10 to 16 to accommodate all HARQ channels
> +#define VENDOR_CLASSIFIER_PARAM_LENGTH 1 //Changed the size to 1 byte since we dont use it
>  #define  VENDOR_SPECIF_QOS_PARAM 1
>  #define VENDOR_PHS_PARAM_LENGTH	10
>  #define MBS_CONTENTS_ID_LENGTH	10
> diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> index d399b5c..0219f83 100644
> --- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> +++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> @@ -267,7 +267,7 @@ extern SDIOH_API_RC sdioh_disable_func_intr(void)
>  }
>  #endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
>  
> -/* Configure callback to client when we recieve client interrupt */
> +/* Configure callback to client when we receive client interrupt */
>  extern SDIOH_API_RC
>  sdioh_interrupt_register(sdioh_info_t *sd, sdioh_cb_fn_t fn, void *argh)
>  {
> diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
> index d749917..9dd0d7b 100644
> --- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
> +++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
> @@ -409,7 +409,7 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
>  		/*
>  		   compute a new dma xfer rate for max_mpdu @ max mcs.
>  		   This is the minimum dma rate that
> -		   can acheive no unferflow condition for the current mpdu size.
> +		   can achieve no underflow condition for the current mpdu size.
>  		 */
>  		/* note : we divide/multiply by 100 to avoid integer overflows */
>  		fifo->dmaxferrate =
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index 093032b..a6c1d5b 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -2045,7 +2045,7 @@ void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
>  			     COMEDI_CB_OVERFLOW)) {
>  		runflags_mask |= SRF_RUNNING;
>  	}
> -	/* remember if an error event has occured, so an error
> +	/* remember if an error event has occurred, so an error
>  	 * can be returned the next time the user does a read() */
>  	if (s->async->events & (COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW)) {
>  		runflags_mask |= SRF_ERROR;
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
> index 9dd857d..f5b8521 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
> @@ -488,9 +488,9 @@ int i_APCI2032_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *
>  +----------------------------------------------------------------------------+
>  | Output Parameters :	--													 |
>  +----------------------------------------------------------------------------+
> -| Return Value      : TRUE  : No error occur                                 |
> -|		            : FALSE : Error occur. Return the error          |
> -|			                                                         |
> +| Return Value      : TRUE  : No error occurred                              |
> +|		            : FALSE : Error occurred. Return the error               |
> +|			                                                                 |
>  +----------------------------------------------------------------------------+
>  */
>  void v_APCI2032_Interrupt(int irq, void *d)
> @@ -498,7 +498,7 @@ void v_APCI2032_Interrupt(int irq, void *d)
>  	struct comedi_device *dev = d;
>  	unsigned int ui_DO;
>  
> -	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occured. */
> +	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occurred. */
>  
>  	if (ui_DO == 0) {
>  		printk("\nInterrupt from unKnown source\n");
> diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
> index 466e69f..0fd0ac5 100644
> --- a/drivers/staging/comedi/drivers/adv_pci1710.c
> +++ b/drivers/staging/comedi/drivers/adv_pci1710.c
> @@ -98,7 +98,7 @@ Configuration options:
>  #define	Status_FE	0x0100	/* 1=FIFO is empty */
>  #define Status_FH	0x0200	/* 1=FIFO is half full */
>  #define Status_FF	0x0400	/* 1=FIFO is full, fatal error */
> -#define Status_IRQ	0x0800	/* 1=IRQ occured */
> +#define Status_IRQ	0x0800	/* 1=IRQ occurred */
>  /* bits from control register (PCI171x_CONTROL) */
>  #define Control_CNT0	0x0040	/* 1=CNT0 have external source,
>  				 * 0=have internal 100kHz source */
> diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
> index 3275fc5..8ed4ac1 100644
> --- a/drivers/staging/comedi/drivers/cb_pcidas.c
> +++ b/drivers/staging/comedi/drivers/cb_pcidas.c
> @@ -411,7 +411,7 @@ struct cb_pcidas_private {
>  	unsigned int divisor1;
>  	unsigned int divisor2;
>  	volatile unsigned int count;	/*  number of analog input samples remaining */
> -	volatile unsigned int adc_fifo_bits;	/*  bits to write to interupt/adcfifo register */
> +	volatile unsigned int adc_fifo_bits;	/*  bits to write to interrupt/adcfifo register */
>  	volatile unsigned int s5933_intcsr_bits;	/*  bits to write to amcc s5933 interrupt control/status register */
>  	volatile unsigned int ao_control_bits;	/*  bits to write to ao control and status register */
>  	short ai_buffer[AI_BUFFER_SIZE];
> diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
> index b220b30..a804742 100644
> --- a/drivers/staging/comedi/drivers/comedi_test.c
> +++ b/drivers/staging/comedi/drivers/comedi_test.c
> @@ -81,7 +81,7 @@ static const struct waveform_board waveform_boards[] = {
>  /* Data unique to this driver */
>  struct waveform_private {
>  	struct timer_list timer;
> -	struct timeval last;	/* time at which last timer interrupt occured */
> +	struct timeval last;	/* time at which last timer interrupt occurred */
>  	unsigned int uvolt_amplitude;	/* waveform amplitude in microvolts */
>  	unsigned long usec_period;	/* waveform period in microseconds */
>  	unsigned long usec_current;	/* current time (modulo waveform period) */
> diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
> index e6825c2..3ba93fb 100644
> --- a/drivers/staging/comedi/drivers/me4000.c
> +++ b/drivers/staging/comedi/drivers/me4000.c
> @@ -1810,7 +1810,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
>  		       ai_context->irq_status_reg) &
>  	    ME4000_IRQ_STATUS_BIT_AI_HF) {
>  		ISR_PDEBUG
> -		    ("me4000_ai_isr(): Fifo half full interrupt occured\n");
> +		    ("me4000_ai_isr(): Fifo half full interrupt occurred\n");
>  
>  		/* Read status register to find out what happened */
>  		tmp = me4000_inl(dev, ai_context->ctrl_reg);
> @@ -1903,7 +1903,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
>  	if (me4000_inl(dev,
>  		       ai_context->irq_status_reg) & ME4000_IRQ_STATUS_BIT_SC) {
>  		ISR_PDEBUG
> -		    ("me4000_ai_isr(): Sample counter interrupt occured\n");
> +		    ("me4000_ai_isr(): Sample counter interrupt occurred\n");
>  
>  		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOA;
>  
> diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
> index e46d62b..e8755d7 100644
> --- a/drivers/staging/comedi/drivers/ni_at_a2150.c
> +++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
> @@ -106,8 +106,8 @@ TRIG_WAKE_EOS
>  #define   OVFL_BIT		0x8	/*  fifo overflow */
>  #define   EDAQ_BIT		0x10	/*  end of aquisition interrupt */
>  #define   DCAL_BIT		0x20	/*  offset calibration in progress */
> -#define   INTR_BIT		0x40	/*  interrupt has occured */
> -#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occured */
> +#define   INTR_BIT		0x40	/*  interrupt has occurred */
> +#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occurred */
>  #define   ID_BITS(x)	(((x) >> 8) & 0x3)
>  #define IRQ_DMA_CNTRL_REG		0x12	/*  write only */
>  #define   DMA_CHAN_BITS(x)		((x) & 0x7)	/*  sets dma channel */
> diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
> index 0728c3c..4641e03 100644
> --- a/drivers/staging/comedi/drivers/ni_labpc.c
> +++ b/drivers/staging/comedi/drivers/ni_labpc.c
> @@ -183,11 +183,11 @@ NI manuals:
>  #define   OVERRUN_BIT	0x2
>  /* fifo overflow */
>  #define   OVERFLOW_BIT	0x4
> -/* timer interrupt has occured */
> +/* timer interrupt has occurred */
>  #define   TIMER_BIT	0x8
> -/* dma terminal count has occured */
> +/* dma terminal count has occurred */
>  #define   DMATC_BIT	0x10
> -/* external trigger has occured */
> +/* external trigger has occurred */
>  #define   EXT_TRIG_BIT	0x40
>  /* 1200 boards only */
>  #define STATUS2_REG	0x1d
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index d5ba3ab..0f9aa01 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -1048,7 +1048,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
>  	uint8_t group;
>  	uint16_t irqbit;
>  
> -	DEBUG("s626_irq_handler: interrupt request recieved!!!\n");
> +	DEBUG("s626_irq_handler: interrupt request received!!!\n");
>  
>  	if (dev->attached == 0)
>  		return IRQ_NONE;
> @@ -1165,7 +1165,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
>  							(16 * group)))
>  					    == 1 && cmd->start_src == TRIG_EXT) {
>  						DEBUG
> -						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
> +						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
>  						     cmd->start_arg);
>  
>  						/*  Start executing the RPS program. */
> @@ -1194,7 +1194,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
>  					    && cmd->scan_begin_src ==
>  					    TRIG_EXT) {
>  						DEBUG
> -						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
> +						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
>  						     cmd->scan_begin_arg);
>  
>  						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
> @@ -1236,7 +1236,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
>  					    == 1
>  					    && cmd->convert_src == TRIG_EXT) {
>  						DEBUG
> -						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
> +						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
>  						     cmd->convert_arg);
>  
>  						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
> @@ -1805,7 +1805,7 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
>  		DEBUG("s626_ai_cmd: NULL command\n");
>  		return -EINVAL;
>  	} else {
> -		DEBUG("s626_ai_cmd: command recieved!!!\n");
> +		DEBUG("s626_ai_cmd: command received!!!\n");
>  	}
>  
>  	if (dev->irq == 0) {
> @@ -2570,7 +2570,7 @@ static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val)
>  	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY)
>  		;
>  
> -	/*  Return non-zero if I2C error occured. */
> +	/*  Return non-zero if I2C error occurred. */
>  	return RR7146(P_I2CCTRL) & I2C_ERR;
>  
>  }
> diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
> index 598884e..a69e450 100644
> --- a/drivers/staging/comedi/drivers/unioxx5.c
> +++ b/drivers/staging/comedi/drivers/unioxx5.c
> @@ -314,7 +314,7 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
>  		outb(i + 1, subdev_iobase + 5);	/* sends channel number to card */
>  		outb('H', subdev_iobase + 6);	/* requests EEPROM world */
>  		while (!(inb(subdev_iobase + 0) & TxBE))
> -			;	/* waits while writting will be allowed */
> +			;	/* waits while writing will be allowed */
>  		outb(0, subdev_iobase + 6);
>  
>  		/* waits while reading of two bytes will be allowed */
> @@ -450,7 +450,7 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
>  	/* sending for bytes to module(one byte per cycle iteration) */
>  	for (i = 0; i < 4; i++) {
>  		while (!((inb(usp->usp_iobase + 0)) & TxBE))
> -			;	/* waits while writting will be allowed */
> +			;	/* waits while writing will be allowed */
>  		outb(usp->usp_extra_data[module][i], usp->usp_iobase + 6);
>  	}
>  
> diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
> index 153ddbf..018041d 100644
> --- a/drivers/staging/crystalhd/crystalhd_hw.c
> +++ b/drivers/staging/crystalhd/crystalhd_hw.c
> @@ -2366,7 +2366,7 @@ enum BC_STATUS crystalhd_hw_set_core_clock(struct crystalhd_hw *hw)
>  	BCMLOG(BCMLOG_INFO, "clock is moving to %d with n %d with vco_mg %d\n",
>  	       hw->core_clock_mhz, n, vco_mg);
>  
> -	/* Change the DRAM refresh rate to accomodate the new frequency */
> +	/* Change the DRAM refresh rate to accommodate the new frequency */
>  	/* refresh reg = ((refresh_rate * clock_rate)/16) - 1; rounding up*/
>  	refresh_reg = (7 * hw->core_clock_mhz / 16);
>  	bc_dec_reg_wr(hw->adp, SDRAM_REF_PARAM, ((1 << 12) | refresh_reg));
> diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
> index 15d7efe..52a0e6e 100644
> --- a/drivers/staging/dt3155v4l/dt3155v4l.c
> +++ b/drivers/staging/dt3155v4l/dt3155v4l.c
> @@ -122,7 +122,7 @@ read_i2c_reg(void __iomem *addr, u8 index, u8 *data)
>   *
>   * returns:	zero on success or error code
>   *
> - * This function starts writting the specified (by index) register
> + * This function starts writing the specified (by index) register
>   * and busy waits for the process to finish.
>   */
>  static int
> @@ -155,7 +155,7 @@ write_i2c_reg(void __iomem *addr, u8 index, u8 data)
>   * @index:	index (internal address) of register to read
>   * @data:	data to be written
>   *
> - * This function starts writting the specified (by index) register
> + * This function starts writing the specified (by index) register
>   * and then returns.
>   */
>  static void write_i2c_reg_nowait(void __iomem *addr, u8 index, u8 data)
> @@ -173,7 +173,7 @@ static void write_i2c_reg_nowait(void __iomem *addr, u8 index, u8 data)
>   *
>   * returns:	zero on success or error code
>   *
> - * This function waits reading/writting to finish.
> + * This function waits reading/writing to finish.
>   */
>  static int wait_i2c_reg(void __iomem *addr)
>  {
> diff --git a/drivers/staging/easycap/easycap_low.c b/drivers/staging/easycap/easycap_low.c
> index 28c4d1e..4206849 100644
> --- a/drivers/staging/easycap/easycap_low.c
> +++ b/drivers/staging/easycap/easycap_low.c
> @@ -27,7 +27,7 @@
>  */
>  /*****************************************************************************/
>  /*
> - *  ACKNOWLEGEMENTS AND REFERENCES
> + *  ACKNOWLEDGEMENTS AND REFERENCES
>   *  ------------------------------
>   *  This driver makes use of register information contained in the Syntek
>   *  Semicon DC-1125 driver hosted at
> diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
> index 8e04bdd..f3a5aba 100644
> --- a/drivers/staging/et131x/et1310_rx.c
> +++ b/drivers/staging/et131x/et1310_rx.c
> @@ -122,7 +122,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
>  	 * number of entries in FBR1.
>  	 *
>  	 * FBR1 holds "large" frames, FBR0 holds "small" frames.  If FBR1
> -	 * entries are huge in order to accomodate a "jumbo" frame, then it
> +	 * entries are huge in order to accommodate a "jumbo" frame, then it
>  	 * will have less entries.  Conversely, FBR1 will now be relied upon
>  	 * to carry more "normal" frames, thus it's entry size also increases
>  	 * and the number of entries goes up too (since it now carries
> diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
> index 36f68fe..3a174df 100644
> --- a/drivers/staging/et131x/et131x_isr.c
> +++ b/drivers/staging/et131x/et131x_isr.c
> @@ -466,7 +466,7 @@ void et131x_isr_handler(struct work_struct *work)
>  		/* Handle SLV Timeout Interrupt */
>  		if (status & ET_INTR_SLV_TIMEOUT) {
>  			/*
> -			 * This means a timeout has occured on a read or
> +			 * This means a timeout has occurred on a read or
>  			 * write request to one of the JAGCore registers. The
>  			 * Global Resources block has terminated the request
>  			 * and on a read request, returned a "fake" value.
> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> index 588afd5..318b41f 100644
> --- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> +++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> @@ -386,10 +386,10 @@ static void ft1000_reset_asic(struct net_device *dev)
>  	}
>  	mdelay(1);
>  	if (info->AsicID == ELECTRABUZZ_ID) {
> -		// set watermark to -1 in order to not generate an interrrupt
> +		// set watermark to -1 in order to not generate an interrupt
>  		ft1000_write_reg(dev, FT1000_REG_WATERMARK, 0xffff);
>  	} else {
> -		// set watermark to -1 in order to not generate an interrrupt
> +		// set watermark to -1 in order to not generate an interrupt
>  		ft1000_write_reg(dev, FT1000_REG_MAG_WATERMARK, 0xffff);
>  	}
>  	// clear interrupts
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
> index 643a637..f03b515 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
> @@ -309,7 +309,7 @@ u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u
>  // Parameters:  ft1000_device  - device structure
>  //              indx - starting address to write the data
>  //              value - 16bits value to write
> -//              hightlow - high or low 16 bit word
> +//              highlow - high or low 16 bit word
>  //
>  // Returns:     STATUS_SUCCESS - success
>  //              STATUS_FAILURE - failure
> @@ -663,7 +663,7 @@ static void ft1000_reset_asic (struct net_device *dev)
>  
>      mdelay(1);
>  
> -    // set watermark to -1 in order to not generate an interrrupt
> +    // set watermark to -1 in order to not generate an interrupt
>      ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_MAG_WATERMARK);
>  
>      // clear interrupts
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
> index a143e9c..19eddde 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
> @@ -364,7 +364,7 @@ struct prov_record {
>  
>  #define ISR_EMPTY			(u8)0x00 	 // no bits set in ISR
>  
> -#define ISR_DOORBELL_ACK	(u8)0x01		 //  the doorbell i sent has been recieved.
> +#define ISR_DOORBELL_ACK	(u8)0x01		 //  the doorbell i sent has been received.
>  
>  #define ISR_DOORBELL_PEND	(u8)0x02 	 //  doorbell for me
>  
> diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
> index 0372424..2f780ab 100644
> --- a/drivers/staging/iio/Documentation/iio_utils.h
> +++ b/drivers/staging/iio/Documentation/iio_utils.h
> @@ -545,7 +545,7 @@ int _write_sysfs_string(char *filename, char *basedir, char *val, int verify)
>  		if (strcmp(temp, val) != 0) {
>  			printf("Possible failure in string write of %s "
>  				"Should be %s "
> -				"writen to %s\%s\n",
> +				"written to %s\%s\n",
>  				temp,
>  				val,
>  				basedir,
> diff --git a/drivers/staging/iio/accel/adis16201.h b/drivers/staging/iio/accel/adis16201.h
> index c9bf22c..23fe54d 100644
> --- a/drivers/staging/iio/accel/adis16201.h
> +++ b/drivers/staging/iio/accel/adis16201.h
> @@ -70,7 +70,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16201_state {
> diff --git a/drivers/staging/iio/accel/adis16203.h b/drivers/staging/iio/accel/adis16203.h
> index b39323e..b886881 100644
> --- a/drivers/staging/iio/accel/adis16203.h
> +++ b/drivers/staging/iio/accel/adis16203.h
> @@ -65,7 +65,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16203_state {
> diff --git a/drivers/staging/iio/accel/adis16204.h b/drivers/staging/iio/accel/adis16204.h
> index e9ed7cb..e618446 100644
> --- a/drivers/staging/iio/accel/adis16204.h
> +++ b/drivers/staging/iio/accel/adis16204.h
> @@ -73,7 +73,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16204_state {
> diff --git a/drivers/staging/iio/accel/adis16209.h b/drivers/staging/iio/accel/adis16209.h
> index 4e97596..8b0da13 100644
> --- a/drivers/staging/iio/accel/adis16209.h
> +++ b/drivers/staging/iio/accel/adis16209.h
> @@ -109,7 +109,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16209_state {
> diff --git a/drivers/staging/iio/accel/adis16220.h b/drivers/staging/iio/accel/adis16220.h
> index 7013314..4d5758c 100644
> --- a/drivers/staging/iio/accel/adis16220.h
> +++ b/drivers/staging/iio/accel/adis16220.h
> @@ -132,7 +132,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16220_state {
> diff --git a/drivers/staging/iio/accel/adis16240.h b/drivers/staging/iio/accel/adis16240.h
> index 51a807d..76a4579 100644
> --- a/drivers/staging/iio/accel/adis16240.h
> +++ b/drivers/staging/iio/accel/adis16240.h
> @@ -132,7 +132,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16240_state {
> diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
> index 6e73055..873b1f6 100644
> --- a/drivers/staging/iio/accel/lis3l02dq.h
> +++ b/drivers/staging/iio/accel/lis3l02dq.h
> @@ -57,7 +57,7 @@
>  /* Reboot memory content */
>  #define LIS3L02DQ_REG_CTRL_2_REBOOT_MEMORY	0x10
>  
> -/* Interupt Enable - applies data ready to the RDY pad */
> +/* Interrupt Enable - applies data ready to the RDY pad */
>  #define LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT	0x08
>  
>  /* Enable Data Ready Generation - relationship with previous unclear in docs */
> @@ -70,36 +70,36 @@
>   * - option for 16 bit left justified */
>  #define LIS3L02DQ_REG_CTRL_2_DATA_ALIGNMENT_16_BIT_LEFT_JUSTIFIED	0x01
>  
> -/* Interupt related stuff */
> +/* Interrupt related stuff */
>  #define LIS3L02DQ_REG_WAKE_UP_CFG_ADDR			0x23
>  
>  /* Switch from or combination fo conditions to and */
>  #define LIS3L02DQ_REG_WAKE_UP_CFG_BOOLEAN_AND		0x80
>  
> -/* Latch interupt request,
> +/* Latch interrupt request,
>   * if on ack must be given by reading the ack register */
>  #define LIS3L02DQ_REG_WAKE_UP_CFG_LATCH_SRC		0x40
>  
> -/* Z Interupt on High (above threshold)*/
> +/* Z Interrupt on High (above threshold)*/
>  #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_HIGH	0x20
> -/* Z Interupt on Low */
> +/* Z Interrupt on Low */
>  #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_LOW	0x10
> -/* Y Interupt on High */
> +/* Y Interrupt on High */
>  #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_HIGH	0x08
> -/* Y Interupt on Low */
> +/* Y Interrupt on Low */
>  #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_LOW	0x04
> -/* X Interupt on High */
> +/* X Interrupt on High */
>  #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_HIGH	0x02
> -/* X Interupt on Low */
> +/* X Interrupt on Low */
>  #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_LOW 0x01
>  
> -/* Register that gives description of what caused interupt
> +/* Register that gives description of what caused interrupt
>   * - latched if set in CFG_ADDRES */
>  #define LIS3L02DQ_REG_WAKE_UP_SRC_ADDR			0x24
>  /* top bit ignored */
> -/* Interupt Active */
> +/* Interrupt Active */
>  #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_ACTIVATED	0x40
> -/* Interupts that have been triggered */
> +/* Interrupts that have been triggered */
>  #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH	0x20
>  #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW	0x10
>  #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH	0x08
> @@ -155,7 +155,7 @@ Form of high byte dependant on justification set in ctrl reg */
>   * @inter:		used to check if new interrupt has been triggered
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct lis3l02dq_state {
> diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
> index c4b4ab7..3067f96 100644
> --- a/drivers/staging/iio/accel/lis3l02dq_core.c
> +++ b/drivers/staging/iio/accel/lis3l02dq_core.c
> @@ -77,7 +77,7 @@ int lis3l02dq_spi_read_reg_8(struct device *dev, u8 reg_address, u8 *val)
>  /**
>   * lis3l02dq_spi_write_reg_8() - write single byte to a register
>   * @dev: device associated with child of actual device (iio_dev or iio_trig)
> - * @reg_address: the address of the register to be writen
> + * @reg_address: the address of the register to be written
>   * @val: the value to write
>   **/
>  int lis3l02dq_spi_write_reg_8(struct device *dev,
> diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
> index 1fd088a..5016238 100644
> --- a/drivers/staging/iio/accel/lis3l02dq_ring.c
> +++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
> @@ -216,7 +216,7 @@ static const u8 read_all_tx_array[] = {
>  /**
>   * lis3l02dq_read_all() Reads all channels currently selected
>   * @st:		device specific state
> - * @rx_array:	(dma capable) recieve array, must be at least
> + * @rx_array:	(dma capable) receive array, must be at least
>   *		4*number of channels
>   **/
>  static int lis3l02dq_read_all(struct lis3l02dq_state *st, u8 *rx_array)
> @@ -408,7 +408,7 @@ static const struct attribute_group lis3l02dq_trigger_attr_group = {
>   *
>   * As the trigger may occur on any data element being updated it is
>   * really rather likely to occur during the read from the previous
> - * trigger event.  The only way to discover if this has occured on
> + * trigger event.  The only way to discover if this has occurred on
>   * boards not supporting level interrupts is to take a look at the line.
>   * If it is indicating another interrupt and we don't seem to have a
>   * handler looking at it, then we need to notify the core that we need
> diff --git a/drivers/staging/iio/accel/sca3000.h b/drivers/staging/iio/accel/sca3000.h
> index 2389284..5971f1d 100644
> --- a/drivers/staging/iio/accel/sca3000.h
> +++ b/drivers/staging/iio/accel/sca3000.h
> @@ -213,7 +213,7 @@ struct sca3000_chip_info {
>   * sca3000_read_data() read a series of values from the device
>   * @dev:		device
>   * @reg_address_high:	start address (decremented read)
> - * @rx:			pointer where recieved data is placed. Callee
> + * @rx:			pointer where received data is placed. Callee
>   *			responsible for freeing this.
>   * @len:		number of bytes to read
>   *
> diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
> index dde097a..adef546 100644
> --- a/drivers/staging/iio/adc/max1363_core.c
> +++ b/drivers/staging/iio/adc/max1363_core.c
> @@ -1425,7 +1425,7 @@ error_ret:
>  }
>  
>  /*
> - * To keep this managable we always use one of 3 scan modes.
> + * To keep this manageable we always use one of 3 scan modes.
>   * Scan 0...3, 0-1,2-3 and 1-0,3-2
>   */
>  static inline int __max1363_check_event_mask(int thismask, int checkmask)
> diff --git a/drivers/staging/iio/chrdev.h b/drivers/staging/iio/chrdev.h
> index 98d1a2c..bfbb22e 100644
> --- a/drivers/staging/iio/chrdev.h
> +++ b/drivers/staging/iio/chrdev.h
> @@ -42,7 +42,7 @@ struct iio_event_data {
>  };
>  
>  /**
> - * struct iio_detected_event_list - list element for events that have occured
> + * struct iio_detected_event_list - list element for events that have occurred
>   * @list:		linked list header
>   * @ev:			the event itself
>   * @shared_pointer:	used when the event is shared - i.e. can be escallated
> diff --git a/drivers/staging/iio/gyro/adis16060.h b/drivers/staging/iio/gyro/adis16060.h
> index 5c00e53..7a901d5 100644
> --- a/drivers/staging/iio/gyro/adis16060.h
> +++ b/drivers/staging/iio/gyro/adis16060.h
> @@ -20,7 +20,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16060_state {
> diff --git a/drivers/staging/iio/gyro/adis16080.h b/drivers/staging/iio/gyro/adis16080.h
> index 3fcbe67..f39af38 100644
> --- a/drivers/staging/iio/gyro/adis16080.h
> +++ b/drivers/staging/iio/gyro/adis16080.h
> @@ -22,7 +22,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16080_state {
> diff --git a/drivers/staging/iio/gyro/adis16130.h b/drivers/staging/iio/gyro/adis16130.h
> index ab80ef6..9d57d27 100644
> --- a/drivers/staging/iio/gyro/adis16130.h
> +++ b/drivers/staging/iio/gyro/adis16130.h
> @@ -29,7 +29,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16130_state {
> diff --git a/drivers/staging/iio/gyro/adis16251.h b/drivers/staging/iio/gyro/adis16251.h
> index d23852c..f9e84c5 100644
> --- a/drivers/staging/iio/gyro/adis16251.h
> +++ b/drivers/staging/iio/gyro/adis16251.h
> @@ -88,7 +88,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16251_state {
> diff --git a/drivers/staging/iio/gyro/adis16260.h b/drivers/staging/iio/gyro/adis16260.h
> index c1fd4364..1369501 100644
> --- a/drivers/staging/iio/gyro/adis16260.h
> +++ b/drivers/staging/iio/gyro/adis16260.h
> @@ -91,7 +91,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   * @negate:		negate the scale parameter
>   **/
> diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
> index 248bdd2..7127f26 100644
> --- a/drivers/staging/iio/iio.h
> +++ b/drivers/staging/iio/iio.h
> @@ -92,7 +92,7 @@ void iio_remove_event_from_list(struct iio_event_handler_list *el,
>   *			changes
>   * @available_scan_masks: [DRIVER] optional array of allowed bitmasks
>   * @trig:		[INTERN] current device trigger (ring buffer modes)
> - * @pollfunc:		[DRIVER] function run on trigger being recieved
> + * @pollfunc:		[DRIVER] function run on trigger being received
>   **/
>  struct iio_dev {
>  	int				id;
> diff --git a/drivers/staging/iio/imu/adis16300.h b/drivers/staging/iio/imu/adis16300.h
> index 1f25d68..c095759 100644
> --- a/drivers/staging/iio/imu/adis16300.h
> +++ b/drivers/staging/iio/imu/adis16300.h
> @@ -99,7 +99,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16300_state {
> diff --git a/drivers/staging/iio/imu/adis16350.h b/drivers/staging/iio/imu/adis16350.h
> index b00001e..b1ad486 100644
> --- a/drivers/staging/iio/imu/adis16350.h
> +++ b/drivers/staging/iio/imu/adis16350.h
> @@ -105,7 +105,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16350_state {
> diff --git a/drivers/staging/iio/imu/adis16400.h b/drivers/staging/iio/imu/adis16400.h
> index 6ff33e1..7a12702 100644
> --- a/drivers/staging/iio/imu/adis16400.h
> +++ b/drivers/staging/iio/imu/adis16400.h
> @@ -131,7 +131,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct adis16400_state {
> diff --git a/drivers/staging/iio/meter/ade7753.h b/drivers/staging/iio/meter/ade7753.h
> index a3722b8..28ee06a 100644
> --- a/drivers/staging/iio/meter/ade7753.h
> +++ b/drivers/staging/iio/meter/ade7753.h
> @@ -66,7 +66,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct ade7753_state {
> diff --git a/drivers/staging/iio/meter/ade7754.h b/drivers/staging/iio/meter/ade7754.h
> index f6a3e4b..5ec1938 100644
> --- a/drivers/staging/iio/meter/ade7754.h
> +++ b/drivers/staging/iio/meter/ade7754.h
> @@ -84,7 +84,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct ade7754_state {
> diff --git a/drivers/staging/iio/meter/ade7758.h b/drivers/staging/iio/meter/ade7758.h
> index df5bb7b..c6fd94f 100644
> --- a/drivers/staging/iio/meter/ade7758.h
> +++ b/drivers/staging/iio/meter/ade7758.h
> @@ -98,7 +98,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct ade7758_state {
> diff --git a/drivers/staging/iio/meter/ade7759.h b/drivers/staging/iio/meter/ade7759.h
> index 813dea2..7387bf7 100644
> --- a/drivers/staging/iio/meter/ade7759.h
> +++ b/drivers/staging/iio/meter/ade7759.h
> @@ -47,7 +47,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct ade7759_state {
> diff --git a/drivers/staging/iio/meter/ade7854.h b/drivers/staging/iio/meter/ade7854.h
> index 47690e5..5240649 100644
> --- a/drivers/staging/iio/meter/ade7854.h
> +++ b/drivers/staging/iio/meter/ade7854.h
> @@ -153,7 +153,7 @@
>   * @indio_dev:		industrial I/O device structure
>   * @trig:		data ready trigger registered with iio
>   * @tx:			transmit buffer
> - * @rx:			recieve buffer
> + * @rx:			receive buffer
>   * @buf_lock:		mutex to protect tx and rx
>   **/
>  struct ade7854_state {
> diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
> index a367991..7a6ecb7 100644
> --- a/drivers/staging/intel_sst/intel_sst_app_interface.c
> +++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
> @@ -871,7 +871,7 @@ int sst_send_algo_ipc(struct ipc_post **msg)
>  }
>  
>  /**
> - * intel_sst_ioctl_dsp - recieves the device ioctl's
> + * intel_sst_ioctl_dsp - receives the device ioctl's
>   *
>   * @cmd:Ioctl cmd
>   * @arg:data
> @@ -1067,7 +1067,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
>  			retval = -EFAULT;
>  			break;
>  		}
> -		pr_debug("SET_VOLUME recieved for %d!\n",
> +		pr_debug("SET_VOLUME received for %d!\n",
>  				set_vol.stream_id);
>  		if (minor == STREAM_MODULE && set_vol.stream_id == 0) {
>  			pr_debug("invalid operation!\n");
> @@ -1085,7 +1085,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
>  			retval = -EFAULT;
>  			break;
>  		}
> -		pr_debug("IOCTL_GET_VOLUME recieved for stream = %d!\n",
> +		pr_debug("IOCTL_GET_VOLUME received for stream = %d!\n",
>  				get_vol.stream_id);
>  		if (minor == STREAM_MODULE && get_vol.stream_id == 0) {
>  			pr_debug("invalid operation!\n");
> @@ -1117,7 +1117,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
>  			retval = -EFAULT;
>  			break;
>  		}
> -		pr_debug("SNDRV_SST_SET_VOLUME recieved for %d!\n",
> +		pr_debug("SNDRV_SST_SET_VOLUME received for %d!\n",
>  			set_mute.stream_id);
>  		if (minor == STREAM_MODULE && set_mute.stream_id == 0) {
>  			retval = -EPERM;
> @@ -1153,7 +1153,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
>  	case _IOC_NR(SNDRV_SST_MMAP_CAPTURE): {
>  		struct snd_sst_mmap_buffs mmap_buf;
>  
> -		pr_debug("SNDRV_SST_MMAP_PLAY/CAPTURE recieved!\n");
> +		pr_debug("SNDRV_SST_MMAP_PLAY/CAPTURE received!\n");
>  		if (minor != STREAM_MODULE) {
>  			retval = -EBADRQC;
>  			break;
> @@ -1239,7 +1239,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
>  	case _IOC_NR(SNDRV_SST_SET_TARGET_DEVICE): {
>  		struct snd_sst_target_device target_device;
>  
> -		pr_debug("SET_TARGET_DEVICE recieved!\n");
> +		pr_debug("SET_TARGET_DEVICE received!\n");
>  		if (copy_from_user(&target_device, (void __user *)arg,
>  				sizeof(target_device))) {
>  			retval = -EFAULT;
> @@ -1256,7 +1256,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
>  	case _IOC_NR(SNDRV_SST_DRIVER_INFO): {
>  		struct snd_sst_driver_info info;
>  
> -		pr_debug("SNDRV_SST_DRIVER_INFO recived\n");
> +		pr_debug("SNDRV_SST_DRIVER_INFO received\n");
>  		info.version = SST_VERSION_NUM;
>  		/* hard coding, shud get sumhow later */
>  		info.active_pcm_streams = sst_drv_ctx->stream_cnt -
> diff --git a/drivers/staging/intel_sst/intel_sst_dsp.c b/drivers/staging/intel_sst/intel_sst_dsp.c
> index 6e5c915..1b56e8b 100644
> --- a/drivers/staging/intel_sst/intel_sst_dsp.c
> +++ b/drivers/staging/intel_sst/intel_sst_dsp.c
> @@ -405,7 +405,7 @@ exit:
>  
>  }
>  
> -/* This function is called when FW requests for a particular libary download
> +/* This function is called when FW requests for a particular library download
>  This function prepares the library to download*/
>  int sst_load_library(struct snd_sst_lib_download *lib, u8 ops)
>  {
> diff --git a/drivers/staging/intel_sst/intel_sst_fw_ipc.h b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
> index 8df313d..0f0c5bb 100644
> --- a/drivers/staging/intel_sst/intel_sst_fw_ipc.h
> +++ b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
> @@ -111,7 +111,7 @@
>  #define IPC_SST_PERIOD_ELAPSED 0x97 /* period elapsed */
>  #define IPC_IA_TARGET_DEV_CHNGD 0x98 /* error in processing a stream */
>  
> -#define IPC_SST_ERROR_EVENT 0x99 /* Buffer over run occured */
> +#define IPC_SST_ERROR_EVENT 0x99 /* Buffer over run occurred */
>  /* L2S messages */
>  #define IPC_SC_DDR_LINK_UP 0xC0
>  #define IPC_SC_DDR_LINK_DOWN 0xC1
> diff --git a/drivers/staging/lirc/lirc_ene0100.h b/drivers/staging/lirc/lirc_ene0100.h
> index 776b693..ed39aa8 100644
> --- a/drivers/staging/lirc/lirc_ene0100.h
> +++ b/drivers/staging/lirc/lirc_ene0100.h
> @@ -81,7 +81,7 @@
>  
>  /* CIR block settings */
>  #define ENE_CIR_CONF1		0xFEC0
> -#define ENE_CIR_CONF1_ADC_ON	0x7	 /* reciever on gpio40 enabled */
> +#define ENE_CIR_CONF1_ADC_ON	0x7	 /* receiver on gpio40 enabled */
>  #define ENE_CIR_CONF1_LEARN1	(1 << 3) /* enabled on learning mode */
>  #define ENE_CIR_CONF1_TX_ON	0x30	 /* enabled on transmit */
>  #define ENE_CIR_CONF1_TX_CARR	(1 << 7) /* send TX carrier or not */
> diff --git a/drivers/staging/octeon/cvmx-helper.c b/drivers/staging/octeon/cvmx-helper.c
> index 5915066..e9c5c83 100644
> --- a/drivers/staging/octeon/cvmx-helper.c
> +++ b/drivers/staging/octeon/cvmx-helper.c
> @@ -691,7 +691,7 @@ int __cvmx_helper_errata_fix_ipd_ptr_alignment(void)
>  
>  		if (!retry_cnt)
>  			cvmx_dprintf("WARNING: FIX_IPD_PTR_ALIGNMENT "
> -				     "get_work() timeout occured.\n");
> +				     "get_work() timeout occurred.\n");
>  
>  		/* Free packet */
>  		if (work)
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
> index 043198d..15aa7c6 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
> @@ -80,7 +80,7 @@ static int dcon_init_xo_1(void)
>  	lob &= ~(1 << DCON_IRQ);
>  	outb(lob, 0x4d0);
>  
> -	/* Register the interupt handler */
> +	/* Register the interrupt handler */
>  	if (request_irq(DCON_IRQ, &dcon_interrupt, 0, "DCON", &dcon_driver)) {
>  		printk(KERN_ERR "olpc-dcon: failed to request DCON's irq\n");
>  		goto err_req_irq;
> diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
> index ed58f48..533dd63 100644
> --- a/drivers/staging/quatech_usb2/quatech_usb2.c
> +++ b/drivers/staging/quatech_usb2/quatech_usb2.c
> @@ -148,7 +148,7 @@ static struct usb_driver quausb2_usb_driver = {
>   * value of the line status flags from the port
>   * @shadowMSR: Last received state of the modem status register, holds
>   * the value of the modem status received from the port
> - * @rcv_flush: Flag indicating that a receive flush has occured on
> + * @rcv_flush: Flag indicating that a receive flush has occurred on
>   * the hardware.
>   * @xmit_flush: Flag indicating that a transmit flush has been processed by
>   * the hardware.
> @@ -156,7 +156,7 @@ static struct usb_driver quausb2_usb_driver = {
>   * includes the size (excluding header) of URBs that have been submitted but
>   * have not yet been sent to to the device, and bytes that have been sent out
>   * of the port but not yet reported sent by the "xmit_empty" messages (which
> - * indicate the number of bytes sent each time they are recieved, despite the
> + * indicate the number of bytes sent each time they are received, despite the
>   * misleading name).
>   * - Starts at zero when port is initialised.
>   * - is incremented by the size of the data to be written (no headers)
> @@ -726,7 +726,7 @@ static int qt2_write(struct tty_struct *tty, struct usb_serial_port *port,
>  		return 0;
>  	} else if (port_extra->tx_pending_bytes >= QT2_FIFO_DEPTH) {
>  		/* buffer is full (==). > should not occur, but would indicate
> -		 * that an overflow had occured */
> +		 * that an overflow had occurred */
>  		dbg("%s(): port transmit buffer is full!", __func__);
>  		/* schedule_work(&port->work); commented in vendor driver */
>  		return 0;
> @@ -823,7 +823,7 @@ static int qt2_write_room(struct tty_struct *tty)
>  	 * reduce the free space count by the size of the dispatched write.
>  	 * When a "transmit empty" message comes back up the USB read stream,
>  	 * we decrement the count by the number of bytes reported sent, thus
> -	 * keeping track of the difference between sent and recieved bytes.
> +	 * keeping track of the difference between sent and received bytes.
>  	 */
>  
>  	room = (QT2_FIFO_DEPTH - port_extra->tx_pending_bytes);
> diff --git a/drivers/staging/rt2860/common/action.c b/drivers/staging/rt2860/common/action.c
> index 56ad236..2f21e66 100644
> --- a/drivers/staging/rt2860/common/action.c
> +++ b/drivers/staging/rt2860/common/action.c
> @@ -456,7 +456,7 @@ void PeerHTAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *Elem)
>  /*
>  	==========================================================================
>  	Description:
> -		Retry sending ADDBA Reqest.
> +		Retry sending ADDBA Request.
>  
>  	IRQL = DISPATCH_LEVEL
>  
> diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
> index b046c2b..ed7f952 100644
> --- a/drivers/staging/rt2860/common/ba_action.c
> +++ b/drivers/staging/rt2860/common/ba_action.c
> @@ -970,7 +970,7 @@ void BASessionTearDownALL(struct rt_rtmp_adapter *pAd, u8 Wcid)
>  /*
>  	==========================================================================
>  	Description:
> -		Retry sending ADDBA Reqest.
> +		Retry sending ADDBA Request.
>  
>  	IRQL = DISPATCH_LEVEL
>  
> @@ -1032,7 +1032,7 @@ void BAOriSessionSetupTimeout(void *SystemSpecific1,
>  /*
>  	==========================================================================
>  	Description:
> -		Retry sending ADDBA Reqest.
> +		Retry sending ADDBA Request.
>  
>  	IRQL = DISPATCH_LEVEL
>  
> diff --git a/drivers/staging/rt2860/common/cmm_data_usb.c b/drivers/staging/rt2860/common/cmm_data_usb.c
> index 7c56c2f..b0de809 100644
> --- a/drivers/staging/rt2860/common/cmm_data_usb.c
> +++ b/drivers/staging/rt2860/common/cmm_data_usb.c
> @@ -702,7 +702,7 @@ Arguments:
>  	*pRxPending			pending received packet flag
>  
>  Return Value:
> -    the recieved packet
> +    the received packet
>  
>  Note:
>  ========================================================================
> diff --git a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/sta/connect.c
> index 4996258..f4f3caa 100644
> --- a/drivers/staging/rt2860/sta/connect.c
> +++ b/drivers/staging/rt2860/sta/connect.c
> @@ -1852,7 +1852,7 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
>  	IRQL = DISPATCH_LEVEL
>  
>  	Note:
> -		We need more information to know it's this requst from AP.
> +		We need more information to know it's this request from AP.
>  		If yes! we need to do extra handling, for example, remove the WPA key.
>  		Otherwise on 4-way handshaking will fail, since the WPA key didn't get
>  		removed while auto reconnect.
> diff --git a/drivers/staging/sbe-2t3e3/io.c b/drivers/staging/sbe-2t3e3/io.c
> index b458ff0..467efbd 100644
> --- a/drivers/staging/sbe-2t3e3/io.c
> +++ b/drivers/staging/sbe-2t3e3/io.c
> @@ -68,7 +68,7 @@ void bootrom_write(struct channel *channel, u32 reg, u32 val)
>  	/* select BootROM address */
>  	dc_write(addr, SBE_2T3E3_21143_REG_BOOT_ROM_PROGRAMMING_ADDRESS, reg & 0x3FFFF);
>  
> -	/* select writting to BootROM */
> +	/* select writing to BootROM */
>  	dc_write(addr, SBE_2T3E3_21143_REG_BOOT_ROM_SERIAL_ROM_AND_MII_MANAGEMENT,
>  		 SBE_2T3E3_21143_VAL_WRITE_OPERATION |
>  		 SBE_2T3E3_21143_VAL_BOOT_ROM_SELECT |
> @@ -312,7 +312,7 @@ void exar7300_write(struct channel *channel, u32 reg, u32 val)
>  	cpld_write_nolock(channel, SBE_2T3E3_CPLD_REG_SERIAL_CHIP_SELECT,
>  			  cpld_val_map[SBE_2T3E3_CPLD_VAL_LIU_SELECT][channel->h.slot]);
>  
> -	/* select writting to Serial I/O Bus */
> +	/* select writing to Serial I/O Bus */
>  	dc_write(addr, SBE_2T3E3_21143_REG_BOOT_ROM_SERIAL_ROM_AND_MII_MANAGEMENT,
>  		 SBE_2T3E3_21143_VAL_WRITE_OPERATION |
>  		 SBE_2T3E3_21143_VAL_SERIAL_ROM_SELECT |
> diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
> index ac5d569..9ae91da 100644
> --- a/drivers/staging/sep/sep_driver.c
> +++ b/drivers/staging/sep/sep_driver.c
> @@ -733,7 +733,7 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
>  	dev_dbg(&sep->pdev->dev, "poll: send_ct is %lx reply ct is %lx\n",
>  		sep->send_ct, sep->reply_ct);
>  
> -	/* Check if error occured during poll */
> +	/* Check if error occurred during poll */
>  	retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
>  	if (retval2 != 0x0) {
>  		dev_warn(&sep->pdev->dev, "poll; poll error %x\n", retval2);
> diff --git a/drivers/staging/spectra/flash.c b/drivers/staging/spectra/flash.c
> index fb39c8e..e74f795 100644
> --- a/drivers/staging/spectra/flash.c
> +++ b/drivers/staging/spectra/flash.c
> @@ -973,7 +973,7 @@ static void process_cmd_fail_abort(int *first_failed_cmd,
>  	if (0 == *first_failed_cmd)
>  		*first_failed_cmd = PendingCMD[idx].SBDCmdIndex;
>  
> -	nand_dbg_print(NAND_DBG_DEBUG, "Uncorrectable error has occured "
> +	nand_dbg_print(NAND_DBG_DEBUG, "Uncorrectable error has occurred "
>  		"while executing %u Command %u accesing Block %u\n",
>  		(unsigned int)p_BTableChangesDelta->ftl_cmd_cnt,
>  		PendingCMD[idx].CMD,
> diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> index 80183a7..9227b1b 100644
> --- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> +++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> @@ -561,7 +561,7 @@ static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
>  	}
>  	/*
>  	 * 2D data sources have only 3 bits for the number of fingers
> -	 * supported - so the encoding is a bit wierd.
> +	 * supported - so the encoding is a bit weird.
>  	 */
>  	if ((queries[1] & MASK_3BIT) <= 4)
>  		/* add 1 since zero based */
> diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
> index 014f5d5..c214df9 100644
> --- a/drivers/staging/tidspbridge/hw/hw_mmu.c
> +++ b/drivers/staging/tidspbridge/hw/hw_mmu.c
> @@ -59,7 +59,7 @@ enum hw_mmu_page_size_t {
>   * RETURNS:
>   *
>   *       Type		: hw_status
> - *       Description     : 0		 -- No errors occured
> + *       Description     : 0		 -- No errors occurred
>   *			 RET_BAD_NULL_PARAM     -- A Pointer
>   *						Paramater was set to NULL
>   *
> @@ -102,7 +102,7 @@ static hw_status mmu_flush_entry(const void __iomem *base_address);
>   * RETURNS:
>   *
>   *       Type	    	: hw_status
> - *       Description     : 0		 -- No errors occured
> + *       Description     : 0		 -- No errors occurred
>   *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
>   *						   was set to NULL
>   *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter out
> @@ -147,7 +147,7 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
>   * RETURNS:
>   *
>   *       Type	    	: hw_status
> - *       Description     : 0		 -- No errors occured
> + *       Description     : 0		 -- No errors occurred
>   *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
>   *							was set to NULL
>   *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter
> diff --git a/drivers/staging/usbvideo/usbvideo.c b/drivers/staging/usbvideo/usbvideo.c
> index f1fcf97..afedfad 100644
> --- a/drivers/staging/usbvideo/usbvideo.c
> +++ b/drivers/staging/usbvideo/usbvideo.c
> @@ -1624,7 +1624,7 @@ static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
>  	 *
>  	 * First things first, make sure we don't copy more than we
>  	 * have - even if the application wants more. That would be
> -	 * a big security embarassment!
> +	 * a big security embarrassment!
>  	 */
>  	if ((count + frame->seqRead_Index) > frame->seqRead_Length)
>  		count = frame->seqRead_Length - frame->seqRead_Index;
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.h b/drivers/staging/vme/bridges/vme_tsi148.h
> index 9f97fa8..a3ac2fe 100644
> --- a/drivers/staging/vme/bridges/vme_tsi148.h
> +++ b/drivers/staging/vme/bridges/vme_tsi148.h
> @@ -212,7 +212,7 @@ static const int TSI148_LCSR_OT[8] = { TSI148_LCSR_OT0, TSI148_LCSR_OT1,
>  #define TSI148_LCSR_OFFSET_OTAT		0x1C
>  
>  /*
> - * VMEbus interupt ack
> + * VMEbus interrupt ack
>   * offset  200
>   */
>  #define TSI148_LCSR_VIACK1	0x204
> @@ -613,7 +613,7 @@ static const int TSI148_GCSR_MBOX[4] = { TSI148_GCSR_MBOX0,
>  /*
>   *  PCI-X Status Register (CRG +$054)
>   */
> -#define TSI148_PCFS_PCIXSTAT_RSCEM     (1<<29)	/* Recieved Split Comp Error */
> +#define TSI148_PCFS_PCIXSTAT_RSCEM     (1<<29)	/* Received Split Comp Error */
>  #define TSI148_PCFS_PCIXSTAT_DMCRS_M   (7<<26)	/* max Cumulative Read Size */
>  #define TSI148_PCFS_PCIXSTAT_DMOST_M   (7<<23)	/* max outstanding Split Trans
>  						 */
> @@ -982,8 +982,8 @@ static const int TSI148_GCSR_MBOX[4] = { TSI148_GCSR_MBOX0,
>  #define TSI148_LCSR_VICR_CNTS_IRQ1     (2<<22)	/* IRQ1 to Cntr */
>  #define TSI148_LCSR_VICR_CNTS_IRQ2     (3<<22)	/* IRQ2 to Cntr */
>  
> -#define TSI148_LCSR_VICR_EDGIS_M       (3<<20)	/* Edge interupt MASK */
> -#define TSI148_LCSR_VICR_EDGIS_DIS     (1<<20)	/* Edge interupt Disable */
> +#define TSI148_LCSR_VICR_EDGIS_M       (3<<20)	/* Edge interrupt MASK */
> +#define TSI148_LCSR_VICR_EDGIS_DIS     (1<<20)	/* Edge interrupt Disable */
>  #define TSI148_LCSR_VICR_EDGIS_IRQ1    (2<<20)	/* IRQ1 to Edge */
>  #define TSI148_LCSR_VICR_EDGIS_IRQ2    (3<<20)	/* IRQ2 to Edge */
>  
> diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
> index f5028d9..eda7fa2 100644
> --- a/drivers/staging/vt6655/device_main.c
> +++ b/drivers/staging/vt6655/device_main.c
> @@ -137,7 +137,7 @@ DEVICE_PARAM(TxDescriptors1,"Number of transmit descriptors1");
>  /* IP_byte_align[] is used for IP header unsigned long byte aligned
>     0: indicate the IP header won't be unsigned long byte aligned.(Default) .
>     1: indicate the IP header will be unsigned long byte aligned.
> -      In some enviroment, the IP header should be unsigned long byte aligned,
> +      In some environment, the IP header should be unsigned long byte aligned,
>        or the packet will be droped when we receive it. (eg: IPVS)
>  */
>  DEVICE_PARAM(IP_byte_align,"Enable IP header dword aligned");
> diff --git a/drivers/staging/vt6655/tether.h b/drivers/staging/vt6655/tether.h
> index 787d885..3b4efb2 100644
> --- a/drivers/staging/vt6655/tether.h
> +++ b/drivers/staging/vt6655/tether.h
> @@ -53,7 +53,7 @@
>  #define TYPE_PKT_802_1x     0x888e
>  #define TYPE_PKT_PreAuth    0x88C7
>  
> -#define TYPE_PKT_PING_M_REQ 0x8011      // master reguest
> +#define TYPE_PKT_PING_M_REQ 0x8011      // master request
>  #define TYPE_PKT_PING_S_GNT 0x8022      // slave grant
>  #define TYPE_PKT_PING_M     0x8077      // pingpong master packet
>  #define TYPE_PKT_PING_S     0x8088      // pingpong slave packet
> @@ -106,7 +106,7 @@
>  #define TYPE_PKT_802_1x     0x8e88
>  #define TYPE_PKT_PreAuth    0xC788
>  
> -#define TYPE_PKT_PING_M_REQ 0x1180      // master reguest
> +#define TYPE_PKT_PING_M_REQ 0x1180      // master request
>  #define TYPE_PKT_PING_S_GNT 0x2280      // slave grant
>  #define TYPE_PKT_PING_M     0x7780      // pingpong master packet
>  #define TYPE_PKT_PING_S     0x8880      // pingpong slave packet
> diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
> index 0d11147..a3cad36 100644
> --- a/drivers/staging/vt6656/baseband.c
> +++ b/drivers/staging/vt6656/baseband.c
> @@ -1096,7 +1096,7 @@ else {
>          pbyAgc = abyVT3184_AGC;
>          wLengthAgc = sizeof(abyVT3184_AGC);
>  
> -        pDevice->abyBBVGA[0] = 0x20; //RobertYu:20060104, reguest by Jack
> +        pDevice->abyBBVGA[0] = 0x20; //RobertYu:20060104, request by Jack
>          pDevice->abyBBVGA[1] = 0x10;
>          pDevice->abyBBVGA[2] = 0x0;
>          pDevice->abyBBVGA[3] = 0x0;
> diff --git a/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c b/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
> index d43dd85..5573533 100644
> --- a/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
> +++ b/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
> @@ -678,7 +678,7 @@ cy_as_read_intr_status(
>  		/*
>  		* queue the mailbox data for later processing.
>  		* this allows the firmware to move forward and
> -		* service the requst from the P port.
> +		* service the request from the P port.
>  		*/
>  		cy_as_ll_queue_mailbox_data(dev_p);
>  
> diff --git a/drivers/staging/westbridge/astoria/api/src/cyasmisc.c b/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
> index 10a52a1..d372e76 100644
> --- a/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
> +++ b/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
> @@ -428,7 +428,7 @@ my_misc_callback(cy_as_device *dev_p, uint8_t context,
>  				if (v & CY_AS_MEM_P0_VM_SET_CFGMODE)
>  					cy_as_hal_print_message(
>  					"initialization message "
> -					"recieved, but config bit "
> +					"received, but config bit "
>  					"still set\n");
>  
>  				v = cy_as_hal_read_register(dev_p->tag,
> @@ -436,7 +436,7 @@ my_misc_callback(cy_as_device *dev_p, uint8_t context,
>  				if ((v & CY_AS_MEM_RST_RSTCMPT) == 0)
>  					cy_as_hal_print_message(
>  					"initialization message "
> -					"recieved, but reset complete "
> +					"received, but reset complete "
>  					"bit still not set\n");
>  			}
>  			break;
> diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
> index e1851f0..43cef26 100644
> --- a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
> +++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
> @@ -117,7 +117,7 @@ struct cyasblkdev_blk_data {
>  	 * 16 * 4K (64 K per request)*/
>  	struct scatterlist	  sg[16];
>  
> -	/* non-zero enables printk of executed reqests */
> +	/* non-zero enables printk of executed requests */
>  	unsigned int	dbgprn_flags;
>  
>  	/*gen_disk for private, system disk */
> diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
> index 0bbb8a3..d1996a2 100644
> --- a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
> +++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
> @@ -222,7 +222,7 @@ static int cyasblkdev_queue_thread(void *d)
>  			continue;
>  		}
>  
> -		/* new req recieved, issue it to the driver  */
> +		/* new req received, issue it to the driver  */
>  		set_current_state(TASK_RUNNING);
>  
>  		#ifndef WESTBRIDGE_NDEBUG
> diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
> index d4bdd3e..bd8d3cc 100644
> --- a/drivers/staging/wlags49_h2/hcf.c
> +++ b/drivers/staging/wlags49_h2/hcf.c
> @@ -1735,7 +1735,7 @@ DESC_STRCT *descp;	// pointer to start of FrameList
>  * - in case encapsulation by the HCF is selected:
>  *	  -	The FrameList does not consists of at least 2 Descriptors.
>  *	  -	The first databuffer does not contain exactly the (space for) the 802.11 header (== 28 words)
> -*	  -	The first databuffer does not have a size to additionally accomodate the 802.3 header and the
> +*	  -	The first databuffer does not have a size to additionally accommodate the 802.3 header and the
>  *		SNAP header of the frame after encapsulation (== 39 words).
>  *	  -	The second databuffer does not contain at least DA, SA and 'type/length' (==14 bytes or 7 words)
>  *!! The 2nd part of the list of asserts should be kept in sync with put_frame_lst, in order to get
> diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
> index 5aa9eb8..5ce3342 100644
> --- a/drivers/staging/wlags49_h2/mdd.h
> +++ b/drivers/staging/wlags49_h2/mdd.h
> @@ -851,7 +851,7 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
>  #define HCF_ERR_LEN					0x08	/* buffer size insufficient
>  		 								  	 *		  -	IFB_ConfigTable too small
>  		 								  	 *		  -	hcf_get_info buffer has a size of 0 or 1 or less than needed
> -		 							  		 *			to accomodate all data
> +		 							  		 *			to accommodate all data
>  		 							  		 *		  -	hcf_put_info: CFG_DLNV_DATA exceeds intermediate
>  											 *		  buffer size */
>  #define HCF_ERR_INCOMP_PRI			0x09	// primary functions are not compatible
> diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
> index 179194e..d540e47 100644
> --- a/drivers/staging/wlan-ng/p80211req.c
> +++ b/drivers/staging/wlan-ng/p80211req.c
> @@ -80,7 +80,7 @@ static int p80211req_mibset_mibget(wlandevice_t *wlandev,
>  /*----------------------------------------------------------------
>  * p80211req_dorequest
>  *
> -* Handles an MLME reqest/confirm message.
> +* Handles an MLME request/confirm message.
>  *
>  * Arguments:
>  *	wlandev		WLAN device struct
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 2521f75..eb30c6e 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -3735,7 +3735,7 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
>  		return PYX_TRANSPORT_LU_COMM_FAILURE;
>  
>  	if (cmd->data_length < 24) {
> -		printk(KERN_WARNING "SPC-PR: Recieved PR OUT parameter list"
> +		printk(KERN_WARNING "SPC-PR: Received PR OUT parameter list"
>  			" length too small: %u\n", cmd->data_length);
>  		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
>  	}
> @@ -3778,7 +3778,7 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
>  	 */
>  	if (!(spec_i_pt) && ((cdb[1] & 0x1f) != PRO_REGISTER_AND_MOVE) &&
>  	    (cmd->data_length != 24)) {
> -		printk(KERN_WARNING "SPC-PR: Recieved PR OUT illegal parameter"
> +		printk(KERN_WARNING "SPC-PR: Received PR OUT illegal parameter"
>  			" list length: %u\n", cmd->data_length);
>  		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
>  	}
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 28b6292..e5389a2 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2567,7 +2567,7 @@ static int transport_execute_tasks(struct se_cmd *cmd)
>  	}
>  	/*
>  	 * Call transport_cmd_check_stop() to see if a fabric exception
> -	 * has occured that prevents execution.
> +	 * has occurred that prevents execution.
>  	 */
>  	if (!(transport_cmd_check_stop(cmd, 0, TRANSPORT_PROCESSING))) {
>  		/*
> diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
> index b001019..0510888 100644
> --- a/drivers/telephony/ixj.c
> +++ b/drivers/telephony/ixj.c
> @@ -487,7 +487,7 @@ DSPbase +
>  8-9		Hardware Status Register			Read Only
>  A-B		Hardware Control Register			Read Write
>  C-D Host Transmit (Write) Data Buffer Access Port (buffer input)Write Only
> -E-F Host Recieve (Read) Data Buffer Access Port (buffer input)	Read Only
> +E-F Host Receive (Read) Data Buffer Access Port (buffer input)	Read Only
>  ************************************************************************/
>  
>  static inline void ixj_read_HSR(IXJ *j)
> diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
> index c3425bb..b6f7d52 100644
> --- a/drivers/tty/hvc/hvc_iucv.c
> +++ b/drivers/tty/hvc/hvc_iucv.c
> @@ -255,7 +255,7 @@ static int hvc_iucv_write(struct hvc_iucv_private *priv,
>  		default:
>  			written = -EIO;
>  		}
> -		/* remove buffer if an error has occured or received data
> +		/* remove buffer if an error has occurred or received data
>  		 * is not correct */
>  		if (rc || (rb->mbuf->version != MSG_VERSION) ||
>  			  (rb->msg.length    != MSG_SIZE(rb->mbuf->datalen)))
> @@ -620,7 +620,7 @@ static void hvc_iucv_hangup(struct hvc_iucv_private *priv)
>   *		the index of an struct hvc_iucv_private instance.
>   *
>   * This routine notifies the HVC back-end that a tty hangup (carrier loss,
> - * virtual or otherwise) has occured.
> + * virtual or otherwise) has occurred.
>   * The z/VM IUCV HVC device driver ignores virtual hangups (vhangup())
>   * to keep an existing IUCV communication path established.
>   * (Background: vhangup() is called from user space (by getty or login) to
> diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
> index 3975df6..e3ddd21 100644
> --- a/drivers/tty/serial/8250.c
> +++ b/drivers/tty/serial/8250.c
> @@ -1616,7 +1616,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
>  			    up->port.iotype == UPIO_DWAPB32) &&
>  			  (iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
>  			/* The DesignWare APB UART has an Busy Detect (0x07)
> -			 * interrupt meaning an LCR write attempt occured while the
> +			 * interrupt meaning an LCR write attempt occurred while the
>  			 * UART was busy. The interrupt must be cleared by reading
>  			 * the UART status register (USR) and the LCR re-written. */
>  			unsigned int status;
> diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
> index e95c524..f723167 100644
> --- a/drivers/tty/serial/bfin_sport_uart.c
> +++ b/drivers/tty/serial/bfin_sport_uart.c
> @@ -261,7 +261,7 @@ static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
>  }
>  #endif
>  
> -/* Reqeust IRQ, Setup clock */
> +/* Request IRQ, Setup clock */
>  static int sport_startup(struct uart_port *port)
>  {
>  	struct sport_uart_port *up = (struct sport_uart_port *)port;
> diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
> index 53a4682..8a869e5 100644
> --- a/drivers/tty/serial/icom.c
> +++ b/drivers/tty/serial/icom.c
> @@ -1248,7 +1248,7 @@ static void icom_set_termios(struct uart_port *port,
>  		}
>  	}
>  
> -	/* Enable Transmitter and Reciever */
> +	/* Enable Transmitter and Receiver */
>  	offset =
>  	    (unsigned long) &ICOM_PORT->statStg->rcv[0] -
>  	    (unsigned long) ICOM_PORT->statStg;
> diff --git a/drivers/tty/serial/jsm/jsm.h b/drivers/tty/serial/jsm/jsm.h
> index 38a509c..b704c8c 100644
> --- a/drivers/tty/serial/jsm/jsm.h
> +++ b/drivers/tty/serial/jsm/jsm.h
> @@ -273,7 +273,7 @@ struct neo_uart_struct {
>  	 u8 fctr;		/* WR	FCTR - Feature Control Reg */
>  	 u8 efr;		/* WR	EFR - Enhanced Function Reg */
>  	 u8 tfifo;		/* WR	TXCNT/TXTRG - Transmit FIFO Reg */
> -	 u8 rfifo;		/* WR	RXCNT/RXTRG - Recieve FIFO Reg */
> +	 u8 rfifo;		/* WR	RXCNT/RXTRG - Receive FIFO Reg */
>  	 u8 xoffchar1;	/* WR	XOFF 1 - XOff Character 1 Reg */
>  	 u8 xoffchar2;	/* WR	XOFF 2 - XOff Character 2 Reg */
>  	 u8 xonchar1;	/* WR	XON 1 - Xon Character 1 Reg */
> diff --git a/drivers/tty/serial/max3107.c b/drivers/tty/serial/max3107.c
> index 910870e..54a03f0 100644
> --- a/drivers/tty/serial/max3107.c
> +++ b/drivers/tty/serial/max3107.c
> @@ -843,7 +843,7 @@ static int max3107_startup(struct uart_port *port)
>  	/* Setup IRQ */
>  	if (request_irq(s->spi->irq, max3107_irq, IRQF_TRIGGER_FALLING,
>  			"max3107", s)) {
> -		dev_err(&s->spi->dev, "IRQ reguest failed\n");
> +		dev_err(&s->spi->dev, "IRQ request failed\n");
>  		destroy_workqueue(s->workqueue);
>  		s->workqueue = NULL;
>  		return -EBUSY;
> diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
> index b62857b..6d18830 100644
> --- a/drivers/tty/serial/mrst_max3110.c
> +++ b/drivers/tty/serial/mrst_max3110.c
> @@ -23,7 +23,7 @@
>   *    1 word. If SPI master controller doesn't support sclk frequency change,
>   *    then the char need be sent out one by one with some delay
>   *
> - * 2. Currently only RX availabe interrrupt is used, no need for waiting TXE
> + * 2. Currently only RX availabe interrupt is used, no need for waiting TXE
>   *    interrupt for a low speed UART device
>   */
>  
> diff --git a/drivers/tty/serial/sn_console.c b/drivers/tty/serial/sn_console.c
> index cff9a30..5b65066 100644
> --- a/drivers/tty/serial/sn_console.c
> +++ b/drivers/tty/serial/sn_console.c
> @@ -481,7 +481,7 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
>  	while (port->sc_ops->sal_input_pending()) {
>  		ch = port->sc_ops->sal_getc();
>  		if (ch < 0) {
> -			printk(KERN_ERR "sn_console: An error occured while "
> +			printk(KERN_ERR "sn_console: An error occurred while "
>  			       "obtaining data from the console (0x%0x)\n", ch);
>  			break;
>  		}
> diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
> index 3f4848e..0a96549 100644
> --- a/drivers/tty/serial/ucc_uart.c
> +++ b/drivers/tty/serial/ucc_uart.c
> @@ -1160,7 +1160,7 @@ static unsigned int soc_info(unsigned int *rev_h, unsigned int *rev_l)
>  }
>  
>  /*
> - * requst_firmware_nowait() callback function
> + * request_firmware_nowait() callback function
>   *
>   * This function is called by the kernel when a firmware is made available,
>   * or if it times out waiting for the firmware.
> diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
> index 99ac70e..9c2dfc7 100644
> --- a/drivers/usb/atm/ueagle-atm.c
> +++ b/drivers/usb/atm/ueagle-atm.c
> @@ -1830,7 +1830,7 @@ static int uea_start_reset(struct uea_softc *sc)
>  
>  	/* mask interrupt */
>  	sc->booting = 1;
> -	/* We need to set this here because, a ack timeout could have occured,
> +	/* We need to set this here because, a ack timeout could have occurred,
>  	 * but before we start the reboot, the ack occurs and set this to 1.
>  	 * So we will failed to wait Ready CMV.
>  	 */
> diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
> index f6b3c25..a03fbc1 100644
> --- a/drivers/usb/c67x00/c67x00-sched.c
> +++ b/drivers/usb/c67x00/c67x00-sched.c
> @@ -907,7 +907,7 @@ static inline int c67x00_end_of_data(struct c67x00_td *td)
>  
>  /* Remove all td's from the list which come
>   * after last_td and are meant for the same pipe.
> - * This is used when a short packet has occured */
> + * This is used when a short packet has occurred */
>  static inline void c67x00_clear_pipe(struct c67x00_hcd *c67x00,
>  				     struct c67x00_td *last_td)
>  {
> diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
> index 5eeb570..b4ea54d 100644
> --- a/drivers/usb/class/cdc-acm.h
> +++ b/drivers/usb/class/cdc-acm.h
> @@ -52,7 +52,7 @@
>   */
>  
>  /*
> - * The only reason to have several buffers is to accomodate assumptions
> + * The only reason to have several buffers is to accommodate assumptions
>   * in line disciplines. They ask for empty space amount, receive our URB size,
>   * and proceed to issue several 1-character writes, assuming they will fit.
>   * The very first write takes a complete URB. Fortunately, this only happens
> diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
> index 6a54634..385acb8 100644
> --- a/drivers/usb/class/usbtmc.c
> +++ b/drivers/usb/class/usbtmc.c
> @@ -483,7 +483,7 @@ static ssize_t usbtmc_read(struct file *filp, char __user *buf,
>  		}
>  
>  		done += n_characters;
> -		/* Terminate if end-of-message bit recieved from device */
> +		/* Terminate if end-of-message bit received from device */
>  		if ((buffer[8] &  0x01) && (actual >= n_characters + 12))
>  			remaining = 0;
>  		else
> diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
> index f8dd726..79918bc 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -278,7 +278,7 @@ static int udc_enable_dev_setup_interrupts(struct udc *dev)
>  	return 0;
>  }
>  
> -/* Calculates fifo start of endpoint based on preceeding endpoints */
> +/* Calculates fifo start of endpoint based on preceding endpoints */
>  static int udc_set_txfifo_addr(struct udc_ep *ep)
>  {
>  	struct udc	*dev;
> @@ -2137,7 +2137,7 @@ static irqreturn_t udc_data_out_isr(struct udc *dev, int ep_ix)
>  	if (use_dma) {
>  		/* BNA event ? */
>  		if (tmp & AMD_BIT(UDC_EPSTS_BNA)) {
> -			DBG(dev, "BNA ep%dout occured - DESPTR = %x \n",
> +			DBG(dev, "BNA ep%dout occurred - DESPTR = %x \n",
>  					ep->num, readl(&ep->regs->desptr));
>  			/* clear BNA */
>  			writel(tmp | AMD_BIT(UDC_EPSTS_BNA), &ep->regs->sts);
> @@ -2151,7 +2151,7 @@ static irqreturn_t udc_data_out_isr(struct udc *dev, int ep_ix)
>  	}
>  	/* HE event ? */
>  	if (tmp & AMD_BIT(UDC_EPSTS_HE)) {
> -		dev_err(&dev->pdev->dev, "HE ep%dout occured\n", ep->num);
> +		dev_err(&dev->pdev->dev, "HE ep%dout occurred\n", ep->num);
>  
>  		/* clear HE */
>  		writel(tmp | AMD_BIT(UDC_EPSTS_HE), &ep->regs->sts);
> @@ -2354,7 +2354,7 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
>  		/* BNA ? */
>  		if (epsts & AMD_BIT(UDC_EPSTS_BNA)) {
>  			dev_err(&dev->pdev->dev,
> -				"BNA ep%din occured - DESPTR = %08lx \n",
> +				"BNA ep%din occurred - DESPTR = %08lx \n",
>  				ep->num,
>  				(unsigned long) readl(&ep->regs->desptr));
>  
> @@ -2367,7 +2367,7 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
>  	/* HE event ? */
>  	if (epsts & AMD_BIT(UDC_EPSTS_HE)) {
>  		dev_err(&dev->pdev->dev,
> -			"HE ep%dn occured - DESPTR = %08lx \n",
> +			"HE ep%dn occurred - DESPTR = %08lx \n",
>  			ep->num, (unsigned long) readl(&ep->regs->desptr));
>  
>  		/* clear HE */
> diff --git a/drivers/usb/gadget/fsl_qe_udc.h b/drivers/usb/gadget/fsl_qe_udc.h
> index bea5b82..e35e24f 100644
> --- a/drivers/usb/gadget/fsl_qe_udc.h
> +++ b/drivers/usb/gadget/fsl_qe_udc.h
> @@ -208,14 +208,14 @@ struct qe_frame{
>  /* Frame status field */
>  /* Receive side */
>  #define FRAME_OK               0x00000000 /* Frame tranmitted or received OK */
> -#define FRAME_ERROR            0x80000000 /* Error occured on frame */
> +#define FRAME_ERROR            0x80000000 /* Error occurred on frame */
>  #define START_FRAME_LOST       0x40000000 /* START_FRAME_LOST */
>  #define END_FRAME_LOST         0x20000000 /* END_FRAME_LOST */
>  #define RX_ER_NONOCT           0x10000000 /* Rx Non Octet Aligned Packet */
>  #define RX_ER_BITSTUFF         0x08000000 /* Frame Aborted --Received packet
>  					     with bit stuff error */
>  #define RX_ER_CRC              0x04000000 /* Received packet with CRC error */
> -#define RX_ER_OVERUN           0x02000000 /* Over-run occured on reception */
> +#define RX_ER_OVERUN           0x02000000 /* Over-run occurred on reception */
>  #define RX_ER_PID              0x01000000 /* Wrong PID received */
>  /* Tranmit side */
>  #define TX_ER_NAK              0x00800000 /* Received NAK handshake */
> @@ -379,7 +379,7 @@ struct qe_udc {
>  #define T_LSP         0x01000000         /* Low-speed transaction */
>  #define T_PID         0x00c00000         /* packet id */
>  #define T_NAK         0x00100000         /* No ack. */
> -#define T_STAL        0x00080000         /* Stall recieved */
> +#define T_STAL        0x00080000         /* Stall received */
>  #define T_TO          0x00040000         /* time out */
>  #define T_UN          0x00020000         /* underrun */
>  
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
> index 4c55eda..008aa27 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -1228,7 +1228,7 @@ static void ch9getstatus(struct fsl_udc *udc, u8 request_type, u16 value,
>  	udc->ep0_dir = USB_DIR_IN;
>  	/* Borrow the per device status_req */
>  	req = udc->status_req;
> -	/* Fill in the reqest structure */
> +	/* Fill in the request structure */
>  	*((u16 *) req->req.buf) = cpu_to_le16(tmp);
>  	req->ep = ep;
>  	req->req.length = 2;
> @@ -1461,7 +1461,7 @@ static int process_ep_req(struct fsl_udc *udc, int pipe,
>  				status = -EILSEQ;
>  				break;
>  			} else
> -				ERR("Unknown error has occured (0x%x)!\n",
> +				ERR("Unknown error has occurred (0x%x)!\n",
>  					errors);
>  
>  		} else if (le32_to_cpu(curr_td->size_ioc_sts)
> diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
> index 1eca8b4..3aa1ab2 100644
> --- a/drivers/usb/gadget/langwell_udc.c
> +++ b/drivers/usb/gadget/langwell_udc.c
> @@ -2186,7 +2186,7 @@ static void get_status(struct langwell_udc *dev, u8 request_type, u16 value,
>  	/* borrow the per device status_req */
>  	req = dev->status_req;
>  
> -	/* fill in the reqest structure */
> +	/* fill in the request structure */
>  	*((u16 *) req->req.buf) = cpu_to_le16(status_data);
>  	req->ep = ep;
>  	req->req.length = 2;
> @@ -2968,7 +2968,7 @@ static irqreturn_t langwell_irq(int irq, void *_dev)
>  		handle_port_change(dev);
>  	}
>  
> -	/* suspend interrrupt */
> +	/* suspend interrupt */
>  	if (irq_sts & STS_SLI) {
>  		dev_vdbg(&dev->pdev->dev, "suspend interrupt\n");
>  		handle_bus_suspend(dev);
> diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
> index d5468a7..3f6e246 100644
> --- a/drivers/usb/gadget/mv_udc_core.c
> +++ b/drivers/usb/gadget/mv_udc_core.c
> @@ -1310,7 +1310,7 @@ udc_prime_status(struct mv_udc *udc, u8 direction, u16 status, bool empty)
>  
>  	req = udc->status_req;
>  
> -	/* fill in the reqest structure */
> +	/* fill in the request structure */
>  	if (empty == false) {
>  		*((u16 *) req->req.buf) = cpu_to_le16(status);
>  		req->req.length = 2;
> @@ -1845,7 +1845,7 @@ static irqreturn_t mv_udc_irq(int irq, void *dev)
>  		return IRQ_NONE;
>  	}
>  
> -	/* Clear all the interrupts occured */
> +	/* Clear all the interrupts occurred */
>  	writel(status, &udc->op_regs->usbsts);
>  
>  	if (status & USBSTS_ERR)
> diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> index b120dbb..3ae2ca3 100644
> --- a/drivers/usb/gadget/pch_udc.c
> +++ b/drivers/usb/gadget/pch_udc.c
> @@ -809,7 +809,7 @@ static inline u32 pch_udc_read_ep_interrupts(struct pch_udc_dev *dev)
>  }
>  
>  /**
> - * pch_udc_write_ep_interrupts() - Clear endpoint interupts
> + * pch_udc_write_ep_interrupts() - Clear endpoint interrupts
>   * @dev:	Reference to structure of type pch_udc_regs
>   * @val:	The value to be written to interrupt register
>   */
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index ef825c3..271c130 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -1176,7 +1176,7 @@ static void s3c_hsotg_process_control(struct s3c_hsotg *hsotg,
>  		writel(ctrl, hsotg->regs + reg);
>  
>  		dev_dbg(hsotg->dev,
> -			"writen DxEPCTL=0x%08x to %08x (DxEPCTL=0x%08x)\n",
> +			"written DxEPCTL=0x%08x to %08x (DxEPCTL=0x%08x)\n",
>  			ctrl, reg, readl(hsotg->regs + reg));
>  
>  		/* don't belive we need to anything more to get the EP
> @@ -2188,7 +2188,7 @@ irq_retry:
>  
>  	/* these next two seem to crop-up occasionally causing the core
>  	 * to shutdown the USB transfer, so try clearing them and logging
> -	 * the occurence. */
> +	 * the occurrence. */
>  
>  	if (gintsts & S3C_GINTSTS_GOUTNakEff) {
>  		dev_info(hsotg->dev, "GOUTNakEff triggered\n");
> diff --git a/drivers/usb/host/fhci-tds.c b/drivers/usb/host/fhci-tds.c
> index 38fe058..52c261a 100644
> --- a/drivers/usb/host/fhci-tds.c
> +++ b/drivers/usb/host/fhci-tds.c
> @@ -40,7 +40,7 @@
>  #define TD_RXER		0x0020 /* Rx error or not */
>  
>  #define TD_NAK		0x0010 /* No ack. */
> -#define TD_STAL		0x0008 /* Stall recieved */
> +#define TD_STAL		0x0008 /* Stall received */
>  #define TD_TO		0x0004 /* time out */
>  #define TD_UN		0x0002 /* underrun */
>  #define TD_NO		0x0010 /* Rx Non Octet Aligned Packet */
> @@ -337,7 +337,7 @@ static void fhci_td_transaction_confirm(struct fhci_usb *usb)
>  					pkt->status = USB_TD_RX_ER_NONOCT;
>  				else
>  					fhci_err(usb->fhci, "illegal error "
> -						 "occured\n");
> +						 "occurred\n");
>  			} else if (td_status & TD_NAK)
>  				pkt->status = USB_TD_TX_ER_NAK;
>  			else if (td_status & TD_TO)
> @@ -347,7 +347,7 @@ static void fhci_td_transaction_confirm(struct fhci_usb *usb)
>  			else if (td_status & TD_STAL)
>  				pkt->status = USB_TD_TX_ER_STALL;
>  			else
> -				fhci_err(usb->fhci, "illegal error occured\n");
> +				fhci_err(usb->fhci, "illegal error occurred\n");
>  		} else if ((extra_data & TD_TOK_IN) &&
>  				pkt->len > td_length - CRC_SIZE) {
>  			pkt->status = USB_TD_RX_DATA_UNDERUN;
> diff --git a/drivers/usb/host/fhci.h b/drivers/usb/host/fhci.h
> index 71c3caa..d16bc8d 100644
> --- a/drivers/usb/host/fhci.h
> +++ b/drivers/usb/host/fhci.h
> @@ -82,7 +82,7 @@
>  #define USB_TD_RX_ER_NONOCT	0x40000000 /* Tx Non Octet Aligned Packet */
>  #define USB_TD_RX_ER_BITSTUFF	0x20000000 /* Frame Aborted-Received pkt */
>  #define USB_TD_RX_ER_CRC	0x10000000 /* CRC error */
> -#define USB_TD_RX_ER_OVERUN	0x08000000 /* Over - run occured */
> +#define USB_TD_RX_ER_OVERUN	0x08000000 /* Over - run occurred */
>  #define USB_TD_RX_ER_PID	0x04000000 /* wrong PID received */
>  #define USB_TD_RX_DATA_UNDERUN	0x02000000 /* shorter than expected */
>  #define USB_TD_RX_DATA_OVERUN	0x01000000 /* longer than expected */
> diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
> index e0cb12b..1455c11 100644
> --- a/drivers/usb/host/oxu210hp-hcd.c
> +++ b/drivers/usb/host/oxu210hp-hcd.c
> @@ -2879,7 +2879,7 @@ static int oxu_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
>  	/* Ok, we have more job to do! :) */
>  
>  	for (i = 0; i < num - 1; i++) {
> -		/* Get free micro URB poll till a free urb is recieved */
> +		/* Get free micro URB poll till a free urb is received */
>  
>  		do {
>  			murb = (struct urb *) oxu_murb_alloc(oxu);
> @@ -2911,7 +2911,7 @@ static int oxu_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
>  
>  	/* Last urb requires special handling  */
>  
> -	/* Get free micro URB poll till a free urb is recieved */
> +	/* Get free micro URB poll till a free urb is received */
>  	do {
>  		murb = (struct urb *) oxu_murb_alloc(oxu);
>  		if (!murb)
> diff --git a/drivers/usb/host/whci/whcd.h b/drivers/usb/host/whci/whcd.h
> index c80c7d9..460f054 100644
> --- a/drivers/usb/host/whci/whcd.h
> +++ b/drivers/usb/host/whci/whcd.h
> @@ -113,7 +113,7 @@ struct whc_std {
>   * @urb: the URB this struct is for.
>   * @qset: the qset associated to the URB.
>   * @dequeue_work: the work to remove the URB when dequeued.
> - * @is_async: the URB belongs to async sheduler or not.
> + * @is_async: the URB belongs to async scheduler or not.
>   * @status: the status to be returned when calling wusbhc_giveback_urb.
>   */
>  struct whc_urb {
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> index 2fe3046..c5d03e0 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -699,7 +699,7 @@ static void rxstate(struct musb *musb, struct musb_request *req)
>  	 * most these gadgets, end of is signified either by a short packet,
>  	 * or filling the last byte of the buffer.  (Sending extra data in
>  	 * that last pckate should trigger an overflow fault.)  But in mode 1,
> -	 * we don't get DMA completion interrrupt for short packets.
> +	 * we don't get DMA completion interrupt for short packets.
>  	 *
>  	 * Theoretically, we could enable DMAReq irq (MUSB_RXCSR_DMAMODE = 1),
>  	 * to get endpoint interrupt on every DMA req, but that didn't seem
> diff --git a/drivers/uwb/drp.c b/drivers/uwb/drp.c
> index a8d83e2..458326d 100644
> --- a/drivers/uwb/drp.c
> +++ b/drivers/uwb/drp.c
> @@ -741,12 +741,12 @@ void uwb_drp_process_all(struct uwb_rc *rc, struct uwb_rc_evt_drp *drp_evt,
>   * DRP notifications can occur for three different reasons:
>   *
>   * - UWB_DRP_NOTIF_DRP_IE_RECVD: one or more DRP IEs with the RC as
> - *   the target or source have been recieved.
> + *   the target or source have been received.
>   *
>   *   These DRP IEs could be new or for an existing reservation.
>   *
>   *   If the DRP IE for an existing reservation ceases to be to
> - *   recieved for at least mMaxLostBeacons, the reservation should be
> + *   received for at least mMaxLostBeacons, the reservation should be
>   *   considered to be terminated.  Note that the TERMINATE reason (see
>   *   below) may not always be signalled (e.g., the remote device has
>   *   two or more reservations established with the RC).
> diff --git a/drivers/uwb/reset.c b/drivers/uwb/reset.c
> index 2784929..3de630b 100644
> --- a/drivers/uwb/reset.c
> +++ b/drivers/uwb/reset.c
> @@ -52,7 +52,7 @@ const char *__strerror[] = {
>  	"cancelled",
>  	"invalid state",
>  	"invalid size",
> -	"ack not recieved",
> +	"ack not received",
>  	"no more asie notification",
>  };
>  
> diff --git a/drivers/video/aty/mach64_cursor.c b/drivers/video/aty/mach64_cursor.c
> index 2ba8b3c..e6c60ed 100644
> --- a/drivers/video/aty/mach64_cursor.c
> +++ b/drivers/video/aty/mach64_cursor.c
> @@ -17,7 +17,7 @@
>  
>  /*
>   * The hardware cursor definition requires 2 bits per pixel. The
> - * Cursor size reguardless of the visible cursor size is 64 pixels
> + * Cursor size regardless of the visible cursor size is 64 pixels
>   * by 64 lines. The total memory required to define the cursor is
>   * 16 bytes / line for 64 lines or 1024 bytes of data. The data
>   * must be in a contigiuos format. The 2 bit cursor code values are
> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
> index 8d61ef9..8b7d473 100644
> --- a/drivers/video/da8xx-fb.c
> +++ b/drivers/video/da8xx-fb.c
> @@ -763,7 +763,7 @@ static int fb_wait_for_vsync(struct fb_info *info)
>  
>  	/*
>  	 * Set flag to 0 and wait for isr to set to 1. It would seem there is a
> -	 * race condition here where the ISR could have occured just before or
> +	 * race condition here where the ISR could have occurred just before or
>  	 * just after this set. But since we are just coarsely waiting for
>  	 * a frame to complete then that's OK. i.e. if the frame completed
>  	 * just before this code executed then we have to wait another full
> diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
> index f4a3277..04251ce 100644
> --- a/drivers/video/fbsysfs.c
> +++ b/drivers/video/fbsysfs.c
> @@ -33,7 +33,7 @@
>   * for driver private data (info->par). info->par (if any) will be
>   * aligned to sizeof(long).
>   *
> - * Returns the new structure, or NULL if an error occured.
> + * Returns the new structure, or NULL if an error occurred.
>   *
>   */
>  struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
> diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
> index 2ffce4d..b6a2b58 100644
> --- a/drivers/watchdog/acquirewdt.c
> +++ b/drivers/watchdog/acquirewdt.c
> @@ -26,7 +26,7 @@
>   *	Theory of Operation:
>   *		The Watch-Dog Timer is provided to ensure that standalone
>   *		Systems can always recover from catastrophic conditions that
> - *		caused the CPU to crash. This condition may have occured by
> + *		caused the CPU to crash. This condition may have occurred by
>   *		external EMI or a software bug. When the CPU stops working
>   *		correctly, hardware on the board will either perform a hardware
>   *		reset (cold boot) or a non-maskable interrupt (NMI) to bring the
> diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
> index 0461858..ced0264 100644
> --- a/drivers/watchdog/sch311x_wdt.c
> +++ b/drivers/watchdog/sch311x_wdt.c
> @@ -201,7 +201,7 @@ static void sch311x_wdt_get_status(int *status)
>  	spin_lock(&sch311x_wdt_data.io_lock);
>  
>  	/* -- Watchdog timer control --
> -	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
> +	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occurred
>  	 * Bit 1   Reserved
>  	 * Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
>  	 * Bit 3   P20 Force Timeout enabled:
> diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
> index 8a1f0bc..4b3462b 100644
> --- a/drivers/watchdog/smsc37b787_wdt.c
> +++ b/drivers/watchdog/smsc37b787_wdt.c
> @@ -191,7 +191,7 @@ static inline void wdt_timer_conf(unsigned char conf)
>  static inline void wdt_timer_ctrl(unsigned char reg)
>  {
>  	/* -- Watchdog timer control --
> -	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
> +	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occurred
>  	 * Bit 1   Power LED Toggle: 0 = Disable Toggle, 1 = Toggle at 1 Hz
>  	 * Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
>  	 * Bit 3   P20 Force Timeout enabled:
> diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
> index 9127eda..5f405ce 100644
> --- a/drivers/watchdog/sp805_wdt.c
> +++ b/drivers/watchdog/sp805_wdt.c
> @@ -90,7 +90,7 @@ static void wdt_setload(unsigned int timeout)
>  	/*
>  	 * sp805 runs counter with given value twice, after the end of first
>  	 * counter it gives an interrupt and then starts counter again. If
> -	 * interrupt already occured then it resets the system. This is why
> +	 * interrupt already occurred then it resets the system. This is why
>  	 * load is half of what should be required.
>  	 */
>  	load = div_u64(rate, 2) * timeout - 1;
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 7468147..5d08441 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -5,7 +5,7 @@
>   * domain gets 1024 event channels, but NR_IRQ is not that large, we
>   * must dynamically map irqs<->event channels.  The event channels
>   * interface with the rest of the kernel by defining a xen interrupt
> - * chip.  When an event is recieved, it is mapped to an irq and sent
> + * chip.  When an event is received, it is mapped to an irq and sent
>   * through the normal interrupt processing path.
>   *
>   * There are four kinds of events which can be mapped to an event
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a004008..f5b243b 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -916,7 +916,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
>  		avail_space *= BTRFS_STRIPE_LEN;
>  
>  		/*
> -		 * In order to avoid overwritting the superblock on the drive,
> +		 * In order to avoid overwriting the superblock on the drive,
>  		 * btrfs starts at an offset of at least 1MB when doing chunk
>  		 * allocation.
>  		 */
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 6b61ded..5323c33 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -765,7 +765,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>  			if (touch) {
>  				struct rb_node *q;
>  
> -				/* touch this + preceeding caps */
> +				/* touch this + preceding caps */
>  				__touch_cap(cap);
>  				for (q = rb_first(&ci->i_caps); q != p;
>  				     q = rb_next(q)) {
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index bd33f87..b1539ce 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -889,7 +889,7 @@ static int truncate_upper(struct dentry *dentry, struct iattr *ia,
>  
>  
>  		/*
> -		 * XXX(truncate) this should really happen at the begginning
> +		 * XXX(truncate) this should really happen at the beginning
>  		 * of ->setattr.  But the code is too messy to that as part
>  		 * of a larger patch.  ecryptfs is also totally missing out
>  		 * on the inode_change_ok check at the beginning of
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index 758323a..e2423c4 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -840,7 +840,7 @@ static int __init ecryptfs_init(void)
>  	}
>  	rc = ecryptfs_init_messaging();
>  	if (rc) {
> -		printk(KERN_ERR "Failure occured while attempting to "
> +		printk(KERN_ERR "Failure occurred while attempting to "
>  				"initialize the communications channel to "
>  				"ecryptfsd\n");
>  		goto out_destroy_kthread;
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ccce8a7..f830e3c 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1649,7 +1649,7 @@ out:
>  
>  /*
>   * ext4_ext_insert_extent:
> - * tries to merge requsted extent into the existing extent or
> + * tries to merge requested extent into the existing extent or
>   * inserts requested extent as new one into the tree,
>   * creating new leaf in the no-space case.
>   */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9f7f9e4..af83cc7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3791,7 +3791,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>   		 * We could direct write to holes and fallocate.
>  		 *
>   		 * Allocated blocks to fill the hole are marked as uninitialized
> - 		 * to prevent paralel buffered read to expose the stale data
> + 		 * to prevent parallel buffered read to expose the stale data
>   		 * before DIO complete the data IO.
>  		 *
>   		 * As to previously fallocated extents, ext4 get_block
> diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
> index d32ee94..2ab1a0d 100644
> --- a/fs/jffs2/readinode.c
> +++ b/fs/jffs2/readinode.c
> @@ -24,7 +24,7 @@
>   *
>   * Returns: 0 if the data CRC is correct;
>   * 	    1 - if incorrect;
> - *	    error code if an error occured.
> + *	    error code if an error occurred.
>   */
>  static int check_node_data(struct jffs2_sb_info *c, struct jffs2_tmp_dnode_info *tn)
>  {
> diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
> index 3a09423..8adc50a 100644
> --- a/fs/jfs/jfs_imap.c
> +++ b/fs/jfs/jfs_imap.c
> @@ -1069,7 +1069,7 @@ int diFree(struct inode *ip)
>  		 */
>  		if (iagp->nfreeexts == cpu_to_le32(EXTSPERIAG - 1)) {
>  			/* in preparation for removing the iag from the
> -			 * ag extent free list, read the iags preceeding
> +			 * ag extent free list, read the iags preceding
>  			 * and following the iag on the ag extent free
>  			 * list.
>  			 */
> @@ -1095,7 +1095,7 @@ int diFree(struct inode *ip)
>  		int inofreefwd = le32_to_cpu(iagp->inofreefwd);
>  
>  		/* in preparation for removing the iag from the
> -		 * ag inode free list, read the iags preceeding
> +		 * ag inode free list, read the iags preceding
>  		 * and following the iag on the ag inode free
>  		 * list.  before reading these iags, we must make
>  		 * sure that we already don't have them in hand
> @@ -2036,7 +2036,7 @@ static int diAllocBit(struct inomap * imap, struct iag * iagp, int ino)
>  
>  	/* check if this is the last free inode within the iag.
>  	 * if so, it will have to be removed from the ag free
> -	 * inode list, so get the iags preceeding and following
> +	 * inode list, so get the iags preceding and following
>  	 * it on the list.
>  	 */
>  	if (iagp->nfreeinos == cpu_to_le32(1)) {
> @@ -2208,7 +2208,7 @@ static int diNewExt(struct inomap * imap, struct iag * iagp, int extno)
>  
>  	/* check if this is the last free extent within the
>  	 * iag.  if so, the iag must be removed from the ag
> -	 * free extent list, so get the iags preceeding and
> +	 * free extent list, so get the iags preceding and
>  	 * following the iag on this list.
>  	 */
>  	if (iagp->nfreeexts == cpu_to_le32(1)) {
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 7bf029e..7051f5e 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -301,7 +301,7 @@ nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
>   * disk, but it retrieves and clears ctx->error after synching, despite
>   * the two being set at the same time in nfs_context_set_write_error().
>   * This is because the former is used to notify the _next_ call to
> - * nfs_file_write() that a write error occured, and hence cause it to
> + * nfs_file_write() that a write error occurred, and hence cause it to
>   * fall back to doing a synchronous write.
>   */
>  static int
> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index d98d021..99d7f6b 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -3647,7 +3647,7 @@ find_lockstateowner_str(struct inode *inode, clientid_t *clid,
>  /*
>   * Alloc a lock owner structure.
>   * Called in nfsd4_lock - therefore, OPEN and OPEN_CONFIRM (if needed) has 
> - * occured. 
> + * occurred. 
>   *
>   * strhashval = lock_ownerstr_hashval 
>   */
> diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
> index a91b69a..09f630c 100644
> --- a/fs/notify/inotify/inotify_fsnotify.c
> +++ b/fs/notify/inotify/inotify_fsnotify.c
> @@ -9,7 +9,7 @@
>   * Copyright 2006 Hewlett-Packard Development Company, L.P.
>   *
>   * Copyright (C) 2009 Eric Paris <Red Hat Inc>
> - * inotify was largely rewriten to make use of the fsnotify infrastructure
> + * inotify was largely rewritten to make use of the fsnotify infrastructure
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index 4cd5d5d..d9bc04d 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -9,7 +9,7 @@
>   * Copyright 2006 Hewlett-Packard Development Company, L.P.
>   *
>   * Copyright (C) 2009 Eric Paris <Red Hat Inc>
> - * inotify was largely rewriten to make use of the fsnotify infrastructure
> + * inotify was largely rewritten to make use of the fsnotify infrastructure
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the
> diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
> index f5094ee..0990be5 100644
> --- a/fs/ntfs/attrib.c
> +++ b/fs/ntfs/attrib.c
> @@ -1181,7 +1181,7 @@ not_found:
>   * for, i.e. if one wants to add the attribute to the mft record this is the
>   * correct place to insert its attribute list entry into.
>   *
> - * When -errno != -ENOENT, an error occured during the lookup.  @ctx->attr is
> + * When -errno != -ENOENT, an error occurred during the lookup.  @ctx->attr is
>   * then undefined and in particular you should not rely on it not changing.
>   */
>  int ntfs_attr_lookup(const ATTR_TYPE type, const ntfschar *name,
> diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
> index a627ed8..dbe32b5 100644
> --- a/fs/ntfs/inode.c
> +++ b/fs/ntfs/inode.c
> @@ -2529,7 +2529,7 @@ retry_truncate:
>  		 * specifies that the behaviour is unspecified thus we do not
>  		 * have to do anything.  This means that in our implementation
>  		 * in the rare case that the file is mmap()ped and a write
> -		 * occured into the mmap()ped region just beyond the file size
> +		 * occurred into the mmap()ped region just beyond the file size
>  		 * and writepage has not yet been called to write out the page
>  		 * (which would clear the area beyond the file size) and we now
>  		 * extend the file size to incorporate this dirty region
> diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
> index 4dadcdf..c71de29 100644
> --- a/fs/ntfs/logfile.c
> +++ b/fs/ntfs/logfile.c
> @@ -669,7 +669,7 @@ err_out:
>   * of cases where we think that a volume is dirty when in fact it is clean.
>   * This should only affect volumes that have not been shutdown cleanly but did
>   * not have any pending, non-check-pointed i/o, i.e. they were completely idle
> - * at least for the five seconds preceeding the unclean shutdown.
> + * at least for the five seconds preceding the unclean shutdown.
>   *
>   * This function assumes that the $LogFile journal has already been consistency
>   * checked by a call to ntfs_check_logfile() and in particular if the $LogFile
> diff --git a/fs/ntfs/logfile.h b/fs/ntfs/logfile.h
> index b5a6f08..aa2b6ac 100644
> --- a/fs/ntfs/logfile.h
> +++ b/fs/ntfs/logfile.h
> @@ -222,7 +222,7 @@ typedef struct {
>  /* 24*/	sle64 file_size;	/* Usable byte size of the log file.  If the
>  				   restart_area_offset + the offset of the
>  				   file_size are > 510 then corruption has
> -				   occured.  This is the very first check when
> +				   occurred.  This is the very first check when
>  				   starting with the restart_area as if it
>  				   fails it means that some of the above values
>  				   will be corrupted by the multi sector
> diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
> index 326e747..35cdee3 100644
> --- a/fs/ntfs/mft.c
> +++ b/fs/ntfs/mft.c
> @@ -1442,7 +1442,7 @@ static int ntfs_mft_bitmap_extend_allocation_nolock(ntfs_volume *vol)
>  		// Note: It will need to be a special mft record and if none of
>  		// those are available it gets rather complicated...
>  		ntfs_error(vol->sb, "Not enough space in this mft record to "
> -				"accomodate extended mft bitmap attribute "
> +				"accommodate extended mft bitmap attribute "
>  				"extent.  Cannot handle this yet.");
>  		ret = -EOPNOTSUPP;
>  		goto undo_alloc;
> @@ -1879,7 +1879,7 @@ static int ntfs_mft_data_extend_allocation_nolock(ntfs_volume *vol)
>  		// and we would then need to update all references to this mft
>  		// record appropriately.  This is rather complicated...
>  		ntfs_error(vol->sb, "Not enough space in this mft record to "
> -				"accomodate extended mft data attribute "
> +				"accommodate extended mft data attribute "
>  				"extent.  Cannot handle this yet.");
>  		ret = -EOPNOTSUPP;
>  		goto undo_alloc;
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 29099a0..b52706d 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -458,7 +458,7 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
>  	 * the volume on boot and updates them.
>  	 *
>  	 * When remounting read-only, mark the volume clean if no volume errors
> -	 * have occured.
> +	 * have occurred.
>  	 */
>  	if ((sb->s_flags & MS_RDONLY) && !(*flags & MS_RDONLY)) {
>  		static const char *es = ".  Cannot remount read-write.";
> @@ -1269,7 +1269,7 @@ static int check_windows_hibernation_status(ntfs_volume *vol)
>  					"hibernated on the volume.");
>  			return 0;
>  		}
> -		/* A real error occured. */
> +		/* A real error occurred. */
>  		ntfs_error(vol->sb, "Failed to find inode number for "
>  				"hiberfil.sys.");
>  		return ret;
> @@ -1370,7 +1370,7 @@ static bool load_and_init_quota(ntfs_volume *vol)
>  			NVolSetQuotaOutOfDate(vol);
>  			return true;
>  		}
> -		/* A real error occured. */
> +		/* A real error occurred. */
>  		ntfs_error(vol->sb, "Failed to find inode number for $Quota.");
>  		return false;
>  	}
> @@ -1454,7 +1454,7 @@ not_enabled:
>  			NVolSetUsnJrnlStamped(vol);
>  			return true;
>  		}
> -		/* A real error occured. */
> +		/* A real error occurred. */
>  		ntfs_error(vol->sb, "Failed to find inode number for "
>  				"$UsnJrnl.");
>  		return false;
> @@ -2292,7 +2292,7 @@ static void ntfs_put_super(struct super_block *sb)
>  	ntfs_commit_inode(vol->mft_ino);
>  
>  	/*
> -	 * If a read-write mount and no volume errors have occured, mark the
> +	 * If a read-write mount and no volume errors have occurred, mark the
>  	 * volume clean.  Also, re-commit all affected inodes.
>  	 */
>  	if (!(sb->s_flags & MS_RDONLY)) {
> @@ -2496,7 +2496,7 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
>  	if (vol->nr_clusters & 63)
>  		nr_free += 64 - (vol->nr_clusters & 63);
>  	up_read(&vol->lcnbmp_lock);
> -	/* If errors occured we may well have gone below zero, fix this. */
> +	/* If errors occurred we may well have gone below zero, fix this. */
>  	if (nr_free < 0)
>  		nr_free = 0;
>  	ntfs_debug("Exiting.");
> @@ -2561,7 +2561,7 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
>  	}
>  	ntfs_debug("Finished reading $MFT/$BITMAP, last index = 0x%lx.",
>  			index - 1);
> -	/* If errors occured we may well have gone below zero, fix this. */
> +	/* If errors occurred we may well have gone below zero, fix this. */
>  	if (nr_free < 0)
>  		nr_free = 0;
>  	ntfs_debug("Exiting.");
> diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
> index a873667..7f6600e 100644
> --- a/fs/ocfs2/cluster/quorum.c
> +++ b/fs/ocfs2/cluster/quorum.c
> @@ -89,7 +89,7 @@ static void o2quo_fence_self(void)
>  	};
>  }
>  
> -/* Indicate that a timeout occured on a hearbeat region write. The
> +/* Indicate that a timeout occurred on a hearbeat region write. The
>   * other nodes in the cluster may consider us dead at that time so we
>   * want to "fence" ourselves so that we don't scribble on the disk
>   * after they think they've recovered us. This can't solve all
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 849fb4a..93bb426 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2129,7 +2129,7 @@ leave:
>  }
>  
>  /**
> - * ocfs2_prep_new_orphaned_file() - Prepare the orphan dir to recieve a newly
> + * ocfs2_prep_new_orphaned_file() - Prepare the orphan dir to receive a newly
>   * allocated file. This is different from the typical 'add to orphan dir'
>   * operation in that the inode does not yet exist. This is a problem because
>   * the orphan dir stringifies the inode block number to come up with it's
> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
> index 8ce7398..1ec56fd 100644
> --- a/fs/ocfs2/stackglue.h
> +++ b/fs/ocfs2/stackglue.h
> @@ -126,7 +126,7 @@ struct ocfs2_stack_operations {
>  	 *
>  	 * ->connect() must not return until it is guaranteed that
>  	 *
> -	 *  - Node down notifications for the filesystem will be recieved
> +	 *  - Node down notifications for the filesystem will be received
>  	 *    and passed to conn->cc_recovery_handler().
>  	 *  - Locking requests for the filesystem will be processed.
>  	 */
> diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
> index 3cfb2e9..fdef5f8 100644
> --- a/fs/reiserfs/xattr.c
> +++ b/fs/reiserfs/xattr.c
> @@ -396,7 +396,7 @@ static struct page *reiserfs_get_page(struct inode *dir, size_t n)
>  	struct address_space *mapping = dir->i_mapping;
>  	struct page *page;
>  	/* We can deadlock if we try to free dentries,
> -	   and an unlink/rmdir has just occured - GFP_NOFS avoids this */
> +	   and an unlink/rmdir has just occurred - GFP_NOFS avoids this */
>  	mapping_set_gfp_mask(mapping, GFP_NOFS);
>  	page = read_mapping_page(mapping, n >> PAGE_CACHE_SHIFT, NULL);
>  	if (!IS_ERR(page)) {
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index c6a2e78..54a7964 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -647,7 +647,7 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
>  		iinfo->i_lenExtents += inode->i_sb->s_blocksize;
>  	}
>  
> -	/* if the extent the requsted block is located in contains multiple
> +	/* if the extent the requested block is located in contains multiple
>  	 * blocks, split the extent into at most three extents. blocks prior
>  	 * to requested block, requested block, and blocks after requested
>  	 * block */
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index a55c1b4..15b2c84 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -381,7 +381,7 @@ xfs_aio_write_isize_update(
>  
>  /*
>   * If this was a direct or synchronous I/O that failed (such as ENOSPC) then
> - * part of the I/O may have been written to disk before the error occured.  In
> + * part of the I/O may have been written to disk before the error occurred.  In
>   * this case the on-disk file size may have been adjusted beyond the in-memory
>   * file size and now needs to be truncated back.
>   */
> diff --git a/fs/xfs/quota/xfs_qm_bhv.c b/fs/xfs/quota/xfs_qm_bhv.c
> index 45b5cb1..a133058 100644
> --- a/fs/xfs/quota/xfs_qm_bhv.c
> +++ b/fs/xfs/quota/xfs_qm_bhv.c
> @@ -135,7 +135,7 @@ xfs_qm_newmount(
>  		 */
>  		if (quotaondisk && !XFS_QM_NEED_QUOTACHECK(mp)) {
>  			/*
> -			 * If an error occured, qm_mount_quotas code
> +			 * If an error occurred, qm_mount_quotas code
>  			 * has already disabled quotas. So, just finish
>  			 * mounting, and get on with the boring life
>  			 * without disk quotas.
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index aa0ebb7..28bf589 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -101,7 +101,7 @@ xlog_get_bp(
>  	/*
>  	 * We do log I/O in units of log sectors (a power-of-2
>  	 * multiple of the basic block size), so we round up the
> -	 * requested size to acommodate the basic blocks required
> +	 * requested size to accommodate the basic blocks required
>  	 * for complete log sectors.
>  	 *
>  	 * In addition, the buffer may be used for a non-sector-
> @@ -112,7 +112,7 @@ xlog_get_bp(
>  	 * an issue.  Nor will this be a problem if the log I/O is
>  	 * done in basic blocks (sector size 1).  But otherwise we
>  	 * extend the buffer by one extra log sector to ensure
> -	 * there's space to accomodate this possiblility.
> +	 * there's space to accommodate this possiblility.
>  	 */
>  	if (nbblks > 1 && log->l_sectBBsize > 1)
>  		nbblks += log->l_sectBBsize;
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index d8e6f8c..da58fef 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -953,7 +953,7 @@ xfs_release(
>  		 * If we previously truncated this file and removed old data
>  		 * in the process, we want to initiate "early" writeout on
>  		 * the last close.  This is an attempt to combat the notorious
> -		 * NULL files problem which is particularly noticable from a
> +		 * NULL files problem which is particularly noticeable from a
>  		 * truncate down, buffered (re-)write (delalloc), followed by
>  		 * a crash.  What we are effectively doing here is
>  		 * significantly reducing the time window where we'd otherwise
> diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
> index 1da8af6..1ac0c03 100644
> --- a/include/drm/ttm/ttm_bo_driver.h
> +++ b/include/drm/ttm/ttm_bo_driver.h
> @@ -219,9 +219,9 @@ struct ttm_mem_type_manager_func {
>  	 * @mem::mm_node should be set to a non-null value, and
>  	 * @mem::start should be set to a value identifying the beginning
>  	 * of the range allocated, and the function should return zero.
> -	 * If the memory region accomodate the buffer object, @mem::mm_node
> +	 * If the memory region accommodate the buffer object, @mem::mm_node
>  	 * should be set to NULL, and the function should return 0.
> -	 * If a system error occured, preventing the request to be fulfilled,
> +	 * If a system error occurred, preventing the request to be fulfilled,
>  	 * the function should return a negative error code.
>  	 *
>  	 * Note that @mem::mm_node will only be dereferenced by
> diff --git a/include/linux/atmlec.h b/include/linux/atmlec.h
> index 39c917f..48a2257 100644
> --- a/include/linux/atmlec.h
> +++ b/include/linux/atmlec.h
> @@ -82,7 +82,7 @@ struct atmlec_msg {
>  			__u16 lec_id;				/* requestor lec_id  */
>  			__u32 tran_id;				/* transaction id    */
>  			unsigned char mac_addr[ETH_ALEN];	/* dst mac addr      */
> -			unsigned char atm_addr[ATM_ESA_LEN];	/* reqestor ATM addr */
> +			unsigned char atm_addr[ATM_ESA_LEN];	/* requestor ATM addr */
>  		} proxy;	/*
>  				 * For mapping LE_ARP requests to responses. Filled by
>  				 * zeppelin, returned by kernel. Used only when proxying
> diff --git a/include/linux/can/error.h b/include/linux/can/error.h
> index d4127fd..5958074 100644
> --- a/include/linux/can/error.h
> +++ b/include/linux/can/error.h
> @@ -51,7 +51,7 @@
>  #define CAN_ERR_PROT_BIT1        0x10 /* unable to send recessive bit */
>  #define CAN_ERR_PROT_OVERLOAD    0x20 /* bus overload */
>  #define CAN_ERR_PROT_ACTIVE      0x40 /* active error announcement */
> -#define CAN_ERR_PROT_TX          0x80 /* error occured on transmission */
> +#define CAN_ERR_PROT_TX          0x80 /* error occurred on transmission */
>  
>  /* error in CAN protocol (location) / data[3] */
>  #define CAN_ERR_PROT_LOC_UNSPEC  0x00 /* unspecified */
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index ce104e3..f0e1ad2 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -240,7 +240,7 @@ struct cgroup {
>  	/* For RCU-protected deletion */
>  	struct rcu_head rcu_head;
>  
> -	/* List of events which userspace want to recieve */
> +	/* List of events which userspace want to receive */
>  	struct list_head event_list;
>  	spinlock_t event_list_lock;
>  };
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index 68ba85a..432282e 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -532,14 +532,14 @@ struct fb_cursor_user {
>  #define FB_EVENT_GET_CONSOLE_MAP        0x07
>  /*      CONSOLE-SPECIFIC: set console to framebuffer mapping */
>  #define FB_EVENT_SET_CONSOLE_MAP        0x08
> -/*      A hardware display blank change occured */
> +/*      A hardware display blank change occurred */
>  #define FB_EVENT_BLANK                  0x09
>  /*      Private modelist is to be replaced */
>  #define FB_EVENT_NEW_MODELIST           0x0A
>  /*	The resolution of the passed in fb_info about to change and
>          all vc's should be changed         */
>  #define FB_EVENT_MODE_CHANGE_ALL	0x0B
> -/*	A software display blank change occured */
> +/*	A software display blank change occurred */
>  #define FB_EVENT_CONBLANK               0x0C
>  /*      Get drawing requirements        */
>  #define FB_EVENT_GET_REQ                0x0D
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 55e0d42..2da9db6 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -107,7 +107,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
>   * @next:	pointer to the next irqaction for shared interrupts
>   * @irq:	interrupt number
>   * @dir:	pointer to the proc/irq/NN/name entry
> - * @thread_fn:	interupt handler function for threaded interrupts
> + * @thread_fn:	interrupt handler function for threaded interrupts
>   * @thread:	thread pointer for threaded interrupts
>   * @thread_flags:	flags related to @thread
>   */
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 16b0261..2e04887 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -98,7 +98,7 @@ struct mmc_data;
>   * EVENT_DATA_COMPLETE is set in @pending_events, all data-related
>   * interrupts must be disabled and @data_status updated with a
>   * snapshot of SR. Similarly, before EVENT_CMD_COMPLETE is set, the
> - * CMDRDY interupt must be disabled and @cmd_status updated with a
> + * CMDRDY interrupt must be disabled and @cmd_status updated with a
>   * snapshot of SR, and before EVENT_XFER_COMPLETE can be set, the
>   * bytes_xfered field of @data must be written. This is ensured by
>   * using barriers.
> diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
> index 2a10efd..6a0664c 100644
> --- a/include/linux/netfilter/nf_conntrack_proto_gre.h
> +++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
> @@ -60,7 +60,7 @@ struct gre_hdr_pptp {
>  	__be16 payload_len;	/* size of ppp payload, not inc. gre header */
>  	__be16 call_id;		/* peer's call_id for this session */
>  	__be32 seq;		/* sequence number.  Present if S==1 */
> -	__be32 ack;		/* seq number of highest packet recieved by */
> +	__be32 ack;		/* seq number of highest packet received by */
>  				/*  sender in this session */
>  };
>  
> diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> index 5b7e6b1..16b038a 100644
> --- a/include/linux/pci_regs.h
> +++ b/include/linux/pci_regs.h
> @@ -435,7 +435,7 @@
>  #define  PCI_EXP_LNKCAP_L0SEL	0x00007000 /* L0s Exit Latency */
>  #define  PCI_EXP_LNKCAP_L1EL	0x00038000 /* L1 Exit Latency */
>  #define  PCI_EXP_LNKCAP_CLKPM	0x00040000 /* L1 Clock Power Management */
> -#define  PCI_EXP_LNKCAP_SDERC	0x00080000 /* Suprise Down Error Reporting Capable */
> +#define  PCI_EXP_LNKCAP_SDERC	0x00080000 /* Surprise Down Error Reporting Capable */
>  #define  PCI_EXP_LNKCAP_DLLLARC	0x00100000 /* Data Link Layer Link Active Reporting Capable */
>  #define  PCI_EXP_LNKCAP_LBNC	0x00200000 /* Link Bandwidth Notification Capability */
>  #define  PCI_EXP_LNKCAP_PN	0xff000000 /* Port Number */
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 27c3c6f..8684011 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -509,7 +509,7 @@ do {									\
>   * case for x86 for example).
>   *
>   * If there is no other protection through preempt disable and/or
> - * disabling interupts then one of these RMW operations can show unexpected
> + * disabling interrupts then one of these RMW operations can show unexpected
>   * behavior because the execution thread was rescheduled on another processor
>   * or an interrupt occurred and the same percpu variable was modified from
>   * the interrupt context.
> diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
> index 2f691e4..44835fb 100644
> --- a/include/linux/pxa2xx_ssp.h
> +++ b/include/linux/pxa2xx_ssp.h
> @@ -122,7 +122,7 @@
>  #define SSCR1_TSRE		(1 << 21)	/* Transmit Service Request Enable */
>  #define SSCR1_RSRE		(1 << 20)	/* Receive Service Request Enable */
>  #define SSCR1_TINTE		(1 << 19)	/* Receiver Time-out Interrupt enable */
> -#define SSCR1_PINTE		(1 << 18)	/* Peripheral Trailing Byte Interupt Enable */
> +#define SSCR1_PINTE		(1 << 18)	/* Peripheral Trailing Byte Interrupt Enable */
>  #define SSCR1_IFS		(1 << 16)	/* Invert Frame Signal */
>  #define SSCR1_STRF		(1 << 15)	/* Select FIFO or EFWR */
>  #define SSCR1_EFWR		(1 << 14)	/* Enable FIFO Write/Read */
> diff --git a/include/linux/spi/spidev.h b/include/linux/spi/spidev.h
> index bf0570a..52d9ed0 100644
> --- a/include/linux/spi/spidev.h
> +++ b/include/linux/spi/spidev.h
> @@ -66,7 +66,7 @@
>   * are in a different address space (and may be of different sizes in some
>   * cases, such as 32-bit i386 userspace over a 64-bit x86_64 kernel).
>   * Zero-initialize the structure, including currently unused fields, to
> - * accomodate potential future updates.
> + * accommodate potential future updates.
>   *
>   * SPI_IOC_MESSAGE gives userspace the equivalent of kernel spi_sync().
>   * Pass it an array of related transfers, they'll execute together.
> diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
> index ea29330..95505f1 100644
> --- a/include/linux/sunrpc/svc.h
> +++ b/include/linux/sunrpc/svc.h
> @@ -142,7 +142,7 @@ static inline void svc_get(struct svc_serv *serv)
>  extern u32 svc_max_payload(const struct svc_rqst *rqstp);
>  
>  /*
> - * RPC Requsts and replies are stored in one or more pages.
> + * RPC Requests and replies are stored in one or more pages.
>   * We maintain an array of pages for each server thread.
>   * Requests are copied into these pages as they arrive.  Remaining
>   * pages are available to write the reply into.
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index e64f4c6..38cba2a 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -187,7 +187,7 @@ struct tcp_md5sig {
>  /* Flags for both getsockopt and setsockopt */
>  #define TCP_COOKIE_IN_ALWAYS	(1 << 0)	/* Discard SYN without cookie */
>  #define TCP_COOKIE_OUT_NEVER	(1 << 1)	/* Prohibit outgoing cookies,
> -						 * supercedes everything. */
> +						 * supersedes everything. */
>  
>  /* Flags for getsockopt */
>  #define TCP_S_DATA_IN		(1 << 2)	/* Was data received? */
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index bd69b65..1a2d2d6 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -793,7 +793,7 @@ struct usbdrv_wrap {
>   *	usb_set_intfdata() to associate driver-specific data with the
>   *	interface.  It may also use usb_set_interface() to specify the
>   *	appropriate altsetting.  If unwilling to manage the interface,
> - *	return -ENODEV, if genuine IO errors occured, an appropriate
> + *	return -ENODEV, if genuine IO errors occurred, an appropriate
>   *	negative errno value.
>   * @disconnect: Called when the interface is no longer accessible, usually
>   *	because its device has been (or is being) disconnected or the
> diff --git a/include/linux/uwb.h b/include/linux/uwb.h
> index 7fc9746..3052e44 100644
> --- a/include/linux/uwb.h
> +++ b/include/linux/uwb.h
> @@ -702,10 +702,10 @@ void edc_init(struct edc *edc)
>  	edc->timestart = jiffies;
>  }
>  
> -/* Called when an error occured.
> +/* Called when an error occurred.
>   * This is way to determine if the number of acceptable errors per time
>   * period has been exceeded. It is not accurate as there are cases in which
> - * this scheme will not work, for example if there are periodic occurences
> + * this scheme will not work, for example if there are periodic occurrences
>   * of errors that straddle updates to the start time. This scheme is
>   * sufficient for our usage.
>   *
> diff --git a/include/net/9p/client.h b/include/net/9p/client.h
> index 83ba6a4..59b5df5 100644
> --- a/include/net/9p/client.h
> +++ b/include/net/9p/client.h
> @@ -101,7 +101,7 @@ enum p9_req_status_t {
>   * Transport use an array to track outstanding requests
>   * instead of a list.  While this may incurr overhead during initial
>   * allocation or expansion, it makes request lookup much easier as the
> - * tag id is a index into an array.  (We use tag+1 so that we can accomodate
> + * tag id is a index into an array.  (We use tag+1 so that we can accommodate
>   * the -1 tag for the T_VERSION request).
>   * This also has the nice effect of only having to allocate wait_queues
>   * once, instead of constantly allocating and freeing them.  Its possible
> diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
> index f53c8e3..b3368c6 100644
> --- a/include/scsi/libfc.h
> +++ b/include/scsi/libfc.h
> @@ -636,7 +636,7 @@ struct libfc_function_template {
>  	int (*rport_logoff)(struct fc_rport_priv *);
>  
>  	/*
> -	 * Recieve a request from a remote port.
> +	 * Receive a request from a remote port.
>  	 *
>  	 * STATUS: OPTIONAL
>  	 */
> diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
> index 741ae7e..2fbcd9e 100644
> --- a/include/scsi/libiscsi_tcp.h
> +++ b/include/scsi/libiscsi_tcp.h
> @@ -51,7 +51,7 @@ struct iscsi_segment {
>  	iscsi_segment_done_fn_t	*done;
>  };
>  
> -/* Socket connection recieve helper */
> +/* Socket connection receive helper */
>  struct iscsi_tcp_recv {
>  	struct iscsi_hdr	*hdr;
>  	struct iscsi_segment	segment;
> diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
> index 53a9e88..0a50799 100644
> --- a/include/scsi/osd_initiator.h
> +++ b/include/scsi/osd_initiator.h
> @@ -265,7 +265,7 @@ int osd_execute_request_async(struct osd_request *or,
>   * @osi           - Recievs a more detailed error report information (optional).
>   * @silent        - Do not print to dmsg (Even if enabled)
>   * @bad_obj_list  - Some commands act on multiple objects. Failed objects will
> - *                  be recieved here (optional)
> + *                  be received here (optional)
>   * @max_obj       - Size of @bad_obj_list.
>   * @bad_attr_list - List of failing attributes (optional)
>   * @max_attr      - Size of @bad_attr_list.
> diff --git a/include/sound/cs46xx_dsp_task_types.h b/include/sound/cs46xx_dsp_task_types.h
> index 5cf920b..be56947 100644
> --- a/include/sound/cs46xx_dsp_task_types.h
> +++ b/include/sound/cs46xx_dsp_task_types.h
> @@ -203,7 +203,7 @@ struct dsp_task_tree_context_block {
>  
>  	u32	  saverfe;					
>  
> -	/* Value may be overwriten by stack save algorithm.
> +	/* Value may be overwritten by stack save algorithm.
>  	   Retain the size of the stack data saved here if used */
>  	___DSP_DUAL_16BIT_ALLOC(
>               reserved1,	
> diff --git a/include/sound/cs8427.h b/include/sound/cs8427.h
> index f862cff..79f7017 100644
> --- a/include/sound/cs8427.h
> +++ b/include/sound/cs8427.h
> @@ -151,7 +151,7 @@
>  #define CS8427_PRO		(1<<3)	/* Channel status block format indicator */
>  #define CS8427_AUDIO		(1<<2)	/* Audio indicator (0 = audio, 1 = nonaudio */
>  #define CS8427_COPY		(1<<1)	/* 0 = copyright asserted, 1 = copyright not asserted */
> -#define CS8427_ORIG		(1<<0)	/* SCMS generation indicator, 0 = 1st generation or highter, 1 = original */
> +#define CS8427_ORIG		(1<<0)	/* SCMS generation indicator, 0 = 1st generation or higher, 1 = original */
>  
>  /* CS8427_REG_RECVERRORS */
>  /* CS8427_REG_RECVERRMASK for CS8427_RERR */
> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 534cac8..a782287 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -158,7 +158,7 @@ struct physdev_manage_pci_ext {
>  };
>  
>  /*
> - * Argument to physdev_op_compat() hypercall. Superceded by new physdev_op()
> + * Argument to physdev_op_compat() hypercall. Superseded by new physdev_op()
>   * hypercall since 0x00030202.
>   */
>  struct physdev_op {
> @@ -206,7 +206,7 @@ struct physdev_get_free_pirq {
>  #define PHYSDEVOP_IRQ_UNMASK_NOTIFY	 4
>  
>  /*
> - * These all-capitals physdev operation names are superceded by the new names
> + * These all-capitals physdev operation names are superseded by the new names
>   * (defined above) since interface version 0x00030202.
>   */
>  #define PHYSDEVOP_IRQ_STATUS_QUERY	 PHYSDEVOP_irq_status_query
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index b24d702..c54a42bc 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -157,7 +157,7 @@ struct css_id {
>  };
>  
>  /*
> - * cgroup_event represents events which userspace want to recieve.
> + * cgroup_event represents events which userspace want to receive.
>   */
>  struct cgroup_event {
>  	/*
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index baa5c4a..c1deb1d 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -594,7 +594,7 @@ out:
>   *	@desc:	the interrupt description structure for this irq
>   *
>   *	Interrupt occures on the falling and/or rising edge of a hardware
> - *	signal. The occurence is latched into the irq controller hardware
> + *	signal. The occurrence is latched into the irq controller hardware
>   *	and must be acked in order to be reenabled. After the ack another
>   *	interrupt can happen on the same source even before the first one
>   *	is handled by the associated event handler. If this happens it
> diff --git a/kernel/latencytop.c b/kernel/latencytop.c
> index ee74b35..376066e 100644
> --- a/kernel/latencytop.c
> +++ b/kernel/latencytop.c
> @@ -153,7 +153,7 @@ static inline void store_stacktrace(struct task_struct *tsk,
>  }
>  
>  /**
> - * __account_scheduler_latency - record an occured latency
> + * __account_scheduler_latency - record an occurred latency
>   * @tsk - the task struct of the task hitting the latency
>   * @usecs - the duration of the latency in microseconds
>   * @inter - 1 if the sleep was interruptible, 0 if uninterruptible
> diff --git a/kernel/module.c b/kernel/module.c
> index efa290e..4ed7fdf 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2971,7 +2971,7 @@ static const char *get_ksymbol(struct module *mod,
>  	else
>  		nextval = (unsigned long)mod->module_core+mod->core_text_size;
>  
> -	/* Scan for closest preceeding symbol, and next symbol. (ELF
> +	/* Scan for closest preceding symbol, and next symbol. (ELF
>  	   starts real symbols at 1). */
>  	for (i = 1; i < mod->num_symtab; i++) {
>  		if (mod->symtab[i].st_shndx == SHN_UNDEF)
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 7510194..1f779bd 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -768,7 +768,7 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
>  }
>  
>   /**
> - * padata_remove_cpu - remove a cpu from the one or both(serial and paralell)
> + * padata_remove_cpu - remove a cpu from the one or both(serial and parallel)
>   *                     padata cpumasks.
>   *
>   * @pinst: padata instance
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 7b5db6a..27616cb 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -227,7 +227,7 @@ power_attr(state);
>   * writing to 'state'.  It first should read from 'wakeup_count' and store
>   * the read value.  Then, after carrying out its own preparations for the system
>   * transition to a sleep state, it should write the stored value to
> - * 'wakeup_count'.  If that fails, at least one wakeup event has occured since
> + * 'wakeup_count'.  If that fails, at least one wakeup event has occurred since
>   * 'wakeup_count' was read and 'state' should not be written to.  Otherwise, it
>   * is allowed to write to 'state', but the transition will be aborted if there
>   * are any wakeup events detected after 'wakeup_count' was written to.
> diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
> index 5404a84..f9cd5ab 100644
> --- a/kernel/time/jiffies.c
> +++ b/kernel/time/jiffies.c
> @@ -31,7 +31,7 @@
>   * inaccuracies caused by missed or lost timer
>   * interrupts and the inability for the timer
>   * interrupt hardware to accuratly tick at the
> - * requested HZ value. It is also not reccomended
> + * requested HZ value. It is also not recommended
>   * for "tick-less" systems.
>   */
>  #define NSEC_PER_JIFFY	((u32)((((u64)NSEC_PER_SEC)<<8)/ACTHZ))
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index 19a359d..479e599 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -13,7 +13,7 @@ static char __percpu *perf_trace_buf[PERF_NR_CONTEXTS];
>  
>  /*
>   * Force it to be aligned to unsigned long to avoid misaligned accesses
> - * suprises
> + * surprises
>   */
>  typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
>  	perf_trace_t;
> diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
> index eb27fd3..92cb706 100644
> --- a/kernel/user-return-notifier.c
> +++ b/kernel/user-return-notifier.c
> @@ -20,7 +20,7 @@ EXPORT_SYMBOL_GPL(user_return_notifier_register);
>  
>  /*
>   * Removes a registered user return notifier.  Must be called from atomic
> - * context, and from the same cpu registration occured in.
> + * context, and from the same cpu registration occurred in.
>   */
>  void user_return_notifier_unregister(struct user_return_notifier *urn)
>  {
> diff --git a/lib/timerqueue.c b/lib/timerqueue.c
> index e3a1050..191176a 100644
> --- a/lib/timerqueue.c
> +++ b/lib/timerqueue.c
> @@ -5,7 +5,7 @@
>   *  Uses rbtrees for quick list adds and expiration.
>   *
>   *  NOTE: All of the following functions need to be serialized
> - *  to avoid races. No locking is done by this libary code.
> + *  to avoid races. No locking is done by this library code.
>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bb0b7c1..353e128 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -842,7 +842,7 @@ struct page *alloc_huge_page_node(struct hstate *h, int nid)
>  }
>  
>  /*
> - * Increase the hugetlb pool such that it can accomodate a reservation
> + * Increase the hugetlb pool such that it can accommodate a reservation
>   * of size 'delta'.
>   */
>  static int gather_surplus_pages(struct hstate *h, int delta)
> @@ -890,7 +890,7 @@ retry:
>  
>  	/*
>  	 * The surplus_list now contains _at_least_ the number of extra pages
> -	 * needed to accomodate the reservation.  Add the appropriate number
> +	 * needed to accommodate the reservation.  Add the appropriate number
>  	 * of pages to the hugetlb pool and free the extras back to the buddy
>  	 * allocator.  Commit the entire reservation here to prevent another
>  	 * process from stealing the pages as they are added to the pool but
> @@ -2492,7 +2492,7 @@ static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	/*
>  	 * Currently, we are forced to kill the process in the event the
>  	 * original mapper has unmapped pages from the child due to a failed
> -	 * COW. Warn that such a situation has occured as it may not be obvious
> +	 * COW. Warn that such a situation has occurred as it may not be obvious
>  	 */
>  	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
>  		printk(KERN_WARNING
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 84225f3..c1d5867 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -265,7 +265,7 @@ static void kmemleak_disable(void);
>  } while (0)
>  
>  /*
> - * Macro invoked when a serious kmemleak condition occured and cannot be
> + * Macro invoked when a serious kmemleak condition occurred and cannot be
>   * recovered from. Kmemleak will be disabled and further allocation/freeing
>   * tracing no longer available.
>   */
> @@ -1006,7 +1006,7 @@ static bool update_checksum(struct kmemleak_object *object)
>  
>  /*
>   * Memory scanning is a long process and it needs to be interruptable. This
> - * function checks whether such interrupt condition occured.
> + * function checks whether such interrupt condition occurred.
>   */
>  static int scan_should_stop(void)
>  {
> @@ -1733,7 +1733,7 @@ static int __init kmemleak_late_init(void)
>  
>  	if (atomic_read(&kmemleak_error)) {
>  		/*
> -		 * Some error occured and kmemleak was disabled. There is a
> +		 * Some error occurred and kmemleak was disabled. There is a
>  		 * small chance that kmemleak_disable() was called immediately
>  		 * after setting kmemleak_initialized and we may end up with
>  		 * two clean-up threads but serialized by scan_mutex.
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 3f93001..f34b04a 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -342,7 +342,7 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
>   * @chunk: chunk of interest
>   *
>   * Determine whether area map of @chunk needs to be extended to
> - * accomodate a new allocation.
> + * accommodate a new allocation.
>   *
>   * CONTEXT:
>   * pcpu_lock.
> @@ -431,7 +431,7 @@ out_unlock:
>   * depending on @head, is reduced by @tail bytes and @tail byte block
>   * is inserted after the target block.
>   *
> - * @chunk->map must have enough free slots to accomodate the split.
> + * @chunk->map must have enough free slots to accommodate the split.
>   *
>   * CONTEXT:
>   * pcpu_lock.
> @@ -1436,7 +1436,7 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
>  	/*
>  	 * Determine min_unit_size, alloc_size and max_upa such that
>  	 * alloc_size is multiple of atom_size and is the smallest
> -	 * which can accomodate 4k aligned segments which are equal to
> +	 * which can accommodate 4k aligned segments which are equal to
>  	 * or larger than min_unit_size.
>  	 */
>  	min_unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
> diff --git a/mm/slub.c b/mm/slub.c
> index e15aa7f..f9d82ac 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3312,7 +3312,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
>  
>  	ret = slab_alloc(s, gfpflags, NUMA_NO_NODE, caller);
>  
> -	/* Honor the call site pointer we recieved. */
> +	/* Honor the call site pointer we received. */
>  	trace_kmalloc(caller, ret, size, s->size, gfpflags);
>  
>  	return ret;
> @@ -3342,7 +3342,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
>  
>  	ret = slab_alloc(s, gfpflags, node, caller);
>  
> -	/* Honor the call site pointer we recieved. */
> +	/* Honor the call site pointer we received. */
>  	trace_kmalloc_node(caller, ret, size, s->size, gfpflags, node);
>  
>  	return ret;
> diff --git a/net/9p/client.c b/net/9p/client.c
> index a848bca..cb6a360 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -178,7 +178,7 @@ free_and_return:
>   * @tag: numeric id for transaction
>   *
>   * this is a simple array lookup, but will grow the
> - * request_slots as necessary to accomodate transaction
> + * request_slots as necessary to accommodate transaction
>   * ids which did not previously have a slot.
>   *
>   * this code relies on the client spinlock to manage locks, its
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 6c11eec..5df4ef9 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2162,7 +2162,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>  		}
>  
>  		if (TCP_COOKIE_OUT_NEVER & ctd.tcpct_flags) {
> -			/* Supercedes all other values */
> +			/* Supersedes all other values */
>  			lock_sock(sk);
>  			if (tp->cookie_values != NULL) {
>  				kref_put(&tp->cookie_values->kref,
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 406f320..52a9a78 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -73,7 +73,7 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
>  	tcp_advance_send_head(sk, skb);
>  	tp->snd_nxt = TCP_SKB_CB(skb)->end_seq;
>  
> -	/* Don't override Nagle indefinately with F-RTO */
> +	/* Don't override Nagle indefinitely with F-RTO */
>  	if (tp->frto_counter == 2)
>  		tp->frto_counter = 3;
>  
> diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
> index 97c5b21..cdd6d04 100644
> --- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
> +++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
> @@ -71,7 +71,7 @@ static unsigned int ipv6_defrag(unsigned int hooknum,
>  	if (reasm == NULL)
>  		return NF_STOLEN;
>  
> -	/* error occured or not fragmented */
> +	/* error occurred or not fragmented */
>  	if (reasm == skb)
>  		return NF_ACCEPT;
>  
> diff --git a/net/irda/irlap_event.c b/net/irda/irlap_event.c
> index d434c88..85b84f4 100644
> --- a/net/irda/irlap_event.c
> +++ b/net/irda/irlap_event.c
> @@ -708,7 +708,7 @@ static int irlap_state_reply(struct irlap_cb *self, IRLAP_EVENT event,
>  
>  				self->frame_sent = TRUE;
>  			}
> -			/* Readjust our timer to accomodate devices
> +			/* Readjust our timer to accommodate devices
>  			 * doing faster or slower discovery than us...
>  			 * Jean II */
>  			irlap_start_query_timer(self, info->S, info->s);
> diff --git a/net/irda/irttp.c b/net/irda/irttp.c
> index f6054f9..72d15ac 100644
> --- a/net/irda/irttp.c
> +++ b/net/irda/irttp.c
> @@ -967,7 +967,7 @@ static int irttp_data_indication(void *instance, void *sap,
>  
>  	/*
>  	 * If the peer device has given us some credits and we didn't have
> -	 * anyone from before, then we need to shedule the tx queue.
> +	 * anyone from before, then we need to schedule the tx queue.
>  	 * We need to do that because our Tx have stopped (so we may not
>  	 * get any LAP flow indication) and the user may be stopped as
>  	 * well. - Jean II
> diff --git a/net/irda/timer.c b/net/irda/timer.c
> index 0335ba0..f418cb2 100644
> --- a/net/irda/timer.c
> +++ b/net/irda/timer.c
> @@ -59,7 +59,7 @@ void irlap_start_query_timer(struct irlap_cb *self, int S, int s)
>  	 * slot time, plus add some extra time to properly receive the last
>  	 * discovery packet (which is longer due to extra discovery info),
>  	 * to avoid messing with for incomming connections requests and
> -	 * to accomodate devices that perform discovery slower than us.
> +	 * to accommodate devices that perform discovery slower than us.
>  	 * Jean II */
>  	timeout = ((sysctl_slot_timeout * HZ / 1000) * (S - s)
>  		   + XIDEXTRA_TIMEOUT + SMALLBUSY_TIMEOUT);
> diff --git a/net/mac80211/rc80211_pid.h b/net/mac80211/rc80211_pid.h
> index 1a873f0..8d8a141 100644
> --- a/net/mac80211/rc80211_pid.h
> +++ b/net/mac80211/rc80211_pid.h
> @@ -80,7 +80,7 @@ union rc_pid_event_data {
>  };
>  
>  struct rc_pid_event {
> -	/* The time when the event occured */
> +	/* The time when the event occurred */
>  	unsigned long timestamp;
>  
>  	/* Event ID number */
> diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> index 1ea96bc..114e509 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> @@ -560,7 +560,7 @@ static struct ipvs_sctp_nextstate
>  	 * SHUTDOWN sent from the client, waitinf for SHUT ACK from the server
>  	 */
>  	/*
> -	 * We recieved the data chuck, keep the state unchanged. I assume
> +	 * We received the data chuck, keep the state unchanged. I assume
>  	 * that still data chuncks  can be received by both the peers in
>  	 * SHUDOWN state
>  	 */
> @@ -627,7 +627,7 @@ static struct ipvs_sctp_nextstate
>  	 * SHUTDOWN sent from the server, waitinf for SHUTDOWN ACK from client
>  	 */
>  	/*
> -	 * We recieved the data chuck, keep the state unchanged. I assume
> +	 * We received the data chuck, keep the state unchanged. I assume
>  	 * that still data chuncks  can be received by both the peers in
>  	 * SHUDOWN state
>  	 */
> @@ -695,7 +695,7 @@ static struct ipvs_sctp_nextstate
>  	 * SHUTDOWN ACK from the client, awaiting for SHUTDOWN COM from server
>  	 */
>  	/*
> -	 * We recieved the data chuck, keep the state unchanged. I assume
> +	 * We received the data chuck, keep the state unchanged. I assume
>  	 * that still data chuncks  can be received by both the peers in
>  	 * SHUDOWN state
>  	 */
> @@ -765,7 +765,7 @@ static struct ipvs_sctp_nextstate
>  	 * SHUTDOWN ACK from the server, awaiting for SHUTDOWN COM from client
>  	 */
>  	/*
> -	 * We recieved the data chuck, keep the state unchanged. I assume
> +	 * We received the data chuck, keep the state unchanged. I assume
>  	 * that still data chuncks  can be received by both the peers in
>  	 * SHUDOWN state
>  	 */
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 84f4fcc..92eb02bc 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -884,7 +884,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
>  	ret = l3proto->get_l4proto(skb, skb_network_offset(skb),
>  				   &dataoff, &protonum);
>  	if (ret <= 0) {
> -		pr_debug("not prepared to track yet or error occured\n");
> +		pr_debug("not prepared to track yet or error occurred\n");
>  		NF_CT_STAT_INC_ATOMIC(net, error);
>  		NF_CT_STAT_INC_ATOMIC(net, invalid);
>  		ret = -ret;
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index bcf47eb..237cc19 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -707,7 +707,7 @@ static const char *ct_sdp_header_search(const char *dptr, const char *limit,
>  }
>  
>  /* Locate a SDP header (optionally a substring within the header value),
> - * optionally stopping at the first occurence of the term header, parse
> + * optionally stopping at the first occurrence of the term header, parse
>   * it and return the offset and length of the data we're interested in.
>   */
>  int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
> index 71f373c..128eb5b 100644
> --- a/net/rds/ib_send.c
> +++ b/net/rds/ib_send.c
> @@ -355,7 +355,7 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
>   *
>   * Conceptually, we have two counters:
>   *  -	send credits: this tells us how many WRs we're allowed
> - *	to submit without overruning the reciever's queue. For
> + *	to submit without overruning the receiver's queue. For
>   *	each SEND WR we post, we decrement this by one.
>   *
>   *  -	posted credits: this tells us how many WRs we recently
> diff --git a/net/rds/iw_cm.c b/net/rds/iw_cm.c
> index 712cf2d..3a60a15 100644
> --- a/net/rds/iw_cm.c
> +++ b/net/rds/iw_cm.c
> @@ -181,7 +181,7 @@ static int rds_iw_init_qp_attrs(struct ib_qp_init_attr *attr,
>  	unsigned int send_size, recv_size;
>  	int ret;
>  
> -	/* The offset of 1 is to accomodate the additional ACK WR. */
> +	/* The offset of 1 is to accommodate the additional ACK WR. */
>  	send_size = min_t(unsigned int, rds_iwdev->max_wrs, rds_iw_sysctl_max_send_wr + 1);
>  	recv_size = min_t(unsigned int, rds_iwdev->max_wrs, rds_iw_sysctl_max_recv_wr + 1);
>  	rds_iw_ring_resize(send_ring, send_size - 1);
> diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
> index 6280ea0..545d8ee 100644
> --- a/net/rds/iw_send.c
> +++ b/net/rds/iw_send.c
> @@ -307,7 +307,7 @@ void rds_iw_send_cq_comp_handler(struct ib_cq *cq, void *context)
>   *
>   * Conceptually, we have two counters:
>   *  -	send credits: this tells us how many WRs we're allowed
> - *	to submit without overruning the reciever's queue. For
> + *	to submit without overruning the receiver's queue. For
>   *	each SEND WR we post, we decrement this by one.
>   *
>   *  -	posted credits: this tells us how many WRs we recently
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 60600d3..84f82b6 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -673,7 +673,7 @@ static sctp_xmit_t sctp_packet_can_append_data(struct sctp_packet *packet,
>  		 * data will fit or delay in hopes of bundling a full
>  		 * sized packet.
>  		 * Don't delay large message writes that may have been
> -		 * fragmeneted into small peices.
> +		 * fragmeneted into small pieces.
>  		 */
>  		if ((len < max) && chunk->msg->can_delay) {
>  			retval = SCTP_XMIT_NAGLE_DELAY;
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 4b4eb7c..ff6a678 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -4402,7 +4402,7 @@ static sctp_disposition_t sctp_sf_violation_ctsn(
>  }
>  
>  /* Handle protocol violation of an invalid chunk bundling.  For example,
> - * when we have an association and we recieve bundled INIT-ACK, or
> + * when we have an association and we receive bundled INIT-ACK, or
>   * SHUDOWN-COMPLETE, our peer is clearly violationg the "MUST NOT bundle"
>   * statement from the specs.  Additinally, there might be an attacker
>   * on the path and we may not want to continue this communication.
> diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
> index c7f7e49..06b9b75 100644
> --- a/net/sctp/ulpqueue.c
> +++ b/net/sctp/ulpqueue.c
> @@ -243,7 +243,7 @@ int sctp_ulpq_tail_event(struct sctp_ulpq *ulpq, struct sctp_ulpevent *event)
>  		} else {
>  			/*
>  			 * If fragment interleave is enabled, we
> -			 * can queue this to the recieve queue instead
> +			 * can queue this to the receive queue instead
>  			 * of the lobby.
>  			 */
>  			if (sctp_sk(sk)->frag_interleave)
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index c431f5a..7e22f74 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -504,7 +504,7 @@ static int xs_nospace(struct rpc_task *task)
>   *   EAGAIN:	The socket was blocked, please call again later to
>   *		complete the request
>   * ENOTCONN:	Caller needs to invoke connect logic then call again
> - *    other:	Some other error occured, the request was not sent
> + *    other:	Some other error occurred, the request was not sent
>   */
>  static int xs_udp_send_request(struct rpc_task *task)
>  {
> @@ -590,7 +590,7 @@ static inline void xs_encode_tcp_record_marker(struct xdr_buf *buf)
>   *   EAGAIN:	The socket was blocked, please call again later to
>   *		complete the request
>   * ENOTCONN:	Caller needs to invoke connect logic then call again
> - *    other:	Some other error occured, the request was not sent
> + *    other:	Some other error occurred, the request was not sent
>   *
>   * XXX: In the case of soft timeouts, should we eventually give up
>   *	if sendmsg is not able to make progress?
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 37693b6..e760f0c 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -813,7 +813,7 @@ static void handle_channel(struct wiphy *wiphy,
>  	if (r) {
>  		/*
>  		 * We will disable all channels that do not match our
> -		 * recieved regulatory rule unless the hint is coming
> +		 * received regulatory rule unless the hint is coming
>  		 * from a Country IE and the Country IE had no information
>  		 * about a band. The IEEE 802.11 spec allows for an AP
>  		 * to send only a subset of the regulatory rules allowed,
> diff --git a/scripts/dtc/livetree.c b/scripts/dtc/livetree.c
> index c9209d5..26d0e1e 100644
> --- a/scripts/dtc/livetree.c
> +++ b/scripts/dtc/livetree.c
> @@ -155,7 +155,7 @@ struct node *merge_nodes(struct node *old_node, struct node *new_node)
>  			}
>  		}
>  
> -		/* if no collision occured, add child to the old node. */
> +		/* if no collision occurred, add child to the old node. */
>  		if (new_child)
>  			add_child(old_node, new_child);
>  	}
> diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
> index 04a2cf8..b6cf297 100644
> --- a/security/apparmor/procattr.c
> +++ b/security/apparmor/procattr.c
> @@ -149,7 +149,7 @@ int aa_setprocattr_changehat(char *args, size_t size, int test)
>  
>  /**
>   * aa_setprocattr_changeprofile - handle procattr interface to changeprofile
> - * @fqname: args received from writting to /proc/<pid>/attr/current (NOT NULL)
> + * @fqname: args received from writing to /proc/<pid>/attr/current (NOT NULL)
>   * @onexec: true if change_profile should be delayed until exec
>   * @test: true if this is a test of change_profile permissions
>   *
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 533bf32..0b3c72a 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2332,7 +2332,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
>  	switch (sbp->s_magic) {
>  	case SMACK_MAGIC:
>  		/*
> -		 * Casey says that it's a little embarassing
> +		 * Casey says that it's a little embarrassing
>  		 * that the smack file system doesn't do
>  		 * extended attributes.
>  		 */
> diff --git a/sound/drivers/pcm-indirect2.c b/sound/drivers/pcm-indirect2.c
> index 3c93c23..f7fa4b1 100644
> --- a/sound/drivers/pcm-indirect2.c
> +++ b/sound/drivers/pcm-indirect2.c
> @@ -47,7 +47,7 @@ void snd_pcm_indirect2_stat(struct snd_pcm_substream *substream,
>  	int seconds = (rec->lastbytetime - rec->firstbytetime) / HZ;
>  
>  	snd_printk(KERN_DEBUG "STAT: mul_elapsed: %u, mul_elapsed_real: %d, "
> -		   "irq_occured: %d\n",
> +		   "irq_occurred: %d\n",
>  		   rec->mul_elapsed, rec->mul_elapsed_real, rec->irq_occured);
>  	snd_printk(KERN_DEBUG "STAT: min_multiple: %d (irqs/period)\n",
>  		   rec->min_multiple);
> diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
> index a25fb7b..e946e45 100644
> --- a/sound/drivers/serial-u16550.c
> +++ b/sound/drivers/serial-u16550.c
> @@ -273,7 +273,7 @@ static void snd_uart16550_io_loop(struct snd_uart16550 * uart)
>  		snd_uart16550_add_timer(uart);
>  }
>  
> -/* NOTES ON SERVICING INTERUPTS
> +/* NOTES ON SERVICING INTERRUPTS
>   * ---------------------------
>   * After receiving a interrupt, it is important to indicate to the UART that
>   * this has been done. 
> diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
> index 44357d8..09d4648 100644
> --- a/sound/oss/swarm_cs4297a.c
> +++ b/sound/oss/swarm_cs4297a.c
> @@ -875,7 +875,7 @@ static void start_adc(struct cs4297a_state *s)
>  		if (s->prop_adc.fmt & AFMT_S8 || s->prop_adc.fmt & AFMT_U8) {
>  			// 
>  			// now only use 16 bit capture, due to truncation issue
> -			// in the chip, noticable distortion occurs.
> +			// in the chip, noticeable distortion occurs.
>  			// allocate buffer and then convert from 16 bit to 
>  			// 8 bit for the user buffer.
>  			//
> diff --git a/sound/pci/asihpi/hpi.h b/sound/pci/asihpi/hpi.h
> index 23399d0..5b0aca8 100644
> --- a/sound/pci/asihpi/hpi.h
> +++ b/sound/pci/asihpi/hpi.h
> @@ -709,7 +709,7 @@ enum HPI_AESEBU_ERRORS {
>  #define HPI_PAD_TITLE_LEN               64
>  /** The text string containing the comment. */
>  #define HPI_PAD_COMMENT_LEN             256
> -/** The PTY when the tuner has not recieved any PTY. */
> +/** The PTY when the tuner has not received any PTY. */
>  #define HPI_PAD_PROGRAM_TYPE_INVALID    0xffff
>  /** \} */
>  
> diff --git a/sound/pci/ctxfi/cthw20k1.c b/sound/pci/ctxfi/cthw20k1.c
> index 0cf400f..f58d5af 100644
> --- a/sound/pci/ctxfi/cthw20k1.c
> +++ b/sound/pci/ctxfi/cthw20k1.c
> @@ -82,7 +82,7 @@ static void hw_write_pci(struct hw *hw, u32 reg, u32 data);
>  
>  #define SRCLA_LA	0x03FFFFFF
>  
> -/* Mixer Parameter Ring ram Low and Hight register.
> +/* Mixer Parameter Ring ram Low and High register.
>   * Fixed-point value in 8.24 format for parameter channel */
>  #define MPRLH_PITCH	0xFFFFFFFF
>  
> diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
> index b6b11bf..c7bb374 100644
> --- a/sound/pci/ctxfi/cthw20k2.c
> +++ b/sound/pci/ctxfi/cthw20k2.c
> @@ -80,7 +80,7 @@ static void hw_write_20kx(struct hw *hw, u32 reg, u32 data);
>  
>  #define SRCLA_LA	0x0FFFFFFF
>  
> -/* Mixer Parameter Ring ram Low and Hight register.
> +/* Mixer Parameter Ring ram Low and High register.
>   * Fixed-point value in 8.24 format for parameter channel */
>  #define MPRLH_PITCH	0xFFFFFFFF
>  
> diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
> index 833e718..304411c 100644
> --- a/sound/pci/pcxhr/pcxhr_core.c
> +++ b/sound/pci/pcxhr/pcxhr_core.c
> @@ -1042,11 +1042,11 @@ void pcxhr_msg_tasklet(unsigned long arg)
>  	int i, j;
>  
>  	if (mgr->src_it_dsp & PCXHR_IRQ_FREQ_CHANGE)
> -		snd_printdd("TASKLET : PCXHR_IRQ_FREQ_CHANGE event occured\n");
> +		snd_printdd("TASKLET : PCXHR_IRQ_FREQ_CHANGE event occurred\n");
>  	if (mgr->src_it_dsp & PCXHR_IRQ_TIME_CODE)
> -		snd_printdd("TASKLET : PCXHR_IRQ_TIME_CODE event occured\n");
> +		snd_printdd("TASKLET : PCXHR_IRQ_TIME_CODE event occurred\n");
>  	if (mgr->src_it_dsp & PCXHR_IRQ_NOTIFY)
> -		snd_printdd("TASKLET : PCXHR_IRQ_NOTIFY event occured\n");
> +		snd_printdd("TASKLET : PCXHR_IRQ_NOTIFY event occurred\n");
>  	if (mgr->src_it_dsp & (PCXHR_IRQ_FREQ_CHANGE | PCXHR_IRQ_TIME_CODE)) {
>  		/* clear events FREQ_CHANGE and TIME_CODE */
>  		pcxhr_init_rmh(prmh, CMD_TEST_IT);
> @@ -1055,7 +1055,7 @@ void pcxhr_msg_tasklet(unsigned long arg)
>  			    err, prmh->stat[0]);
>  	}
>  	if (mgr->src_it_dsp & PCXHR_IRQ_ASYNC) {
> -		snd_printdd("TASKLET : PCXHR_IRQ_ASYNC event occured\n");
> +		snd_printdd("TASKLET : PCXHR_IRQ_ASYNC event occurred\n");
>  
>  		pcxhr_init_rmh(prmh, CMD_ASYNC);
>  		prmh->cmd[0] |= 1;	/* add SEL_ASYNC_EVENTS */
> @@ -1233,7 +1233,7 @@ irqreturn_t pcxhr_interrupt(int irq, void *dev_id)
>  	reg = PCXHR_INPL(mgr, PCXHR_PLX_L2PCIDB);
>  	PCXHR_OUTPL(mgr, PCXHR_PLX_L2PCIDB, reg);
>  
> -	/* timer irq occured */
> +	/* timer irq occurred */
>  	if (reg & PCXHR_IRQ_TIMER) {
>  		int timer_toggle = reg & PCXHR_IRQ_TIMER;
>  		/* is a 24 bit counter */
> @@ -1288,7 +1288,7 @@ irqreturn_t pcxhr_interrupt(int irq, void *dev_id)
>  	if (reg & PCXHR_IRQ_MASK) {
>  		if (reg & PCXHR_IRQ_ASYNC) {
>  			/* as we didn't request any async notifications,
> -			 * some kind of xrun error will probably occured
> +			 * some kind of xrun error will probably occurred
>  			 */
>  			/* better resynchronize all streams next interrupt : */
>  			mgr->dsp_time_last = PCXHR_DSP_TIME_INVALID;
> diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
> index 1b8f674..64b4336 100644
> --- a/sound/pci/sis7019.c
> +++ b/sound/pci/sis7019.c
> @@ -308,7 +308,7 @@ static irqreturn_t sis_interrupt(int irq, void *dev)
>  	u32 intr, status;
>  
>  	/* We only use the DMA interrupts, and we don't enable any other
> -	 * source of interrupts. But, it is possible to see an interupt
> +	 * source of interrupts. But, it is possible to see an interrupt
>  	 * status that didn't actually interrupt us, so eliminate anything
>  	 * we're not expecting to avoid falsely claiming an IRQ, and an
>  	 * ensuing endless loop.
> diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
> index edce8a2..bc823a5 100644
> --- a/sound/ppc/snd_ps3.c
> +++ b/sound/ppc/snd_ps3.c
> @@ -358,7 +358,7 @@ static irqreturn_t snd_ps3_interrupt(int irq, void *dev_id)
>  		 * filling dummy data, serial automatically start to
>  		 * consume them and then will generate normal buffer
>  		 * empty interrupts.
> -		 * If both buffer underflow and buffer empty are occured,
> +		 * If both buffer underflow and buffer empty are occurred,
>  		 * it is better to do nomal data transfer than empty one
>  		 */
>  		snd_ps3_program_dma(card,
> diff --git a/sound/ppc/snd_ps3_reg.h b/sound/ppc/snd_ps3_reg.h
> index 03fdee4..a7962c5 100644
> --- a/sound/ppc/snd_ps3_reg.h
> +++ b/sound/ppc/snd_ps3_reg.h
> @@ -316,13 +316,13 @@ DISABLED=Interrupt generation disabled.
>  
>  /*
>  Audio Port Interrupt Status Register
> -Indicates Interrupt status, which interrupt has occured, and can clear
> +Indicates Interrupt status, which interrupt has occurred, and can clear
>  each interrupt in this register.
>  Writing 1b to a field containing 1b clears field and de-asserts interrupt.
>  Writing 0b to a field has no effect.
>  Field vaules are the following:
> -0 - Interrupt hasn't occured.
> -1 - Interrupt has occured.
> +0 - Interrupt hasn't occurred.
> +1 - Interrupt has occurred.
>  
>  
>   31            24 23           16 15            8 7             0
> @@ -756,7 +756,7 @@ The STATUS field can be used to monitor the progress of a DMA request.
>  DONE indicates the previous request has completed.
>  EVENT indicates that the DMA engine is waiting for the EVENT to occur.
>  PENDING indicates that the DMA engine has not started processing this
> -request, but the EVENT has occured.
> +request, but the EVENT has occurred.
>  DMA indicates that the data transfer is in progress.
>  NOTIFY indicates that the notifier signalling end of transfer is being written.
>  CLEAR indicated that the previous transfer was cleared.
> diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
> index 5d230ce..7fbfa05 100644
> --- a/sound/soc/atmel/atmel_ssc_dai.c
> +++ b/sound/soc/atmel/atmel_ssc_dai.c
> @@ -672,7 +672,7 @@ static int atmel_ssc_resume(struct snd_soc_dai *cpu_dai)
>  	/* re-enable interrupts */
>  	ssc_writel(ssc_p->ssc->regs, IER, ssc_p->ssc_state.ssc_imr);
>  
> -	/* Re-enable recieve and transmit as appropriate */
> +	/* Re-enable receive and transmit as appropriate */
>  	cr = 0;
>  	cr |=
>  	    (ssc_p->ssc_state.ssc_sr & SSC_BIT(SR_RXEN)) ? SSC_BIT(CR_RXEN) : 0;
> diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
> index b9cb1fc..77f13f9 100644
> --- a/sound/soc/codecs/wm8962.c
> +++ b/sound/soc/codecs/wm8962.c
> @@ -3612,7 +3612,7 @@ static int wm8962_gpio_request(struct gpio_chip *chip, unsigned offset)
>  
>  	/* The WM8962 GPIOs aren't linearly numbered.  For simplicity
>  	 * we export linear numbers and error out if the unsupported
> -	 * ones are requsted.
> +	 * ones are requested.
>  	 */
>  	switch (offset + 1) {
>  	case 2:
> diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
> index 3167be6..d0737ed 100644
> --- a/sound/soc/omap/ams-delta.c
> +++ b/sound/soc/omap/ams-delta.c
> @@ -330,7 +330,7 @@ static int cx81801_hangup(struct tty_struct *tty)
>  	return 0;
>  }
>  
> -/* Line discipline .recieve_buf() */
> +/* Line discipline .receive_buf() */
>  static void cx81801_receive(struct tty_struct *tty,
>  				const unsigned char *cp, char *fp, int count)
>  {
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
