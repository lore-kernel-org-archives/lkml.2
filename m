Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab1HEAlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 20:41:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56669 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab1HEAlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 20:41:03 -0400
Date: Fri, 5 Aug 2011 01:41:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs stuff
Message-ID: <20110805004100.GP2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Rafael's fix + RCU freeing of posix_acl.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (2):
      get rid of boilerplate switches in posix_acl.h
      RCUify freeing acls, let check_acl() go ahead in RCU mode if acl is cached

Rafael J. Wysocki (1):
      fix block device fallout from ->fsync() changes

Diffstat:
 fs/block_dev.c            |    4 ++
 fs/namei.c                |   17 ++++-------
 include/linux/posix_acl.h |   74 ++++++++++++++++-----------------------------
 3 files changed, 36 insertions(+), 59 deletions(-)
