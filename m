Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1ALItm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:49:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab1ALItg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:49:36 -0500
Date: Wed, 12 Jan 2011 09:49:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1101102344030.26685@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336203264-1310692202-1294699693=:26685"
Content-ID: <alpine.LNX.2.00.1101111130140.26685@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336203264-1310692202-1294699693=:26685
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.1101111130141.26685@pobox.suse.cz>

Linus,

please pull from 'for-next' branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-next

to receive updates queued in trivial tree. Nothing earth-shaking, as usual 
with this tree -- some comment typo updates, very simple fixes all over 
the tree.

You are going to receive one conflict in 
drivers/net/wireless/iwlwifi/iwl-core.c -- this is caused by conflict 
between 81baf6ec ("iwlwifi: Legacy isr only used by legacy devices") from 
the net tree and commit 62e45c14 ("wireless: comment typo fix diable -> 
disable") from the trivial tree.

This is because the code got moved around to 
iwl-legacy.c from iwl-core.c, but the typo is still there. The resolution 
is therefore trivial (attached).

Thanks.

Alan Stern (1):
      SCSI: improve two error messages

Andrea Gelmini (1):
      drivers: scsi: fix typo in comment

David Sterba (1):
      i7core_edac: fix typos in comments

Figo.zhang (1):
      mm/rmap.c: fix comment

Jesper Juhl (6):
      VIA Chrome camera: remove duplicate includes
      ARM, mm: Don't include smp_plat.h twice in flush.c
      infiniband: Only include mutex.h once in drivers/infiniband/hw/cxgb4/iw_cxgb4.h
      Kill off a bunch of warning: ‘inline’ is not at beginning of declaration
      coda: kill redundant cast in coda_alloc_inode()
      sound, ca0106: Fix assignment to 'channel'.

Jim Cromie (3):
      init/Kconfig: fix typo
      remove extraneous 'is' from Documentation/iostats.txt
      remove doc for obsolete dynamic-printk kernel-parameter

Jiri Kosina (4):
      Merge branch 'master' into for-next
      Don't touch blackfin with printk typo fixes
      Merge branch 'master' into for-next
      Revert conflicting V4L changes

Jonathan Neuschäfer (1):
      spelling fix in drivers/misc/Kconfig

Justin P. Mattock (5):
      media: comment typo fix diable -> disable.
      wireless: comment typo fix diable -> disable.
      m68k: fix comment typo diable -> disable.
      drivers: fix comment typo diable -> disable.
      ppc: fix comment typo singal -> signal

Lionel Debroux (3):
      hibernation: constify platform_hibernation_ops
      backlight: constify backlight_ops
      suspend: constify platform_suspend_ops

Michael Witten (4):
      Kconfig: typo: and -> an
      Docs: typo: Complete -> Completely
      Kconfig: typo: boad -> board
      Docs/Kconfig: Update: osdl.org -> linuxfoundation.org

Minchan Kim (1):
      writeback: fix global_dirty_limits comment runtime -> real-time

Namhyung Kim (3):
      poll: fix a typo in comment
      anon_inodes: fix wrong function name in comment
      hrtimer: fix a typo in comment

Nicolas Kaiser (1):
      telephony: fix return value

Robert P. J. Day (1):
      Fix "forcably" comment typo

Ross Kirk (1):
      audit: error message typo correction

Simon Horman (1):
      kdump: update kexec-tools URL and Vivek's email

Stefan Weil (2):
      Fix spelling mistakes in comments
      Fix spelling milisec -> ms in snd_ps3 module parameter description

Tao Ma (1):
      Documentation/trace/events.txt: Remove obsolete sched_signal_send.

Uwe Kleine-König (2):
      tree-wide: fix comment/printk typos
      fix comment typos concerning "consistent"

Wu Fengguang (1):
      ext4: fix redirty_page_for_writepage() typo in comment

matt mooney (1):
      powerpc: remove cast from void*

 Documentation/DocBook/mtdnand.tmpl                 |    2 +-
 Documentation/cgroups/cgroup_event_listener.c      |    2 +-
 Documentation/cgroups/memcg_test.txt               |    2 +-
 Documentation/iostats.txt                          |    2 +-
 Documentation/kdump/kdump.txt                      |   15 +++++++++------
 Documentation/kernel-parameters.txt                |    5 -----
 Documentation/ko_KR/HOWTO                          |    4 ++--
 Documentation/kprobes.txt                          |    2 +-
 Documentation/kvm/api.txt                          |    2 +-
 Documentation/lguest/lguest.txt                    |    7 +++++--
 Documentation/networking/bridge.txt                |    4 ++--
 Documentation/networking/caif/spi_porting.txt      |    2 +-
 Documentation/networking/dccp.txt                  |    4 ++--
 Documentation/networking/generic_netlink.txt       |    2 +-
 Documentation/powerpc/booting-without-of.txt       |    2 +-
 Documentation/scheduler/00-INDEX                   |    2 +-
 Documentation/scsi/ChangeLog.lpfc                  |    2 +-
 Documentation/timers/timer_stats.txt               |    2 +-
 Documentation/trace/events.txt                     |    8 ++++----
 Documentation/zh_CN/HOWTO                          |    4 ++--
 Documentation/zh_CN/SubmittingDrivers              |    2 +-
 MAINTAINERS                                        |   10 +++++-----
 arch/arm/common/it8152.c                           |    2 +-
 arch/arm/common/vic.c                              |    2 +-
 arch/arm/mach-at91/board-ecbat91.c                 |    6 +++---
 arch/arm/mach-at91/pm.c                            |    2 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw.c          |    2 +-
 arch/arm/mach-bcmring/csp/dmac/dmacHw.c            |    2 +-
 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c      |    2 +-
 arch/arm/mach-bcmring/csp/tmr/tmrHw.c              |    2 +-
 arch/arm/mach-bcmring/dma.c                        |    2 +-
 arch/arm/mach-bcmring/include/csp/dmacHw.h         |    2 +-
 arch/arm/mach-bcmring/include/csp/tmrHw.h          |    4 ++--
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |    2 +-
 .../arm/mach-bcmring/include/mach/csp/dmacHw_reg.h |    2 +-
 arch/arm/mach-davinci/pm.c                         |    2 +-
 arch/arm/mach-gemini/include/mach/hardware.h       |    2 +-
 arch/arm/mach-imx/pm-imx27.c                       |    2 +-
 arch/arm/mach-lpc32xx/pm.c                         |    2 +-
 arch/arm/mach-msm/include/mach/entry-macro-qgic.S  |    2 +-
 arch/arm/mach-msm/io.c                             |    2 +-
 arch/arm/mach-omap1/pm.c                           |    2 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |    2 +-
 arch/arm/mach-omap2/pm24xx.c                       |    2 +-
 arch/arm/mach-omap2/pm34xx.c                       |    2 +-
 arch/arm/mach-omap2/pm44xx.c                       |    2 +-
 arch/arm/mach-omap2/serial.c                       |    2 +-
 arch/arm/mach-pnx4008/pm.c                         |    2 +-
 arch/arm/mach-pxa/mxm8x10.c                        |    2 +-
 arch/arm/mach-pxa/pm.c                             |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c                     |    2 +-
 arch/arm/mach-s3c64xx/dma.c                        |    2 +-
 arch/arm/mach-sa1100/pm.c                          |    2 +-
 arch/arm/mach-spear3xx/spear300.c                  |    4 ++--
 arch/arm/mach-spear3xx/spear310.c                  |    2 +-
 arch/arm/mach-spear3xx/spear320.c                  |    2 +-
 arch/arm/mach-spear3xx/spear3xx.c                  |    6 +++---
 arch/arm/mach-spear6xx/spear6xx.c                  |    4 ++--
 arch/arm/mach-u300/Kconfig                         |    2 +-
 arch/arm/mach-u300/include/mach/coh901318.h        |    4 ++--
 arch/arm/mm/flush.c                                |    1 -
 arch/arm/plat-mxc/include/mach/irqs.h              |    2 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |    2 +-
 arch/arm/plat-samsung/pm.c                         |    2 +-
 arch/avr32/mach-at32ap/pm.c                        |    2 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |    2 +-
 arch/blackfin/mach-common/pm.c                     |    2 +-
 arch/cris/arch-v32/lib/nand_init.S                 |    2 +-
 arch/cris/include/asm/etraxgpio.h                  |    2 +-
 arch/h8300/Kconfig.debug                           |    2 +-
 arch/ia64/kvm/mmio.c                               |    2 +-
 arch/m68k/ifpsp060/src/fpsp.S                      |    2 +-
 arch/m68k/mac/psc.c                                |    2 +-
 arch/mips/alchemy/common/power.c                   |    2 +-
 arch/mips/alchemy/devboards/pm.c                   |    2 +-
 arch/mips/include/asm/mach-powertv/ioremap.h       |    2 +-
 arch/mips/jz4740/board-qi_lb60.c                   |    4 ++--
 arch/mips/jz4740/gpio.c                            |    2 +-
 arch/mips/jz4740/pm.c                              |    2 +-
 arch/mips/loongson/common/pm.c                     |    2 +-
 arch/mips/mti-malta/malta-memory.c                 |    2 +-
 arch/mips/pci/pcie-octeon.c                        |    2 +-
 arch/mips/powertv/memory.c                         |    2 +-
 arch/mips/txx9/generic/pci.c                       |    2 +-
 arch/powerpc/include/asm/8xx_immap.h               |    4 ++--
 arch/powerpc/oprofile/op_model_cell.c              |    2 +-
 arch/powerpc/platforms/52xx/lite5200_pm.c          |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pm.c           |    2 +-
 arch/powerpc/platforms/83xx/suspend-asm.S          |    6 +++---
 arch/powerpc/platforms/83xx/suspend.c              |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    2 +-
 arch/powerpc/platforms/ps3/device-init.c           |    4 ++--
 arch/powerpc/platforms/ps3/interrupt.c             |    2 +-
 arch/powerpc/platforms/pseries/hvCall_inst.c       |    2 +-
 arch/powerpc/platforms/pseries/suspend.c           |    2 +-
 arch/powerpc/sysdev/fsl_pmc.c                      |    2 +-
 arch/sh/boards/mach-hp6xx/pm.c                     |    2 +-
 arch/sh/kernel/cpu/shmobile/pm.c                   |    2 +-
 arch/sh/mm/cache-sh5.c                             |    2 +-
 arch/sparc/kernel/traps_64.c                       |    2 +-
 arch/x86/include/asm/pgalloc.h                     |    2 +-
 arch/x86/include/asm/processor.h                   |    2 +-
 arch/x86/kernel/amd_iommu.c                        |    4 ++--
 arch/x86/kernel/early_printk_mrst.c                |    2 +-
 arch/x86/kernel/head_32.S                          |    2 +-
 block/cfq-iosched.c                                |    2 +-
 drivers/acpi/acpica/acobject.h                     |    2 +-
 drivers/acpi/apei/einj.c                           |    2 +-
 drivers/acpi/apei/erst.c                           |    2 +-
 drivers/acpi/sleep.c                               |    8 ++++----
 drivers/acpi/video.c                               |    2 +-
 drivers/ata/libata-core.c                          |    4 ++--
 drivers/ata/sata_vsc.c                             |    2 +-
 drivers/atm/idt77252.h                             |    2 +-
 drivers/atm/iphase.c                               |    4 ++--
 drivers/base/bus.c                                 |    2 +-
 drivers/base/power/main.c                          |    2 +-
 drivers/dma/intel_mid_dma.c                        |    6 +++---
 drivers/edac/amd8131_edac.h                        |    2 +-
 drivers/edac/cell_edac.c                           |    4 ++--
 drivers/edac/edac_core.h                           |    2 +-
 drivers/edac/i7core_edac.c                         |    6 +++---
 drivers/edac/ppc4xx_edac.c                         |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_bios.c             |    4 ++--
 drivers/gpu/drm/radeon/atombios.h                  |    2 +-
 drivers/i2c/busses/i2c-nomadik.c                   |    4 ++--
 drivers/infiniband/hw/cxgb3/cxio_wr.h              |    2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    1 -
 drivers/infiniband/hw/qib/qib_iba7322.c            |    2 +-
 drivers/input/serio/Kconfig                        |    2 +-
 drivers/input/touchscreen/Kconfig                  |    2 +-
 drivers/isdn/gigaset/bas-gigaset.c                 |    4 ++--
 drivers/isdn/gigaset/ser-gigaset.c                 |    4 ++--
 drivers/isdn/gigaset/usb-gigaset.c                 |    4 ++--
 drivers/isdn/hardware/mISDN/ipac.h                 |    4 ++--
 drivers/isdn/hardware/mISDN/isar.h                 |    2 +-
 drivers/isdn/mISDN/dsp_cmx.c                       |    2 +-
 drivers/macintosh/via-pmu-backlight.c              |    4 ++--
 drivers/macintosh/via-pmu.c                        |    2 +-
 drivers/media/video/cx18/cx23418.h                 |    2 +-
 drivers/media/video/cx25840/cx25840-ir.c           |    2 +-
 drivers/media/video/davinci/vpif.h                 |    2 +-
 drivers/media/video/davinci/vpss.c                 |    2 +-
 drivers/media/video/omap/omap_vout.c               |    2 +-
 drivers/media/video/saa7164/saa7164-core.c         |    4 ++--
 drivers/media/video/sn9c102/sn9c102_sensor.h       |    2 +-
 drivers/media/video/tvp7002.c                      |    2 +-
 drivers/media/video/via-camera.c                   |    2 --
 drivers/message/fusion/lsi/mpi_log_sas.h           |    2 +-
 drivers/message/fusion/mptbase.c                   |    2 +-
 drivers/message/fusion/mptsas.c                    |    2 +-
 drivers/message/i2o/i2o_block.c                    |    2 +-
 drivers/misc/Kconfig                               |    2 +-
 drivers/misc/arm-charlcd.c                         |    2 +-
 drivers/mmc/card/block.c                           |    2 +-
 drivers/mmc/host/Kconfig                           |    2 +-
 drivers/mmc/host/au1xmmc.c                         |    2 +-
 drivers/mmc/host/sdricoh_cs.c                      |    4 ++--
 drivers/mtd/nand/nand_base.c                       |    2 +-
 drivers/net/bnx2x/bnx2x_main.c                     |    2 +-
 drivers/net/bnx2x/bnx2x_reg.h                      |    2 +-
 drivers/net/bonding/bond_3ad.c                     |    6 +++---
 drivers/net/chelsio/subr.c                         |    2 +-
 drivers/net/cxgb3/mc5.c                            |    2 +-
 drivers/net/cxgb3/t3_hw.c                          |    2 +-
 drivers/net/e1000/e1000_hw.h                       |    2 +-
 drivers/net/e1000/e1000_main.c                     |    2 +-
 drivers/net/e1000e/82571.c                         |    2 +-
 drivers/net/e1000e/ich8lan.c                       |    2 +-
 drivers/net/e1000e/phy.c                           |    2 +-
 drivers/net/eepro.c                                |    2 +-
 drivers/net/irda/donauboe.h                        |    2 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |    4 ++--
 drivers/net/ll_temac_main.c                        |    2 +-
 drivers/net/sis900.c                               |    2 +-
 drivers/net/tehuti.c                               |    6 +++---
 drivers/net/tun.c                                  |    2 +-
 drivers/net/via-velocity.c                         |    2 +-
 drivers/net/vxge/vxge-traffic.h                    |    2 +-
 drivers/net/wan/dscc4.c                            |    2 +-
 drivers/net/wimax/i2400m/driver.c                  |    2 +-
 drivers/net/wimax/i2400m/i2400m.h                  |    4 ++--
 drivers/net/wireless/ath/ath5k/reg.h               |    6 +++---
 drivers/net/wireless/b43/phy_g.c                   |    2 +-
 drivers/net/wireless/b43legacy/phy.c               |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |    2 +-
 drivers/net/wireless/prism54/islpci_dev.c          |    6 +++---
 drivers/net/wireless/prism54/islpci_eth.c          |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |    2 +-
 drivers/net/wireless/wl1251/acx.h                  |    4 ++--
 drivers/net/wireless/wl1251/wl1251.h               |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h               |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_acx.h           |    4 ++--
 drivers/net/wireless/wl3501_cs.c                   |    2 +-
 drivers/pcmcia/m32r_cfc.h                          |    2 +-
 drivers/pcmcia/m32r_pcc.h                          |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c                       |    2 +-
 drivers/platform/x86/acer-wmi.c                    |    2 +-
 drivers/platform/x86/asus-laptop.c                 |    2 +-
 drivers/platform/x86/asus_acpi.c                   |    2 +-
 drivers/platform/x86/dell-laptop.c                 |    2 +-
 drivers/platform/x86/eeepc-laptop.c                |    2 +-
 drivers/platform/x86/fujitsu-laptop.c              |    2 +-
 drivers/platform/x86/sony-laptop.c                 |    2 +-
 drivers/platform/x86/thinkpad_acpi.c               |    4 ++--
 drivers/platform/x86/toshiba_acpi.c                |    2 +-
 drivers/power/s3c_adc_battery.c                    |    4 ++--
 drivers/s390/net/lcs.c                             |    2 +-
 drivers/s390/scsi/zfcp_cfdc.c                      |    2 +-
 drivers/scsi/a100u2w.c                             |    2 +-
 drivers/scsi/aacraid/commsup.c                     |    2 +-
 drivers/scsi/aic7xxx_old/aic7xxx.seq               |    2 +-
 drivers/scsi/aic94xx/aic94xx_reg_def.h             |    4 ++--
 drivers/scsi/aic94xx/aic94xx_scb.c                 |    2 +-
 drivers/scsi/aic94xx/aic94xx_seq.c                 |    6 +++---
 drivers/scsi/bfa/bfa_fcpim.c                       |    2 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |    2 +-
 drivers/scsi/dc395x.c                              |    8 ++++----
 drivers/scsi/libfc/fc_fcp.c                        |    2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |    2 +-
 drivers/scsi/megaraid.h                            |    2 +-
 drivers/scsi/megaraid/megaraid_mm.c                |    2 +-
 drivers/scsi/pm8001/pm8001_init.c                  |    2 +-
 drivers/scsi/scsi_netlink.c                        |    2 +-
 drivers/scsi/scsi_sysfs.c                          |    6 ++++--
 drivers/scsi/sym53c8xx_2/sym_glue.c                |    2 +-
 drivers/spi/atmel_spi.c                            |    4 ++--
 drivers/spi/spidev.c                               |    2 +-
 drivers/staging/msm/msm_fb_bl.c                    |    2 +-
 drivers/staging/olpc_dcon/olpc_dcon.c              |    2 +-
 drivers/staging/samsung-laptop/samsung-laptop.c    |    2 +-
 drivers/telephony/ixj.c                            |    3 ++-
 drivers/usb/gadget/imx_udc.c                       |    2 +-
 drivers/usb/gadget/langwell_udc.c                  |    4 ++--
 drivers/usb/host/fhci-hcd.c                        |    4 ++--
 drivers/usb/host/fhci-tds.c                        |    4 ++--
 drivers/usb/host/imx21-hcd.c                       |    2 +-
 drivers/usb/host/oxu210hp-hcd.c                    |    2 +-
 drivers/usb/misc/adutux.c                          |    2 +-
 drivers/usb/misc/iowarrior.c                       |    2 +-
 drivers/usb/misc/ldusb.c                           |    2 +-
 drivers/usb/musb/musb_gadget.c                     |    4 ++--
 drivers/usb/wusbcore/wa-rpipe.c                    |    2 +-
 drivers/video/atmel_lcdfb.c                        |    2 +-
 drivers/video/aty/aty128fb.c                       |    2 +-
 drivers/video/aty/atyfb_base.c                     |    2 +-
 drivers/video/aty/radeon_backlight.c               |    2 +-
 drivers/video/backlight/88pm860x_bl.c              |    2 +-
 drivers/video/backlight/max8925_bl.c               |    2 +-
 drivers/video/nvidia/nv_backlight.c                |    2 +-
 drivers/video/omap2/displays/panel-taal.c          |    2 +-
 drivers/video/riva/fbdev.c                         |    2 +-
 drivers/video/sstfb.c                              |    2 +-
 fs/anon_inodes.c                                   |    6 +++---
 fs/coda/inode.c                                    |    2 +-
 fs/ext4/ext4.h                                     |    2 +-
 fs/ext4/extents.c                                  |    4 ++--
 fs/ext4/inode.c                                    |    6 +++---
 fs/jbd/transaction.c                               |    2 +-
 fs/jbd2/transaction.c                              |    2 +-
 fs/notify/fanotify/Kconfig                         |    2 +-
 fs/ocfs2/inode.c                                   |    2 +-
 fs/ocfs2/suballoc.c                                |    2 +-
 fs/xfs/linux-2.6/xfs_super.c                       |    2 +-
 include/acpi/actbl1.h                              |    2 +-
 include/linux/cgroup.h                             |    2 +-
 include/linux/firewire-cdev.h                      |    2 +-
 include/linux/mfd/core.h                           |    2 +-
 include/linux/poll.h                               |    2 +-
 include/linux/suspend.h                            |    8 ++++----
 include/linux/u64_stats_sync.h                     |   12 ++++++------
 include/media/davinci/vpss.h                       |    2 +-
 include/net/sctp/user.h                            |    4 ++--
 include/scsi/fc/fc_fcp.h                           |    4 ++--
 init/Kconfig                                       |    2 +-
 kernel/audit.c                                     |    2 +-
 kernel/debug/kdb/kdb_main.c                        |    2 +-
 kernel/hrtimer.c                                   |    2 +-
 kernel/kexec.c                                     |    2 +-
 kernel/perf_event.c                                |    2 +-
 kernel/power/hibernate.c                           |    4 ++--
 kernel/power/suspend.c                             |    4 ++--
 kernel/power/swap.c                                |    2 +-
 kernel/sched.c                                     |    2 +-
 kernel/sysctl_binary.c                             |    2 +-
 kernel/time.c                                      |    4 ++--
 kernel/time/clocksource.c                          |    2 +-
 kernel/trace/trace_entries.h                       |    2 +-
 lib/nlattr.c                                       |    2 +-
 lib/swiotlb.c                                      |    2 +-
 mm/page-writeback.c                                |    2 +-
 mm/page_alloc.c                                    |    2 +-
 mm/percpu.c                                        |    2 +-
 mm/rmap.c                                          |    2 +-
 mm/sparse-vmemmap.c                                |    2 +-
 net/Kconfig                                        |    4 +++-
 net/core/dev.c                                     |    2 +-
 net/dccp/Kconfig                                   |    4 +++-
 net/decnet/dn_dev.c                                |    2 +-
 net/ipv4/Kconfig                                   |    4 +++-
 net/ipv4/tcp_output.c                              |    2 +-
 net/ipv6/af_inet6.c                                |    2 +-
 net/sched/Kconfig                                  |    2 +-
 scripts/kconfig/confdata.c                         |    2 +-
 scripts/mod/modpost.c                              |    2 +-
 security/apparmor/include/match.h                  |    2 +-
 sound/core/init.c                                  |    2 +-
 sound/core/pcm_native.c                            |    2 +-
 sound/isa/opl3sa2.c                                |    2 +-
 sound/pci/ca0106/ca0106.h                          |    2 +-
 sound/pci/ca0106/ca0106_main.c                     |    2 +-
 sound/pci/emu10k1/emu10k1x.c                       |    2 +-
 sound/pci/emu10k1/p16v.h                           |    2 +-
 sound/pci/es1968.c                                 |    2 +-
 sound/pci/rme9652/hdspm.c                          |    6 +++---
 sound/ppc/snd_ps3.c                                |    2 +-
 sound/soc/codecs/max98088.c                        |    2 +-
 sound/soc/s3c24xx/smdk_spdif.c                     |    6 +++---
 325 files changed, 439 insertions(+), 433 deletions(-)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--336203264-1310692202-1294699693=:26685
Content-Type: TEXT/X-PATCH; NAME=resolution.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.1101102348130.26685@pobox.suse.cz>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=resolution.patch

ZGlmZiAtLWNjIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWxl
Z2FjeS5jDQppbmRleCBhMDhiNGU1LDAwMDAwMDAuLmJiMWE3NDINCm1vZGUg
MTAwNjQ0LDAwMDAwMC4uMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9pd2x3aWZpL2l3bC1sZWdhY3kuYw0KKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvaXdsd2lmaS9pd2wtbGVnYWN5LmMNCkBAQCAtMSw2NjIgLTEs
MCArMSw2NjIgQEBADQogKy8qKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioNCiArICoNCiArICogR1BMIExJQ0VOU0UgU1VNTUFSWQ0KICsgKg0K
ICsgKiBDb3B5cmlnaHQoYykgMjAwOCAtIDIwMTAgSW50ZWwgQ29ycG9yYXRp
b24uIEFsbCByaWdodHMgcmVzZXJ2ZWQuDQogKyAqDQogKyAqIFRoaXMgcHJv
Z3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBp
dCBhbmQvb3IgbW9kaWZ5DQogKyAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB2
ZXJzaW9uIDIgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFz
DQogKyAqIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0
aW9uLg0KICsgKg0KICsgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQg
aW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwgYnV0DQogKyAq
IFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxp
ZWQgd2FycmFudHkgb2YNCiArICogTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5F
U1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZSBHTlUNCiAr
ICogR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLg0K
ICsgKg0KICsgKiBZb3Ugc2hvdWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9m
IHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQ0KICsgKiBhbG9uZyB3
aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBT
b2Z0d2FyZQ0KICsgKiBGb3VuZGF0aW9uLCBJbmMuLCA1MSBGcmFua2xpbiBT
dHJlZXQsIEZpZnRoIEZsb29yLCBCb3N0b24sIE1BIDAyMTEwLA0KICsgKiBV
U0ENCiArICoNCiArICogVGhlIGZ1bGwgR05VIEdlbmVyYWwgUHVibGljIExp
Y2Vuc2UgaXMgaW5jbHVkZWQgaW4gdGhpcyBkaXN0cmlidXRpb24NCiArICog
aW4gdGhlIGZpbGUgY2FsbGVkIExJQ0VOU0UuR1BMLg0KICsgKg0KICsgKiBD
b250YWN0IEluZm9ybWF0aW9uOg0KICsgKiAgSW50ZWwgTGludXggV2lyZWxl
c3MgPGlsd0BsaW51eC5pbnRlbC5jb20+DQogKyAqIEludGVsIENvcnBvcmF0
aW9uLCA1MjAwIE4uRS4gRWxhbSBZb3VuZyBQYXJrd2F5LCBIaWxsc2Jvcm8s
IE9SIDk3MTI0LTY0OTcNCiArICoqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqLw0KICsNCiArI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KICsj
aW5jbHVkZSA8bmV0L21hYzgwMjExLmg+DQogKw0KICsjaW5jbHVkZSAiaXds
LWRldi5oIg0KICsjaW5jbHVkZSAiaXdsLWNvcmUuaCINCiArI2luY2x1ZGUg
Iml3bC1oZWxwZXJzLmgiDQogKyNpbmNsdWRlICJpd2wtbGVnYWN5LmgiDQog
Kw0KICtzdGF0aWMgdm9pZCBpd2xfdXBkYXRlX3FvcyhzdHJ1Y3QgaXdsX3By
aXYgKnByaXYsIHN0cnVjdCBpd2xfcnhvbl9jb250ZXh0ICpjdHgpDQogK3sN
CiArCWlmICh0ZXN0X2JpdChTVEFUVVNfRVhJVF9QRU5ESU5HLCAmcHJpdi0+
c3RhdHVzKSkNCiArCQlyZXR1cm47DQogKw0KICsJaWYgKCFjdHgtPmlzX2Fj
dGl2ZSkNCiArCQlyZXR1cm47DQogKw0KICsJY3R4LT5xb3NfZGF0YS5kZWZf
cW9zX3Bhcm0ucW9zX2ZsYWdzID0gMDsNCiArDQogKwlpZiAoY3R4LT5xb3Nf
ZGF0YS5xb3NfYWN0aXZlKQ0KICsJCWN0eC0+cW9zX2RhdGEuZGVmX3Fvc19w
YXJtLnFvc19mbGFncyB8PQ0KICsJCQlRT1NfUEFSQU1fRkxHX1VQREFURV9F
RENBX01TSzsNCiArDQogKwlpZiAoY3R4LT5odC5lbmFibGVkKQ0KICsJCWN0
eC0+cW9zX2RhdGEuZGVmX3Fvc19wYXJtLnFvc19mbGFncyB8PSBRT1NfUEFS
QU1fRkxHX1RHTl9NU0s7DQogKw0KICsJSVdMX0RFQlVHX1FPUyhwcml2LCAi
c2VuZCBRb1MgY21kIHdpdGggUW9zIGFjdGl2ZT0lZCBGTEFHUz0weCVYXG4i
LA0KICsJCSAgICAgIGN0eC0+cW9zX2RhdGEucW9zX2FjdGl2ZSwNCiArCQkg
ICAgICBjdHgtPnFvc19kYXRhLmRlZl9xb3NfcGFybS5xb3NfZmxhZ3MpOw0K
ICsNCiArCWl3bF9zZW5kX2NtZF9wZHVfYXN5bmMocHJpdiwgY3R4LT5xb3Nf
Y21kLA0KICsJCQkgICAgICAgc2l6ZW9mKHN0cnVjdCBpd2xfcW9zcGFyYW1f
Y21kKSwNCiArCQkJICAgICAgICZjdHgtPnFvc19kYXRhLmRlZl9xb3NfcGFy
bSwgTlVMTCk7DQogK30NCiArDQogKy8qKg0KICsgKiBpd2xfbGVnYWN5X21h
Y19jb25maWcgLSBtYWM4MDIxMSBjb25maWcgY2FsbGJhY2sNCiArICovDQog
K2ludCBpd2xfbGVnYWN5X21hY19jb25maWcoc3RydWN0IGllZWU4MDIxMV9o
dyAqaHcsIHUzMiBjaGFuZ2VkKQ0KICt7DQogKwlzdHJ1Y3QgaXdsX3ByaXYg
KnByaXYgPSBody0+cHJpdjsNCiArCWNvbnN0IHN0cnVjdCBpd2xfY2hhbm5l
bF9pbmZvICpjaF9pbmZvOw0KICsJc3RydWN0IGllZWU4MDIxMV9jb25mICpj
b25mID0gJmh3LT5jb25mOw0KICsJc3RydWN0IGllZWU4MDIxMV9jaGFubmVs
ICpjaGFubmVsID0gY29uZi0+Y2hhbm5lbDsNCiArCXN0cnVjdCBpd2xfaHRf
Y29uZmlnICpodF9jb25mID0gJnByaXYtPmN1cnJlbnRfaHRfY29uZmlnOw0K
ICsJc3RydWN0IGl3bF9yeG9uX2NvbnRleHQgKmN0eDsNCiArCXVuc2lnbmVk
IGxvbmcgZmxhZ3MgPSAwOw0KICsJaW50IHJldCA9IDA7DQogKwl1MTYgY2g7
DQogKwlpbnQgc2Nhbl9hY3RpdmUgPSAwOw0KICsJYm9vbCBodF9jaGFuZ2Vk
W05VTV9JV0xfUlhPTl9DVFhdID0ge307DQogKw0KICsJaWYgKFdBUk5fT04o
IXByaXYtPmNmZy0+b3BzLT5sZWdhY3kpKQ0KICsJCXJldHVybiAtRU9QTk9U
U1VQUDsNCiArDQogKwltdXRleF9sb2NrKCZwcml2LT5tdXRleCk7DQogKw0K
ICsJSVdMX0RFQlVHX01BQzgwMjExKHByaXYsICJlbnRlciB0byBjaGFubmVs
ICVkIGNoYW5nZWQgMHglWFxuIiwNCiArCQkJCQljaGFubmVsLT5od192YWx1
ZSwgY2hhbmdlZCk7DQogKw0KICsJaWYgKHVubGlrZWx5KCFwcml2LT5jZmct
Pm1vZF9wYXJhbXMtPmRpc2FibGVfaHdfc2NhbiAmJg0KICsJCQl0ZXN0X2Jp
dChTVEFUVVNfU0NBTk5JTkcsICZwcml2LT5zdGF0dXMpKSkgew0KICsJCXNj
YW5fYWN0aXZlID0gMTsNCiArCQlJV0xfREVCVUdfTUFDODAyMTEocHJpdiwg
ImxlYXZlIC0gc2Nhbm5pbmdcbiIpOw0KICsJfQ0KICsNCiArCWlmIChjaGFu
Z2VkICYgKElFRUU4MDIxMV9DT05GX0NIQU5HRV9TTVBTIHwNCiArCQkgICAg
ICAgSUVFRTgwMjExX0NPTkZfQ0hBTkdFX0NIQU5ORUwpKSB7DQogKwkJLyog
bWFjODAyMTEgdXNlcyBzdGF0aWMgZm9yIG5vbi1IVCB3aGljaCBpcyB3aGF0
IHdlIHdhbnQgKi8NCiArCQlwcml2LT5jdXJyZW50X2h0X2NvbmZpZy5zbXBz
ID0gY29uZi0+c21wc19tb2RlOw0KICsNCiArCQkvKg0KICsJCSAqIFJlY2Fs
Y3VsYXRlIGNoYWluIGNvdW50cy4NCiArCQkgKg0KICsJCSAqIElmIG1vbml0
b3IgbW9kZSBpcyBlbmFibGVkIHRoZW4gbWFjODAyMTEgd2lsbA0KICsJCSAq
IHNldCB1cCB0aGUgU00gUFMgbW9kZSB0byBPRkYgaWYgYW4gSFQgY2hhbm5l
bCBpcw0KICsJCSAqIGNvbmZpZ3VyZWQuDQogKwkJICovDQogKwkJaWYgKHBy
aXYtPmNmZy0+b3BzLT5oY21kLT5zZXRfcnhvbl9jaGFpbikNCiArCQkJZm9y
X2VhY2hfY29udGV4dChwcml2LCBjdHgpDQogKwkJCQlwcml2LT5jZmctPm9w
cy0+aGNtZC0+c2V0X3J4b25fY2hhaW4ocHJpdiwgY3R4KTsNCiArCX0NCiAr
DQogKwkvKiBkdXJpbmcgc2Nhbm5pbmcgbWFjODAyMTEgd2lsbCBkZWxheSBj
aGFubmVsIHNldHRpbmcgdW50aWwNCiArCSAqIHNjYW4gZmluaXNoIHdpdGgg
Y2hhbmdlZCA9IDANCiArCSAqLw0KICsJaWYgKCFjaGFuZ2VkIHx8IChjaGFu
Z2VkICYgSUVFRTgwMjExX0NPTkZfQ0hBTkdFX0NIQU5ORUwpKSB7DQogKwkJ
aWYgKHNjYW5fYWN0aXZlKQ0KICsJCQlnb3RvIHNldF9jaF9vdXQ7DQogKw0K
ICsJCWNoID0gY2hhbm5lbC0+aHdfdmFsdWU7DQogKwkJY2hfaW5mbyA9IGl3
bF9nZXRfY2hhbm5lbF9pbmZvKHByaXYsIGNoYW5uZWwtPmJhbmQsIGNoKTsN
CiArCQlpZiAoIWlzX2NoYW5uZWxfdmFsaWQoY2hfaW5mbykpIHsNCiArCQkJ
SVdMX0RFQlVHX01BQzgwMjExKHByaXYsICJsZWF2ZSAtIGludmFsaWQgY2hh
bm5lbFxuIik7DQogKwkJCXJldCA9IC1FSU5WQUw7DQogKwkJCWdvdG8gc2V0
X2NoX291dDsNCiArCQl9DQogKw0KICsJCXNwaW5fbG9ja19pcnFzYXZlKCZw
cml2LT5sb2NrLCBmbGFncyk7DQogKw0KICsJCWZvcl9lYWNoX2NvbnRleHQo
cHJpdiwgY3R4KSB7DQogKwkJCS8qIENvbmZpZ3VyZSBIVDQwIGNoYW5uZWxz
ICovDQogKwkJCWlmIChjdHgtPmh0LmVuYWJsZWQgIT0gY29uZl9pc19odChj
b25mKSkgew0KICsJCQkJY3R4LT5odC5lbmFibGVkID0gY29uZl9pc19odChj
b25mKTsNCiArCQkJCWh0X2NoYW5nZWRbY3R4LT5jdHhpZF0gPSB0cnVlOw0K
ICsJCQl9DQogKwkJCWlmIChjdHgtPmh0LmVuYWJsZWQpIHsNCiArCQkJCWlm
IChjb25mX2lzX2h0NDBfbWludXMoY29uZikpIHsNCiArCQkJCQljdHgtPmh0
LmV4dGVuc2lvbl9jaGFuX29mZnNldCA9DQogKwkJCQkJCUlFRUU4MDIxMV9I
VF9QQVJBTV9DSEFfU0VDX0JFTE9XOw0KICsJCQkJCWN0eC0+aHQuaXNfNDBt
aHogPSB0cnVlOw0KICsJCQkJfSBlbHNlIGlmIChjb25mX2lzX2h0NDBfcGx1
cyhjb25mKSkgew0KICsJCQkJCWN0eC0+aHQuZXh0ZW5zaW9uX2NoYW5fb2Zm
c2V0ID0NCiArCQkJCQkJSUVFRTgwMjExX0hUX1BBUkFNX0NIQV9TRUNfQUJP
VkU7DQogKwkJCQkJY3R4LT5odC5pc180MG1oeiA9IHRydWU7DQogKwkJCQl9
IGVsc2Ugew0KICsJCQkJCWN0eC0+aHQuZXh0ZW5zaW9uX2NoYW5fb2Zmc2V0
ID0NCiArCQkJCQkJSUVFRTgwMjExX0hUX1BBUkFNX0NIQV9TRUNfTk9ORTsN
CiArCQkJCQljdHgtPmh0LmlzXzQwbWh6ID0gZmFsc2U7DQogKwkJCQl9DQog
KwkJCX0gZWxzZQ0KICsJCQkJY3R4LT5odC5pc180MG1oeiA9IGZhbHNlOw0K
ICsNCiArCQkJLyoNCiArCQkJICogRGVmYXVsdCB0byBubyBwcm90ZWN0aW9u
LiBQcm90ZWN0aW9uIG1vZGUgd2lsbA0KICsJCQkgKiBsYXRlciBiZSBzZXQg
ZnJvbSBCU1MgY29uZmlnIGluIGl3bF9odF9jb25mDQogKwkJCSAqLw0KICsJ
CQljdHgtPmh0LnByb3RlY3Rpb24gPSBJRUVFODAyMTFfSFRfT1BfTU9ERV9Q
Uk9URUNUSU9OX05PTkU7DQogKw0KICsJCQkvKiBpZiB3ZSBhcmUgc3dpdGNo
aW5nIGZyb20gaHQgdG8gMi40IGNsZWFyIGZsYWdzDQogKwkJCSAqIGZyb20g
YW55IGh0IHJlbGF0ZWQgaW5mbyBzaW5jZSAyLjQgZG9lcyBub3QNCiArCQkJ
ICogc3VwcG9ydCBodCAqLw0KICsJCQlpZiAoKGxlMTZfdG9fY3B1KGN0eC0+
c3RhZ2luZy5jaGFubmVsKSAhPSBjaCkpDQogKwkJCQljdHgtPnN0YWdpbmcu
ZmxhZ3MgPSAwOw0KICsNCiArCQkJaXdsX3NldF9yeG9uX2NoYW5uZWwocHJp
diwgY2hhbm5lbCwgY3R4KTsNCiArCQkJaXdsX3NldF9yeG9uX2h0KHByaXYs
IGh0X2NvbmYpOw0KICsNCiArCQkJaXdsX3NldF9mbGFnc19mb3JfYmFuZChw
cml2LCBjdHgsIGNoYW5uZWwtPmJhbmQsDQogKwkJCQkJICAgICAgIGN0eC0+
dmlmKTsNCiArCQl9DQogKw0KICsJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
JnByaXYtPmxvY2ssIGZsYWdzKTsNCiArDQogKwkJaWYgKHByaXYtPmNmZy0+
b3BzLT5sZWdhY3ktPnVwZGF0ZV9iY2FzdF9zdGF0aW9ucykNCiArCQkJcmV0
ID0gcHJpdi0+Y2ZnLT5vcHMtPmxlZ2FjeS0+dXBkYXRlX2JjYXN0X3N0YXRp
b25zKHByaXYpOw0KICsNCiArIHNldF9jaF9vdXQ6DQogKwkJLyogVGhlIGxp
c3Qgb2Ygc3VwcG9ydGVkIHJhdGVzIGFuZCByYXRlIG1hc2sgY2FuIGJlIGRp
ZmZlcmVudA0KICsJCSAqIGZvciBlYWNoIGJhbmQ7IHNpbmNlIHRoZSBiYW5k
IG1heSBoYXZlIGNoYW5nZWQsIHJlc2V0DQogKwkJICogdGhlIHJhdGUgbWFz
ayB0byB3aGF0IG1hYzgwMjExIGxpc3RzICovDQogKwkJaXdsX3NldF9yYXRl
KHByaXYpOw0KICsJfQ0KICsNCiArCWlmIChjaGFuZ2VkICYgKElFRUU4MDIx
MV9DT05GX0NIQU5HRV9QUyB8DQogKwkJCUlFRUU4MDIxMV9DT05GX0NIQU5H
RV9JRExFKSkgew0KICsJCXJldCA9IGl3bF9wb3dlcl91cGRhdGVfbW9kZShw
cml2LCBmYWxzZSk7DQogKwkJaWYgKHJldCkNCiArCQkJSVdMX0RFQlVHX01B
QzgwMjExKHByaXYsICJFcnJvciBzZXR0aW5nIHNsZWVwIGxldmVsXG4iKTsN
CiArCX0NCiArDQogKwlpZiAoY2hhbmdlZCAmIElFRUU4MDIxMV9DT05GX0NI
QU5HRV9QT1dFUikgew0KICsJCUlXTF9ERUJVR19NQUM4MDIxMShwcml2LCAi
VFggUG93ZXIgb2xkPSVkIG5ldz0lZFxuIiwNCiArCQkJcHJpdi0+dHhfcG93
ZXJfdXNlcl9sbXQsIGNvbmYtPnBvd2VyX2xldmVsKTsNCiArDQogKwkJaXds
X3NldF90eF9wb3dlcihwcml2LCBjb25mLT5wb3dlcl9sZXZlbCwgZmFsc2Up
Ow0KICsJfQ0KICsNCiArCWlmICghaXdsX2lzX3JlYWR5KHByaXYpKSB7DQog
KwkJSVdMX0RFQlVHX01BQzgwMjExKHByaXYsICJsZWF2ZSAtIG5vdCByZWFk
eVxuIik7DQogKwkJZ290byBvdXQ7DQogKwl9DQogKw0KICsJaWYgKHNjYW5f
YWN0aXZlKQ0KICsJCWdvdG8gb3V0Ow0KICsNCiArCWZvcl9lYWNoX2NvbnRl
eHQocHJpdiwgY3R4KSB7DQogKwkJaWYgKG1lbWNtcCgmY3R4LT5hY3RpdmUs
ICZjdHgtPnN0YWdpbmcsIHNpemVvZihjdHgtPnN0YWdpbmcpKSkNCiArCQkJ
aXdsY29yZV9jb21taXRfcnhvbihwcml2LCBjdHgpOw0KICsJCWVsc2UNCiAr
CQkJSVdMX0RFQlVHX0lORk8ocHJpdiwNCiArCQkJCSJOb3QgcmUtc2VuZGlu
ZyBzYW1lIFJYT04gY29uZmlndXJhdGlvbi5cbiIpOw0KICsJCWlmIChodF9j
aGFuZ2VkW2N0eC0+Y3R4aWRdKQ0KICsJCQlpd2xfdXBkYXRlX3Fvcyhwcml2
LCBjdHgpOw0KICsJfQ0KICsNCiArb3V0Og0KICsJSVdMX0RFQlVHX01BQzgw
MjExKHByaXYsICJsZWF2ZVxuIik7DQogKwltdXRleF91bmxvY2soJnByaXYt
Pm11dGV4KTsNCiArCXJldHVybiByZXQ7DQogK30NCiArRVhQT1JUX1NZTUJP
TChpd2xfbGVnYWN5X21hY19jb25maWcpOw0KICsNCiArdm9pZCBpd2xfbGVn
YWN5X21hY19yZXNldF90c2Yoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQog
K3sNCiArCXN0cnVjdCBpd2xfcHJpdiAqcHJpdiA9IGh3LT5wcml2Ow0KICsJ
dW5zaWduZWQgbG9uZyBmbGFnczsNCiArCS8qIElCU1MgY2FuIG9ubHkgYmUg
dGhlIElXTF9SWE9OX0NUWF9CU1MgY29udGV4dCAqLw0KICsJc3RydWN0IGl3
bF9yeG9uX2NvbnRleHQgKmN0eCA9ICZwcml2LT5jb250ZXh0c1tJV0xfUlhP
Tl9DVFhfQlNTXTsNCiArDQogKwlpZiAoV0FSTl9PTighcHJpdi0+Y2ZnLT5v
cHMtPmxlZ2FjeSkpDQogKwkJcmV0dXJuOw0KICsNCiArCW11dGV4X2xvY2so
JnByaXYtPm11dGV4KTsNCiArCUlXTF9ERUJVR19NQUM4MDIxMShwcml2LCAi
ZW50ZXJcbiIpOw0KICsNCiArCXNwaW5fbG9ja19pcnFzYXZlKCZwcml2LT5s
b2NrLCBmbGFncyk7DQogKwltZW1zZXQoJnByaXYtPmN1cnJlbnRfaHRfY29u
ZmlnLCAwLCBzaXplb2Yoc3RydWN0IGl3bF9odF9jb25maWcpKTsNCiArCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCiAr
DQogKwlzcGluX2xvY2tfaXJxc2F2ZSgmcHJpdi0+bG9jaywgZmxhZ3MpOw0K
ICsNCiArCS8qIG5ldyBhc3NvY2lhdGlvbiBnZXQgcmlkIG9mIGlic3MgYmVh
Y29uIHNrYiAqLw0KICsJaWYgKHByaXYtPmJlYWNvbl9za2IpDQogKwkJZGV2
X2tmcmVlX3NrYihwcml2LT5iZWFjb25fc2tiKTsNCiArDQogKwlwcml2LT5i
ZWFjb25fc2tiID0gTlVMTDsNCiArDQogKwlwcml2LT50aW1lc3RhbXAgPSAw
Ow0KICsNCiArCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnByaXYtPmxvY2ss
IGZsYWdzKTsNCiArDQogKwlpd2xfc2Nhbl9jYW5jZWxfdGltZW91dChwcml2
LCAxMDApOw0KICsJaWYgKCFpd2xfaXNfcmVhZHlfcmYocHJpdikpIHsNCiAr
CQlJV0xfREVCVUdfTUFDODAyMTEocHJpdiwgImxlYXZlIC0gbm90IHJlYWR5
XG4iKTsNCiArCQltdXRleF91bmxvY2soJnByaXYtPm11dGV4KTsNCiArCQly
ZXR1cm47DQogKwl9DQogKw0KICsJLyogd2UgYXJlIHJlc3RhcnRpbmcgYXNz
b2NpYXRpb24gcHJvY2Vzcw0KICsJICogY2xlYXIgUlhPTl9GSUxURVJfQVNT
T0NfTVNLIGJpdA0KICsJICovDQogKwljdHgtPnN0YWdpbmcuZmlsdGVyX2Zs
YWdzICY9IH5SWE9OX0ZJTFRFUl9BU1NPQ19NU0s7DQogKwlpd2xjb3JlX2Nv
bW1pdF9yeG9uKHByaXYsIGN0eCk7DQogKw0KICsJaXdsX3NldF9yYXRlKHBy
aXYpOw0KICsNCiArCW11dGV4X3VubG9jaygmcHJpdi0+bXV0ZXgpOw0KICsN
CiArCUlXTF9ERUJVR19NQUM4MDIxMShwcml2LCAibGVhdmVcbiIpOw0KICt9
DQogK0VYUE9SVF9TWU1CT0woaXdsX2xlZ2FjeV9tYWNfcmVzZXRfdHNmKTsN
CiArDQogK3N0YXRpYyB2b2lkIGl3bF9odF9jb25mKHN0cnVjdCBpd2xfcHJp
diAqcHJpdiwNCiArCQkJc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikNCiAr
ew0KICsJc3RydWN0IGl3bF9odF9jb25maWcgKmh0X2NvbmYgPSAmcHJpdi0+
Y3VycmVudF9odF9jb25maWc7DQogKwlzdHJ1Y3QgaWVlZTgwMjExX3N0YSAq
c3RhOw0KICsJc3RydWN0IGllZWU4MDIxMV9ic3NfY29uZiAqYnNzX2NvbmYg
PSAmdmlmLT5ic3NfY29uZjsNCiArCXN0cnVjdCBpd2xfcnhvbl9jb250ZXh0
ICpjdHggPSBpd2xfcnhvbl9jdHhfZnJvbV92aWYodmlmKTsNCiArDQogKwlJ
V0xfREVCVUdfQVNTT0MocHJpdiwgImVudGVyOlxuIik7DQogKw0KICsJaWYg
KCFjdHgtPmh0LmVuYWJsZWQpDQogKwkJcmV0dXJuOw0KICsNCiArCWN0eC0+
aHQucHJvdGVjdGlvbiA9DQogKwkJYnNzX2NvbmYtPmh0X29wZXJhdGlvbl9t
b2RlICYgSUVFRTgwMjExX0hUX09QX01PREVfUFJPVEVDVElPTjsNCiArCWN0
eC0+aHQubm9uX2dmX3N0YV9wcmVzZW50ID0NCiArCQkhIShic3NfY29uZi0+
aHRfb3BlcmF0aW9uX21vZGUgJiBJRUVFODAyMTFfSFRfT1BfTU9ERV9OT05f
R0ZfU1RBX1BSU05UKTsNCiArDQogKwlodF9jb25mLT5zaW5nbGVfY2hhaW5f
c3VmZmljaWVudCA9IGZhbHNlOw0KICsNCiArCXN3aXRjaCAodmlmLT50eXBl
KSB7DQogKwljYXNlIE5MODAyMTFfSUZUWVBFX1NUQVRJT046DQogKwkJcmN1
X3JlYWRfbG9jaygpOw0KICsJCXN0YSA9IGllZWU4MDIxMV9maW5kX3N0YSh2
aWYsIGJzc19jb25mLT5ic3NpZCk7DQogKwkJaWYgKHN0YSkgew0KICsJCQlz
dHJ1Y3QgaWVlZTgwMjExX3N0YV9odF9jYXAgKmh0X2NhcCA9ICZzdGEtPmh0
X2NhcDsNCiArCQkJaW50IG1heHN0cmVhbXM7DQogKw0KICsJCQltYXhzdHJl
YW1zID0gKGh0X2NhcC0+bWNzLnR4X3BhcmFtcyAmDQogKwkJCQkgICAgICBJ
RUVFODAyMTFfSFRfTUNTX1RYX01BWF9TVFJFQU1TX01BU0spDQogKwkJCQkJ
Pj4gSUVFRTgwMjExX0hUX01DU19UWF9NQVhfU1RSRUFNU19TSElGVDsNCiAr
CQkJbWF4c3RyZWFtcyArPSAxOw0KICsNCiArCQkJaWYgKChodF9jYXAtPm1j
cy5yeF9tYXNrWzFdID09IDApICYmDQogKwkJCSAgICAoaHRfY2FwLT5tY3Mu
cnhfbWFza1syXSA9PSAwKSkNCiArCQkJCWh0X2NvbmYtPnNpbmdsZV9jaGFp
bl9zdWZmaWNpZW50ID0gdHJ1ZTsNCiArCQkJaWYgKG1heHN0cmVhbXMgPD0g
MSkNCiArCQkJCWh0X2NvbmYtPnNpbmdsZV9jaGFpbl9zdWZmaWNpZW50ID0g
dHJ1ZTsNCiArCQl9IGVsc2Ugew0KICsJCQkvKg0KICsJCQkgKiBJZiBhdCBh
bGwsIHRoaXMgY2FuIG9ubHkgaGFwcGVuIHRocm91Z2ggYSByYWNlDQogKwkJ
CSAqIHdoZW4gdGhlIEFQIGRpc2Nvbm5lY3RzIHVzIHdoaWxlIHdlJ3JlIHN0
aWxsDQogKwkJCSAqIHNldHRpbmcgdXAgdGhlIGNvbm5lY3Rpb24sIGluIHRo
YXQgY2FzZSBtYWM4MDIxMQ0KICsJCQkgKiB3aWxsIHNvb24gdGVsbCB1cyBh
Ym91dCB0aGF0Lg0KICsJCQkgKi8NCiArCQkJaHRfY29uZi0+c2luZ2xlX2No
YWluX3N1ZmZpY2llbnQgPSB0cnVlOw0KICsJCX0NCiArCQlyY3VfcmVhZF91
bmxvY2soKTsNCiArCQlicmVhazsNCiArCWNhc2UgTkw4MDIxMV9JRlRZUEVf
QURIT0M6DQogKwkJaHRfY29uZi0+c2luZ2xlX2NoYWluX3N1ZmZpY2llbnQg
PSB0cnVlOw0KICsJCWJyZWFrOw0KICsJZGVmYXVsdDoNCiArCQlicmVhazsN
CiArCX0NCiArDQogKwlJV0xfREVCVUdfQVNTT0MocHJpdiwgImxlYXZlXG4i
KTsNCiArfQ0KICsNCiArc3RhdGljIGlubGluZSB2b2lkIGl3bF9zZXRfbm9f
YXNzb2Moc3RydWN0IGl3bF9wcml2ICpwcml2LA0KICsJCQkJICAgIHN0cnVj
dCBpZWVlODAyMTFfdmlmICp2aWYpDQogK3sNCiArCXN0cnVjdCBpd2xfcnhv
bl9jb250ZXh0ICpjdHggPSBpd2xfcnhvbl9jdHhfZnJvbV92aWYodmlmKTsN
CiArDQogKwlpd2xfbGVkX2Rpc2Fzc29jaWF0ZShwcml2KTsNCiArCS8qDQog
KwkgKiBpbmZvcm0gdGhlIHVjb2RlIHRoYXQgdGhlcmUgaXMgbm8gbG9uZ2Vy
IGFuDQogKwkgKiBhc3NvY2lhdGlvbiBhbmQgdGhhdCBubyBtb3JlIHBhY2tl
dHMgc2hvdWxkIGJlDQogKwkgKiBzZW50DQogKwkgKi8NCiArCWN0eC0+c3Rh
Z2luZy5maWx0ZXJfZmxhZ3MgJj0gflJYT05fRklMVEVSX0FTU09DX01TSzsN
CiArCWN0eC0+c3RhZ2luZy5hc3NvY19pZCA9IDA7DQogKwlpd2xjb3JlX2Nv
bW1pdF9yeG9uKHByaXYsIGN0eCk7DQogK30NCiArDQogK3N0YXRpYyB2b2lk
IGl3bGNvcmVfYmVhY29uX3VwZGF0ZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywNCiArCQkJCSAgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikNCiArew0K
ICsJc3RydWN0IGl3bF9wcml2ICpwcml2ID0gaHctPnByaXY7DQogKwl1bnNp
Z25lZCBsb25nIGZsYWdzOw0KICsJX19sZTY0IHRpbWVzdGFtcDsNCiArCXN0
cnVjdCBza19idWZmICpza2IgPSBpZWVlODAyMTFfYmVhY29uX2dldChodywg
dmlmKTsNCiArDQogKwlpZiAoIXNrYikNCiArCQlyZXR1cm47DQogKw0KICsJ
SVdMX0RFQlVHX01BQzgwMjExKHByaXYsICJlbnRlclxuIik7DQogKw0KICsJ
bG9ja2RlcF9hc3NlcnRfaGVsZCgmcHJpdi0+bXV0ZXgpOw0KICsNCiArCWlm
ICghcHJpdi0+YmVhY29uX2N0eCkgew0KICsJCUlXTF9FUlIocHJpdiwgInVw
ZGF0ZSBiZWFjb24gYnV0IG5vIGJlYWNvbiBjb250ZXh0IVxuIik7DQogKwkJ
ZGV2X2tmcmVlX3NrYihza2IpOw0KICsJCXJldHVybjsNCiArCX0NCiArDQog
KwlzcGluX2xvY2tfaXJxc2F2ZSgmcHJpdi0+bG9jaywgZmxhZ3MpOw0KICsN
CiArCWlmIChwcml2LT5iZWFjb25fc2tiKQ0KICsJCWRldl9rZnJlZV9za2Io
cHJpdi0+YmVhY29uX3NrYik7DQogKw0KICsJcHJpdi0+YmVhY29uX3NrYiA9
IHNrYjsNCiArDQogKwl0aW1lc3RhbXAgPSAoKHN0cnVjdCBpZWVlODAyMTFf
bWdtdCAqKXNrYi0+ZGF0YSktPnUuYmVhY29uLnRpbWVzdGFtcDsNCiArCXBy
aXYtPnRpbWVzdGFtcCA9IGxlNjRfdG9fY3B1KHRpbWVzdGFtcCk7DQogKw0K
ICsJSVdMX0RFQlVHX01BQzgwMjExKHByaXYsICJsZWF2ZVxuIik7DQogKwlz
cGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5sb2NrLCBmbGFncyk7DQog
Kw0KICsJaWYgKCFpd2xfaXNfcmVhZHlfcmYocHJpdikpIHsNCiArCQlJV0xf
REVCVUdfTUFDODAyMTEocHJpdiwgImxlYXZlIC0gUkYgbm90IHJlYWR5XG4i
KTsNCiArCQlyZXR1cm47DQogKwl9DQogKw0KICsJcHJpdi0+Y2ZnLT5vcHMt
PmxlZ2FjeS0+cG9zdF9hc3NvY2lhdGUocHJpdik7DQogK30NCiArDQogK3Zv
aWQgaXdsX2xlZ2FjeV9tYWNfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywNCiArCQkJCSAgICAgc3RydWN0IGllZWU4MDIxMV92
aWYgKnZpZiwNCiArCQkJCSAgICAgc3RydWN0IGllZWU4MDIxMV9ic3NfY29u
ZiAqYnNzX2NvbmYsDQogKwkJCQkgICAgIHUzMiBjaGFuZ2VzKQ0KICt7DQog
KwlzdHJ1Y3QgaXdsX3ByaXYgKnByaXYgPSBody0+cHJpdjsNCiArCXN0cnVj
dCBpd2xfcnhvbl9jb250ZXh0ICpjdHggPSBpd2xfcnhvbl9jdHhfZnJvbV92
aWYodmlmKTsNCiArCWludCByZXQ7DQogKw0KICsJaWYgKFdBUk5fT04oIXBy
aXYtPmNmZy0+b3BzLT5sZWdhY3kpKQ0KICsJCXJldHVybjsNCiArDQogKwlJ
V0xfREVCVUdfTUFDODAyMTEocHJpdiwgImNoYW5nZXMgPSAweCVYXG4iLCBj
aGFuZ2VzKTsNCiArDQogKwlpZiAoIWl3bF9pc19hbGl2ZShwcml2KSkNCiAr
CQlyZXR1cm47DQogKw0KICsJbXV0ZXhfbG9jaygmcHJpdi0+bXV0ZXgpOw0K
ICsNCiArCWlmIChjaGFuZ2VzICYgQlNTX0NIQU5HRURfUU9TKSB7DQogKwkJ
dW5zaWduZWQgbG9uZyBmbGFnczsNCiArDQogKwkJc3Bpbl9sb2NrX2lycXNh
dmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCiArCQljdHgtPnFvc19kYXRhLnFv
c19hY3RpdmUgPSBic3NfY29uZi0+cW9zOw0KICsJCWl3bF91cGRhdGVfcW9z
KHByaXYsIGN0eCk7DQogKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcHJp
di0+bG9jaywgZmxhZ3MpOw0KICsJfQ0KICsNCiArCWlmIChjaGFuZ2VzICYg
QlNTX0NIQU5HRURfQkVBQ09OX0VOQUJMRUQpIHsNCiArCQkvKg0KICsJCSAq
IHRoZSBhZGRfaW50ZXJmYWNlIGNvZGUgbXVzdCBtYWtlIHN1cmUgd2Ugb25s
eSBldmVyDQogKwkJICogaGF2ZSBhIHNpbmdsZSBpbnRlcmZhY2UgdGhhdCBj
b3VsZCBiZSBiZWFjb25pbmcgYXQNCiArCQkgKiBhbnkgdGltZS4NCiArCQkg
Ki8NCiArCQlpZiAodmlmLT5ic3NfY29uZi5lbmFibGVfYmVhY29uKQ0KICsJ
CQlwcml2LT5iZWFjb25fY3R4ID0gY3R4Ow0KICsJCWVsc2UNCiArCQkJcHJp
di0+YmVhY29uX2N0eCA9IE5VTEw7DQogKwl9DQogKw0KICsJaWYgKGNoYW5n
ZXMgJiBCU1NfQ0hBTkdFRF9CRUFDT04gJiYgdmlmLT50eXBlID09IE5MODAy
MTFfSUZUWVBFX0FQKSB7DQogKwkJZGV2X2tmcmVlX3NrYihwcml2LT5iZWFj
b25fc2tiKTsNCiArCQlwcml2LT5iZWFjb25fc2tiID0gaWVlZTgwMjExX2Jl
YWNvbl9nZXQoaHcsIHZpZik7DQogKwl9DQogKw0KICsJaWYgKGNoYW5nZXMg
JiBCU1NfQ0hBTkdFRF9CRUFDT05fSU5UICYmIHZpZi0+dHlwZSA9PSBOTDgw
MjExX0lGVFlQRV9BUCkNCiArCQlpd2xfc2VuZF9yeG9uX3RpbWluZyhwcml2
LCBjdHgpOw0KICsNCiArCWlmIChjaGFuZ2VzICYgQlNTX0NIQU5HRURfQlNT
SUQpIHsNCiArCQlJV0xfREVCVUdfTUFDODAyMTEocHJpdiwgIkJTU0lEICVw
TVxuIiwgYnNzX2NvbmYtPmJzc2lkKTsNCiArDQogKwkJLyoNCiArCQkgKiBJ
ZiB0aGVyZSBpcyBjdXJyZW50bHkgYSBIVyBzY2FuIGdvaW5nIG9uIGluIHRo
ZQ0KICsJCSAqIGJhY2tncm91bmQgdGhlbiB3ZSBuZWVkIHRvIGNhbmNlbCBp
dCBlbHNlIHRoZSBSWE9ODQogKwkJICogYmVsb3cvaW4gcG9zdF9hc3NvY2lh
dGUgd2lsbCBmYWlsLg0KICsJCSAqLw0KICsJCWlmIChpd2xfc2Nhbl9jYW5j
ZWxfdGltZW91dChwcml2LCAxMDApKSB7DQogKwkJCUlXTF9XQVJOKHByaXYs
ICJBYm9ydGVkIHNjYW4gc3RpbGwgaW4gcHJvZ3Jlc3MgYWZ0ZXIgMTAwbXNc
biIpOw0KICsJCQlJV0xfREVCVUdfTUFDODAyMTEocHJpdiwgImxlYXZpbmcg
LSBzY2FuIGFib3J0IGZhaWxlZC5cbiIpOw0KICsJCQltdXRleF91bmxvY2so
JnByaXYtPm11dGV4KTsNCiArCQkJcmV0dXJuOw0KICsJCX0NCiArDQogKwkJ
LyogbWFjODAyMTEgb25seSBzZXRzIGFzc29jIHdoZW4gaW4gU1RBVElPTiBt
b2RlICovDQogKwkJaWYgKHZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9B
REhPQyB8fCBic3NfY29uZi0+YXNzb2MpIHsNCiArCQkJbWVtY3B5KGN0eC0+
c3RhZ2luZy5ic3NpZF9hZGRyLA0KICsJCQkgICAgICAgYnNzX2NvbmYtPmJz
c2lkLCBFVEhfQUxFTik7DQogKw0KICsJCQkvKiBjdXJyZW50bHkgbmVlZGVk
IGluIGEgZmV3IHBsYWNlcyAqLw0KICsJCQltZW1jcHkocHJpdi0+YnNzaWQs
IGJzc19jb25mLT5ic3NpZCwgRVRIX0FMRU4pOw0KICsJCX0gZWxzZSB7DQog
KwkJCWN0eC0+c3RhZ2luZy5maWx0ZXJfZmxhZ3MgJj0NCiArCQkJCX5SWE9O
X0ZJTFRFUl9BU1NPQ19NU0s7DQogKwkJfQ0KICsNCiArCX0NCiArDQogKwkv
Kg0KICsJICogVGhpcyBuZWVkcyB0byBiZSBhZnRlciBzZXR0aW5nIHRoZSBC
U1NJRCBpbiBjYXNlDQogKwkgKiBtYWM4MDIxMSBkZWNpZGVzIHRvIGRvIGJv
dGggY2hhbmdlcyBhdCBvbmNlIGJlY2F1c2UNCiArCSAqIGl0IHdpbGwgaW52
b2tlIHBvc3RfYXNzb2NpYXRlLg0KICsJICovDQogKwlpZiAodmlmLT50eXBl
ID09IE5MODAyMTFfSUZUWVBFX0FESE9DICYmIGNoYW5nZXMgJiBCU1NfQ0hB
TkdFRF9CRUFDT04pDQogKwkJaXdsY29yZV9iZWFjb25fdXBkYXRlKGh3LCB2
aWYpOw0KICsNCiArCWlmIChjaGFuZ2VzICYgQlNTX0NIQU5HRURfRVJQX1BS
RUFNQkxFKSB7DQogKwkJSVdMX0RFQlVHX01BQzgwMjExKHByaXYsICJFUlBf
UFJFQU1CTEUgJWRcbiIsDQogKwkJCQkgICBic3NfY29uZi0+dXNlX3Nob3J0
X3ByZWFtYmxlKTsNCiArCQlpZiAoYnNzX2NvbmYtPnVzZV9zaG9ydF9wcmVh
bWJsZSkNCiArCQkJY3R4LT5zdGFnaW5nLmZsYWdzIHw9IFJYT05fRkxHX1NI
T1JUX1BSRUFNQkxFX01TSzsNCiArCQllbHNlDQogKwkJCWN0eC0+c3RhZ2lu
Zy5mbGFncyAmPSB+UlhPTl9GTEdfU0hPUlRfUFJFQU1CTEVfTVNLOw0KICsJ
fQ0KICsNCiArCWlmIChjaGFuZ2VzICYgQlNTX0NIQU5HRURfRVJQX0NUU19Q
Uk9UKSB7DQogKwkJSVdMX0RFQlVHX01BQzgwMjExKHByaXYsICJFUlBfQ1RT
ICVkXG4iLCBic3NfY29uZi0+dXNlX2N0c19wcm90KTsNCiArCQlpZiAoYnNz
X2NvbmYtPnVzZV9jdHNfcHJvdCAmJiAocHJpdi0+YmFuZCAhPSBJRUVFODAy
MTFfQkFORF81R0haKSkNCiArCQkJY3R4LT5zdGFnaW5nLmZsYWdzIHw9IFJY
T05fRkxHX1RHR19QUk9URUNUX01TSzsNCiArCQllbHNlDQogKwkJCWN0eC0+
c3RhZ2luZy5mbGFncyAmPSB+UlhPTl9GTEdfVEdHX1BST1RFQ1RfTVNLOw0K
ICsJCWlmIChic3NfY29uZi0+dXNlX2N0c19wcm90KQ0KICsJCQljdHgtPnN0
YWdpbmcuZmxhZ3MgfD0gUlhPTl9GTEdfU0VMRl9DVFNfRU47DQogKwkJZWxz
ZQ0KICsJCQljdHgtPnN0YWdpbmcuZmxhZ3MgJj0gflJYT05fRkxHX1NFTEZf
Q1RTX0VOOw0KICsJfQ0KICsNCiArCWlmIChjaGFuZ2VzICYgQlNTX0NIQU5H
RURfQkFTSUNfUkFURVMpIHsNCiArCQkvKiBYWFggdXNlIHRoaXMgaW5mb3Jt
YXRpb24NCiArCQkgKg0KICsJCSAqIFRvIGRvIHRoYXQsIHJlbW92ZSBjb2Rl
IGZyb20gaXdsX3NldF9yYXRlKCkgYW5kIHB1dCBzb21ldGhpbmcNCiArCQkg
KiBsaWtlIHRoaXMgaGVyZToNCiArCQkgKg0KICsJCWlmIChBLWJhbmQpDQog
KwkJCWN0eC0+c3RhZ2luZy5vZmRtX2Jhc2ljX3JhdGVzID0NCiArCQkJCWJz
c19jb25mLT5iYXNpY19yYXRlczsNCiArCQllbHNlDQogKwkJCWN0eC0+c3Rh
Z2luZy5vZmRtX2Jhc2ljX3JhdGVzID0NCiArCQkJCWJzc19jb25mLT5iYXNp
Y19yYXRlcyA+PiA0Ow0KICsJCQljdHgtPnN0YWdpbmcuY2NrX2Jhc2ljX3Jh
dGVzID0NCiArCQkJCWJzc19jb25mLT5iYXNpY19yYXRlcyAmIDB4RjsNCiAr
CQkgKi8NCiArCX0NCiArDQogKwlpZiAoY2hhbmdlcyAmIEJTU19DSEFOR0VE
X0hUKSB7DQogKwkJaXdsX2h0X2NvbmYocHJpdiwgdmlmKTsNCiArDQogKwkJ
aWYgKHByaXYtPmNmZy0+b3BzLT5oY21kLT5zZXRfcnhvbl9jaGFpbikNCiAr
CQkJcHJpdi0+Y2ZnLT5vcHMtPmhjbWQtPnNldF9yeG9uX2NoYWluKHByaXYs
IGN0eCk7DQogKwl9DQogKw0KICsJaWYgKGNoYW5nZXMgJiBCU1NfQ0hBTkdF
RF9BU1NPQykgew0KICsJCUlXTF9ERUJVR19NQUM4MDIxMShwcml2LCAiQVNT
T0MgJWRcbiIsIGJzc19jb25mLT5hc3NvYyk7DQogKwkJaWYgKGJzc19jb25m
LT5hc3NvYykgew0KICsJCQlwcml2LT50aW1lc3RhbXAgPSBic3NfY29uZi0+
dGltZXN0YW1wOw0KICsNCiArCQkJaXdsX2xlZF9hc3NvY2lhdGUocHJpdik7
DQogKw0KICsJCQlpZiAoIWl3bF9pc19yZmtpbGwocHJpdikpDQogKwkJCQlw
cml2LT5jZmctPm9wcy0+bGVnYWN5LT5wb3N0X2Fzc29jaWF0ZShwcml2KTsN
CiArCQl9IGVsc2UNCiArCQkJaXdsX3NldF9ub19hc3NvYyhwcml2LCB2aWYp
Ow0KICsJfQ0KICsNCiArCWlmIChjaGFuZ2VzICYmIGl3bF9pc19hc3NvY2lh
dGVkX2N0eChjdHgpICYmIGJzc19jb25mLT5haWQpIHsNCiArCQlJV0xfREVC
VUdfTUFDODAyMTEocHJpdiwgIkNoYW5nZXMgKCUjeCkgd2hpbGUgYXNzb2Np
YXRlZFxuIiwNCiArCQkJCSAgIGNoYW5nZXMpOw0KICsJCXJldCA9IGl3bF9z
ZW5kX3J4b25fYXNzb2MocHJpdiwgY3R4KTsNCiArCQlpZiAoIXJldCkgew0K
ICsJCQkvKiBTeW5jIGFjdGl2ZV9yeG9uIHdpdGggbGF0ZXN0IGNoYW5nZS4g
Ki8NCiArCQkJbWVtY3B5KCh2b2lkICopJmN0eC0+YWN0aXZlLA0KICsJCQkJ
JmN0eC0+c3RhZ2luZywNCiArCQkJCXNpemVvZihzdHJ1Y3QgaXdsX3J4b25f
Y21kKSk7DQogKwkJfQ0KICsJfQ0KICsNCiArCWlmIChjaGFuZ2VzICYgQlNT
X0NIQU5HRURfQkVBQ09OX0VOQUJMRUQpIHsNCiArCQlpZiAodmlmLT5ic3Nf
Y29uZi5lbmFibGVfYmVhY29uKSB7DQogKwkJCW1lbWNweShjdHgtPnN0YWdp
bmcuYnNzaWRfYWRkciwNCiArCQkJICAgICAgIGJzc19jb25mLT5ic3NpZCwg
RVRIX0FMRU4pOw0KICsJCQltZW1jcHkocHJpdi0+YnNzaWQsIGJzc19jb25m
LT5ic3NpZCwgRVRIX0FMRU4pOw0KICsJCQlpd2xfbGVkX2Fzc29jaWF0ZShw
cml2KTsNCiArCQkJcHJpdi0+Y2ZnLT5vcHMtPmxlZ2FjeS0+Y29uZmlnX2Fw
KHByaXYpOw0KICsJCX0gZWxzZQ0KICsJCQlpd2xfc2V0X25vX2Fzc29jKHBy
aXYsIHZpZik7DQogKwl9DQogKw0KICsJaWYgKGNoYW5nZXMgJiBCU1NfQ0hB
TkdFRF9JQlNTKSB7DQogKwkJcmV0ID0gcHJpdi0+Y2ZnLT5vcHMtPmxlZ2Fj
eS0+bWFuYWdlX2lic3Nfc3RhdGlvbihwcml2LCB2aWYsDQogKwkJCQkJCQli
c3NfY29uZi0+aWJzc19qb2luZWQpOw0KICsJCWlmIChyZXQpDQogKwkJCUlX
TF9FUlIocHJpdiwgImZhaWxlZCB0byAlcyBJQlNTIHN0YXRpb24gJXBNXG4i
LA0KICsJCQkJYnNzX2NvbmYtPmlic3Nfam9pbmVkID8gImFkZCIgOiAicmVt
b3ZlIiwNCiArCQkJCWJzc19jb25mLT5ic3NpZCk7DQogKwl9DQogKw0KICsJ
bXV0ZXhfdW5sb2NrKCZwcml2LT5tdXRleCk7DQogKw0KICsJSVdMX0RFQlVH
X01BQzgwMjExKHByaXYsICJsZWF2ZVxuIik7DQogK30NCiArRVhQT1JUX1NZ
TUJPTChpd2xfbGVnYWN5X21hY19ic3NfaW5mb19jaGFuZ2VkKTsNCiArDQog
K2lycXJldHVybl90IGl3bF9pc3JfbGVnYWN5KGludCBpcnEsIHZvaWQgKmRh
dGEpDQogK3sNCiArCXN0cnVjdCBpd2xfcHJpdiAqcHJpdiA9IGRhdGE7DQog
Kwl1MzIgaW50YSwgaW50YV9tYXNrOw0KICsJdTMyIGludGFfZmg7DQogKwl1
bnNpZ25lZCBsb25nIGZsYWdzOw0KICsJaWYgKCFwcml2KQ0KICsJCXJldHVy
biBJUlFfTk9ORTsNCiArDQogKwlzcGluX2xvY2tfaXJxc2F2ZSgmcHJpdi0+
bG9jaywgZmxhZ3MpOw0KICsNCiArCS8qIERpc2FibGUgKGJ1dCBkb24ndCBj
bGVhciEpIGludGVycnVwdHMgaGVyZSB0byBhdm9pZA0KICsJICogICAgYmFj
ay10by1iYWNrIElTUnMgYW5kIHNwb3JhZGljIGludGVycnVwdHMgZnJvbSBv
dXIgTklDLg0KICsJICogSWYgd2UgaGF2ZSBzb21ldGhpbmcgdG8gc2Vydmlj
ZSwgdGhlIHRhc2tsZXQgd2lsbCByZS1lbmFibGUgaW50cy4NCiArCSAqIElm
IHdlICpkb24ndCogaGF2ZSBzb21ldGhpbmcsIHdlJ2xsIHJlLWVuYWJsZSBi
ZWZvcmUgbGVhdmluZyBoZXJlLiAqLw0KICsJaW50YV9tYXNrID0gaXdsX3Jl
YWQzMihwcml2LCBDU1JfSU5UX01BU0spOyAgLyoganVzdCBmb3IgZGVidWcg
Ki8NCiArCWl3bF93cml0ZTMyKHByaXYsIENTUl9JTlRfTUFTSywgMHgwMDAw
MDAwMCk7DQogKw0KICsJLyogRGlzY292ZXIgd2hpY2ggaW50ZXJydXB0cyBh
cmUgYWN0aXZlL3BlbmRpbmcgKi8NCiArCWludGEgPSBpd2xfcmVhZDMyKHBy
aXYsIENTUl9JTlQpOw0KICsJaW50YV9maCA9IGl3bF9yZWFkMzIocHJpdiwg
Q1NSX0ZIX0lOVF9TVEFUVVMpOw0KICsNCiArCS8qIElnbm9yZSBpbnRlcnJ1
cHQgaWYgdGhlcmUncyBub3RoaW5nIGluIE5JQyB0byBzZXJ2aWNlLg0KICsJ
ICogVGhpcyBtYXkgYmUgZHVlIHRvIElSUSBzaGFyZWQgd2l0aCBhbm90aGVy
IGRldmljZSwNCiArCSAqIG9yIGR1ZSB0byBzcG9yYWRpYyBpbnRlcnJ1cHRz
IHRocm93biBmcm9tIG91ciBOSUMuICovDQogKwlpZiAoIWludGEgJiYgIWlu
dGFfZmgpIHsNCiArCQlJV0xfREVCVUdfSVNSKHByaXYsDQogKwkJCSJJZ25v
cmUgaW50ZXJydXB0LCBpbnRhID09IDAsIGludGFfZmggPT0gMFxuIik7DQog
KwkJZ290byBub25lOw0KICsJfQ0KICsNCiArCWlmICgoaW50YSA9PSAweEZG
RkZGRkZGKSB8fCAoKGludGEgJiAweEZGRkZGRkYwKSA9PSAweGE1YTVhNWEw
KSkgew0KICsJCS8qIEhhcmR3YXJlIGRpc2FwcGVhcmVkLiBJdCBtaWdodCBo
YXZlIGFscmVhZHkgcmFpc2VkDQogKwkJICogYW4gaW50ZXJydXB0ICovDQog
KwkJSVdMX1dBUk4ocHJpdiwgIkhBUkRXQVJFIEdPTkU/PyBJTlRBID09IDB4
JTA4eFxuIiwgaW50YSk7DQogKwkJZ290byB1bnBsdWdnZWQ7DQogKwl9DQog
Kw0KICsJSVdMX0RFQlVHX0lTUihwcml2LCAiSVNSIGludGEgMHglMDh4LCBl
bmFibGVkIDB4JTA4eCwgZmggMHglMDh4XG4iLA0KICsJCSAgICAgIGludGEs
IGludGFfbWFzaywgaW50YV9maCk7DQogKw0KICsJaW50YSAmPSB+Q1NSX0lO
VF9CSVRfU0NEOw0KICsNCiArCS8qIGl3bF9pcnFfdGFza2xldCgpIHdpbGwg
c2VydmljZSBpbnRlcnJ1cHRzIGFuZCByZS1lbmFibGUgdGhlbSAqLw0KICsJ
aWYgKGxpa2VseShpbnRhIHx8IGludGFfZmgpKQ0KICsJCXRhc2tsZXRfc2No
ZWR1bGUoJnByaXYtPmlycV90YXNrbGV0KTsNCiArDQogK3VucGx1Z2dlZDoN
CiArCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnByaXYtPmxvY2ssIGZsYWdz
KTsNCiArCXJldHVybiBJUlFfSEFORExFRDsNCiArDQogK25vbmU6DQogKwkv
KiByZS1lbmFibGUgaW50ZXJydXB0cyBoZXJlIHNpbmNlIHdlIGRvbid0IGhh
dmUgYW55dGhpbmcgdG8gc2VydmljZS4gKi8NCi0gCS8qIG9ubHkgUmUtZW5h
YmxlIGlmIGRpYWJsZWQgYnkgaXJxICovDQorKwkvKiBvbmx5IFJlLWVuYWJs
ZSBpZiBkaXNhYmxlZCBieSBpcnEgKi8NCiArCWlmICh0ZXN0X2JpdChTVEFU
VVNfSU5UX0VOQUJMRUQsICZwcml2LT5zdGF0dXMpKQ0KICsJCWl3bF9lbmFi
bGVfaW50ZXJydXB0cyhwcml2KTsNCiArCXNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCiArCXJldHVybiBJUlFfTk9ORTsN
CiArfQ0KICtFWFBPUlRfU1lNQk9MKGl3bF9pc3JfbGVnYWN5KTsNCiArDQog
Ky8qDQogKyAqICBpd2xfbGVnYWN5X3R4X2NtZF9wcm90ZWN0aW9uOiBTZXQg
cnRzL2N0cy4gMzk0NSBhbmQgNDk2NSBvbmx5IHNoYXJlIHRoaXMNCiArICog
IGZ1bmN0aW9uLg0KICsgKi8NCiArdm9pZCBpd2xfbGVnYWN5X3R4X2NtZF9w
cm90ZWN0aW9uKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwNCiArCQkJICAgICAg
IHN0cnVjdCBpZWVlODAyMTFfdHhfaW5mbyAqaW5mbywNCiArCQkJICAgICAg
IF9fbGUxNiBmYywgX19sZTMyICp0eF9mbGFncykNCiArew0KICsJaWYgKGlu
Zm8tPmNvbnRyb2wucmF0ZXNbMF0uZmxhZ3MgJiBJRUVFODAyMTFfVFhfUkNf
VVNFX1JUU19DVFMpIHsNCiArCQkqdHhfZmxhZ3MgfD0gVFhfQ01EX0ZMR19S
VFNfTVNLOw0KICsJCSp0eF9mbGFncyAmPSB+VFhfQ01EX0ZMR19DVFNfTVNL
Ow0KICsJCSp0eF9mbGFncyB8PSBUWF9DTURfRkxHX0ZVTExfVFhPUF9QUk9U
X01TSzsNCiArDQogKwkJaWYgKCFpZWVlODAyMTFfaXNfbWdtdChmYykpDQog
KwkJCXJldHVybjsNCiArDQogKwkJc3dpdGNoIChmYyAmIGNwdV90b19sZTE2
KElFRUU4MDIxMV9GQ1RMX1NUWVBFKSkgew0KICsJCWNhc2UgY3B1X3RvX2xl
MTYoSUVFRTgwMjExX1NUWVBFX0FVVEgpOg0KICsJCWNhc2UgY3B1X3RvX2xl
MTYoSUVFRTgwMjExX1NUWVBFX0RFQVVUSCk6DQogKwkJY2FzZSBjcHVfdG9f
bGUxNihJRUVFODAyMTFfU1RZUEVfQVNTT0NfUkVRKToNCiArCQljYXNlIGNw
dV90b19sZTE2KElFRUU4MDIxMV9TVFlQRV9SRUFTU09DX1JFUSk6DQogKwkJ
CSp0eF9mbGFncyAmPSB+VFhfQ01EX0ZMR19SVFNfTVNLOw0KICsJCQkqdHhf
ZmxhZ3MgfD0gVFhfQ01EX0ZMR19DVFNfTVNLOw0KICsJCQlicmVhazsNCiAr
CQl9DQogKwl9IGVsc2UgaWYgKGluZm8tPmNvbnRyb2wucmF0ZXNbMF0uZmxh
Z3MgJg0KICsJCSAgIElFRUU4MDIxMV9UWF9SQ19VU0VfQ1RTX1BST1RFQ1Qp
IHsNCiArCQkqdHhfZmxhZ3MgJj0gflRYX0NNRF9GTEdfUlRTX01TSzsNCiAr
CQkqdHhfZmxhZ3MgfD0gVFhfQ01EX0ZMR19DVFNfTVNLOw0KICsJCSp0eF9m
bGFncyB8PSBUWF9DTURfRkxHX0ZVTExfVFhPUF9QUk9UX01TSzsNCiArCX0N
CiArfQ0KICtFWFBPUlRfU1lNQk9MKGl3bF9sZWdhY3lfdHhfY21kX3Byb3Rl
Y3Rpb24pOw0K

--336203264-1310692202-1294699693=:26685--
