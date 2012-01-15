Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2AOWdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 17:33:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab2AOWdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 17:33:14 -0500
Date: Sun, 15 Jan 2012 17:32:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com
Subject: Re: [RFC 0/3]block: An IOPS based ioscheduler
Message-ID: <20120115223246.GC3174@redhat.com>
References: <20120104065337.230911609@sli10-conroe.sh.intel.com>
 <20120104071931.GB17026@dastard>
 <1325746241.22361.503.camel@sli10-conroe>
 <1325826750.22361.533.camel@sli10-conroe>
 <20120106143759.GE20291@quack.suse.cz>
 <1326072405.22361.553.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326072405.22361.553.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 09:26:45AM +0800, Shaohua Li wrote:

[..]
> >  Could you for example compare a latency of reads while running heavy
> > background writing between CFQ and your scheduler? Loads like this where
> > original motivation for CFQ I believe.
> CFQ supports preemption, FIOPS doesn't, so I suppose read latency of CFQ
> is still better in such workload.
> In this initial post, I just want to demonstrate the basic idea of the
> ioscheduler. I'll post more data for both latency and throughput in next
> round.

I think before numbers what will be more helpful to know is that what are
you trying to achieve and why existing CFQ code can not do that with little
modification.

Thanks
Vivek
