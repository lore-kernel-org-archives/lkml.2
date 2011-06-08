Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1FHJi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:38:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab1FHJi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:38:28 -0400
Date: Wed, 8 Jun 2011 11:38:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Thomas Sattler <tsattler@gmx.de>,
        Ury Stankevich <urykhy@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm: vmscan: Do not use page_count without a page pin
Message-ID: <20110608093827.GD6742@tiehlicka.suse.cz>
References: <1307459225-4481-1-git-send-email-mgorman@suse.de>
 <1307459225-4481-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307459225-4481-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 07-06-11 16:07:03, Mel Gorman wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> It is unsafe to run page_count during the physical pfn scan because
> compound_head could trip on a dangling pointer when reading
> page->first_page if the compound page is being freed by another CPU.
> 
> [mgorman@suse.de: Split out patch]
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Michal Hocko <mhocko@suse.cz>
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
