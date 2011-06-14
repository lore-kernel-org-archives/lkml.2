Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1FNJtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:49:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855Ab1FNJtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:49:00 -0400
Date: Tue, 14 Jun 2011 11:48:11 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [BUGFIX][PATCH 4/5] memcg:  fix wrong check of noswap with
 softlimit
Message-ID: <20110614094811.GD6371@redhat.com>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
 <20110613121105.b8f251e2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613121105.b8f251e2.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 12:11:05PM +0900, KAMEZAWA Hiroyuki wrote:
> >From 0a0358d300330a4ba86e39ea56ed63f1e4519dfd Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Mon, 13 Jun 2011 10:31:16 +0900
> Subject: [PATCH 4/5]  fix wrong check of noswap with softlimit
> 
> Hierarchical reclaim doesn't swap out if memsw and resource limits are
> same (memsw_is_minimum == true) because we would hit mem+swap limit
> anyway (during hard limit reclaim).
> If it comes to the solft limit we shouldn't consider memsw_is_minimum at
> all because it doesn't make much sense. Either the soft limit is bellow
> the hard limit and then we cannot hit mem+swap limit or the direct
> reclaim takes a precedence.
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Johannes Weiner <jweiner@redhat.com>
