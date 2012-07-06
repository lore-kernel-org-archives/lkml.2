Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab2GFIAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:00:45 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:61001 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750836Ab2GFIAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:00:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgNAHGa9k9bdWOb/2dsb2JhbABFrnsiiBuBB4IYAQEEAScLAQUdIwEFCwshFg8JAwIBAgFFBg0BBwEBiAIJukCRXwOVN5ADgmE
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="926704466"
Message-ID: <4FF69B29.3070703@igalia.com>
Date: Fri, 06 Jul 2012 10:00:41 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] Staging: xgifb: Comment cleaning.
References: <cover.1341498465.git.magomez@igalia.com> <c43dc4d9658a520bc62592d51ec9b7b2a3d81fd7.1341498465.git.magomez@igalia.com> <20120705172421.GA4519@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20120705172421.GA4519@blackmetal.musicnaut.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Some minor comments below:
>
>> -/*
>> - * XG20, XG21, XG40, XG42 frame buffer device
>> - * for Linux kernels  2.5.x, 2.6.x
>> - * Base on TW's sis fbdev code.
>
> A lot of code was copy-pasted from Thomas Winischhofer's sisfb driver,
> I'm not sure if it's OK to remove the credit...?

You're right. I'll keep the credit.

>> -		/* TW: We can't switch off CRT1 on LVDS/Chrontel
>> +		/* We can't switch off CRT1 on LVDS/Chrontel
>>   		 * in 8bpp Modes */
>>   		if ((xgifb_info->hasVB == HASVB_LVDS) ||
>>   		    (xgifb_info->hasVB == HASVB_LVDS_CHRONTEL)) {
>>   			doit = 0;
>>   		}
>> -		/* TW: We can't switch off CRT1 on 301B-DH
>> +		/* We can't switch off CRT1 on 301B-DH
>>                 * in 8bpp Modes if using LCD */
>
> These could be also fixed according to multiline comment style at the
> same go.

Written down for the next version ;)

>> diff --git a/drivers/staging/xgifb/vb_init.h b/drivers/staging/xgifb/vb_init.h
>> index a27b4fe..be5589c 100644
>> --- a/drivers/staging/xgifb/vb_init.h
>> +++ b/drivers/staging/xgifb/vb_init.h
>> @@ -3,4 +3,3 @@
>>   extern unsigned char XGIInitNew(struct pci_dev *pdev);
>>   extern struct XGI21_LVDSCapStruct  XGI21_LCDCapList[13];
>>   #endif
>> -
> [...]
>> diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
>> index 9161de1..ff40247 100644
>> --- a/drivers/staging/xgifb/vb_util.h
>> +++ b/drivers/staging/xgifb/vb_util.h
>> @@ -6,4 +6,3 @@ extern void xgifb_reg_or(unsigned long, u8, unsigned);
>>   extern void xgifb_reg_and(unsigned long, u8, unsigned);
>>   extern void xgifb_reg_and_or(unsigned long, u8, unsigned, unsigned);
>>   #endif
>> -
>
> These changes are not really "comment cleaning".

Mmmm no they aren't... seems I committed them by mistake while I was 
berserker cleaning XD... I'll remove them.

-- 
Miguel Gómez
Igalia - http://www.igalia.com


