Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab0FFLXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:23:11 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52313 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab0FFLXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:23:09 -0400
Message-ID: <4C0B851A.7050008@fusionio.com>
Date: Sun, 06 Jun 2010 13:23:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       philipp.reisner@linbit.com
Subject: Re: [GIT PULL] block/IO bits for 2.6.35-rc1
References: <4C08F758.7070009@fusionio.com> <alpine.LFD.2.00.1006041531340.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006041531340.8175@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-05 00:37, Linus Torvalds wrote:
> 
> 
> On Fri, 4 Jun 2010, Jens Axboe wrote:
>>
>> - A drbd update.
> 
> Can we agree to just stop this? 
> 
> During the merge window, please. The drbd fiasco has been going on too 
> long for me to believe in the whole "a few more fixes" thing.
> 
> If it's a security issue, or a major oops, take it. But don't send me 
> "updates" or stuff "just to make it work", since it never has before.
> 
> It's not a regression that drbd is in bad shape. So don't try to make it 
> out to be one. And if it's not a regression or a major oops/security 
> issue, it goes into the NEXT MERGE WINDOW.
> 
> Yes, I'm annoyed. Somebody needs to call out the drbd crud. I really don't 
> want _any_ more drbd crap after the merge window. If I see any more, I'll 
> stop pulling. Comprende?

Understood, I should have been a bit more strict on accepting
late drbd chages.

-- 
Jens Axboe

