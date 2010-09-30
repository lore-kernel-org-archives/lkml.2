Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0I3CJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:09:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38736 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0I3CJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:09:25 -0400
Date: Wed, 29 Sep 2010 19:07:51 -0700
From: Joel Becker <boel.becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 symlink walk fix
Message-ID: <20100930020749.GD23107@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, et al,
	We've discovered that ocfs2 can walk off the end reading a fast
symlink if the NUL got corrupted on disk.  It's a simple
strlen()->strnlen() fix, but I think it should go sooner rather than
later.
	Please pull.

Joel

The following changes since commit 4193d9163582b05e33aca3392e46649e5c3da8d1:

  Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs (2010-09-29 14:58:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git fixes

Joel Becker (1):
      ocfs2: Don't walk off the end of fast symlinks.

 fs/ocfs2/symlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
