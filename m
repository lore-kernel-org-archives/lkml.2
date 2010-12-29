Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0L2OrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:47:19 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:15560
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672Ab0L2OrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:47:18 -0500
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LE72EC-01-9HI-02
X-M-MSG: 
Date: Wed, 29 Dec 2010 15:47:02 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes for v2.6.37
Message-ID: <20101229144702.GL4739@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile fixes for v2.6.37 (tip/perf/urgent):

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

(uploaded but not yet sync'ed until now)

Thanks,

-Robert


The following changes since commit e1e359273576ee8fe27021356b064c772ed29af3:

  ring_buffer: Off-by-one and duplicate events in ring_buffer_read_page (2010-12-23 12:09:30 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Andrew Morton (1):
      arch/x86/oprofile/op_model_amd.c: perform initialisation on a single CPU

 arch/x86/oprofile/op_model_amd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

