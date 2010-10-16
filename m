Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab0JPGkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 02:40:45 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60040 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab0JPGkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 02:40:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAL7juEx5LcB2/2dsb2JhbAChMXK9TIVJBI9K
Date: Sat, 16 Oct 2010 17:40:41 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: inode per-cpu last_ino allocator
Message-ID: <20101016064041.GB4383@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-16-git-send-email-david@fromorbit.com>
 <20100929215312.5fcb6976.akpm@linux-foundation.org>
 <1285824982.5211.675.camel@edumazet-laptop>
 <1285833189.2615.31.camel@edumazet-laptop>
 <20100930011417.6ca16ed7.akpm@linux-foundation.org>
 <1285842136.2615.251.camel@edumazet-laptop>
 <20100930094558.97c9afa2.akpm@linux-foundation.org>
 <1285867685.2615.865.camel@edumazet-laptop>
 <20101016063604.GA4383@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016063604.GA4383@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 05:36:04PM +1100, Nick Piggin wrote:
> On Thu, Sep 30, 2010 at 07:28:05PM +0200, Eric Dumazet wrote:
> > [PATCH] fs: inode per-cpu last_ino allocator
> 
> Thanks Eric, this looks good. You didn't seem to add a comment about
> preempt safety that Andrew wanted, but I'll add it.

Oh I beg your pardon, you added preempt disable in the code. Much safer,
thanks.

