Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1ICSFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 14:05:33 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51764 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab1ICSFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 14:05:31 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Sep 2011 14:05:30 EDT
Message-Id: <20110903174721.390074195@efficios.com>
User-Agent: quilt/0.48-1
Date: Sat, 03 Sep 2011 13:47:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, lenb@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC patch 0/2] API renaming: "llist" (lockless list) to "llstack" (lockless stack)
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sat,  3 Sep 2011 17:55:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am proposing these 2 patches:

1) Rename the llist API into llstack
2) make llstack_push return "prior empty state" information

The API change in (2) assumes that this "lockless list" behaves like a
stack. Having a "list" API that has a stack behavior cast in stone does
not make sense, but nevertheless some stack properties are really
useful. So reflect the behavior of the lockless structure (stack/lifo)
into the API.

These patches apply on Linux v3.1-rc4.

Comments are welcome,

Best regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
