Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1CSJJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 05:09:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1CSJJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 05:09:47 -0400
Date: Sat, 19 Mar 2011 10:09:45 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, zkaspar82@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild/packaging update for 2.6.39-rc1
Message-ID: <20110319090945.GA19129@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is one patch to the packaging part of kbuild: make tarxz-pkg and
make perf-tarxz-src-pkg.  Please pull.

Thanks,
Michal

The following changes since commit 85e2efbb1db9a18d218006706d6e4fbeb0216213:

  Linux 2.6.38-rc5 (2011-02-15 19:23:45 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git packaging

Michal Marek (1):
      Merge commit 'v2.6.38-rc1' into kbuild/packaging

Zdenek Kaspar (1):
      kbuild: Add make tarxz-pkg build option

Note: git request-pull seems confused by the merge commit and includes a
diffstat between -rc1 and -rc5 or something like that (-rc5 was when the
previous two commits were merged). So here is the proper diffstat for the
tarxz patch:

scripts/package/Makefile |    5 ++++-
scripts/package/buildtar |    4 ++++
2 files changed, 8 insertions(+), 1 deletions(-)


