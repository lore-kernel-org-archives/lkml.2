Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab1FPMPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:15:02 -0400
Received: from relay3.sgi.com ([192.48.152.1]:41961 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756986Ab1FPMO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:14:59 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8 v3] x86, UV: fixes to tlb shootdown
Cc: mingo@elte.hu
Message-Id: <E1QXBUZ-0004ft-Om@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 16 Jun 2011 07:16:11 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Version 1 was a series of 6 patches, submitted Jun14 2011.

Version 2 of this series:
- Adds more explanation to "UV: smp_processor_id in a preemptable region"
- Splits "UV: correct reset_with_ipi()" into its 3 logical changes
- Adds statement of importance to "UV: correct UV2 BAU destination timeout"

Version 3 of this series:
- Uses get_cpu()/put_cpu() to bound the region in which cpu number is used
  in "UV: smp_processor_id in a preemptable region"


[PATCH 1/8 v3] x86, UV: smp_processor_id in a preemptable region
[PATCH 2/8 v3] x86, UV: inline header file functions
[PATCH 3/8 v3] x86, UV: allow for non-consecutive sockets
[PATCH 4/8 v3] x86, UV: correct reset_with_ipi()
[PATCH 5/8 v3] x86, UV: rename hubmask to pnmask
[PATCH 6/8 v3] x86, UV: remove cpumask_t from the stack
[PATCH 7/8 v3] x86, UV: correct failed topology memory leak
[PATCH 8/8 v3] x86, UV: correct UV2 BAU destination timeout
