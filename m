Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1EYOlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:41:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:57076 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab1EYOls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:41:48 -0400
Date: Wed, 25 May 2011 16:41:46 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: andi@lisas.de, jim.cromie@gmail.com, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild/misc for 2.6.40
Message-ID: <20110525144146.GA17486@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Misc kbuild updates:
* export_report.pl fixes
* fixes for make *check
* scripts/patch-kernel fix to not require bash

Please pull.
Michal

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git misc

Andreas Mohr (1):
      eradicate bashisms in scripts/patch-kernel

Jim Cromie (3):
      export_report: do collectcfiles work in perl itself
      export_report: sort SECTION 2 output
      export_report: use warn() to issue WARNING, so they go to stderr

Peter Foley (5):
      kbuild: don't warn about include/linux/version.h not including itself
      kbuild: add targets to PHONY
      kbuild: make headerdep work in KBUILD_OUTDIR
      kbuild: make includecheck work in KBUILD_OUTDIR
      kbuild: make versioncheck work in KBUILD_OUTDIR

 Makefile                 |    9 ++++++---
 scripts/checkversion.pl  |    1 +
 scripts/export_report.pl |   26 ++++++++++++++++++++------
 scripts/patch-kernel     |    2 +-
 4 files changed, 28 insertions(+), 10 deletions(-)
