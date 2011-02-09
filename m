Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1BIWUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:20:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab1BIWUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:20:18 -0500
Date: Wed, 9 Feb 2011 23:20:17 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: max@stro.at, mmarek@suse.cz, nicolas.2p.debian@free.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild packaging fixes
Message-ID: <20110209222017.GA16053@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these two patches fix problems with 'make deb-pkg' introduced in
2.6.38-rc1. Please pull.

Thanks,
Michal


The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:

  Linux 2.6.38-rc1 (2011-01-18 15:14:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Michal Marek (1):
      Merge branch 'kbuild/packaging' into kbuild/rc-fixes

Nicolas de Pesloüan (1):
      deb-pkg: Fix building outside of source tree (O=...).

maximilian attems (1):
      deb-pkg: Use $SRCARCH for include path

 scripts/package/builddeb |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
