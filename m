Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab2JKV4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:56:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759433Ab2JKV4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:56:07 -0400
Date: Thu, 11 Oct 2012 23:56:04 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ak@linux.intel.com, daniel.santos@pobox.com, kliegs@chromium.org,
        ozancag@gmail.com, urpapa@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild changes for v3.7
Message-ID: <20121011215604.GA6652@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The main part of kbuild for v3.7 contains:
* Fix for scripts/Makefile.modpost to not choke on a '.ko' substring in
  the build directory path
* Two warning fixes (modpost and main Makefile)
* __compiletime_error works also with gcc 4.3
* make tar{gz,bz2,xz}-pkg uses default compression settings instead of
  saving as many bytes as possible (this should actually be in the misc
  branch, I don't know why I applied it here).

Michal

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to 415c2c525fab214ab75413aadbc67b4ee9cf212e:

  compiler-gcc4.h: correct verion check for __compiletime_error (2012-10-11 22:51:41 +0200)

----------------------------------------------------------------
Andi Kleen (1):
      Kbuild: use normal compression settings for tar*-pkg

Daniel Santos (1):
      compiler-gcc4.h: correct verion check for __compiletime_error

Jonathan Kliegman (1):
      modpost: Permit .GCC.command.line sections

Ozan Çağlayan (1):
      kbuild: Remove useless warning while appending KCFLAGS

이건호 (1):
      scripts/Makefile.modpost: error in finding modules from .mod files.

 Makefile                      |   19 +++----------------
 include/linux/compiler-gcc4.h |    2 +-
 scripts/Makefile.modinst      |    2 +-
 scripts/Makefile.modpost      |    2 +-
 scripts/mod/modpost.c         |    1 +
 scripts/package/buildtar      |    6 +++---
 6 files changed, 10 insertions(+), 22 deletions(-)
