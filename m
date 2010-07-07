Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0GGJIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 05:08:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:57337 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0GGJIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 05:08:11 -0400
Date: Wed, 7 Jul 2010 11:08:08 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild
Message-ID: <20100707090808.GA23006@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

my last pull request broke LOCALVERSION for O=... builds, sorry about
that. The following commit fixes that (verified by Rafael and Stephen
who reported it. I really hope this is the _last_ kbuild thing for
2.6.35.

Michal

The following changes since commit 62052be3a797f26f6f0fe30fc8d7f40ab54e08fd:

  Merge branch 'setlocalversion-speedup' into kbuild/rc-fixes (2010-07-02 11:56:52 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Michal Marek (1):
      kbuild: Fix path to scripts/setlocalversion

 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
