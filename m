Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1HSQvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab1HSQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:51:31 -0400
Date: Fri, 19 Aug 2011 12:51:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 10/11] VFS: Cache request_queue in struct block_device
Message-ID: <20110819165101.GA13862@redhat.com>
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
 <1312259893-4548-11-git-send-email-andi@firstfloor.org>
 <20110818194245.GJ15413@redhat.com>
 <4E4D7E3C.8060104@linux.intel.com>
 <20110819141409.GD18656@redhat.com>
 <20110819153622.GD25996@one.firstfloor.org>
 <20110819155534.GA13464@redhat.com>
 <20110819162312.GE25996@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819162312.GE25996@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 06:23:12PM +0200, Andi Kleen wrote:
> > Primarily because of code complexity. We are stashing away a pointer and
> > not taking any reference anywhere. So I am not even sure who is making
> > sure that request queue is not gone and there are no comments in the code
> > about why we are stashing a pointer and how are we making sure that
> > request queue is around for the lifetime of bdev.
> 
> Can you point out a concrete problem in my approach?  This seems
> rather vague.

I am not saying that there is a problem in your approach. I am just
asking or trying to understand that who makes sure request queue is
not gone. 

So if you could just comment two things in code it will help for
a futuer reader of the code.

- Why are we stashing this extra pointer.
- What makes sure that object pointed by this pointer is not freed.

I am not saying that there is a problem. Just that I don't know enough
of code to understand how we are making sure queue object is still
around.

Thanks
Vivek
