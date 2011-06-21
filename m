Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1FUMWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:22:45 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33402 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754793Ab1FUMWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:22:43 -0400
Message-Id: <20110621122125.688884227@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 21 Jun 2011 07:21:25 -0500
From: cpw@sgi.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [patch 0/8 v5] Subject: x86, UV: fixes to tlb shootdown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 1 was a series of 6 patches, submitted Jun14 2011.

Version 2 of this series: 8 patches
- Adds more explanation to "UV: smp_processor_id in a preemptable region"
- Splits "UV: correct reset_with_ipi()" into its 3 logical changes
- Adds statement of importance to "UV: correct UV2 BAU destination timeout"

Version 3 of this series:
- Uses get_cpu()/put_cpu() to bound the region in which cpu number is used
  in "UV: smp_processor_id in a preemptable region"

Version 4 of this series:
- cc's x86@kernel.org
- Moves non-change notes out of the changelog text

Version 5 of this series:
- removes the Diffed against tags

[PATCH 1/8 v5] x86, UV: smp_processor_id in a preemptable region
[PATCH 2/8 v5] x86, UV: inline header file functions
[PATCH 3/8 v5] x86, UV: allow for non-consecutive sockets
[PATCH 4/8 v5] x86, UV: correct reset_with_ipi()
[PATCH 5/8 v5] x86, UV: rename hubmask to pnmask
[PATCH 6/8 v5] x86, UV: remove cpumask_t from the stack
[PATCH 7/8 v5] x86, UV: correct failed topology memory leak
[PATCH 8/8 v5] x86, UV: correct UV2 BAU destination timeout

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
