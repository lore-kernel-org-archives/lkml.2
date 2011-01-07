Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1AGWPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:15:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab1AGWPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:15:08 -0500
Date: Fri, 7 Jan 2011 23:15:03 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, bengardiner@nanometrics.ca,
        bgamari.foss@gmail.com, eric.dumazet@gmail.com, geert@linux-m68k.org,
        hjl.tools@gmail.com, jj@chaosbits.net, kirill@shutemov.name,
        lacombar@gmail.com, mmarek@suse.cz, olof@lixom.net, stigge@antcom.de,
        thomas@wytron.com.tw, vapier@gentoo.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild core updates for 2.6.38-rc1
Message-ID: <20110107221503.GA13373@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

plese pull following kbuild updates for 2.6.38-rc1. It's quite boring
this time: two modpost fixes, a fixdep optimization that makes
allmodconfig build 2% faster and a couple of small but welcome fixes.

Michal

The following changes since commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4:

  Linux 2.6.37-rc1 (2010-11-01 07:54:12 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kbuild

Andrew Morton (1):
      gen_init_cpio: checkpatch fixes

Arnaud Lacombe (1):
      scripts/genksyms: fix header usage

Ben Gamari (1):
      Make fixdep error handling more explicit

Ben Gardiner (1):
      kbuild: fix interaction of CONFIG_IKCONFIG and KCONFIG_CONFIG

Eric Dumazet (1):
      fixdep: use hash table instead of a single array

Geert Uytterhoeven (1):
      checksyscalls: Fix stand-alone usage

H.J. Lu (1):
      modpost: Put .zdebug* section on white list

Jesper Juhl (1):
      gen_init_cpio: Avoid race between call to stat() and call to open()

Kirill A. Shutemov (2):
      kbuild: introduce HDR_ARCH_LIST for headers_install_all
      kbuild: export linux/{a.out,kvm,kvm_para}.h on headers_install_all

Michal Marek (1):
      Merge commit 'v2.6.37-rc1' into kbuild/kbuild

Mike Frysinger (1):
      headers_install: check exit status of unifdef

Olof Johansson (1):
      modpost: Fix address calculation in reloc_location()

Roland Stigge (1):
      mkuboot.sh: Fail if mkimage is missing

Thomas Chou (1):
      gen_init_cpio: remove leading `/' from file names

 Documentation/make/headers_install.txt |    5 +-
 Makefile                               |    1 +
 include/linux/Kbuild                   |    9 ++-
 kernel/Makefile                        |    2 +-
 scripts/basic/fixdep.c                 |  119 ++++++++++++++++++--------------
 scripts/checksyscalls.sh               |    4 +-
 scripts/genksyms/parse.c_shipped       |    2 +-
 scripts/genksyms/parse.y               |    2 +-
 scripts/headers.sh                     |    2 +-
 scripts/headers_install.pl             |    7 ++
 scripts/mkuboot.sh                     |    2 +-
 scripts/mod/modpost.c                  |    3 +-
 usr/gen_init_cpio.c                    |   20 ++++--
 13 files changed, 108 insertions(+), 70 deletions(-)
