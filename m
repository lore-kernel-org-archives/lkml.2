Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0LGDgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 22:36:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42188 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0LGDgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 22:36:21 -0500
Date: Mon, 6 Dec 2010 19:34:59 -0800
From: Joel Becker <joel.becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 fixes for 2.6.37-rc4
Message-ID: <20101207033459.GB2233@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus et al,
	Here are the currently queued ocfs2 fixes for 2.6.37-rc.  A
couple close some issues with merged changes.  Please pull.

Joel


The following changes since commit 771f8bc71c31c6bd103cdec283012253f352ab1c:

  Merge branch 'slab/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 (2010-12-05 16:45:02 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

David Sterba (1):
      fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock

Jiri Slaby (1):
      ocfs2: fix memory leak

Milton Miller (1):
      ocfs2: char is not always signed

Tristan Ye (1):
      Ocfs2: Stop tracking a negative dentry after dentry_iput().

dann frazier (1):
      ocfs2_connection_find() returns pointer to bad structure

 fs/ocfs2/cluster/heartbeat.c |   14 ++++++++++----
 fs/ocfs2/dcache.c            |    1 -
 fs/ocfs2/dlm/dlmdomain.c     |    2 +-
 fs/ocfs2/ocfs2.h             |    6 +++---
 fs/ocfs2/stack_user.c        |    2 +-
 5 files changed, 15 insertions(+), 10 deletions(-)
