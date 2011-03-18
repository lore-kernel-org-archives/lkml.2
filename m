Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1CRN4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:56:00 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:3489 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab1CRNzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:55:55 -0400
Date: Fri, 18 Mar 2011 09:11:30 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] omfs fixes for 2.6.39
Message-ID: <20110318131130.GA5698@hash.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the omfs tree for 2.6.39 from

git://git.kernel.org/pub/scm/linux/kernel/git/bcopeland/omfs.git for-linus

The tree includes fixes from Al Viro including a readdir bug and problems
with i_nlink handling.  Thanks!

The following changes since commit 85e2efbb1db9a18d218006706d6e4fbeb0216213:

  Linux 2.6.38-rc5 (2011-02-15 19:23:45 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bcopeland/omfs.git for-linus

Al Viro (4):
      omfs: rename() needs to mark old_inode dirty after ctime update
      omfs: stop playing silly buggers with omfs_unlink() in ->rename()
      omfs: merge unlink() and rmdir(), close leak in rename()
      omfs: make readdir stop when filldir says so

 fs/omfs/dir.c |   66 +++++++++++++++++---------------------------------------
 1 files changed, 20 insertions(+), 46 deletions(-)
-- 
Bob Copeland %% www.bobcopeland.com

