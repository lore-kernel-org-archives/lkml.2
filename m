Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1AGWgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:36:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:38923 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab1AGWgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:36:45 -0500
Date: Fri, 7 Jan 2011 23:36:44 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: asbjorn@asbjorn.biz, max@stro.at, tytso@mit.edu,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild packaging updates for 2.6.38-rc1
Message-ID: <20110107223644.GA14533@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these deb packaging updates for 2.6.38-rc1:
 * Better support for cross-compiling
 * make deb-pkg now also generates linux-headers (for kernel modules) and
   linux-libc-dev packages
 * Fix for umask 077

The following changes since commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4:

  Linux 2.6.37-rc1 (2010-11-01 07:54:12 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git packaging

Asbjoern Sloth Toennesen (2):
      kbuild, deb-pkg: select userland architecture based on UTS_MACHINE
      kbuild, deb-pkg: support overriding userland architecture

Theodore Ts'o (1):
      kbuild: create linux-headers package in deb-pkg

maximilian attems (3):
      kbuild, deb-pkg: Fix build with paranoid umask
      deb-pkg: Make deb-pkg generate a seperate linux-libc-dev deb
      deb-pkg: s/hdr/kernel_headers_/ && s/header/libc_headers_/

 Documentation/kbuild/kbuild.txt |    8 +++
 scripts/package/builddeb        |   93 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 97 insertions(+), 4 deletions(-)
