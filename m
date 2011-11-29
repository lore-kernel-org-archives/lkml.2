Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1K2VVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:21:06 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:40595 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756501Ab1K2VVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:21:02 -0500
Message-ID: <4ED55A78.9060704@xenotime.net>
Date: Tue, 29 Nov 2011 14:19:36 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
        mad_soft@inbox.ru
Subject: Re: [RFC v6]Trivial: Fix typos in various parts of the kernel, and
 fix some comments.
References: <1322541060-26444-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1322541060-26444-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 08:31 PM, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> The below patch fixes some typos in various parts of the kernel, as well as fixes some comments.
> Please let me know if I missed anything, and I will try to get it changed and resent.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: pebolle@tiscali.nl
> Cc: mad_soft@inbox.ru
> Cc: rdunlap@xenotime.net

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  arch/arm/plat-omap/include/plat/serial.h           |    2 +-
>  arch/powerpc/include/asm/io.h                      |    2 +-
>  arch/powerpc/include/asm/keylargo.h                |    2 +-
>  arch/powerpc/mm/numa.c                             |    2 +-
>  arch/sparc/kernel/smp_64.c                         |    2 +-
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
>  46 files changed, 51 insertions(+), 51 deletions(-)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
