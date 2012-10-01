Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2JATJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:09:18 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58605 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab2JATJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:09:16 -0400
Date: Mon, 1 Oct 2012 15:09:05 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v3 05/13] Add a __GFP_KMEMCG flag
Message-ID: <20121001190905.GE23734@cmpxchg.org>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-6-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347977050-29476-6-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 06:04:02PM +0400, Glauber Costa wrote:
> This flag is used to indicate to the callees that this allocation is a
> kernel allocation in process context, and should be accounted to
> current's memcg. It takes numerical place of the of the recently removed
> __GFP_NO_KSWAPD.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Suleiman Souhlal <suleiman@google.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

With the feedback from Christoph and Mel incorporated:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
