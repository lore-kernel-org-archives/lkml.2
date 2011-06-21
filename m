Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1FUMw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:52:28 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4270 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1FUMw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:52:27 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN5539-01-H4V-02
X-M-MSG: 
Date: Tue, 21 Jun 2011 14:52:20 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes for v3.0
Message-ID: <20110621125219.GZ20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile fixes for v3.0 (tip/perf/urgent):

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert


The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:

  Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Robert Richter (2):
      oprofile, x86: Fix race in nmi handler while starting counters
      oprofile, x86: Fix nmi-unsafe callgraph support

 arch/x86/oprofile/backtrace.c |   56 ++++++++++++++++++++++++++++++++++------
 arch/x86/oprofile/nmi_int.c   |   14 +++++++---
 2 files changed, 57 insertions(+), 13 deletions(-)


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

