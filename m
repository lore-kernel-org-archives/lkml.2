Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab1CDInQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:43:16 -0500
Received: from linux-sh.org ([111.68.239.195]:44926 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1CDInP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:43:15 -0500
Date: Fri, 4 Mar 2011 17:09:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.38-rc8
Message-ID: <20110304080919.GC13621@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-fixes-for-linus

Which contains:

Francesco Virlinzi (1):
      sh: Change __nosave_XXX symbols to long

Nobuhiro Iwamatsu (2):
      sh: sh7750: move machtypes.h to include/generated
      sh: sh7750: Fix incompatible pointer type

Stuart Menefy (2):
      sh: Ensure ST40-300 BogoMIPS value is consistent
      sh: Flush executable pages in copy_user_highpage

 arch/sh/include/asm/sections.h        |    2 +-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c |   13 +++++++++----
 arch/sh/lib/delay.c                   |   10 ++++++++++
 arch/sh/mm/cache.c                    |    3 ++-
 4 files changed, 22 insertions(+), 6 deletions(-)
