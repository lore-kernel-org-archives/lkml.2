Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab2KBXIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:08:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54334 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2KBXIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:08:02 -0400
Date: Fri, 2 Nov 2012 16:07:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH 2/2 v5] block/throttle: Add IO submitted information in
 blkio.throttle
Message-ID: <20121102230757.GF27843@mtj.dyndns.org>
References: <1351848697-26087-1-git-send-email-robin.k.dong@gmail.com>
 <1351848697-26087-2-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351848697-26087-2-git-send-email-robin.k.dong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 05:31:37PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> Currently, if the IO is throttled by io-throttle, the system admin has no idea
> of the situation and can't report it to the real application user about that
> he/she has to do something.
> 
> So this patch adds a new interface named blkio.throttle.io_submitted which
> exposes the number of bios that have been sent into blk-throttle therefore the
> user could calculate the difference from throttle.io_serviced to see how many
> IOs are currently throttled.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> Signed-off-by: Robin Dong <sanbai@taobao.com>

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
