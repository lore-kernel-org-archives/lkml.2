Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1BCXzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:55:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37497 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1BCXzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:55:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Feb 2011 08:49:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: remove impossible conditional when committing
Message-Id: <20110204084939.c3cdec51.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110203141110.GF2286@cmpxchg.org>
References: <20110203141110.GF2286@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 15:11:10 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> No callsite ever passes a NULL pointer for a struct mem_cgroup * to
> the committing function.  There is no need to check for it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

But, could you add VM_BUG_ON(!mem) here ?

Thanks,
-Kame

