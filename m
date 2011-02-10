Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1BJLSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 06:18:04 -0500
Received: from gir.skynet.ie ([193.1.99.77]:37108 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab1BJLSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 06:18:02 -0500
Date: Thu, 10 Feb 2011 11:17:36 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] teach smaps_pte_range() about THP pmds
Message-ID: <20110210111736.GF17873@csn.ul.ie>
References: <20110209195406.B9F23C9F@kernel> <20110209195411.816D55A7@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110209195411.816D55A7@kernel>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:54:11AM -0800, Dave Hansen wrote:
> 
> This adds code to explicitly detect  and handle
> pmd_trans_huge() pmds.  It then passes HPAGE_SIZE units
> in to the smap_pte_entry() function instead of PAGE_SIZE.
> 
> This means that using /proc/$pid/smaps now will no longer
> cause THPs to be broken down in to small pages.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: David Rientjes <rientjes@google.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
