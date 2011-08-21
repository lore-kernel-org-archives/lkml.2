Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1HUXz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:55:28 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37875 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab1HUXzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:55:24 -0400
Message-ID: <4E519AE7.6030305@gmail.com>
Date: Mon, 22 Aug 2011 09:55:19 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] backlight: ep93xx_bl: add missing include of linux/module.h
References: <1313937209.13671.3.camel@phoenix> <4E519744.1020707@gmail.com>
In-Reply-To: <4E519744.1020707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/11 09:39, Ryan Mallon wrote:
> On 22/08/11 00:33, Axel Lin wrote:
>> ep93xx_bl.c uses interfaces from linux/module.h,
>> so it should include that file. This patch fixes below build errors.
>
> Thanks,
>
> Acked-by: Ryan Mallon <rmallon@gmail.com>

Retracted. Please see my reply to the ep93xx framebuffer patch.

~Ryan

>
>>    CC [M]  drivers/video/backlight/ep93xx_bl.o
>> drivers/video/backlight/ep93xx_bl.c:138: error: 'THIS_MODULE' 
>> undeclared here (not in a function)
>> drivers/video/backlight/ep93xx_bl.c:158: error: expected declaration 
>> specifiers or '...' before string constant
>> drivers/video/backlight/ep93xx_bl.c:158: warning: data definition has 
>> no type or storage class
>> drivers/video/backlight/ep93xx_bl.c:158: warning: type defaults to 
>> 'int' in declaration of 'MODULE_DESCRIPTION'
>> drivers/video/backlight/ep93xx_bl.c:158: warning: function 
>> declaration isn't a prototype
>> drivers/video/backlight/ep93xx_bl.c:159: error: expected declaration 
>> specifiers or '...' before string constant
>> drivers/video/backlight/ep93xx_bl.c:159: warning: data definition has 
>> no type or storage class
>> drivers/video/backlight/ep93xx_bl.c:159: warning: type defaults to 
>> 'int' in declaration of 'MODULE_AUTHOR'
>> drivers/video/backlight/ep93xx_bl.c:159: warning: function 
>> declaration isn't a prototype
>> drivers/video/backlight/ep93xx_bl.c:160: error: expected declaration 
>> specifiers or '...' before string constant
>> drivers/video/backlight/ep93xx_bl.c:160: warning: data definition has 
>> no type or storage class
>> drivers/video/backlight/ep93xx_bl.c:160: warning: type defaults to 
>> 'int' in declaration of 'MODULE_LICENSE'
>> drivers/video/backlight/ep93xx_bl.c:160: warning: function 
>> declaration isn't a prototype
>> drivers/video/backlight/ep93xx_bl.c:161: error: expected declaration 
>> specifiers or '...' before string constant
>> drivers/video/backlight/ep93xx_bl.c:161: warning: data definition has 
>> no type or storage class
>> drivers/video/backlight/ep93xx_bl.c:161: warning: type defaults to 
>> 'int' in declaration of 'MODULE_ALIAS'
>> drivers/video/backlight/ep93xx_bl.c:161: warning: function 
>> declaration isn't a prototype
>> make[3]: *** [drivers/video/backlight/ep93xx_bl.o] Error 1
>> make[2]: *** [drivers/video/backlight] Error 2
>> make[1]: *** [drivers/video] Error 2
>> make: *** [drivers] Error 2
>>
>> Signed-off-by: Axel Lin<axel.lin@gmail.com>
>> ---
>>   drivers/video/backlight/ep93xx_bl.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/backlight/ep93xx_bl.c 
>> b/drivers/video/backlight/ep93xx_bl.c
>> index 9f1e389..b058291 100644
>> --- a/drivers/video/backlight/ep93xx_bl.c
>> +++ b/drivers/video/backlight/ep93xx_bl.c
>> @@ -11,7 +11,7 @@
>>    * BRIGHT, on the Cirrus EP9307, EP9312, and EP9315 processors.
>>    */
>>
>> -
>> +#include<linux/module.h>
>>   #include<linux/platform_device.h>
>>   #include<linux/io.h>
>>   #include<linux/fb.h>
>

