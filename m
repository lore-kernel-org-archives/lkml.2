Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455Ab2AFQEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:04:34 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51543 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030367Ab2AFQEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:04:33 -0500
Date: Fri, 6 Jan 2012 16:04:18 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Kmemleak patches for 3.3-rc1
Message-ID: <20120106160417.GB3715@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the kmemleak branch below? Thanks.

The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux.git kmemleak

Catalin Marinas (4):
      kmemleak: Show where early_log issues come from
      kmemleak: When the early log buffer is exceeded, report the actual number
      kmemleak: Report previously found leaks even after an error
      kmemleak: Handle percpu memory allocation

Laura Abbott (1):
      kmemleak: Add support for memory hotplug

 Documentation/kmemleak.txt |    3 +
 include/linux/kmemleak.h   |    8 ++
 lib/Kconfig.debug          |    2 +-
 mm/kmemleak.c              |  158 ++++++++++++++++++++++++++++++++++++-------
 mm/percpu.c                |   12 +++-
 5 files changed, 155 insertions(+), 28 deletions(-)
