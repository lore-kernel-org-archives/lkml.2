Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2JSTjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:39:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715Ab2JSTjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:39:44 -0400
Date: Fri, 19 Oct 2012 15:39:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Robin Dong <robin.k.dong@gmail.com>, linux-kernel@vger.kernel.org,
        Robin Dong <sanbai@taobao.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH V3] block/throttle: Add IO throttled information in
 blkio.throttle
Message-ID: <20121019193932.GA3633@redhat.com>
References: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
 <20121016232706.GI16166@google.com>
 <20121017134945.GC31663@redhat.com>
 <20121018232404.GW13370@google.com>
 <20121019150011.GE27052@redhat.com>
 <20121019193600.GK13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019193600.GK13370@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 12:36:00PM -0700, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Fri, Oct 19, 2012 at 11:00:11AM -0400, Vivek Goyal wrote:
> > > That way we can stick to the usual stats facility.
> > 
> > So how does this help? Because it is a monotonically increasing value
> > we can use per cpu stats without extra locking? Or somthing else?
> 
> It's generally much simpler to expose dumb increasing counters.  You
> don't have to worry about mismatching decrements (for whatever reason,
> percpu or segmented counters), so unless there's a pretty good reason
> to deviate, why deviate?

I really can't think of a reason to deviate. I was just curious of
advantages. I think it does make sense to not get into decrement business
and let user space subtract two values and figure out how much IO from
the group is throttled.

Thanks
Vivek
