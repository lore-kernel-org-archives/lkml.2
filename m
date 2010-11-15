Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0KOGZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:25:55 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39295 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab0KOGZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:25:47 -0500
Date: Mon, 15 Nov 2010 15:25:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile fixes for 2.6.37-rc2, part 2.
Message-ID: <20101115062515.GA24925@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More trivial bits..

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-fixes-for-linus

Which contains:

Kuninori Morimoto (1):
      ARM: mach-shmobile: ap4evb: add fsib 44100Hz rate

Paul Mundt (1):
      MAINTAINERS: update the ARM SH-Mobile git tree entry.

Tony SIM (1):
      ARM: mach-shmobile: intc-sh7372: fix interrupt number

Yusuke Goda (1):
      ARM: mach-shmobile: ap4evb: Mark NOR boot loader partitions read-only.

 MAINTAINERS                           |    2 +-
 arch/arm/mach-shmobile/board-ap4evb.c |    6 ++++++
 arch/arm/mach-shmobile/intc-sh7372.c  |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)
