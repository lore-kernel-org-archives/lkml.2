Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab0FJQlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:41:17 -0400
Received: from verein.lst.de ([213.95.11.210]:34359 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab0FJQlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:41:16 -0400
Date: Thu, 10 Jun 2010 18:40:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
Message-ID: <20100610164048.GA25171@lst.de>
References: <4C10EC2A.8060002@fusionio.com> <AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com> <4C1111ED.6020008@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1111ED.6020008@fusionio.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 06:25:17PM +0200, Jens Axboe wrote:
> I agree, it's late and it makes me nervous too. I had them cook for
> a day, didn't see any problems. And Christoph would not send it in
> unless it passes at least xfs qa, which is what found the problems
> last time (the ones we reverted).
> 
> It's fixing a regression where umount takes a LONG time if you have
> a lot of dirty inodes, since it basically degenerates to a data
> integrity writeback instead of a simple WB_SYNC_NONE. If it wasn't
> fixing a nasty regression (the distros are all wanting a real fix
> for this, it's a user problem), I would not be submitting this code
> at this point in time.

Maybe give it a bit more beating in linux-next and send it off to Linus
once he's back from his vacation?
