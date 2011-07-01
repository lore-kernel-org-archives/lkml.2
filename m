Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1GAT3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 15:29:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1GAT3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 15:29:33 -0400
Date: Fri, 1 Jul 2011 15:29:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Shaohua <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] writeback: bdi write bandwidth estimation
Message-ID: <20110701192915.GE28563@redhat.com>
References: <20110629145245.835998321@intel.com>
 <20110629145553.906668553@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629145553.906668553@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:52:48PM +0800, Wu Fengguang wrote:
> The estimation value will start from 100MB/s and adapt to the real
> bandwidth in seconds.
> 
> It tries to update the bandwidth only when disk is fully utilized.
> Any inactive period of more than one second will be skipped.

Is this piece of code being tested in your graphs? Are there any
inactive periods which get filtered out in your workload? I am 
assuming in a continuous dd, we will not have periods of inactivity
1 second long.

Thanks
Vivek
