Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2A3Pav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:30:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab2A3Par (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:30:47 -0500
Date: Mon, 30 Jan 2012 10:30:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com
Subject: Re: [patch v2 0/8]block: An IOPS based ioscheduler
Message-ID: <20120130153009.GB30245@redhat.com>
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130070213.793690895@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 03:02:13PM +0800, Shaohua Li wrote:
> An IOPS based I/O scheduler
> 
> Flash based storage has some different characteristics against rotate disk.
> 1. no I/O seek.
> 2. read and write I/O cost usually is much different.
> 3. Time which a request takes depends on request size.
> 4. High throughput and IOPS, low latency.

Hi Shaohua,

Last time we agreed that you will try to extend CFQ iops mode to take care
of this case. I was wondering that if that idea is out of the window?

Also what's the real workload where this is going to benefit us. I had
struggled to run something which drove constantly deep queue depths to
get the fairness without idling.

Thanks
Vivek
