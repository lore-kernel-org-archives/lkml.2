Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab1KVRJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:09:24 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:55279 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1KVRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:09:23 -0500
Message-ID: <1321981758.1753.6.camel@x61.thuisdomein>
Subject: Re: [RFC v3]Trivial: Fix typos in various parts of the kernel.
From: Paul Bolle <pebolle@tiscali.nl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 22 Nov 2011 18:09:18 +0100
In-Reply-To: <1321980061-2675-1-git-send-email-justinmattock@gmail.com>
References: <1321980061-2675-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 08:41 -0800, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> I have sent this patch before kernel.org got hacked, but never heard much about this. 
> I did and resend prior to(after a small fix)but then heard nothing(understandable given the situation). 
> 
> Anyway, I have rebased this to the current Mainline and am resending, I have deleted the old . 
> if I have missed anything please let me know, and I will _try_ and fix/resend it out.

Are you sure you want this to be your commit's explanation? Anyway, this
is missing some sort of list of typos this patch tries to fix, which I
suppose might help review.

> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  arch/arm/plat-omap/include/plat/serial.h           |    4 ++--
>  arch/powerpc/include/asm/io.h                      |    2 +-
>  arch/powerpc/include/asm/keylargo.h                |    2 +-
>  arch/powerpc/mm/numa.c                             |    2 +-
>  arch/sparc/kernel/smp_64.c                         |    4 ++--
>  drivers/acpi/acpica/hwxface.c                      |    2 +-
>  drivers/block/xen-blkback/xenbus.c                 |    2 +-
>  drivers/char/ipmi/ipmi_bt_sm.c                     |    2 +-
>  drivers/edac/ppc4xx_edac.c                         |    2 +-
>  drivers/media/video/zoran/zoran_driver.c           |    2 +-
>  drivers/message/fusion/lsi/mpi_ioc.h               |    2 +-
>  drivers/net/irda/nsc-ircc.c                        |    2 +-
>  drivers/net/irda/via-ircc.c                        |    4 ++--
>  drivers/net/irda/w83977af_ir.c                     |    2 +-
>  drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
>  drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |    4 ++--
>  drivers/parport/parport_mfc3.c                     |    2 +-
>  drivers/scsi/aic7xxx/aicasm/aicasm.c               |    2 +-
>  drivers/scsi/ips.c                                 |    2 +-
>  drivers/scsi/qla4xxx/ql4_fw.h                      |    2 +-
>  drivers/scsi/vmw_pvscsi.c                          |    2 +-
>  .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
>  drivers/staging/cxt1e1/libsbew.h                   |    2 +-
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 ++--
>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    2 +-
>  drivers/staging/iio/industrialio-trigger.c         |    2 +-
>  drivers/staging/sep/sep_driver.c                   |    2 +-
>  drivers/staging/tidspbridge/Kconfig                |    2 +-
>  drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 +-
>  drivers/usb/host/hwa-hc.c                          |    2 +-
>  drivers/usb/host/imx21-hcd.c                       |    2 +-
>  drivers/usb/otg/fsl_otg.c                          |    2 +-
>  drivers/uwb/i1480/dfu/usb.c                        |    2 +-
>  fs/btrfs/inode.c                                   |    2 +-
>  fs/ext3/inode.c                                    |    2 +-
>  fs/ext4/inode.c                                    |    2 +-
>  fs/nfsd/nfs4state.c                                |    2 +-
>  fs/ocfs2/file.c                                    |    2 +-
>  fs/xfs/xfs_file.c                                  |    6 +++---
>  fs/xfs/xfs_log_cil.c                               |    2 +-
>  include/drm/drmP.h                                 |    2 +-
>  include/linux/wanrouter.h                          |    2 +-
>  include/net/mac80211.h                             |    2 +-
>  net/ipv4/ip_fragment.c                             |    2 +-
>  net/mac80211/work.c                                |    2 +-
>  net/sctp/endpointola.c                             |    2 +-
>  tools/power/cpupower/debug/i386/intel_gsic.c       |    2 +-
>  47 files changed, 54 insertions(+), 54 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/serial.h b/arch/arm/plat-omap/include/plat/serial.h
> index 1ab9fd6..e229545 100644
> --- a/arch/arm/plat-omap/include/plat/serial.h
> +++ b/arch/arm/plat-omap/include/plat/serial.h
> @@ -2,7 +2,7 @@
>   * arch/arm/plat-omap/include/mach/serial.h
>   *
>   * Copyright (C) 2009 Texas Instruments
> - * Addded OMAP4 support- Santosh Shilimkar <santosh.shilimkar@ti.com>
> + * Added OMAP4 support- Santosh Shilimkar <santosh.shilimkar@ti.com>
>   *
>   * This program is distributed in the hope that it will be useful,
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
> @@ -24,7 +24,7 @@
>   *
>   * 1. Kernel uncompress code cannot overlap OMAP_UART_INFO as the
>   *    uncompress code could then partially overwrite itself
> - * 2. We assume printascii is called at least once before paging_init,
> + * 2. We assume print ascii is called at least once before paging_init,

This is not a typo. How did this get in your patch? 

(I stopped reviewing here.)


Paul Bolle

