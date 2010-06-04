Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab0FDWmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:42:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757165Ab0FDWmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:42:31 -0400
Date: Fri, 4 Jun 2010 15:37:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jaxboe@fusionio.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [GIT PULL] block/IO bits for 2.6.35-rc1
In-Reply-To: <4C08F758.7070009@fusionio.com>
Message-ID: <alpine.LFD.2.00.1006041531340.8175@i5.linux-foundation.org>
References: <4C08F758.7070009@fusionio.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jun 2010, Jens Axboe wrote:
>
> - A drbd update.

Can we agree to just stop this? 

During the merge window, please. The drbd fiasco has been going on too 
long for me to believe in the whole "a few more fixes" thing.

If it's a security issue, or a major oops, take it. But don't send me 
"updates" or stuff "just to make it work", since it never has before.

It's not a regression that drbd is in bad shape. So don't try to make it 
out to be one. And if it's not a regression or a major oops/security 
issue, it goes into the NEXT MERGE WINDOW.

Yes, I'm annoyed. Somebody needs to call out the drbd crud. I really don't 
want _any_ more drbd crap after the merge window. If I see any more, I'll 
stop pulling. Comprende?

			Linus
