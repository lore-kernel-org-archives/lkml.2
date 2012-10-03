Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2JCMtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:49:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:42925 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2JCMtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:49:40 -0400
Message-ID: <506C343E.60203@kernel.dk>
Date: Wed, 03 Oct 2012 14:49:02 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] drbd-8.3 updates
References: <8391701.3EY4hQfmFv@fat-tyre> <506BDECA.90701@kernel.dk> <1538845.40xQlPEFSm@fat-tyre> <10403443.3yRLLBkj5b@fat-tyre>
In-Reply-To: <10403443.3yRLLBkj5b@fat-tyre>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-03 12:07, Philipp Reisner wrote:
> Am Mittwoch, 3. Oktober 2012, 11:24:09 schrieben Sie:
>>> Not pulled. Two reasons:
>>>
>>> - It's late (in the merge window)
>>> - and it's not based off my for-3.7/drivers branch, hence I get a ton of
>>>
>>>   unrelated changes with a pull into that branch.
>>
>> Hi Jens,
>>
>> I can rebase it for you in a few hours. Would influence this your decission?
>>
> 
> Hi Jens,
> 
> Is there a convenient way for me to find our when it is the right time
> to send pull requests your way? (i.e. a notification when you create your
> for-3.x/drivers branch)

The right time is anytime between -rc1 and -rcN for the previous
release, where N is the last released -rc for that series. IOW, I should
have it before the next merge window opens, not a days into that window.

> Rebasing it on your drivers tree was trivial, here is the updated pull
> request:
> 
> The following changes since commit fab74e7a8f0f8d0af2356c28aa60d55f9e6f5f8b:
> 
>   loop: Make explicit loop device destruction lazy (2012-09-28 10:42:23 +0200)
> 
> are available in the git repository at:
> 
>   git://git.drbd.org/linux-drbd.git for-jens
> 
> for you to fetch changes up to 61e8114a682b0e868696f8363ed03e5fd4c750d1:
> 
>   drbd: log request sector offset and size for IO errors (2012-10-03 11:54:45 +0200)

Thanks, one question before this is pulled in:

> Philipp Reisner (6):
>       drbd: Add a drbd directory to sysfs
>       drbd: expose the data generation identifiers via sysfs

What are these? It's sitting in /sys/block/<dev>/drbd/, I don't see any
documentation or justification for that.

Why isn't it off in debugfs or similar instead?

-- 
Jens Axboe

