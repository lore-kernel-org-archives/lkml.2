Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1C1QEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:04:45 -0400
Received: from ra.se.axis.com ([195.60.68.13]:51374 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1C1QEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:04:44 -0400
Date: Mon, 28 Mar 2011 18:04:41 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: [git pull] CRIS changes
Message-ID: <20110328160441.GA3976@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus!

Please pull the below repository, it contains some small changes
for CRIS specific rtc drivers (actually nuking the CRISv32 version)
and one fix for restarting syscalls on CRISv10.

Thanks!

The following changes since commit a44f99c7efdb88fa41128065c9a9445c19894e34:

  Merge branch 'trivial' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6 (2011-03-20 18:14:55 -0700)

are available in the git repository at:

  git://www.jni.nu/cris.git for-linus

Jesper Nilsson (3):
      Drop the CRISv32 version of pcf8563
      CRISv10: Fix return before mutex_unlock in pcf8563
      Correct auto-restart of syscalls via restartblock

 arch/cris/Kconfig                    |    3 +-
 arch/cris/arch-v10/drivers/pcf8563.c |    2 +-
 arch/cris/arch-v10/kernel/signal.c   |    2 +-
 arch/cris/arch-v32/drivers/Makefile  |    1 -
 arch/cris/arch-v32/drivers/pcf8563.c |  377 ----------------------------------
 5 files changed, 3 insertions(+), 382 deletions(-)
 delete mode 100644 arch/cris/arch-v32/drivers/pcf8563.c

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
