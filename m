Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0KNJdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 04:33:43 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20668 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0KNJdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 04:33:40 -0500
Date: Sun, 14 Nov 2010 01:31:37 -0800
From: Joel Becker <boel.becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] Important ocfs2 fix for 2.6.37-rc1
Message-ID: <20101114093136.GA27747@mail.oracle.com>
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

Linus, et al,
	We've got a rather large problem in our cluster locking in the
2.6.37-rc1 changes.  Tao has found the problem (a signed-vs-unsigned
error that I should have caught).  Here's the fix.
	Please pull.

Joel

The following changes since commit 2d3b07c07b39c4b7d9b6641052a02d996cd5d87c:

  Merge branch 'x86-platform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-10-28 12:25:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Tao Ma (1):
      ocfs2: Change some lock status member in ocfs2_lock_res to char.

 fs/ocfs2/ocfs2.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
