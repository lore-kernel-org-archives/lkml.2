Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab2HJRaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:30:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab2HJRaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:30:02 -0400
Date: Fri, 10 Aug 2012 19:30:00 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 02/11] memcg: Reclaim when more than one page needed.
Message-ID: <20120810173000.GB14591@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-3-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344517279-30646-3-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 09-08-12 17:01:10, Glauber Costa wrote:
[...]
> For now retry up to COSTLY_ORDER (as page_alloc.c does) and make sure
> not to do it if __GFP_NORETRY.

Who is using __GFP_NORETRY for user backed memory (except for hugetlb
which has its own controller)?

-- 
Michal Hocko
SUSE Labs
