Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2GFIWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:22:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53488 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab2GFIWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:22:52 -0400
Date: Fri, 6 Jul 2012 10:22:42 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: add BUG() to mem_cgroup_reset
Message-ID: <20120706082242.GA1230@cmpxchg.org>
References: <1341546297-6223-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341546297-6223-1-git-send-email-liwp.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 11:44:57AM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Branch in mem_cgroup_reset only can be RES_MAX_USAGE, RES_FAILCNT.

And nobody is passing anything else.  Which is easy to prove as this
is a private function.  And there wouldn't even be any harm passing
something else.  Please don't add stuff like this.
