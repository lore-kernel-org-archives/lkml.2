Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2CZJcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 05:32:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47354 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab2CZJcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 05:32:05 -0400
Date: Mon, 26 Mar 2012 10:32:01 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: Anton Blanchard <anton@samba.org>, aarcange@redhat.com,
        akpm@linux-foundation.org, hughd@google.com,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Re: kswapd stuck using 100% CPU
Message-ID: <20120326093201.GL1007@csn.ul.ie>
References: <20120324130353.48f2e4c8@kryten>
 <20120324102621.353114da@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120324102621.353114da@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 10:26:21AM -0400, Rik van Riel wrote:
> 
> Only test compaction_suitable if the kernel is built with CONFIG_COMPACTION,
> otherwise the stub compaction_suitable function will always return
> COMPACT_SKIPPED and send kswapd into an infinite loop.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Anton Blanchard <anton@samba.org>
> 

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
