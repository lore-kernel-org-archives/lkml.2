Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2CLGer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:34:47 -0400
Received: from linux-sh.org ([111.68.239.195]:42365 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab2CLGej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:34:39 -0400
Date: Mon, 12 Mar 2012 15:34:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile fixes for 3.3-rc8
Message-ID: <20120312063433.GA5573@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 55062d061790b43aee01ab3f9ac57b8596254f19:

  x86: fix typo in recent find_vma_prev purge (2012-03-06 18:48:13 -0800)

are available in the git repository at:
  git://github.com/pmundt/linux-sh.git rmobile-for-linus

Kuninori Morimoto (1):
      ARM: mach-shmobile: ap4evb: fixup fsi2_ak4643_info typo

Laurent Pinchart (2):
      ARM: mach-shmobile: Fix ag5evm compilation by including linux/videodev2.h
      ARM: mach-shmobile: mackerel: Reserve DMA memory for the frame buffer

Phil Edworthy (1):
      ARM: mach-shmobile: Fix bonito compile breakage

 arch/arm/mach-shmobile/board-ag5evm.c   |    1 +
 arch/arm/mach-shmobile/board-ap4evb.c   |    2 +-
 arch/arm/mach-shmobile/board-bonito.c   |    3 ++-
 arch/arm/mach-shmobile/board-mackerel.c |    4 ++++
 4 files changed, 8 insertions(+), 2 deletions(-)
