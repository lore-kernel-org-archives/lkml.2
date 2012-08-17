Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2HQOGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab2HQOF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:05:59 -0400
Subject: [GIT PULL] C6X atomic64 support
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 17 Aug 2012 10:05:56 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1345212358.2750.70.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to 01ddd9a809b9a95df097ff1b5565f806e681a606:

  C6X: select GENERIC_ATOMIC64 (2012-08-15 12:27:00 -0400)

----------------------------------------------------------------
Enable atomic64 ops in C6X

  - define L1_CACHE_SHIFT
  - select GENERIC_ATOMIC64

----------------------------------------------------------------
Mark Salter (2):
      C6X: add Lx_CACHE_SHIFT defines
      C6X: select GENERIC_ATOMIC64

 arch/c6x/Kconfig             |    1 +
 arch/c6x/include/asm/cache.h |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)


