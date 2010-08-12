Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761169Ab0HLXSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 19:18:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760456Ab0HLXSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 19:18:41 -0400
Date: Fri, 13 Aug 2010 01:16:20 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: andrej.gelenberg@udo.edu, sakiwit@gmail.com, sam@ravnborg.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild: kconfig late changes
Message-ID: <20100812231620.GA21703@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sam made two important fixes to 'make savedefconfig' and plans to submit
a defconfig trimming patch in this merge window. Also, there are three
small fixes that came after the merge window opened, but should not hurt
(if you don't like merging them for .36, then please pull at least the
two patches from Sam up to a64b44e).

Thanks,
Michal

The following changes since commit e4d6152b520184be87aa65cb7035bf87acd27c14:

  Merge branch 'kconfig' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6 (2010-08-05 14:12:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kconfig

Andrej Gelenberg (1):
      nconfig: Fix segfault when menu is empty

Jean Sacren (2):
      kconfig: Fix warning: ignoring return value of 'fwrite'
      kconfig: Fix warning: ignoring return value of 'fgets'

Sam Ravnborg (2):
      kconfig: fix savedefconfig for tristate choices
      kconfig: fix tristate choice with minimal config

 scripts/kconfig/conf.c     |   15 +++++-
 scripts/kconfig/confdata.c |  111 ++++++++++++++++++++++++++++----------------
 scripts/kconfig/expr.c     |    2 +-
 scripts/kconfig/lkc.h      |   10 ++++
 scripts/kconfig/nconf.c    |    2 +
 5 files changed, 97 insertions(+), 43 deletions(-)
