Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2JPSLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:11:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51631 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2JPSLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:11:00 -0400
Date: Tue, 16 Oct 2012 19:10:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] several vfs patches
Message-ID: <20121016181059.GQ2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fix for my braino in replace_fd(), dhowell's fix for the fallout
from over-enthusiastic bo^Wdeclaration movements plus crapectomy that
should've happened a long time ago (SEL_... definitions).  Please, pull
from
git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (2):
      fix a leak in replace_fd() users
      bury SEL_{IN,OUT,EX}

David Howells (1):
      Unexport some bits of linux/fs.h

Diffstat:
 fs/coredump.c            |    5 +-
 include/linux/fs.h       |  126 +++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h  |  132 ----------------------------------------------
 security/selinux/hooks.c |   18 +++----
 4 files changed, 136 insertions(+), 145 deletions(-)

