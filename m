Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0DPJkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 05:40:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37492 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab0DPJkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 05:40:04 -0400
Date: Fri, 16 Apr 2010 10:39:43 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Valdis.Kletnieks@vt.edu
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmscan: simplify shrink_inactive_list()
Message-ID: <20100416093943.GA19264@csn.ul.ie>
References: <20100415085420.GT2493@dastard> <20100415185310.D1A1.A69D9226@jp.fujitsu.com> <20100415192140.D1A4.A69D9226@jp.fujitsu.com> <20100415131532.GD10966@csn.ul.ie> <16363.1271355721@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <16363.1271355721@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 02:22:01PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 15 Apr 2010 14:15:33 BST, Mel Gorman said:
> 
> > Yep. I modified bloat-o-meter to work with stacks (imaginatively calling it
> > stack-o-meter) and got the following. The prereq patches are from
> > earlier in the thread with the subjects
> 
> Think that's a script worth having in-tree?

Ahh, it's a hatchet-job at the moment. I copied bloat-o-meter and
altered one function. I made a TODO note to extend bloat-o-meter
properly and that would be worth merging.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
