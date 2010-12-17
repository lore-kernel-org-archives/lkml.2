Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0LQAUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:20:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:37451 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab0LQAUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:20:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,358,1288594800"; 
   d="scan'208";a="869123685"
Subject: Re: [PATCH -mm -v8 0/3] Lockless memory allocator and list
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1292491467.6803.4327.camel@twins>
References: <1292482744-12953-1-git-send-email-ying.huang@intel.com>
	 <1292491467.6803.4327.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 08:20:32 +0800
Message-ID: <1292545232.12648.1236.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 17:24 +0800, Peter Zijlstra wrote:
> On Thu, 2010-12-16 at 14:59 +0800, Huang Ying wrote:
> > This patchset adds a lockless memory allocator and a lock-less
> > list.
> 
> Still no users the allocator, and no attempt to unify the existing
> lockless list implementations.
> 
> I'm getting very tired of this Huang.

I just want to do that in the next step after merging the data structure
itself. The first user of the allocator is APEI, which will go ACPI
tree, lockless list in irq_work will go tip tree, lockless list in xlist
will go net tree.

We must merge the data structure with its users together?

Best Regards,
Huang Ying


