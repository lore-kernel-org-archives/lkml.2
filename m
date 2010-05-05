Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561Ab0EEP0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:26:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759827Ab0EEP0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:26:45 -0400
Date: Wed, 5 May 2010 17:25:31 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] fix count_vm_event preempt in memory compaction direct
 reclaim
Message-ID: <20100505152531.GK5835@random.random>
References: <1271797276-31358-1-git-send-email-mel@csn.ul.ie>
 <1271797276-31358-13-git-send-email-mel@csn.ul.ie>
 <20100505121908.GA5835@random.random>
 <20100505125156.GM20979@csn.ul.ie>
 <20100505131112.GB5835@random.random>
 <20100505135537.GO20979@csn.ul.ie>
 <20100505144813.GI5835@random.random>
 <20100505151439.GQ20979@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505151439.GQ20979@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 04:14:39PM +0100, Mel Gorman wrote:
> How about the following as an alternative to dropp migrate_prep?

Yep this is what I'd like too... btw in the comments you also mention
IPI but I guess that's ok. About the cost I'm not sure but I would
expect the cost of this to be even higher because it also has to run
the scheduler unlike a real IPI.
