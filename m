Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab0K3EIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 23:08:17 -0500
Received: from gate.crashing.org ([63.228.1.57]:36709 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0K3EIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 23:08:16 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 15:07:33 +1100
Message-ID: <1291090053.32570.353.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This is a small fix for a misuse of RCU on powerpc, please pull.

Cheers,
Ben.

The following changes since commit
72083646528d4887b920deb71b37e09bc7d227bb:

  Un-inline get_pipe_info() helper function (2010-11-28 16:27:19 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Peter Zijlstra (1):
      powerpc: Use call_rcu_sched() for pagetables

 arch/powerpc/mm/pgtable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


