Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2IJPPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:15:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43569 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2IJPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:15:14 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] fuse fixes for 3.6
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Mon, 10 Sep 2012 17:16:43 +0200
Message-ID: <877gs1aox0.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This contains bugfixes for FUSE and CUSE and a compile warning fix.

Thanks,
Miklos

---
Daniel Mack (1):
      fuse: mark variables uninitialized

Miklos Szeredi (3):
      cuse: fix fuse_conn_kill()
      cuse: kill connection on initialization error
      fuse: fix retrieve length

---
 fs/fuse/control.c |    4 ++--
 fs/fuse/cuse.c    |    4 +---
 fs/fuse/dev.c     |    1 +
 fs/fuse/inode.c   |   12 +++++++-----
 4 files changed, 11 insertions(+), 10 deletions(-)
