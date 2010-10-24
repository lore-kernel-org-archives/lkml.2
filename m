Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab0JXRCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 13:02:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49881 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602Ab0JXRCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 13:02:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010241618480.8736@localhost6.localdomain6>
References: <1287849986-5936-1-git-send-email-sez@debian.org> <alpine.LFD.2.00.1010241618480.8736@localhost6.localdomain6>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sun, 24 Oct 2010 13:01:39 -0400
Message-ID: <AANLkTin2-h3+ts2JuZ4rxLSppr3Lqh1VCoi3sRQEHoaB@mail.gmail.com>
Subject: Re: [PATCH] time: jiffies.c: fix typos in comment
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Serafeim Zanikolas <sez@debian.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 10:22, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 23 Oct 2010, Serafeim Zanikolas wrote:
>> diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
>> index 5404a84..12ba9a7 100644
>> --- a/kernel/time/jiffies.c
>> +++ b/kernel/time/jiffies.c
>> @@ -30,8 +30,8 @@
>>   * the timer interrupt frequency HZ and it suffers
>>   * inaccuracies caused by missed or lost timer
>>   * interrupts and the inability for the timer
>> - * interrupt hardware to accuratly tick at the
>> - * requested HZ value. It is also not reccomended
>> + * interrupt hardware to accurately tick at the
>> + * requested HZ value. It is also not recommended
>>   * for "tick-less" systems.
>
> You are not only correcting a typo. You are changing the sense of the
> comment, unfortunately in the wrong way.
>
> Why wouldn't it be recommended that the interrupt hardware ticks at
> the requested HZ value ?
>
> The inability of it to tick accurately at the requested HZ value is
> one of the causes which make jiffies clocksource inaccurate. And that
> what the comment says.

Thomas,

Please reread the patch again, I think it does exactly what he said it
did.  Specifically, the old text is:
>>   * the timer interrupt frequency HZ and it suffers
>>   * inaccuracies caused by missed or lost timer
>>   * interrupts and the inability for the timer
>>   * interrupt hardware to accuratly tick at the
>>   * requested HZ value. It is also not reccomended
>>   * for "tick-less" systems.

While the new text is:
>>   * the timer interrupt frequency HZ and it suffers
>>   * inaccuracies caused by missed or lost timer
>>   * interrupts and the inability for the timer
>>   * interrupt hardware to accurately tick at the
>>   * requested HZ value. It is also not recommended
>>   * for "tick-less" systems.

I misread it the first time myself, mentally combining the second line
of the old text with the new text; what you probably saw was:

>> - * requested HZ value. It is also not reccomended
>> + * interrupt hardware to accurately tick at the
>> + * requested HZ value.

Cheers,
Kyle Moffett
