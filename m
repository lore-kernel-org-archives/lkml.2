Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0L2O0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:26:30 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:45861
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab0L2O02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:26:28 -0500
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LE71FS-02-I9R-02
X-M-MSG: 
Date: Wed, 29 Dec 2010 15:26:18 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile updates for v2.6.38
Message-ID: <20101229142618.GJ4739@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile updates for v2.6.38 (tip/perf/core):

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks,

-Robert



The following changes since commit 32ae2ade462146729580117d9886cc9efd83dfbe:

  perf probe: Fix short file name probe location reporting (2010-12-27 19:48:21 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Robert Richter (2):
      oprofile, x86: Add support for AMD family 15h
      oprofile, x86: Add support for 6 counters (AMD family 15h)

 arch/x86/include/asm/msr-index.h |    4 +++
 arch/x86/oprofile/nmi_int.c      |    3 ++
 arch/x86/oprofile/op_model_amd.c |   54 +++++++++++++++++++++++++------------
 3 files changed, 43 insertions(+), 18 deletions(-)


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

