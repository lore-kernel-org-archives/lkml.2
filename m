Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab2ASUyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:54:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43812 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab2ASUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:54:00 -0500
Date: Thu, 19 Jan 2012 12:53:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] memcg: let css_get_next() rely upon rcu_read_lock()
Message-ID: <20120119205355.GJ5198@google.com>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
 <1326958401.1113.22.camel@edumazet-laptop>
 <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com>
 <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
 <alpine.LSU.2.00.1201191250210.29542@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1201191250210.29542@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:51:47PM -0800, Hugh Dickins wrote:
> Remove lock and unlock around css_get_next()'s call to idr_get_next().
> memcg iterators (only users of css_get_next) already did rcu_read_lock(),
> and its comment demands that; but add a WARN_ON_ONCE to make sure of it.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>

All three look good to me,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
