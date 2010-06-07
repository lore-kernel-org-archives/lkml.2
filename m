Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0FGGyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:54:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35327 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab0FGGyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:54:49 -0400
Date: Mon, 7 Jun 2010 12:24:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [cleanup][PATCH -mmotm 1/2] memcg: remove redundant codes
Message-ID: <20100607065431.GQ4603@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100607145239.cb5cb917.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100607145239.cb5cb917.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2010-06-07 14:52:39]:

> These patches are based on mmotm-2010-06-03-16-36 + some already merged patches
> for memcg.
> 
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> - try_get_mem_cgroup_from_mm() calls rcu_read_lock/unlock by itself, so we
>   don't have to call them in task_in_mem_cgroup().
> - *mz is not used in __mem_cgroup_uncharge_common().
> - we don't have to call lookup_page_cgroup() in mem_cgroup_end_migration()
>   after we've cleared PCG_MIGRATION of @oldpage.
> - remove empty comment.
> - remove redundant empty line in mem_cgroup_cache_charge().
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
