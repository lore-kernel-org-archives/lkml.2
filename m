Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab0FJRAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:00:43 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46617 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759573Ab0FJRAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:00:42 -0400
Message-ID: <4C111A39.7000900@fusionio.com>
Date: Thu, 10 Jun 2010 19:00:41 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
References: <4C10EC2A.8060002@fusionio.com>	<AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com>	<4C1111ED.6020008@fusionio.com> <AANLkTikKwoZKYsj2Nd98rIa8i947a-AlpEd47lkuHyro@mail.gmail.com>
In-Reply-To: <AANLkTikKwoZKYsj2Nd98rIa8i947a-AlpEd47lkuHyro@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-10 18:55, Linus Torvalds wrote:
> On Thu, Jun 10, 2010 at 9:25 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> It's fixing a regression where umount takes a LONG time if you have
>> a lot of dirty inodes, since it basically degenerates to a data
>> integrity writeback instead of a simple WB_SYNC_NONE. If it wasn't
>> fixing a nasty regression (the distros are all wanting a real fix
>> for this, it's a user problem), I would not be submitting this code
>> at this point in time.
> 
> I'm not sure if you noticed, we had a separate thread with Dave
> Chinner that resulted in three hopefully fairly minimal patches going
> in instead.
> 
> See commits
> 
>    git log -3  d87815cb2090
> 
> and I thought that last one (first one applied: "pay attention to
> wbc->nr_to_write") was the one that had fixed the worst XFS issues.
> 
> But maybe it was an unrelated thing.

That's a different bug.

-- 
Jens Axboe

