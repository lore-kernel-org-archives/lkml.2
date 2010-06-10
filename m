Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab0FJQ75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:59:57 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46395 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759498Ab0FJQ7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:59:55 -0400
Message-ID: <4C111A0A.1030703@fusionio.com>
Date: Thu, 10 Jun 2010 18:59:54 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
References: <4C10EC2A.8060002@fusionio.com> <AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com> <4C1111ED.6020008@fusionio.com> <20100610164048.GA25171@lst.de>
In-Reply-To: <20100610164048.GA25171@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-10 18:40, Christoph Hellwig wrote:
> On Thu, Jun 10, 2010 at 06:25:17PM +0200, Jens Axboe wrote:
>> I agree, it's late and it makes me nervous too. I had them cook for
>> a day, didn't see any problems. And Christoph would not send it in
>> unless it passes at least xfs qa, which is what found the problems
>> last time (the ones we reverted).
>>
>> It's fixing a regression where umount takes a LONG time if you have
>> a lot of dirty inodes, since it basically degenerates to a data
>> integrity writeback instead of a simple WB_SYNC_NONE. If it wasn't
>> fixing a nasty regression (the distros are all wanting a real fix
>> for this, it's a user problem), I would not be submitting this code
>> at this point in time.
> 
> Maybe give it a bit more beating in linux-next and send it off to Linus
> once he's back from his vacation?

We can do that. Linus, I'll split split off the writeback parts and send
you a new pull request.

-- 
Jens Axboe

