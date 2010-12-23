Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0LWWo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:44:56 -0500
Received: from thunk.org ([69.25.196.29]:60852 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab0LWWoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:44:55 -0500
Date: Thu, 23 Dec 2010 17:44:53 -0500
Message-Id: <E1PVtu1-0005vZ-Ay@tytso-glaptop>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 regression fix
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git linus-hot-fix

To get the following regression fix (which was introduced in
2.6.37-rc1).

Thanks,

						- Ted

Theodore Ts'o (1):
      ext4: fix on-line resizing regression

 fs/ext4/resize.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)
