Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0DPXDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 19:03:44 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:43397 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894Ab0DPXDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 19:03:42 -0400
Date: Sat, 17 Apr 2010 01:03:32 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 07/10] vmscan: Remove unnecessary temporary variables in shrink_zone()
Message-ID: <20100416230332.GH20640@cmpxchg.org>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-8-git-send-email-mel@csn.ul.ie> <20100416115053.27A1.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416115053.27A1.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 11:51:26AM +0900, KOSAKI Motohiro wrote:
> > Two variables are declared that are unnecessary in shrink_zone() as they
> > already exist int the scan_control. Remove them
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> ok.
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

You confuse me, you added the local variables yourself in 01dbe5c9
for performance reasons.  Doesn't that still hold?
