Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2LTLRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:17:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2LTLRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:17:46 -0500
Date: Thu, 20 Dec 2012 11:17:43 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] ksm: make rmap walks more scalable
Message-ID: <20121220111743.GF10819@suse.de>
References: <alpine.LNX.2.00.1212191735530.25409@eggly.anvils>
 <alpine.LNX.2.00.1212191742440.25409@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1212191742440.25409@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 05:44:29PM -0800, Hugh Dickins wrote:
> The rmap walks in ksm.c are like those in rmap.c:
> they can safely be done with anon_vma_lock_read().
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

I'm assuming these are going to go through Andrew's tree as normal for
-mm patches. Andrew?

-- 
Mel Gorman
SUSE Labs
