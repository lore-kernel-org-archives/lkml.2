Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab2FBOrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 10:47:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34724 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab2FBOrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 10:47:14 -0400
Date: Sat, 2 Jun 2012 15:47:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs.git fix
Message-ID: <20120602144712.GN30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another dumb fsck-up of mine, this time in VFS tree...  Please, pull from 
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
Shortlog:
Anton Blanchard (1):
      powerpc: Fix size of st_nlink on 64bit

Diffstat:
 arch/powerpc/include/asm/stat.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
