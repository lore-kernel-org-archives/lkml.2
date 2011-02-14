Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1BNTtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:49:46 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:22994
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751475Ab1BNTto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:49:44 -0500
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGMHQG-01-8XN-02
X-M-MSG: 
Date: Mon, 14 Feb 2011 20:49:29 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes for v2.6.38
Message-ID: <20110214194929.GX5874@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile fixes for tip/perf/urgent (v2.6.38):

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert



The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next

Ari Kauppi (2):
      oprofile: Fix usage of CONFIG_HW_PERF_EVENTS for oprofile_perf_init and friends
      ARM: oprofile: Fix backtraces in timer mode

 arch/arm/oprofile/common.c |   12 ++----------
 include/linux/oprofile.h   |   13 +++++++++++--
 2 files changed, 13 insertions(+), 12 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

