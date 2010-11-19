Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab0KSWPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:15:37 -0500
Received: from waste.org ([173.11.57.241]:59698 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757892Ab0KSWPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:15:12 -0500
Subject: Re: [PATCH] mm: remove call to find_vma in pagewalk for
 non-hugetlbfs
From: Matt Mackall <mpm@selenic.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>, Andy Whitcroft <apw@canonical.com>,
        David Rientjes <rientjes@google.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <1290127197-20360-1-git-send-email-dsterba@suse.cz>
References: <1290127197-20360-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 14:09:17 -0600
Message-ID: <1290197357.26343.944.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 01:39 +0100, David Sterba wrote:
> Commit d33b9f45 introduces a check if a vma is a hugetlbfs one and
> later in 5dc37642 is moved under #ifdef CONFIG_HUGETLB_PAGE but
> a needless find_vma call is left behind and it's result not used
> anywhere else in the function.
> 
> The sideefect of caching vma for @addr inside walk->mm is neither
> utilized in walk_page_range() nor in called functions.

Looks good to me.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.


