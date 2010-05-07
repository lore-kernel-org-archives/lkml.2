Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0EGIRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:17:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48471 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0EGIRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:17:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 7 May 2010 17:13:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/2] Fix migration races in rmap_walk() V7
Message-Id: <20100507171310.4c15c4cc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1273188053-26029-1-git-send-email-mel@csn.ul.ie>
References: <1273188053-26029-1-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 May 2010 00:20:51 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> No major change since V6, just looks nicer.
> 

seems to work well in my test.
I think there is no unknown pitfalls. I'm glad if you double check my
concern for patch [1/2].

Thanks,
-Kame


