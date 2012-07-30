Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2G3Ggy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:36:54 -0400
Received: from tundra.namei.org ([65.99.196.166]:43270 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2G3Ggw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:36:52 -0400
Date: Mon, 30 Jul 2012 16:36:51 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] security subsystem bugfixes
Message-ID: <alpine.LRH.2.02.1207301635540.16928@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these fixes for your curren tree.

The following changes since commit f7da9cdf45cbbad5029d4858dcbc0134e06084ed:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Al Viro (1):
      selinux: fix selinux_inode_setxattr oops

Alan Cox (1):
      smack: off by one error

David Howells (1):
      KEYS: linux/key-type.h needs linux/errno.h

 include/linux/key-type.h |    1 +
 security/selinux/hooks.c |   15 ++++++++++-----
 security/smack/smackfs.c |    8 ++++----
 3 files changed, 15 insertions(+), 9 deletions(-)
