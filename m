Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1HZKwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:52:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:26452 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab1HZKwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:52:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,284,1312182000"; 
   d="scan'208";a="42691331"
Date: Fri, 26 Aug 2011 18:52:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110826105226.GA16385@localhost>
References: <20110823034042.GC7332@localhost>
 <1314093660.8002.24.camel@twins>
 <20110823141504.GA15949@localhost>
 <20110823174757.GC15820@redhat.com>
 <20110824001257.GA6349@localhost>
 <1314202378.6925.48.camel@twins>
 <20110826001846.GA6118@localhost>
 <1314349469.26922.24.camel@twins>
 <20110826100428.GA7996@localhost>
 <1314355342.9377.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314355342.9377.5.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 06:42:22PM +0800, Peter Zijlstra wrote:
> On Fri, 2011-08-26 at 18:04 +0800, Wu Fengguang wrote:
> > Sorry I'm now feeling lost...
> 
> hehe welcome to my world ;-)

Yeah, so sorry...

> Seriously though, I appreciate all the effort you put in trying to
> explain things. I feel I do understand things now, although I might not
> completely agree with them quite yet ;-)

Thank you :)

> I'll go read the v9 patch-set you send out and look at some of the
> details (such as pos_ratio being comprised of both global and bdi
> limits, which so far has been somewhat glossed over).

Hold on please! I'll immediately post a v10 with all the comment updates.

Thanks,
Fengguang

