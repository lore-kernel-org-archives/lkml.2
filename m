Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab2EHDuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:50:04 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37386 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758191Ab2EHDuD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:50:03 -0400
MIME-Version: 1.0
In-Reply-To: <87r4uvwnpi.fsf@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<1335462041-4949-5-git-send-email-j-keerthy@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1AA2@DBDE01.ent.ti.com>
	<CAJ6a13ZSWSa_RpGB9NxtfyChUba9NGivGogpsfyk7oT9pNayjg@mail.gmail.com>
	<87d36fzhkm.fsf@ti.com>
	<87r4uvwnpi.fsf@ti.com>
Date: Tue, 8 May 2012 09:14:16 +0530
Message-ID: <CAJ6a13ZC6CYG+EtOZeBsCF1Fkz8oZWSzX3T1hNPf-OCOf0oOMw@mail.gmail.com>
Subject: Re: [PATCH V3 04/10] ARM: OMAP3: hwmod: rename the smartreflex entries
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 5:25 AM, Kevin Hilman <khilman@ti.com> wrote:
> Kevin Hilman <khilman@ti.com> writes:
>
>> "J, KEERTHY" <j-keerthy@ti.com> writes:
>
> [...]
>
>>>>> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
>>>>> index 2edd1e2..d859277 100644
>>>>> --- a/arch/arm/mach-omap2/smartreflex.c
>>>>> +++ b/arch/arm/mach-omap2/smartreflex.c
>>>>> @@ -183,7 +183,7 @@ static void sr_set_regfields(struct omap_sr *sr)
>>>>>               sr->err_weight = OMAP3430_SR_ERRWEIGHT;
>>>>>               sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
>>>>>               sr->accum_data = OMAP3430_SR_ACCUMDATA;
>>>>> -             if (!(strcmp(sr->name, "sr1"))) {
>>>>> +             if (!(strcmp(sr->name, "smartreflex_mpu_iva"))) {
>>>>
>>>> What if voltage rail is different for mpu and iva? I have seen some devices
>>>> supports SmartReflex have different voltage rails for mpu and iva.
>>>>
>>>
>>> I get the point. OMAP3 iva and mpu have a common rail. OMAP4 onwards
>>> even we have different rails for mpu and iva. I will enhance the checks here.
>>
>> Rather than enhancing the checks, this SoC specific data should probably
>> just be made part of the SoC specific hwmod dev_attr.
>
> That being said, this is an additional feature we can add after this
> driver is moved.
>
> I would like this series to concentrate on the cleanups necessary to
> move to drivers/*, then additional features to support other SoCs can be
> added on top.
>
> Keerthy, please prepare a patch to generalize this to other SoCs by
> using dev_attr for this SoC specific data.   We can add it after this
> series is merged upstream.
Kevin,

Ok. I will do that.

>
> Thanks,
>
> Kevin



-- 
Regards and Thanks,
Keerthy
