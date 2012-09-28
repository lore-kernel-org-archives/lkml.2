Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2I1Dkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:40:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48888 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2I1Dkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:40:46 -0400
Date: Fri, 28 Sep 2012 04:40:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull][vfs.git] a couple of fixes
Message-ID: <20120928034044.GD13973@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	A couple of fixes; one for automount/lazy umount race, another
a classic "we don't protect the refcount transition to zero with the
lock that protects looking for object in hash" kind of crap in lockd.
Please, pull.  The usual place -
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (2):
      do_add_mount()/umount -l races
      close the race in nlmsvc_free_block()

Diffstat:
 fs/lockd/svclock.c |    3 +--
 fs/namespace.c     |   10 ++++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)
