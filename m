Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1G1Iqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 04:46:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41934 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab1G1Iqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 04:46:35 -0400
Date: Thu, 28 Jul 2011 01:46:31 -0700 (PDT)
Message-Id: <20110728.014631.1261854605882078979.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 28 Jul 2011 01:46:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just enablement for Niagara-T3 cpus now that I have one to play with.

Please pull, thanks a lot.

The following changes since commit 95b6886526bb510b8370b625a49bc0ab3b8ff10f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 (2011-07-27 19:26:38 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (6):
      sparc: Don't leave sparc_pmu_type NULL on sun4v.
      sparc: Add T3 sun4v cpu type and hypervisor group defines.
      sparc: Don't do expensive hypervisor PCR write unless necessary.
      sparc: Detect and handle UltraSPARC-T3 cpu types.
      n2rng: Attach on Niagara-T3.
      n2_crypto: Attach on Niagara-T3.

 arch/sparc/include/asm/elf_64.h     |    6 ++++--
 arch/sparc/include/asm/hypervisor.h |    1 +
 arch/sparc/include/asm/spitfire.h   |    1 +
 arch/sparc/include/asm/xor_64.h     |    3 ++-
 arch/sparc/kernel/cpu.c             |    7 +++++++
 arch/sparc/kernel/cpumap.c          |    1 +
 arch/sparc/kernel/head_64.S         |   31 +++++++++++++++++++++++++++++++
 arch/sparc/kernel/hvapi.c           |    1 +
 arch/sparc/kernel/pcr.c             |   11 +++++++++--
 arch/sparc/kernel/perf_event.c      |    3 ++-
 drivers/char/hw_random/n2-drv.c     |   29 +++++++++++++++++------------
 drivers/char/hw_random/n2rng.h      |    2 +-
 drivers/crypto/n2_core.c            |   33 ++++++++++++++++++---------------
 13 files changed, 95 insertions(+), 34 deletions(-)
