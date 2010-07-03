Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0GCFSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 01:18:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:53744 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab0GCFSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 01:18:21 -0400
Date: Sat, 3 Jul 2010 15:18:16 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-ID: <20100703051816.GG11732@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030730.245992858@suse.de>
 <20100630072702.GF24712@dastard>
 <20100630120502.GB21358@laptop>
 <20100702190355.2b3fe6d2.akpm@linux-foundation.org>
 <20100703034123.GE11732@laptop>
 <20100702213149.f0ca2f72.akpm@linux-foundation.org>
 <20100703050652.GF11732@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100703050652.GF11732@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 03:06:52PM +1000, Nick Piggin wrote:
> It is possible that locking can be reduced if some things are verified
> and carefully shown not to matter. I just don't see the need yet and it
> would make things overly complicated I think. Introducing any more
> complexity will sink this patchset.

By overly complicated, I mean, for this patchset where locking is
already been rewritten. It would then be no more complicated (actually
far less) than equivalently trying to lift inode_lock from parts of the
code where it is causing contention times.

