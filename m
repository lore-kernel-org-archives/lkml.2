Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0HWJmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:42:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:58314 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0HWJma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:42:30 -0400
Date: Sat, 21 Aug 2010 22:13:50 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: JBeulich@novell.com, amwang@redhat.com, mmarek@suse.cz, sam@ravnborg.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fixes for 2.6.36-rc2
Message-ID: <20100821201350.GA9144@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there are some post-rc1 kbuild fixes:
* Two kconfig fixes by Sam.
* A fix for new make version by Jan (this is technically no a rc1
  regression, but we should fix it sooner rather than later).
* Two setlocalversion fixes, one by Amerigo, one by me.

Thanks,
Michal


The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:

  Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Amerigo Wang (1):
      makefile: not need to regenerate kernel.release file when make kernelrelease

Jan Beulich (1):
      fixes for using make 3.82

Michal Marek (2):
      Merge commit 'v2.6.36-rc1' into kbuild/rc-fixes
      setlocalversion: Ignote SCMs above the linux source tree

Sam Ravnborg (2):
      kconfig: fix savedefconfig with choice marked optional
      kconfig: fix segfault when detecting recursive dependency

 Makefile                   |    4 ++--
 firmware/Makefile          |    2 +-
 scripts/kconfig/confdata.c |    6 ++++--
 scripts/kconfig/symbol.c   |    2 ++
 scripts/mkmakefile         |    4 +++-
 scripts/setlocalversion    |    4 ++--
 6 files changed, 14 insertions(+), 8 deletions(-)
