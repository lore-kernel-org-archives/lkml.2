Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0LWIbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:31:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:7970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab0LWIbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:31:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,218,1291622400"; 
   d="scan'208";a="871219529"
Subject: Re: [RFC -v9 0/4] Lock-less list
From: Huang Ying <ying.huang@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <23265.1293084340@localhost>
References: <1293083003-19577-1-git-send-email-ying.huang@intel.com>
	 <23265.1293084340@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 16:31:19 +0800
Message-ID: <1293093079.8743.179.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Valdis,

Thanks for your comments.

On Thu, 2010-12-23 at 14:05 +0800, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 23 Dec 2010 13:43:19 +0800, Huang Ying said:
> > Add a lock-less NULL-terminated linked list implementation.  And use
> > that in irq_work and replace net/rds/xlist.h.
> 
> A quick overview of the code looks mostly sane.  What I don't see is
> an explanation of *why* this is being added.  What benefits does it
> have over the current code?  Is it faster? Smaller?  Simply getting rid
> of near-duplicate versions in rds and irq_work? Something else?

The code is almost same.  Just to avoid code duplicating, provide better
document, and make it easier for future users.

Best Regards,
Huang Ying



