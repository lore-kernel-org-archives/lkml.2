Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2GPB7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 21:59:55 -0400
Received: from tundra.namei.org ([65.99.196.166]:58386 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab2GPB7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 21:59:52 -0400
Date: Mon, 16 Jul 2012 11:59:49 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [GIT] Fix SELinux regression
Message-ID: <alpine.LRH.2.02.1207161158290.22772@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now with the correct patches and signoffs.

Please pull.

The following changes since commit 918227bb1b59444a2c467711fd50cc22bb4a897b:
  Linus Torvalds (1):
        Merge tag 'fbdev-fixes-for-3.5-2' of git://github.com/schandinat/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Eric Paris (2):
      SELinux: include definition of new capabilities
      SELinux: do not check open perms if they are not known to policy

 security/selinux/hooks.c            |    2 +-
 security/selinux/include/classmap.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)


