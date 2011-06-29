Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1F2NAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 09:00:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64792 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1F2NAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 09:00:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110629190325.28aa2dc6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110629190325.28aa2dc6.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 29 Jun 2011 18:30:44 +0530
Message-ID: <BANLkTikavaLfBxHnpVQYwnHjJn-Sa_UD0w@mail.gmail.com>
Subject: Re: [PATCH] [Cleanup] memcg: export memory cgroup's swappiness v2
From: Balbir Singh <bsingharora@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 3:33 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> This is onto 3 patches I posted yesterday.
> I'm sorry I once got Acks in v1 but refleshed totally.
> ==
> From fda72071ee473be1caee163920da0f5c397c95e8 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Wed, 29 Jun 2011 18:24:49 +0900
> Subject: [PATCH] export memory cgroup's swappines
>
> Each memory cgroup has 'swappiness' value and it can be accessed by
> get_swappiness(memcg). The major user is try_to_free_mem_cgroup_pages()
> and swappiness is passed by argument. It's propagated by scan_control.
>
> get_swappiness is static function but some planned updates will need to
> get swappiness from files other than memcontrol.c
> This patch exports get_swappiness() as mem_cgroup_swappiness().
> By this, we can remove the argument of swapiness from try_to_free...
> and drop swappiness from scan_control. only memcg uses it.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Good refactoring

Acked-by: Balbir Singh <bsingharora@gmail.com>

Thanks,
Balbir Singh
