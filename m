Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1I2PE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:04:26 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55678 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab1I2PEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:04:25 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LSAHUZ-01-AOU-02
X-M-MSG: 
Date: Thu, 29 Sep 2011 17:04:13 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile updates for v3.2
Message-ID: <20110929150413.GP6063@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile updates for v3.2 (tip/perf/core):

  git://amd64.org/linux/rric.git core

Thanks,

-Robert


The following changes since commit d6eed550a9d08fbd1fce32e517e8c49afa6edbf7:

  x86: Perf_event_amd.c needs <asm/apicdef.h> (2011-09-27 19:55:09 +0200)

are available in the git repository at:
  git://amd64.org/linux/rric.git core

Maarten Lankhorst (1):
      oprofile, x86: Convert memory allocation to static array

Robert Richter (1):
      oprofile, x86: Fix overflow and warning (commit 1d12d35)

 arch/x86/oprofile/op_model_ppro.c |   27 ++-------------------------
 1 files changed, 2 insertions(+), 25 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

