Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1IFDUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 23:20:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:2706 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab1IFDUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 23:20:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45517392"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 06 Sep 2011 06:22:36 +0300
Message-Id: <20110906032236.19050.6306.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS fixes for 3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a fix an UBIFS regression - we mistakingly linked debuggin messages
even when debugging was disabled.

The following changes since commit 93ee7a9340d64f20295aacc3fb6a22b759323280:

  Linux 3.1-rc2 (2011-08-14 15:09:08 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Michal Marek (1):
      UBIFS: not build debug messages with CONFIG_UBIFS_FS_DEBUG disabled

 fs/ubifs/debug.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Thanks,
Artem.
