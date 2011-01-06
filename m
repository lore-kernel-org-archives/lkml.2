Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1AFJ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:57:10 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50171 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab1AFJ5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:57:09 -0500
Date: Thu, 6 Jan 2011 09:56:47 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>
Subject: Re: [RFC 3/5] tlbfs: Remove unnecessary page release
Message-ID: <20110106095647.GC29257@csn.ul.ie>
References: <cover.1292604745.git.minchan.kim@gmail.com> <08549e97645f7d6c2bcc5c760a24fde56dfed513.1292604745.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <08549e97645f7d6c2bcc5c760a24fde56dfed513.1292604745.git.minchan.kim@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 02:13:38AM +0900, Minchan Kim wrote:
> This patch series changes remove_from_page_cache's page ref counting
> rule. page cache ref count is decreased in remove_from_page_cache.
> So we don't need call again in caller context.
> 
> Cc: William Irwin <wli@holomorphy.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Other than the subject calling hugetlbfs tlbfs, I did not see any problem
with this assuming the first patch of the series is also applied.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
