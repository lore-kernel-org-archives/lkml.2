Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab2DBM2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:28:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab2DBM2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 08:28:03 -0400
Date: Mon, 2 Apr 2012 14:28:00 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sboyd@codeaurora.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] make cscope fix
Message-ID: <20120402122800.GA7157@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the kbuild.git#misc pull request introduced a bug that broke make
cscope. Apparently, both the original author and me only tested the use
case that the commit was supposed to improve (make tags/TAGS), and not
the use case that was not supposed (make cscope).

Michal

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

Stephen Boyd (1):
      Subject: [PATCH] tags.sh: Add missing quotes

 scripts/tags.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
