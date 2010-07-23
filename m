Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237Ab0GWOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:25:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:39484 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0GWOZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:25:26 -0400
Date: Fri, 23 Jul 2010 16:25:15 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bebarino@gmail.com, gentoo@mgorny.alt.pl, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fixes for 2.6.35
Message-ID: <20100723142515.GA524@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there are three more fixes for kbuild bugs that appeared in 2.6.35. The
first two are fixes to the setlocalversion script, the third one fixes a
format string bug in nconfig (nconfig was added in this release cycle).

Please pull from the below url, thanks.
Michal

The following changes since commit 1c5474a65bf15a4cb162dfff86d6d0b5a08a740c:

  Linux 2.6.35-rc5 (2010-07-12 14:55:33 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Michal Marek (1):
      kbuild: Fix make rpm

Michał Górny (1):
      kbuild: Make the setlocalversion script POSIX-compliant

Stephen Boyd (1):
      nconfig: Fix segfault when help contains special characters

 scripts/kconfig/nconf.gui.c |    2 +-
 scripts/package/Makefile    |    2 +-
 scripts/setlocalversion     |   16 ++++++++++------
 3 files changed, 12 insertions(+), 8 deletions(-)
