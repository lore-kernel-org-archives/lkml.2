Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab2GGNtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 09:49:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:18026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab2GGNtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 09:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174486557"
Date: Sat, 7 Jul 2012 21:48:56 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 2/7] memcg: remove MEMCG_NR_FILE_MAPPED
Message-ID: <20120707134856.GB23648@localhost>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881111-5576-1-git-send-email-handai.szj@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340881111-5576-1-git-send-email-handai.szj@taobao.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 06:58:31PM +0800, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> While accounting memcg page stat, it's not worth to use MEMCG_NR_FILE_MAPPED
> as an extra layer of indirection because of the complexity and presumed
> performance overhead. We can use MEM_CGROUP_STAT_FILE_MAPPED directly.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> ---
>  include/linux/memcontrol.h |   25 +++++++++++++++++--------
>  mm/memcontrol.c            |   24 +-----------------------
>  mm/rmap.c                  |    4 ++--
>  3 files changed, 20 insertions(+), 33 deletions(-)

Nice cleanup!

Acked-by: Fengguang Wu <fengguang.wu@intel.com>
