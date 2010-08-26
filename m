Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0HZSLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:11:01 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:38495 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0HZSK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:10:58 -0400
Date: Thu, 26 Aug 2010 20:10:50 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] writeback: Account for time spent congestion_waited
Message-ID: <20100826181050.GA6805@cmpxchg.org>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <1282835656-5638-2-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282835656-5638-2-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:14:14PM +0100, Mel Gorman wrote:
> There is strong evidence to indicate a lot of time is being spent in
> congestion_wait(), some of it unnecessarily. This patch adds a
> tracepoint for congestion_wait to record when congestion_wait() occurred
> and how long was spent.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
