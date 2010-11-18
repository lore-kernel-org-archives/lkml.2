Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0KRIcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:32:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48304 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab0KRIcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:32:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Nov 2010 17:26:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Use memory compaction instead of lumpy reclaim
 during high-order allocations
Message-Id: <20101118172627.cf25b83a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101118081254.GB8135@csn.ul.ie>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie>
	<20101117154641.51fd7ce5.akpm@linux-foundation.org>
	<20101118081254.GB8135@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 08:12:54 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> > > I'm hoping that this series also removes the
> > > necessity for the "delete lumpy reclaim" patch from the THP tree.
> > 
> > Now I'm sad.  I read all that and was thinking "oh goody, we get to
> > delete something for once".  But no :(
> > 
> > If you can get this stuff to work nicely, why can't we remove lumpy
> > reclaim?
> 
> Ultimately we should be able to. Lumpy reclaim is still there for the
> !CONFIG_COMPACTION case and to have an option if we find that compaction
> behaves badly for some reason.
> 

Hmm. CONFIG_COMPACTION depends on CONFIG_MMU. lumpy reclaim will be for NOMMU,
finally ?

Thanks,
-Kame

