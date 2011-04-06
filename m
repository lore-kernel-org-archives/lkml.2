Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab1DFLYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:24:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57153 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab1DFLYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qhPVe+OQhuJMJABNxd6AxyuOaSM/If9Ha4tC09hrH52UMUsCfqg/Aph+EmMbCCCOxt
         v9MBKYb4fiYWJP9uo9JvI38IppiynQxhOvFJsTy5rvDBiXy9W9YPPlMIQA5qwoU+c7UP
         x4tKNLljRmun6MhKh5w0nyBunOdjMQAUYVV90=
Message-ID: <4D9C4E95.4070705@gmail.com>
Date: Wed, 06 Apr 2011 19:29:25 +0800
From: "helight.xu" <helight.xu@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: "Eric.Moore <Eric.Moore@lsi.com>; support <support@lsi.com>;
	DL-MPTFusionLinux <DL-MPTFusionLinux@lsi.com>; linux-scsi" 
	<linux-scsi@vger.kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: =?windows-1252?Q?Re=3A_=5BPATCH=5D_fix_warning=3A_unused?=
 =?windows-1252?Q?_variable_=91log=5Finfo=92_drivers/message/fusion?=
 =?windows-1252?Q?/mptsas=2Ec?=
References: <4D9C4E04.9070205@gmail.com>
In-Reply-To: <4D9C4E04.9070205@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 07:27 PM, helight.xu wrote:
> fix warning: unused variable ‘log_info’ drivers/message/fusion/mptsas.c
>
>
> Signed-off-by: helight <helight@zhwen.org>
> ---
>  drivers/gpu/drm/nouveau/nv50_vm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nv50_vm.c 
> b/drivers/gpu/drm/nouveau/nv50_vm.c
> index 6144156..1f47c75 100644
> --- a/drivers/gpu/drm/nouveau/nv50_vm.c
> +++ b/drivers/gpu/drm/nouveau/nv50_vm.c
> @@ -31,7 +31,6 @@ void
>  nv50_vm_map_pgt(struct nouveau_gpuobj *pgd, u32 pde,
>          struct nouveau_gpuobj *pgt[2])
>  {
> -    struct drm_nouveau_private *dev_priv = pgd->dev->dev_private;
>      u64 phys = 0xdeadcafe00000000ULL;
>      u32 coverage = 0;
>
sorry ,this is the patch


fix warning: unused variable ‘log_info’ drivers/message/fusion/mptsas.c

Signed-off-by: helight <helight@zhwen.org>
---
  drivers/message/fusion/mptsas.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c 
b/drivers/message/fusion/mptsas.c
index 8aefb18..431092b 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5009,13 +5009,13 @@ mptsas_event_process(MPT_ADAPTER *ioc, 
EventNotificationReply_t *reply)
              (ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)) {
              VirtTarget *vtarget = NULL;
              u8        id, channel;
-            u32     log_info = le32_to_cpu(reply->IOCLogInfo);

              id = sas_event_data->TargetID;
              channel = sas_event_data->Bus;

              vtarget = mptsas_find_vtarget(ioc, channel, id);
              if (vtarget) {
+                u32 log_info = le32_to_cpu(reply->IOCLogInfo);
                  devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
                      "LogInfo (0x%x) available for "
                     "INTERNAL_DEVICE_RESET"
-- 
1.6.0.2
