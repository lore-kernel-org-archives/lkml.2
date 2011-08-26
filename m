Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1HZNYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:24:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:2981 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab1HZNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:24:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,285,1312182000"; 
   d="scan'208";a="42727962"
Date: Fri, 26 Aug 2011 21:24:45 +0800
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
Message-ID: <20110826132445.GA8219@localhost>
References: <20110824001257.GA6349@localhost>
 <1314202378.6925.48.camel@twins>
 <20110826001846.GA6118@localhost>
 <1314349469.26922.24.camel@twins>
 <20110826100428.GA7996@localhost>
 <20110826112637.GA17785@localhost>
 <1314360710.11049.1.camel@twins>
 <20110826122057.GA32711@localhost>
 <20110826131341.GA7114@localhost>
 <1314364701.12445.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314364701.12445.0.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 09:18:21PM +0800, Peter Zijlstra wrote:
> On Fri, 2011-08-26 at 21:13 +0800, Wu Fengguang wrote:
> > We got similar result as in the read disturber case, even though one
> > disturbs N and the other impacts writeout bandwith.  The original
> > patchset is consistently performing much better :) 
> 
> It does indeed, and I figure on these timescales it makes sense to
> assumes N is a constant. Fair enough, thanks!

Thank you! Glad that we finally reaches some consensus :)

Thanks,
Fengguang
