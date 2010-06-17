Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab0FQB4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:56:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34290 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab0FQBvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/9] oom: don't try to kill oom_unkillable child
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100616144127.GA9278@barrios-desktop>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com> <20100616144127.GA9278@barrios-desktop>
Message-Id: <20100617091325.FB4B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 16, 2010 at 08:29:13PM +0900, KOSAKI Motohiro wrote:
> > Now, badness() doesn't care neigher CPUSET nor mempolicy. Then
> > if the victim child process have disjoint nodemask, __out_of_memory()
> > can makes kernel hang eventually.
> > 
> > This patch fixes it.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> This patch inclues two things. 
> 
> 1. consider cpuset and mempolicy in oom_kill_process
> 2. Simplify mempolicy oom check with nodemask != NULL 
>    in select_bad_process.
> 
> 1) change behavior but 2) is just cleanup. 
> It should have been in another patch to reivew easily. :)

Thank you. removed (2).



