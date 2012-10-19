Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab2JSTgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:36:07 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44394 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544Ab2JSTgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:36:04 -0400
Date: Fri, 19 Oct 2012 12:36:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Robin Dong <robin.k.dong@gmail.com>, linux-kernel@vger.kernel.org,
        Robin Dong <sanbai@taobao.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH V3] block/throttle: Add IO throttled information in
 blkio.throttle
Message-ID: <20121019193600.GK13370@google.com>
References: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
 <20121016232706.GI16166@google.com>
 <20121017134945.GC31663@redhat.com>
 <20121018232404.GW13370@google.com>
 <20121019150011.GE27052@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019150011.GE27052@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Fri, Oct 19, 2012 at 11:00:11AM -0400, Vivek Goyal wrote:
> > That way we can stick to the usual stats facility.
> 
> So how does this help? Because it is a monotonically increasing value
> we can use per cpu stats without extra locking? Or somthing else?

It's generally much simpler to expose dumb increasing counters.  You
don't have to worry about mismatching decrements (for whatever reason,
percpu or segmented counters), so unless there's a pretty good reason
to deviate, why deviate?

Thanks.

-- 
tejun
