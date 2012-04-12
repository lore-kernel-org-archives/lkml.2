Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2DLFJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:09:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40132 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2DLFJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:09:38 -0400
Date: Thu, 12 Apr 2012 06:09:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: vfs fixes
Message-ID: <20120412050937.GN6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression fix in mtdchar_open(), fix for a really old leak (almost never
hit in practice - it's a b0rken failure exit in simple_fill_super()) and a
typo fix in vfs.txt (misspelled method type).  Please, pull from the usual
place -
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (3):
      fix breakage in mtdchar_open(), sanitize failure exits
      dentry leak in simple_fill_super() failure exit
      typo fix in Documentation/filesystems/vfs.txt

Diffstat:
 Documentation/filesystems/vfs.txt |    2 +-
 drivers/mtd/mtdchar.c             |   20 ++++++++++----------
 fs/libfs.c                        |    1 +
 3 files changed, 12 insertions(+), 11 deletions(-)
