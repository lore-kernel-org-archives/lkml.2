Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab2JRXYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:24:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57379 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab2JRXYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:24:08 -0400
Date: Thu, 18 Oct 2012 16:24:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Robin Dong <robin.k.dong@gmail.com>, linux-kernel@vger.kernel.org,
        Robin Dong <sanbai@taobao.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH V3] block/throttle: Add IO throttled information in
 blkio.throttle
Message-ID: <20121018232404.GW13370@google.com>
References: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
 <20121016232706.GI16166@google.com>
 <20121017134945.GC31663@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017134945.GC31663@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Wed, Oct 17, 2012 at 09:49:45AM -0400, Vivek Goyal wrote:
> Can you explain a bit more. Whe do you mean by "total number queued". I
> think throttle.io_queued will total number of bios queued in the cgroup
> at the time of query.

Instead of exposing the number that blk-throttle currently has
deferred, we can expose the number of bios that have been sent to
blk-throttle and the number of bios which left blk-throttle, both
monotically increasing and the difference indicating the number being
deferred.  That way we can stick to the usual stats facility.

Thanks.

-- 
tejun
