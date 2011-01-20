Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1ATD0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 22:26:17 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:56741 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab1ATD0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 22:26:15 -0500
Message-Id: <20110120031729.055590217@efficios.com>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 22:17:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/3] Fix alignment of custom sections made from structures
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Thu, 20 Jan 2011 03:25:57 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is a patchset that fixes the Ftrace-induced crash experienced on sparc64
discussed in the following thread: https://lkml.org/lkml/2011/1/16/2

The third patch changes the Tracepoints to use the more compact alignment scheme
proposed here, even though their alignment on 32-byte works fine. This third
patch is therefore not a fix per se.

The patchset is based on 2.6.37. Hopefully there are not too many things to
update for the current -git.

Comments, flames as well as acclamation are welcome. ;-)

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
