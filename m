Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1K2Ecc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:32:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39176 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1K2Ecb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:32:31 -0500
Message-ID: <4ED4605B.8040306@gmail.com>
Date: Mon, 28 Nov 2011 20:32:27 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
        mad_soft@inbox.ru
Subject: Re: [RFC V5]Trivial: Fix typos in various parts of the kernel, and
 fix some comments.
References: <1322241515-3195-1-git-send-email-justinmattock@gmail.com> <4ED3D95E.2040702@xenotime.net>
In-Reply-To: <4ED3D95E.2040702@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 10:56 AM, Randy Dunlap wrote:
> On 11/25/2011 09:18 AM, Justin P. Mattock wrote:
>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>
>> Note:resend after some changes rev5.
>> The below patch fixes some typos in various parts of the kernel, as well as fixes some comments.
>> Please let me know if I missed anything, and I will try to get it changed and resent.
>
> Mostly looks good to me, with a few exceptions noted below.
>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   arch/arm/plat-omap/include/plat/serial.h           |    2 +-
>>   arch/powerpc/include/asm/io.h                      |    2 +-
>>   arch/powerpc/include/asm/keylargo.h                |    2 +-
>>   arch/powerpc/mm/numa.c                             |    2 +-
>>   arch/sparc/kernel/smp_64.c                         |    2 +-
>>   drivers/acpi/acpica/hwxface.c                      |    2 +-
>>   drivers/block/xen-blkback/xenbus.c                 |    2 +-
>>   drivers/char/ipmi/ipmi_bt_sm.c                     |    2 +-
>>   drivers/edac/ppc4xx_edac.c                         |    2 +-
>>   drivers/media/video/zoran/zoran_driver.c           |    2 +-
>>   drivers/message/fusion/lsi/mpi_ioc.h               |    2 +-
>>   drivers/net/irda/nsc-ircc.c                        |    2 +-
>>   drivers/net/irda/via-ircc.c                        |    4 ++--
>>   drivers/net/irda/w83977af_ir.c                     |    2 +-
>>   drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
>>   drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |    4 ++--
>>   drivers/parport/parport_mfc3.c                     |    2 +-
>>   drivers/scsi/aic7xxx/aicasm/aicasm.c               |    2 +-
>>   drivers/scsi/ips.c                                 |    2 +-
>>   drivers/scsi/qla4xxx/ql4_fw.h                      |    2 +-
>>   drivers/scsi/vmw_pvscsi.c                          |    2 +-
>>   .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
>>   drivers/staging/cxt1e1/libsbew.h                   |    2 +-
>>   drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 ++--
>>   drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    2 +-
>>   drivers/staging/iio/industrialio-trigger.c         |    2 +-
>>   drivers/staging/sep/sep_driver.c                   |    2 +-
>>   drivers/staging/tidspbridge/Kconfig                |    2 +-
>>   drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 +-
>>   drivers/usb/host/hwa-hc.c                          |    2 +-
>>   drivers/usb/host/imx21-hcd.c                       |    2 +-
>>   drivers/usb/otg/fsl_otg.c                          |    2 +-
>>   drivers/uwb/i1480/dfu/usb.c                        |    2 +-
>>   fs/btrfs/inode.c                                   |    2 +-
>>   fs/ext3/inode.c                                    |    2 +-
>>   fs/ext4/inode.c                                    |    2 +-
>>   fs/nfsd/nfs4state.c                                |    2 +-
>>   fs/ocfs2/file.c                                    |    2 +-
>>   fs/xfs/xfs_file.c                                  |    6 +++---
>>   fs/xfs/xfs_log_cil.c                               |    2 +-
>>   include/drm/drmP.h                                 |    2 +-
>>   include/linux/wanrouter.h                          |    2 +-
>>   include/net/mac80211.h                             |    2 +-
>>   net/ipv4/ip_fragment.c                             |    2 +-
>>   net/mac80211/work.c                                |    2 +-
>>   net/sctp/endpointola.c                             |    2 +-
>>   46 files changed, 51 insertions(+), 51 deletions(-)
>
>
>> diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
>> index 45698d5..2fd3645 100644
>> --- a/arch/powerpc/include/asm/io.h
>> +++ b/arch/powerpc/include/asm/io.h
>> @@ -394,7 +394,7 @@ __do_out_asm(_rec_outl, "stwbrx")
>>   #endif /* CONFIG_PPC32 */
>>
>>   /* The "__do_*" operations below provide the actual "base" implementation
>> - * for each of the defined acccessor. Some of them use the out_* functions
>> + * for each of the defined accessor. Some of them use the out_* functions
>
>                                accessors.
>
>>    * directly, some of them still use EEH, though we might change that in the
>>    * future. Those macros below provide the necessary argument swapping and
>>    * handling of the IO base for PIO.
>> diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
>> index d4d05d2..c624403 100644
>> --- a/drivers/media/video/zoran/zoran_driver.c
>> +++ b/drivers/media/video/zoran/zoran_driver.c
>> @@ -1550,7 +1550,7 @@ static int zoran_enum_fmt(struct zoran *zr, struct v4l2_fmtdesc *fmt, int flag)
>>   		if (zoran_formats[i].flags&  flag&&  num++ == fmt->index) {
>>   			strncpy(fmt->description, zoran_formats[i].name,
>>   				sizeof(fmt->description) - 1);
>> -			/* fmt struct pre-zeroed, so adding '\0' not neeed */
>> +			/* fmt struct pre-zeroed, so adding '\0' not need */
>
> 			not needed */
>
>>   			fmt->pixelformat = zoran_formats[i].fourcc;
>>   			if (zoran_formats[i].flags&  ZORAN_FORMAT_COMPRESSED)
>>   				fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
>> diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
>> index 2ee18cf..8936bfa 100644
>> --- a/drivers/usb/host/imx21-hcd.c
>> +++ b/drivers/usb/host/imx21-hcd.c
>> @@ -473,7 +473,7 @@ static void free_epdmem(struct imx21 *imx21, struct usb_host_endpoint *ep)
>>   /* End handling 				*/
>>   /* ===========================================	*/
>>
>> -/* Endpoint now idle - release it's ETD(s) or asssign to queued request */
>> +/* Endpoint now idle - release it's ETD(s) or assign to queued request */
>
>                                    its
>
>>   static void ep_idle(struct imx21 *imx21, struct ep_priv *ep_priv)
>>   {
>>   	int i;
>
>
> thanks.
>

Cool Thanks for having a look! I went and did the changes, and resent
if I missed any let me know.

Thanks!

Justin P. Mattock
