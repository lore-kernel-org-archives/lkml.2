Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab1EZNj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:39:58 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:5556 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1EZNj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:39:57 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLT1YD-01-NEO-02
X-M-MSG: 
Date: Thu, 26 May 2011 15:39:48 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes for v2.6.40
Message-ID: <20110526133948.GX20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile fixes for v2.6.40 (tip/perf/urgent):

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert



The following changes since commit a2d063ac216c1618bfc2b4d40b7176adffa63511:

  extable, core_kernel_data(): Make sure all archs define _sdata (2011-05-20 08:56:56 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Anton Blanchard (1):
      oprofile: Use linux/mutex.h

Eric B Munson (1):
      oprofile, powerpc: Handle events that raise an exception without overflowing

Robert Richter (1):
      oprofile, x86: Enable preemption during pci device setup in IBS init

 arch/powerpc/oprofile/op_model_power4.c |   24 ++++++++-
 arch/x86/oprofile/op_model_amd.c        |   95 +++++++++++++++++-------------
 drivers/oprofile/event_buffer.h         |    2 +-
 drivers/oprofile/oprof.c                |    2 +-
 4 files changed, 79 insertions(+), 44 deletions(-)


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

