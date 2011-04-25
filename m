Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab1DYJ1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:27:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44122 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab1DYJ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:27:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Hennerich <michael.hennerich@analog.com>,
        device-driver-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] blackfin: convet cpumask apis
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110425182906.2673.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 18:27:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rusty Russle introduced a lot of cpumask related APIs. and He gone even
though the work is unfinished. This patch series is sequel of his work.

No functional change. only api change.

note: I've confirmed only cross-compile build. so, I hope blackfin
developers see the code.


KOSAKI Motohiro (4):
  blackfin: remove unused function
  blackfin: don't touch cpu_possible_map and cpu_present_map directly
  blackfin: don't touch task->cpus_allowed directly
  blackfin: convert old cpumask API to new one

 arch/blackfin/kernel/nmi.c                  |    8 ++--
 arch/blackfin/kernel/process.c              |    6 +--
 arch/blackfin/kernel/setup.c                |    4 +-
 arch/blackfin/mach-bf561/include/mach/smp.h |    2 -
 arch/blackfin/mach-bf561/smp.c              |   27 ++++-------
 arch/blackfin/mach-common/dpmc.c            |    7 ++-
 arch/blackfin/mach-common/smp.c             |   27 ++++++-----


