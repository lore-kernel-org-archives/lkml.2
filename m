Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1A2QnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 11:43:01 -0500
Received: from smtp.nokia.com ([147.243.1.47]:36630 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab1A2QnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 11:43:00 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Holger Brunck <holger.brunck@keymile.com>,
        Anatolij Gustschin <agust@denx.de>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 29 Jan 2011 18:44:48 +0200
Message-Id: <20110129164448.22944.90815.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI fix for 2.6.38-rc2
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a fix for UBIFS backward compatibility breakage.
The fix consists of one revert and fixes the problem reported
here: http://lists.infradead.org/pipermail/linux-mtd/2011-January/033790.html

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git for-linus

Artem Bityutskiy (1):
      Revert "UBI: use mtd->writebufsize to set minimal I/O unit size"

 drivers/mtd/ubi/build.c |   28 +---------------------------
 1 files changed, 1 insertions(+), 27 deletions(-)

Thanks,
Artem.
