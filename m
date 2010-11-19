Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0KSMnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:43:13 -0500
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:54624 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011Ab0KSMnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:43:12 -0500
X-AuditID: 1209190d-b7cacae000000a14-8e-4ce670df9f48
Subject: Re: [PATCH 0/8] Use memory compaction instead of lumpy reclaim during high-order allocations
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20101119104856.GB28613@csn.ul.ie>
Date: Fri, 19 Nov 2010 07:43:02 -0500
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4B8266CB-F658-4CC8-BCA3-677C22BAFAE0@mit.edu>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie> <20101117154641.51fd7ce5.akpm@linux-foundation.org> <20101118081254.GB8135@csn.ul.ie> <20101118172627.cf25b83a.kamezawa.hiroyu@jp.fujitsu.com> <20101118083828.GA24635@cmpxchg.org> <20101118092044.GE8135@csn.ul.ie> <20101118114928.ecb2d6b0.akpm@linux-foundation.org> <20101119104856.GB28613@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 19, 2010, at 5:48 AM, Mel Gorman wrote:

> At least as long as !CONFIG_COMPACTION exists. That will be a while because
> bear in mind CONFIG_COMPACTION is disabled by default (although I believe
> some distros are enabling it at least). Maybe we should choose to deprecate
> it in 2.6.40 and delete it at the infamous time of 2.6.42? That would give
> ample time to iron out any issues that crop up with reclaim/compaction
> (what this series has turned into).

How about making the default before 2.6.40, as an initial step?

-Ted
