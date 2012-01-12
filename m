Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2ALLPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 06:15:44 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37810 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2ALLPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 06:15:40 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] fuse updates for 3.3
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 12 Jan 2012 12:15:31 +0100
Message-ID: <87obu9xjcc.fsf@tucsk.pomaz.szeredi.hu>
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
John Muir (1):
      FUSE: Notifying the kernel of deletion.

Miklos Szeredi (2):
      fuse: llseek optimize SEEK_CUR and SEEK_SET
      fuse: support ioctl on directories

Thomas Meyer (1):
      fuse: Use kcalloc instead of kzalloc to allocate array

---
 fs/fuse/dev.c        |   57 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/dir.c        |   58 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/file.c       |   58 +++++++++++--------------------------------------
 fs/fuse/fuse_i.h     |   10 +++++++-
 include/linux/fuse.h |   16 +++++++++++++-
 5 files changed, 149 insertions(+), 50 deletions(-)

