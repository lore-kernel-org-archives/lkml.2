Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2ARATp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:19:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33259 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2ARATn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:19:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 18 Jan 2012 09:18:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        leonid.moiseichuk@nokia.com, penberg@kernel.org,
        Rik van Riel <riel@redhat.com>, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>
Subject: Re: [RFC 2/3] vmscan hook
Message-Id: <20120118091824.0bde46f7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120117230801.GA903@barrios-desktop.redhat.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-3-git-send-email-minchan@kernel.org>
	<20120117173932.1c058ba4.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117091356.GA29736@barrios-desktop.redhat.com>
	<20120117190512.047d3a03.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117230801.GA903@barrios-desktop.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 08:08:01 +0900
Minchan Kim <minchan@kernel.org> wrote:

> > 
> > 
> > > > 2. can't we measure page-in/page-out distance by recording something ?
> > > 
> > > I can't understand your point. What's relation does it with swapout prevent?
> > > 
> > 
> > If distance between pageout -> pagein is short, it means thrashing.
> > For example, recoding the timestamp when the page(mapping, index) was
> > paged-out, and check it at page-in.
> 
> Our goal is prevent swapout. When we found thrashing, it's too late.
> 

If you want to prevent swap-out, don't swapon any. That's all.
Then, you can check the number of FILE_CACHE and have threshold.

Thanks,
-Kame

