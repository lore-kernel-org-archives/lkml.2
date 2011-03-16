Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1CPOnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:43:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39521 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1CPOmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:42:55 -0400
Date: Wed, 16 Mar 2011 14:42:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] several fixes
Message-ID: <20110316144253.GT22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Several fixes, including the brown paperbag one for -ELOOP breakage
in the last commit of yesterday pull.  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:

Al Viro (1):
      fix follow_link() breakage

Christoph Hellwig (1):
      prune back iprune_sem

Stephen Rothwell (1):
      vfs: add nonconflicting values for O_PATH

Diffstat:

 arch/alpha/include/asm/fcntl.h  |    2 ++
 arch/parisc/include/asm/fcntl.h |    2 ++
 arch/sparc/include/asm/fcntl.h  |    2 ++
 fs/inode.c                      |   32 ++++++++++++++------------------
 fs/namei.c                      |    7 +++----
 5 files changed, 23 insertions(+), 22 deletions(-)

