Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1GDKXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:23:53 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:46902
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482Ab1GDKXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:23:52 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LNT0VN-01-2PY-02
X-M-MSG: 
Date: Mon, 4 Jul 2011 12:23:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile updates for v3.1
Message-ID: <20110704102344.GW4590@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile updates for v3.1 (tip/perf/core):

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks,

-Robert


The following changes since commit 29dfc4fd7e792854b30d771d4e299fbdd2adb763:

  perf, powerpc: Fix build borkage (2011-07-01 16:20:04 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Daniel Kalmar (2):
      MIPS: Add new unwind_stack variant
      MIPS: oprofile: Add callgraph support

Robert Richter (3):
      oprofile, x86: Fix race in nmi handler while starting counters
      oprofile, x86: Fix nmi-unsafe callgraph support
      Merge branch 'oprofile/urgent' into HEAD

 arch/mips/include/asm/stacktrace.h |    4 +
 arch/mips/kernel/process.c         |   19 +++-
 arch/mips/oprofile/Makefile        |    2 +-
 arch/mips/oprofile/backtrace.c     |  175 ++++++++++++++++++++++++++++++++++++
 arch/mips/oprofile/common.c        |    1 +
 arch/mips/oprofile/op_impl.h       |    2 +
 arch/x86/oprofile/backtrace.c      |   56 ++++++++++--
 arch/x86/oprofile/nmi_int.c        |   14 ++-
 8 files changed, 254 insertions(+), 19 deletions(-)
 create mode 100644 arch/mips/oprofile/backtrace.c


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

