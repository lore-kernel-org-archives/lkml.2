Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab0KPAxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 19:53:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:40415 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0KPAxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 19:53:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,203,1288594800"; 
   d="scan'208";a="349121651"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v4 0/2] Lockless memory allocator and list
Date: Tue, 16 Nov 2010 08:53:09 +0800
Message-Id: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Len,

This patchset is needed by APEI support. Which involves some lockless
operations. And I think they can be used by some other part of kernel
too.

v4:

- Split from APEI patchset
- Update patch description and comments according to ML comments

v3:

- Rework lockless memory allocator and list according to ML comments

[PATCH -v4 1/2] lib, Make gen_pool memory allocator lockless
[PATCH -v4 2/2] lib, Add lock-less NULL terminated single list
