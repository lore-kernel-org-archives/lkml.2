Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2FNLuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:50:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48970 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2FNLuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:50:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD9CF85.1030609@jp.fujitsu.com>
Date: Thu, 14 Jun 2012 20:48:21 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: Minchan Kim <minchan@kernel.org>, Keping Chen <chenkeping@huawei.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH] trivial, memory hotplug: add kswapd_is_running() for
 better readability
References: <4FD97718.6060008@kernel.org> <1339663776-196-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1339663776-196-1-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/14 17:49), Jiang Liu wrote:
> Add kswapd_is_running() to check whether the kswapd worker thread is already
> running before calling kswapd_run() when onlining memory pages.
> 
> It's based on a draft version from Minchan Kim<minchan@kernel.org>.
> 
> Signed-off-by: Jiang Liu<liuj97@gmail.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

