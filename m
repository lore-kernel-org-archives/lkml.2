Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab2FEMAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:00:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36132 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab2FEMAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:00:45 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] fuse updates for 3.5
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 05 Jun 2012 14:01:29 +0200
Message-ID: <87vcj6hsrq.fsf@tucsk.pomaz.szeredi.hu>
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
Anatol Pomozov (1):
      fuse: add FALLOCATE operation

Miklos Szeredi (2):
      fuse: optimize fallocate on permanent failure
      fuse: fix blksize calculation

Pavel Shilovsky (1):
      fuse: fix stat call on 32 bit platforms

Peter Huewe (1):
      fuse: Convert to kstrtoul_from_user

---
 fs/fuse/control.c    |   10 ++--------
 fs/fuse/dir.c        |   11 ++++++++++-
 fs/fuse/file.c       |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h     |    6 ++++++
 fs/fuse/inode.c      |   17 ++++++++++++++++-
 include/linux/fuse.h |   14 +++++++++++++-
 6 files changed, 87 insertions(+), 11 deletions(-)
