Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0DZN5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:57:24 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:37370 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0DZN5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:57:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=q8BMNBAqv6/t2fum1doKv6IClw7zb3pkr3g3w2bAcdaBCID2ZeYVhBS0F3e5Ij1y/q
         zMTG7JRjIn8HChZPTAycij6cKG04wWXKclop7blKzuG9UNq1aHShoe8d3jPK+Pceqc81
         FdiAwWziFGZczkw6inV85V+C1fhie4QvsdAEQ=
MIME-Version: 1.0
Date: Mon, 26 Apr 2010 14:57:21 +0100
Message-ID: <g2zbffbecbb1004260657j7aff37dy9d10ca5ed37337c0@mail.gmail.com>
Subject: [GIT PULL] Squashfs bug fixes for 2.6.34-rc6
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Squashfs bug fixes.  The locking bug was
added in the 2.6.34 merge window and it is
rather nasty as it breaks liveCDs.  The other bugs are much less
important but have all come to light since the merge window.

Thanks

Phillip

 --------------------------------
The following changes since commit 0d0fb0f9c5fddef4a10242fe3337f00f528a3099:
  Linus Torvalds (1):
        Linux 2.6.34-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (4):
      squashfs: fix locking bug in zlib wrapper
      squashfs: fix warn_on when root inode is corrupted
      squashfs: add missing buffer free
      squashfs: fix potential buffer over-run on 4K block file systems

 fs/squashfs/block.c        |    5 ++---
 fs/squashfs/super.c        |    4 +++-
 fs/squashfs/zlib_wrapper.c |    3 ++-
 3 files changed, 7 insertions(+), 5 deletions(-)
