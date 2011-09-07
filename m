Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab1IGQTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:19:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:56233 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab1IGQT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,344,1312182000"; 
   d="scan'208";a="46332127"
Date: Wed, 7 Sep 2011 19:00:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/18] writeback: per task dirty rate limit
Message-ID: <20110907110022.GA6012@localhost>
References: <20110904015305.367445271@intel.com>
 <20110904020915.240747479@intel.com>
 <1315324030.14232.14.camel@twins>
 <20110907010448.GA6513@localhost>
 <1315380716.11101.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315380716.11101.5.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 03:31:56PM +0800, Peter Zijlstra wrote:
> On Wed, 2011-09-07 at 09:04 +0800, Wu Fengguang wrote:
> 
> > So the sqrt naturally leads to less overheads and more N tolerance for
> > large memory servers, which have large (thresh-freerun) gaps.
> 
> Thanks, and as you say its an initial guess, later refined using patch
> 14.

Yes, exactly.
