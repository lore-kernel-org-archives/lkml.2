Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2JDHNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:13:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33154 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2JDHNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:13:43 -0400
Message-ID: <506D3704.4060102@ti.com>
Date: Thu, 4 Oct 2012 12:43:08 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [PATCH] ARM: davinci: dm644x: fix out range signal for ED
References: <1349246100-7477-1-git-send-email-prabhakar.lad@ti.com> <506C158D.4000906@ti.com> <CA+V-a8uFNXvb7bPv0dLKeSeNzZ9C3rvrXCNSWy+8HgiumR9sEw@mail.gmail.com>
In-Reply-To: <CA+V-a8uFNXvb7bPv0dLKeSeNzZ9C3rvrXCNSWy+8HgiumR9sEw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/2012 10:22 AM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> On Wed, Oct 3, 2012 at 4:08 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On 10/3/2012 12:05 PM, Prabhakar wrote:
>>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>>
>>> while testing display on dm644x, for ED out-range signals
>>> was observed. This patch fixes appropriate clock setting
>>> for ED.
>>
>> Can you please clarify what you mean by "out range signal"? Are there
>> any user visible artifacts on the display? What was the clock being
>> provided earlier and what is the value after this patch?
>>
>> Also, is the issue severe enough that this patch should be applied to
>> stable tree as well?
>>
> Ideally a clock of 54Mhz is required for  enhanced definition to
> work, which it was actually set to but while testing I noticed
> out-of-range signal. The out-of-range signal is often caused
> when the field rate is above the rate that the television will handle.
> When this is the case the TV or monitor displays "Out-Of-Range Signal".
> 
> Reducing the clock fixed it. now the clock is set to 27Mhz.

So, is the requirement for ED 54MHz or lower? Still trying to explain
myself how 27MHz is working where a 54MHz is required. I guess there is
also a lower limit on what the frequency should be?

Sorry I am not familiar will all the video concepts, hence the questions.

Thanks,
Sekhar
