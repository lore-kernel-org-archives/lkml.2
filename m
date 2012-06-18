Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2FRMWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:22:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41911 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2FRMWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:22:04 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDF1CE5.90803@jp.fujitsu.com>
Date: Mon, 18 Jun 2012 21:19:49 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        cgroups@vger.kernel.org, devel@openvz.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 17/25] skip memcg kmem allocations in specified code
 regions
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-18-git-send-email-glommer@parallels.com>
In-Reply-To: <1340015298-14133-18-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/18 19:28), Glauber Costa wrote:
> This patch creates a mechanism that skip memcg allocations during
> certain pieces of our core code. It basically works in the same way
> as preempt_disable()/preempt_enable(): By marking a region under
> which all allocations will be accounted to the root memcg.
> 
> We need this to prevent races in early cache creation, when we
> allocate data using caches that are not necessarily created already.
> 
> Signed-off-by: Glauber Costa<glommer@parallels.com>
> CC: Christoph Lameter<cl@linux.com>
> CC: Pekka Enberg<penberg@cs.helsinki.fi>
> CC: Michal Hocko<mhocko@suse.cz>
> CC: Kamezawa Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner<hannes@cmpxchg.org>
> CC: Suleiman Souhlal<suleiman@google.com>

I'm ok with this approach.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


