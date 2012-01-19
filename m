Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2ASISs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:18:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:59630 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2ASISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:18:47 -0500
Message-ID: <4F17D1CB.4050902@kernel.dk>
Date: Thu, 19 Jan 2012 09:18:19 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch]block,cfq: change code order
References: <1326938918.22361.652.camel@sli10-conroe>
In-Reply-To: <1326938918.22361.652.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 03:08 AM, Shaohua Li wrote:
> Subject: block,cfq: change code order
> 
> cfq_slice_expired will change saved_workload_slice. It should be called
> first so saved_workload_slice is correctly set to 0 after workload type
> is changed.
> This fixes the code order changed by 54b466e44b1c7.

Thanks, applied.

-- 
Jens Axboe

