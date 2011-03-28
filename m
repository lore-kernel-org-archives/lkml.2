Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1C1QaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:01 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37936 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1C1Q37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mATemqB2W5moWNvvTQTvRSz3uI6xFCe/EH/fG/YbYUXRyZnsu/peJzPLNNs3g54NJR
         iIoOiIIviGblndDorM3tmAgCZgtXMeBtx/OiW+EYaQ6ellQ+aysCVcWHyuOsFBqQJEph
         Fvz6RN0/iO10k6qs17onnq75q7LGdyXQRmK3U=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/25] Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:23 -0700
Message-Id: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Note: Not sure if somebody has already sent a patch that does this or not..
(if so then cheers, if not then take this if you would like..
(either way its good practice)).

Using a cleanup script I was able to see that version.h is no longer
in the kernel..  The patch set below removes version.h since it is no longer
in the kernel, and is no longer needed as an include <linux/version.h>
Please let me know when you have the time if this is good, or not..

 arch/arm/include/asm/stackprotector.h              |    1 -
 arch/arm/mach-bcmring/irq.c                        |    1 -
 arch/arm/mach-bcmring/timer.c                      |    1 -
 arch/mips/include/asm/mach-powertv/dma-coherence.h |    1 -
 arch/powerpc/kernel/vdso32/note.S                  |    1 -
 arch/s390/kernel/vdso32/note.S                     |    1 -
 arch/s390/kernel/vdso64/note.S                     |    1 -
 arch/sh/kernel/vsyscall/vsyscall-note.S            |    1 -
 arch/sparc/kernel/head_32.S                        |    1 -
 arch/sparc/kernel/head_64.S                        |    1 -
 arch/x86/mm/mmio-mod.c                             |    1 -
 arch/x86/vdso/vdso-note.S                          |    1 -
 arch/x86/vdso/vdso32/note.S                        |    1 -
 drivers/block/drbd/drbd_int.h                      |    1 -
 drivers/input/keyboard/adp5588-keys.c              |    1 -
 drivers/input/misc/bfin_rotary.c                   |    1 -
 drivers/input/mouse/pxa930_trkball.c               |    1 -
 drivers/input/mouse/sentelic.c                     |    1 -
 drivers/media/dvb/siano/smscoreapi.h               |    1 -
 drivers/media/radio/radio-cadet.c                  |    1 -
 drivers/media/radio/radio-sf16fmi.c                |    1 -
 drivers/media/radio/radio-timb.c                   |    1 -
 drivers/media/radio/si470x/radio-si470x.h          |    1 -
 drivers/media/radio/wl128x/fmdrv.h                 |    1 -
 drivers/media/video/arv.c                          |    1 -
 drivers/media/video/au0828/au0828-video.c          |    1 -
 drivers/media/video/bt8xx/bttvp.h                  |    1 -
 drivers/media/video/bw-qcam.c                      |    1 -
 drivers/media/video/c-qcam.c                       |    1 -
 drivers/media/video/cpia2/cpia2.h                  |    1 -
 drivers/media/video/cpia2/cpia2_v4l.c              |    3 ---
 drivers/media/video/cx18/cx18-driver.h             |    1 -
 drivers/media/video/cx231xx/cx231xx-video.c        |    1 -
 drivers/media/video/cx23885/altera-ci.c            |    1 -
 drivers/media/video/cx23885/cx23885.h              |    1 -
 drivers/media/video/cx88/cx88.h                    |    1 -
 drivers/media/video/davinci/vpif_capture.c         |    1 -
 drivers/media/video/davinci/vpif_capture.h         |    1 -
 drivers/media/video/davinci/vpif_display.c         |    1 -
 drivers/media/video/davinci/vpif_display.h         |    1 -
 drivers/media/video/em28xx/em28xx-video.c          |    1 -
 drivers/media/video/et61x251/et61x251.h            |    1 -
 drivers/media/video/fsl-viu.c                      |    1 -
 drivers/media/video/gspca/gl860/gl860.h            |    1 -
 drivers/media/video/gspca/gspca.c                  |    1 -
 drivers/media/video/hdpvr/hdpvr-video.c            |    1 -
 drivers/media/video/ivtv/ivtv-driver.h             |    1 -
 drivers/media/video/mem2mem_testdev.c              |    1 -
 drivers/media/video/mx1_camera.c                   |    1 -
 drivers/media/video/mx2_camera.c                   |    1 -
 drivers/media/video/mx3_camera.c                   |    1 -
 drivers/media/video/omap1_camera.c                 |    1 -
 drivers/media/video/omap24xxcam.c                  |    1 -
 drivers/media/video/omap3isp/ispvideo.h            |    1 -
 drivers/media/video/pms.c                          |    1 -
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    1 -
 drivers/media/video/pwc/pwc-ioctl.h                |    1 -
 drivers/media/video/pwc/pwc.h                      |    1 -
 drivers/media/video/pxa_camera.c                   |    1 -
 drivers/media/video/s2255drv.c                     |    1 -
 drivers/media/video/s5p-fimc/fimc-capture.c        |    1 -
 drivers/media/video/s5p-fimc/fimc-core.c           |    1 -
 drivers/media/video/saa7134/saa7134.h              |    1 -
 drivers/media/video/saa7164/saa7164.h              |    1 -
 drivers/media/video/sh_mobile_ceu_camera.c         |    1 -
 drivers/media/video/sh_vou.c                       |    1 -
 drivers/media/video/sn9c102/sn9c102.h              |    1 -
 drivers/media/video/timblogiw.c                    |    1 -
 drivers/media/video/tlg2300/pd-common.h            |    1 -
 drivers/media/video/tlg2300/pd-radio.c             |    1 -
 drivers/media/video/usbvision/usbvision-video.c    |    1 -
 drivers/media/video/uvc/uvc_v4l2.c                 |    1 -
 drivers/media/video/vino.c                         |    1 -
 drivers/media/video/vivi.c                         |    1 -
 drivers/media/video/w9966.c                        |    1 -
 drivers/media/video/zoran/zoran_driver.c           |    1 -
 drivers/media/video/zr364xx.c                      |    1 -
 drivers/net/atl1c/atl1c.h                          |    1 -
 drivers/net/atl1e/atl1e.h                          |    1 -
 drivers/net/benet/be.h                             |    1 -
 drivers/net/bna/cna.h                              |    1 -
 drivers/net/caif/caif_serial.c                     |    1 -
 drivers/net/caif/caif_shm_u5500.c                  |    1 -
 drivers/net/caif/caif_spi.c                        |    1 -
 drivers/net/caif/caif_spi_slave.c                  |    1 -
 drivers/net/can/c_can/c_can.c                      |    1 -
 drivers/net/can/c_can/c_can_platform.c             |    1 -
 drivers/net/can/softing/softing_main.c             |    1 -
 drivers/net/cxgb4vf/cxgb4vf_main.c                 |    1 -
 drivers/net/cxgb4vf/t4vf_hw.c                      |    1 -
 drivers/net/davinci_emac.c                         |    1 -
 drivers/net/pptp.c                                 |    1 -
 drivers/net/sfc/net_driver.h                       |    1 -
 drivers/net/usb/cdc_ncm.c                          |    1 -
 drivers/net/wan/farsync.c                          |    1 -
 drivers/net/wireless/rtlwifi/wifi.h                |    1 -
 drivers/s390/char/sclp_cpi.c                       |    1 -
 drivers/scsi/aacraid/src.c                         |    1 -
 drivers/scsi/bfa/bfad_drv.h                        |    1 -
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |    1 -
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |    1 -
 drivers/scsi/fcoe/fcoe.c                           |    1 -
 drivers/scsi/gdth.c                                |    1 -
 drivers/scsi/mpt2sas/mpt2sas_base.c                |    1 -
 drivers/scsi/mpt2sas/mpt2sas_config.c              |    1 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c                 |    1 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    1 -
 drivers/scsi/mvsas/mv_sas.h                        |    1 -
 drivers/scsi/pmcraid.c                             |    1 -
 drivers/scsi/pmcraid.h                             |    1 -
 .../staging/ath6kl/os/linux/include/config_linux.h |    2 --
 .../ath6kl/os/linux/include/ieee80211_ioctl.h      |    2 --
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    1 -
 drivers/staging/bcm/headers.h                      |    1 -
 drivers/staging/cx25821/cx25821.h                  |    1 -
 drivers/staging/cxd2099/cxd2099.c                  |    1 -
 drivers/staging/cxt1e1/sbecom_inline_linux.h       |    1 -
 drivers/staging/dt3155v4l/dt3155v4l.c              |    1 -
 drivers/staging/easycap/easycap.h                  |    1 -
 drivers/staging/gma500/psb_bl.c                    |    1 -
 drivers/staging/gma500/psb_drv.h                   |    2 --
 drivers/staging/gma500/psb_fb.h                    |    1 -
 drivers/staging/go7007/go7007-v4l2.c               |    1 -
 drivers/staging/hv/hv_timesource.c                 |    1 -
 drivers/staging/lirc/lirc_ttusbir.c                |    1 -
 drivers/staging/lirc/lirc_zilog.c                  |    1 -
 drivers/staging/msm/ebi2_lcd.c                     |    3 +--
 drivers/staging/msm/msm_fb.c                       |    1 -
 drivers/staging/msm/msm_fb_bl.c                    |    1 -
 drivers/staging/msm/msm_fb_def.h                   |    1 -
 drivers/staging/msm/msm_fb_panel.c                 |    1 -
 drivers/staging/panel/panel.c                      |    1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    1 -
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |    1 -
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |    1 -
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |    1 -
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |    1 -
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |    1 -
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     |    1 -
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.c   |    1 -
 .../rtl8192e/ieee80211/ieee80211_crypt_ccmp.c      |    1 -
 .../rtl8192e/ieee80211/ieee80211_crypt_tkip.c      |    1 -
 .../rtl8192e/ieee80211/ieee80211_crypt_wep.c       |    1 -
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  |    1 -
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |    1 -
 drivers/staging/rtl8192e/r8192E.h                  |    1 -
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    1 -
 .../staging/rtl8192u/ieee80211/ieee80211_crypt.c   |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |    1 -
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    1 -
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    1 -
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    1 -
 drivers/staging/rtl8192u/r8192U.h                  |    1 -
 drivers/staging/rtl8712/osdep_service.h            |    1 -
 drivers/staging/rts_pstor/rtsx.h                   |    1 -
 drivers/staging/solo6x10/solo6x10.h                |    1 -
 drivers/staging/speakup/main.c                     |    1 -
 drivers/staging/speakup/speakup.h                  |    1 -
 .../tidspbridge/include/dspbridge/host_os.h        |    1 -
 drivers/staging/tm6000/tm6000-cards.c              |    1 -
 drivers/staging/tm6000/tm6000-video.c              |    1 -
 drivers/staging/usbip/usbip_common.h               |    1 -
 drivers/staging/wlags49_h2/wl_internal.h           |    1 -
 drivers/staging/wlags49_h2/wl_version.h            |    1 -
 drivers/staging/wlan-ng/prism2sta.c                |    1 -
 drivers/staging/xgifb/XGI_main_26.c                |    1 -
 drivers/staging/xgifb/vb_ext.c                     |    1 -
 drivers/staging/xgifb/vb_init.c                    |    1 -
 drivers/staging/xgifb/vb_setmode.c                 |    1 -
 drivers/target/target_core_alua.c                  |    1 -
 drivers/target/target_core_configfs.c              |    1 -
 drivers/target/target_core_fabric_configfs.c       |    1 -
 drivers/target/target_core_file.c                  |    1 -
 drivers/target/target_core_iblock.c                |    1 -
 drivers/target/target_core_pr.c                    |    1 -
 drivers/target/target_core_pscsi.c                 |    1 -
 drivers/target/target_core_rd.c                    |    1 -
 drivers/target/target_core_stat.c                  |    1 -
 drivers/target/target_core_tmr.c                   |    1 -
 drivers/target/target_core_transport.c             |    1 -
 drivers/target/target_core_ua.c                    |    1 -
 drivers/usb/core/hcd.c                             |    1 -
 drivers/usb/gadget/uvc_v4l2.c                      |    1 -
 drivers/usb/storage/realtek_cr.c                   |    1 -
 drivers/uwb/uwb-internal.h                         |    1 -
 drivers/video/backlight/adp8860_bl.c               |    1 -
 drivers/video/matrox/matroxfb_base.c               |    2 --
 drivers/video/pxa3xx-gcu.c                         |    1 -
 drivers/video/xilinxfb.c                           |    1 -
 fs/btrfs/ctree.h                                   |    1 -
 fs/omfs/file.c                                     |    1 -
 include/linux/ceph/messenger.h                     |    1 -
 include/linux/media.h                              |    1 -
 include/media/pwc-ioctl.h                          |    1 -
 init/version.c                                     |    1 -
 kernel/power/snapshot.c                            |    1 -
 lib/dynamic_debug.c                                |    1 -
 net/caif/caif_dev.c                                |    1 -
 net/caif/chnl_net.c                                |    1 -
 net/ipv4/gre.c                                     |    1 -
 net/netfilter/ipset/ip_set_core.c                  |    1 -
 net/netfilter/xt_set.c                             |    1 -
 sound/i2c/other/tea575x-tuner.c                    |    1 -
 sound/pci/asihpi/asihpi.c                          |    1 -
 sound/soc/codecs/wm8991.c                          |    1 -
 211 files changed, 1 insertions(+), 218 deletions(-)


cheers,

Justin P. Mattock

