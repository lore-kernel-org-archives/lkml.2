Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3ADR7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:59:25 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:57476 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab3ADR7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:59:19 -0500
Date: Fri, 4 Jan 2013 17:59:18 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20130104175918.GA29537@dcvr.yhbt.net>
References: <20121228014503.GA5017@dcvr.yhbt.net>
 <20130102200848.GA4500@dcvr.yhbt.net>
 <20130104160148.GB3885@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130104160148.GB3885@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> wrote:
> On Wed, Jan 02, 2013 at 08:08:48PM +0000, Eric Wong wrote:
> > Instead, I disabled THP+compaction under v3.7.1 and I've been unable to
> > reproduce the issue without THP+compaction.
> > 
> 
> Implying that it's stuck in compaction somewhere. It could be the case
> that compaction alters timing enough to trigger another bug. You say it
> tests differently depending on whether TCP or unix sockets are used
> which might indicate multiple problems. However, lets try and see if
> compaction is the primary problem or not.

I haven't managed to reproduce the issue on Unix sockets, yet, just TCP.
Trying Unix with 90KB as Eric Dumazet suggested.

I'll get the info you need from /proc soon.
Thank you for looking at this!
