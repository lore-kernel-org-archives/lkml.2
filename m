Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1KVWC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:02:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab1KVWC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:02:26 -0500
Date: Tue, 22 Nov 2011 17:02:18 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kexec@lists.infradead.org
Subject: Re: block: initialize request_queue's numa node during allocation
Message-ID: <20111122220218.GA17543@redhat.com>
References: <4ECB5C80.8080609@redhat.com>
 <alpine.DEB.2.00.1111220140470.4306@chino.kir.corp.google.com>
 <20111122152739.GA5663@redhat.com>
 <20111122211954.GA17120@redhat.com>
 <alpine.DEB.2.00.1111221342320.2621@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111221342320.2621@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22 2011 at  4:45pm -0500,
David Rientjes <rientjes@google.com> wrote:

> On Tue, 22 Nov 2011, Mike Snitzer wrote:
> 
> > From: Mike Snitzer <snitzer@redhat.com>
> > Subject: block: initialize request_queue's numa node during allocation
> > 
> > Set request_queue's node in blk_alloc_queue_node() rather than
> > blk_init_allocated_queue_node().  This avoids blk_throtl_init() using
> > q->node before it is initialized.
> > 
> > Rename blk_init_allocated_queue_node() to blk_init_allocated_queue().
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> When I debug an issue and suggest a patch to fix it in addition to 
> suggesting the possible cleanup for blk_init_allocated_queue_node(), I 
> don't expect that you'll just take it and claim it as your own, sheesh.

Sorry I pissed you off.  But I'm not that hard up for credit.  I was
just looking to make sure proper _code_ changes occurred ;)  I didn't
take enough time to fully appreciate the long road you've travelled on
this.

Jens, I'll defer to David to post a proper patch header.  David please
claim the patch and its contents as your own in v2.  But feel free to
add my Signed-off-by.

Thanks,
Mike
