Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0FPQIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:08:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:33958 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210Ab0FPQGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:06:34 -0400
Message-Id: <20100616160027.590430763@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 16 Jun 2010 18:00:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/8] perf pmu interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches prepare the perf code for multiple pmus (no user
interface yet, Lin Ming is working on that). These patches remove all
weak functions and rework the struct pmu interface.

The latter is inspired by the work Frederic is doing to to filter out
IRQ contexts.

These patches are very prelimenary, they haven't seen a compiler yet and
the last patch still needs sparc,ppc and arm converted.

But they patches seem to be in a good enough shape to see what people
think..

comments?

