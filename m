Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab0EZLWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:22:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38992 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759179Ab0EZLWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:22:02 -0400
Date: Wed, 26 May 2010 12:21:43 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 07/10] vmscan: Remove unnecessary temporary variables
	in shrink_zone()
Message-ID: <20100526112143.GM29038@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-8-git-send-email-mel@csn.ul.ie> <20100416115053.27A1.A69D9226@jp.fujitsu.com> <20100416230332.GH20640@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100416230332.GH20640@cmpxchg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 01:03:32AM +0200, Johannes Weiner wrote:
> On Fri, Apr 16, 2010 at 11:51:26AM +0900, KOSAKI Motohiro wrote:
> > > Two variables are declared that are unnecessary in shrink_zone() as they
> > > already exist int the scan_control. Remove them
> > > 
> > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > 
> > ok.
> > 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> You confuse me, you added the local variables yourself in 01dbe5c9
> for performance reasons.  Doesn't that still hold?
> 

To avoid a potential regression, I've dropped the patch.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
