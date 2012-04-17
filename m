Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab2DQOFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:05:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab2DQOFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:05:54 -0400
Date: Tue, 17 Apr 2012 15:05:49 +0100
From: Mel Gorman <mgorman@suse.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] mm/hugetlb: fix warning in
 alloc_huge_page/dequeue_huge_page_vma
Message-ID: <20120417140549.GJ2359@suse.de>
References: <20120417122819.7438.26117.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120417122819.7438.26117.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 04:28:19PM +0400, Konstantin Khlebnikov wrote:
> This patch fixes gcc warning (and bug?) introduced in linux-next commit cc9a6c877
> ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
> 
> Local variable "page" can be uninitialized if nodemask from vma policy does not
> intersects with nodemask from cpuset. Even if it wouldn't happens it's better to
> initialize this variable explicitly than to introduce kernel oops on weird corner case.
> 
> mm/hugetlb.c: In function ???alloc_huge_page???:
> mm/hugetlb.c:1135:5: warning: ???page??? may be used uninitialized in this function
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Mel Gorman <mgorman@suse.de>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
