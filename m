Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1G2AJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 20:09:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:15660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab1G2AJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 20:09:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31560650"
Subject: Re: [PATCH] kswapd: assign new_order and new_classzone_idx after
 wakeup in sleeping
From: "Alex,Shi" <alex.shi@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrea@cpushare.com" <andrea@cpushare.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <20110728111203.GM3010@suse.de>
References: <1311840688-11388-1-git-send-email-alex.shi@intel.com>
	 <20110728101943.GI3010@suse.de> <1311850029.27358.2408.camel@debian>
	 <20110728111203.GM3010@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 08:10:38 +0800
Message-ID: <1311898238.27358.2416.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Post to linux-mm, cc me.
> 
> > > Acked-by: Mel Gorman <mgorman@suse.de>
> > > 
> > > It won't be merged to -stable until it goes to mainline though so
> > > minimally you need to post this to linux-mm.
> > > 
> > > For -stable, you should explain why it is a candidate. I didn't push
> > > the patch at the time because user problems were already resolved
> > > and I wanted the merged for 3.0 before revisiting it. What problem
> > > did you observe without this patch? With the lack of reference to
> > > the other thread or the previous patch, I'm assuming you found and
> > > solved the problem independently and I'd like to add a test case.
> > 
> > Actually, our LKP testing didn't find this problem on this point. Even
> > with the patch, performance has no change on our machines. I just find
> > this by my eyes. 
> > 
> 
> Dang. I figured all right that it was unlikely the patch would
> actually fix any problem but it looks correct and shouldnt' cause a
> regression. You should resend the patch to Andrew cc'ing the people
> in the old thread and linux-mm and ask Padraig Brady to test the
> patch to confirm his problem does not reappear. When it gets into
> mainline, try for -stable but I think there is very little motivation
> for merging it there.

Thanks a lot for the suggestions. I will do them. 

