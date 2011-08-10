Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1HJDXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 23:23:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:22210 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab1HJDXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 23:23:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,348,1309762800"; 
   d="scan'208";a="36901840"
Date: Wed, 10 Aug 2011 11:22:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] writeback: IO-less balance_dirty_pages()
Message-ID: <20110810032249.GA24486@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094527.136636891@intel.com>
 <20110809181543.GG6482@redhat.com>
 <1312915266.1083.75.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312915266.1083.75.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 02:41:05AM +0800, Peter Zijlstra wrote:
> On Tue, 2011-08-09 at 14:15 -0400, Vivek Goyal wrote:
> > 
> > So far bw had pos_ratio as value now it will be replaced with actual
> > bandwidth as value. It makes code confusing. So using pos_ratio will
> > help. 
> 
> Agreed on consistency, also I'm not sure bandwidth is the right term
> here to begin with, its a pages/s unit and I think rate would be better
> here. But whatever ;-)

Good idea, I'll switch to the name "rate".

Thanks,
Fengguang
