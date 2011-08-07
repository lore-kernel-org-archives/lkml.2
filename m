Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1HGIzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 04:55:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59295 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1HGIzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 04:55:01 -0400
Date: Sun, 7 Aug 2011 09:54:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs fix
Message-ID: <20110807085459.GX2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to remove MAY_NOT_BLOCK from mask when we started to call
posix_acl_permission() on RCU path.  Ari has caught and fixed that.
Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Ari Savolainen (1):
      Fix POSIX ACL permission check

Diffstat:
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

