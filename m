Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab2EWAk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:40:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59779 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab2EWAkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:40:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6719"; a="193718732"
Date: Tue, 22 May 2012 19:40:50 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [GIT PULL] Hexagon:  misc cleanup
Message-ID: <20120523004049.GA4269@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for the Hexagon architecture from: 

  git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.git for-linus

These are mostly cleanups and feedback remaining from the original
upstreaming.


Thanks,
Richard Kuo



------------------>
Jesper Juhl (1):
      Remove unneeded include of version.h from arch/hexagon/include/asm/spinlock_types.h

Julia Lawall (1):
      arch/hexagon/kernel/dma.c: make function static

Kautuk Consul (1):
      hexagon/mm/vm_fault.c: Port OOM changes to do_page_fault

Richard Kuo (1):
      various Kconfig cleanup and old platform build code removal

Thomas Meyer (1):
      Hexagon: Use resource_size function

 arch/hexagon/Kconfig                      |   21 ++++-----------------
 arch/hexagon/Makefile                     |    5 -----
 arch/hexagon/include/asm/spinlock_types.h |    2 --
 arch/hexagon/kernel/dma.c                 |    2 +-
 arch/hexagon/kernel/time.c                |    6 ++----
 arch/hexagon/mm/vm_fault.c                |   22 +++++++++++++++++-----
 6 files changed, 24 insertions(+), 34 deletions(-)


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
