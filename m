Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab2JDNxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:53:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42759 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933108Ab2JDNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:53:47 -0400
MIME-Version: 1.0
In-Reply-To: <506D3704.4060102@ti.com>
References: <1349246100-7477-1-git-send-email-prabhakar.lad@ti.com>
 <506C158D.4000906@ti.com> <CA+V-a8uFNXvb7bPv0dLKeSeNzZ9C3rvrXCNSWy+8HgiumR9sEw@mail.gmail.com>
 <506D3704.4060102@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 4 Oct 2012 19:23:26 +0530
Message-ID: <CA+V-a8uqQhpe+9Q_A_ojR1MahHLnbKpOEBdg9Vz3Gq8YQbHyjg@mail.gmail.com>
Subject: Re: [PATCH] ARM: davinci: dm644x: fix out range signal for ED
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sekhar

On Thu, Oct 4, 2012 at 12:43 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 10/4/2012 10:22 AM, Prabhakar Lad wrote:
>> Hi Sekhar,
>>
>> On Wed, Oct 3, 2012 at 4:08 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>>> On 10/3/2012 12:05 PM, Prabhakar wrote:
>>>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>>>
>>>> while testing display on dm644x, for ED out-range signals
>>>> was observed. This patch fixes appropriate clock setting
>>>> for ED.
>>>
>>> Can you please clarify what you mean by "out range signal"? Are there
>>> any user visible artifacts on the display? What was the clock being
>>> provided earlier and what is the value after this patch?
>>>
>>> Also, is the issue severe enough that this patch should be applied to
>>> stable tree as well?
>>>
>> Ideally a clock of 54Mhz is required for  enhanced definition to
>> work, which it was actually set to but while testing I noticed
>> out-of-range signal. The out-of-range signal is often caused
>> when the field rate is above the rate that the television will handle.
>> When this is the case the TV or monitor displays "Out-Of-Range Signal".
>>
>> Reducing the clock fixed it. now the clock is set to 27Mhz.
>
> So, is the requirement for ED 54MHz or lower? Still trying to explain
> myself how 27MHz is working where a 54MHz is required. I guess there is
> also a lower limit on what the frequency should be?
>
Ideally its 54Mhz, but I see in the datasheet for AD7342/3 [1] it can also
work at 27Mhz too.

Regards,
--Prabhakar

[1] http://www.analog.com/static/imported-files/data_sheets/ADV7342_7343.pdf

> Sorry I am not familiar will all the video concepts, hence the questions.
>
> Thanks,
> Sekhar
