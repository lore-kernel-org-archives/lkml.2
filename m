Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1GZBY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:24:26 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:59230 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab1GZBYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:19 -0400
Message-ID: <4E2E175C.7060400@lougher.demon.co.uk>
Date: Tue, 26 Jul 2011 02:24:44 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 3.1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following minor Squashfs update.

Thanks

Phillip


The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:

   Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (2):
       Squashfs: Update documentation for XZ and add squashfs-tools devel tree
       Squashfs: Make ZLIB compression support optional

  Documentation/filesystems/squashfs.txt |    4 +++-
  fs/squashfs/Kconfig                    |   14 +++++++++++++-
  fs/squashfs/Makefile                   |    3 ++-
  fs/squashfs/decompressor.c             |    6 ++++++
  fs/squashfs/decompressor.h             |    4 ++++
  fs/squashfs/squashfs.h                 |    3 ---
  6 files changed, 28 insertions(+), 6 deletions(-)
