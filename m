Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2IUXcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 19:32:33 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58045 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2IUXcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 19:32:32 -0400
Date: Fri, 21 Sep 2012 19:32:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/4] mm: remove unevictable_pgs_mlockfreed
Message-ID: <20120921233219.GY1560@cmpxchg.org>
References: <alpine.LSU.2.00.1209182045370.11632@eggly.anvils>
 <alpine.LSU.2.00.1209182055290.11632@eggly.anvils>
 <20120921124715.GD11157@csn.ul.ie>
 <alpine.LSU.2.00.1209211550180.23812@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1209211550180.23812@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 03:56:11PM -0700, Hugh Dickins wrote:
> Simply remove UNEVICTABLE_MLOCKFREED and unevictable_pgs_mlockfreed
> line from /proc/vmstat: Johannes and Mel point out that it was very
> unlikely to have been used by any tool, and of course we can restore
> it easily enough if that turns out to be wrong.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Ying Han <yinghan@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
