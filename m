Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1FHMyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:54:00 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:58873
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753199Ab1FHMx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:53:59 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMH2HN-02-6UT-02
X-M-MSG: 
Date: Wed, 8 Jun 2011 14:53:46 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes for v3.0
Message-ID: <20110608125346.GL20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1306860406-6094-1-git-send-email-robert.richter@amd.com>
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


The following changes since commit d7ebe75b065a7c2d58ffc12f9d2e00d5ea4e71eb:

  perf: Fix comments in include/linux/perf_event.h (2011-06-04 12:31:14 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Robert Richter (4):
      oprofile, x86: Add comments to IBS LVT offset initialization
      oprofile: Free potentially owned tasks in case of errors
      oprofile: Fix locking dependency in sync_start()
      oprofile, dcookies: Fix possible circular locking dependency

 arch/x86/kernel/apic/apic.c      |    3 ++-
 arch/x86/oprofile/op_model_amd.c |   13 +++++++++----
 drivers/oprofile/buffer_sync.c   |   21 +++++++++++----------
 fs/dcookies.c                    |    3 +++
 4 files changed, 25 insertions(+), 15 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

