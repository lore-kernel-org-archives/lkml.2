Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2BCQBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:01:45 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61381 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756822Ab2BCQBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:01:44 -0500
Date: Fri, 3 Feb 2012 16:01:36 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Kmemleak fixes for 3.3
Message-ID: <20120203160136.GA16222@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the tag below, it has two kmemleak fixes found
recently. Thank you.

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux.git kmemleak-fixes

for you to fetch changes up to b370d29ea7565a638ccf85389488364b5abb39fa:

  kmemleak: Disable early logging when kmemleak is off by default (2012-01-20 16:57:05 +0000)

----------------------------------------------------------------
Trivial kmemleak bug-fixes:

- Early logging doesn't stop when kmemleak is off by default.
- Zero-size scanning areas should be ignored (currently it prints a warning).

----------------------------------------------------------------
Catalin Marinas (1):
      kmemleak: Disable early logging when kmemleak is off by default

Tiejun Chen (1):
      kmemleak: Only scan non-zero-size areas

 mm/kmemleak.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
Catalin
