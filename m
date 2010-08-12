Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908Ab0HLXYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 19:24:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:40652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0HLXYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 19:24:30 -0400
Date: Fri, 13 Aug 2010 01:22:10 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: miltonm@bga.com, yegorslists@googlemail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild: 2 late fixes
Message-ID: <20100812232210.GA22347@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these two kbuild fixes that came after the merge window
opened (the one from Milton did come before 2.6.35 actually, but I
overlooked it).

Thanks,
Michal


The following changes since commit da9e82b3b8989fc09e2a4c45b9da604ba2b4c46d:

  Merge branch 'kbuild' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6 (2010-08-05 14:10:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kbuild

Milton Miller (1):
      setlocalversion: fix version for untaged nontip mercurial revs

Yegor Yefremov (1):
      Fix CONFIG_CROSS_COMPILE issue in .config

 Makefile                |    1 -
 scripts/setlocalversion |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)
