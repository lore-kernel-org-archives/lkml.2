Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab1E0Jw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:52:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53101 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1E0Jw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:52:58 -0400
Date: Fri, 27 May 2011 02:52:48 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ocfs2 important fix for $next_version-rc1
Message-ID: <20110527095248.GD4966@noexit.corp.google.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20110526094632.GB8252@noexit.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526094632.GB8252@noexit.corp.google.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus et al,
	Mea culpa.  The online defrag code in the ocfs2 feature pull had
a naked 64-bit divide that I missed in eyeballing and we all missed in
testing.  None of us managed to build the sucker on 32bit in the past
two months.  That's on me.  Thank you to akpm for noticing.  Also
included is a bugfix in the defrag location guessing.
	I'd really like to get this in before -rc1 so that ocfs2 builds
aren't broken there.  Please pull.

Mr Egg-on-his-face (Joel)

The following changes since commit a74b81b0aff4a01e0816df5915c854fb52c5e87f:

  Merge branch 'linux-next' of git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2 (2011-05-26 10:55:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git linux-next

Joel Becker (1):
      Merge branch 'move_extents' of git://oss.oracle.com/git/tye/linux-2.6 into ocfs2-merge-window

Tristan Ye (2):
      Ocfs2/move_extents: Avoid doing division in extent moving.
      Ocfs2/move_extents: Validate moving goal after the adjustment.

 fs/ocfs2/move_extents.c |   41 ++++++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 21 deletions(-)

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

			http://www.jlbec.org/
			jlbec@evilplan.org
