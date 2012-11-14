Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2KNHNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:13:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35421 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2KNHNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:13:24 -0500
Message-ID: <50A34485.1080803@ti.com>
Date: Wed, 14 Nov 2012 08:13:09 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/3] leds: leds-pwm: Convert to use devm_get_pwm
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com> <1352731270-27534-2-git-send-email-peter.ujfalusi@ti.com> <CAK5ve-JDCSSOKHQG-F1RoDii62=-DiPevaD6SafndYVvOgB6Fw@mail.gmail.com>
In-Reply-To: <CAK5ve-JDCSSOKHQG-F1RoDii62=-DiPevaD6SafndYVvOgB6Fw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 11/14/2012 02:14 AM, Bryan Wu wrote:
>> diff --git a/include/linux/leds_pwm.h b/include/linux/leds_pwm.h
>> index 33a0711..a65e964 100644
>> --- a/include/linux/leds_pwm.h
>> +++ b/include/linux/leds_pwm.h
>> @@ -7,7 +7,7 @@
>>  struct led_pwm {
>>         const char      *name;
>>         const char      *default_trigger;
>> -       unsigned        pwm_id;
>> +       unsigned        pwm_id __deprecated;
> 
> I suggest we remove this later, we can provide patches from this from
> platform data of board file. And I think this patch is good for me to
> merge, will do it soon.

Yes, we can remove it in 3.9. I marked it as deprecated for now to avoid
breakage - if any - in 3.8.

Thank you,
Péter
