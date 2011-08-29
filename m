Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1H2N0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:26:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58456 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1H2N0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:26:47 -0400
MIME-Version: 1.0
In-Reply-To: <201108291346.29847.philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
 <CAGpXXZKem-uEdF4SyUgpQFV6=d5Vo3v9p3wmcaygAKa4w4x01w@mail.gmail.com> <201108291346.29847.philipp.reisner@linbit.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Mon, 29 Aug 2011 09:26:16 -0400
Message-ID: <CAGpXXZK4wSCoVfyGpwt7ygN_8mqQ1cNzuVD4XsWXunJzUvEX+g@mail.gmail.com>
Subject: Re: [Drbd-dev] [RFC 000/118] drbd: part 1 of adding multiple volume
 support to drbd
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 7:46 AM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> Am Freitag, 26. August 2011, 15:20:51 schrieb Greg Freemyer:
>> On Thu, Aug 25, 2011 at 11:06 AM, Philipp Reisner <
>>
>> philipp.reisner@linbit.com> wrote:
>> > This the first request for review of drbd-8.4. The complete set has
>> > 500 patches. In this first series there are only 118 of these.
>>
>> Lars,
>>
>> I've only taken a quick glance, but is drbd functional between applying
>> each patch?
>>
>> It doesn't look like it to me, but I didn't look that close.  I also saw at
>> least one patch that introduced a new function with no caller to test it.
>>
>> The idea is that a patch series leave a testable / functional kernel after
>> each patch in the series is applied sequentially.
>>
>> That is the only way git bisect can do its job.
>>
>> ie. Introducing a new function but no new caller makes a change, but there
>> is no way to test it.  Therefore there is no real value in not merging that
>> patch with one that has the new call in it.
>>
>
> Greg,
>
> You replied to mail 000. Please point out to which patch/function you
> refer, so that we can fix this.
>
> Best,
>  Phil

Phillip,

Take a look at patch 115 of 118 in your series.  I did not review the
whole series, I just poked around briefly and noticed this one.

Greg
