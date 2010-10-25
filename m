Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab0JYPqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:46:18 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:39892
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756523Ab0JYPqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:46:17 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0LAURSO-01-C83-02
X-M-MSG: 
Date: Mon, 25 Oct 2010 17:46:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile updates for v2.6.37
Message-ID: <20101025154601.GM5969@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please consider to pull AMD oprofile cpu updates for tip/perf/core and
v2.6.37:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git x86

Thanks,

-Robert


The following changes since commit d4429f608abde89e8bc1e24b43cd503feb95c496:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-10-21 21:19:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next

Robert Richter (10):
      oprofile, x86: Add support for AMD family 12h
      oprofile, x86: Add support for AMD family 14h
      oprofile, x86: Check IBS capability bits 1 and 2
      oprofile, x86: Remove duplicate check for IBS_CAPS_OPCNT
      oprofile, x86: Introduce struct ibs_state
      oprofile, x86: Add support for IBS branch target address reporting
      oprofile, x86: Add support for IBS periodic op counter extension
      Merge commit 'v2.6.36' into oprofile/core
      Merge commit 'linux-2.6/master' (early part) into oprofile/core
      Merge branch 'oprofile/core' into oprofile/x86

 arch/x86/include/asm/msr-index.h  |    1 +
 arch/x86/include/asm/perf_event.h |   19 +++---
 arch/x86/oprofile/nmi_int.c       |    6 ++
 arch/x86/oprofile/op_model_amd.c  |  120 +++++++++++++++++++++++++-----------
 4 files changed, 100 insertions(+), 46 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

