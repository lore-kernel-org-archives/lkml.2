Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2F2SDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:03:36 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:31815
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754246Ab2F2SDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:03:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz936eI4015Izz1202hzz8275dhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M6E4T7-01-647-02
X-M-MSG: 
Date: Fri, 29 Jun 2012 20:03:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Will Deacon <will.deacon@arm.com>
Subject: [GIT PULL] oprofile: updates for tip/perf/core
Message-ID: <20120629180304.GZ24632@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Mailer: git-send-email 1.6.6
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

it's only one patch (oprofile, perf: Use per-cpu framework), please
pull from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Note: This pull request implicitly pulls tip/perf/urgent into
tip/perf/core. Hope this is ok to you. This is due to the reason my
patch depends on Will Deacon's patch that is in urgent.

Thanks,

-Robert


The following changes since commit add79461a2a7d964a00b4a2fdaf313c4cf9cf4ec:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-06-29 15:11:26 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Ingo Molnar (1):
      Merge branch 'tip/perf/urgent-2' of git://git.kernel.org/.../rostedt/linux-trace into perf/urgent

Robert Richter (1):
      oprofile, perf: Use per-cpu framework

Steven Rostedt (1):
      ftrace: Make all inline tags also include notrace

Will Deacon (1):
      oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static array

 drivers/oprofile/oprofile_perf.c |   23 +++++++++++------------
 include/linux/compiler-gcc.h     |    6 +++---
 2 files changed, 14 insertions(+), 15 deletions(-)

