Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab0LXA37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 19:29:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:48639 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0LXA36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 19:29:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,221,1291622400"; 
   d="scan'208";a="639957214"
Subject: Re: [RFC -v9 4/4] net, rds, Replace xlist in net/rds/xlist.h with
 llist
From: Huang Ying <ying.huang@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1293140819-sup-9361@think>
References: <1293083003-19577-1-git-send-email-ying.huang@intel.com>
	 <1293083003-19577-5-git-send-email-ying.huang@intel.com>
	 <1293140819-sup-9361@think>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Dec 2010 08:29:16 +0800
Message-ID: <1293150556.22308.1.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-24 at 05:51 +0800, Chris Mason wrote:
> Excerpts from Huang Ying's message of 2010-12-23 00:43:23 -0500:
> > The functionality of xlist and llist is almost same.  This patch
> > replace xlist with llist to avoid code duplication.
> 
> I'm not against it, the goal was always to move this to include/linux as
> more users popped up.  We can test it out here with rds RDMA.

Thanks for your helping.

Best Regards,
Huang Ying


