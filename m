Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0FGUCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 16:02:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52587 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0FGUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=c+GdHdm9esWybK2+6C6Rsj0hVwYH+apY728aVfrUvggjkhPGgblPkW03aHDck+iapy
         3myin6dkFlWm4tIXM6c28xM4O3sF6+TnOW2ory/ItF4eaOoLLwYQ5G4A2lR+F6CoP0OB
         Pl1RS4C3EWXYueJFAMYQG9a+f6FFfpP5oLQCE=
MIME-Version: 1.0
Date: Mon, 7 Jun 2010 15:02:15 -0500
Message-ID: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com>
Subject: [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please merge the following bug fixes for the 9P file system.

The following changes since commit 386f40c86d6c8d5b717ef20620af1a750d0dacb4:
  Linus Torvalds (1):
        Revert "tty: fix a little bug in scrup, vt.c"

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Fang Wenqi (1):
      virtio_9p.h needs <linux/types.h>

jvrao (2):
      Add a helper function to get fsgid for a file create.
      9p: Add a wstat after TCREATE to fix the gid.

 fs/9p/vfs_inode.c         |   34 ++++++++++++++++++++++++++++++++++
 include/linux/virtio_9p.h |    1 +
 2 files changed, 35 insertions(+), 0 deletions(-)
