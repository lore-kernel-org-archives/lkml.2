Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab1CXDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:09:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932207Ab1CXDJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:09:28 -0400
Date: Wed, 23 Mar 2011 20:04:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct
 reclaim path completely
Message-Id: <20110323200458.724f2af8.akpm@linux-foundation.org>
In-Reply-To: <20110324114842.CC70.A69D9226@jp.fujitsu.com>
References: <20110324111200.1AF4.A69D9226@jp.fujitsu.com>
	<20110323192150.9895afe3.akpm@linux-foundation.org>
	<20110324114842.CC70.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 11:48:19 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Thu, 24 Mar 2011 11:11:46 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > Subject: [PATCH] vmscan: remove all_unreclaimable check from direct reclaim path completely
> > 
> > zone.all_unreclaimable is there to prevent reclaim from wasting CPU
> > cycles scanning a zone which has no reclaimable pages.  When originally
> > implemented it did this very well.
> >
> > That you guys keep breaking it, or don't feel like improving it is not a
> > reason to remove it!
> > 
> > If the code is unneeded and the kernel now reliably solves this problem
> > by other means then this should have been fully explained in the
> > changelog, but it was not even mentioned.
> 
> The changelog says, the logic was removed at 2008. three years ago.
> even though it's unintentionally. and I and minchan tried to resurrect
> the broken logic and resurrected a bug in the logic too. then, we
> are discussed it should die or alive.
> 
> Which part is hard to understand for you?
> 

The part which isn't there: how does the kernel now address the problem
which that code fixed?

