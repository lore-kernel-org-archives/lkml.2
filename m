Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2HGJhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:37:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54144 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2HGJhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:37:18 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] fuse updates for 3.6 
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 07 Aug 2012 11:38:34 +0200
Message-ID: <87zk6759et.fsf@tucsk.pomaz.szeredi.hu>
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
Brian Foster (3):
      fuse: add FUSE_AUTO_INVAL_DATA init flag
      fuse: invalidate inode mapping if mtime changes
      fuse: update attributes on aio_read

Miklos Szeredi (2):
      fuse: add missing INIT flags
      fuse: add missing INIT flag descriptions

Zach Brown (1):
      fuse: verify all ioctl retry iov elements

---
 fs/fuse/file.c       |   15 +++++++++------
 fs/fuse/fuse_i.h     |    3 +++
 fs/fuse/inode.c      |   32 ++++++++++++++++++++++++++++----
 include/linux/fuse.h |   19 ++++++++++++++++++-
 4 files changed, 58 insertions(+), 11 deletions(-)
