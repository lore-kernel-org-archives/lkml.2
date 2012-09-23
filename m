Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2IWWMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 18:12:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab2IWWMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 18:12:40 -0400
Date: Mon, 24 Sep 2012 00:12:36 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jeffm@suse.de, mark.asselstine@windriver.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild rc fixes
Message-ID: <20120923221236.GA7412@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there are two more kbuild fixes for 3.6. One fixes a race between x86's
archscripts target and the rule (re)building scripts/basic/fixdep. The
second is a fix for the previous attempt at fixing make firmware_install
with make 3.82. This new solution should work with any version of GNU make.

Thanks,
Michal

The following changes since commit 6c7080a61fc7b46b3ac8573952b5a3e9d5f68bc4:

  firmware: fix directory creation rule matching with make 3.82 (2012-08-30 16:27:13 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

for you to fetch changes up to 24cc7fb69a5b5edfdff1d38c6a213d6a33648829:

  x86/kbuild: archscripts depends on scripts_basic (2012-09-21 13:49:47 +0200)

----------------------------------------------------------------
Jeff Mahoney (1):
      x86/kbuild: archscripts depends on scripts_basic

Mark Asselstine (1):
      firmware: fix directory creation rule matching with make 3.80

 arch/x86/Makefile       |    2 +-
 scripts/Makefile.fwinst |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
