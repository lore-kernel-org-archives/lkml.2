Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab0GSMmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 08:42:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39630 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109Ab0GSMmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 08:42:51 -0400
Subject: [GIT PULL] kmemleak fixes for 2.6.35
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 19 Jul 2010 12:55:05 +0100
Message-ID: <1279540505.10760.8.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jul 2010 11:55:06.0316 (UTC) FILETIME=[3ACA80C0:01CB2739]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull two kmemleak fixes for 2.6.35? Thanks.

The following changes since commit 815c4163b6c8ebf8152f42b0a5fd015cfdcedc78:
  Linus Torvalds (1):
        Linux 2.6.35-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git kmemleak

Catalin Marinas (2):
      kmemleak: Annotate false positive in init_section_page_cgroup()
      kmemleak: Add support for NO_BOOTMEM configurations

 kernel/early_res.c |    6 ++++++
 mm/page_alloc.c    |    5 +++++
 mm/page_cgroup.c   |    7 +++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

-- 
Catalin

