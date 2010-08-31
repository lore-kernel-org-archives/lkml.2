Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab0HaF5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 01:57:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:49927 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab0HaF5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 01:57:16 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 15:56:38 +1000
Message-ID: <1283234198.2151.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a few small fixes, one is an important fix for a nasty regression
breaking pseries machine running under hypervisor... oops !

Cheers,
Ben.

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:
  Linus Torvalds (1):
        Linux 2.6.36-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Matthew McClintock (1):
      powerpc/kexec: Adds correct calling convention for kexec purgatory

Michael Neuling (1):
      powerpc: Don't use kernel stack with translation off

Paul Mackerras (1):
      powerpc/perf_event: Reduce latency of calling perf_event_do_pending

 arch/powerpc/kernel/head_64.S |   12 +++++++++---
 arch/powerpc/kernel/misc_32.S |    3 +++
 arch/powerpc/kernel/time.c    |   23 +++++++++++------------
 3 files changed, 23 insertions(+), 15 deletions(-)


