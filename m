Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398Ab0FKOAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 10:00:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:60183 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386Ab0FKOAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 10:00:00 -0400
Date: Fri, 11 Jun 2010 15:59:57 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fixes
Message-ID: <20100611135957.GA26561@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these two commits that fix the way modules.builtin is
generated.

Thanks,
Michal

The following changes since commit 63a07cb64ccc3ceae619d3298545d602ab5ecd38:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2010-06-09 12:44:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Michal Marek (2):
      kbuild: Generate modules.builtin in make modules
      kbuild: Create output directory in Makefile.modbuiltin

 Makefile                    |    4 ++--
 scripts/Makefile.modbuiltin |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)
