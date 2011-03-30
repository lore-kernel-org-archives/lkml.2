Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1C3PXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab1C3PXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:23:08 -0400
Date: Wed, 30 Mar 2011 11:22:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        hch@infradead.org
Subject: Re: block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330152248.GC1291@redhat.com>
References: <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
 <20110330140123.GA28212@redhat.com>
 <20110330142751.GH17523@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330142751.GH17523@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 04:27:51PM +0200, Tejun Heo wrote:

[..]
> > And just to be clear: none of this is a concern for stable right?  It is
> > just the flush-merge code introduced for 2.6.39 that needs fixing?
> 
> I think 2.6.38 needs a -stable fix.  It has the previous version of
> the new flush implementation and is using front insertion.

Tejun,

So wee need this as stable fix because FLUSH request can get ahead of
REQUEUED requests and it can break some drivers?

Thanks
Vivek
