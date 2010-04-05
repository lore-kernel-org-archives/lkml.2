Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab0DEUkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:40:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48566 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab0DEUkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Ibv4s5F5/ziqOHzaJtmv7lOMs3vdlsBW8493PGbLtSngxZVwpmt82cjkk3NDLI4JJi
         q8yfuzgiCWqmbYtnybF1P4bCNyCqSoAZ+gVL8uR+C5RVGdSuyTbXtBwZMHzkdTsnsBW1
         DhEDydBLDkSZYKL/YwSBnOEbDPAT3TBk8TdaM=
MIME-Version: 1.0
Date: Mon, 5 Apr 2010 15:40:12 -0500
Message-ID: <i2la4e6962a1004051340n741c2594s5765dfdc85414e7b@mail.gmail.com>
Subject: [GIT PULL] 9p file system bug fixes for 2.6.34-rc3
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit db217dece3003df0841bacf9556b5c06aa097dae:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/sparc-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (3):
      fs/9p: Clunk the fid resulting from partial walk of the name
      9p: drop nlink remove
      9p: Make sure we are able to clunk the cached fid on umount

Dan Carpenter (2):
      9p: return on mutex_lock_interruptible()
      9p: saving negative to unsigned char

Sripathi Kodi (3):
      9p: Fix setting of protocol flags in v9fs_session_info structure.
      9p: documentation update
      9p: Creating files with names too long should fail with ENAMETOOLONG.

 Documentation/filesystems/9p.txt |   18 ++++++++++++++++--
 fs/9p/fid.c                      |   12 ++++++++++--
 fs/9p/v9fs.c                     |   21 ++++++++++++++++++---
 fs/9p/v9fs.h                     |    1 +
 fs/9p/vfs_dir.c                  |    2 ++
 fs/9p/vfs_inode.c                |    9 ++++++++-
 fs/9p/vfs_super.c                |    3 ++-
 include/net/9p/client.h          |    2 ++
 net/9p/client.c                  |   23 +++++++++++++++++++----
 9 files changed, 78 insertions(+), 13 deletions(-)

    thanks,

           -eric
