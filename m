Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1DCJjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 05:39:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33150 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1DCJjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 05:39:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        akpm@linux-foundation.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20110401180455.GU2879@balbir.in.ibm.com>
References: <20110401222250.A894.A69D9226@jp.fujitsu.com> <20110401180455.GU2879@balbir.in.ibm.com>
Message-Id: <20110403183927.AE4D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Sun,  3 Apr 2011 18:39:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Hm. OK, I may misread.
> > > > Can you please explain the reason why de-duplication feature need to selectable and
> > > > disabled by defaut. "explicity enable" mean this feature want to spot corner case issue??
> > > 
> > > Yes, because given a selection of choices (including what you
> > > mentioned in the review), it would be nice to have
> > > this selectable.
> > 
> > It's no good answer. :-/
> 
> I am afraid I cannot please you with my answers
> 
> > Who need the feature and who shouldn't use it? It this enough valuable for enough large
> > people? That's my question point.
> > 
> 
> You can see the use cases documented, including when running Linux as
> a guest under other hypervisors, 

Which hypervisor? If this patch is unrelated 99.9999% people, shouldn't you have to reduce
negative impact?


> today we have a choice of not using
> host page cache with cache=none, but nothing the other way round.
> There are other use cases for embedded folks (in terms of controlling
> unmapped page cache), please see previous discussions.

Is there other usecase? really? Where exist?
Why do you start to talk about embedded sudenly? I reviewed this as virtualization feature
beucase you wrote so in [path 0/3]. Why do you change your point suddenly?




