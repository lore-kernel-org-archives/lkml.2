Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2KNIkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:40:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab2KNIkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:40:16 -0500
Date: Wed, 14 Nov 2012 09:40:14 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] rework mem_cgroup iterator
Message-ID: <20121114084014.GB17111@dhcp22.suse.cz>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <50A3C42F.9020901@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A3C42F.9020901@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-11-12 17:17:51, Glauber Costa wrote:
[...]
> Why can't we reuse the scheduler iterator and move it to kernel/cgroup.c?

I do not care much about the internal implementation of the core
iterators. Those implemented by Tejun make sense to me. I just want to
get rid of css->id based ones.

Memcg iterator, however, still needs its own iterator on top because we
have to handle the parallel reclaimers.
[...]
-- 
Michal Hocko
SUSE Labs
