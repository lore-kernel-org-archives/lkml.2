Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0JORNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:13:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:12724 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538Ab0JORNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:13:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,337,1283756400"; 
   d="scan'208";a="336597778"
Subject: Re: [PATCH 3/4] sched: drop group_capacity to 1 only if local
 group has extra capacity
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Venkatesh Pallipadi <venki@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1287162325.1998.101.camel@laptop>
References: <1286996978-7007-4-git-send-email-ncrao@google.com>
	 <1287035281-25579-1-git-send-email-ncrao@google.com>
	 <1287143423.29097.1460.camel@twins>
	 <AANLkTinotiJqfvr9D2yTkuaLDKPcaUaG1dU1goRK8Bi+@mail.gmail.com>
	 <1287162325.1998.101.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 15 Oct 2010 10:13:05 -0700
Message-Id: <1287162786.2622.16.camel@sbsiddha-MOBL3>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 10:05 -0700, Peter Zijlstra wrote:
> For regular balancing local_group will be the first, since we only
> ascend the domain tree on the local groups. But its not true for no_hz
> balancing afaikt.

Even for NOHZ, we always ascend each cpu's sched domain and the local
group is the first one always. But yes, we are depending on the local
group being the first group.

thanks,
suresh

