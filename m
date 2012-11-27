Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab2K0Jy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:54:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342Ab2K0Jyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:54:54 -0500
Date: Tue, 27 Nov 2012 10:54:52 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121127095452.GD20537@dhcp22.suse.cz>
References: <20121122233434.3D5E35E6@pobox.sk>
 <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121125011047.7477BB5E@pobox.sk>
 <20121125120524.GB10623@dhcp22.suse.cz>
 <20121125135542.GE10623@dhcp22.suse.cz>
 <20121126013855.AF118F5E@pobox.sk>
 <20121126131837.GC17860@dhcp22.suse.cz>
 <50B403CA.501@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B403CA.501@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-11-12 09:05:30, KAMEZAWA Hiroyuki wrote:
[...]
> As a short term fix, I think this patch will work enough and seems simple enough.
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks!
If Johannes is also ok with this for now I will resubmit the patch to
Andrew after I hear back from the reporter.
 
> Reading discussion between you and Johannes, to release locks, I understand
> the memcg need to return "RETRY" for a long term fix. Thinking a little,
> it will be simple to return "RETRY" to all processes waited on oom kill queue
> of a memcg and it can be done by a small fixes to memory.c.

I wouldn't call it simple but it is doable.
-- 
Michal Hocko
SUSE Labs
