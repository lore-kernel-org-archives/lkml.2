Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1E3F4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:56:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56994 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1E3F4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:56:11 -0400
Date: Mon, 30 May 2011 06:56:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        Sage Weil <sage@newdream.net>
Subject: [git pull] dentry_unhash() breakage
Message-ID: <20110530055601.GK11521@ZenIV.linux.org.uk>
References: <20110530020604.GC561@dastard>
 <20110530034741.GD561@dastard>
 <Pine.LNX.4.64.1105292057570.9134@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1105292057570.9134@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of dentry_unhash fallout fixes

Please, pull from usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Al Viro (1):
      autofs4: bogus dentry_unhash() added in ->unlink()

Sage Weil (1):
      vfs: shrink_dcache_parent before rmdir, dir rename

 fs/autofs4/root.c |    2 --
 fs/namei.c        |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)
