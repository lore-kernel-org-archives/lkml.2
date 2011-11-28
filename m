Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1K1VBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:01:00 -0500
Received: from relay3.sgi.com ([192.48.152.1]:43774 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753679Ab1K1VA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:00:59 -0500
Date: Mon, 28 Nov 2011 15:01:18 -0600
From: Ben Myers <bpm@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Simon Kirby <sim@hostway.ca>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111128210118.GT29840@sgi.com>
References: <20111021132240.GA24136@infradead.org> <20111021202857.GB30100@hostway.ca> <20111024082219.GA19941@infradead.org> <20111025200748.GA25043@hostway.ca> <20111026112521.GA10432@infradead.org> <20111104210324.GB14983@infradead.org> <20111116195643.GF24411@hostway.ca> <20111120153241.GA23511@infradead.org> <20111128190554.GA31168@hostway.ca> <20111128195505.GA3759@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128195505.GA3759@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Christoph,

On Mon, Nov 28, 2011 at 02:55:05PM -0500, Christoph Hellwig wrote:
> On Mon, Nov 28, 2011 at 11:05:54AM -0800, Simon Kirby wrote:
> > On Sun, Nov 20, 2011 at 10:32:41AM -0500, Christoph Hellwig wrote:
> > 
> > > On Wed, Nov 16, 2011 at 11:56:43AM -0800, Simon Kirby wrote:
> > > > Sorry for the delay in testing.
> > > > 
> > > > Yes, everything looks fine even with the xfs_log_force line from your
> > > > patch commented out. So, the changes in xfs_reclaim_inode() are just the
> > > > set_bit(XBT_FORCE_FLUSH) and wake_up_process(), relative to 3.1.
> > > 
> > > Dave pointed out that we can do better than the big hammer, and the
> > > patch below should fix your issue, too.  Can you test it?
> > 
> > Yes, seems to be fine. No hung task warnings, tested for ~5 days.
> 
> Thanks a lot for the testing Simon.
> 
> Ben, can you add a:
> 
> Tested-by: Simon Kirby <sim@hostway.ca>
> 
> to the patch when applying it?

Yep, I will add Simon's Tested-by:

Thanks Simon!  ;)

-Ben
