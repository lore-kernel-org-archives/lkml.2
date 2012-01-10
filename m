Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2AJJo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:44:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab2AJJo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:44:56 -0500
Date: Tue, 10 Jan 2012 09:44:52 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: fix setting reclaim mode
Message-ID: <20120110094452.GC4118@suse.de>
References: <CAJd=RBAqzawZ=jEFt7TrZgU0gaejMkfiBxzH7Y19qqNnsZrJGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBAqzawZ=jEFt7TrZgU0gaejMkfiBxzH7Y19qqNnsZrJGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 03:05:03PM +0800, Hillf Danton wrote:
> The check for under memory pressure is corrected, then lumpy reclaim or
> reclaim/compaction could be avoided either when for order-O reclaim or
> when free pages are already low enough.
> 

No explanation of problem, how this patch fixes it or what the impact
is.

At a glance, this will have the impact of using sync reclaim at low
reclaim priorities. This is unexpected so needs much better explanation.

-- 
Mel Gorman
SUSE Labs
