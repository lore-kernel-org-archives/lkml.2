Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2GFICm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:02:42 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:29884 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889Ab2GFICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:02:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwNAHGa9k9bdWOb/2dsb2JhbABFhWSpFyKIG4EHghgBAQQBIw8BBR0jAQULCxoCBRYLAgIJAwIBAgFFBg0BBwEBiAIJpy+TEYEgjy2BEgOVN5ADgmE
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="926705032"
Message-ID: <4FF69B9B.3060307@igalia.com>
Date: Fri, 06 Jul 2012 10:02:35 +0200
From: =?UTF-8?B?TWlndWVsIEfDs21leg==?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] Staging: xgifb: Comment cleaning.
References: <cover.1341498465.git.magomez@igalia.com>  <c43dc4d9658a520bc62592d51ec9b7b2a3d81fd7.1341498465.git.magomez@igalia.com> <1341509701.21263.7.camel@joe2Laptop>
In-Reply-To: <1341509701.21263.7.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
> []
>> @@ -1,9 +1,3 @@
>> -/*
>> - * XG20, XG21, XG40, XG42 frame buffer device
>> - * for Linux kernels  2.5.x, 2.6.x
>> - * Base on TW's sis fbdev code.
>> - */
>
> Maybe the comment removal is a bit aggressive.
> Perhaps two of these are relevant comments.
>
>> diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
> []
>> @@ -79,7 +79,4 @@ struct xgi_hw_device_info {
>>   	unsigned long ulCRT2LCDType; /* defined in the data structure type */
>>   };
>>
>> -/* Additional IOCTL for communication xgifb <> X driver        */
>> -/* If changing this, xgifb.h must also be changed (for xgifb) */
>>   #endif
>> -
>
> Maybe this too.

Yes, true, Point taken :)

>  From a quick glance, the rest of the patches look like
> nice cleanups.
>
> btw: most kernel code uses logical line continuations
> at the end of the line not at the beginning of the next
> line.
>
> ie:
> 	if (foo &&
> 	    bar)
> not
> 	if (foo
> 	    && bar)

Thanks for the tip! I wasn't really sure about the preferred way to do it.

Regards!

-- 
Miguel Gómez
Igalia - http://www.igalia.com


