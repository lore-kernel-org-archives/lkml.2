Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0F3J01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:26:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59721 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab0F3J0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:26:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/9] oom: cleanup has_intersects_mems_allowed()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1006211305590.8367@chino.kir.corp.google.com>
References: <20100617134601.FBA7.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006211305590.8367@chino.kir.corp.google.com>
Message-Id: <20100628192237.389F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:26:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 21 Jun 2010, KOSAKI Motohiro wrote:
> 
> > > I disagree that the renaming of the variables is necessary, please simply 
> > > change the while (tsk != start) to use while_each_thread(tsk, start);
> > 
> > This is common naming rule of while_each_thread(). please grep.
> > 
> 
> I disagree, there's no sense in substituting variable names like "tsk" for 
> `p' and removing a very clear and obvious "start" task: it doesn't improve 
> code readability.
> 
> I'm in favor of changing the while (tsk != start) to 
> while_each_thread(tsk, start) which is very trivial to understand and much 
> more readable than while_each_thread(p, tsk).  With the latter, it's not 
> clear whether `p' or "tsk" is the iterator and which is the constant.

Heh, I'm ok this. It isn't big matter at all.




