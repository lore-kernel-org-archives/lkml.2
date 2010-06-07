Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0FGGGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:06:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47550 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0FGGGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:06:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Jun 2010 15:02:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [cleanup][PATCH -mmotm 1/2] memcg: remove redundant codes
Message-Id: <20100607150207.6971b8b9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100607145239.cb5cb917.nishimura@mxp.nes.nec.co.jp>
References: <20100607145239.cb5cb917.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010 14:52:39 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

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
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


