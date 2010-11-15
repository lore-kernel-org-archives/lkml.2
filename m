Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0KOGZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:25:46 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39290 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab0KOGZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:25:45 -0500
Date: Mon, 15 Nov 2010 15:25:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.37-rc2, part 2.
Message-ID: <20101115062512.GD8489@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing too interesting here, all trivial changes.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-fixes-for-linus

Which contains:

Axel Lin (1):
      rtc: rtc-sh - fix a memory leak

Paul Mundt (4):
      sh: intc: Fix up initializers for gcc 4.5.
      sh: clkfwk: fix up compiler warnings.
      MAINTAINERS: update the sh git tree entry.
      sh: intc: Fix up build failure introduced by radix tree changes.

 MAINTAINERS             |    2 +-
 drivers/rtc/rtc-sh.c    |    4 ++--
 drivers/sh/clk/core.c   |    4 ++--
 drivers/sh/intc/virq.c  |    2 +-
 include/linux/sh_intc.h |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)
