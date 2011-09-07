Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1IGS4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:56:16 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:50835 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755539Ab1IGS4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:56:15 -0400
Message-ID: <16442abc758871e205bb13759a3d081d.squirrel@xenotime.net>
In-Reply-To: <1315252366.1243.22.camel@ted>
References: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com>
    <1315249786-15387-2-git-send-email-bryan.wu@canonical.com>
    <1315252366.1243.22.camel@ted>
Date: Wed, 7 Sep 2011 11:56:12 -0700
Subject: Re: [PATCH 2/2] Documentation: leds-class: fix a typo
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Richard Purdie" <richard.purdie@linuxfoundation.org>
Cc: "Bryan Wu" <bryan.wu@canonical.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        "akpm" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, September 5, 2011 12:52 pm, Richard Purdie wrote:
> On Tue, 2011-09-06 at 03:09 +0800, Bryan Wu wrote:
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>
> Acked-by: Richard Purdie <rchard.purdie@linuxfoundation.org>

Who are we expecting to merge this patch?


>> ---
>>  Documentation/leds/leds-class.txt |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/leds/leds-class.txt
>> b/Documentation/leds/leds-class.txt
>> index 4996586..79699c2 100644
>> --- a/Documentation/leds/leds-class.txt
>> +++ b/Documentation/leds/leds-class.txt
>> @@ -61,8 +61,8 @@ Hardware accelerated blink of LEDs
>>  Some LEDs can be programmed to blink without any CPU interaction. To
>>  support this feature, a LED driver can optionally implement the
>>  blink_set() function (see <linux/leds.h>). To set an LED to blinking,
>> -however, it is better to use use the API function led_blink_set(),
>> -as it will check and implement software fallback if necessary.
>> +however, it is better to use the API function led_blink_set(), as it
>> +will check and implement software fallback if necessary.
>>
>>  To turn off blinking again, use the API function led_brightness_set()
>>  as that will not just set the LED brightness but also stop any software
>
>
> --


-- 
~Randy

