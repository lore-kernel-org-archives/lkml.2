Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab2GLE0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 00:26:50 -0400
Received: from linux-sh.org ([111.68.239.195]:60600 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2GLE0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 00:26:49 -0400
Date: Thu, 12 Jul 2012 13:26:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 3.5-rc7
Message-ID: <20120712042646.GC16064@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ca24a145573124732152daff105ba68cc9a2b545:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2012-07-01 11:02:25 -0700)

are available in the git repository at:


  git://github.com/pmundt/linux-sh.git tags/sh-for-linus

for you to fetch changes up to 44033109e99cf584d6285226ed521098f5ef7250:

  SH: Convert out[bwl] macros to inline functions (2012-07-12 13:12:13 +0900)

----------------------------------------------------------------
SuperH fixes for 3.5-rc7

----------------------------------------------------------------
Corey Minyard (1):
      SH: Convert out[bwl] macros to inline functions

Paul Mundt (1):
      sh: Fix up se7721 GPIOLIB=y build warnings.

 arch/sh/include/asm/io_noioport.h      | 17 ++++++++++++++---
 arch/sh/kernel/cpu/sh3/serial-sh7720.c |  2 +-
 2 files changed, 15 insertions(+), 4 deletions(-)
