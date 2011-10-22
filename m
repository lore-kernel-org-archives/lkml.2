Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1JVDLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 23:11:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:64512 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab1JVDLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 23:11:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,390,1315206000"; 
   d="scan'208";a="65169982"
Date: Sat, 22 Oct 2011 11:11:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] writeback: avoid touching dirtied_when on blocked
 inodes
Message-ID: <20111022031135.GA4823@localhost>
References: <20111020152240.751936131@intel.com>
 <20111020232116.GB20542@quack.suse.cz>
 <20111021104049.GA3784@localhost>
 <20111021195448.GA10166@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021195448.GA10166@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > btw, with the I_SYNC case converted, it's actually no longer necessary
> > to keep a standalone b_more_io_wait. It should still be better to keep
> > the list and the above error check for catching possible errors and
> > the flexibility of adding policies like "don't retry possible blocked
> > inodes in N seconds as long as there are other inodes to work with".
> > 
> > The below diff only intends to show the _possibility_ to remove
> > b_more_io_wait:
>   Good observation. So should we introduce b_more_io_wait in the end? We
> could always introduce it when the need for some more complicated policy
> comes...
> 

I have no problem removing it if you liked it more. Anyway, let me
test the idea out first (just kicked off the tests).

Thanks,
Fengguang
