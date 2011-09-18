Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1IROXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 10:23:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:27116 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1IROXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 10:23:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,401,1312182000"; 
   d="scan'208";a="50112534"
Date: Sun, 18 Sep 2011 22:23:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/18] writeback: limit max dirty pause time
Message-ID: <20110918142344.GC15366@localhost>
References: <20110904015305.367445271@intel.com>
 <20110904020916.329482509@intel.com>
 <1315320726.14232.11.camel@twins>
 <20110907023505.GB13755@localhost>
 <1315822951.26517.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315822951.26517.25.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 06:22:31PM +0800, Peter Zijlstra wrote:
> On Wed, 2011-09-07 at 10:35 +0800, Wu Fengguang wrote:
> > So yeah, the HZ value does impact the minimal available sleep time...
> 
> There's always schedule_hrtimeout() and we could trivially add a
> io_schedule_hrtimeout() variant if you need it.

Yeah, we could do that when get done with the basic functions :)

Thanks,
Fengguang
