Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2JCVWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:22:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:7959 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab2JCVWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,529,1344236400"; 
   d="scan'208";a="152093231"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: jolsa@redhat.com, eranian@google.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Subject: Tie lose "perf, tools" ends in Haswell PMU patchkit
Date: Wed,  3 Oct 2012 14:22:40 -0700
Message-Id: <1349299363-30714-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some left over issues in my Haswell PMU patchkit yesterday:
Ideally applied on top, although there should be no direct dependencies.

- Now the kernel supplied sysfs aliases can be directly used for cpu.
This means I can use "tx-aborts" instead of "cpu/tx-aborts/
- List the kernel events
- Support using the same names as generic events for kernel events.
This allows to use cpu/instructions,intx=1/ which was not possible
before because instructions clashed with the generic name.

-Andi

