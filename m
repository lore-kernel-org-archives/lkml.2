Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2JQNt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:49:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818Ab2JQNt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:49:58 -0400
Date: Wed, 17 Oct 2012 09:49:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Robin Dong <robin.k.dong@gmail.com>, linux-kernel@vger.kernel.org,
        Robin Dong <sanbai@taobao.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH V3] block/throttle: Add IO throttled information in
 blkio.throttle
Message-ID: <20121017134945.GC31663@redhat.com>
References: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
 <20121016232706.GI16166@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016232706.GI16166@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 04:27:06PM -0700, Tejun Heo wrote:

[..]
> > Changelog from v2:
> > 	Use nr-queued[] of struct throtl_grp for stats instaed of adding new blkg_rwstat.
> 
> As I wrote last time, I would prefer exposing the total number queued
> to blk-throttle rather than exposing the number of bios being
> currently held and let userland calculate from the difference from
> throttle.io_serviced.  That is simpler and more inline with all other
> stats.

Hi Tejun,

Can you explain a bit more. Whe do you mean by "total number queued". I
think throttle.io_queued will total number of bios queued in the cgroup
at the time of query.

Thanks
Vivek
