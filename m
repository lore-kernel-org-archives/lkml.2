Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab1F3INt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:13:49 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43831 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684Ab1F3INq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:13:46 -0400
Message-ID: <4E0C3037.6040905@kernel.dk>
Date: Thu, 30 Jun 2011 10:13:43 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] DRBD minor fixes for 3.0-rc6
References: <201106291714.57384.philipp.reisner@linbit.com> <4E0B6B85.5090202@kernel.dk> <201106301008.32832.philipp.reisner@linbit.com>
In-Reply-To: <201106301008.32832.philipp.reisner@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-30 10:08, Philipp Reisner wrote:
> Am Mittwoch, 29. Juni 2011, 20:14:29 schrieb Jens Axboe:
>> On 2011-06-29 17:14, Philipp Reisner wrote:
>>> The following changes since commit a1c15c59feee36267c43142a41152fbf7402afb6:
>>>   loop: handle on-demand devices correctly (2011-05-24 16:48:55 +0200)
>>>
>>> are available in the git repository at:
>>>   git://git.drbd.org/linux-2.6-drbd.git for-jens
>>
>> This looks way too big for -rc6. Take another look at the list and
>> re-send with what is absolutely crucial this late in the cycle, please.
> 
> Hi Jens,
> 
> I categorised them into three branches:
> for-3.0-important, for-3.0-non-important-trivia and for-3.0-non-trivial-cosmetic.
> 
> Please consider to pull the first one, eventually the second one. (The third
> one is only there for sake of completeness, to document that this patch will
> be scheduled for the next merge window)

I have pulled your for-3.0-important branch, looks fine. I'm not pulling
any non-important or trivia for 3.0, so both of the latter branches will
have to wait for 3.1. But do send me pull request for them, might as
well queue it up now since it'll soon be merge time again.

-- 
Jens Axboe

