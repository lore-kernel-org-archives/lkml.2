Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1ATAqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:46:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:54919 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab1ATAqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:46:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,347,1291622400"; 
   d="scan'208";a="698601065"
Subject: Re: [PATCH -v10 0/4] Lock-less list
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20110119135546.bb7e8f62.akpm@linux-foundation.org>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	 <20110119135546.bb7e8f62.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 08:45:58 +0800
Message-ID: <1295484358.15213.25.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 05:55 +0800, Andrew Morton wrote:
> I'm trying to remember why we're talking about this.
> 
> You had an ACPI-based "hardware error reporting" thing.  And that
> required an nmi-context memory allocator.  And that required a
> "lockless" list implementation.
> 
> Yes?

Yes.  But the "lockless" list implementation is general, it can be used
by other part of kernel too,  such as irq_work and xlist in
net/rds/xlist.h in the patchset.

Best Regards,
Huang Ying


