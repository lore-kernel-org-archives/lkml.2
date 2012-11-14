Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423252Ab2KNSwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:52:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64514 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423016Ab2KNSwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:52:50 -0500
Date: Wed, 14 Nov 2012 10:52:45 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
Message-ID: <20121114185245.GF21185@mtj.dyndns.org>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <1352820639-13521-3-git-send-email-mhocko@suse.cz>
 <20121113161442.GA18227@mtj.dyndns.org>
 <20121114085129.GC17111@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114085129.GC17111@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Nov 14, 2012 at 09:51:29AM +0100, Michal Hocko wrote:
> > 	reclaim(root);
> > 	for_each_descendent_pre()
> > 		reclaim(descendant);
> 
> We cannot do for_each_descendent_pre here because we do not iterate
> through the whole hierarchy all the time. Check shrink_zone.

I'm a bit confused.  Why would that make any difference?  Shouldn't it
be just able to test the condition and continue?

Thanks.

-- 
tejun
