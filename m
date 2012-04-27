Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab2D0CKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 22:10:38 -0400
Received: from linux-sh.org ([111.68.239.195]:60127 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840Ab2D0CKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 22:10:36 -0400
Date: Fri, 27 Apr 2012 11:10:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 3.4-rc5
Message-ID: <20120427021031.GB7988@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 82b769063598d01a8b24abf250a53f8b437e09f1:

  Merge branch 'stable' of git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2012-04-26 15:36:27 -0700)

are available in the git repository at:

  git://github.com/pmundt/linux-sh.git sh-for-linus

Nobuhiro Iwamatsu (1):
      sh: Fix up tracepoint build fallout from static key introduction.

Paul Mundt (2):
      Merge branch 'sh/st-integration' into sh/urgent
      Merge branch 'sh/urgent' into sh-fixes-for-linus

Stuart Menefy (1):
      sh: Fix error synchronising kernel page tables

 arch/sh/include/asm/atomic.h |    2 +-
 arch/sh/mm/fault_32.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
