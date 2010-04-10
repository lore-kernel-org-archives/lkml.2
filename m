Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab0DJSJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 14:09:37 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:45478 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0DJSJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 14:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rhOqI6WlPplsgdkaOpOcHdTg6Fyh92v1Ac5pe0/FN1OqpcYFmSFllCvs//V/twaJNU
         SCvZ7kVwkgm4XaI/xh5/f2EPWUromcUa1vsheiSb0gZbmgwyyaB3sMNRkAPFcIlgdmIW
         vRv9kwfsbtEA+zSjxMEAPUft78J3G07dkEccM=
MIME-Version: 1.0
In-Reply-To: <20100315053233.GA11552@elf.ucw.cz>
References: <1268623742-10872-1-git-send-email-chihau@gmail.com>
	 <20100315053233.GA11552@elf.ucw.cz>
Date: Sat, 10 Apr 2010 14:09:33 -0400
Message-ID: <g2of5ca57691004101109k1e8c37a9mc65b07e22eda9cd5@mail.gmail.com>
Subject: Re: [PATCH] Staging: dream: smd: smd_private: fix code style issues
From: Chihau Chau <chihau@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, What about this patch? Greg?

2010/3/15 Pavel Machek <pavel@ucw.cz>:
> On Mon 2010-03-15 00:29:02, Chihau Chau wrote:
>> From: Chihau Chau <chihau@gmail.com>
>>
>> This put open braces '{' following structs on the same line.
>>
>> Signed-off-by: Chihau Chau <chihau@gmail.com>
>
> ACK.
>
>> ---
>>  drivers/staging/dream/smd/smd_private.h |   21 +++++++--------------
>>  1 files changed, 7 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/staging/dream/smd/smd_private.h b/drivers/staging/dream/smd/smd_private.h
>> index c0eb3de..1b2e1c8 100644
>> --- a/drivers/staging/dream/smd/smd_private.h
>> +++ b/drivers/staging/dream/smd/smd_private.h
>> @@ -16,24 +16,21 @@
>>  #ifndef _ARCH_ARM_MACH_MSM_MSM_SMD_PRIVATE_H_
>>  #define _ARCH_ARM_MACH_MSM_MSM_SMD_PRIVATE_H_
>>
>> -struct smem_heap_info
>> -{
>> +struct smem_heap_info {
>>       unsigned initialized;
>>       unsigned free_offset;
>>       unsigned heap_remaining;
>>       unsigned reserved;
>>  };
>>
>> -struct smem_heap_entry
>> -{
>> +struct smem_heap_entry {
>>       unsigned allocated;
>>       unsigned offset;
>>       unsigned size;
>>       unsigned reserved;
>>  };
>>
>> -struct smem_proc_comm
>> -{
>> +struct smem_proc_comm {
>>       unsigned command;
>>       unsigned status;
>>       unsigned data1;
>> @@ -49,22 +46,19 @@ struct smem_proc_comm
>>  #define VERSION_APPS      8
>>  #define VERSION_MODEM     9
>>
>> -struct smem_shared
>> -{
>> +struct smem_shared {
>>       struct smem_proc_comm proc_comm[4];
>>       unsigned version[32];
>>       struct smem_heap_info heap_info;
>>       struct smem_heap_entry heap_toc[128];
>>  };
>>
>> -struct smsm_shared
>> -{
>> +struct smsm_shared {
>>       unsigned host;
>>       unsigned state;
>>  };
>>
>> -struct smsm_interrupt_info
>> -{
>> +struct smsm_interrupt_info {
>>       uint32_t aArm_en_mask;
>>       uint32_t aArm_interrupts_pending;
>>       uint32_t aArm_wakeup_reason;
>> @@ -108,8 +102,7 @@ void smsm_print_sleep_info(void);
>>
>>  #define SMEM_NUM_SMD_CHANNELS        64
>>
>> -typedef enum
>> -{
>> +typedef enum {
>>       /* fixed items */
>>       SMEM_PROC_COMM = 0,
>>       SMEM_HEAP_INFO,
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Chihau Chau
