Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935352Ab0EVAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:09:26 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:50725 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935275Ab0EVAJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:09:22 -0400
Date: Sat, 22 May 2010 10:09:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 0/4] writeback: tracing and wbc->nr_to_write fixes
Message-ID: <20100522000913.GZ8120@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <20100521150504.GA4598@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521150504.GA4598@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 11:05:04AM -0400, Christoph Hellwig wrote:
> What happened to this series?  Getting the trace events in will
> defintively help with tuning the writeback code, and we'll also need
> the nr_to_write issue fixed some way.

I've been snowed under trying to get several different things done
all at the same time, so this has slipped. I'm trying to get back to
it early next week. The nr_to_pages fix is badly needed, as that
causes severe fragmentation in XFS for the exact workloads it fixes
the severe fragmentation in ext4....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
