Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2BNHVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:21:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39050 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2BNHVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:21:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120214120640.ef2ef23a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com> <20120214120640.ef2ef23a.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Mon, 13 Feb 2012 23:21:13 -0800
Message-ID: <CAHH2K0a8h5dSWp2-TXW3s2LKnv2d0c6Z9fTBc0UxKdx=H6pSRg@mail.gmail.com>
Subject: Re: [PATCH 1/6 v4] memcg: remove EXPORT_SYMBOL(mem_cgroup_update_page_stat)
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 7:06 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> This is just a cleanup.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 2 Feb 2012 12:05:41 +0900
> Subject: [PATCH 1/6] memcg: remove EXPORT_SYMBOL(mem_cgroup_update_page_stat)
>
> From the log, I guess EXPORT was for preparing dirty accounting.
> But _now_, we don't need to export this. Remove this for now.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Looks good to me.

Reviewed-by: Greg Thelen <gthelen@google.com>

> ---
>  mm/memcontrol.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ab315ab..4c2b759 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1897,7 +1897,6 @@ out:
>                move_unlock_page_cgroup(pc, &flags);
>        rcu_read_unlock();
>  }
> -EXPORT_SYMBOL(mem_cgroup_update_page_stat);
>
>  /*
>  * size of first charge trial. "32" comes from vmscan.c's magic value.
> --
> 1.7.4.1
