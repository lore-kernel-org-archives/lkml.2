Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1FGMN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:13:58 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38050
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753034Ab1FGMN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:13:56 -0400
Date: Tue, 7 Jun 2011 08:13:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: writeback merge status, was Re: [PATCH 00/18] writeback fixes and
 cleanups for 2.6.40 (v3)
Message-ID: <20110607121335.GA14080@infradead.org>
References: <20110519214530.939830917@intel.com>
 <20110523090739.GA27894@infradead.org>
 <20110523092838.GA25829@localhost>
 <20110524032859.GA17429@localhost>
 <20110601153142.0bf83332.akpm@linux-foundation.org>
 <20110602022919.GB6015@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602022919.GB6015@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like we once again got no writeback fixes merged for $NEXT,
even with Wu having a very nice, well reviewed and tested series of 
fairly trivial patches.

I'm getting really frustrated about this.  We need a lot of work to
make writeback not suck with todays hardware and workloads, nevermind
tomorrows, and we're getting stalled for completely untransparent
reasons.  Basically people doing the work move ahead, then it gets stuck
in -mm which doesn't even get into linux-next and gets completely
stalled there.  So my vote is to have a proper peer-reviewed writeback
git tree, handled like all the other git trees we have, that is
maintained e.g. by Wu and make progress with that.

After fixing all those basic issues we have other big items like
I/O-less balance_dirty_pages and the memcg integration on our plate,
and with the current rate of progress we won't get there before Linux
4.0.

