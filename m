Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0HWUXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:23:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44173 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab0HWUXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:23:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Mon, 23 Aug 2010 16:23:34 -0400
Message-Id: <1282595014-16881-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1282552805-18989-1-git-send-email-vapier@gentoo.org>
References: <1282552805-18989-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9ee47476d6734c9deb9ae9ab05d963302f6b6150:

  Merge branch 'radix-tree' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev (2010-08-22 19:55:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Mike Frysinger (3):
      Blackfin: fix hweight breakage
      ADI/ASoC: add MAINTAINERS entries
      Blackfin: wire up new fanotify/prlimit64 syscalls

 MAINTAINERS                        |   11 +++++++++++
 arch/blackfin/include/asm/bitops.h |   17 ++++++++++-------
 arch/blackfin/include/asm/unistd.h |    5 ++++-
 arch/blackfin/mach-common/entry.S  |    3 +++
 4 files changed, 28 insertions(+), 8 deletions(-)
