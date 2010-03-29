Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0C2ULl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:11:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48995
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742Ab0C2ULk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:11:40 -0400
Date: Mon, 29 Mar 2010 13:11:41 -0700 (PDT)
Message-Id: <20100329.131141.80866523.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these Sparc fixes, thanks!

The following changes since commit b72c40949b0f04728f2993a1434598d3bad094ea:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Properly truncate pt_regs framepointer in perf callback.

Julia Lawall (1):
      arch/sparc/kernel: Use set_cpus_allowed_ptr

Rob Landley (1):
      sparc: Fix use of uid16_t and gid16_t in asm/stat.h

 arch/sparc/include/asm/stat.h    |    4 ++--
 arch/sparc/kernel/perf_event.c   |    2 +-
 arch/sparc/kernel/sysfs.c        |    4 ++--
 arch/sparc/kernel/us2e_cpufreq.c |    8 ++++----
 arch/sparc/kernel/us3_cpufreq.c  |    8 ++++----
 5 files changed, 13 insertions(+), 13 deletions(-)

