Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab0FJQzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:55:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660Ab0FJQzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <4C1111ED.6020008@fusionio.com>
References: <4C10EC2A.8060002@fusionio.com>
	<AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com>
	<4C1111ED.6020008@fusionio.com>
Date: Thu, 10 Jun 2010 09:55:10 -0700
Message-ID: <AANLkTikKwoZKYsj2Nd98rIa8i947a-AlpEd47lkuHyro@mail.gmail.com>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 9:25 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> It's fixing a regression where umount takes a LONG time if you have
> a lot of dirty inodes, since it basically degenerates to a data
> integrity writeback instead of a simple WB_SYNC_NONE. If it wasn't
> fixing a nasty regression (the distros are all wanting a real fix
> for this, it's a user problem), I would not be submitting this code
> at this point in time.

I'm not sure if you noticed, we had a separate thread with Dave
Chinner that resulted in three hopefully fairly minimal patches going
in instead.

See commits

   git log -3  d87815cb2090

and I thought that last one (first one applied: "pay attention to
wbc->nr_to_write") was the one that had fixed the worst XFS issues.

But maybe it was an unrelated thing.

                 Linus
