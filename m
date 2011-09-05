Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab1IECBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 22:01:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:34750 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab1IECA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 22:00:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,330,1312182000"; 
   d="scan'208";a="45552964"
Message-ID: <4E642D55.7010500@intel.com>
Date: Mon, 05 Sep 2011 10:00:53 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, "lenb@kernel.org" <lenb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC patch 1/2] Rename the "llist" (lockless list) to "llstack"
 (lockless stack)
References: <20110903174721.390074195@efficios.com> <20110903175543.363519825@efficios.com>
In-Reply-To: <20110903175543.363519825@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO, I prefer to keep "llist" as the name of the best general lock-less
list we can implemented.  Maybe in the future we can replace the
implementation totally, or add/change its API.  I don't like the name of
"llstack" because we don't want to implement or use a lock-less stack,
we just can only implement stack like operations so far,  maybe in the
future we can work out some solution for other operations.

Best Regards,
Huang Ying

