Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0L0OWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 09:22:32 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34131 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab0L0OWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 09:22:30 -0500
Date: Mon, 27 Dec 2010 23:20:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.37-rc8
Message-ID: <20101227142048.GA6555@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-fixes-for-linus

Which contains:

Paul Mundt (4):
      sh: Fix up SH4-202 clkfwk build.
      sh: mach-se: Fix up SE7206 build.
      sh: Fix up SH7201 clkfwk build.
      sh: intc: Initialize radix tree gfp mask explicitly.

 arch/sh/boards/mach-se/7206/irq.c      |    2 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7201.c |    2 +-
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c |    3 +--
 drivers/sh/intc/core.c                 |    1 +
 4 files changed, 4 insertions(+), 4 deletions(-)
