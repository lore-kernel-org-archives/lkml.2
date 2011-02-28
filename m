Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1B1LPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:15:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45146 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1B1LPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:15:53 -0500
Date: Mon, 28 Feb 2011 03:15:39 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ocfs2 fixes for 2.6.38-rc
Message-ID: <20110228111536.GA32135@noexit>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus et al,
	Here are the latest ocfs2 fixes for 2.6.38-rc.  I've got a
couple more pending, but since my test environment is in pieces, I'm
sending you what's already been queued.  I'll send another request when
I have the next batch tested.
	Please pull.

The following changes since commit 0cc9d5257857608ba85885b75fcada13d359b5d1:

  Merge branch 'rtc-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-02-18 14:20:46 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Jan Kara (1):
      ocfs2: Fix estimate of necessary credits for mkdir

Mark Fasheh (1):
      ocfs2: Check heartbeat mode for kernel stacks only

Tristan Ye (1):
      Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters in a right number.

 fs/ocfs2/journal.h      |    6 +++---
 fs/ocfs2/refcounttree.c |    7 +++++--
 fs/ocfs2/super.c        |   28 ++++++++++++++++++++--------
 3 files changed, 28 insertions(+), 13 deletions(-)

-- 

"I don't want to achieve immortality through my work; I want to
 achieve immortality through not dying."
        - Woody Allen

			http://www.jlbec.org/
			jlbec@evilplan.org
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
