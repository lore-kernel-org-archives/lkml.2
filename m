Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2JJJ1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:27:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab2JJJ1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:27:04 -0400
Date: Wed, 10 Oct 2012 11:27:00 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-linus] memcg, kmem: fix build error when CONFIG_INET
 is disabled
Message-ID: <20121010092700.GD23011@dhcp22.suse.cz>
References: <alpine.DEB.2.00.1210092325500.9528@chino.kir.corp.google.com>
 <5075383A.1000001@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5075383A.1000001@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-10-12 12:56:26, Glauber Costa wrote:
> On 10/10/2012 10:32 AM, David Rientjes wrote:
> > Commit e1aab161e013 ("socket: initial cgroup code.") causes a build error 
> > when CONFIG_INET is disabled in Linus' tree:
> > 
> unlikely that something that old would cause a build bug now, specially
> that commit, that actually wraps things inside CONFIG_INET.
> 
> More likely caused by the recently merged
> "memcg-cleanup-kmem-tcp-ifdefs.patch" in -mm by mhocko (CC'd)

Strange it didn't trigger during my (and Fenguang) build testing.

> As a matter of fact, I just tested, and it indeed start failing after
> that patch.
> 
> Michal, since it is just a cleanup patch, I'd prefer just reverting if
> you are okay with it.

I think that taking David's patch makes more sense.

-- 
Michal Hocko
SUSE Labs
