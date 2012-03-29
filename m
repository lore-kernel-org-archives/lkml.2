Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab2C2A7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 20:59:33 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:36588 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932832Ab2C2A7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 20:59:30 -0400
Message-ID: <4F73B3EE.9060401@lougher.demon.co.uk>
Date: Thu, 29 Mar 2012 01:59:26 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 3.4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Squashfs updates...

Thanks

Phillip


The following changes since commit 192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:

   Linux 3.3-rc6 (2012-03-03 17:08:09 -0800)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git tags/squashfs-updates

for you to fetch changes up to 4b0180a49f08dd1c681cdc99edc9e0cec0a833fa:

   Squashfs: add mount time sanity check for block_size and block_log match (2012-03-10 03:01:02 +0000)

----------------------------------------------------------------
Add an extra mount time sanity check, plus some code cleanups and bug fixes.

----------------------------------------------------------------
Ajeet Yadav (1):
       Squashfs: use define instead of constant

Phillip Lougher (6):
       Squashfs: update comment removing reference to zlib only
       Squashfs: remove redundant length initialisation in squashfs_readdir
       Squashfs: remove redundant length initialisation in squashfs_lookup
       Squashfs: get rid of obsolete definitions in header file
       Squashfs: fix f_pos check in get_dir_index_using_offset
       Squashfs: add mount time sanity check for block_size and block_log match

  fs/squashfs/block.c       |    3 ++-
  fs/squashfs/dir.c         |    7 +++----
  fs/squashfs/namei.c       |    5 ++---
  fs/squashfs/squashfs_fs.h |   19 +++----------------
  fs/squashfs/super.c       |    5 +++++
  5 files changed, 15 insertions(+), 24 deletions(-)
