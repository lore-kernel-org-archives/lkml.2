Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab1IFDUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 23:20:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:4296 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1IFDUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 23:20:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,336,1312182000"; 
   d="scan'208";a="48361910"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 06 Sep 2011 06:22:43 +0300
Message-Id: <20110906032243.19063.19293.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI fixes for 3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a fix an UBI regression - we mistakingly linked debuggin messages
even when debugging was disabled.

The following changes since commit 93ee7a9340d64f20295aacc3fb6a22b759323280:

  Linux 3.1-rc2 (2011-08-14 15:09:08 -0700)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (1):
      UBI: do not link debug messages when debugging is disabled

 drivers/mtd/ubi/debug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Thanks,
Artem.
