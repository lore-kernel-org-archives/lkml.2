Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab0JUUwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:52:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50520 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab0JUUwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JZQjYOo5NJnc82THkHDshn/jkq+GaRUAy1ezjsvtAekKxWQw+wcIyQkYwFW7VkgajY
         QlPtLY0u+FFD2XTtxgv5Pn03XSOMH2fBFG/1YMWJHXWWo74Lt5RIplMNWGC9Q79n68o7
         PdZGc5heiuPlDoRJbcY2YJEG92w8WA+dL6A4o=
MIME-Version: 1.0
In-Reply-To: <20101021075401.GC22100@n2100.arm.linux.org.uk>
References: <AANLkTim+vj_OAd22TdThuC-HSqUiDjguOHQWjyqFaq6N@mail.gmail.com>
	<AANLkTi=Cpq2_vV2RGcoQhrqk8xpL59AvLFPzfvTBk5Xa@mail.gmail.com>
	<4CBF8BDB.7090907@gmail.com>
	<20101021075401.GC22100@n2100.arm.linux.org.uk>
Date: Thu, 21 Oct 2010 22:52:54 +0200
Message-ID: <AANLkTikYtxiT+R3eb0N5U1hoDvaP=oevjWjUuAJ453p=@mail.gmail.com>
Subject: Re: [RFC] Removal of dead code from arch/arm/*
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/21 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Thu, Oct 21, 2010 at 02:39:55AM +0200, N.P.S. wrote:
>> diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
>> index 38c261f..fd30b75 100644
>> --- a/arch/arm/kernel/time.c
>> +++ b/arch/arm/kernel/time.c
>> @@ -37,13 +37,9 @@
>>   */
>>  struct sys_timer *system_timer;
>>
>> -#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
>> +#if defined(CONFIG_RTC_DRV_CMOS)
>>  /* this needs a better home */
>>  DEFINE_SPINLOCK(rtc_lock);
>> -
>> -#ifdef CONFIG_RTC_DRV_CMOS_MODULE
>> -EXPORT_SYMBOL(rtc_lock);
>> -#endif
>>  #endif    /* pc-style 'CMOS' RTC support */
>>
>>  /* change this if you have some constant time drift */
>
> This is wrong, and will break the build if rtc-cmos is built as a module.
>

Ok, I dropped this patch. Recreated tree can be found here
git pull git://github.com/napohybelskurwysynom2010/Linux-2.6-nps.git rodc2

I build tested it. Now should I send every patch for review to
developers? Could you pull this tree to arm-next (2.6.38)?

Regards,
ZL

-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
