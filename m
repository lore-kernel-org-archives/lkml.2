Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2G3Kp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:45:27 -0400
Received: from nat.scz.novell.com ([213.151.88.252]:47059 "EHLO linux.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752177Ab2G3Kp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:45:26 -0400
Date: Mon, 30 Jul 2012 12:45:25 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pebolle@tiscali.nl, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild treewide cleanup
Message-ID: <20120730104525.GA1578@noe.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Paul Bolle did a cleanup of <asm/*.h> headers in various architectures.
Because the patch touch several architectures at once, it was easiest
for me to apply them to the kbuild tree.

Thanks,
Michal


The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git trivial

Paul Bolle (3):
      Remove useless wrappers of asm-generic/cpumask.h
      Remove useless wrappers of asm-generic/ipc.h
      Remove useless wrappers of asm-generic/rmap.h

 arch/frv/include/asm/cpumask.h    |    6 ------
 arch/hexagon/include/asm/Kbuild   |    2 --
 arch/mn10300/include/asm/ipc.h    |    1 -
 arch/openrisc/include/asm/Kbuild  |    2 --
 arch/tile/include/asm/Kbuild      |    1 -
 arch/xtensa/include/asm/cpumask.h |   16 ----------------
 arch/xtensa/include/asm/rmap.h    |   16 ----------------
 7 files changed, 0 insertions(+), 44 deletions(-)
 delete mode 100644 arch/frv/include/asm/cpumask.h
 delete mode 100644 arch/mn10300/include/asm/ipc.h
 delete mode 100644 arch/xtensa/include/asm/cpumask.h
 delete mode 100644 arch/xtensa/include/asm/rmap.h
