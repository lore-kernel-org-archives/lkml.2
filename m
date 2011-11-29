Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1K2Qpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 11:45:54 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:58808 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab1K2Qpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 11:45:53 -0500
Date: Tue, 29 Nov 2011 11:45:48 -0500
Message-Id: <E1RVQoW-0005SB-7d@tytso-glaptop.cam.corp.google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bugfixes for 3.2-rc4
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There is a signed tag tytso-for-linus-20111129 covering this fix (which
is also cc'ed to stable@kernel.org).

Thanks!!

						- Ted

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

Tejun Heo (1):
      ext4: fix racy use-after-free in ext4_end_io_dio()

 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
