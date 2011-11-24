Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1KXACW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:02:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60986 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1KXACV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:02:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Nov 2011 09:01:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] mm: memcg: lookup_page_cgroup (almost) never
 returns NULL
Message-Id: <20111124090112.93bde2b4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322062951-1756-5-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-5-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 16:42:27 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Johannes Weiner <jweiner@redhat.com>
> 
> Pages have their corresponding page_cgroup descriptors set up before
> they are used in userspace, and thus managed by a memory cgroup.
> 
> The only time where lookup_page_cgroup() can return NULL is in the
> page sanity checking code that executes while feeding pages into the
> page allocator for the first time.
> 
> Remove the NULL checks against lookup_page_cgroup() results from all
> callsites where we know that corresponding page_cgroup descriptors
> must be allocated.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

