Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab2FNMAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:00:05 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44922 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab2FNMAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <1339663776-196-1-git-send-email-jiang.liu@huawei.com>
References: <4FD97718.6060008@kernel.org> <1339663776-196-1-git-send-email-jiang.liu@huawei.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 14 Jun 2012 07:59:42 -0400
X-Google-Sender-Auth: NFAai6VCu-tGJOMUnGBW1VlmQ30
Message-ID: <CAHGf_=p0E9_iXuDS_RNCGp2KPiU+=BO5AB6ZxqnSE57mNiyQGw@mail.gmail.com>
Subject: Re: [PATCH] trivial, memory hotplug: add kswapd_is_running() for
 better readability
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>, Keping Chen <chenkeping@huawei.com>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 4:49 AM, Jiang Liu <jiang.liu@huawei.com> wrote:
> Add kswapd_is_running() to check whether the kswapd worker thread is already
> running before calling kswapd_run() when onlining memory pages.
>
> It's based on a draft version from Minchan Kim <minchan@kernel.org>.
>
> Signed-off-by: Jiang Liu <liuj97@gmail.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
