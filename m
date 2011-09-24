Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1IXQ6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 12:58:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:44890 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab1IXQ6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 12:58:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,435,1312182000"; 
   d="scan'208";a="55235635"
From: Andi Kleen <andi@firstfloor.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name
Subject: Re: [PATCH v3 6/7] tcp buffer limitation: per-cgroup limit
References: <1316393805-3005-1-git-send-email-glommer@parallels.com>
	<1316393805-3005-7-git-send-email-glommer@parallels.com>
Date: Sat, 24 Sep 2011 09:58:14 -0700
In-Reply-To: <1316393805-3005-7-git-send-email-glommer@parallels.com> (Glauber
	Costa's message of "Sun, 18 Sep 2011 21:56:44 -0300")
Message-ID: <m24o01khcp.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <glommer@parallels.com> writes:

> This patch uses the "tcp_max_mem" field of the kmem_cgroup to
> effectively control the amount of kernel memory pinned by a cgroup.
>
> We have to make sure that none of the memory pressure thresholds
> specified in the namespace are bigger than the current cgroup.

I noticed that some other OS known by bash seem to have a rlimit per
process for this. Would that make sense too? Not sure how difficult
your infrastructure would be to extend to that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
