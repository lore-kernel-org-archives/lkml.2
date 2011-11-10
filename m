Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935602Ab1KJQOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:14:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab1KJQOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:14:33 -0500
Date: Thu, 10 Nov 2011 17:14:29 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david.daney@cavium.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: [GIT] kbuild mips fix
Message-ID: <20111110161429.GA2255@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

commit 5f7efb4 from the latest kbuild pull request broke MIPS. Here is
the fix.

Michal

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

David Daney (1):
      kbuild: Fix missing system calls check on mips.

 Kbuild             |    2 +-
 arch/mips/Makefile |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
