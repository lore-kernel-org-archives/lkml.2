Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab0LNKHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:07:10 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38856 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0LNKHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:07:07 -0500
Date: Tue, 14 Dec 2010 19:05:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.37-rc6
Message-ID: <20101214100547.GH14606@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not much of note here. A missing syscall for non-multiplexed socketcalls,
and we've temporarily re-enabled the deprecated IRQ chip APIs to give the
MFD and GPIO drivers a chance to catch up in .38 as requested by Mark Brown.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-fixes-for-linus

Which contains:

Carmelo AMOROSO (1):
      sh: wire up accept4 syscall (non-multiplexed path)

Paul Mundt (1):
      sh: Enable deprecated IRQ chip APIs for MFD and GPIOLIB drivers.

 arch/sh/Kconfig                 |    3 ++-
 arch/sh/include/asm/unistd_32.h |    3 ++-
 arch/sh/kernel/syscalls_32.S    |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)
