Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1JYPqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:46:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50732 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab1JYPqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:46:06 -0400
Date: Tue, 25 Oct 2011 16:45:57 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Kmemleak patches
Message-ID: <20111025154557.GA17784@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the four kmemleak patches on the branch below?
Thanks.

The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux kmemleak

Catalin Marinas (4):
      kmemleak: Show where early_log issues come from
      kmemleak: When the early log buffer is exceeded, report the actual number
      kmemleak: Report previously found leaks even after an error
      kmemleak: Handle percpu memory allocation

 Documentation/kmemleak.txt |    3 +
 include/linux/kmemleak.h   |    8 ++
 mm/kmemleak.c              |  152 +++++++++++++++++++++++++++++++++++++-------
 mm/percpu.c                |   12 +++-
 4 files changed, 150 insertions(+), 25 deletions(-)

-- 
Catalin
