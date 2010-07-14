Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0GNCPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:15:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56852 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab0GNCPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:15:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] vmscan: don't subtraction of unsined
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.DEB.2.00.1007132047001.14067@router.home>
References: <20100713182918.EA67.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1007132047001.14067@router.home>
Message-Id: <20100714110614.EA7B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 14 Jul 2010 11:15:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Jul 2010, KOSAKI Motohiro wrote:
> 
> > Christoph, Can we hear your opinion about to add new branch in slab-free path?
> > I think this is ok, because reclaim makes a lot of cache miss then branch
> > mistaken is relatively minor penalty. thought?
> 
> Its on the slow path so I would think that should be okay. But is this
> really necessary? Working with the per zone slab reclaim counters is not
> enough? We are adding counter after counter that have similar purposes and
> the handling gets more complex.
> 
> Maybe we can get rid of the code in the slabs instead by just relying on
> the difference of the zone counters?

Okey, I agree. I'm pending this work at once. and I'll (probably) resume it
after Nick's work merged.

Thanks.




