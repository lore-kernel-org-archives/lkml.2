Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2ICTSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:18:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab2ICTSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:18:08 -0400
Date: Mon, 3 Sep 2012 21:18:01 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mark.asselstine@windriver.com, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild rc fixes for v3.6
Message-ID: <20120903191801.GA23227@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there are two fixes that should go into 3.6. The link-vmlinux.sh one is
obvious. The other one fixes make firmware_install with certain
configurations, where a file in the toplevel firmware tree gets
installed first, and $(INSTALL_FW_PATH)/$$(dir <file>) results in
/lib/firmware/./, which confuses make 3.82 for some reason.

Thanks,
Michal

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git ..BRANCH.NOT.VERIFIED..

Mark Asselstine (1):
      firmware: fix directory creation rule matching with make 3.82

Michal Marek (1):
      link-vmlinux.sh: Fix stray "echo" in error message

 scripts/Makefile.fwinst |    2 +-
 scripts/link-vmlinux.sh |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
