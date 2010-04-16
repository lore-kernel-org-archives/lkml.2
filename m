Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab0DPXeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 19:34:11 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:60756 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0DPXeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 19:34:09 -0400
Date: Sat, 17 Apr 2010 01:34:05 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 10/10] vmscan: Update isolated page counters outside of main path in shrink_inactive_list()
Message-ID: <20100416233405.GK20640@cmpxchg.org>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-11-git-send-email-mel@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271352103-2280-11-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:21:43PM +0100, Mel Gorman wrote:
> When shrink_inactive_list() isolates pages, it updates a number of
> counters using temporary variables to gather them. These consume stack
> and it's in the main path that calls ->writepage(). This patch moves the
> accounting updates outside of the main path to reduce stack usage.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
