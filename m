Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab1FOPgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:36:16 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59914 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab1FOPgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:36:11 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8 v2] x86, UV: fixes to tlb shootdown
Cc: mingo@elte.hu
Message-Id: <E1QWs9h-0008Ba-6A@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 15 Jun 2011 10:37:21 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Version 1 was a series of 6 patches, submitted Jun14 2011.

Version 2 of this series:
- Adds more explanation to "UV: smp_processor_id in a preemptable region"
- Splits "UV: correct reset_with_ipi()" into its 3 logical changes
- Adds statement of importance to "UV: correct UV2 BAU destination timeout"


[PATCH 1/8 v2] x86, UV: smp_processor_id in a preemptable region
[PATCH 2/8 v2] x86, UV: inline header file functions
[PATCH 3/8 v2] x86, UV: allow for non-consecutive sockets
[PATCH 4/8 v2] x86, UV: correct reset_with_ipi()
[PATCH 5/8 v2] x86, UV: rename hubmask to pnmask
[PATCH 6/8 v2] x86, UV: remove cpumask_t from the stack
[PATCH 7/8 v2] x86, UV: correct failed topology memory leak
[PATCH 8/8 v2] x86, UV: correct UV2 BAU destination timeout
