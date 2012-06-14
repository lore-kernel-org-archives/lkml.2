Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2FNPEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:04:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41768 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab2FNPEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:04:47 -0400
Date: Fri, 15 Jun 2012 00:04:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>, Keping Chen <chenkeping@huawei.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH] trivial, memory hotplug: add kswapd_is_running() for
 better readability
Message-ID: <20120614150434.GC2097@barrios>
References: <4FD97718.6060008@kernel.org>
 <1339663776-196-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339663776-196-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 04:49:36PM +0800, Jiang Liu wrote:
> Add kswapd_is_running() to check whether the kswapd worker thread is already
> running before calling kswapd_run() when onlining memory pages.
> 
> It's based on a draft version from Minchan Kim <minchan@kernel.org>.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>

Reviewed-by: Minchan Kim <minchan@kernel.org>

Thanks!

