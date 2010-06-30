Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0F3J03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:26:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59728 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab0F3J0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:26:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/9] oom: make oom_unkillable_task() helper function
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1006211314370.8367@chino.kir.corp.google.com>
References: <20100617104637.FB86.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006211314370.8367@chino.kir.corp.google.com>
Message-Id: <20100630164726.AA40.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:26:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:
> 
> > 
> > Now, we have the same task check in two places. Unify it.
> > 
> 
> We should exclude tasks from select_bad_process() and oom_kill_process() 
> by having badness() return a score of 0, just like it's done for 
> OOM_DISABLE.

No. again, select_bad_process() have meaningful check order.


