Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1FVPWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:22:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab1FVPWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:22:21 -0400
Date: Wed, 22 Jun 2011 17:22:16 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/7] export memory cgroup's swappines by
 mem_cgroup_swappiness()
Message-ID: <20110622152216.GG14343@tiehlicka.suse.cz>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
 <20110616125222.71bcdff3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616125222.71bcdff3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-06-11 12:52:22, KAMEZAWA Hiroyuki wrote:
> From 6f9c40172947fb92ab0ea6f7d73d577473879636 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Wed, 15 Jun 2011 12:06:31 +0900
> Subject: [PATCH 2/7] export memory cgroup's swappines by mem_cgroup_swappiness()
> 
> Each memory cgroup has 'swappiness' value and it can be accessed by
> get_swappiness(memcg). The major user is try_to_free_mem_cgroup_pages()
> and swappiness is passed by argument.
> 
> It's now static function but some planned updates will need to
> get swappiness from files other than memcontrol.c
> This patch exports get_swappiness() as mem_cgroup_swappiness().
> By this, we can remove the argument of swapiness from try_to_fre...
> 
> I think this makes sense because passed swapiness is always from memory
> cgroup passed as an argument and this duplication of argument is
> not very good.

Yes makes sense and it makes it more looking like a global reclaim.

> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
