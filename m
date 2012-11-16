Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2KPQOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:14:35 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51200 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2KPQOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:14:34 -0500
Date: Fri, 16 Nov 2012 16:14:29 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64: bug-fix for 3.7
Message-ID: <20121116161428.GG20103@arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Nov 2012 16:14:32.0344 (UTC) FILETIME=[76672180:01CDC415]
X-MC-Unique: 112111616143203601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the tag below for 3.7. Thank you.

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-fixes

for you to fetch changes up to 8e620b0476696e9428442d3551f3dad47df0e28f:

  arm64: Distinguish between user and kernel XN bits (2012-11-16 15:50:25 +0000)

----------------------------------------------------------------
AArch64 page permission bug fix. Without this fix, the CPU speculatively
accesses the interrupt controller memory causing random IRQ acknowledge.

----------------------------------------------------------------
Catalin Marinas (1):
      arm64: Distinguish between user and kernel XN bits

 arch/arm64/include/asm/io.h            |  2 +-
 arch/arm64/include/asm/pgtable-hwdef.h |  6 +++--
 arch/arm64/include/asm/pgtable.h       | 40 +++++++++++++++++-----------------
 3 files changed, 25 insertions(+), 23 deletions(-)

