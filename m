Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1BUOUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:20:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:33122 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab1BUOUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:20:38 -0500
Date: Mon, 21 Feb 2011 15:20:36 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au
Subject: [GIT] kbuild anticipatory fix
Message-ID: <20110221142036.GA3583@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Commit 9599ec0 in the tip tree is going to replace
arch/x86/lib/memmove_64.c with arch/x86/lib/memmove_64.S, which breaks
build if one does not run 'make clean' after merging that commit. While
this is not a regression, the kbuild fix is rather simple and will avoid
the annoyance in the merge window if merged now. Please consider.

Michal

The following changes since commit 85e2efbb1db9a18d218006706d6e4fbeb0216213:

  Linux 2.6.38-rc5 (2011-02-15 19:23:45 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Michal Marek (1):
      fixdep: Do not record dependency on the source file itself

 scripts/basic/fixdep.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)
