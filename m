Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1E2J0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 05:26:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48239 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1E2J0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 05:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=orX8s4Iii8mMCatgL1dGCWi2TmS5Lx9dZjaCy0Sqogf4JzXbK2Ws/p6dJivGzZHroP
         yE9d2P0z0ZqfoICv0O69iPh/bDgjuwGJDLYUi6mWAfeQ2Cdn7nFiQOhqdxB20Czl93DB
         FC/6aMSNeK/6O+DJtxeku/JHOZDLeelb0pj6Y=
MIME-Version: 1.0
Date: Sun, 29 May 2011 10:26:21 +0100
Message-ID: <BANLkTi=ZX0txfJzSTdDg5ViFPf50yf7+mw@mail.gmail.com>
Subject: [GIT PULL] Squashfs update for 2.6.40
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Phillip Lougher <phillip@lougher.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this last minute fix - this is a fix to some of the patches
already merged in the merge window.

Thanks

Phillip

----
The following changes since commit d7f2ff6718efa155fd92e481a5960496d084c63f:

  Squashfs: update email address (2011-05-26 10:49:11 +0100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (1):
      Squashfs: Fix sanity check patches on big-endian systems

 fs/squashfs/export.c   |    2 +-
 fs/squashfs/fragment.c |    2 +-
 fs/squashfs/id.c       |    2 +-
 fs/squashfs/super.c    |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)
