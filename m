Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab2DIWaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:30:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab2DIWae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:30:34 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Apr 2012 00:30:28 +0200
From: Richard Weinberger <richard@nod.at>
To: <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,
        <user-mode-linux-devel@lists.sourceforge.net>
Subject: [GIT PULL] UML fixes for 3.4-rc3
Message-ID: <905c4f872802ba8c93fe28bc2f627407@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

This are the UML fixes for for 3.4-rc3.

Thanks,
//richard

---
The following changes since commit 
0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-3.4-rc3

Al Viro (3):
      um: fix linker script generation
      um: several x86 hw-dependent crypto modules won't build on uml
      um: switch cow_user.h to htobe{32,64}/betoh{32,64}

Boaz Harrosh (1):
      um: uml_setup_stubs': warning: unused variable 'pages'

Richard Weinberger (2):
      um: Disintegrate asm/system.h
      um: Use asm-generic/switch_to.h

 arch/um/drivers/cow.h           |   35 ----------
 arch/um/drivers/cow_user.c      |   43 ++++++------
 arch/um/drivers/mconsole_kern.c |    1 +
 arch/um/include/asm/Kbuild      |    3 +-
 arch/um/kernel/Makefile         |    7 +-
 arch/um/kernel/process.c        |    6 +--
 arch/um/kernel/skas/mmu.c       |    1 -
 arch/x86/Makefile.um            |    3 +
 arch/x86/um/asm/barrier.h       |   75 +++++++++++++++++++++
 arch/x86/um/asm/system.h        |  135 
---------------------------------------
 crypto/Kconfig                  |    6 +-
 11 files changed, 110 insertions(+), 205 deletions(-)
 create mode 100644 arch/x86/um/asm/barrier.h
 delete mode 100644 arch/x86/um/asm/system.h

