Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2DROXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:23:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45131 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2DROXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:23:04 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] fuse updates for 3.4
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Wed, 18 Apr 2012 16:23:16 +0200
Message-ID: <87ipgx9l0r.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

to receive the following changes.

Thanks,
Miklos

---
Anand Avati (1):
      fuse: O_DIRECT support for files

Miklos Szeredi (3):
      fuse: fix nlink after unlink
      fuse: allow nanosecond granularity
      fuse: use flexible array in fuse.h

---
 fs/fuse/dir.c        |   25 ++++++----
 fs/fuse/file.c       |  129 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/inode.c      |    1 +
 include/linux/fuse.h |    2 +-
 4 files changed, 129 insertions(+), 28 deletions(-)
