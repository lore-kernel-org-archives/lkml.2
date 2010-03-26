Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0CZQxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:53:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44721 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0CZQxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:53:53 -0400
Date: Fri, 26 Mar 2010 16:53:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] LOOKUP_DIRECTORY fix
Message-ID: <20100326165351.GE30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Restore LOOKUP_DIRECTORY handling in case of open() with
O_DIRECTORY.  While filesystems shouldn't have require O_DIRECTORY
for directory lookup to succeed, they have legitimate case for
knowing that flag had been there - it's a useful hint.

	git breakage on NFSv4 in -rc1/-rc2 should be fixed by that.
Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (1):
      Restore LOOKUP_DIRECTORY hint handling in final lookup on open()

Diffstat:
 fs/namei.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

