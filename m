Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab1F3HLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:11:11 -0400
Received: from linux-sh.org ([111.68.239.195]:40447 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1F3HLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:11:05 -0400
Date: Thu, 30 Jun 2011 16:10:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile fixes for 3.0-rc6
Message-ID: <20110630071058.GE22023@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-3.x.git rmobile-fixes-for-linus

Which contains:

Guennadi Liakhovetski (1):
      ARM: mach-shmobile: make a struct in board-ap4evb.c static

Kuninori Morimoto (1):
      ARM: mach-shmobile: mackerel: change usbhs devices order

Simon Horman (1):
      ARM: mach-shmobile: ag5evm: consistently name sdhi info structures

 arch/arm/mach-shmobile/board-ag5evm.c   |    4 ++--
 arch/arm/mach-shmobile/board-ap4evb.c   |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
