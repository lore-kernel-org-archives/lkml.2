Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab2HIEaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 00:30:25 -0400
Received: from linux-sh.org ([111.68.239.195]:51622 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab2HIEaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 00:30:24 -0400
Date: Thu, 9 Aug 2012 13:30:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.6-rc2
Message-ID: <20120809043021.GG1614@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f4ba394c1b02e7fc2179fda8d3941a5b3b65efb6:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-08-08 20:06:43 +0300)

are available in the git repository at:


  git://github.com/pmundt/linux-sh tags/sh-for-linus

for you to fetch changes up to fa75ce649ee2600b117631f8794e0e7dbedb1d68:

  Merge branches 'sh/urgent' and 'sh/gpiolib' into sh-latest (2012-08-09 13:21:13 +0900)

----------------------------------------------------------------

SuperH fixes for 3.6-rc2

----------------------------------------------------------------
Mike Frysinger (1):
      sh: dma: fix request_irq usage

Paul Mundt (2):
      sh: intc: Handle domain association for sparseirq pre-allocated vectors.
      Merge branches 'sh/urgent' and 'sh/gpiolib' into sh-latest

Phil Edworthy (1):
      sh: sh7269: Fix LCD pinmux

 arch/sh/drivers/dma/dma-sh.c            |   2 +-
 arch/sh/include/cpu-sh2a/cpu/sh7269.h   |  36 ++++--
 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c | 195 +++++++++++++++++++-------------
 drivers/sh/intc/core.c                  |  27 ++++-
 4 files changed, 165 insertions(+), 95 deletions(-)
