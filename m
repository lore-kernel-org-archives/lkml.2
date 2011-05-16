Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab1EPP02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:26:28 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52391 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab1EPP00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:26:26 -0400
Date: Mon, 16 May 2011 17:26:08 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>, stable <stable@kernel.org>
Subject: Re: [PATCH 1/2] mm: vmscan: Correct use of pgdat_balanced in
 sleeping_prematurely
Message-ID: <20110516152608.GT16531@cmpxchg.org>
References: <1305558417-24354-1-git-send-email-mgorman@suse.de>
 <1305558417-24354-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305558417-24354-2-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 04:06:56PM +0100, Mel Gorman wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> Johannes Weiner poined out that the logic in commit [1741c877: mm:
> kswapd: keep kswapd awake for high-order allocations until a percentage
> of the node is balanced] is backwards. Instead of allowing kswapd to go
> to sleep when balancing for high order allocations, it keeps it kswapd
> running uselessly.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
