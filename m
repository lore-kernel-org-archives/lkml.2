Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2JQWJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:09:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2JQWJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:09:10 -0400
Date: Wed, 17 Oct 2012 15:09:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 05/14] Add a __GFP_KMEMCG flag
In-Reply-To: <1350382611-20579-6-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1210171508530.20712@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-6-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Glauber Costa wrote:

> This flag is used to indicate to the callees that this allocation is a
> kernel allocation in process context, and should be accounted to
> current's memcg. It takes numerical place of the of the recently removed
> __GFP_NO_KSWAPD.
> 
> [ v4: make flag unconditional, also declare it in trace code ]
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Suleiman Souhlal <suleiman@google.com>
> CC: Tejun Heo <tj@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
