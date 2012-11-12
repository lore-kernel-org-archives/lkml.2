Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2KLN0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:26:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab2KLN0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:26:22 -0500
Date: Mon, 12 Nov 2012 14:26:20 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bpoirier@suse.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] menuconfig portability fix
Message-ID: <20121112132620.GA16743@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a fix for v3.7 that makes menuconfig compile again on systems
whose C library is lacking CIRCLEQ_* macros. I thought I sent it
earlier, but apparently I did not.

Michal

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

for you to fetch changes up to bad9955db1b73d7286f74a8136a0628a9b1ac017:

  menuconfig: Replace CIRCLEQ by list_head-style lists. (2012-10-25 15:06:00 +0200)

----------------------------------------------------------------
Benjamin Poirier (1):
      menuconfig: Replace CIRCLEQ by list_head-style lists.

 scripts/kconfig/expr.h      |    5 +--
 scripts/kconfig/list.h      |   91 +++++++++++++++++++++++++++++++++++++++++++
 scripts/kconfig/lkc_proto.h |    4 +-
 scripts/kconfig/mconf.c     |    6 +--
 scripts/kconfig/menu.c      |   14 ++++---
 5 files changed, 106 insertions(+), 14 deletions(-)
 create mode 100644 scripts/kconfig/list.h
