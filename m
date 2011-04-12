Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab1DLJ33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:29:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45009 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1DLJ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:29:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
In-Reply-To: <BANLkTi=fEejkrPdX27bFi1x+dHpOSGxQaQ@mail.gmail.com>
References: <20110411170134.035E.A69D9226@jp.fujitsu.com> <BANLkTi=fEejkrPdX27bFi1x+dHpOSGxQaQ@mail.gmail.com>
Message-Id: <20110412183010.B52A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 18:29:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi, KOSAKI
> 
> On Mon, Apr 11, 2011 at 5:01 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Currently, cpu hotplug updates pcp->stat_threashold, but memory
> > hotplug doesn't. there is no reason.
> >
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Acked-by: Mel Gorman <mel@csn.ul.ie>
> > Acked-by: Christoph Lameter <cl@linux.com>
> 
> I can think it makes sense so I don't oppose the patch merging.
> But as you know I am very keen on the description.
> 
> What is the problem if hotplug doesn't do it?
> I means the patch solves what's problem?
> 
> Please write down fully for better description.
> Thanks.

No real world issue. I found the fault by code review.
No good stat_threshold might makes performance hurt.




