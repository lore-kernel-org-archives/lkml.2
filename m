Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab0LCN5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:57:23 -0500
Received: from smtp.nokia.com ([147.243.128.26]:59210 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0LCN5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:57:22 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Dec 2010 15:57:49 +0200
Message-Id: <20101203135749.28810.71964.sendpatchset@localhost.localdomain>
Subject: [GIT PULL N2] UBI fixes for 2.6.37-rc
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull another UBI fix for 2.6.37-rcX.

The following changes since commit e8a7e48bb248a1196484d3f8afa53bded2b24e71:

  Linux 2.6.37-rc4 (2010-11-29 20:42:04 -0800)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (1):
      UBI: fix corrupted PEB detection for NOR flash

 drivers/mtd/ubi/io.c   |   37 +++++++++++++++++++++++++------------
 drivers/mtd/ubi/scan.c |    4 ++++
 2 files changed, 29 insertions(+), 12 deletions(-)

Thanks,
Artem.
