Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1IIARz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:17:55 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:60649 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756429Ab1IIARx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:17:53 -0400
Message-ID: <4E68F72F.70305@xenotime.net>
Date: Thu, 08 Sep 2011 10:11:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Richard Purdie <richard.purdie@linuxfoundation.org>
CC: Bryan Wu <bryan.wu@canonical.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Documentation: leds-class: fix a typo
References: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com>	 <1315249786-15387-2-git-send-email-bryan.wu@canonical.com> <1315252366.1243.22.camel@ted>
In-Reply-To: <1315252366.1243.22.camel@ted>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/11 12:52, Richard Purdie wrote:
> On Tue, 2011-09-06 at 03:09 +0800, Bryan Wu wrote:
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> 
> Acked-by: Richard Purdie <rchard.purdie@linuxfoundation.org>

Applied, thanks.

>> ---
>>  Documentation/leds/leds-class.txt |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/leds/leds-class.txt b/Documentation/leds/leds-class.txt
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


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
