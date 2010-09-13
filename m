Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0IMKKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:10:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56906 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0IMKK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:10:29 -0400
Date: Mon, 13 Sep 2010 11:10:16 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH 01/17] writeback: remove the internal 5% low bound on
	dirty_ratio
Message-ID: <20100913101016.GF23508@csn.ul.ie>
References: <20100912154945.758129106@intel.com> <20100912155202.733389420@intel.com> <20100913095130.GD23508@csn.ul.ie> <20100913095708.GA31310@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100913095708.GA31310@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > i.e. * instead of +. With +, the value for dirty is almost always going
> > to be simply 1%.
> 
> Where's the "+" come from?
> 

This is embarassing. I was reading mail on a small font that had reduced all *
to look like +. Ignore the question.
