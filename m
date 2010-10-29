Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab0J2KEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 06:04:31 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:13318 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933627Ab0J2KE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 06:04:28 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i2a8h)
X-WSS-ID: 0LB1QN7-02-1BN-02
X-M-MSG: 
Date: Fri, 29 Oct 2010 12:04:20 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes for v2.6.37
Message-ID: <20101029100420.GF5969@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile fixes v2.6.37:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert


The following changes since commit e25804a0327dad954f7d43803178fdef2fd35b4e:

  Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 into perf/urgent (2010-10-27 08:25:15 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next

Santosh Shilimkar (1):
      oprofile: Fix the hang while taking the cpu offline

Tejun Heo (1):
      oprofile: Remove deprecated use of flush_scheduled_work()

 drivers/oprofile/buffer_sync.c |    2 +-
 drivers/oprofile/cpu_buffer.c  |   10 +++++++---
 drivers/oprofile/cpu_buffer.h  |    1 +
 drivers/oprofile/timer_int.c   |   13 +++++++++++++
 4 files changed, 22 insertions(+), 4 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

