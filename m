Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0CVVCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:02:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:39683 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab0CVVB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:01:59 -0400
Date: Tue, 23 Mar 2010 08:01:55 +1100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] mm, fs: warn on missing address space operations
Message-ID: <20100322210155.GS17637@laptop>
References: <20100322053937.GA17637@laptop>
 <20100322005610.5dfa70b1.akpm@linux-foundation.org>
 <20100322104057.GG17637@laptop>
 <20100322093041.2de599f8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322093041.2de599f8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 09:30:41AM -0400, Andrew Morton wrote:
> On Mon, 22 Mar 2010 21:40:57 +1100 Nick Piggin <npiggin@suse.de> wrote:
> 
> > > 
> > > 	/* this fs should use block_invalidatepage() */
> > > 	WARN_ON_ONCE(!invalidatepage);
> > 
> > Problem is that it doesn't give you the aop name (and call trace
> > probably won't help).
> 
> Yes it does - you have the filename and line number.  You go there and
> read "invalidatepage".  And the backtrace identifies the filesystem.

The backtrace is usually coming from just generic code paths though.
Granted that it's usually not too hard to figure what filesystem it is
(although it may have several aops).
