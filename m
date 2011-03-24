Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1CXKFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:05:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44433 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab1CXKFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:05:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] Accelerate OOM killing
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>
In-Reply-To: <1300960353-2596-1-git-send-email-minchan.kim@gmail.com>
References: <1300960353-2596-1-git-send-email-minchan.kim@gmail.com>
Message-Id: <20110324190534.5CC9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 24 Mar 2011 19:05:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When I test Andrey's problem, I saw the livelock and sysrq-t says
> there are many tasks in cond_resched after try_to_free_pages.
> 
> If did_some_progress is false, cond_resched could delay oom killing so
> It might be killing another task.
> 
> This patch accelerates oom killing without unnecessary giving CPU
> to another task. It could help avoding unnecessary another task killing
> and livelock situation a litte bit.
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrey Vagin <avagin@openvz.org>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





