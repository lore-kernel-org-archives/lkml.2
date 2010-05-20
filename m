Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0ETNuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 09:50:16 -0400
Received: from smtp.nokia.com ([192.100.122.230]:43986 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0ETNuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 09:50:13 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 20 May 2010 16:48:37 +0300
Message-Id: <20100520134837.3024.89757.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.35
X-OriginalArrivalTime: 20 May 2010 13:49:44.0330 (UTC) FILETIME=[4D9F26A0:01CAF823]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull the UBI tree:

The following changes since commit 01bf0b64579ead8a82e7cfc32ae44bc667e7ad0f:
  Linus Torvalds (1):
        Linux 2.6.34-rc5

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git linux-next

Kevin Cernekee (1):
      UBI: remove reboot notifier

Marc Kleine-Budde (1):
      UBI: init even if MTD device cannot be attached, if built into kernel

Shinya Kuribayashi (2):
      UBI: fix s/then/than/ typos
      UBI: misc comment fixes

 drivers/mtd/ubi/Kconfig |    2 +-
 drivers/mtd/ubi/build.c |   60 ++++++++++++++++++-----------------------------
 drivers/mtd/ubi/io.c    |    6 ++--
 drivers/mtd/ubi/kapi.c  |    6 ++--
 drivers/mtd/ubi/scan.c  |    4 +-
 drivers/mtd/ubi/ubi.h   |    2 -
 drivers/mtd/ubi/vtbl.c  |    4 +-
 drivers/mtd/ubi/wl.c    |    2 +-
 8 files changed, 35 insertions(+), 51 deletions(-)

Thanks,
Artem.
