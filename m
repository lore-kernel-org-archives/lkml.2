Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab1KVRoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:44:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51491 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1KVRoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:44:22 -0500
Date: Tue, 22 Nov 2011 17:44:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs fix
Message-ID: <20111122174419.GI2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Really embarrassing braino; kudos to jlayton for catching that one.
Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Al Viro (1):
      mount_subtree() pointless use-after-free

 fs/namespace.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

