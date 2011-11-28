Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1K1Hx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:53:58 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:28118
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab1K1Hx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:53:57 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK9371K1432N98dKzz1202hzz8275ch8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
Message-ID: <4ED33CB2.70703@analog.com>
Date: Mon, 28 Nov 2011 08:48:02 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Haojian Zhuang <haojian.zhuang@gmail.com>
CC: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Richard Purdie <rpurdie@rpsys.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] backlight: convert drivers/video/backlight/* to use module_platform_driver()
References: <1322273963.10633.1.camel@phoenix> <CAN1soZz0jVjEQg_Com=Ge+4KrDFjnnhOK+5oD=+wz1BiuuGSOQ@mail.gmail.com>
In-Reply-To: <CAN1soZz0jVjEQg_Com=Ge+4KrDFjnnhOK+5oD=+wz1BiuuGSOQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2011 03:59 AM, Haojian Zhuang wrote:
> On Sat, Nov 26, 2011 at 10:19 AM, Axel Lin<axel.lin@gmail.com>  wrote:
>> This patch converts the drivers in drivers/video/backlight/* to use the
>> module_platform_driver() macro which makes the code smaller and a bit
>> simpler.
>>
>> Cc: Haojian Zhuang<haojian.zhuang@marvell.com>
>> Cc: H Hartley Sweeten<hsweeten@visionengravers.com>
>> Cc: Mike Rapoport<mike@compulab.co.il>
>> Cc: Richard Purdie<rpurdie@rpsys.net>
>> Cc: Michael Hennerich<michael.hennerich@analog.com>
>> Cc: Mark Brown<broonie@opensource.wolfsonmicro.com>
>> Signed-off-by: Axel Lin<axel.lin@gmail.com>
>> ---
>>   drivers/video/backlight/88pm860x_bl.c        |   12 +-----------
>>   drivers/video/backlight/adp5520_bl.c         |   12 +-----------
>>   drivers/video/backlight/adx_bl.c             |   13 +------------
>>   drivers/video/backlight/da903x_bl.c          |   12 +-----------
>>   drivers/video/backlight/ep93xx_bl.c          |   12 +-----------
>>   drivers/video/backlight/generic_bl.c         |   13 +------------
>>   drivers/video/backlight/jornada720_bl.c      |   13 +------------
>>   drivers/video/backlight/jornada720_lcd.c     |   13 +------------
>>   drivers/video/backlight/max8925_bl.c         |   12 +-----------
>>   drivers/video/backlight/omap1_bl.c           |   13 +------------
>>   drivers/video/backlight/pcf50633-backlight.c |   12 +-----------
>>   drivers/video/backlight/platform_lcd.c       |   13 +------------
>>   drivers/video/backlight/pwm_bl.c             |   12 +-----------
>>   drivers/video/backlight/wm831x_bl.c          |   12 +-----------
>>   14 files changed, 14 insertions(+), 160 deletions(-)
>>
> Acked-by Haojian Zhuang<haojian.zhuang@gmail.com>
>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>

-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


